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
#include "llvm/Support/CommandLine.h"

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
  const auto& memAccesses = ctx.memAccesses;

  MDBuilder MDB(currFn->getContext());
  if (!mdDomain)
    mdDomain = MDB.createAnonymousAliasScopeDomain(currFn->getName());
  DenseMap<const Value *, MDNode *> scopes;
  unsigned ptrCount = 0;

  // Create a different alias scope for each base pointer in the region.
  for (const auto& pair : memAccesses) {
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
  for (const auto& pair : memAccesses) {
    const Value *basePointer = pair.first;

    // Set the alias metadata for each memory access instruction in the region.
    for (auto memInst : pair.second.users) {
      // Check that the instruction was not removed from the region.
      if (!memInst->getParent())
        continue;

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

void SCEVAliasInstrumenter::buildNoAliasClone(AliasInstrumentationContext &context) {
  Region *region = context.region;

  switch (PollyAliasInstrumenterMode) {
    case InstrumentAndClone: {
      auto checkResult = insertDynamicChecks(context);

      if (!checkResult)
        return;

      auto* br           = region->getEnteringBlock()->getTerminator();
      auto* clonedRegion = cloneRegion(region, nullptr, ri, dt, df);

      // Build the conditional brach based on the dynamic test result.
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

      // Mark the original region as free of dependencies.
      fixAliasInfo(context);
      break;
    }
    case MeasureCheckCosts: {
      auto checkResult = insertDynamicChecks(context);

      if (!checkResult)
        return;

      GlobalValue *blackhole = defineBlackhole();

      IRBuilder<> irb(region->getEnteringBlock()->getTerminator());
      irb.CreateStore(checkResult, blackhole);
      break;
    }
    case MeasureCheckCostsBaseline: {
      auto checkResult = insertDynamicChecks(context);
      assert(!checkResult);

      GlobalValue *blackhole = defineBlackhole();

      IRBuilder<> irb(region->getEnteringBlock()->getTerminator());
      irb.CreateStore(irb.getFalse(), blackhole);
      break;
    }
    case CountScops: {
      // Mark the original region as free of dependencies.
      fixAliasInfo(context);
      break;
    }
  }
}

Value *SCEVAliasInstrumenter::insertDynamicChecks(
                            AliasInstrumentationContext &context) {

  auto region = context.region;

  // Create an entering block to receive the checks.
  simplifyRegion(region, this);

  if (PollyAliasInstrumenterMode == MeasureCheckCostsBaseline)
    return nullptr;

  // Set instruction insertion context. We'll insert the run-time tests in the
  // region entering block.
  Instruction *insertPt = region->getEnteringBlock()->getTerminator();
  BuilderType builder(se->getContext(), TargetFolder(se->getDataLayout()));
  builder.SetInsertPoint(insertPt);

  SCEVRangeBuilder scevRange(se, aa, li, dt, region, insertPt);
  scevRange.setArtificialBECounts(context.getBECountsMap());

  RangeCheckBuilder    rangeChecks{scevRange, builder, context};
  HeapCheckBuilder     heapChecks{builder, region->getEnteringBlock(), getPtrId};
  EqualityCheckBuilder eqChecks{builder};

  // *** insert checks

  Value *result = nullptr;

  // Insert comparison expressions for every pair of pointers that need to be
  // checked in the region.
  for (auto& pair : context.scevChecks.ptrPairsToCheck) {
    assert(flags.UseSCEVAliasChecks);

    auto basePtr1 = pair.first;
    auto basePtr2 = pair.second;

    auto *check = rangeChecks.buildRangeCheck(basePtr1, basePtr2);

    result = result ? builder.CreateAnd(result, check) : check;
  }
  for (auto& pair : context.heapChecks.ptrPairsToCheck) {
    assert(flags.UseHeapAliasChecks);

    auto basePtr1 = pair.first;
    auto basePtr2 = pair.second;

    auto *check = heapChecks.buildCheck(basePtr1, basePtr2);

    result = result ? builder.CreateAnd(result, check) : check;
  }

  // Also, if we hoisted loop bound loads, insert tests to guarantee that no
  // store in the region alises the hoisted loads.
  for (auto &pair : context.artificialBECounts) {
    for (auto &storeTarget : context.scevChecks.storeTargets) {
      auto check = rangeChecks.buildLocationCheck(storeTarget, pair.second.addr);

      result = result ? builder.CreateAnd(result, check) : check;
    }
    for (auto &storeTarget : context.heapChecks.storeTargets) {
      auto check = heapChecks.buildCheck(storeTarget, pair.second.addr);

      result = result ? builder.CreateAnd(result, check) : check;
    }
  }

  return result;
}

GlobalVariable *SCEVAliasInstrumenter::defineBlackhole() {
  static const char *const name = "__alias_check_blackhole";

  auto *mod = currFn->getParent();
  auto &ctx = currFn->getContext();

  GlobalVariable *blackhole = mod->getGlobalVariable(name);

  if (!blackhole) {
    blackhole = new GlobalVariable(
      *mod,
      IntegerType::get(ctx, 1),
      /*isConstant=*/false,
      GlobalValue::LinkOnceAnyLinkage,
      ConstantInt::get(ctx, APInt(1, 0)),
      name
    );
    blackhole->setAlignment(1);
  }

  return blackhole;
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

  // Set of regions that will be instrumented.
  std::vector<std::unique_ptr<AliasInstrumentationContext>> targetRegions;

  findAliasInstrumentableRegions(
    topRegion,
    se, aa, saa, li, dt,
    flags,
    targetRegions
  );

  bool changed = !targetRegions.empty();

  // Instrument and clone each target region.
  for (auto& context : targetRegions) {
    buildNoAliasClone(*context);
  }

  return changed;
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

bool SCEVAliasInstrumenter::doInitialization(Module& M) {
  LLVMContext& ctx = M.getContext();

  // ** declare external gcg_getBasePtr function

  Type *void_ptr_type = Type::getInt8PtrTy(ctx);

  Type *return_type = void_ptr_type;

  std::vector<Type*> parameter_types{
    void_ptr_type
  };

  getPtrId = Function::Create(
    FunctionType::get(return_type, parameter_types, false),
    GlobalValue::ExternalLinkage,
    "gcg_getBasePtr",
    &M
  );

  getPtrId->addAttribute(1, Attribute::ReadOnly);
  getPtrId->addAttribute(1, Attribute::NoCapture);

  return true;
}

char SCEVAliasInstrumenter::ID = 0;

Pass *polly::createSCEVAliasInstrumenterPass() {
  return new SCEVAliasInstrumenter();
}
Pass *polly::createSCEVAliasInstrumenterPass(const AliasCheckFlags& flags) {
  return new SCEVAliasInstrumenter(flags);
}

INITIALIZE_PASS_BEGIN(SCEVAliasInstrumenter, "polly-scev-checks",
                      "Polly - Instrument alias dependencies", false,
                      false);
INITIALIZE_AG_DEPENDENCY(AliasAnalysis);
INITIALIZE_AG_DEPENDENCY(SpeculativeAliasAnalysis);
INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass);
INITIALIZE_PASS_DEPENDENCY(LoopInfo);
INITIALIZE_PASS_DEPENDENCY(PostDominatorTree);
INITIALIZE_PASS_DEPENDENCY(DominanceFrontier);
INITIALIZE_PASS_DEPENDENCY(RegionInfoPass);
INITIALIZE_PASS_DEPENDENCY(ScalarEvolution);
INITIALIZE_PASS_END(SCEVAliasInstrumenter, "polly-scev-checks",
                    "Polly - Instrument alias dependencies", false, false)
