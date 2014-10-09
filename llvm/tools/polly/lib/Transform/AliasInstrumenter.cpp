#include "polly/AliasInstrumenter.h"
#include "polly/ScopDetection.h"
#include "llvm/Analysis/RegionInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpander.h"
#include "llvm/Support/Debug.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

using namespace llvm;
using namespace polly;

#define DEBUG_TYPE "polly-alias-instrumenter"


// TODO: avoid inserting duplicated computation.
// Utility for computing Value objects corresponding to the lower and upper
// bounds of a SCEV within a region R. The generated values are inserted into
// the region entry. The resulting expressions can then be filled with runtime
// values, in order to dynamically compute the exact bounds. Bounds are only
// provided if they can be computed right before the region start, i.e., all
// values in the SCEV are region invariant or vary in a well-behaved way.
struct SCEVRangeAnalyser : private SCEVExpander {
private:
  const ScopDetection *sd;
  ScalarEvolution *se;
  Region *r;
  const bool main_upper; // Which bound to extract from the main SCEV. Lower if
                         // false.
  std::map<std::tuple<const SCEV *, Instruction *, bool>, TrackingVH<Value> >
    InsertedExpressions; // Saved expressions for reuse.

  SCEVRangeAnalyser(ScalarEvolution *se, const ScopDetection *sd, Region *r,
                    const bool main_upper)
    : SCEVExpander(*se, "scevrange"), sd(sd), se(se), r(r),
      main_upper(main_upper) {
    SetInsertPoint(r->getEntry(), r->getEntry()->begin());
  }

  Value* getSavedExpression(const SCEV *S, Instruction *InsertPt,
                                          bool upper) {
    std::map<std::tuple<const SCEV *, Instruction *, bool>, TrackingVH<Value> >::iterator
      I = InsertedExpressions.find(std::make_tuple(S, InsertPt, upper));
    if (I != InsertedExpressions.end())
      return I->second;
  
    return NULL;
  }
 
  void rememberExpression(const SCEV *S, Instruction *InsertPt, bool upper,
                                        Value *V) {
    InsertedExpressions[std::make_tuple(S, InsertPt, upper)] = V;
  }

  // If the caller doesn't specify which bound to compute, we assume the same of
  // the main expression. Usually called by methods defined in SCEVExpander.
  Value *expand(const SCEV *s) {return expand(s, main_upper);}
  Value *visit(const SCEV *s) {return visit(s, main_upper);}

  // TODO: like in SCEVExpander, here should come best insertion-point
  // computation.
  // Check expression cache before expansion.
  Value *expand(const SCEV *s, bool upper) {
    Instruction *insertPt = getInsertPoint();
    Value *v = getSavedExpression(s, insertPt, upper);

    if (v)
      return v;
  
    v = visit(s, upper);
    rememberExpression(s, insertPt, upper, v);
    return v;
  }

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

  Value *visitConstant(const SCEVConstant *constant, bool upper) {
    return constant->getValue();
  }

  // If the original value is within an overflow-free range, we simply return
  // the truncated bound. If not, we define the bound to be the maximum/minimum
  // value the destination bitwidth can assume. The overflow-free range is
  // defined as the greatest lower bound and least upper pound among the types
  // that the destination bitwidth can represent.
  Value *visitTruncateExpr(const SCEVTruncateExpr *expr, bool upper) {
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
    Value *noOFLimit = Builder.CreateSExt(ConstantInt::get(dstTy, APnoOFLimit),
                                          srcTy);
    rememberInstruction(noOFLimit);
    Value *tyLimit = Builder.CreateSExt(ConstantInt::get(dstTy, APTyLimit),
                                        srcTy);
    rememberInstruction(tyLimit);
    Value *icmp = (upper ? Builder.CreateICmpSGT(bound, noOFLimit) :
                   Builder.CreateICmpSLT(bound, noOFLimit));
    rememberInstruction(icmp);
    Value *sel = Builder.CreateSelect(icmp, tyLimit, bound, "sbound");
    rememberInstruction(sel);
    Value *inst = Builder.CreateTrunc(sel, dstTy);
    rememberInstruction(inst);

    return inst;
  }
  
  // Expand and save the bound of the operand on the expression cache, then
  // invloke the expander visitor to generate the actual code.
  // - upper_bound: zero_extend (upper_bound(op))
  // - lower_bound: zero_extend (lower_bound(op))
  Value *visitZeroExtendExpr(const SCEVZeroExtendExpr *expr, bool upper) {
    if (!expand(expr->getOperand()))
       return nullptr;

    return SCEVExpander::visitZeroExtendExpr(expr);
  }

  // Expand operands here first, to check the existence of their bounds, then
  // call the expander visitor to generate the actual code.
  // - upper_bound: sext(upper_bound(op))
  // - lower_bound: sext(lower_bound(op))
  Value *visitSignExtendExpr(const SCEVSignExtendExpr *expr, bool upper) {
    if (!expand(expr->getOperand()))
      return nullptr;

    return SCEVExpander::visitSignExtendExpr(expr);
  }
 
  // Simply put all operands on the expression cache and let the expander insert
  // the actual instructions.
  // - upper_bound: upper_bound(op) + upper_bound(op)
  // - lower_bound: lower_bound(op) + lower_bound(op)
  Value *visitAddExpr(const SCEVAddExpr *expr, bool upper) {
    for (unsigned i = 0, e = expr->getNumOperands(); i < e; ++i) {
      if (!expand(expr->getOperand(i)))
        return nullptr;
    }

    return SCEVExpander::visitAddExpr(expr);
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
  Value *visitMulExpr(const SCEVMulExpr *expr, bool upper) {
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
  Value *visitUDivExpr(const SCEVUDivExpr *expr, bool upper) {
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
  // - upper: upper(%start) + upper(%step) * (upper(backedge_taken(%loop))+1)
  // - lower_bound: lower_bound(%start)
  Value *visitAddRecExpr(const SCEVAddRecExpr *expr, bool upper) {
    // lower.
    if (!upper)
      return expand(expr->getStart(), upper);

    // upper.
    // Cast all values to the effective start value type.
    Type *opTy = se->getEffectiveSCEVType(expr->getStart()->getType());
    const SCEV *startSCEV = se->getTruncateOrSignExtend(expr->getStart(), opTy);
    const SCEV *stepSCEV = se->getTruncateOrSignExtend(expr->getStepRecurrence(*se),
                                               opTy);
    const SCEV *bEdgeCountSCEV =
      se->getTruncateOrSignExtend(se->getBackedgeTakenCount(expr->getLoop()), opTy);

    Value *start = expand(startSCEV, upper);
    Value *step = expand(stepSCEV, upper);
    Value *bEdgeCount = expand(bEdgeCountSCEV, upper);

    if (!start || !step || !bEdgeCount)
      return nullptr;

    // Build the actual computation.
    start = InsertNoopCastOfTo(start, opTy);
    Value *inc = Builder.CreateAdd(bEdgeCount, ConstantInt::get(opTy, 1));
    rememberInstruction(inc);
    Value *mul = Builder.CreateMul(step, inc);
    rememberInstruction(mul);
    Value *bound = Builder.CreateAdd(start, mul);
    rememberInstruction(bound);

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
  Value *visitUMaxExpr(const SCEVUMaxExpr *expr, bool upper) {
    for (unsigned i = 0, e = expr->getNumOperands(); i < e; ++i) {
      if (!expand(expr->getOperand(i)))
        return nullptr;
    }

    return SCEVExpander::visitUMaxExpr(expr);
  }

  // Simply expand all operands and save them on the expression cache. We then
  // call the base expander to build the final expression. This is done so we
  // can check that all operands have computable bounds before we build the
  // actual instructions.
  // - upper_bound: max(upper_bound(op_1), ... upper_bound(op_N))
  // - lower_bound: max(lower_bound(op_1), ... lower_bound(op_N))
  Value *visitSMaxExpr(const SCEVSMaxExpr *expr, bool upper) {
    for (unsigned i = 0, e = expr->getNumOperands(); i < e; ++i) {
      if (!expand(expr->getOperand(i)))
        return nullptr;
    }

    return SCEVExpander::visitSMaxExpr(expr);
  }
 
  // The bounds of a generic value are the value itself, if it is region
  // invariant, i.e., a region parameter.
  Value *visitUnknown(const SCEVUnknown *expr, bool upper) {
    Value *val = expr->getValue();

    if (!sd->isInvariant(*val, *r))
      return nullptr;

    return val;
  }

public:
  // Returns the maximum value an SCEV can assume.
  static Value *generateUpperBound(ScalarEvolution *se, const ScopDetection *sd,
                                   Region *r, const SCEV *s) {
    SCEVRangeAnalyser analyser(se, sd, r, /*upper*/true);
    return analyser.expand(s);
  }

  // Returns the minimum value an SCEV can assume.
  static Value *generateLowerBound(ScalarEvolution *se, const ScopDetection *sd,
                                   Region *r, const SCEV *s) {
    SCEVRangeAnalyser analyser(se, sd, r, /*upper*/false);
    return analyser.expand(s);
  }
};

namespace polly {
Value *generateSCEVUpperBound(ScalarEvolution *se, const ScopDetection *sd,
                              Region *r, const SCEV *s) {
  return SCEVRangeAnalyser::generateUpperBound(se, sd, r, s);
}

Value *generateSCEVLowerBound(ScalarEvolution *se, const ScopDetection *sd,
                              Region *r, const SCEV *s) {
  return SCEVRangeAnalyser::generateLowerBound(se, sd, r, s);
}
}
