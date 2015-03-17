//===------------------------------------------------------------*- C++ -*-===//
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
#include "llvm/Analysis/RegionInfo.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/TypeBuilder.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include <llvm/Analysis/DominanceFrontier.h>
#include <llvm/Support/CorseCommon.h>

#include "polly/RegionAliasInfo.h"
#include "polly/SpeculativeAliasAnalysis.h"
#include "polly/LinkAllPasses.h"
#include "polly/ScopDetection.h"
#include "polly/Support/ScopHelper.h"
#include "polly/CloneRegion.h"
#include "polly/CodeGen/BlockGenerators.h"
#include "polly/SCEVRangeBuilder.h"
#include "polly/Support/AliasCheckBuilders.h"
#include "polly/SpeculativeAliasAnalysis.h"
// #include "polly/Support/SCEVValidator.h"

using namespace llvm;
using namespace polly;

#define DEBUG_TYPE "polly-aa-eval"

// namespace {

struct PollyAaEval final : FunctionPass {
  static char ID;
  PollyAaEval() : FunctionPass(ID) {
    initializePollyAaEvalPass(*PassRegistry::getPassRegistry());
  }

  /// FunctionPass interface.
  bool runOnFunction(llvm::Function &F) override {
    /// Collect all analyses needed for runtime check generation.
    li  = &getAnalysis<LoopInfo>();
    ri  = &getAnalysis<RegionInfoPass>().getRegionInfo();
    aa  = &getAnalysis<AliasAnalysis>();
    se  = &getAnalysis<ScalarEvolution>();
    dt  = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();
    saa = &getAnalysis<SpeculativeAliasAnalysis>();

    std::vector<std::unique_ptr<AliasInstrumentationContext>> targetRegions;

    findAliasInstrumentableRegions(
      ri->getTopLevelRegion(),
      se, aa, saa, li, dt,
      AliasCheckFlags::allTrue(),
      targetRegions
    );

    for (auto& context : targetRegions) {
      evalRegion(&F, *context);
    }

    return false;
  }

  bool doInitialization(Module &M) override {
    numRegions = numPairs = numStaticNoAlias = numStaticMayAlias =
    numStaticMustAlias = numDynamicNoAlias = numDynamicNoHeapAlias =
    numDynamicNoRangeAlias = numDynamicProbablyAlias = numDynamicMustAlias =
    numDynamicDontKnow = 0;

    return false;
  }

  bool doFinalization(Module &M) override {
    errs() << "---\n";
    errs() << "regions:                " << numRegions              << "\n";
    errs() << "pairs:                  " << numPairs                << "\n";
    errs() << "static-no-alias:        " << numStaticNoAlias        << "\n";
    errs() << "static-may-alias:       " << numStaticMayAlias       << "\n";
    errs() << "static-must-alias:      " << numStaticMustAlias      << "\n";
    errs() << "dynamic-no-alias:       " << numDynamicNoAlias       << "\n";
    errs() << "dynamic-no-heap-alias:  " << numDynamicNoHeapAlias   << "\n";
    errs() << "dynamic-no-range-alias: " << numDynamicNoRangeAlias  << "\n";
    errs() << "dynamic-probably-alias: " << numDynamicProbablyAlias << "\n";
    errs() << "dynamic-must-alias:     " << numDynamicMustAlias     << "\n";

    // just printing the don't know is a bit unfair, since we only profile
    // may-alias pairs
    // so we substract the number of must- and no-aliases
    errs() << "dynamic-don't-know:     ";
    errs() << (numDynamicDontKnow - numStaticMustAlias - numStaticNoAlias);
    errs() << "\n";

    errs() << "...\n";

    return false;
  }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.addRequired<DominatorTreeWrapperPass>();
    AU.addRequired<PostDominatorTree>();
    AU.addRequired<DominanceFrontier>();
    AU.addRequired<LoopInfo>();
    AU.addRequired<ScalarEvolution>();
    AU.addRequired<AliasAnalysis>();
    AU.addRequired<RegionInfoPass>();
    AU.addRequired<SpeculativeAliasAnalysis>();

    AU.setPreservesAll();
  }
private:
  void evalRegion(Function *f, AliasInstrumentationContext& ctx) {
    numRegions++;

    std::set<std::pair<Value *, Value *>> ptrPairs;

    for (const auto& memAccess1 : ctx.memAccesses) {
      auto* ptr1 = memAccess1.first;

      for (const auto& memAccess2 : ctx.memAccesses) {
        auto* ptr2 = memAccess2.first;

        if (ptr1 == ptr2)
          continue;

        ptrPairs.insert(make_ordered_pair(ptr1, ptr2));
      }
    }

    for (auto& pair : ptrPairs)
      evalPair(f, pair.first, pair.second);
  }

  void evalPair(Function *f, Value *ptr1, Value *ptr2) {
    numPairs++;

    switch (aa->alias(ptr1, ptr2)) {
      case AliasAnalysis::NoAlias:
        numStaticNoAlias++;
        break;
      case AliasAnalysis::MayAlias:
        numStaticMayAlias++;
        break;
      case AliasAnalysis::MustAlias:
        numStaticMustAlias++;
        break;
      default:
        break;
    }

    switch (saa->speculativeAlias(f, ptr1, ptr2)) {
      case SpeculativeAliasResult::NoHeapAlias:
        numDynamicNoHeapAlias++;
        break;
      case SpeculativeAliasResult::NoRangeOverlap:
        numDynamicNoRangeAlias++;
        break;
      case SpeculativeAliasResult::NoAlias:
        numDynamicNoAlias++;
        break;
      case SpeculativeAliasResult::ExactAlias:
        numDynamicMustAlias++;
        break;
      case SpeculativeAliasResult::ProbablyAlias:
        numDynamicProbablyAlias++;
        break;
      case SpeculativeAliasResult::DontKnow:
        numDynamicDontKnow++;
        break;
    }
  }

  // Analyses used.
  ScalarEvolution *se;
  AliasAnalysis *aa;
  SpeculativeAliasAnalysis *saa;
  LoopInfo *li;
  RegionInfo *ri;
  DominatorTree *dt;

  size_t numRegions;
  size_t numPairs;
  size_t numStaticNoAlias, numStaticMayAlias, numStaticMustAlias;
  size_t numDynamicNoAlias, numDynamicNoHeapAlias, numDynamicNoRangeAlias,
         numDynamicProbablyAlias, numDynamicMustAlias, numDynamicDontKnow;
};

// } // end anoymous namespace

char PollyAaEval::ID = 0;

Pass *polly::createPollyAaEvalPass() {
  return new PollyAaEval();
}

INITIALIZE_PASS_BEGIN(PollyAaEval, "polly-aa-eval-pass",
                      "Polly - Evaluate static alias analysis in Scops",
                      false, false);
INITIALIZE_AG_DEPENDENCY(AliasAnalysis);
INITIALIZE_AG_DEPENDENCY(SpeculativeAliasAnalysis);
INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass);
INITIALIZE_PASS_DEPENDENCY(LoopInfo);
INITIALIZE_PASS_DEPENDENCY(RegionInfoPass);
INITIALIZE_PASS_DEPENDENCY(ScalarEvolution);
INITIALIZE_PASS_END(PollyAaEval, "polly-aa-eval-pass",
                    "Polly - Evaluate static alias analysis in Scops",
                    false, false)
