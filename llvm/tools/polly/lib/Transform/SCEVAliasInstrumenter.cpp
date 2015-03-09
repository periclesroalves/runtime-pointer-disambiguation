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

Value *SCEVAliasInstrumenter::insertDynamicChecks(
                            AliasInstrumentationContext &context) {
  auto region = context.region;

  // Create an entering block to receive the checks.
  simplifyRegion(region);

  // Set instruction insertion context. We'll insert the run-time tests in the
  // region entering block.
  Instruction *insertPt = region->getEnteringBlock()->getTerminator();
  BuilderType builder(se->getContext(), TargetFolder(se->getDataLayout()));
  builder.SetInsertPoint(insertPt);

  SCEVRangeBuilder scevRange(se, aa, li, dt, region, insertPt);
  scevRange.setArtificialBECounts(context.getBECountsMap());

  RangeCheckBuilder    rangeChecks{scevRange, builder, context};
  HeapCheckBuilder     heapChecks{builder, region->getEnteringBlock(), nullptr};
  EqualityCheckBuilder eqChecks{builder};

  // *** insert checks

  Value *result = builder.getTrue();

  // Insert comparison expressions for every pair of pointers that need to be
  // checked in the region.
  for (auto& pair : context.ptrPairsToCheck) {
    auto basePtr1 = pair.first;
    auto basePtr2 = pair.second;

    Value *check;

    switch (saa->speculativeAlias(basePtr1, basePtr2)) {
      // TODO: implement heap checks
      case SpeculativeAliasResult::NoHeapAlias:
        check = heapChecks.buildCheck(basePtr1, basePtr2);
        break;
      case SpeculativeAliasResult::ExactAlias:
        check = eqChecks.buildCheck(basePtr1, basePtr2);
        break;
      // TODO: decide which check to use for these cases
      case SpeculativeAliasResult::NoAlias:
      case SpeculativeAliasResult::DontKnow:
      // TODO: don't insert checks for these cases
      case SpeculativeAliasResult::ProbablyAlias:
      case SpeculativeAliasResult::NoRangeOverlap:
        check = rangeChecks.buildRangeCheck(basePtr1, basePtr2);
        break;
    }

    result = builder.CreateAnd(result, check);
  }

  // Also, if we hoisted loop bound loads, insert tests to guarantee that no
  // store in the region alises the hoisted loads.
  for (auto &pair : context.artificialBECounts) {
    for (auto &storeTarget : context.storeTargets) {
      auto check = rangeChecks.buildLocationCheck(storeTarget, pair.second.addr);

      result = builder.CreateAnd(result, check);
    }
  }

  return result;
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
