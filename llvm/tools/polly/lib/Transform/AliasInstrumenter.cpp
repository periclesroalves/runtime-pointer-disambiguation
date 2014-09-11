#include "polly/AliasInstrumenter.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/Support/Debug.h"

using namespace llvm;

#define DEBUG_TYPE "polly-alias-instrumenter"


// Utility for computing values corresponding to the lower and upper bounds of
// a SCEV object.
struct SCEVRangeAnalyser : public SCEVVisitor<SCEVRangeAnalyser, Value*> {
private:
  const bool upper; // Which bound to extract. Lower if false.

public:
  SCEVRangeAnalyser(const bool upper) : upper(upper) {}

  // Returns the maximum value an SCEV can assume.
  static Value *getUpperBound(const SCEV *s) {
    SCEVRangeAnalyser analyser(true);
    return analyser.visit(s);
  }

  // Returns the minimum value an SCEV can assume.
  static Value *getLowerBound(const SCEV *s) {
    SCEVRangeAnalyser analyser(false);
    return analyser.visit(s);
  }

  Value *visitConstant(const SCEVConstant *constant) {
    // TODO
    return NULL;
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
  
  Value *visitUnknown(const SCEVUnknown *expr) {
    // TODO
    return NULL;
  }
};

namespace polly {
Value *getSCEVUpperBound(const SCEV *s) {
  return SCEVRangeAnalyser::getUpperBound(s);
}

Value *getSCEVLowerBound(const SCEV *s) {
  return SCEVRangeAnalyser::getLowerBound(s);
}
}
