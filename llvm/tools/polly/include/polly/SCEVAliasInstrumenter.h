//===------------- SCEVAliasInstrumenter.h ----------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// Instrument regions with runtime checks capable of verifying if there are true
// dependences or not. This is achieved through address interval comparison
// between all loads/stores within the region. This pass also does region
// versioning, based on the dynamic check result.
//
// Thee following example:
//
//   for (int i = 0; i < N; i++)
//     A[i] = B[i + M];
//
// We would become the following code:
//
//   // Tests if access to A and B do not overlap.
//   if ((A + N - 1 < B) || (B + N + M - 1 < A)) {
//     // Version of the loop with no depdendencies.
//     for (int i = 0; i < N; i++)
//       A[i] = B[i + M];
//   } else {
//     // Version of the loop with unknown alias dependencies.
//     for (int i = 0; i < N; i++)
//       A[i] = B[i + M];
//   }
//===----------------------------------------------------------------------===//

#ifndef POLLY_ALIAS_INSTRUMENTER_H
#define POLLY_ALIAS_INSTRUMENTER_H

#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/Analysis/AliasSetTracker.h"
#include "llvm/Analysis/RegionInfo.h"
#include "llvm/Analysis/ScalarEvolutionExpander.h"
#include "llvm/IR/Module.h"
#include "polly/RegionAliasInfo.h"
#include "polly/SCEVRangeBuilder.h"
#include "polly/Support/AliasCheckBuilders.h"
#include <map>
#include <set>
#include <list>

namespace llvm {
class ScalarEvolution;
class AliasAnalysis;
class SCEV;
class DominatorTree;
class DominanceFrontier;
struct PostDominatorTree;
class Value;
class Region;
class LoopInfo;
}

namespace polly {

using namespace llvm;

class ScopDetection;
class DetectionContext;
class AliasProfilingFeedback;
class SpeculativeAliasAnalysis;

class SCEVAliasInstrumenter : public FunctionPass {
  typedef IRBuilder<true, TargetFolder> BuilderType;

  // Analyses used.
  ScalarEvolution *se;
  AliasAnalysis *aa;
  SpeculativeAliasAnalysis *saa;
  LoopInfo *li;
  RegionInfo *ri;
  DominatorTree *dt;
  DominanceFrontier *df;
  PostDominatorTree *pdt;

  // Function being analysed.
  Function *currFn;

  // Function for getting heap id of pointee of a pointer
  Function *getPtrId;

  // Metadata domain to be used by alias metadata.
  MDNode *mdDomain = nullptr;

  // Set of regions that will be instrumented.
  std::vector<AliasInstrumentationContext> targetRegions;

  // Generates dynamic checks that compare the access range of every pair of
  // pointers in the region at run-time, thus finding if there is true aliasing.
  // For every pair (A,B) of pointers in the region that may alias, we generate:
  // - check(A, B) -> upperAddrA < lowerAddrB || upperAddrB < lowerAddrA
  // The instructions needed for the checks compuation are inserted in the
  // entering block of the target region, which works as a pre-header. The
  // returned Instruction produces a boolean value that, at run-time, indicates
  // if the region is free of dependencies.
  Value *insertDynamicChecks(AliasInstrumentationContext &context);

  // Produce two versions of an instrumented region: one with the original
  // alias info, if the run-time alias check fails, and one set to ignore
  // dependencies, in case the check passes.
  //     ____\|/___                 ____\|/___
  //    | dy_check |               | dy_check |
  //    '-----.----'               '-----.----'
  //     ____\|/___     =>      F .------'------. T
  //    | Region:  |         ____\|/__    _____\|/____
  //    |    ...   |        | (Alias) |  | (No alias) |
  //    '-----.----'        |    ...  |  |    ...     |
  //         \|/            '-----.---'  '------.-----'
  //                              '------.------'
  //                                    \|/
  void buildNoAliasClone(AliasInstrumentationContext &context,
                         Value *checkResult);

  // Create single entry and exit EDGES in a region (thus creating entering and
  // exiting blocks).
  void simplifyRegion(Region *r);

  // Use scoped alias tags to tell the compiler that cloned regions are free of
  // dependencies. Basically creates a separate alias scope for each base
  // pointer in the region. Each load/store instruction is then associated with
  // it's base pointer scope, generating disjoint alias sets in the region.
  void fixAliasInfo(AliasInstrumentationContext&);

public:
  static char ID;
  explicit SCEVAliasInstrumenter() : FunctionPass(ID), getPtrId(nullptr) {}

  // FunctionPass interface.
  virtual void getAnalysisUsage(AnalysisUsage &AU) const override;
  virtual bool runOnFunction(Function &F) override;
  void releaseMemory() override { targetRegions.clear(); }

  bool doInitialization(Module &M) override;
};

} // end namespace polly

namespace llvm {
class PassRegistry;
void initializeSCEVAliasInstrumenterPass(llvm::PassRegistry &);
}

#endif
