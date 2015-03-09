//===------------- SCEVAliasInstrumenter.cpp --------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/StringExtras.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/TypeBuilder.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

#include "polly/SCEVAliasInstrumenter.h"
#include "polly/SpeculativeAliasAnalysis.h"
#include "polly/LinkAllPasses.h"
#include "polly/ScopDetection.h"
#include "polly/Support/ScopHelper.h"
#include "polly/CloneRegion.h"
#include "polly/CodeGen/BlockGenerators.h"
#include "polly/Support/SCEVValidator.h"

using namespace llvm;
using namespace polly;

#define DEBUG_TYPE "polly-alias-instrumenter"

template<typename T>
std::pair<T,T> make_ordered_pair(const T& t1, const T& t2) {
  return (t1 < t2) ? std::make_pair(t1,t2) : std::make_pair(t2,t1);
}

void SCEVAliasInstrumenter::fixAliasInfo(AliasInstrumentationContext &ctx) {
  auto& memAccesses = ctx.memAccesses;

  MDBuilder MDB(currFn->getContext());
  if (!mdDomain)
    mdDomain = MDB.createAnonymousAliasScopeDomain(currFn->getName());
  DenseMap<const Value *, MDNode *> scopes;
  unsigned ptrCount = 0;

  // Create a different alias scope for each base pointer in the region.
  for (auto pair : memAccesses) {
    const Value *basePointer = pair.first;
    std::string name = currFn->getName();

    name += (basePointer->hasName()) ? (": %" + basePointer->getName().str()) :
      (": ptr " + utostr(ptrCount++));
    MDNode *scope = MDB.createAnonymousAliasScope(mdDomain, name);
    scopes.insert(std::make_pair(basePointer, scope));
  }

  // Set the actual scoped alias tags for each memory instruction in the region.
  // A memory instruction always aliases its base pointer and never aliases
  // other pointers in the region.
  for (auto pair : memAccesses) {
    const Value *basePointer = pair.first;

    // Set the alias metadata for each memory access instruction in the region.
    for (auto memInst : pair.second.users) {
      // A memory instruction always aliases its base pointer.
      memInst->setMetadata(LLVMContext::MD_alias_scope, MDNode::concatenate(
        memInst->getMetadata(LLVMContext::MD_alias_scope),
          MDNode::get(currFn->getContext(), scopes[basePointer])));

      // The instruction never aliases other pointers in the region.
      for (auto otherPair : memAccesses) {
        const Value *otherBasePointer = otherPair.first;

        // Slip the instruction's own base pointer.
        if (otherBasePointer == basePointer)
          continue;

        memInst->setMetadata(LLVMContext::MD_noalias, MDNode::concatenate(
          memInst->getMetadata(LLVMContext::MD_noalias),
            MDNode::get(currFn->getContext(), scopes[otherBasePointer])));
      }
    }
  }
}

void SCEVAliasInstrumenter::simplifyRegion(Region *r) {
  BasicBlock *entering = r->getEnteringBlock();

  // Create a new entering block to host the checks. If an entering block
  // already exists, just reuse it. If not, create one from the region entry.
  if (entering && (entering != &(entering->getParent()->getEntryBlock()))) {
    SplitBlock(entering, entering->getTerminator(), li);
  } else {
    BasicBlock *entry = r->getEntry();
    r->replaceEntryRecursive(SplitBlock(entry, entry->begin(), li));
  }

  // Create exiting block.
  if (!r->getExitingBlock()) {
    BasicBlock *newExit = createSingleExitEdge(r, li);

    for (auto &&subRegion : *r)
      subRegion->replaceExitRecursive(newExit);
  }
}

void SCEVAliasInstrumenter::buildNoAliasClone(AliasInstrumentationContext &context,
                                              Value *checkResult) {
  if (!checkResult)
    return;

  Region *region       = context.region;
  Region *clonedRegion = cloneRegion(region, nullptr, ri, dt, df);

  // Build the conditional brach based on the dynamic test result.
  Instruction *br = &region->getEnteringBlock()->back();
  BuilderType builder(se->getContext(), TargetFolder(se->getDataLayout()));
  builder.SetInsertPoint(br);
  builder.CreateCondBr(checkResult, region->getEntry(), clonedRegion->getEntry());
  br->eraseFromParent();

  // Replace original loop bound loads by hoisted loads in the region, which is
  // now guarded against true aliasing.
  for (auto &pair : context.artificialBECounts) {
    pair.second.oldLoad->replaceAllUsesWith(pair.second.hoistedLoad);
    pair.second.oldLoad->eraseFromParent();
  }

  // Mark the cloned region as free of dependencies.
  fixAliasInfo(context);
}

Value *SCEVAliasInstrumenter::chainChecks(std::vector<Value *> checks,
                                          BuilderType &builder) {
  if (checks.size() < 1)
    return nullptr;

  Value *rhs = checks[0];

  for (std::vector<Value *>::size_type i = 1; i != checks.size(); i++) {
    rhs = builder.CreateAnd(checks[i], rhs, "region-no-alias");
  }

  return rhs;
}

Value *SCEVAliasInstrumenter::buildRangeCheck(
                              std::pair<Value *, Value *> boundsA,
                              std::pair<Value *, Value *> boundsB,
                              BuilderType &builder,
                              SCEVRangeBuilder &rangeBuilder) {
  // Cast all bounds to i8* (equivalent to void*, according to the LLVM manual).
  Type *i8PtrTy = builder.getInt8PtrTy();
  Value *lowerA = rangeBuilder.InsertNoopCastOfTo(boundsA.first, i8PtrTy);
  Value *upperA = rangeBuilder.InsertNoopCastOfTo(boundsA.second, i8PtrTy);
  Value *lowerB = rangeBuilder.InsertNoopCastOfTo(boundsB.first, i8PtrTy);
  Value *upperB = rangeBuilder.InsertNoopCastOfTo(boundsB.second, i8PtrTy);

  // Build actual interval comparisons.
  Value *aIsBeforeB = builder.CreateICmpULT(upperA, lowerB);
  Value *bIsBeforeA = builder.CreateICmpULT(upperB, lowerA);

  Value *check = builder.CreateOr(aIsBeforeB, bIsBeforeA, "pair-no-alias");

  return check;
}

Value *SCEVAliasInstrumenter::buildRangeCheck(std::pair<Value *, Value *>
                                    boundsA, Value *addrB, BuilderType &builder,
                                    SCEVRangeBuilder &rangeBuilder) {
  // Cast all bounds to i8* (equivalent to void*, according to the LLVM manual).
  Type *i8PtrTy = builder.getInt8PtrTy();
  Value *lowerA = rangeBuilder.InsertNoopCastOfTo(boundsA.first, i8PtrTy);
  Value *upperA = rangeBuilder.InsertNoopCastOfTo(boundsA.second, i8PtrTy);
  Value *locB = rangeBuilder.InsertNoopCastOfTo(addrB, i8PtrTy);

  // Build actual interval comparisons.
  Value *aIsBeforeB = builder.CreateICmpULT(upperA, locB);
  Value *bIsBeforeA = builder.CreateICmpULT(locB, lowerA);

  Value *check = builder.CreateOr(aIsBeforeB, bIsBeforeA, "loc-no-alias");

  return check;
}

void SCEVAliasInstrumenter::buildSCEVBounds(AliasInstrumentationContext &context,
                                            SCEVRangeBuilder &rangeBuilder) {
  // Compute access bounds for each base pointer in the region.
  for (auto& pair : context.memAccesses) {
    auto& accessFunctions = pair.second.accessFunctions;

    Value *low = rangeBuilder.getULowerBound(accessFunctions);
    Value *up = rangeBuilder.getUUpperBound(accessFunctions);

    assert((low && up) &&
      "All access expressions should have computable SCEV bounds by now");

    context.pointerBounds[pair.first] = std::make_pair(low, up);
  }
}

Value *SCEVAliasInstrumenter::insertDynamicChecks(
                            AliasInstrumentationContext &context) {
  auto region = context.region;

  // Create an entering block to receive the checks.
  simplifyRegion(region);

  // Set instruction insertion context. We'll insert the run-time tests in the
  // region entering block.
  Instruction *insertPt = region->getEnteringBlock()->getTerminator();
  SCEVRangeBuilder rangeBuilder(se, aa, li, dt, region, insertPt);
  rangeBuilder.setArtificialBECounts(context.getBECountsMap());
  BuilderType builder(se->getContext(), TargetFolder(se->getDataLayout()));
  builder.SetInsertPoint(insertPt);

  buildSCEVBounds(context, rangeBuilder);

  std::vector<Value *> pairChecks;

  // Insert comparison expressions for every pair of pointers that need to be
  // checked in the region.
  for (auto& pair : context.ptrPairsToCheck) {
    assert(context.pointerBounds.count(pair.first) &&
           context.pointerBounds.count(pair.second) &&
           "SCEV bounds should be available at this point.");

    auto check = buildRangeCheck(context.pointerBounds[pair.first],
                                 context.pointerBounds[pair.second],
                                 builder, rangeBuilder);
    pairChecks.push_back(check);
  }

  // Also, if we hoisted loop bound loads, insert tests to guarantee that no
  // store in the region alises the hoisted loads.
  for (auto &pair : context.artificialBECounts) {
    for (auto &storeTarget : context.storeTargets) {
      auto check = buildRangeCheck(context.pointerBounds[storeTarget],
                                   pair.second.addr, builder, rangeBuilder);
      pairChecks.push_back(check);
    }
  }

  // Combine all checks into a single boolean result using AND.
  return chainChecks(pairChecks, builder);
}

bool SCEVAliasInstrumenter::runOnFunction(llvm::Function &F) {
  // Collect all analyses needed for runtime check generation.
  li = &getAnalysis<LoopInfo>();
  ri = &getAnalysis<RegionInfoPass>().getRegionInfo();
  aa = &getAnalysis<AliasAnalysis>();
  saa = &getAnalysis<SpeculativeAliasAnalysis>();
  se = &getAnalysis<ScalarEvolution>();
  dt = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  pdt = &getAnalysis<PostDominatorTree>();
  df = &getAnalysis<DominanceFrontier>();

  currFn = &F;
  Region *topRegion = ri->getTopLevelRegion();

  releaseMemory();
  findAliasInstrumentableRegions(
    topRegion,
    se, aa, li, dt, pdt, df,
    targetRegions
  );

  // Instrument and clone each target region.
  for (auto context : targetRegions) {
    auto checkResult = insertDynamicChecks(context);
    buildNoAliasClone(context, checkResult);
  }

  return true;
}

void SCEVAliasInstrumenter::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.addRequired<DominatorTreeWrapperPass>();
  AU.addRequired<PostDominatorTree>();
  AU.addRequired<DominanceFrontier>();
  AU.addRequired<LoopInfo>();
  AU.addRequired<ScalarEvolution>();
  AU.addRequired<AliasAnalysis>();
  AU.addRequired<SpeculativeAliasAnalysis>();
  AU.addRequired<RegionInfoPass>();

  // Changing the CFG like we do doesn't preserve anything.
  AU.addPreserved<AliasAnalysis>();
}

char SCEVAliasInstrumenter::ID = 0;

Pass *polly::createSCEVAliasInstrumenterPass() {
  return new SCEVAliasInstrumenter();
}

INITIALIZE_PASS_BEGIN(SCEVAliasInstrumenter, "polly-scev-checks",
                      "Polly - Instrument alias dependencies", false,
                      false);
INITIALIZE_AG_DEPENDENCY(AliasAnalysis);
INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass);
INITIALIZE_PASS_DEPENDENCY(LoopInfo);
INITIALIZE_PASS_DEPENDENCY(PostDominatorTree);
INITIALIZE_PASS_DEPENDENCY(DominanceFrontier);
INITIALIZE_PASS_DEPENDENCY(RegionInfoPass);
INITIALIZE_PASS_DEPENDENCY(ScalarEvolution);
INITIALIZE_PASS_END(SCEVAliasInstrumenter, "polly-scev-checks",
                    "Polly - Instrument alias dependencies", false, false) 
