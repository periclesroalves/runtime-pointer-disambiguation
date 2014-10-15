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

#include "polly/ScopDetection.h"

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

// TODO: avoid inserting duplicated computation.
// Utility for computing Value objects corresponding to the lower and upper
// bounds of a SCEV within a region R. The generated values are inserted into
// the region entry. The resulting expressions can then be filled with runtime
// values, in order to dynamically compute the exact bounds. Bounds are only
// provided if they can be computed right before the region start, i.e., all
// values in the SCEV are region invariant or vary in a well-behaved way.
struct SCEVRangeAnalyser : private SCEVExpander {
  const ScopDetection *sd;
  ScalarEvolution *se;
  Region *r;
  bool current_upper; // Which bound is currently being extracted. Used mainly
                      // by methods of SCEVExpander, which are not aware of
                      // bounds computation.
  std::map<std::tuple<const SCEV *, Instruction *, bool>, TrackingVH<Value> >
    InsertedExpressions; // Saved expressions for reuse.

  SCEVRangeAnalyser(ScalarEvolution *se, const ScopDetection *sd, Region *r)
    : SCEVExpander(*se, "scevrange"), sd(sd), se(se), r(r),
      current_upper(true) {
    SetInsertPoint(r->getEntry()->getFirstNonPHI());
  }

  // If the caller doesn't specify which bound to compute, we assume the same of
  // the last expanded expression. Usually called by methods defined in
  // SCEVExpander.
  Value *expand(const SCEV *s) {return expand(s, current_upper);}

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

  void insertPrintfForVal(Value *val);

public:
  // Returns the maximum value an SCEV can assume.
  Value *generateUpperBound(const SCEV *s) {
    return expand(s, /*upper*/true);
  }

  // Returns the minimum value an SCEV can assume.
  Value *generateLowerBound(const SCEV *s) {
    return expand(s, /*upper*/false);
  }
};

struct AliasInstrumenter {
  SCEVRangeAnalyser rangeAnalyser;
  AliasSetTracker &ast;
  ScalarEvolution *se;
  LoopInfo *li;
  Region *r;

  AliasInstrumenter(ScalarEvolution *se, const ScopDetection *sd,
      AliasSetTracker &ast, LoopInfo *li, Region *r)
    : rangeAnalyser(se, sd, r), ast(ast), se(se), li(li), r(r) {}

  /// @brief Generate dynamic alias checks for all pointers within the region
  /// for which dependencies can't be solved statically.
  /// 
  /// @return True if all needed checks were inserted, false otherwise.
  bool generateAliasChecks();
};
} // end namespace polly

#endif
