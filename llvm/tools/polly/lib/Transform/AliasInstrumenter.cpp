//===------------- AliasInstrumenter.h --------------------------*- C++ -*-===//
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

#include "polly/AliasInstrumenter.h"
#include "polly/LinkAllPasses.h"
#include "polly/ScopDetection.h"
#include "polly/Support/ScopHelper.h"
#include "polly/CloneRegion.h"
#include "polly/CodeGen/BlockGenerators.h"
#include "polly/Support/SCEVValidator.h"

using namespace llvm;
using namespace polly;

#define DEBUG_TYPE "polly-alias-instrumenter"

static const char *const traceFuncName = "memtrack_dumpArrayBounds";

Function* polly::declareTraceFunction(Module *M)
{
  LLVMContext  &ctx                 = M->getContext();
  Type         *const_char_ptr_type = TypeBuilder<const char*, false>::get(ctx);
  Type         *void_type           = TypeBuilder<void,        false>::get(ctx);
  Type         *void_ptr_type       = TypeBuilder<void*,       false>::get(ctx);

  std::vector<Type*> parameter_types
  {
    const_char_ptr_type, // const char *regionName
    const_char_ptr_type, // const char *valueName
    void_ptr_type,       // void       *value
    void_ptr_type,       // void       *lowGuess
    void_ptr_type        // void       *upGuess
  };

  auto fn_type  = FunctionType::get(void_type, parameter_types, false);
  auto trace_fn = M->getFunction(traceFuncName);

  if (!trace_fn) {
	  trace_fn = Function::Create(
	    FunctionType::get(void_type, parameter_types, false),
	    GlobalValue::ExternalLinkage,
	    traceFuncName,
	    M);

	  trace_fn->addAttribute(1, Attribute::ReadOnly);
	  trace_fn->addAttribute(2, Attribute::ReadOnly);
	  trace_fn->addAttribute(3, Attribute::ReadOnly);
	  trace_fn->addAttribute(4, Attribute::ReadOnly);
	  trace_fn->addAttribute(5, Attribute::ReadOnly);
  }

	if (trace_fn->getType() != fn_type->getPointerTo()) {
		errs() << "Trace function was already declared and has wrong type\n";
		exit(1);
		return nullptr;
	}

  return trace_fn;
}

// Generate dynamic alias checks for all pointers within the region for which
// dependencies can't be solved statically.
bool AliasInstrumenter::checkAndSolveDependencies(Region *r) {
  std::map<const Value *, std::set<const SCEV *> > memAccesses;
  std::set<std::pair<Value *, Value *> > pairsToCheck;
  AliasSetTracker ast(*aa);

  // Set instruction insertion context.
  Instruction *insertPtr = r->getEntry()->getFirstNonPHI();
  SCEVRangeAnalyser rangeAnalyser(se, aa, r, insertPtr);
  BuilderType builder(se->getContext(), TargetFolder(se->getDataLayout()));
  builder.SetInsertPoint(insertPtr);

  // Collect, for all memory accesses, their respective base pointer and access
  // function. For the accesses a[i], a[i+5], and b[i+j], we'd have something
  // like:
  // - memAccesses: {a: (i,i+5), b: (i+j)}
  // Also collect all pairs of base pointers that need to be dynamically checked
  // for aliasing. If the pointers a, b, and c may alias each other, we'd have:
  // - pairsToCheck: (<a,b>, <b,c>, <a,c>)
  for (BasicBlock *bb : r->blocks()) {
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

      if (!as.isMustAlias()) {
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
    }
  }

  std::map<Value *, std::pair<Value *, Value *> > pointerBounds;
  std::vector<Value *> checks;

  // Insert comparison expressions for every pair of pointers that need to be
  // checked.
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
      pointerBounds[pair.second], builder, rangeAnalyser);
    checks.push_back(check);
  }

  if (Value *checkResult = chainChecks(checks, builder))
    insertedChecks.push_back(std::make_pair(checkResult, r));

  return true;
}

// Prints the array bounds of a value
void AliasInstrumenter::printArrayBounds(Value *v, Value *l, Value *u, Region *r, BuilderType &builder, SCEVRangeAnalyser& rangeAnalyser)
{
  errs() << "Tracing value " << fin->getName(v) << " in region " << fin->getName(r->getEntry()) << "\n";

  Value *regName = builder.CreateGlobalStringPtr(fin->getName(r->getEntry()));
  Value *valName = builder.CreateGlobalStringPtr(fin->getName(v));

  Value *val = rangeAnalyser.InsertNoopCastOfTo(v, builder.getInt8PtrTy());
  Value *low = rangeAnalyser.InsertNoopCastOfTo(l, builder.getInt8PtrTy());
  Value *up  = rangeAnalyser.InsertNoopCastOfTo(u, builder.getInt8PtrTy());

  assert(trace_fn);
  builder.CreateCall5(trace_fn, regName, valName, val, low, up);
}

// Inserts a dynamic test to guarantee that accesses to two pointers do not
// overlap, by doing:
//   no-alias: upper(A) < lower(B) || upper(B) < lower(A)
Value *AliasInstrumenter::insertCheck(std::pair<Value *, Value *> boundsA,
                                      std::pair<Value *, Value *> boundsB,
                                      BuilderType &builder,
                                      SCEVRangeAnalyser &rangeAnalyser) {

  // Cast all bounds to i8* (equivalent to void*, according to the LLVM manual).
  Type *i8PtrTy = builder.getInt8PtrTy();
  Value *lowerA = rangeAnalyser.InsertNoopCastOfTo(boundsA.first, i8PtrTy);
  Value *upperA = rangeAnalyser.InsertNoopCastOfTo(boundsA.second, i8PtrTy);
  Value *lowerB = rangeAnalyser.InsertNoopCastOfTo(boundsB.first, i8PtrTy);
  Value *upperB = rangeAnalyser.InsertNoopCastOfTo(boundsB.second, i8PtrTy);

  Value *aIsBeforeB = builder.CreateICmpULT(upperA, lowerB);
  Value *bIsBeforeA = builder.CreateICmpULT(upperB, lowerA);
  return builder.CreateOr(aIsBeforeB, bIsBeforeA, "no-dyn-alias");
}

Value *AliasInstrumenter::chainChecks(std::vector<Value *> checks, BuilderType &builder) {
  if (checks.size() < 1)
    return nullptr;

  Value *rhs = checks[0];

  for (std::vector<Value *>::size_type i = 1; i != checks.size(); i++) {
    rhs = builder.CreateAnd(checks[i], rhs, "no-dyn-alias");
  }

  return rhs;
}

// Make all instrumented regions simple and isolate the dynamic checks.
void AliasInstrumenter::fixInstrumentedRegions() {
  // Reverse "insertedChecks", so that sub-regions always come first.
  std::reverse(insertedChecks.begin(), insertedChecks.end());

  // Regions that can't be fixed will be eliminated.
  std::vector<std::pair<Value *, Region *> > oldChecks(insertedChecks);
  insertedChecks.clear();

  for (auto &check : oldChecks) {
    Instruction *dyResult = dyn_cast<Instruction>(check.first);
    BasicBlock *entry = dyResult->getParent();
    Region *r = check.second;

    assert((dyResult && entry == r->getEntry()) && "Malformed dynamic check.");

    // Simplify the region if possible.
    if (isSafeToSimplify(r)) {
      if (!r->getEnteringBlock())
        r->replaceEntryRecursive(SplitBlock(entry, entry->begin(), li));
  
      if (!r->getExitingBlock()) {
        BasicBlock *newExit = createSingleExitEdge(r, li);
  
        for (auto &&subRegion : *r)
          subRegion->replaceExitRecursive(newExit);
      }
    }

    // Move the checks to the entering block.
    if (r->isSimple()) {
      Instruction *inst;
      BasicBlock::iterator it = dyResult->getParent()->getFirstNonPHI();
      Instruction *insertPtr = &r->getEnteringBlock()->back();

      do {
        inst = it;
        it++;
        inst->removeFromParent();
        inst->insertBefore(insertPtr);
      } while (inst != dyResult);

      insertedChecks.push_back(std::make_pair(check.first, r));
    }
  }
}

// Checks if creating single entry and exit edges for a region breaks the
// single-entry single-exit property.
bool AliasInstrumenter::isSafeToSimplify(Region *r) {
  bool safeToSimplify = true;

  for (auto *p : make_range(pred_begin(r->getEntry()), pred_end(r->getEntry())))
    if (r->contains(p) && p != r->getExit())
      safeToSimplify = false;

  for (auto *s : make_range(succ_begin(r->getExit()), succ_end(r->getExit())))
    if (r->contains(s) && s != r->getEntry())
      safeToSimplify = false;

  return safeToSimplify;
}

void AliasInstrumenter::cloneInstrumentedRegions() {
  if (insertedChecks.size() <= 0)
    return;

  fixInstrumentedRegions();

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

    fixAliasInfo(clonedRegion);
  }
}

// Use scoped alias tags to tell the compiler that pointer accesses in the
// cloned region do not alias, unless they have the same base pointer. This will
// allow other optimizations to take advantage of the information provided by
// the dynamic alias cheks.
void AliasInstrumenter::fixAliasInfo(Region *r) {
  std::map<const Value *, std::set<Instruction *> > memAccesses;

  // Build a map from base pointers to the instructions that can access them
  // within the region.
  for (BasicBlock *bb : r->blocks()) {
    for (BasicBlock::iterator i = bb->begin(), e = --bb->end(); i != e; ++i) {
      Instruction &inst = *i;

      if (!isa<LoadInst>(inst) && !isa<StoreInst>(inst))
        continue;

      Value *ptr = getPointerOperand(inst);
      Loop *l = li->getLoopFor(inst.getParent());
      const SCEV *accessFunction = se->getSCEVAtScope(ptr, l);
      const SCEVUnknown *basePointer =
        dyn_cast<SCEVUnknown>(se->getPointerBase(accessFunction));
      Value *basePointerValue = basePointer->getValue();

      memAccesses[basePointerValue].insert(i);
    }
  }

  MDBuilder MDB(currFn->getContext());
  if (!mdDomain)
    mdDomain = MDB.createAnonymousAliasScopeDomain(currFn->getName());
  DenseMap<const Value *, MDNode *> scopes;
  unsigned ptrCount = 0;

  // Create a different scope for each base pointer in the region.
  for (auto pair : memAccesses) {
    const Value *basePointer = pair.first;
    std::string name = currFn->getName();

    if (basePointer->hasName()) {
      name += ": %";
      name += basePointer->getName();
    } else {
      name += ": ptr ";
      name += utostr(ptrCount++);
    }

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

        // Slip the instruction own base pointer.
        if (otherBasePointer == basePointer)
          continue;

        memInst->setMetadata(LLVMContext::MD_noalias, MDNode::concatenate(
          memInst->getMetadata(LLVMContext::MD_noalias),
            MDNode::get(currFn->getContext(), scopes[otherBasePointer])));
      }
    }
  }
}

// Computes and prints the access bounds for a pointer.
bool AliasInstrumenter::computeAndPrintBounds(Value *pointer, Region *r) {
  std::set<const SCEV *>  memAccesses;

  // Set instruction insertion context.
  Instruction *insertPtr = r->getEntry()->begin();
  SCEVRangeAnalyser rangeAnalyser(se, aa, r, insertPtr);
  BuilderType builder(se->getContext(), TargetFolder(se->getDataLayout()));
  builder.SetInsertPoint(insertPtr);

  // Collect all access functions to to the pointer in the region.
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

      if (baseValue != pointer)
        continue;

      memAccesses.insert(accessFunction);
    }

  // Compute the lowest lower and greatest upper bounds.
  Value *low = rangeAnalyser.getULowerBound(memAccesses);
  Value *up = rangeAnalyser.getUUpperBound(memAccesses);

  if (!low || !up)
    return false;

  rangeAnalyser.insertPtrPrintf(low);
  rangeAnalyser.insertPtrPrintf(up);

  return true;
}

bool AliasInstrumenter::isInvariant(const Value &Val, const Region &Reg) {
  // A reference to function argument or constant value is invariant.
  if (isa<Argument>(Val) || isa<Constant>(Val))
    return true;

  const Instruction *I = dyn_cast<Instruction>(&Val);
  if (!I)
    return false;

  if (!Reg.contains(I))
    return true;

  if (I->mayHaveSideEffects())
    return false;

  // When Val is a Phi node, it is likely not invariant. We do not check whether
  // Phi nodes are actually invariant, we assume that Phi nodes are usually not
  // invariant. Recursively checking the operators of Phi nodes would lead to
  // infinite recursion.
  if (isa<PHINode>(*I))
    return false;

  for (const Use &Operand : I->operands())
    if (!isInvariant(*Operand, Reg))
      return false;

  // When the instruction is a load instruction, check that no write to memory
  // in the region aliases with the load.
  if (const LoadInst *li = dyn_cast<LoadInst>(I)) {
    AliasAnalysis::Location Loc = aa->getLocation(li);
    const Region::const_block_iterator BE = Reg.block_end();
    // Check if any basic block in the region can modify the location pointed to
    // by 'Loc'.  If so, 'Val' is (likely) not invariant in the region.
    for (const BasicBlock *BB : Reg.blocks())
      if (aa->canBasicBlockModify(*BB, Loc))
        return false;
  }

  return true;
}

bool AliasInstrumenter::isValidMemoryAccess(Instruction &Inst, Region &R) {
  Value *Ptr = getPointerOperand(Inst);
  Loop *L = li->getLoopFor(Inst.getParent());
  const SCEV *AccessFunction = se->getSCEVAtScope(Ptr, L);
  const SCEVUnknown *BasePointer;
  Value *BaseValue;

  BasePointer = dyn_cast<SCEVUnknown>(se->getPointerBase(AccessFunction));

  if (!BasePointer)
    return false;

  BaseValue = BasePointer->getValue();

  if (isa<UndefValue>(BaseValue))
    return false;

  // Check that the base address of the access is invariant in the current
  // region.
  if (!isInvariant(*BaseValue, R))
    // Verification of this property is difficult as the independent blocks
    // pass may introduce aliasing that we did not have when running the
    // scop detection.
    return false;

  AccessFunction = se->getMinusSCEV(AccessFunction, BasePointer);

  if (IntToPtrInst *Inst = dyn_cast<IntToPtrInst>(BaseValue))
    return false;

  return true;
}

bool AliasInstrumenter::isValidInstruction(Instruction &Inst, Region &R) {
  if (PHINode *PN = dyn_cast<PHINode>(&Inst))
    if (!canSynthesize(PN, li, se, &R))
      return false;

  // We only check the call instruction but not invoke instruction.
  if (CallInst *CI = dyn_cast<CallInst>(&Inst)) {
    if (isValidCallInst(*CI))
      return true;

    return false;
  }

  if (!Inst.mayWriteToMemory() && !Inst.mayReadFromMemory()) {
    if (!isa<AllocaInst>(Inst))
      return true;

    return false;
  }

  // Check the access function.
  if (isa<LoadInst>(Inst) || isa<StoreInst>(Inst))
    return isValidMemoryAccess(Inst, R);

  // We do not know this instruction, therefore we assume it is invalid.
  return false;
}

bool AliasInstrumenter::isValidLoop(Loop *L, Region &R) {
  // Ensure that each loop has a canonical induction variable.
  PHINode *IndVar = L->getCanonicalInductionVariable();

  if (!IndVar)
    return false;

  // Is the loop count affine?
  const SCEV *LoopCount = se->getBackedgeTakenCount(L);
  if (!isAffineExpr(&R, LoopCount, *se))
    return false;

  return true;
}

bool AliasInstrumenter::isValidExit(Region &R) {
  // PHI nodes are not allowed in the exit basic block.
  if (BasicBlock *Exit = R.getExit()) {
    BasicBlock::iterator I = Exit->begin();
    if (I != Exit->end() && isa<PHINode>(*I))
      return false;
  }

  return true;
}

bool AliasInstrumenter::isValidCFG(BasicBlock &BB, Region &R) {
  TerminatorInst *TI = BB.getTerminator();

  // Return instructions are only valid if the region is the top level region.
  if (isa<ReturnInst>(TI) && !R.getExit() && TI->getNumOperands() == 0)
    return true;

  BranchInst *Br = dyn_cast<BranchInst>(TI);

  if (!Br)
    return false;

  if (Br->isUnconditional())
    return true;

  Value *Condition = Br->getCondition();

  // UndefValue is not allowed as condition.
  if (isa<UndefValue>(Condition))
    return false;

  // Only Constant and ICmpInst are allowed as condition.
  if (!(isa<Constant>(Condition) || isa<ICmpInst>(Condition)))
    return false;

  // Allow perfectly nested conditions.
  assert(Br->getNumSuccessors() == 2 && "Unexpected number of successors");

  if (ICmpInst *ICmp = dyn_cast<ICmpInst>(Condition)) {
    // Unsigned comparisons are not allowed. They trigger overflow problems
    // in the code generation.
    //
    // TODO: This is not sufficient and just hides bugs. However it does pretty
    // well.
    if (ICmp->isUnsigned())
      return false;

    // Are both operands of the ICmp affine?
    if (isa<UndefValue>(ICmp->getOperand(0)) ||
        isa<UndefValue>(ICmp->getOperand(1)))
      return false;

    Loop *L = li->getLoopFor(ICmp->getParent());
    const SCEV *LHS = se->getSCEVAtScope(ICmp->getOperand(0), L);
    const SCEV *RHS = se->getSCEVAtScope(ICmp->getOperand(1), L);

    if (!isAffineExpr(&R, LHS, *se) ||
        !isAffineExpr(&R, RHS, *se))
      return false;
  }

  // Allow loop exit conditions.
  Loop *L = li->getLoopFor(&BB);
  if (L && L->getExitingBlock() == &BB)
    return true;

  // Allow perfectly nested conditions.
  Region *bbR = ri->getRegionFor(&BB);
  if (bbR->getEntry() != &BB)
    return false;

  return true;
}

bool AliasInstrumenter::allBlocksValid(Region &R) {
  for (const BasicBlock *BB : R.blocks()) {
    Loop *L = li->getLoopFor(BB);
    if (L && L->getHeader() == BB && !isValidLoop(L, R))
      return false;
  }

  for (BasicBlock *BB : R.blocks())
    if (!isValidCFG(*BB, R))
      return false;

  for (BasicBlock *BB : R.blocks())
    for (BasicBlock::iterator I = BB->begin(), E = --BB->end(); I != E; ++I)
      if (!isValidInstruction(*I, R))
        return false;

  // Try to solve dependencies through instrumentation/
  if (!checkAndSolveDependencies(&R))
    return false;

  return true;
}

bool AliasInstrumenter::isValidRegion(Region &R) {
  // Top-level regions can't be a SCoP.
  if (R.isTopLevelRegion())
    return false;

  if (!R.getEnteringBlock()) {
    BasicBlock *entry = R.getEntry();
    Loop *L = li->getLoopFor(entry);

    if (L) {
      if (!L->isLoopSimplifyForm())
        return false;

      for (pred_iterator PI = pred_begin(entry), PE = pred_end(entry); PI != PE;
           ++PI) {
        // Region entering edges come from the same loop but outside the region
        // are not allowed.
        if (L->contains(*PI) && !R.contains(*PI))
          return false;
      }
    }
  }

  // SCoP cannot contain the entry block of the function, because we need
  // to insert alloca instruction there when translate scalar to array.
  if (R.getEntry() == &(R.getEntry()->getParent()->getEntryBlock()))
    return false;

  if (!isValidExit(R))
    return false;

  if (!allBlocksValid(R))
    return false;

  return true;
} 

static bool regionWithoutLoops(Region &R, LoopInfo *LI) {
  for (const BasicBlock *BB : R.blocks())
    if (R.contains(LI->getLoopFor(BB)))
      return false;

  return true;
}

void AliasInstrumenter::findScops(Region &R) {
  if (regionWithoutLoops(R, li))
    return;

  bool IsValidRegion = isValidRegion(R);

  // If this region can be fully handled, stop the search.
  if (IsValidRegion)
    return;

  for (auto &SubRegion : R)
    findScops(*SubRegion);

  // TODO: we should look for expanded regions, as ScopDetection does.
}

bool AliasInstrumenter::runOnFunction(llvm::Function &F) {
  li = &getAnalysis<LoopInfo>();
  ri = &getAnalysis<RegionInfoPass>().getRegionInfo();
  aa = &getAnalysis<AliasAnalysis>();
  se = &getAnalysis<ScalarEvolution>();
  dt = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  pdt = &getAnalysis<PostDominatorTree>();
  df = &getAnalysis<DominanceFrontier>();
  fin = &getAnalysis<FullInstNamer>();

  auto trace_fn = declareTraceFunction(F.getParent());
  currFn = &F;
  Region *TopRegion = ri->getTopLevelRegion();

  releaseMemory();
  findScops(*TopRegion);
  cloneInstrumentedRegions();
  
  return false;
}

void AliasInstrumenter::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.addRequired<DominatorTreeWrapperPass>();
  AU.addRequired<PostDominatorTree>();
  AU.addRequired<DominanceFrontier>();
  AU.addRequired<LoopInfo>();
  AU.addRequired<ScalarEvolution>();
  AU.addRequired<AliasAnalysis>();
  AU.addRequired<RegionInfoPass>();
  AU.addRequired<FullInstNamer>();

  // Changing the CFG like we do doesn't preserve anything.
  AU.addPreserved<AliasAnalysis>();
}

char AliasInstrumenter::ID = 0;

Pass *polly::createAliasInstrumenterPass() { return new AliasInstrumenter(); }

INITIALIZE_PASS_BEGIN(AliasInstrumenter, "polly-instrument-dependences",
                      "Polly - Instrument alias dependencies", false,
                      false);
INITIALIZE_AG_DEPENDENCY(AliasAnalysis);
INITIALIZE_PASS_DEPENDENCY(DominatorTreeWrapperPass);
INITIALIZE_PASS_DEPENDENCY(LoopInfo);
INITIALIZE_PASS_DEPENDENCY(PostDominatorTree);
INITIALIZE_PASS_DEPENDENCY(DominanceFrontier);
INITIALIZE_PASS_DEPENDENCY(RegionInfoPass);
INITIALIZE_PASS_DEPENDENCY(ScalarEvolution);
INITIALIZE_PASS_DEPENDENCY(FullInstNamer);
INITIALIZE_PASS_END(AliasInstrumenter, "polly-instrument-dependences",
                    "Polly - Instrument alias dependencies", false, false) 
