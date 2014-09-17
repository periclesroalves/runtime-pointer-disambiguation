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
  const bool upper; // Which bound to extract. Lower if false.

  SCEVRangeAnalyser(ScalarEvolution *se, const ScopDetection *sd, Region *r,
                    const bool upper)
    : SCEVExpander(*se, "scevrange"), sd(sd), se(se), r(r), upper(upper) {
    BasicBlock *insertionBlock = getInsertionBlock();
    SetInsertPoint(insertionBlock, insertionBlock->begin());
  }

  // TODO: take care to do not insert duplicated range computations.
  // Guarantees that the region entry, a.k.a. the insertion block, has a single
  // successor. This separates range computation from actual region code.
  BasicBlock *getInsertionBlock() {
    BasicBlock *entry = r->getEntry();

    if (entry->getTerminator()->getNumSuccessors() == 1)
      SplitBlock(entry, entry->begin(), se);

    return entry;
  }

  // TODO: like in SCEVExpander, here should come best insertion-point
  // computation.
  // TODO: check what happens when NULL is returned to a visit() method of
  // SCEVExpander.
  Value *expand(const SCEV *s) {
    // Check to see if we already expanded this expression.
    Instruction *insertPt = getInsertPoint();
    Value *v = getSavedExpression(s, insertPt);
  
    if (v)
      return v;
  
    v = visit(s);
    rememberExpression(s, insertPt, v);
    return v;
  }

  // We need to overwrite this method so the most specialized visit methods are
  // called before the visitors on SCEVExpander.
  Value *visit(const SCEV *s) {
    switch (s->getSCEVType()) {
      case scConstant:
        return visitConstant((const SCEVConstant*)s);
      case scTruncate:
        return visitTruncateExpr((const SCEVTruncateExpr*)s);
      case scZeroExtend:
        return visitZeroExtendExpr((const SCEVZeroExtendExpr*)s);
      case scSignExtend:
        return visitSignExtendExpr((const SCEVSignExtendExpr*)s);
      case scAddExpr:
        return visitAddExpr((const SCEVAddExpr*)s);
      case scMulExpr:
        return visitMulExpr((const SCEVMulExpr*)s);
      case scUDivExpr:
        return visitUDivExpr((const SCEVUDivExpr*)s);
      case scAddRecExpr:
        return visitAddRecExpr((const SCEVAddRecExpr*)s);
      case scSMaxExpr:
        return visitSMaxExpr((const SCEVSMaxExpr*)s);
      case scUMaxExpr:
        return visitUMaxExpr((const SCEVUMaxExpr*)s);
      case scUnknown:
        return visitUnknown((const SCEVUnknown*)s);
      case scCouldNotCompute:
        return visitCouldNotCompute((const SCEVCouldNotCompute*)s);
      default:
        llvm_unreachable("Unknown SCEV type!");
    }
  }

  Value *visitConstant(const SCEVConstant *constant) {
    return constant->getValue();
  }
  
  Value *visitTruncateExpr(const SCEVTruncateExpr *expr) {
    // TODO
    return nullptr;
  }
  
  Value *visitZeroExtendExpr(const SCEVZeroExtendExpr *expr) {
    // TODO
    return nullptr;
  }
  
  Value *visitSignExtendExpr(const SCEVSignExtendExpr *expr) {
    // TODO
    return nullptr;
  }
  
  Value *visitAddExpr(const SCEVAddExpr *expr) {
    // TODO
    return nullptr;
  }
  
  Value *visitMulExpr(const SCEVMulExpr *expr) {
    // TODO
    return nullptr;
  }
  
  Value *visitUDivExpr(const SCEVUDivExpr *expr) {
    // TODO
    return nullptr;
  }
  
  Value *visitAddRecExpr(const SCEVAddRecExpr *expr) {
    // TODO
    return nullptr;
  }

  Value *visitUMaxExpr(const SCEVUMaxExpr *expr) {
    // TODO
    return nullptr;
  }

  // TODO: test this method's flow (methods of the right class) and generated code.
  // Simply expand all operands and save them on the expression cache. We then
  // call the base expander to build the final expression. This is done so we
  // can check that all operands have computable bounds before we build the
  // actual instructions.
  // - upper_bound: max(upper_bound(op_1), upper_bound(op_2))
  // - lower_bound: max(lower_bound(op_1), lower_bound(op_2))
  Value *visitSMaxExpr(const SCEVSMaxExpr *expr) {
    Value *lhs = expand(expr->getOperand(expr->getNumOperands()-1));

    if (!lhs)
      return nullptr;

    Type *ty = lhs->getType();

    for (int i = expr->getNumOperands()-2; i >= 0; --i) {
      if (expr->getOperand(i)->getType() != ty)
        ty = se->getEffectiveSCEVType(ty);

      Value *rhs = expandCodeFor(expr->getOperand(i), ty);

      if (!rhs)
        return nullptr;
    }

    return SCEVExpander::visitSMaxExpr(expr);
  }
 
  // The bounds of a generic value are the value itself, if it is region
  // invariant, i.e., a region parameter.
  Value *visitUnknown(const SCEVUnknown *expr) {
    Value *val = expr->getValue();

    if (!sd->isInvariant(*val, *r))
      return nullptr;

    return val;
  }

public:
  // Returns the maximum value an SCEV can assume.
  static Value *generateUpperBound(ScalarEvolution *se, const ScopDetection *sd,
                                   Region *r, const SCEV *s) {
    SCEVRangeAnalyser analyser(se, sd, r, true);
    return analyser.expand(s);
  }

  // Returns the minimum value an SCEV can assume.
  static Value *generateLowerBound(ScalarEvolution *se, const ScopDetection *sd,
                                   Region *r, const SCEV *s) {
    SCEVRangeAnalyser analyser(se, sd, r, false);
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
