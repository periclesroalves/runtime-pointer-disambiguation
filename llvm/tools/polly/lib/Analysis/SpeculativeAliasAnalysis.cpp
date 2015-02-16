//===- SpeculativeAliasAnalysis.cpp - Speculative Alias Analysis -----------==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
//
//===----------------------------------------------------------------------===//

#include "polly/SpeculativeAliasAnalysis.h"
#include "polly/LinkAllPasses.h"
#include <llvm/Support/CommandLine.h>
using namespace polly;
using namespace llvm;

cl::OptionCategory category("Speculative alias analysis");

// Register the AliasAnalysis interface, providing a nice name to refer to.
char SpeculativeAliasAnalysis::ID = 0;
INITIALIZE_ANALYSIS_GROUP(SpeculativeAliasAnalysis, "Speculative Alias Analysis", NoSpecAA)

void SpeculativeAliasAnalysis::anchor() {}


//===----------------------------------------------------------------------===//
// Implementation using offline profiling feedback
//===----------------------------------------------------------------------===//

namespace {
  struct ProfilingFeedbackSpecAA : public ImmutablePass, 
      public SpeculativeAliasAnalysis {
    static char ID; // Class identification, replacement for typeinfo
    ProfilingFeedbackSpecAA() : ImmutablePass(ID) {
      initializeProfilingFeedbackSpecAAPass(*PassRegistry::getPassRegistry());
    }

    SpeculativeAliasResult speculativeAlias(const Value *a, const Value *b) override {
      // TODO: lazily load profiling results and use them

      return SpeculativeAliasResult::DontKnow;
    }

    //===------------------------------------------------------------------===//
    //  Pass interface
    //===------------------------------------------------------------------===//

    void *getAdjustedAnalysisPointer(const void *ID) override {
      if (ID == &SpeculativeAliasAnalysis::ID)
        return (SpeculativeAliasAnalysis*)this;
      return this;
    }
  };
}  // End of anonymous namespace

// Register this pass...
char ProfilingFeedbackSpecAA::ID = 0;
INITIALIZE_AG_PASS(ProfilingFeedbackSpecAA, SpeculativeAliasAnalysis, "profiling-spec-aa",
                   "Speculative Alias Analysis using profiling feedback",
                   true, false, false)

Pass *polly::createProfilingFeedbackSpecAAPass() { return new ProfilingFeedbackSpecAA(); }


//===----------------------------------------------------------------------===//
// Default implementation
//===----------------------------------------------------------------------===//

namespace {
  /// This class implements the -no-specaa pass which always returns don't know
  /// for any alias query.
  struct NoSpecAA : public ImmutablePass, public SpeculativeAliasAnalysis {
    static char ID; // Class identification, replacement for typeinfo
    NoSpecAA() : ImmutablePass(ID) {
      initializeNoSpecAAPass(*PassRegistry::getPassRegistry());
    }

    SpeculativeAliasResult speculativeAlias(const Value *a, const Value *b) override {
      return SpeculativeAliasResult::DontKnow;
    }

    //===------------------------------------------------------------------===//
    //  Pass interface
    //===------------------------------------------------------------------===//

    void *getAdjustedAnalysisPointer(const void *ID) override {
      if (ID == &SpeculativeAliasAnalysis::ID)
        return (SpeculativeAliasAnalysis*)this;
      return this;
    }
  };
}  // End of anonymous namespace

// Register this pass...
char NoSpecAA::ID = 0;
INITIALIZE_AG_PASS(NoSpecAA, SpeculativeAliasAnalysis, "no-spec-aa",
                   "No Speculative Alias Analysis (same result as static AA)",
                   true, true, true)

Pass *polly::createNoSpecAAPass() { return new NoSpecAA(); }

