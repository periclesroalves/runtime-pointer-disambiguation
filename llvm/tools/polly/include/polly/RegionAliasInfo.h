//===---- polly/RegionAliasInfo.h - Alias data for SESE regions -*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Find pairs of pointers in a single-entry single-exit region that need to be
// checked for aliasing at runtime in order to ensure that region is a Scop.
//
//===----------------------------------------------------------------------===//

#ifndef POLLY_RegionAliasInfo_H
#define POLLY_RegionAliasInfo_H

#include <llvm/Analysis/TargetFolder.h>
#include <llvm/Pass.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/ValueMap.h>
#include <llvm/ADT/iterator_range.h>
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
class RegionInfo;
class Instruction;
class Loop;
class LoopInfo;
}

namespace polly {

using namespace llvm;

class ScopDetection;
class DetectionContext;
class AliasProfilingFeedback;
class SCEVRangeBuilder;
class SpeculativeAliasAnalysis;
struct AliasCheckFlags;

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
struct AliasInstrumentationContext {
  struct BasePtrInfo {
    std::set<Instruction *> users;
    std::set<const SCEV  *> accessFunctions;
  };

  using MemoryAccessMap = ValueMap<Value *, BasePtrInfo>;
  using MemoryAccess    = MemoryAccessMap::value_type;
  using ValuePair       = std::pair<Value *, Value *>;

  struct NoAliasChecks {
    // Stores all pairs of base pointers that need to be dynamically checked
    // against each other, for the region to be considered free of aliasing.
    // If the pointers a, b, and c may alias in the region, we'd have:
    // - pairsToCheck: (<a,b>, <b,c>, <a,c>)
    std::set<ValuePair> ptrPairsToCheck;

    // All base pointers that are targets of store instructions in the region.
    std::set<Value *> storeTargets;

    // Add a pair of pointers to check for aliasing.
    // If any of them are targets of a store they will be added to storeTargets.
    void addPair(AliasInstrumentationContext& ctx, Value *ptr1, Value *ptr2);
  };

  Region *region; // The region being instrumented.

  // Stores, for each memory accesses instruction in the region, its
  // respective base pointer and access function.
  // For the accesses a[i], a[i+5], and b[i+j], we'd have something like:
  // - memAccesses: {a: (i,i+5), b: (i+j)}
  MemoryAccessMap memAccesses;

  // Artificial back-edge counts created for loops in this region.
  std::map<Loop *, ArtificialBECount> artificialBECounts;
  bool allLoopsHaveBounds = false;

  // stores pairs of pointers and stores that need to be checked for aliasing
  NoAliasChecks heapChecks;
  NoAliasChecks scevChecks;

  // Stores pairs of pointers that are likely to be exactly equal
  // at runtime.
  std::set<std::pair<Value *, Value *>> ptrPairsToEqualityCheck;

  AliasInstrumentationContext(Region *r) : region(r) {}

  void addMemoryAccess(Value *basePtr, Instruction *inst, const SCEV *scev) {
    BasePtrInfo& info = memAccesses[basePtr];

    info.users.insert(inst);
    info.accessFunctions.insert(scev);
  }

  // Builds a map containing the artificially created BE counts.
  std::map<const Loop *, const SCEV *> getBECountsMap() {
    std::map<const Loop *, const SCEV *> counts;

    for (auto &pair : artificialBECounts)
      counts.emplace(pair.first, pair.second.count);

    return counts;
  }

  friend struct RegionAliasInfoBuilder;
};

void findAliasInstrumentableRegions(
    Region *region,
    ScalarEvolution *se,
    AliasAnalysis *aa,
    SpeculativeAliasAnalysis *saa,
    LoopInfo *li,
    DominatorTree *dt,
    const AliasCheckFlags& flags,
    std::vector<std::unique_ptr<AliasInstrumentationContext>>& out
);

/// Create single entry and exit EDGES in a region (thus creating entering and
/// exiting blocks).
void simplifyRegion(Region *r, LoopInfo *li);

} // end namespace polly

#endif // POLLY_RegionAliasInfo_H
