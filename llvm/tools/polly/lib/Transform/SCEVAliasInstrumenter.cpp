//===------------- SCEVAliasInstrumenter.cpp --------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/StringExtras.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/TypeBuilder.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

#include "polly/SCEVAliasInstrumenter.h"
#include "polly/LinkAllPasses.h"
#include "polly/ScopDetection.h"
#include "polly/Support/ScopHelper.h"
#include "polly/CloneRegion.h"
#include "polly/CodeGen/BlockGenerators.h"
#include "polly/Support/SCEVValidator.h"

using namespace llvm;
using namespace polly;

#define DEBUG_TYPE "polly-alias-instrumenter"

template<typename T>
std::pair<T,T> make_ordered_pair(const T& t1, const T& t2) {
  return (t1 < t2) ? std::make_pair(t1,t2) : std::make_pair(t2,t1);
}

void SCEVAliasInstrumenter::fixAliasInfo(Region *r) {
  std::map<const Value *, std::set<Instruction *> > memAccesses;

  // Build a map from base pointers to the instructions that can access them
  // within the region.
  for (BasicBlock *bb : r->blocks()) {
    for (BasicBlock::iterator i = bb->begin(), e = --bb->end(); i != e; ++i) {
      Instruction &inst = *i;

      if (!isa<LoadInst>(inst) && !isa<StoreInst>(inst))
        continue;

      Value *basePtrValue = getBasePtrValue(inst, *r);
      assert(basePtrValue && "Bad load/store in cloned region.");
      memAccesses[basePtrValue].insert(i);
    }
  }

  MDBuilder MDB(currFn->getContext());
  if (!mdDomain)
    mdDomain = MDB.createAnonymousAliasScopeDomain(currFn->getName());
  DenseMap<const Value *, MDNode *> scopes;
  unsigned ptrCount = 0;

  // Create a different alias scope for each base pointer in the region.
  for (auto pair : memAccesses) {
    const Value *basePointer = pair.first;
    std::string name = currFn->getName();

    name += (basePointer->hasName()) ? (": %" + basePointer->getName().str()) :
      (": ptr " + utostr(ptrCount++));
    MDNode *scope = MDB.createAnonymousAliasScope(mdDomain, name);
    scopes.insert(std::make_pair(basePointer, scope));
  }

  // Set the actual scoped alias tags for each memory instruction in the region.
  // A memory instruction always aliases its base pointer and never aliases
  // other pointers in the region.
  for (auto pair : memAccesses) {
    const Value *basePointer = pair.first;

    // Set the alias metadata for each memory access instruction in the region.
    for (auto memInst : pair.second) {
      // Check that the instruction was not removed from the region.
      if (!memInst->getParent())
        continue;

      // A memory instruction always aliases its base pointer.
      memInst->setMetadata(LLVMContext::MD_alias_scope, MDNode::concatenate(
        memInst->getMetadata(LLVMContext::MD_alias_scope),
          MDNode::get(currFn->getContext(), scopes[basePointer])));

      // The instruction never aliases other pointers in the region.
      for (auto otherPair : memAccesses) {
        const Value *otherBasePointer = otherPair.first;

        // Slip the instruction's own base pointer.
        if (otherBasePointer == basePointer)
          continue;

        memInst->setMetadata(LLVMContext::MD_noalias, MDNode::concatenate(
          memInst->getMetadata(LLVMContext::MD_noalias),
            MDNode::get(currFn->getContext(), scopes[otherBasePointer])));
      }
    }
  }
}

void SCEVAliasInstrumenter::simplifyRegion(Region *r) {
  // If this is a top-level region, create an exit block for it.
  if (!r->getExit()) {
    BasicBlock *exiting = getFnExitingBlock();
    assert(exiting && "Candidate top-level regions need an exiting block");
    r->replaceExitRecursive(SplitBlock(exiting, exiting->begin(), this));
  }

  // If the region doesn't have an entering block, create one.
  if (!r->getEnteringBlock()) {
    BasicBlock *entry = r->getEntry();

    SmallVector<BasicBlock *, 4> preds;
    for (pred_iterator pi = pred_begin(entry), pe = pred_end(entry); pi != pe; ++pi)
      if (!r->contains(*pi))
        preds.push_back(*pi);

    // Weird things happen when we call SplitBlockPredecessors on a block with
    // no predecessors.
    if (preds.size() > 0)
      SplitBlockPredecessors(entry, preds, ".region", this);
    else
      r->replaceEntryRecursive(SplitBlock(entry, entry->begin(), this));
  }

  // Split the entering block, so the checks will be in a single block.
  SplitBlock(r->getEnteringBlock(), r->getEnteringBlock()->getTerminator(), this);

  // Create exiting block.
  if (!r->getExitingBlock())
    createSingleExitEdge(r, this);
}

void SCEVAliasInstrumenter::buildNoAliasClone(InstrumentationContext &context,
                                              Instruction *checkResult) {
  if (!checkResult)
    return;

  Region &r = context.r;
  Region *clonedRegion = cloneRegion(&r, nullptr, ri, dt, df);

  // Build the conditional brach based on the dynamic test result.
  TerminatorInst *br = r.getEnteringBlock()->getTerminator();
  BuilderType builder(se->getContext(), TargetFolder(se->getDataLayout()));
  builder.SetInsertPoint(br);
  builder.CreateCondBr(checkResult, r.getEntry(), clonedRegion->getEntry());
  br->eraseFromParent();

  // Replace original loop bound loads by hoisted loads in the region, which is
  // now guarded against true aliasing.
  for (auto &pair : context.artificialBECounts) {
    pair.second.oldLoad->replaceAllUsesWith(pair.second.hoistedLoad);
    pair.second.oldLoad->eraseFromParent();
  }

  // Mark the cloned region as free of dependencies.
  fixAliasInfo(&r);
}

Instruction *SCEVAliasInstrumenter::chainChecks(
                                          std::vector<Instruction *> checks,
                                          BuilderType &builder) {
  if (checks.size() < 1)
    return nullptr;

  Value *rhs = checks[0];

  for (std::vector<Value *>::size_type i = 1; i != checks.size(); i++) {
    rhs = builder.CreateAnd(checks[i], rhs, "region-no-alias");
  }

  // ugly but safe, since `and' of instructions always produces an instruction
  return cast<Instruction>(rhs);
}

Value *SCEVAliasInstrumenter::stretchUpperBound(Value *basePtr, Value *upperBound,
                                                BuilderType &builder,
                                                SCEVRangeBuilder &rangeBuilder) {
  Type *boundTy = upperBound->getType();

  // We can only perform arithmetic operations on integers types.
  if (!boundTy->isIntegerTy()) {
    boundTy = se->getDataLayout()->getIntPtrType(boundTy);
    upperBound = rangeBuilder.InsertNoopCastOfTo(upperBound, boundTy);
  }

  // As the base pointer might be multi-dimensional, we extract its innermost
  // element type.
  Type *elemTy = basePtr->getType();

  while (isa<SequentialType>(elemTy))
    elemTy = cast<SequentialType>(elemTy)->getElementType();

  Constant *elemSize = ConstantInt::get(boundTy,
                       se->getDataLayout()->getTypeAllocSize(elemTy));
  return builder.CreateAdd(upperBound, elemSize);
}

Instruction *SCEVAliasInstrumenter::buildRangeCheck(
                                    Value *basePtrA, Value *basePtrB,
                                    std::pair<Value *, Value *> boundsA,
                                    std::pair<Value *, Value *> boundsB,
                                    BuilderType &builder,
                                    SCEVRangeBuilder &rangeBuilder) {
  Value *lowerA = boundsA.first;
  Value *upperA = boundsA.second;
  Value *lowerB = boundsB.first;
  Value *upperB = boundsB.second;

  // Stretch both upper bounds past the last addressable byte.
  upperA = stretchUpperBound(basePtrA, upperA, builder, rangeBuilder);
  upperB = stretchUpperBound(basePtrB, upperB, builder, rangeBuilder);

  // Cast all bounds to i8* (equivalent to void*, according to the LLVM manual).
  Type *i8PtrTy = builder.getInt8PtrTy();
  lowerA = rangeBuilder.InsertNoopCastOfTo(lowerA, i8PtrTy);
  lowerB = rangeBuilder.InsertNoopCastOfTo(lowerB, i8PtrTy);
  upperA = rangeBuilder.InsertNoopCastOfTo(upperA, i8PtrTy);
  upperB = rangeBuilder.InsertNoopCastOfTo(upperB, i8PtrTy);

  // Build actual interval comparisons.
  Value *aIsBeforeB = builder.CreateICmpULE(upperA, lowerB);
  Value *bIsBeforeA = builder.CreateICmpULE(upperB, lowerA);

  Value *check = builder.CreateOr(aIsBeforeB, bIsBeforeA, "pair-no-alias");

  return cast<Instruction>(check);
}

void SCEVAliasInstrumenter::buildSCEVBounds(InstrumentationContext &context,
                                            SCEVRangeBuilder &rangeBuilder) {
  // Compute access bounds for each base pointer in the region.
  for (auto& pair : context.memAccesses) {
    Value *low = rangeBuilder.getULowerBound(pair.second);
    Value *up = rangeBuilder.getUUpperBound(pair.second);

    assert((low && up) &&
      "All access expressions should have computable SCEV bounds by now");

    context.pointerBounds[pair.first] = std::make_pair(low, up);
  }
}

Instruction *SCEVAliasInstrumenter::insertDynamicChecks(
                            InstrumentationContext &context) {
  Region &r = context.r;

  // Create an entering block to receive the checks.
  simplifyRegion(&r);

  // Set instruction insertion context. We'll insert the run-time tests in the
  // region entering block.
  Instruction *insertPt = r.getEnteringBlock()->getTerminator();
  SCEVRangeBuilder rangeBuilder(se, aa, li, dt, &r, insertPt);
  rangeBuilder.setArtificialBECounts(context.getBECountsMap());
  BuilderType builder(se->getContext(), TargetFolder(se->getDataLayout()));
  builder.SetInsertPoint(insertPt);

  buildSCEVBounds(context, rangeBuilder);

  std::vector<Instruction *> pairChecks;

  // Insert comparison expressions for every pair of pointers that need to be
  // checked in the region.
  for (auto& pair : context.ptrPairsToCheckOnRange) {
    assert(context.pointerBounds.count(pair.first) &&
           context.pointerBounds.count(pair.second) &&
           "SCEV bounds should be available at this point.");

    auto check = buildRangeCheck(pair.first, pair.second,
                                 context.pointerBounds[pair.first],
                                 context.pointerBounds[pair.second],
                                 builder, rangeBuilder);
    pairChecks.push_back(check);
  }

  // Also, if we hoisted loop bound loads, insert tests to guarantee that no
  // store in the region alises the hoisted loads.
  for (auto &pair : context.artificialBECounts) {
    for (auto &storeTarget : context.storeTargets) {
      auto check = buildRangeCheck(storeTarget, pair.second.addr,
                   context.pointerBounds[storeTarget],
                   std::make_pair(pair.second.addr, pair.second.addr),
                   builder, rangeBuilder);
      pairChecks.push_back(check);
    }
  }

  // Combine all checks into a single boolean result using AND.
  return chainChecks(pairChecks, builder);
}

Value *SCEVAliasInstrumenter::getBasePtrValue(Instruction &inst,
                                              const Region &r) {
  Value *ptr = getPointerOperand(inst);
  Loop *l = li->getLoopFor(inst.getParent());
  const SCEV *accessFunction = se->getSCEVAtScope(ptr, l);
  const SCEVUnknown *basePointer =
    cast<SCEVUnknown>(se->getPointerBase(accessFunction));

  if (!basePointer)
    return nullptr;

  Value *basePtrValue = basePointer->getValue();

  // We can't handle direct address manipulation.
  if (isa<UndefValue>(basePtrValue) || isa<IntToPtrInst>(basePtrValue))
    return nullptr;

  // The base pointer can vary within the given region.
  if (!ScopDetection::isInvariant(*basePtrValue, r, li, aa))
    return nullptr;

  return basePtrValue;
}

bool SCEVAliasInstrumenter::collectDependencyData(
                            InstrumentationContext &context) {
  const Region &r = context.r;

  AliasSetTracker ast(*aa);

  for (BasicBlock *bb : r.blocks())
    ast.add(*bb);

  // find which checks we need to insert
  for (BasicBlock *bb : r.blocks()) {
    for (BasicBlock::iterator i = bb->begin(), e = --bb->end(); i != e; ++i) {
      Instruction &inst = *i;

      if (!isa<LoadInst>(inst) && !isa<StoreInst>(inst))
        continue;

      Value *basePtrValue = getBasePtrValue(inst, r);

      // If we can't define the base pointer, then it's not possible to define
      // the dependencies.
      if (!basePtrValue)
        return false;

      // As full type size info is needed, we can only handle sequential types.
      if (!isa<SequentialType>(basePtrValue->getType()))
        return false;

      // Store this access expression.
      Value *ptr = getPointerOperand(inst);
      Loop *l = li->getLoopFor(inst.getParent());
      const SCEV *accessFunction = se->getSCEVAtScope(ptr, l);
      context.memAccesses[basePtrValue].insert(accessFunction);

      if (isa<StoreInst>(inst))
        context.storeTargets.insert(basePtrValue);

      // We need checks against all pointers in the May Alias set.
      AliasSet &as =
        ast.getAliasSetForPointer(basePtrValue, AliasAnalysis::UnknownSize,
                                  inst.getMetadata(LLVMContext::MD_tbaa));

      // Store all pointers that need to be tested agains the current one.
      if (!as.isMustAlias()) {
        for (const auto &aliasPointer : as) {
          Value *aliasValue = aliasPointer.getValue();

          if (basePtrValue == aliasValue)
            continue;

          // We only need to check against pointers accessed within the region.
          if (!context.memAccesses.count(aliasValue))
            continue;

          // Guarantees ordered pairs (avoids repetition).
          auto pair = make_ordered_pair(basePtrValue, aliasValue);
          context.ptrPairsToCheckOnRange.insert(pair);
        }
      }
    }
  }

  return true;
}

bool SCEVAliasInstrumenter::isValidInstruction(Instruction &inst) {
  if (CallInst *CI = dyn_cast<CallInst>(&inst)) {
    if (ScopDetection::isValidCallInst(*CI))
      return true;

    return false;
  }

  // Anything that doesn't access memory is valid.
  if (!inst.mayWriteToMemory() && !inst.mayReadFromMemory()) {
    if (!isa<AllocaInst>(inst))
      return true;

    return false;
  }

  // Loads and stores will be checked later, when building the dynamic tests.
  if (isa<LoadInst>(inst) || isa<StoreInst>(inst))
    return true;

  // We do not know this instruction, therefore we assume it is invalid.
  return false;
}

bool SCEVAliasInstrumenter::createArtificialInvariantBECount(Loop *l,
                            InstrumentationContext &context) {
  Region &r = context.r;
  BasicBlock *entering = r.getEnteringBlock();

  // We need an entering block to put the hoisted load.
  if (!entering)
    return false;

  SmallVector<BasicBlock *, 8> exitingBlocks;
  l->getExitingBlocks(exitingBlocks);

  // For simplicity, we only handle loops with one exit block, which must
  // control all iterations.
  if ((exitingBlocks.size() != 1) ||
      !se->hasConsistentTerminator(l, exitingBlocks[0]))
    return false;

  // The counter must be controled by a branch instruction based on an ICmp.
  BranchInst *br = dyn_cast<BranchInst>(exitingBlocks[0]->getTerminator());

  if (!br || !isa<ICmpInst>(br->getCondition()))
    return false;

  ICmpInst *exitCond = dyn_cast<ICmpInst>(br->getCondition());

  // If the condition is exit on true, convert it to exit on false.
  ICmpInst::Predicate cond = !l->contains(/*false BB*/br->getSuccessor(1)) ?
    exitCond->getPredicate() : exitCond->getInversePredicate();

  const SCEV *lhsSCEV = se->getSCEVAtScope(exitCond->getOperand(0), l);
  const SCEV *rhsSCEV = se->getSCEVAtScope(exitCond->getOperand(1), l);

  // LHS must be an induction variable and RHS must be a loop-variant load.
  if (!isa<SCEVAddRecExpr>(lhsSCEV) || !isa<LoadInst>(exitCond->getOperand(1)) ||
      se->isLoopInvariant(rhsSCEV, l))
    return false;

  LoadInst *oldLoad = dyn_cast<LoadInst>(exitCond->getOperand(1));
  Value *addr = oldLoad->getPointerOperand();

  // The loaded address must be loop-invariant.
  if (!addr || !se->isLoopInvariant(se->getSCEVAtScope(addr, l), l))
    return false;

  // Create a hoisted copy of the load, creating a loop-invariant bound.
  Instruction *newLoad = oldLoad->clone();
  newLoad->setName((oldLoad->hasName() ? oldLoad->getName() + "." : "") +
    "hoisted");
  newLoad->insertBefore(entering->getTerminator());
  const SCEV *newRhsSCEV = se->getSCEVAtScope(newLoad, l);
  const SCEV *count;

  // Compute the counter using the newly hoisted load as bound.
  switch (cond) {
    case ICmpInst::ICMP_SLT:
    case ICmpInst::ICMP_ULT: {
      bool isSign = (cond == ICmpInst::ICMP_SLT);
      count = se->HowManyLessThans(lhsSCEV, newRhsSCEV, l, isSign,
                                   /*IsSubExpr*/false).Exact;
      if (count == se->getCouldNotCompute()) return false;
      break;
    }
    case ICmpInst::ICMP_SGT:
    case ICmpInst::ICMP_UGT: {
      bool isSign = (cond == ICmpInst::ICMP_SGT);
      count = se->HowManyGreaterThans(lhsSCEV, newRhsSCEV, l, isSign,
                                      /*IsSubExpr*/false).Exact;
      if (count == se->getCouldNotCompute()) return false;
      break;
    }
    default:
      return false;
  }

  context.artificialBECounts.emplace(l, ArtificialBECount(addr, oldLoad,
                                                          newLoad, count));
  return true;
}

BasicBlock *SCEVAliasInstrumenter::getFnExitingBlock() {
  std::vector<BasicBlock*> returnBlocks;

  for (Function::iterator i = currFn->begin(), e = currFn->end(); i != e; ++i)
    if (isa<ReturnInst>(i->getTerminator()))
      returnBlocks.push_back(i);

  if (returnBlocks.size() != 1)
    return nullptr;

  return returnBlocks.front();
}

bool SCEVAliasInstrumenter::canInstrument(InstrumentationContext &context) {
  Region &r = context.r;

  // Top-level regions need at least an exiting block to be instrumented.
  if (!r.getExit() && !getFnExitingBlock())
    return false;

  bool hasLoop = false;

  // Do not instrument regions without loops.
  for (const BasicBlock *bb : r.blocks())
    if (r.contains(li->getLoopFor(bb)))
      hasLoop = true;

  if (!hasLoop)
    return false;

  // Make sure that all loops in the region have a symbolic limit.
  for (BasicBlock *bb : r.blocks()) {
    Loop *l = li->getLoopFor(bb);

    // If a loop doesn't have a defined limit, try to create an artificial one.
    if (l && (l->getHeader() == bb) &&
        !se->hasLoopInvariantBackedgeTakenCount(l) &&
        !createArtificialInvariantBECount(l, context))
      return false;
  }

  // Check that all instructions are valid.
  for (BasicBlock *bb : r.blocks())
    for (BasicBlock::iterator i = bb->begin(), e = --bb->end(); i != e; ++i)
      if (!isValidInstruction(*i))
        return false;

  // If dependencies can't be fully defined, then we can't instrument.
  if (!collectDependencyData(context))
    return false;

  Instruction *insertPt = r.getEntry()->getFirstNonPHI();
  SCEVRangeBuilder rangeBuilder(se, aa, li, dt, &r, insertPt);
  rangeBuilder.setArtificialBECounts(context.getBECountsMap());

  // Make sure that access bounds can be computed for every access expression
  // within the region.
  for (auto& pair : context.memAccesses)
    if (!rangeBuilder.canComputeBoundsFor(pair.second))
      return false;

  return true;
}

void SCEVAliasInstrumenter::findTargetRegions(Region &r) {
  InstrumentationContext context(r);

  // If the whole region can be instrumented, stop the search.
  if (canInstrument(context)) {
    targetRegions.push_back(context);
    return;
  }

  // If the region can't be instrumented, look at smaller regions.
  for (auto &subRegion : r)
    findTargetRegions(*subRegion);
}

bool SCEVAliasInstrumenter::runOnFunction(llvm::Function &F) {
  // Collect all analyses needed for runtime check generation.
  li = &getAnalysis<LoopInfo>();
  ri = &getAnalysis<RegionInfoPass>().getRegionInfo();
  aa = &getAnalysis<AliasAnalysis>();
  se = &getAnalysis<ScalarEvolution>();
  dt = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  pdt = &getAnalysis<PostDominatorTree>();
  df = &getAnalysis<DominanceFrontier>();

  // We need precise type info, so DataLayout must be available.
  if (!se->getDataLayout())
    return true;

  currFn = &F;
  Region *topRegion = ri->getTopLevelRegion();

  releaseMemory();
  findTargetRegions(*topRegion);

  // Instrument and clone each target region.
  for (auto context : targetRegions) {
    Instruction *checkResult = insertDynamicChecks(context);
    buildNoAliasClone(context, checkResult);
  }

  return true;
}

void SCEVAliasInstrumenter::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.addRequired<DominatorTreeWrapperPass>();
  AU.addRequired<PostDominatorTree>();
  AU.addRequired<DominanceFrontier>();
  AU.addRequired<LoopInfo>();
  AU.addRequired<ScalarEvolution>();
  AU.addRequired<AliasAnalysis>();
  AU.addRequired<RegionInfoPass>();

  // Changing the CFG like we do doesn't preserve anything.
  AU.addPreserved<AliasAnalysis>();
}

std::set<Value*>& MustAliasSets::getSetFor(Value *v) {
  for (auto& set : sets) {
    if (set.count(v))
      return set;
  }

  iterator set = sets.emplace(sets.end());

  set->insert(v);

  return *set;
}


char SCEVAliasInstrumenter::ID = 0;

Pass *polly::createSCEVAliasInstrumenterPass() {
  return new SCEVAliasInstrumenter();
}

INITIALIZE_PASS_BEGIN(SCEVAliasInstrumenter, "polly-scev-checks",
                      "Polly - Instrument alias dependencies", false,
                      false);
INITIALIZE_AG_DEPENDENCY(AliasAnalysis);
INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass);
INITIALIZE_PASS_DEPENDENCY(LoopInfo);
INITIALIZE_PASS_DEPENDENCY(PostDominatorTree);
INITIALIZE_PASS_DEPENDENCY(DominanceFrontier);
INITIALIZE_PASS_DEPENDENCY(RegionInfoPass);
INITIALIZE_PASS_DEPENDENCY(ScalarEvolution);
INITIALIZE_PASS_END(SCEVAliasInstrumenter, "polly-scev-checks",
                    "Polly - Instrument alias dependencies", false, false)

