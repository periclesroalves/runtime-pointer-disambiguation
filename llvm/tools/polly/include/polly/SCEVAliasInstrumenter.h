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
#include "polly/SCEVRangeBuilder.h"
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
class Instruction;
class LoopInfo;
}

namespace polly {

using namespace llvm;

class ScopDetection;
class DetectionContext;
class AliasProfilingFeedback;
class SpeculativeAliasAnalysis;
enum class SpeculativeAliasResult;

class MustAliasSets {
public:
  using Set            = std::list<std::set<Value*>>;
  using iterator       = Set::iterator;
  using const_iterator = Set::const_iterator;

  std::set<Value*>& getSetFor(Value *v);

  iterator begin() { return sets.begin(); }
  iterator end() { return sets.end(); }

  const_iterator begin() const { return sets.begin(); }
  const_iterator end() const { return sets.end(); }
private:
  Set sets;
};

class SCEVAliasInstrumenter : public FunctionPass {
  typedef IRBuilder<true, TargetFolder> BuilderType;

  /**
   * Holds information about the region being instrumented, like memory
   * properties.
   */
  struct InstrumentationContext {
    Region &r; // The region being instrumented.

    // Stores, for each memory accesses instruction in the region, its
    // respective base pointer and access function.
    // For the accesses a[i], a[i+5], and b[i+j], we'd have something like:
    // - memAccesses: {a: (i,i+5), b: (i+j)}
    std::map<Value *, std::set<const SCEV *> > memAccesses;

    //@{
    // Stores all pairs of base pointers that need to be dynamically checked
    // against each other, for the region to be considered free of aliasing.
    // If the pointers a, b, and c may alias in the region, we'd have:
    // - pairsToCheck: (<a,b>, <b,c>, <a,c>)
    std::set<std::pair<Value *, Value *>> rangeChecks;
    std::set<std::pair<Value *, Value *>> heapChecks;
    //@}

    // pointers that we will check for equality to establish a must alias
    // relationship    
    MustAliasSets equalityChecks;

    // Holds the lower and upper bounds for each base pointer in the region,
    // represented by the bounds of the smallest and largest access expressions.
    std::map<Value *, std::pair<Value *, Value *> > pointerBounds;

    InstrumentationContext(Region &r) : r(r) {}
  };

  // Analyses used.
  ScalarEvolution *se;
  AliasAnalysis *aa;
  SpeculativeAliasAnalysis *saa;
  LoopInfo *li;
  RegionInfo *ri;
  DominatorTree *dt;
  PostDominatorTree *pdt;
  DominanceFrontier *df;

  // Function being analysed.
  Function *currFn;

  // Metadata domain to be used by alias metadata.
  MDNode *mdDomain = nullptr;

  // List of dynamic checks generated while instrumenting regions. Each value in
  // this list is a boolean that indicates, at runtime, if the corresponding
  // region is free of true dependencies. This value usually lives right before
  // the region entry.
  std::vector<std::pair<Instruction *, Region *> > insertedChecks;

  // Walks the region tree, trying to insert dynamic checks for the greatest
  // possible regions.
  void findAndInstrumentRegions(Region &r);

  // Checks if the given region has all the properties needed for
  // instrumentation.
  bool canInstrument(InstrumentationContext &context);

  // Checks if the given instruction doesn't break the properties needed for
  // instrumentation (basically checks if it doesn't access memory in an
  // unpredictable way).
  bool isValidInstruction(Instruction &inst);

  // Collects, for each memory access instruction in the region, its base
  // pointers, access function, and pointers that need to be checked against it
  // so it can be considered alias-free.
  bool collectDependencyData(InstrumentationContext &context);

  // Get the value that represents the base pointer of the given memory access
  // instruction in the given region. The pointer must be region invariant.
  Value *getBasePtrValue(Instruction &inst, const Region &r);

  // Tries to generate dynamic checks that compare the access range of every
  // pair of pointers in the region at run-time, thus finding if there is true
  // aliasing. Returns true if checks could be generated for all dependencies.
  // For every pair (A,B) of pointers in the region that may alias, we generate:
  // - check(A, B) -> upperAddrA < lowerAddrB || upperAddrB < lowerAddrA
  bool instrumentDependencies(InstrumentationContext &context);

  // Tries to compute the bounds for the addresses accessed over each base
  // pointer in the region, using SCEV.
  bool buildSCEVBounds(InstrumentationContext &context,
                       SCEVRangeBuilder &rangeBuilder);

  // Inserts a dynamic test to guarantee that accesses to two pointers do not
  // overlap in a specific region, given their access ranges.
  // E.g.: %pair-no-alias = upper(A) < lower(B) || upper(B) < lower(A)
  Instruction *buildRangeCheck(std::pair<Value *, Value *> boundsA,
                               std::pair<Value *, Value *> boundsB,
                               BuilderType &builder,
                               SCEVRangeBuilder &rangeBuilder);

  // Chain the checks that compare different pairs of pointers to a single
  // result value using "and" operations.
  // E.g.: %region-no-alias = %pair-no-alias1 && %pair-no-alias2 && %pair-no-alias3
  Instruction
  *chainChecks(std::vector<Instruction *> checks, BuilderType &builder);

  // Produce two versions of each instrumented region: one with the original
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
  void cloneInstrumentedRegions();

  // The structure of a region can't be changed while instrumenting it, so the
  // checks were inserted in the entry block. This method fix the structure of
  // the instrumented regions by simplifying them and moving the checks to the
  // entering block, so we can clone the region without cloning the checks.
  // NOTE: checks that can't be hoisted will e aliminated.
  //       |    |              ____\|/___
  //     _\|/__\|/_           | dy_check |
  //    | Region:  |          '-----.----'
  //    | dy_check |           ____\|/___
  //    |   ...    |    =>    | Region:  |
  //    '---|---|--'          |    ...   |
  //       \|/ \|/            '-----.----'
  //                               \|/
  void hoistChecks();

  // Create single entry and exit EDGES in a region (thus creating entering and
  // exiting blocks).
  bool simplifyRegion(Region *r);

  // Checks if a region can be simplified to have single entry and exit EDGES
  // without breaking the sinlge entry and exit BLOCKS property. This can happen
  // when edges from within the region point to its entry or exit.
  bool isSafeToSimplify(Region *r);

  // Use scoped alias tags to tell the compiler that cloned regions are free of
  // dependencies. Basically creates a separate alias scope for each base
  // pointer in the region. Each load/store instruction is then associated with
  // it's base pointer scope, generating disjoint alias sets in the region.
  void fixAliasInfo(Region *r);

  // DEBUG - compute the lower and upper access bounds for the base pointer in
  // the given region. Also inserts instructions to print the computed bounds at
  // runtime, in the region entry. Returns true if the bounds can be computed,
  // false otherwis..
  bool computeAndPrintPtrBounds(Value *pointer, Region *r);

public:
  static char ID;
  explicit SCEVAliasInstrumenter() : FunctionPass(ID) {}

  // FunctionPass interface.
  virtual void getAnalysisUsage(AnalysisUsage &AU) const;
  virtual bool runOnFunction(Function &F);
  void releaseMemory() { insertedChecks.clear(); }
};
} // end namespace polly

namespace llvm {
class PassRegistry;
void initializeSCEVAliasInstrumenterPass(llvm::PassRegistry &);
}

#endif
