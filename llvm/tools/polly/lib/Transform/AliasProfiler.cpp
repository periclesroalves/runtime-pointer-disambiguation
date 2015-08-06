//===------------- AliasProfiler.cpp ----------------------------*- C++ -*-===//
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

#include "polly/RegionAliasInfo.h"
#include "polly/SpeculativeAliasAnalysis.h"
#include "polly/LinkAllPasses.h"
#include "polly/ScopDetection.h"
#include "polly/Support/ScopHelper.h"
#include "polly/CloneRegion.h"
#include "polly/CodeGen/BlockGenerators.h"
#include "polly/SCEVRangeBuilder.h"
#include "polly/Support/AliasCheckBuilders.h"
// #include "polly/Support/SCEVValidator.h"

using namespace llvm;
using namespace polly;

#define DEBUG_TYPE "polly-alias-profiler"

template<typename T>
std::pair<T,T> make_ordered_pair(const T& t1, const T& t2) {
  return (t1 < t2) ? std::make_pair(t1,t2) : std::make_pair(t2,t1);
}

// from alias_profiler.h
enum memtrackAliasType {
  MEMTRACK_NO_HEAP_ALIAS  = 1,
  MEMTRACK_NO_RANGE_ALIAS = 2,
  MEMTRACK_EXACT_ALIAS    = 3,
};


// namespace {

struct AliasProfiling final : FunctionPass {
  typedef IRBuilder<true, TargetFolder> BuilderType;

  static char ID;
  AliasProfiling() : FunctionPass(ID) {
    initializeAliasProfilingPass(*PassRegistry::getPassRegistry());
  }

  // FunctionPass interface.
  void getAnalysisUsage(AnalysisUsage &AU) const override;
  bool runOnFunction(Function &F) override;
  void releaseMemory() override;
private:
  void insertInstrumentation(AliasInstrumentationContext &ctx) {
    auto region = ctx.region;

    /// Create an entering block to receive the checks.
    simplifyRegion(region, this);

    // Set instruction insertion context. We'll insert the run-time tests in the
    // region entering block.
    Instruction *insertPt = region->getEnteringBlock()->getTerminator();
    BuilderType builder(se->getContext(), TargetFolder(se->getDataLayout()));
    builder.SetInsertPoint(insertPt);

    SCEVRangeBuilder scevRange(se, aa, li, dt, region, insertPt);
    scevRange.setArtificialBECounts(ctx.getBECountsMap());

    RangeCheckBuilder    rangeChecks{scevRange, builder, ctx};
    HeapCheckBuilder     heapChecks{builder, region->getEnteringBlock(), getPtrId};
    EqualityCheckBuilder eqChecks{builder};

    // *** insert checks

    auto insertTraceCall = [&](Value* basePtr1, Value* basePtr2, Value* checkResult, uint8_t type) {
      assert(traceAliasBehaviour);

      if (!checkResult)
        return;

      checkResult = builder.CreateSExtOrTrunc(checkResult, builder.getInt8Ty());

      builder.CreateCall5(
        traceAliasBehaviour,
        getNameAsValue(builder, currentFunction),
        getNameAsValue(builder, basePtr1),
        getNameAsValue(builder, basePtr2),
        checkResult,
        builder.getInt8(type)
      );
    };

    auto insertTraceCalls = [&](Value* basePtr1, Value* basePtr2) {
      insertTraceCall(
        basePtr1, basePtr2,
        heapChecks.buildCheck(basePtr1, basePtr2),
        MEMTRACK_NO_HEAP_ALIAS
      );
      insertTraceCall(
        basePtr1, basePtr2,
        eqChecks.buildCheck(basePtr1, basePtr2),
        MEMTRACK_EXACT_ALIAS
      );
      insertTraceCall(
        basePtr1, basePtr2,
        rangeChecks.buildRangeCheck(basePtr1, basePtr2),
        MEMTRACK_NO_RANGE_ALIAS
      );
    };

    // Insert comparison expressions for every pair of pointers that need to be
    // checked in the region.
    for (auto& pair : ctx.heapChecks.ptrPairsToCheck) {
      auto basePtr1 = pair.first;
      auto basePtr2 = pair.second;

      insertTraceCalls(basePtr1, basePtr2);
    }
    for (auto& pair : ctx.scevChecks.ptrPairsToCheck) {
      auto basePtr1 = pair.first;
      auto basePtr2 = pair.second;

      insertTraceCalls(basePtr1, basePtr2);
    }
  }

  Value* getNameAsValue(BuilderType& irb, Value *v) {
    return FullInstNamer::getNameAsValue(this, irb, v);
  }

  void initializeCallbacks(Module &M) {
    using GetPtrIdTy = void*(void*);
    using TraceFnTy  = void(const char*, const char*, const char *, uint8_t, uint8_t);

    getPtrId            = declareTraceFunction<GetPtrIdTy>("gcg_getBasePtr", M);
    traceAliasBehaviour = declareTraceFunction<TraceFnTy>("memtrack_traceAlias", M);
  }

  static Function* declareTraceFunction(const char* const name, FunctionType* type, Module &M) {
    auto trace_fn = M.getFunction(name);

    if (trace_fn)
      return trace_fn;

    trace_fn = Function::Create(
      type,
      GlobalValue::ExternalLinkage,
      name,
      &M
    );
    assert(trace_fn);

    unsigned idx = 1;
    for (auto& arg : trace_fn->args()) {
      if (arg.getType()->isPointerTy()) {
        trace_fn->addAttribute(idx, Attribute::ReadOnly);
        trace_fn->addAttribute(idx, Attribute::NoCapture);
      }
      idx++;
    }

    return trace_fn;
  }

  template<typename FnType>
  static Function* declareTraceFunction(const char* const name, Module &M) {
    auto &ctx = M.getContext();
    auto type = TypeBuilder<FnType, false>::get(ctx);

    assert(type);

    return declareTraceFunction(name, type, M);
  }

  // Analyses used.
  ScalarEvolution *se;
  AliasAnalysis *aa;
  SpeculativeAliasAnalysis *saa;
  LoopInfo *li;
  RegionInfo *ri;
  DominatorTree *dt;
  DominanceFrontier *df;
  PostDominatorTree *pdt;

  Function *currentFunction = nullptr;

  Function* getPtrId            = nullptr;
  Function* traceAliasBehaviour = nullptr;
};

// } // end anoymous namespace

bool AliasProfiling::runOnFunction(llvm::Function &F) {
  initializeCallbacks(*F.getParent());

  currentFunction = &F;

  /// Collect all analyses needed for runtime check generation.
  li  = &getAnalysis<LoopInfo>();
  ri  = &getAnalysis<RegionInfoPass>().getRegionInfo();
  aa  = &getAnalysis<AliasAnalysis>();
  saa = &getAnalysis<SpeculativeAliasAnalysis>();
  se  = &getAnalysis<ScalarEvolution>();
  dt  = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  pdt = &getAnalysis<PostDominatorTree>();
  df  = &getAnalysis<DominanceFrontier>();

  std::vector<std::unique_ptr<AliasInstrumentationContext>> targetRegions;

  findAliasInstrumentableRegions(
    ri->getTopLevelRegion(),
    se, aa, saa, li, dt,
    AliasCheckFlags::allTrue(),
    targetRegions
  );

  bool changed = !targetRegions.empty();

  // Instrument target region.
  for (auto& context : targetRegions) {
    insertInstrumentation(*context);
  }

  return changed;
}

void AliasProfiling::getAnalysisUsage(AnalysisUsage &AU) const {
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

void AliasProfiling::releaseMemory() {
}

char AliasProfiling::ID = 0;

Pass *polly::createAliasProfilingPass() {
  return new AliasProfiling();
}

INITIALIZE_PASS_BEGIN(AliasProfiling, "polly-alias-profiler",
                      "Polly - Add instrumentation for alias profiling",
                      false, false);
INITIALIZE_AG_DEPENDENCY(AliasAnalysis);
INITIALIZE_AG_DEPENDENCY(SpeculativeAliasAnalysis);
INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass);
INITIALIZE_PASS_DEPENDENCY(LoopInfo);
INITIALIZE_PASS_DEPENDENCY(PostDominatorTree);
INITIALIZE_PASS_DEPENDENCY(DominanceFrontier);
INITIALIZE_PASS_DEPENDENCY(RegionInfoPass);
INITIALIZE_PASS_DEPENDENCY(ScalarEvolution);
INITIALIZE_PASS_END(AliasProfiling, "polly-alias-profiler",
                    "Polly - Add instrumentation for alias profiling",
                    false, false)
