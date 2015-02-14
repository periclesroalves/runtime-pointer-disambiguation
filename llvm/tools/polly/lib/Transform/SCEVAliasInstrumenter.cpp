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

bool SCEVAliasInstrumenter::isSafeToSimplify(Region *r) {
  bool safeToSimplify = true;

  // Check if a region edge's destination won't taken to outside the region.
  for (auto *p : make_range(pred_begin(r->getEntry()), pred_end(r->getEntry())))
    if (r->contains(p) && p != r->getExit())
      safeToSimplify = false;

  // Check if a region edge's source won't taken to outside the region.
  for (auto *s : make_range(succ_begin(r->getExit()), succ_end(r->getExit())))
    if (r->contains(s) && s != r->getEntry())
      safeToSimplify = false;

  return safeToSimplify;
}

bool SCEVAliasInstrumenter::simplifyRegion(Region *r) {
  if (!isSafeToSimplify(r))
    return false;

  // Create a new entering block to host the checks, even if we already had one.
  BasicBlock *entry = r->getEntry();
  r->replaceEntryRecursive(SplitBlock(entry, entry->begin(), li));

  // Create exiting block.
  if (!r->getExitingBlock()) {
    BasicBlock *newExit = createSingleExitEdge(r, li);

    for (auto &&subRegion : *r)
      subRegion->replaceExitRecursive(newExit);
  }

  return true;
}

void SCEVAliasInstrumenter::hoistChecks() {
  // NOTE: checks that can't be hoisted will be eliminated.
  std::vector<std::pair<Value *, Region *> > oldChecks(insertedChecks);
  insertedChecks.clear();

  for (auto &check : oldChecks) {
    Instruction *dyResult = dyn_cast<Instruction>(check.first);
    BasicBlock *entry = dyResult->getParent();
    Region *r = check.second;

    assert((dyResult && entry == r->getEntry()) && "Malformed dynamic check.");

    // Only simple regions can be cloned. Skip regions that can't be simplified.
    if (!simplifyRegion(r))
      continue;

    // The check expressions live between the entry blocks phis and the final
    // result.
    Instruction *inst;
    BasicBlock::iterator it = dyResult->getParent()->getFirstNonPHI();
    Instruction *insertPt = &r->getEnteringBlock()->back();

    // Move the check expressions to the entering block, one instruction at a
    // time.
    do {
      inst = it;
      it++;
      inst->removeFromParent();
      inst->insertBefore(insertPt);
    } while (inst != dyResult);

    // Register the new check location.
    insertedChecks.push_back(std::make_pair(check.first, r));
  }
}

void SCEVAliasInstrumenter::cloneInstrumentedRegions() {
  if (insertedChecks.size() <= 0)
    return;

  // Reverse "insertedChecks", so that sub-regions are always modified first.
  std::reverse(insertedChecks.begin(), insertedChecks.end());

  // Take the checks outside the regions before cloning them.
  hoistChecks();

  // Clone each instrumented region.
  for (auto &check : insertedChecks) {
    Instruction *dyResult = dyn_cast<Instruction>(check.first);
    Region *r = check.second;
    Region *clonedRegion = cloneRegion(r, nullptr, ri, dt, df);

    // Build the conditional brach based on the test result.
    Instruction *br = &r->getEnteringBlock()->back();
    BuilderType builder(se->getContext(), TargetFolder(se->getDataLayout()));
    builder.SetInsertPoint(br);
    builder.CreateCondBr(dyResult, clonedRegion->getEntry(), r->getEntry());
    br->eraseFromParent();

    // Mark the cloned region as free of dependencies.
    fixAliasInfo(clonedRegion);
  }
}

Value *SCEVAliasInstrumenter::chainChecks(std::vector<Value *> checks,
                                          BuilderType &builder) {
  if (checks.size() < 1)
    return nullptr;

  Value *rhs = checks[0];

  for (std::vector<Value *>::size_type i = 1; i != checks.size(); i++) {
    rhs = builder.CreateAnd(checks[i], rhs, "region-no-alias");
  }

  return rhs;
}

Value *SCEVAliasInstrumenter::buildPtrPairCheck(
                              std::pair<Value *, Value *> boundsA,
                              std::pair<Value *, Value *> boundsB,
                              BuilderType &builder,
                              SCEVRangeBuilder &rangeBuilder) {

  // Cast all bounds to i8* (equivalent to void*, according to the LLVM manual).
  Type *i8PtrTy = builder.getInt8PtrTy();
  Value *lowerA = rangeBuilder.InsertNoopCastOfTo(boundsA.first, i8PtrTy);
  Value *upperA = rangeBuilder.InsertNoopCastOfTo(boundsA.second, i8PtrTy);
  Value *lowerB = rangeBuilder.InsertNoopCastOfTo(boundsB.first, i8PtrTy);
  Value *upperB = rangeBuilder.InsertNoopCastOfTo(boundsB.second, i8PtrTy);

  // Build actual interval comparisons.
  Value *aIsBeforeB = builder.CreateICmpULT(upperA, lowerB);
  Value *bIsBeforeA = builder.CreateICmpULT(upperB, lowerA);
  return builder.CreateOr(aIsBeforeB, bIsBeforeA, "pair-no-alias");
}

bool SCEVAliasInstrumenter::buildSCEVBounds(InstrumentationContext &context,
                                            SCEVRangeBuilder &rangeBuilder) {
  // Compute access bounds for each base pointer in the region.
  for (auto& pair : context.memAccesses) {
    Value *low = rangeBuilder.getULowerBound(pair.second);
    Value *up = rangeBuilder.getUUpperBound(pair.second);

    // Check if both bounds could be comuted.
    if (!low || !up)
      return false;

    context.pointerBounds[pair.first] = std::make_pair(low, up);
  }

  return true;
}

bool SCEVAliasInstrumenter::instrumentDependencies(
                            InstrumentationContext &context) {
  Region &r = context.r;

  // Set instruction insertion context. We'll temporarily insert the run-time
  // tests in the region entry.
  Instruction *insertPt = r.getEntry()->getFirstNonPHI();
  SCEVRangeBuilder rangeBuilder(se, aa, li, dt, &r, insertPt);
  BuilderType builder(se->getContext(), TargetFolder(se->getDataLayout()));
  builder.SetInsertPoint(insertPt);

  if (!buildSCEVBounds(context, rangeBuilder))
    return false;

  std::vector<Value *> pairChecks;

  // Insert comparison expressions for every pair of pointers that need to be
  // checked in the region.
  for (auto& pair : context.pairsToCheck) {
    assert(context.pointerBounds.count(pair.first) &&
           context.pointerBounds.count(pair.second) &&
           "SCEV bounds should be available at this point.");

    Value *check = buildPtrPairCheck(context.pointerBounds[pair.first],
                                     context.pointerBounds[pair.second],
                                     builder, rangeBuilder);
    pairChecks.push_back(check);
  }

  // Combine all checks into a single boolean result using AND.
  if (Value *checkResult = chainChecks(pairChecks, builder))
    insertedChecks.push_back(std::make_pair(checkResult, &r));

  return true;
}

Value *SCEVAliasInstrumenter::getBasePtrValue(Instruction &inst, Region &r) {
  Value *ptr = getPointerOperand(inst);
  Loop *l = li->getLoopFor(inst.getParent());
  const SCEV *accessFunction = se->getSCEVAtScope(ptr, l);
  const SCEVUnknown *basePointer =
    dyn_cast<SCEVUnknown>(se->getPointerBase(accessFunction));

  if (!basePointer)
    return nullptr;

  Value *basePtrValue = basePointer->getValue();

  // We can't handle direct address manipulation.
  if (isa<UndefValue>(basePtrValue) || dyn_cast<IntToPtrInst>(basePtrValue))
    return nullptr;

  // The base pointer can vary within the given region.
  if (!ScopDetection::isInvariant(*basePtrValue, r, li, aa))
    return nullptr;

  return basePtrValue;
}

bool SCEVAliasInstrumenter::collectDependencyData(
                            InstrumentationContext &context) {
  Region &r = context.r;
  AliasSetTracker ast(*aa);

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

      // Store this access expression.
      Value *ptr = getPointerOperand(inst);
      Loop *l = li->getLoopFor(inst.getParent());
      const SCEV *accessFunction = se->getSCEVAtScope(ptr, l);
      context.memAccesses[basePtrValue].insert(accessFunction);

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
          if (basePtrValue <= aliasValue)
            context.pairsToCheck.insert(std::make_pair(basePtrValue, aliasValue));
          else
            context.pairsToCheck.insert(std::make_pair(aliasValue, basePtrValue));
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

bool SCEVAliasInstrumenter::canInstrument(InstrumentationContext &context) {
  Region &r = context.r;
  bool hasLoop = false;

  // Do not instrument regions without loops.
  for (const BasicBlock *bb : r.blocks())
    if (r.contains(li->getLoopFor(bb)))
      hasLoop = true;

  if (!hasLoop)
    return false;

  // Top-level regions can't be instrumented.
  if (r.isTopLevelRegion())
    return false;

  // Check that all instructions are valid.
  for (BasicBlock *bb : r.blocks())
    for (BasicBlock::iterator i = bb->begin(), e = --bb->end(); i != e; ++i)
      if (!isValidInstruction(*i))
        return false;

  // If dependencies can't be fully defined, then we can't instrument.
  if (!collectDependencyData(context))
    return false;

  return true;
} 

void SCEVAliasInstrumenter::findAndInstrumentRegions(Region &r) {
  InstrumentationContext context(r);

  // If the whole region was successfully instrumented, stop the search.
  if (canInstrument(context) && instrumentDependencies(context))
    return;

  // If the region can't be instrumented, look at smaller regions.
  for (auto &subRegion : r)
    findAndInstrumentRegions(*subRegion);
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

  currFn = &F;
  Region *topRegion = ri->getTopLevelRegion();

  releaseMemory();
  findAndInstrumentRegions(*topRegion);
  cloneInstrumentedRegions();
  
  return false;
}

bool SCEVAliasInstrumenter::computeAndPrintPtrBounds(Value *pointer,
                                                     Region *r) {
  std::set<const SCEV *>  memAccesses;

  // Set instruction insertion context.
  Instruction *insertPt = r->getEntry()->begin();
  SCEVRangeBuilder rangeBuilder(se, aa, li, dt, r, insertPt);
  BuilderType builder(se->getContext(), TargetFolder(se->getDataLayout()));
  builder.SetInsertPoint(insertPt);

  // Collect all access functions to to the pointer in the region.
  for (BasicBlock *bb : r->blocks())
    for (BasicBlock::iterator i = bb->begin(), e = --bb->end(); i != e; ++i) {
      Instruction &inst = *i;

      if (!isa<LoadInst>(inst) && !isa<StoreInst>(inst))
        continue;

      Value *basePtrValue = getBasePtrValue(inst, *r);

      if (basePtrValue != pointer)
        continue;

      Value *ptr = getPointerOperand(inst);
      Loop *l = li->getLoopFor(inst.getParent());
      const SCEV *accessFunction = se->getSCEVAtScope(ptr, l);  
      memAccesses.insert(accessFunction);
    }

  // Compute the lowest lower and greatest access bounds.
  Value *low = rangeBuilder.getULowerBound(memAccesses);
  Value *up = rangeBuilder.getUUpperBound(memAccesses);

  if (!low || !up)
    return false;

  rangeBuilder.insertPtrPrintf(low);
  rangeBuilder.insertPtrPrintf(up);

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
