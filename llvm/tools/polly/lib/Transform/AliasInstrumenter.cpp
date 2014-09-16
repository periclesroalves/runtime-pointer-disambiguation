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
// bounds of a SCEV within a region R. The generated values are inserted right
// before the region entry. The resulting expressions can then be filled with
// runtime values, in order to dynamically compute the exact bounds. Bounds are
// only provided if they can be computed right before the region start, i.e.,
// all values in the SCEV are region invariant or vary in a well-behaved way.
struct SCEVRangeAnalyser : private SCEVExpander {
private:
  const ScopDetection *sd;
  ScalarEvolution *se;
  Region *r;
  const bool upper; // Which bound to extract. Lower if false.

  SCEVRangeAnalyser(ScalarEvolution *se, const ScopDetection *sd, Region *r,
                    const bool upper)
    : SCEVExpander(*se, "scevrange"), sd(sd), se(se), r(r), upper(upper) {
    setInsertPoint(getInsertionBlock());
  }

  // TODO: take care to do not insert duplicated range computations.
  // TODO: do not create this block if values were not inserted.
  // Creates a block to insert the values needed for bounds computation, if it
  // doesn't already exist. The new block is inserted right before the entry
  // block of the current region, in the hope that it doesn't affect any
  // region-based analysis that may be going on.
  BasicBlock *getInsertionBlock() {
    BasicBlock *insertionBB = NULL;

    insertionBB = r->getEnteringBlock();

    if (insertionBB)
      return insertionBB;

    // Create a new block.
    BasicBlock *oldEntry = r->getEntry();
    BasicBlock *newEntry = SplitBlock(oldEntry, oldEntry->begin(), se);
    r->replaceEntryRecursive(newEntry);

    return oldEntry;
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

  Value *visitConstant(const SCEVConstant *constant) {
    return constant->getValue();
  }
  
  Value *visitTruncateExpr(const SCEVTruncateExpr *expr) {
    // TODO
    return NULL;
  }
  
  Value *visitZeroExtendExpr(const SCEVZeroExtendExpr *expr) {
    // TODO
    return NULL;
  }
  
  Value *visitSignExtendExpr(const SCEVSignExtendExpr *expr) {
    // TODO
    return NULL;
  }
  
  Value *visitAddExpr(const SCEVAddExpr *expr) {
    // TODO
    return NULL;
  }
  
  Value *visitMulExpr(const SCEVMulExpr *expr) {
    // TODO
    return NULL;
  }
  
  Value *visitUDivExpr(const SCEVUDivExpr *expr) {
    // TODO
    return NULL;
  }
  
  Value *visitAddRecExpr(const SCEVAddRecExpr *expr) {
    // TODO
    return NULL;
  }

  Value *visitUMaxExpr(const SCEVUMaxExpr *expr) {
    // TODO
    return NULL;
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
    Type *ty = lhs->getType();

    if (!lhs)
      return NULL;

    for (int i = expr->getNumOperands()-2; i >= 0; --i) {
      if (expr->getOperand(i)->getType() != ty) {
        ty = se->getEffectiveSCEVType(ty);
      }
      Value *rhs = expandCodeFor(expr->getOperand(i), ty);

      if (!rhs)
        return NULL;
    }

    return SCEVExpander::visitSMaxExpr(expr);
  }
 
  // The bounds of a generic value are the value itself, if it is region
  // invariant, i.e., a region parameter.
  Value *visitUnknown(const SCEVUnknown *expr) {
    Value *val = expr->getValue();

    if (!sd->isInvariant(*val, *r))
      return NULL;

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
