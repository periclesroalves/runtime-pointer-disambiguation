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
#include "llvm/Support/Format.h"

#include "polly/CloneRegion.h"
#include "polly/LinkAllPasses.h"
#include "polly/SCEVRangeBuilder.h"
#include "polly/SpeculativeAliasAnalysis.h"
#include "polly/ScopDetection.h"
#include "polly/CodeGen/BlockGenerators.h"
#include "polly/Support/SCEVValidator.h"
#include "polly/Support/ScopHelper.h"
#include "polly/LinkAllPasses.h"
#include "polly/Support/AliasCheckBuilders.h"

using namespace llvm;
using namespace polly;

#define DEBUG_TYPE "polly-region-alias-info"

struct RegionAliasInfoBuilder {
  RegionAliasInfoBuilder(
    ScalarEvolution *se,
    AliasAnalysis *aa,
    SpeculativeAliasAnalysis *saa,
    LoopInfo *li,
    DominatorTree *dt,
    AliasCheckFlags flags,
    std::vector<std::unique_ptr<AliasInstrumentationContext>>& regions
  )
  : se(se), aa(aa), saa(saa), li(li), dt(dt)
  , flags(flags), regions(regions) {}

  // Walks the region tree, collecting the greatest possible regions that can be
  // safely instrumented.
  void findTargetRegions(Region *r) {
    // make_unique is C++14 :(
    std::unique_ptr<AliasInstrumentationContext> context{
      new AliasInstrumentationContext(r)
    };

    // If the whole region can be instrumented, stop the search.
    if (canInstrument(*context)) {
      regions.push_back(std::move(context));
      return;
    }

    // If the region can't be instrumented, look at smaller regions.
    for (auto &subRegion : *r)
      findTargetRegions(subRegion.get());
  }
private:
  using Context         = AliasInstrumentationContext;
  using MemoryAccessMap = Context::MemoryAccessMap;
  using MemoryAccess    = Context::MemoryAccess;
  using ValuePair       = std::pair<Value*, Value*>;
  using ValuePairSet    = std::set<ValuePair>;

  // Checks if the given region has all the properties needed for
  // instrumentation.
  bool canInstrument(AliasInstrumentationContext &context) {
    const auto region = context.region;

    // errs() << "canInstrument? " << region->getNameStr() << "\n";

    // ** check basic properties of region

    if (region->isTopLevelRegion())
      return false;

    if (!isSafeToSimplify(region))
      return false;

    if (!containsLoops(region))
      return false;

    if (!containsOnlyValidInstructions(region))
      return false;

    // ** try to collect information about region

    // get base pointers, the instructions that use them and their
    // access functions.
    if (!collectMemoryAccesses(context))
      return false;

    // TODO: only insert loads on success.
    context.allLoopsHaveBounds = ensureAllLoopsHaveSymbolicBackedgeCount(context);

    // find pairs of base ptrs with aliasing users
    if (!collectPtrPairsToCheck(context))
      return false;

    return true;
  }

  bool canBuildScevCheck(AliasInstrumentationContext &context,
                         SCEVRangeBuilder &rangeBuilder,
                         Value *ptr1, Value *ptr2) {
    if (!flags.UseSCEVAliasChecks)
      return false;

    if (!context.allLoopsHaveBounds)
      return false;

    return isValidScevBasePtr(context, rangeBuilder, ptr1)
        && isValidScevBasePtr(context, rangeBuilder, ptr2);
  }

  bool isValidScevBasePtr(AliasInstrumentationContext &context,
                          SCEVRangeBuilder &rangeBuilder,
                          Value *basePtr) {
    // We can't handle direct address manipulation.
    if (isa<UndefValue>(basePtr) || isa<IntToPtrInst>(basePtr))
      return false;

    // The base pointer can vary within the given region.
    if (!ScopDetection::isInvariant(*basePtr, *context.region, li, aa))
      return false;

    auto &accessFunctions = context.memAccesses[basePtr].accessFunctions;

    return rangeBuilder.canComputeBoundsFor(accessFunctions);
  }

  bool canBuildHeapCheck(AliasInstrumentationContext &context,
                         Value *ptr1, Value *ptr2) {
    if (!flags.UseHeapAliasChecks)
      return false;

    const auto *region = context.region;

    return notDefinedInRegion(region, ptr1)
        && notDefinedInRegion(region, ptr2);
  }

  static bool notDefinedInRegion(const Region *r, Value *v) {
    if (auto *inst = dyn_cast<Instruction>(v))
      return !r->contains(inst);
    return true;
  }

  // Checks if a region can be simplified to have single entry and exit EDGES
  // without breaking the sinlge entry and exit BLOCKS property. This can happen
  // when edges from within the region point to its entry or exit.
  bool isSafeToSimplify(const Region *r) {
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

  bool collectMemoryAccesses(AliasInstrumentationContext &context) {
    const auto region = context.region;

    for (auto *bb : region->blocks()) {
      for (auto &inst : bb->getInstList()) {
        // TODO: what about other memory instructions?
        if (!isa<LoadInst>(inst) && !isa<StoreInst>(inst))
          continue;

        Value *basePtrValue = getBasePtrValue(inst, *region);

        if (!basePtrValue)
          return false;

        // Compute access expression.
        Value *ptr = getPointerOperand(inst);
        Loop *l = li->getLoopFor(inst.getParent());
        const SCEV *accessFunction = se->getSCEVAtScope(ptr, l);

        context.addMemoryAccess(basePtrValue, &inst, accessFunction);
      }
    }

    return true;
  }

  bool collectPtrPairsToCheck(AliasInstrumentationContext &context) {
    auto *region         = context.region;
    auto *function       = region->getEntry()->getParent();
    auto &memAccesses    = context.memAccesses;
    auto &heapChecks     = context.heapChecks;
    auto &scevChecks     = context.scevChecks;
    auto &equalityChecks = context.ptrPairsToEqualityCheck;

    auto begin = memAccesses.begin();
    auto end   = memAccesses.end();

    // Make sure that access bounds can be computed for every access expression
    // within the region.
    Instruction *insertPt = region->getEntry()->getFirstNonPHI();
    SCEVRangeBuilder rangeBuilder(se, aa, li, dt, region, insertPt);
    rangeBuilder.setArtificialBECounts(context.getBECountsMap());

    // create pairs of base pointers
    for (auto i = begin; i != end; ++i) {
      for (auto j = i; ++j != end; /**/) {
        Value *ptr1 = i->first;
        Value *ptr2 = j->first;

        // bool heap = canBuildHeapCheck(context, ptr1, ptr2);
        // bool scev = canBuildScevCheck(context, rangeBuilder, ptr1, ptr2);

        // std::string name = context.region->getNameStr();

        // outs() << format("%-40s", name.c_str())
        //        << " "
        //        << format("%-15s", ptr1->getName().data())
        //        << " "
        //        << format("%-15s", ptr2->getName().data())
        //        << " "
        //        << (heap ? "HEAP" : "    ")
        //        << " "
        //        << (scev ? "SCEV" : "    ")
        //        << "\n";

        // if (!anyUsersMayAlias(*i, *j))
        //   continue;
        switch (saa->speculativeAlias(function, ptr1, ptr2)) {
          case SpeculativeAliasResult::NoHeapAlias:
            assert(false && "XXX: just here for experiments");
            if (canBuildHeapCheck(context, ptr1, ptr2)) {
              heapChecks.addPair(context, ptr1, ptr2);
            } else if (canBuildScevCheck(context, rangeBuilder, ptr1, ptr2)) {
              scevChecks.addPair(context, ptr1, ptr2);
            } else {
              return false;
            }
            break;

          case SpeculativeAliasResult::NoAlias:
          case SpeculativeAliasResult::DontKnow:
            // TODO: evaluate which check to use for these cases
          case SpeculativeAliasResult::NoRangeOverlap:
            if (canBuildScevCheck(context, rangeBuilder, ptr1, ptr2)) {
              scevChecks.addPair(context, ptr1, ptr2);
            } else if (canBuildHeapCheck(context, ptr1, ptr2)) {
              heapChecks.addPair(context, ptr1, ptr2);
            } else {
              return false;
            }
            break;

          case SpeculativeAliasResult::ExactAlias:
            // TODO: do must-alias checks
          case SpeculativeAliasResult::ProbablyAlias:
            // don't insert checks that will only fail anyway
            assert(false && "XXX: just here for experiments");
            return false;
        }
      }
    }

    return true;
  }

  /// Check if any user of two base pointers have a badly defined
  /// alias relationship (i.e. may-alias, but not must-alias or no-alias)
  bool anyUsersMayAlias(const MemoryAccess &a, const MemoryAccess &b) {
    for (auto *user1 : a.second.users) {
      for (auto *user2 : b.second.users) {
        if (user1 == user2)
          continue;

        switch (aa->alias(a.first, b.first)) {
          case AliasAnalysis::MayAlias:
          case AliasAnalysis::PartialAlias:
            return true;
          case AliasAnalysis::MustAlias:
          case AliasAnalysis::NoAlias:
            break;
        }
      }
    }

    return false;
  }

  // Check if the given region contains any loops
  bool containsLoops(const Region *region) {
    for (const Loop *loop : *li)
      if (region->contains(loop))
        return true;

    return false;
  }

  // Check if the given region contains only instructions polly can handle
  bool containsOnlyValidInstructions(const Region *region) {
    for (const auto *bb : region->blocks())
      for (const auto &i : bb->getInstList())
        if (!isValidInstruction(i))
          return false;

    return true;
  }

  // Checks if the given instruction doesn't break the properties needed for
  // instrumentation (basically checks if it doesn't access memory in an
  // unpredictable way).
  bool isValidInstruction(const Instruction &inst) {
    if (const auto *CI = dyn_cast<CallInst>(&inst)) {
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

  // ensure that all loops have a backedge count expressable as a SCEV.
  // If this fails we can't compute bounds and have to use heap checks
  // note: this function inserts new instructions!
  bool ensureAllLoopsHaveSymbolicBackedgeCount(
                                        AliasInstrumentationContext& context) {
    auto *region = context.region;
    std::set<Instruction*> hoistedLoads;

    // Make sure that all loops in the region have a symbolic limit.
    for (Loop *loop : *li) {
      if (!region->contains(loop))
        continue;

      // If a loop doesn't have a defined limit, try to create an artificial one.
      if (!se->hasLoopInvariantBackedgeTakenCount(loop) &&
          !createArtificialInvariantBECount(loop, context, hoistedLoads)) {

        // cleanup
        context.artificialBECounts.clear();
        for (auto *load : hoistedLoads)
          load->eraseFromParent();

        return false;
      }
    }
    return true;
  }

  // Tries to give the loop an invariant backedge taken count, by modifying the
  // loop structure then inserting some checks that guarantee its correctness.
  // We currently check if the loop bound comes from a loop variant load from
  // an invariant address. If so, we try to hoist the load to outside the loop,
  // thus making it possible to compute an invariant BE count. During check
  // insertion, we generate a dynamic check that guarantees that no other store
  // aliases the hoisted load.
  bool createArtificialInvariantBECount(Loop *l,
                                        AliasInstrumentationContext &context,
                                        std::set<Instruction*> &hoistedLoads);

  // Get the value that represents the base pointer of the given memory access
  // instruction in the given region. The pointer must be region invariant.
  Value *getBasePtrValue(Instruction &inst, const Region &r);

  // Analyses used.
  ScalarEvolution *se;
  AliasAnalysis *aa;
  SpeculativeAliasAnalysis *saa;
  LoopInfo *li;
  DominatorTree *dt;

  AliasCheckFlags flags;

  std::vector<std::unique_ptr<AliasInstrumentationContext>>& regions;
};

void polly::findAliasInstrumentableRegions(
    Region *region,
    ScalarEvolution *se,
    AliasAnalysis *aa,
    SpeculativeAliasAnalysis *saa,
    LoopInfo *li,
    DominatorTree *dt,
    const AliasCheckFlags &flags,
    std::vector<std::unique_ptr<AliasInstrumentationContext>>& out
) {
  RegionAliasInfoBuilder builder(se, aa, saa, li, dt, flags, out);

  builder.findTargetRegions(region);
}

void polly::simplifyRegion(Region *r, LoopInfo *li) {
  auto entering = r->getEnteringBlock();

  // Create a new entering block to host the checks. If an entering block
  // already exists, just reuse it. If not, create one from the region entry.
  if (entering && (entering != &entering->getParent()->getEntryBlock()) &&
      isa<BranchInst>(entering->getTerminator()) &&
      dyn_cast<BranchInst>(entering->getTerminator())->isUnconditional()) {
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

bool RegionAliasInfoBuilder::createArtificialInvariantBECount(Loop *l,
                                        AliasInstrumentationContext &context,
                                        std::set<Instruction*> &hoistedLoads) {
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

  hoistedLoads.insert(newLoad);

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

// record which users of base ptr are stores
static void addStoreTargets(AliasInstrumentationContext &ctx,
                            std::set<Value*>& dst, Value *basePtr) {
  // if no hoisting happened there is no need to guard stores.
  if (!ctx.allLoopsHaveBounds)
    return;

  for (Value *user : ctx.memAccesses[basePtr].users)
    if (isa<StoreInst>(user))
      dst.insert(basePtr);
}

void AliasInstrumentationContext::NoAliasChecks::addPair(
                            AliasInstrumentationContext &ctx,
                            Value *ptr1, Value *ptr2) {
  auto pair = make_ordered_pair(ptr1, ptr2);

  ptrPairsToCheck.insert(pair);

  addStoreTargets(ctx, storeTargets, ptr1);
  addStoreTargets(ctx, storeTargets, ptr2);
}
