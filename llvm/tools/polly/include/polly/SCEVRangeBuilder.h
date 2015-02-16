//===------------- SCEVRangeBuilder.h ---------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
// Utility for computing Value objects corresponding to the lower and upper
// bounds of a SCEV within a region R. The resulting expressions can be filled
// with runtime values, in order to dynamically compute the exact bounds. Bounds
// are only provided if they can be computed right before the region start,
// i.e., all values in the SCEV are region invariant or vary in a well-behaved
// way.
//===----------------------------------------------------------------------===//

#ifndef POLLY_SCEV_RANGE_ANALYSER_H
#define POLLY_SCEV_RANGE_ANALYSER_H 1

#include "llvm/Transforms/Utils/FullInstNamer.h"
#include "llvm/Analysis/AliasSetTracker.h"
#include "llvm/Analysis/RegionInfo.h"
#include "llvm/Analysis/ScalarEvolutionExpander.h"
#include "llvm/IR/Module.h"
#include <map>
#include <set>

namespace llvm {
class ScalarEvolution;
class AliasAnalysis;
class DominatorTree;
class SCEV;
class Value;
class Region;
class Instruction;
class LoopInfo;
}

namespace polly {

using namespace llvm;

class DetectionContext;

class SCEVRangeBuilder : private SCEVExpander {
  friend class SCEVAliasInstrumenter;

  ScalarEvolution *se;
  AliasAnalysis *aa;
  LoopInfo *li;
  DominatorTree *dt;
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

  // Find detailed description for each method at their implementation headers.
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

  // Generates the lower or upper bound for a set of unsigned expressions. More
  // details in the method implementation header.
  Value *getULowerOrUpperBound(const std::set<const SCEV *> &exprList,
                              bool upper);

  // DEBUG - generates a printf instruction for the given value at the current
  // insertion point. Uses pointer format.
  void insertPtrPrintf(Value *val);

public:
  SCEVRangeBuilder(ScalarEvolution *se, AliasAnalysis *aa, LoopInfo *li,
      DominatorTree *dt, Region *r, Instruction *insertPtr)
    : SCEVExpander(*se, "scevrange"), se(se), aa(aa), li(li), dt(dt), r(r),
      currentUpper(true) {
    SetInsertPoint(insertPtr);
  }

  static bool canComputeBoundFor(
      const std::set<const SCEV *> &exprList,
      ScalarEvolution              *se,
      AliasAnalysis                *aa,
      LoopInfo                     *li,
      DominatorTree                *dt,
      Region                       *r
  ) {
    for (auto expr : exprList)
      if (!canComputeBoundFor(expr, se, aa, li, dt, r))
        return false;
    return true;
  }

  static bool canComputeBoundFor(
     const SCEV      *expr,
     ScalarEvolution *se,
     AliasAnalysis   *aa,
     LoopInfo        *li,
     DominatorTree   *dt,
     Region          *r
  );

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
  Value *getULowerBound(const std::set<const SCEV *> &exprList);
  Value *getUUpperBound(const std::set<const SCEV *> &exprList);
};

} // end namespace polly

#endif // POLLY_SCEV_RANGE_ANALYSER_H
