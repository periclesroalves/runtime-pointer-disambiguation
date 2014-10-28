//===------------- AliasInstrumenter.h --------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// Utilities for generating symbolic bounds for a Scalar Evolution expression
// and instrumenting a program with dynamic alias checks.
//===----------------------------------------------------------------------===//

#ifndef POLLY_ALIAS_INSTRUMENTER_H
#define POLLY_ALIAS_INSTRUMENTER_H

#include "llvm/Analysis/AliasSetTracker.h"
#include "llvm/Analysis/RegionInfo.h"
#include "llvm/Analysis/ScalarEvolutionExpander.h"
#include "llvm/IR/Module.h"

using namespace llvm;

namespace llvm {
class ScalarEvolution;
class AliasAnalysis;
class SCEV;
class Value;
class Region;
class Instruction;
class LoopInfo;
}

namespace polly {
class ScopDetection;
class DetectionContext;

// Utility for computing Value objects corresponding to the lower and upper
// bounds of a SCEV within a region R. The generated values are inserted into
// the region entry. The resulting expressions can then be filled with runtime
// values, in order to dynamically compute the exact bounds. Bounds are only
// provided if they can be computed right before the region start, i.e., all
// values in the SCEV are region invariant or vary in a well-behaved way.
class SCEVRangeAnalyser : private SCEVExpander {
  friend class AliasInstrumenter;

  const ScopDetection *sd;
  ScalarEvolution *se;
  Region *r;
  bool currentUpper; // Which bound is currently being extracted. Used mainly
                      // by methods of SCEVExpander, which are not aware of
                      // bounds computation.
  std::map<std::tuple<const SCEV *, Instruction *, bool>, TrackingVH<Value> >
    InsertedExpressions; // Saved expressions for reuse.

  // If the caller doesn't specify which bound to compute, we assume the same of
  // the last expanded expression. Usually called by methods defined in
  // SCEVExpander.
  Value *expand(const SCEV *s) {return expand(s, currentUpper);}

  // Main entry point for expansion.
  Value *expand(const SCEV *s, bool upper);

  Value* getSavedExpression(const SCEV *S, Instruction *InsertPt, bool upper);
  void rememberExpression(const SCEV *S, Instruction *InsertPt, bool upper,
                          Value *V);

  // We need to overwrite this method so the most specialized visit methods are
  // called before the visitors on SCEVExpander.
  Value *visit(const SCEV *s, bool upper) {
    switch (s->getSCEVType()) {
      case scConstant:
        return visitConstant((const SCEVConstant*)s, upper);
      case scTruncate:
        return visitTruncateExpr((const SCEVTruncateExpr*)s, upper);
      case scZeroExtend:
        return visitZeroExtendExpr((const SCEVZeroExtendExpr*)s, upper);
      case scSignExtend:
        return visitSignExtendExpr((const SCEVSignExtendExpr*)s, upper);
      case scAddExpr:
        return visitAddExpr((const SCEVAddExpr*)s, upper);
      case scMulExpr:
        return visitMulExpr((const SCEVMulExpr*)s, upper);
      case scUDivExpr:
        return visitUDivExpr((const SCEVUDivExpr*)s, upper);
      case scAddRecExpr:
        return visitAddRecExpr((const SCEVAddRecExpr*)s, upper);
      case scSMaxExpr:
        return visitSMaxExpr((const SCEVSMaxExpr*)s, upper);
      case scUMaxExpr:
        return visitUMaxExpr((const SCEVUMaxExpr*)s, upper);
      case scUnknown:
        return visitUnknown((const SCEVUnknown*)s, upper);
      case scCouldNotCompute:
        return nullptr;
      default:
        llvm_unreachable("Unknown SCEV type!");
    }
  }

  Value *visitConstant(const SCEVConstant *constant, bool upper);
  Value *visitTruncateExpr(const SCEVTruncateExpr *expr, bool upper);
  Value *visitZeroExtendExpr(const SCEVZeroExtendExpr *expr, bool upper);
  Value *visitSignExtendExpr(const SCEVSignExtendExpr *expr, bool upper);
  Value *visitAddExpr(const SCEVAddExpr *expr, bool upper);
  Value *visitMulExpr(const SCEVMulExpr *expr, bool upper);
  Value *visitUDivExpr(const SCEVUDivExpr *expr, bool upper);
  Value *visitAddRecExpr(const SCEVAddRecExpr *expr, bool upper);
  Value *visitUMaxExpr(const SCEVUMaxExpr *expr, bool upper);
  Value *visitSMaxExpr(const SCEVSMaxExpr *expr, bool upper);
  Value *visitUnknown(const SCEVUnknown *expr, bool upper);

  // Generates the lower or upper bound for a set of unsigned expressions.
  Value *getULowerOrUpperBound(std::set<const SCEV *> &exprList, bool upper);

  void insertPtrPrintf(Value *val);

public:
  SCEVRangeAnalyser(ScalarEvolution *se, const ScopDetection *sd, Region *r,
                    Instruction *insertPtr)
    : SCEVExpander(*se, "scevrange"), sd(sd), se(se), r(r),
      currentUpper(true) {
    SetInsertPoint(insertPtr);
  }

  // Returns the minimum value an SCEV can assume.
  Value *getLowerBound(const SCEV *s) {
    return expand(s, /*upper*/false);
  }

  // Returns the maximum value an SCEV can assume.
  Value *getUpperBound(const SCEV *s) {
    return expand(s, /*upper*/true);
  }

  // Generate the smallest lower bound and greatest upper bound for a set of
  // expressions. All expressions are assumed to be type consistent (all of the
  // same type) and produce an unsigned result.
  Value *getULowerBound(std::set<const SCEV *> &exprList);
  Value *getUUpperBound(std::set<const SCEV *> &exprList);
};

class AliasInstrumenter {
  typedef IRBuilder<true, TargetFolder> BuilderType;

  ScalarEvolution *se;
  const ScopDetection *sd;
  AliasAnalysis *aa;
  LoopInfo *li;
  std::vector<std::pair<Value *, Region *> > insertedChecks;

  // Inserts a dynamic test to guarantee that accesses to two pointers do not
  // overlap, given their access ranges.
  Value *insertCheck(std::pair<Value *, Value *> boundsA,
                     std::pair<Value *, Value *> boundsB,
                     BuilderType &builder, SCEVRangeAnalyser &rangeAnalyser);

  // Chain all checks to a single result value using "and" operations.
  Value *chainChecks(std::vector<Value *> checks, BuilderType &builder);

public:
  AliasInstrumenter() {}

  AliasInstrumenter(ScalarEvolution *se, const ScopDetection *sd,
                    AliasAnalysis *aa, LoopInfo *li)
    : se(se), sd(sd), aa(aa), li(li) {}

  // Check for dependencies within the current region, generating dynamic alias
  // checks for all pointers that can't be solved statically. Returns true if
  // all dependecies could be solved.
  bool checkAndSolveDependencies(Region *r);

  // Return the set of dynamic checks generated while solving dependencies (a
  // single value per region). Each value indicates, at runtime, if the region
  // is free of dependencies.
  std::vector<std::pair<Value *, Region *> > &getInsertedChecks() {
    return insertedChecks;
  }

  // The structure of a region can't be changed while instrumenting it. This
  // method fix the structure of the instrumented regions by simplifying them
  // and isolating the checks in a new entering block.
  void fixInstrumentedRegions();
};
} // end namespace polly

#endif
