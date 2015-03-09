//===------------- SCEVRangeBuilder.cpp -------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/StringExtras.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/TypeBuilder.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

#include "polly/SCEVRangeBuilder.h"
#include "polly/ScopDetection.h"
#include "polly/Support/ScopHelper.h"
#include "polly/CloneRegion.h"

using namespace llvm;
using namespace polly;

#define DEBUG_TYPE "polly-scev-range-analyser"

Value* SCEVRangeBuilder::getSavedExpression(const SCEV *S,
                                             Instruction *InsertPt, bool upper) {
  std::map<std::tuple<const SCEV *, Instruction *, bool>, TrackingVH<Value> >::iterator
    I = InsertedExpressions.find(std::make_tuple(S, InsertPt, upper));
  if (I != InsertedExpressions.end())
    return I->second;

  return NULL;
}

void SCEVRangeBuilder::rememberExpression(const SCEV *S, Instruction *InsertPt,
                                           bool upper, Value *V) {
  InsertedExpressions[std::make_tuple(S, InsertPt, upper)] = V;
}

Value *SCEVRangeBuilder::expand(const SCEV *s, bool upper) {
  // Check expression cache before expansion.
  Instruction *insertPt = getInsertPoint();
  Value *v = getSavedExpression(s, insertPt, upper);

  if (v)
    return v;

  // Remember which bound was computed for the last expression.
  bool oldUpper = currentUpper;

  currentUpper = upper;
  v = visit(s, upper);

  // In analysis mode, V is just a dummy value.
  if (!analysisMode)
    rememberExpression(s, insertPt, upper, v);

  currentUpper = oldUpper;

  return v;
}

Value *SCEVRangeBuilder::visitConstant(const SCEVConstant *constant,
                                        bool upper) {
  return constant->getValue();
}

// If the original value is within an overflow-free range, we simply return
// the truncated bound. If not, we define the bound to be the maximum/minimum
// value the destination bitwidth can assume. The overflow-free range is
// defined as the greatest lower bound and least upper pound among the types
// that the destination bitwidth can represent.
Value *SCEVRangeBuilder::visitTruncateExpr(const SCEVTruncateExpr *expr,
                                            bool upper) {
  Type *dstTy = se->getEffectiveSCEVType(expr->getType());
  Type *srcTy = se->getEffectiveSCEVType(expr->getOperand()->getType());
  Value *bound = expand(expr->getOperand(), upper);

  if (!bound)
    return nullptr;

  bound = InsertNoopCastOfTo(bound, srcTy);

  // Maximum/minimum value guaranteed to be overflow-free after trunc and
  // maximum/minimum value the destination type can assume.
  unsigned dstBW = dstTy->getIntegerBitWidth();
  const APInt &APnoOFLimit = (upper ? APInt::getSignedMaxValue(dstBW) :
                              APInt::getMinValue(dstBW));
  const APInt &APTyLimit = (upper ? APInt::getMaxValue(dstBW) :
                            APInt::getSignedMinValue(dstBW));

  // Build actual bound selection.
  Value *noOFLimit = InsertCast(Instruction::SExt,
                                ConstantInt::get(dstTy, APnoOFLimit), srcTy);
  Value *tyLimit = InsertCast(Instruction::SExt,
                              ConstantInt::get(dstTy, APTyLimit), srcTy);
  Value *icmp = (upper ? InsertICmp(ICmpInst::ICMP_SGT, bound, noOFLimit) :
                 InsertICmp(ICmpInst::ICMP_SLT, bound, noOFLimit));
  Value *sel = InsertSelect(icmp, tyLimit, bound, "sbound");
  Value *inst = InsertCast(Instruction::Trunc, sel, dstTy);

  return inst;
}

// Expand and save the bound of the operand on the expression cache, then
// invloke the expander visitor to generate the actual code.
// - upper_bound: zero_extend (upper_bound(op))
// - lower_bound: zero_extend (lower_bound(op))
Value *SCEVRangeBuilder::visitZeroExtendExpr(const SCEVZeroExtendExpr *expr,
                                              bool upper) {
  if (!expand(expr->getOperand()))
     return nullptr;

  return generateCodeForZeroExtend(expr);
}

// Expand operands here first, to check the existence of their bounds, then
// call the expander visitor to generate the actual code.
// - upper_bound: sext(upper_bound(op))
// - lower_bound: sext(lower_bound(op))
Value *SCEVRangeBuilder::visitSignExtendExpr(const SCEVSignExtendExpr *expr,
                                              bool upper) {
  if (!expand(expr->getOperand()))
    return nullptr;

  return generateCodeForSignExtend(expr);
}

// Simply put all operands on the expression cache and let the expander insert
// the actual instructions.
// - upper_bound: upper_bound(op) + upper_bound(op)
// - lower_bound: lower_bound(op) + lower_bound(op)
Value *SCEVRangeBuilder::visitAddExpr(const SCEVAddExpr *expr, bool upper) {
  for (unsigned i = 0, e = expr->getNumOperands(); i < e; ++i) {
    if (!expand(expr->getOperand(i)))
      return nullptr;
  }

  return generateCodeForAdd(expr);
}

// We only handle the case where one of the operands is a constant (C * %v).
// We do so because that's basically the only case for which we can get
// useful/precise range information.
// - if C >= 0:
//   . upper_bound: C * upper_bound(op2)
//   . lower_bound: C * lower_bound(op2)
// - if C < 0:
//   . upper_bound: C * lower_bound(op2)
//   . lower_bound: C * upper_bound(op2)
Value *SCEVRangeBuilder::visitMulExpr(const SCEVMulExpr *expr, bool upper) {
  if (expr->getNumOperands() != 2)
    return nullptr;

  // If there is a constant, it will be the first operand.
  const SCEVConstant *sc = dyn_cast<SCEVConstant>(expr->getOperand(0));

  if (!sc)
    return nullptr;

  bool invertBounds = sc->getValue()->getValue().isNegative();
  Type *ty = se->getEffectiveSCEVType(expr->getType());
  Value *rhs = expand(expr->getOperand(1), invertBounds ? !upper : upper);

  if (!rhs)
    return nullptr;

  rhs = InsertNoopCastOfTo(rhs, ty);
  Value *scCast = InsertNoopCastOfTo(sc->getValue(), ty);
  return InsertBinop(Instruction::Mul, scCast, rhs);
}

// This code is based on the visitUDiv code from SCEVExpander. We only
// reproduce it here because it involves using mixed bounds to compute a
// single bound.
// - upper_bound: upper_bound(lhs) / lower_bound(rhs)
// - lower_bound: lower_bound(lhs) / upper_bound(rhs)
Value *SCEVRangeBuilder::visitUDivExpr(const SCEVUDivExpr *expr, bool upper) {
  Type *ty = se->getEffectiveSCEVType(expr->getType());
  Value *lhs = expand(expr->getLHS(), upper);

  if (!lhs)
    return nullptr;

  lhs = InsertNoopCastOfTo(lhs, ty);

  if (const SCEVConstant *sc = dyn_cast<SCEVConstant>(expr->getRHS())) {
    const APInt &rhs = sc->getValue()->getValue();
    if (rhs.isPowerOf2())
      return InsertBinop(Instruction::LShr, lhs,
                         ConstantInt::get(ty, rhs.logBase2()));
  }

  Value *rhs = expand(expr->getRHS(), !upper);

  if (!rhs)
    return nullptr;

  rhs = InsertNoopCastOfTo(rhs, ty);

  return InsertBinop(Instruction::UDiv, lhs, rhs);
}

// Compute bounds for an expression of the type {%start, +, %step}<%loop>.
// - upper: upper(%start) + upper(%step) * upper(backedge_taken(%loop))
// - lower_bound: lower_bound(%start)
Value *SCEVRangeBuilder::visitAddRecExpr(const SCEVAddRecExpr *expr,
                                          bool upper) {
  // lower.
  if (!upper)
    return expand(expr->getStart(), /*upper*/ false);

  // upper.
  // Cast all values to the effective start value type.
  Type *opTy = se->getEffectiveSCEVType(expr->getStart()->getType());
  const SCEV *startSCEV = se->getTruncateOrSignExtend(expr->getStart(), opTy);
  const SCEV *stepSCEV = se->getTruncateOrSignExtend(expr->getStepRecurrence(*se),
                                             opTy);
  const SCEV *bEdgeCountSCEV;
  const Loop *l = expr->getLoop();

  // Try to compute a symbolic limit for the loop iterations, so we can fix a
  // bound for a recurrence over it. If a BE count limit is not available for
  // the loop, check if an artificial limit was provided for it.
  if (se->hasLoopInvariantBackedgeTakenCount(l))
    bEdgeCountSCEV = se->getBackedgeTakenCount(l);
  else if (artificialBECounts.count(l))
    bEdgeCountSCEV = artificialBECounts[l];
  else
    return nullptr;

  bEdgeCountSCEV = se->getTruncateOrSignExtend(bEdgeCountSCEV, opTy);
  Value *start = expand(startSCEV, upper);
  Value *step = expand(stepSCEV, upper);
  Value *bEdgeCount = expand(bEdgeCountSCEV, upper);

  if (!start || !step || !bEdgeCount)
    return nullptr;

  // Build the actual computation.
  start = InsertNoopCastOfTo(start, opTy);
  Value *mul = InsertBinop(Instruction::Mul, step, bEdgeCount);
  Value *bound = InsertBinop(Instruction::Add, start, mul);

  // From this point on, we already know this bound can be computed.
  if (analysisMode)
    return DUMMY_VAL;

  // Convert the result back to the original type if needed.
  Type *ty = se->getEffectiveSCEVType(expr->getType());
  const SCEV *boundCast = se->getTruncateOrSignExtend(se->getUnknown(bound), ty);
  return expand(boundCast, upper);
}

// Simply expand all operands and save them on the expression cache. We then
// call the base expander to build the final expression. This is done so we
// can check that all operands have computable bounds before we build the
// actual instructions.
// - upper_bound: umax(upper_bound(op_1), ... upper_bound(op_N))
// - lower_bound: umax(lower_bound(op_1), ... lower_bound(op_N))
Value *SCEVRangeBuilder::visitUMaxExpr(const SCEVUMaxExpr *expr, bool upper) {
  for (unsigned i = 0, e = expr->getNumOperands(); i < e; ++i) {
    if (!expand(expr->getOperand(i)))
      return nullptr;
  }

  return generateCodeForUMax(expr);
}

// Simply expand all operands and save them on the expression cache. We then
// call the base expander to build the final expression. This is done so we
// can check that all operands have computable bounds before we build the
// actual instructions.
// - upper_bound: max(upper_bound(op_1), ... upper_bound(op_N))
// - lower_bound: max(lower_bound(op_1), ... lower_bound(op_N))
Value *SCEVRangeBuilder::visitSMaxExpr(const SCEVSMaxExpr *expr, bool upper) {
  for (unsigned i = 0, e = expr->getNumOperands(); i < e; ++i) {
    if (!expand(expr->getOperand(i)))
      return nullptr;
  }

  return generateCodeForSMax(expr);
}

// The bounds of a generic value are the value itself.
Value *SCEVRangeBuilder::visitUnknown(const SCEVUnknown *expr, bool upper) {
  Value *val = expr->getValue();
  Instruction *inst = dyn_cast<Instruction>(val);
  BasicBlock::iterator insertPt = getInsertPoint();

  // The value must be a region parameter.
  if (!ScopDetection::isInvariant(*val, *r, li, aa))
    return nullptr;

  // To be used in range computation, the instruction must be available at the
  // insertion point.
  if (inst && !dt->dominates(inst, insertPt))
    return nullptr;

  return val;
}

Value *SCEVRangeBuilder::generateCodeForAdd(const SCEVAddExpr *expr) {
  return analysisMode ? DUMMY_VAL : SCEVExpander::visitAddExpr(expr);
}

Value *SCEVRangeBuilder::generateCodeForZeroExtend(const SCEVZeroExtendExpr *expr) {
  return analysisMode ? DUMMY_VAL : SCEVExpander::visitZeroExtendExpr(expr);
}

Value *SCEVRangeBuilder::generateCodeForSignExtend(const SCEVSignExtendExpr *expr) {
  return analysisMode ? DUMMY_VAL : SCEVExpander::visitSignExtendExpr(expr);
}

Value *SCEVRangeBuilder::generateCodeForSMax(const SCEVSMaxExpr *expr) {
  return analysisMode ? DUMMY_VAL : SCEVExpander::visitSMaxExpr(expr);
}

Value *SCEVRangeBuilder::generateCodeForUMax(const SCEVUMaxExpr *expr) {
  return analysisMode ? DUMMY_VAL : SCEVExpander::visitUMaxExpr(expr);;
}

Value *SCEVRangeBuilder::InsertBinop(Instruction::BinaryOps op, Value *lhs,
                                     Value *rhs) {
  return analysisMode ? DUMMY_VAL : SCEVExpander::InsertBinop(op, lhs, rhs);
}

Value *SCEVRangeBuilder::InsertCast(Instruction::CastOps op, Value *v,
                                    Type *destTy) {
  return analysisMode ? DUMMY_VAL : SCEVExpander::InsertCast(op, v, destTy);
}

Value *SCEVRangeBuilder::InsertICmp(CmpInst::Predicate p, Value *lhs,
                                    Value *rhs) {
  return analysisMode ? DUMMY_VAL : SCEVExpander::InsertICmp(p, lhs, rhs);
}

Value *SCEVRangeBuilder::InsertSelect(Value *v, Value *_true, Value *_false,
                                      const Twine &name) {
  return analysisMode ? DUMMY_VAL : SCEVExpander::InsertSelect(v, _true, _false,
                                                               name);
}

Value *SCEVRangeBuilder::InsertNoopCastOfTo(Value *v, Type *ty) {
  return analysisMode ? DUMMY_VAL : SCEVExpander::InsertNoopCastOfTo(v, ty);
}

// Generates the final bound by building a chain of either UMin or UMax
// operations on the bounds of each expression in the list.
// - lower_bound: umin(exprN, umin(exprN-1, ... umin(expr2, expr1)))
// - upper_bound: umax(exprN, umax(exprN-1, ... umax(expr2, expr1)))
Value *SCEVRangeBuilder::getULowerOrUpperBound(
                                         const std::set<const SCEV *> &exprList,
                                         bool upper) {
  if (exprList.size() < 1)
    return nullptr;

  auto it = exprList.begin();
  Value *bestBound = expand(*it, upper);
  ++it;

  if (!bestBound)
    return nullptr;

  for (auto end = exprList.end(); it != end; ++it) {
    Value *newBound = expand(*it, upper);

    if (!newBound)
      return nullptr;

    // The old bound is promoted on type conflicts.
    if (bestBound->getType() != newBound->getType())
      bestBound = InsertNoopCastOfTo(bestBound, newBound->getType());

    auto cmpKind = upper ? ICmpInst::ICMP_UGT : ICmpInst::ICMP_ULT;
    auto name    = upper ? "umax" : "umin";

    auto cmp = InsertICmp(cmpKind, newBound, bestBound);

    bestBound = InsertSelect(cmp, newBound, bestBound, name);
  }

  return bestBound;
}

Value *SCEVRangeBuilder::getULowerBound(
                                       const std::set<const SCEV *> &exprList) {
  return getULowerOrUpperBound(exprList, /*upper*/false);
}

Value *SCEVRangeBuilder::getUUpperBound(
                                       const std::set<const SCEV *> &exprList) {
  return getULowerOrUpperBound(exprList, /*upper*/true);
}

bool SCEVRangeBuilder::canComputeBoundsFor(const std::set<const SCEV *>
                                           &exprList) {
  bool canComputeBounds = true;

  // Avoid instruction insertion.
  setAnalysisMode(true);

  // Try to compute both bounds for each expression.
  for (auto expr : exprList) {
    if (!expand(expr, /*upper*/false) || !expand(expr, /*upper*/true)) {
      canComputeBounds = false;
      break;
    }
  }

  setAnalysisMode(false);
  return canComputeBounds;
}

