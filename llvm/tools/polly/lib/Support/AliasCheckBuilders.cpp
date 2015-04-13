
#include "polly/Support/AliasCheckBuilders.h"

using namespace polly;
using namespace llvm;

AliasCheckFlags AliasCheckFlags::allTrue() {
  return AliasCheckFlags(true, true, true);
}

Value* RangeCheckBuilder::buildRangeCheck(Value *a, Value *b) {
  ValuePair boundsA, boundsB;

  if (!buildSCEVBounds(a, boundsA) || !buildSCEVBounds(b, boundsB))
    return nullptr;

  // Cast all bounds to i8* (equivalent to void*, according to the LLVM manual).
  auto i8PtrTy = builder.getInt8PtrTy();
  auto lowerA  = rangeBuilder.noopCast(boundsA.first,  i8PtrTy);
  auto upperA  = rangeBuilder.noopCast(boundsA.second, i8PtrTy);
  auto lowerB  = rangeBuilder.noopCast(boundsB.first,  i8PtrTy);
  auto upperB  = rangeBuilder.noopCast(boundsB.second, i8PtrTy);

  // Build actual interval comparisons.
  auto aIsBeforeB = builder.CreateICmpULT(upperA, lowerB);
  auto bIsBeforeA = builder.CreateICmpULT(upperB, lowerA);

  return builder.CreateOr(aIsBeforeB, bIsBeforeA, "pair-no-alias");
}

Value *RangeCheckBuilder::buildLocationCheck(Value *a, Value *addrB) {
  ValuePair boundsA;
  if (!buildSCEVBounds(a, boundsA))
    return nullptr;

  // Cast all bounds to i8* (equivalent to void*, according to the LLVM manual).
  auto i8PtrTy = builder.getInt8PtrTy();
  auto lowerA  = rangeBuilder.noopCast(boundsA.first,  i8PtrTy);
  auto upperA  = rangeBuilder.noopCast(boundsA.second, i8PtrTy);
  auto locB    = rangeBuilder.noopCast(addrB,          i8PtrTy);

  // Build actual interval comparisons.
  Value *aIsBeforeB = builder.CreateICmpULT(upperA, locB);
  Value *bIsBeforeA = builder.CreateICmpULT(locB,   lowerA);

  Value *check = builder.CreateOr(aIsBeforeB, bIsBeforeA, "loc-no-alias");

  return check;
}


bool RangeCheckBuilder::buildSCEVBounds(Value *basePtr, ValuePair &dst) {
  auto it = boundsCache.find(basePtr);

  if (it != boundsCache.end()) {
    dst = it->second;
    return true;
  }

  assert(memAccesses.count(basePtr));

  auto& accessFunctions = memAccesses[basePtr].accessFunctions;

  auto lower = rangeBuilder.getULowerBound(accessFunctions);
  auto upper = rangeBuilder.getUUpperBound(accessFunctions);

  if (!lower || !upper)
    return false;

  auto pair = std::make_pair(lower, upper);

  boundsCache.insert(it, std::make_pair(basePtr, pair));

  dst = pair;
  return true;
}

Value* HeapCheckBuilder::buildCheck(Value *a, Value *b) {
    auto idA = buildGetPtrIdCall(a);
    auto idB = buildGetPtrIdCall(b);

    return builder.CreateICmpNE(idA, idB);
}

Value* HeapCheckBuilder::buildGetPtrIdCall(Value *ptr) {
  assert(getPtrId);

  // look up in cache
  auto I = ptrIdCache.find(ptr);

  if(I != ptrIdCache.end())
      return I->second;

  // we hoist the call ourselves since LLVM cannot see the effects of our
  // function and isn't able to hoist it itself.

  Instruction *insertBefore;

  if (isa<Constant>(ptr) || isa<Argument>(ptr))
    insertBefore = enteringBlock->getFirstInsertionPt();
  else if (auto phi = dyn_cast<PHINode>(ptr))
    // don't insert into the middle of a block of PHIs
    insertBefore = phi->getParent()->getFirstInsertionPt();
  else
    insertBefore = cast<Instruction>(ptr)->getNextNode();

  assert(insertBefore);

  BuilderType IRB(builder);
  IRB.SetInsertPoint(insertBefore);

  auto operand  = IRB.CreatePointerCast(ptr, IRB.getInt8PtrTy());
  auto magicNum = IRB.CreateCall(getPtrId, operand);

  // update cache
  ptrIdCache[ptr] = magicNum;

  return magicNum;
}

Value *EqualityCheckBuilder::buildCheck(Value *a, Value *b) {
	auto& set            = sets.getSetFor(a, b);
	auto  representative = set.getSomePointer();

  Value* check = builder.getTrue();

  check = buildCmp(representative, a, check);
  check = buildCmp(representative, b, check);

  return check;
}

Value *EqualityCheckBuilder::buildCmp(Value *setRepresentative, Value *ptr, Value *chain) {
  if (setRepresentative != ptr) {
    auto *void_ptr_ty = builder.getInt8PtrTy();

    chain = builder.CreateAnd(
      chain,
      builder.CreateICmpEQ(
        builder.CreatePointerCast(setRepresentative, void_ptr_ty),
        builder.CreatePointerCast(ptr, void_ptr_ty)
      )
    );
  }

  return chain;
}
