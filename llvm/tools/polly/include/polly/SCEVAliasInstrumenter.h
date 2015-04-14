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

  // Information regarding an artificial back edge count created for a loop.
  struct ArtificialBECount {
    Instruction *addr; // Address of the loaded loop bound.
    Instruction *oldLoad; // Original loop-variant load.
    Instruction *hoistedLoad; // Hoisted copy of the bound load.
    const SCEV *count; // New artificial BE count.

    ArtificialBECount(Instruction *addr, Instruction *oldLoad,
                      Instruction *hoistedLoad, const SCEV *count)
      : addr(addr), oldLoad(oldLoad), hoistedLoad(hoistedLoad), count(count) {}
  };

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

    // All base pointers that are targets of store instructions in the region.
    std::set<Value *> storeTargets;

    // Artificial back-edge counts created for loops in this region.
    std::map<Loop *, ArtificialBECount> artificialBECounts;

    //@{
    // Stores all pairs of base pointers that need to be dynamically checked
    // against each other, for the region to be considered free of aliasing.
    // If the pointers a, b, and c may alias in the region, we'd have:
    // - pairsToCheck: (<a,b>, <b,c>, <a,c>)
    std::set<std::pair<Value *, Value *>> ptrPairsToCheckOnRange;
    std::set<std::pair<Value *, Value *>> ptrPairsToCheckOnHeap;
    //@}

    // pointers that we will check for equality to establish a must alias
    // relationship    
    MustAliasSets equalityChecks;

    // Holds the lower and upper bounds for each base pointer in the region,
    // represented by the bounds of the smallest and largest access expressions.
    std::map<Value *, std::pair<Value *, Value *> > pointerBounds;

    InstrumentationContext(Region &r) : r(r) {}

    // Builds a map containing the artificially created BE counts.
    std::map<const Loop *, const SCEV *> getBECountsMap() {
      std::map<const Loop *, const SCEV *> counts;

      for (auto &pair : artificialBECounts)
        counts.emplace(pair.first, pair.second.count);

      return counts;
    }
  };

  // Analyses used.
  ScalarEvolution *se;
  AliasAnalysis *aa;
  LoopInfo *li;
  RegionInfo *ri;
  DominatorTree *dt;
  PostDominatorTree *pdt;
  DominanceFrontier *df;

  // Function being analysed.
  Function *currFn;

  // Metadata domain to be used by alias metadata.
  MDNode *mdDomain = nullptr;

  // Set of regions that will be instrumented.
  std::vector<InstrumentationContext> targetRegions;

  // Walks the region tree, collecting the greatest possible regions that can be
  // safely instrumented.
  void findTargetRegions(Region &r);

  // Checks if the given region has all the properties needed for
  // instrumentation.
  bool canInstrument(InstrumentationContext &context);

  // Tries to give the loop an invariant backedge taken count, by modifying the
  // loop structure then inserting some checks that guarantee its correctness.
  // We currently check if the loop bound comes from a loop variant load from
  // an invariant address. If so, we try to hoist the load to outside the loop,
  // thus making it possible to compute an invariant BE count. During check
  // insertion, we generate a dynamic check that guarantees that no other store
  // aliases the hoisted load.
  bool createArtificialInvariantBECount(Loop *l,
                                        InstrumentationContext &context);

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

  // Generates dynamic checks that compare the access range of every pair of
  // pointers in the region at run-time, thus finding if there is true aliasing.
  // For every pair (A,B) of pointers in the region that may alias, we generate:
  // - check(A, B) -> upperAddrA < lowerAddrB || upperAddrB < lowerAddrA
  // The instructions needed for the checks compuation are inserted in the
  // entering block of the target region, which works as a pre-header. The
  // returned Instruction produces a boolean value that, at run-time, indicates
  // if the region is free of dependencies.
  Instruction *insertDynamicChecks(InstrumentationContext &context);

  // Computes the bounds for the addresses accessed over each base pointer in
  // the region, using SCEV.
  void buildSCEVBounds(InstrumentationContext &context,
                       SCEVRangeBuilder &rangeBuilder);

  // Inserts a dynamic test to guarantee that accesses to two pointers do not
  // overlap in a specific region, given their access ranges.
  // E.g.: %pair-no-alias = upper(A) < lower(B) || upper(B) < lower(A)
  Instruction *buildRangeCheck(std::pair<Value *, Value *> boundsA,
                               std::pair<Value *, Value *> boundsB,
                               BuilderType &builder,
                               SCEVRangeBuilder &rangeBuilder);

  // Inserts a dynamic test to guarantee that accesses to a pointer do not alias
  // a specific address within the region, given the pointer range and the
  // symbolic address.
  // E.g.: %loc-no-alias = upper(A) < B || B < lower(A)
  Instruction *buildRangeCheck(std::pair<Value *, Value *> boundsA,
                               Value *addrB, BuilderType &builder,
                               SCEVRangeBuilder &rangeBuilder);

  // Chain the checks that compare different pairs of pointers to a single
  // result value using "and" operations.
  // E.g.: %region-no-alias = %pair-no-alias1 && %pair-no-alias2 && %pair-no-alias3
  Instruction *chainChecks(std::vector<Instruction *> checks, BuilderType &builder);

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
  void buildNoAliasClone(InstrumentationContext &context,
                         Instruction *checkResult);

  // Create single entry and exit EDGES in a region (thus creating entering and
  // exiting blocks).
  void simplifyRegion(Region *r);

  // Checks if a region can be simplified to have single entry and exit EDGES
  // without breaking the sinlge entry and exit BLOCKS property. This can happen
  // when edges from within the region point to its entry or exit.
  bool isSafeToSimplify(Region *r);

  // Use scoped alias tags to tell the compiler that cloned regions are free of
  // dependencies. Basically creates a separate alias scope for each base
  // pointer in the region. Each load/store instruction is then associated with
  // it's base pointer scope, generating disjoint alias sets in the region.
  void fixAliasInfo(Region *r);

public:
  static char ID;
  explicit SCEVAliasInstrumenter() : FunctionPass(ID) {}

  // FunctionPass interface.
  virtual void getAnalysisUsage(AnalysisUsage &AU) const;
  virtual bool runOnFunction(Function &F);
  void releaseMemory() { targetRegions.clear(); }
};
} // end namespace polly

namespace llvm {
class PassRegistry;
void initializeSCEVAliasInstrumenterPass(llvm::PassRegistry &);
}

#endif
