//===------------- RegionAliasInfo.cpp --------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

#include "polly/RegionAliasInfo.h"

#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/Analysis/PostDominators.h"
#include "llvm/Analysis/RegionInfo.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/TypeBuilder.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Support/CorseCommon.h"

#include "polly/CloneRegion.h"
#include "polly/LinkAllPasses.h"
#include "polly/SCEVRangeBuilder.h"
#include "polly/SpeculativeAliasAnalysis.h"
#include "polly/ScopDetection.h"
#include "polly/CodeGen/BlockGenerators.h"
#include "polly/Support/SCEVValidator.h"
#include "polly/Support/ScopHelper.h"
#include "polly/LinkAllPasses.h"

using namespace llvm;
using namespace polly;

#define DEBUG_TYPE "polly-region-alias-info"

struct RegionAliasInfoBuilder {
  RegionAliasInfoBuilder(
    ScalarEvolution *se,
    AliasAnalysis *aa,
    LoopInfo *li,
    DominatorTree *dt,
    PostDominatorTree *pdt,
    DominanceFrontier *df,
    std::vector<AliasInstrumentationContext>& regions
  ) : se(se), aa(aa), li(li), dt(dt), pdt(pdt), df(df), regions(regions) {}

  // Walks the region tree, collecting the greatest possible regions that can be
  // safely instrumented.
  void findTargetRegions(Region *r);

  // Checks if a region can be simplified to have single entry and exit EDGES
  // without breaking the sinlge entry and exit BLOCKS property. This can happen
  // when edges from within the region point to its entry or exit.
  bool isSafeToSimplify(const Region *r);

  // Checks if the given region has all the properties needed for
  // instrumentation.
  bool canInstrument(AliasInstrumentationContext &context);

  // Checks if the given instruction doesn't break the properties needed for
  // instrumentation (basically checks if it doesn't access memory in an
  // unpredictable way).
  bool isValidInstruction(Instruction &inst);

  // Collects, for each memory access instruction in the region, its base
  // pointers, access function, and pointers that need to be checked against it
  // so it can be considered alias-free.
  bool collectDependencyData(AliasInstrumentationContext &context);

  // Tries to give the loop an invariant backedge taken count, by modifying the
  // loop structure then inserting some checks that guarantee its correctness.
  // We currently check if the loop bound comes from a loop variant load from
  // an invariant address. If so, we try to hoist the load to outside the loop,
  // thus making it possible to compute an invariant BE count. During check
  // insertion, we generate a dynamic check that guarantees that no other store
  // aliases the hoisted load.
  bool createArtificialInvariantBECount(Loop *l,
                                        AliasInstrumentationContext &context);

  // Get the value that represents the base pointer of the given memory access
  // instruction in the given region. The pointer must be region invariant.
  Value *getBasePtrValue(Instruction &inst, const Region &r);

  // Analyses used.
  ScalarEvolution *se;
  AliasAnalysis *aa;
  LoopInfo *li;
  DominatorTree *dt;
  PostDominatorTree *pdt;
  DominanceFrontier *df;

  std::vector<AliasInstrumentationContext>& regions;
};

void polly::findAliasInstrumentableRegions(
    Region *region,
    ScalarEvolution *se,
    AliasAnalysis *aa,
    LoopInfo *li,
    DominatorTree *dt,
    PostDominatorTree *pdt,
    DominanceFrontier *df,
    std::vector<AliasInstrumentationContext>& out
) {
  RegionAliasInfoBuilder builder(se, aa, li, dt, pdt, df, out);

  builder.findTargetRegions(region);
}

void polly::simplifyRegion(Region *r, LoopInfo *li) {
  auto entering = r->getEnteringBlock();

  // Create a new entering block to host the checks. If an entering block
  // already exists, just reuse it. If not, create one from the region entry.
  if (entering && (entering != &entering->getParent()->getEntryBlock())) {
    SplitBlock(entering, entering->getTerminator(), li);
  } else {
    auto entry = r->getEntry();
    r->replaceEntryRecursive(SplitBlock(entry, entry->begin(), li));
  }

  // Create exiting block.
  if (!r->getExitingBlock()) {
    BasicBlock *newExit = createSingleExitEdge(r, li);

    for (auto &&subRegion : *r)
      subRegion->replaceExitRecursive(newExit);
  }
}


bool RegionAliasInfoBuilder::isSafeToSimplify(const Region *r) {
  if (r->isSimple())
    return true;

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

Value *RegionAliasInfoBuilder::getBasePtrValue(Instruction &inst,
                                              const Region &r) {
  Value *ptr = getPointerOperand(inst);
  Loop *l = li->getLoopFor(inst.getParent());
  const SCEV *accessFunction = se->getSCEVAtScope(ptr, l);
  const SCEVUnknown *basePointer =
    dyn_cast<SCEVUnknown>(se->getPointerBase(accessFunction));

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

bool RegionAliasInfoBuilder::collectDependencyData(
                            AliasInstrumentationContext &context) {
  const auto region          = context.region;
  auto&      ptrPairsToCheck = context.ptrPairsToCheck;

  AliasSetTracker ast(*aa);

  // build alias sets
  // TODO: this does yet another pass over the blocks of the region,
  //       can we reuse context.memAccesses, or something like it?
  for (BasicBlock *bb : region->blocks())
    ast.add(*bb);

  // find which checks we need to insert
  for (BasicBlock *bb : region->blocks()) {
    for (BasicBlock::iterator i = bb->begin(), e = --bb->end(); i != e; ++i) {
      Instruction &inst = *i;

      if (!isa<LoadInst>(inst) && !isa<StoreInst>(inst))
        continue;

      Value *basePtrValue = getBasePtrValue(inst, *region);

      // If we can't define the base pointer, then it's not possible to define
      // the dependencies.
      if (!basePtrValue)
        return false;

      // Store this access expression.
      Value *ptr = getPointerOperand(inst);
      Loop *l = li->getLoopFor(inst.getParent());
      const SCEV *accessFunction = se->getSCEVAtScope(ptr, l);
      context.memAccesses[basePtrValue].addMemoryAccess(&inst, accessFunction);

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

          ptrPairsToCheck.insert(pair);
        }
      }
    }
  }

  return true;
}

bool RegionAliasInfoBuilder::isValidInstruction(Instruction &inst) {
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



// TODO: insert checks for the load address.
// TODO: after cloning, replace uses of the old load in the cloned region
//       be the new load and eliminate the old load.
bool RegionAliasInfoBuilder::createArtificialInvariantBECount(Loop *l,
                            AliasInstrumentationContext &context) {
  Region     &r        = *context.region;
  BasicBlock *entering = r.getEnteringBlock();

  // We need an entering block to put the hoisted load, which cannot be the
  // function entry block.
  if (!entering || (entering ==  &(entering->getParent()->getEntryBlock())))
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
  Instruction *addr = dyn_cast<Instruction>(oldLoad->getPointerOperand());

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

bool RegionAliasInfoBuilder::canInstrument(AliasInstrumentationContext &context) {
  const auto region = context.region;

  // Top-level regions can't be instrumented.
  if (region->isTopLevelRegion())
    return false;

  // We need an entering block to insert the dynamic checks, so if a region
  // can't simplified, it can't be instrumented.
  if (!isSafeToSimplify(region))
    return false;

  // Do not instrument regions without loops.
  bool hasLoop = false;

  for (const BasicBlock *bb : region->blocks())
    if (region->contains(li->getLoopFor(bb)))
      hasLoop = true;

  if (!hasLoop)
    return false;

  // Make sure that all loops in the region have a symbolic limit.
  for (BasicBlock *bb : region->blocks()) {
    Loop *l = li->getLoopFor(bb);

    // If a loop doesn't have a defined limit, try to create an artificial one.
    if (l && (l->getHeader() == bb) &&
        !se->hasLoopInvariantBackedgeTakenCount(l) &&
        !createArtificialInvariantBECount(l, context))
      return false;
  }

  // Check that all instructions are valid.
  for (BasicBlock *bb : region->blocks())
    for (BasicBlock::iterator i = bb->begin(), e = --bb->end(); i != e; ++i)
      if (!isValidInstruction(*i))
        return false;

  // If dependencies can't be fully defined, then we can't instrument.
  if (!collectDependencyData(context))
    return false;

  // Make sure that access bounds can be computed for every access expression
  // within the region.
  Instruction *insertPt = region->getEntry()->getFirstNonPHI();
  SCEVRangeBuilder rangeBuilder(se, aa, li, dt, region, insertPt);
  rangeBuilder.setArtificialBECounts(context.getBECountsMap());

  for (auto& pair : context.memAccesses)
    if (!rangeBuilder.canComputeBoundsFor(pair.second.accessFunctions))
      return false;

  return true;
}

void RegionAliasInfoBuilder::findTargetRegions(Region *r) {
  AliasInstrumentationContext context(r);

  // If the whole region can be instrumented, stop the search.
  if (canInstrument(context)) {
    regions.push_back(context);
    return;
  }

  // If the region can't be instrumented, look at smaller regions.
  for (auto &subRegion : *r)
    findTargetRegions(subRegion.get());
}
