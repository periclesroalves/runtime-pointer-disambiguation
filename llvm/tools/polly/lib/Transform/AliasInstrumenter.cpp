#include "polly/AliasInstrumenter.h"
#include "polly/ScopDetection.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/Support/Debug.h"

using namespace llvm;
using namespace polly;

#define DEBUG_TYPE "polly-alias-instrumenter"


// Utility for computing Value objects corresponding to the lower and upper
// bounds of a SCEV within a region R. The resulting expressions can then be
// filled with runtime values, in order to dynamically compute the exact
// bounds. Bounds are only provided if they can be computed right before the
// region starts, i.e., all values in the SCEV are region invariant or vary in a
// well-behaved way.
struct SCEVRangeAnalyser : public SCEVVisitor<SCEVRangeAnalyser, Value*> {
private:
  const ScopDetection *sd;
  const Region *r;
  const bool upper; // Which bound to extract. Lower if false.

public:
  SCEVRangeAnalyser(const ScopDetection *sd, const Region *r, const bool upper) : sd(sd), r(r), upper(upper) {}

  // Returns the maximum value an SCEV can assume.
  static Value *getUpperBound(const ScopDetection *sd, const Region *r, const SCEV *s) {
    SCEVRangeAnalyser analyser(sd, r, true);
    return analyser.visit(s);
  }

  // Returns the minimum value an SCEV can assume.
  static Value *getLowerBound(const ScopDetection *sd, const Region *r, const SCEV *s) {
    SCEVRangeAnalyser analyser(sd, r, false);
    return analyser.visit(s);
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
  
  Value *visitSMaxExpr(const SCEVSMaxExpr *expr) {
    // TODO
    return NULL;
  }
  
  Value *visitUMaxExpr(const SCEVUMaxExpr *expr) {
    // TODO
    return NULL;
  }

  // The bounds of a generic value are the value itself, if it is region
  // invariant, i.e., a region parameter.
  Value *visitUnknown(const SCEVUnknown *expr) {
    Value *val = expr->getValue();

    if (!sd->isInvariant(*val, *r))
      return NULL;

    return val;
  }
};

namespace polly {
Value *getSCEVUpperBound(const ScopDetection *sd, const Region *r, const SCEV *s) {
  return SCEVRangeAnalyser::getUpperBound(sd, r, s);
}

Value *getSCEVLowerBound(const ScopDetection *sd, const Region *r, const SCEV *s) {
  return SCEVRangeAnalyser::getLowerBound(sd, r, s);
}
}
