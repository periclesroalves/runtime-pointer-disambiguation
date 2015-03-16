//===------------- AliasChecks.h --------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Helper classes for creating various kinds of runtime alias checks.
//
//===----------------------------------------------------------------------===//

#ifndef POLLY_ALIAS_CHECKS_H
#define POLLY_ALIAS_CHECKS_H

#include <llvm/Analysis/TargetFolder.h>
#include <llvm/IR/IRBuilder.h>
#include <polly/SCEVRangeBuilder.h>
#include <polly/RegionAliasInfo.h>
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

using ValuePair = std::pair<Value*, Value*>;

// Builds no-alias checks using SCEV based range analysis
class RangeCheckBuilder {
public:
  typedef IRBuilder<true, TargetFolder> BuilderType;

  RangeCheckBuilder(
      SCEVRangeBuilder& rangeBuilder,
      BuilderType& builder,
      AliasInstrumentationContext& ctx)
  : rangeBuilder(rangeBuilder)
  , builder(builder)
  , memAccesses(ctx.memAccesses)
  {}

  // Inserts a dynamic test to guarantee that accesses to two pointers do not
  // overlap in a specific region, given their access ranges.
  // E.g.: %pair-no-alias = upper(A) < lower(B) || upper(B) < lower(A)
  Value *buildRangeCheck(Value *a, Value *b);

  // Inserts a dynamic test to guarantee that accesses to a pointer do not alias
  // a specific address within the region, given the pointer range and the
  // symbolic address.
  // E.g.: %loc-no-alias = upper(A) < B || B < lower(A)
  Value* buildLocationCheck(Value *a, Value *addrB);
private:
  ValuePair buildSCEVBounds(Value *basePtr);

  SCEVRangeBuilder&                             rangeBuilder;
  BuilderType&                                  builder;
  AliasInstrumentationContext::MemoryAccessMap& memAccesses;
  std::map<Value *, ValuePair>                  boundsCache;
};

// Builds no-alias checks using shadow-memory pointer metadata
class HeapCheckBuilder {
public:
  typedef IRBuilder<true, TargetFolder> BuilderType;

  HeapCheckBuilder(BuilderType&   builder,
                   BasicBlock*    enteringBlock,
                   Function*      getPtrId)
  : builder(builder)
  , enteringBlock(enteringBlock)
  , getPtrId(getPtrId)
  {}

  Value *buildCheck(Value *a, Value *b);
private:
  Value *buildGetPtrIdCall(Value *ptr);

  BuilderType&     builder;
  BasicBlock*      enteringBlock;
  Function*        getPtrId;
  std::map<Value*, Instruction*> ptrIdCache;
};

// Builds must-alias checks using pointer equality
class EqualityCheckBuilder {
public:
  typedef IRBuilder<true, TargetFolder> BuilderType;

  EqualityCheckBuilder(BuilderType& builder)
  : builder(builder)
  {}

  Value *buildCheck(Value *a, Value *b);
private:
  Value *buildCmp(Value *setRepresentative, Value *ptr, Value *chain);

  // non-empty set of must alias pointers
  struct MustAliasSet {
    using iterator = std::set<Value*>::iterator;

    MustAliasSet(Value *v) : representative(v) {
      pointers.insert(v);
    }

    bool count(Value *v) {
      return pointers.count(v);
    }

    void insert(Value *v) {
      pointers.insert(v);
    }

    // return some pointer from the set
    Value *getSomePointer() { return representative; }

    iterator begin() { return pointers.begin(); }
    iterator end()   { return pointers.end(); }
  private:
    MustAliasSet(const MustAliasSet&) = delete;

    Value           *representative;
    std::set<Value*> pointers;
  };

  // manages non-overlapping sets of must-alias poitners.
  struct MustAliasSets {
    using SetList  = std::list<MustAliasSet>;
    using iterator = SetList::iterator;

    // inserts two must-alias pointers and returns their must-alias set
    MustAliasSet& getSetFor(Value *a, Value *b) {
      auto& set = getSetFor(a);
      set.insert(b);

      return set;
    }

    MustAliasSet& getSetFor(Value *v) {
      for (auto& set : sets) {
        if (set.count(v))
          return set;
      }

      // create new singleton set containing v
      iterator it = sets.emplace(sets.end(), v);

      return *it;
    }

    iterator begin() { return sets.begin(); }
    iterator end() { return sets.end(); }
  private:
    SetList sets;
  };

  BuilderType&  builder;
  MustAliasSets sets;
};

} // end namespace polly


#endif // POLLY_ALIAS_CHECKS_H
