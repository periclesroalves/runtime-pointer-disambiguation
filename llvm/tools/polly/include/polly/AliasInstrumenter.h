//===------------- AliasInstrumenter.h --------------------------*- C++ -*-===//
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

#include "llvm/Transforms/Utils/FullInstNamer.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/Analysis/AliasSetTracker.h"
#include "llvm/Analysis/RegionInfo.h"
#include "llvm/Analysis/ScalarEvolutionExpander.h"
#include "llvm/IR/Module.h"
#include "polly/SCEVRangeAnalyser.h"
#include <map>

namespace llvm {
class ScalarEvolution;
class AliasAnalysis;
class SCEV;
class DominatorTree;
class DominanceFrontier;
struct PostDominatorTree;
class Value;
class Region;
class Instruction;
class LoopInfo;
}

namespace polly {

using namespace llvm;

class ScopDetection;
class DetectionContext;

Function* declareTraceFunction(Module *m);

class AliasInstrumenter : public FunctionPass {
  typedef IRBuilder<true, TargetFolder> BuilderType;

  // Analyses used.
  ScalarEvolution *se;
  AliasAnalysis *aa;
  LoopInfo *li;
  RegionInfo *ri;
  DominatorTree *dt;
  PostDominatorTree *pdt;
  DominanceFrontier *df;
  FullInstNamer *fin;

  Function *currFn;
  Function *trace_fn;

  // Metadata domain to be used by alias metadata.
  MDNode *mdDomain = nullptr;

  // List of dynamic checks generated while solving dependencies. Each value
  // indicates, at runtime, if the corresponding region is free of dependencies.
  std::vector<std::pair<Value *, Region *> > insertedChecks;

  // Inserts a dynamic test to guarantee that accesses to two pointers do not
  // overlap, given their access ranges.
  Value *insertCheck(std::pair<Value *, Value *> boundsA,
                     std::pair<Value *, Value *> boundsB,
                     BuilderType &builder, SCEVRangeAnalyser &rangeAnalyser);

  // Chain all checks to a single result value using "and" operations.
  Value *chainChecks(std::vector<Value *> checks, BuilderType &builder);

  // calls runtime to print the expected and the real array bounds of a value
  void printArrayBounds(Value *v, Value *l, Value *u, Region *r, BuilderType &builder, SCEVRangeAnalyser& rangeAnalyser);
public:
  static char ID;
  explicit AliasInstrumenter() : FunctionPass(ID) {}

  // FunctionPass interface.
  virtual void getAnalysisUsage(AnalysisUsage &AU) const;
  virtual bool runOnFunction(Function &F);
  void releaseMemory() { insertedChecks.clear(); }

  // Check for dependencies within the current region, generating dynamic alias
  // checks for all pointers that can't be solved statically. Returns true if
  // all dependecies could be solved. For every pair (A,B) of pointers that may
  // alias, generates:
  // - check(A, B) -> upperAddrA < lowerAddrB || upperAddrB < lowerAddrA
  bool checkAndSolveDependencies(Region *r);

  std::vector<std::pair<Value *, Region *> > &getInsertedChecks() {
    return insertedChecks;
  }

  // The structure of a region can't be changed while instrumenting it. This
  // method fix the structure of the instrumented regions by simplifying them
  // and isolating the checks in a new entering block.
  //       |    |              ____\|/___
  //     _\|/__\|/_           | dy_check |
  //    | Region:  |          '-----.----'
  //    | dy_check |           ____\|/___
  //    |   ...    |    =>    | Region:  |
  //    '---|---|--'          |    ...   |
  //       \|/ \|/            '-----.----'
  //                               \|/
  void fixInstrumentedRegions();

  // Produce two versions of each instrumented region: one with the original
  // alias info, if the check fails, and one set to ignore dependencies, in
  // case the check passes.
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
  void cloneInstrumentedRegions(RegionInfo *ri, DominatorTree *dt,
                                DominanceFrontier *df);

  // Use scoped alias tags to tell the compiler that cloned regions are free of
  // dependencies.
  void fixAliasInfo(Region *r);

  // DEBUG - compute the lower and upper access bounds for the base pointer in
  // the given region. Also inserts instructions to print the computed bounds at
  // runtime. Returns true if the bounds can be computed, false otherwise.
  bool computeAndPrintBounds(Value *pointer, Region *r);

  // Checks if a region can be simplified without breaking the sinlge-entry
  // single-exit property.
  bool isSafeToSimplify(Region *r);
};
} // end namespace polly

namespace llvm {
class PassRegistry;
void initializeAliasInstrumenterPass(llvm::PassRegistry &);
}

#endif
