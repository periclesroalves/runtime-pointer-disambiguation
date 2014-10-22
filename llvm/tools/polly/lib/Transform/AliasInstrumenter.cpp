//===------------- AliasInstrumenter.h --------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/Analysis/AliasAnalysis.h"

#include "polly/AliasInstrumenter.h"
#include "polly/Support/ScopHelper.h"

using namespace llvm;
using namespace polly;

#define DEBUG_TYPE "polly-alias-instrumenter"

Value* SCEVRangeAnalyser::getSavedExpression(const SCEV *S,
                                             Instruction *InsertPt, bool upper) {
  std::map<std::tuple<const SCEV *, Instruction *, bool>, TrackingVH<Value> >::iterator
    I = InsertedExpressions.find(std::make_tuple(S, InsertPt, upper));
  if (I != InsertedExpressions.end())
    return I->second;

  return NULL;
}

void SCEVRangeAnalyser::rememberExpression(const SCEV *S, Instruction *InsertPt,
                                           bool upper, Value *V) {
  InsertedExpressions[std::make_tuple(S, InsertPt, upper)] = V;
}

// TODO: like in SCEVExpander, here should come insertion-point computation.
// Main entry point for expansion.
Value *SCEVRangeAnalyser::expand(const SCEV *s, bool upper) {
  // Check expression cache before expansion.
  Instruction *insertPt = getInsertPoint();
  Value *v = getSavedExpression(s, insertPt, upper);

  if (v)
    return v;

  // Remember which bound was computed for the last expression.
  bool old_upper = current_upper;

  current_upper = upper;
  v = visit(s, upper);
  rememberExpression(s, insertPt, upper, v);
  current_upper = old_upper;

  return v;
}

Value *SCEVRangeAnalyser::visitConstant(const SCEVConstant *constant,
                                        bool upper) {
  return constant->getValue();
}

// If the original value is within an overflow-free range, we simply return
// the truncated bound. If not, we define the bound to be the maximum/minimum
// value the destination bitwidth can assume. The overflow-free range is
// defined as the greatest lower bound and least upper pound among the types
// that the destination bitwidth can represent.
Value *SCEVRangeAnalyser::visitTruncateExpr(const SCEVTruncateExpr *expr,
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
  Value *noOFLimit = Builder.CreateSExt(ConstantInt::get(dstTy, APnoOFLimit),
                                        srcTy);
  Value *tyLimit = Builder.CreateSExt(ConstantInt::get(dstTy, APTyLimit),
                                      srcTy);
  Value *icmp = (upper ? Builder.CreateICmpSGT(bound, noOFLimit) :
                 Builder.CreateICmpSLT(bound, noOFLimit));
  Value *sel = Builder.CreateSelect(icmp, tyLimit, bound, "sbound");
  Value *inst = Builder.CreateTrunc(sel, dstTy);

  return inst;
}

// Expand and save the bound of the operand on the expression cache, then
// invloke the expander visitor to generate the actual code.
// - upper_bound: zero_extend (upper_bound(op))
// - lower_bound: zero_extend (lower_bound(op))
Value *SCEVRangeAnalyser::visitZeroExtendExpr(const SCEVZeroExtendExpr *expr,
                                              bool upper) {
  if (!expand(expr->getOperand()))
     return nullptr;

  return SCEVExpander::visitZeroExtendExpr(expr);
}

// Expand operands here first, to check the existence of their bounds, then
// call the expander visitor to generate the actual code.
// - upper_bound: sext(upper_bound(op))
// - lower_bound: sext(lower_bound(op))
Value *SCEVRangeAnalyser::visitSignExtendExpr(const SCEVSignExtendExpr *expr,
                                              bool upper) {
  if (!expand(expr->getOperand()))
    return nullptr;

  return SCEVExpander::visitSignExtendExpr(expr);
}

// Simply put all operands on the expression cache and let the expander insert
// the actual instructions.
// - upper_bound: upper_bound(op) + upper_bound(op)
// - lower_bound: lower_bound(op) + lower_bound(op)
Value *SCEVRangeAnalyser::visitAddExpr(const SCEVAddExpr *expr, bool upper) {
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
Value *SCEVRangeAnalyser::visitMulExpr(const SCEVMulExpr *expr, bool upper) {
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
Value *SCEVRangeAnalyser::visitUDivExpr(const SCEVUDivExpr *expr, bool upper) {
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
Value *SCEVRangeAnalyser::visitAddRecExpr(const SCEVAddRecExpr *expr,
                                          bool upper) {
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
  Value *mul = Builder.CreateMul(step, bEdgeCount);
  Value *bound = Builder.CreateAdd(start, mul);

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
Value *SCEVRangeAnalyser::visitUMaxExpr(const SCEVUMaxExpr *expr, bool upper) {
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
Value *SCEVRangeAnalyser::visitSMaxExpr(const SCEVSMaxExpr *expr, bool upper) {
  for (unsigned i = 0, e = expr->getNumOperands(); i < e; ++i) {
    if (!expand(expr->getOperand(i)))
      return nullptr;
  }

  return SCEVExpander::visitSMaxExpr(expr);
}

// The bounds of a generic value are the value itself, if it is region
// invariant, i.e., a region parameter.
Value *SCEVRangeAnalyser::visitUnknown(const SCEVUnknown *expr, bool upper) {
  Value *val = expr->getValue();

  if (!sd->isInvariant(*val, *r))
    return nullptr;

  return val;
}

// Insert a printf call to print the specified value in a pointer format.
void SCEVRangeAnalyser::insertPtrPrintf(Value *val) {
  Module *module = r->getEntry()->getParent()->getParent();
  LLVMContext& ctx = module->getContext();
  Twine formatVarName = Twine("pointer_format.str");
  GlobalVariable *formatVar = module->getNamedGlobal(formatVarName.str());

  // Declare the format string if it doesn't exist.
  if (!formatVar) {
    Twine formatStr = Twine("%p\n");
    Constant *formatConst = ConstantDataArray::getString(ctx, formatStr.str());
    ArrayType *varTy = ArrayType::get(IntegerType::getInt8Ty(ctx),
                                      formatStr.str().size()+1);
    formatVar = new GlobalVariable(*module, varTy, true,
                                   GlobalValue::PrivateLinkage, formatConst,
                                   formatVarName);
  }

  std::vector<llvm::Constant*> indices;
  Constant *zero = Constant::getNullValue(IntegerType::getInt32Ty(ctx));
  indices.push_back(zero);
  indices.push_back(zero);
  Constant *formatVarRef = ConstantExpr::getGetElementPtr(formatVar, indices);

  // Build the actual call.
  std::vector<Type*> argTypes;
  argTypes.push_back(Type::getInt8PtrTy(ctx));
  FunctionType *fTy = FunctionType::get(Type::getInt32Ty(ctx), argTypes, true);
  Constant *fun = module->getOrInsertFunction("printf", fTy);

  Builder.CreateCall2(cast<Function>(fun), formatVarRef, val, "printf");
}

// Generates the final bound by building a chain of either UMin or UMax
// operations on the bounds of each expression in the list.
// - lower_bound: umin(exprN, umin(exprN-1, ... umin(expr2, expr1)))
// - upper_bound: umax(exprN, umax(exprN-1, ... umax(expr2, expr1)))
Value *SCEVRangeAnalyser::getULowerOrUpperBound(std::set<const SCEV *> &exprList,
                                                bool upper) {
  if (exprList.size() < 1)
    return nullptr;

  std::set<const SCEV *>::iterator it = exprList.begin();
  const SCEV *expr = *it;
  Value *bestBound = expand(expr, upper);

  while (it != exprList.end()) {
    expr = *it;
    Value *newBound = expand(expr, upper);
    Value *cmp;

    if (upper)
      cmp = Builder.CreateICmpUGT(newBound, bestBound);
    else
      cmp = Builder.CreateICmpULT(newBound, bestBound);

    bestBound = Builder.CreateSelect(cmp, newBound, bestBound,
      (upper ? "umax" : "umin"));
    ++it;
  }

  return bestBound;
}

Value *SCEVRangeAnalyser::getULowerBound(std::set<const SCEV *> &exprList) {
  return getULowerOrUpperBound(exprList, /*upper*/false);
}

Value *SCEVRangeAnalyser::getUUpperBound(std::set<const SCEV *> &exprList) {
  return getULowerOrUpperBound(exprList, /*upper*/true);
}

// Generate dynamic alias checks for all pointers within the region for which
// dependencies can't be solved statically.
bool AliasInstrumenter::generateAliasChecks() {
  std::map<const Value *, std::set<const SCEV *> > memAccesses;
  std::set<std::pair<Value *, Value *> > pairsToCheck;

  // Collect, for all memory accesses, their respective base pointer and access
  // function. For the accesses a[i], a[i+5], and b[i+j], we'd have something
  // like:
  // - memAccesses: {a: (i,i+5), b: (i+j)}
  // Also collect all pairs of base pointers that need to be dynamically checked
  // for aliasing. If the pointers a, b, and c may alias each other, we'd have:
  // - pairsToCheck: (<a,b>, <b,c>, <a,c>)
  for (BasicBlock *bb : r->blocks())
    for (BasicBlock::iterator i = bb->begin(), e = --bb->end(); i != e; ++i) {
      Instruction &inst = *i;

      if (!isa<LoadInst>(inst) && !isa<StoreInst>(inst))
        continue;

      Value *ptr = getPointerOperand(inst);
      Loop *l = li->getLoopFor(inst.getParent());
      const SCEV *accessFunction = se->getSCEVAtScope(ptr, l);
      const SCEVUnknown *basePointer =
        dyn_cast<SCEVUnknown>(se->getPointerBase(accessFunction));
      Value *baseValue = basePointer->getValue();

      memAccesses[baseValue].insert(accessFunction);

      // We need checks against all pointers in the May Alias set.
      AliasSet &as =
        ast.getAliasSetForPointer(baseValue, AliasAnalysis::UnknownSize,
                                          inst.getMetadata(LLVMContext::MD_tbaa));

      if (!as.isMustAlias())
        for (const auto &aliasPointer : as) {
          Value *aliasValue = aliasPointer.getValue();

          if (baseValue == aliasValue)
            continue;

          // We only need to check against pointers accessed within the region.
          if (!memAccesses.count(aliasValue))
            continue;

          // Guarantees ordered pairs (avoids repetition).
          if (baseValue <= aliasValue)
            pairsToCheck.insert(std::make_pair(baseValue, aliasValue));
          else
            pairsToCheck.insert(std::make_pair(aliasValue, baseValue));
        }
    }

  std::map<Value *, std::pair<Value *, Value *> > pointerBounds;
  std::vector<Value *> checks;

  // Insert comparison expressions for every pair of pointers that need to be
  // checked. Example:
  // check(A, B) -> upperAddrA < lowerAddrB || upperAddrB < lowerAddrA
  for (auto& pair : pairsToCheck) {
    // Extract the access bounds for each pointer.
    if (!pointerBounds.count(pair.first)) {
      Value *low = rangeAnalyser.getULowerBound(memAccesses[pair.first]);
      Value *up = rangeAnalyser.getUUpperBound(memAccesses[pair.first]);

      // If we can't compute the bounds for a pointer, we can't guarantee no
      // dependencies.
      if (!low || !up)
        return false;

      pointerBounds[pair.first] = std::make_pair(low, up);
    }

    if (!pointerBounds.count(pair.second)) {
      Value *low = rangeAnalyser.getULowerBound(memAccesses[pair.second]);
      Value *up = rangeAnalyser.getUUpperBound(memAccesses[pair.second]);

      // If we can't compute the bounds for a pointer, we can't guarantee no
      // dependencies.
      if (!low || !up)
        return false;

      pointerBounds[pair.second] = std::make_pair(low, up);
    }

    Value *check = insertCheck(pointerBounds[pair.first],
      pointerBounds[pair.second]);
    checks.push_back(check);
  }

  chainChecks(checks);

  return true;
}

// Inserts a dynamic test to guarantee that accesses to two pointers do not
// overlap, by doing:
// no-alias: upper(A) < lower(B) || upper(B) < lower(A)
Value *AliasInstrumenter::insertCheck(std::pair<Value *, Value *> boundsA,
                                    std::pair<Value *, Value *> boundsB) {
  // Cast all bounds to i8* (equivalent to void*, according to the LLVM manual).
  Type *i8PtrTy = rangeAnalyser.Builder.getInt8PtrTy();
  Value *lowerA = rangeAnalyser.InsertNoopCastOfTo(boundsA.first, i8PtrTy);
  Value *upperA = rangeAnalyser.InsertNoopCastOfTo(boundsA.second, i8PtrTy);
  Value *lowerB = rangeAnalyser.InsertNoopCastOfTo(boundsB.first, i8PtrTy);
  Value *upperB = rangeAnalyser.InsertNoopCastOfTo(boundsB.second, i8PtrTy);

  Value *aIsBeforeB = rangeAnalyser.Builder.CreateICmpULT(upperA, lowerB);
  Value *bIsBeforeA = rangeAnalyser.Builder.CreateICmpULT(upperB, lowerA);
  return rangeAnalyser.Builder.CreateOr(aIsBeforeB, bIsBeforeA, "no-dyn-alias");
}

Value *AliasInstrumenter::chainChecks(std::vector<Value *> checks) {
  if (checks.size() < 1)
    return nullptr;

  Value *rhs = checks[0];

  for (std::vector<Value *>::size_type i = 1; i != checks.size(); i++) {
    rhs = rangeAnalyser.Builder.CreateAnd(checks[i], rhs, "no-dyn-alias");
  }

  return rhs;
}
