/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include <llvm/Analysis/AliasAnalysis.h>
#include <llvm/Analysis/RegionInfo.h>
#include <llvm/IR/Dominators.h>
#include <llvm/IR/Constants.h>
#include "BasePtrInfo.h"
#include "Common.h"
#include <list>

//#define DEBUG(x) x
#define DEBUG_TYPE "base-ptrs"

using namespace llvm;
using namespace std;
using namespace ilc;

/************************* PRIVATE API ************************/

bool BasePtrInfo::mayReadOrWriteMemory(Instruction *i)
{
  /* TODO: check the above cases
    - MemTransfer    --
    - MemIntrinsic    |
    - Fence           | May Read/Write
    - GetElementPtr   | memory operations
    - Invoke          |
    - Call           --
  */
  switch(i->getOpcode())
  {
    case Instruction::Load:
    case Instruction::Store:
    case Instruction::VAArg:
    case Instruction::AtomicCmpXchg:
    case Instruction::AtomicRMW:
      return true;
    default:
      return false;
   }
}

AliasAnalysis::Location BasePtrInfo::getLocation(Instruction *i)
{
  /* TODO: check the above cases
    - MemTransfer    --
    - MemIntrinsic    |
    - Fence           | May Read/Write
    - GetElementPtr   | memory operations
    - Invoke          |
    - Call           --
  */
  switch(i->getOpcode())
  {
    case Instruction::Load:
      return aliasAnalysis.getLocation(cast<LoadInst>(i));
    case Instruction::Store:
      return aliasAnalysis.getLocation(cast<StoreInst>(i));
    case Instruction::VAArg:
      return aliasAnalysis.getLocation(cast<VAArgInst>(i));
    case Instruction::AtomicCmpXchg:
      return aliasAnalysis.getLocation(cast<AtomicCmpXchgInst>(i));
    case Instruction::AtomicRMW:
      return aliasAnalysis.getLocation(cast<AtomicRMWInst>(i));
    default:
      DEBUG(dbgs() << *i << "\n");
      llvm_unreachable("Unhandled type of memory instruction");
   }
}

void BasePtrInfo::getBasePtrs(Value *ModRefVal, ValueSet& basePtrs, ValueSet& visited)
{
  if(visited.count(ModRefVal)) return;
  else visited.insert(ModRefVal);

  if(isGlobalOrArgument(ModRefVal))
  {
    basePtrs.insert(ModRefVal);
    return;
  }

  if (auto const_expr = dyn_cast<ConstantExpr>(ModRefVal))
  {
    for (Value *op : const_expr->operand_values())
    {
      if (op->getType()->isPointerTy())
        getBasePtrs(op, basePtrs, visited);
    }
    return;
  }

  Instruction *ModRefInstr = cast<Instruction>(ModRefVal);

  if (domTree.dominates(ModRefInstr->getParent(), entry))
  {
    basePtrs.insert(ModRefVal);
    return;
  }

  // TODO: think if we need to check more cases
  switch(ModRefInstr->getOpcode())
  {
    case Instruction::Load:
    case Instruction::Call:
    case Instruction::Invoke:
      // we cannot tell about indirections
      basePtrs.insert(nullptr);
      return;
    case Instruction::Store:
      ModRefVal = ((StoreInst *)ModRefInstr)->getPointerOperand();
      break;
    case Instruction::GetElementPtr:
      ModRefVal = ((GetElementPtrInst *)ModRefInstr)->getPointerOperand();
      break;
    case Instruction::VAArg:
      ModRefVal = ((VAArgInst *)ModRefInstr)->getPointerOperand();
     break;
    case Instruction::AtomicCmpXchg:
      ModRefVal = ((AtomicCmpXchgInst *)ModRefInstr)->getPointerOperand();
      break;
    case Instruction::AtomicRMW:
      ModRefVal = ((AtomicRMWInst *)ModRefInstr)->getPointerOperand();
      break;
    case Instruction::PtrToInt:
      ModRefVal = ((PtrToIntInst *)ModRefInstr)->getPointerOperand();
      break;
    case Instruction::BitCast:
      ModRefVal = ((BitCastInst *)ModRefInstr)->getOperand(0);
      break;
    case Instruction::Select:
    case Instruction::PHI:
      for(unsigned i=0; i<ModRefInstr->getNumOperands(); ++i)
      {
        Value *pointerOp = ModRefInstr->getOperand(i);
        // do not track the condition operand of the select instruction
        if(!pointerOp->getType()->isPointerTy()) continue;
        getBasePtrs(pointerOp, basePtrs, visited);
      }
      return;
    default:
      errs() << *ModRefInstr << "\n";
      llvm_unreachable("Unhandled type of instruction");
      assert(false);
  }

  getBasePtrs(ModRefVal, basePtrs, visited);
}

ValueSet& BasePtrInfo::getOrInsertBasePtrs(Instruction *i)
{
  // look up in map
  InstructionMap::iterator I = basePtrs_for_instruction.find(i);

  if(I != basePtrs_for_instruction.end()) return *(I->second);

  Value    *ptr      = const_cast<Value*>((getLocation(i)).Ptr);
  ValueSet *basePtrs = new ValueSet();
  ValueSet  visited;

  // update map
  basePtrs_for_instruction[i] = basePtrs;

  getBasePtrs(ptr, *basePtrs, visited);

  return *basePtrs;
}

void BasePtrInfo::rebuildAllBasePtrs()
{
  allBasePtrs.clear();

  for (auto pair : basePtrPairs)
  {
    assert(pair.first);
    assert(pair.second);

    allBasePtrs.insert(pair.first);
    allBasePtrs.insert(pair.second);
  }
}

void BasePtrInfo::buildInfo(list<Instruction*>& ModRefInstructions)
{
  // list of may-alias instruction pairs
  set<InstrPair> MayAliasPairs;

  // check each possible pair of memory accesses that may alias
  while(!ModRefInstructions.empty())
  {
    for(list<Instruction*>::iterator I = ModRefInstructions.begin(), IE = ModRefInstructions.end(); ++I != IE;)
    {
      Instruction *i1 = ModRefInstructions.front();
      Instruction *i2 = *I;

      if(aliasAnalysis.alias(getLocation(i1), getLocation(i2)) == AliasAnalysis::MayAlias)
        MayAliasPairs.insert(orderedPair(i1, i2));
    }
    ModRefInstructions.pop_front();
  }

  // find the base pointers of each pair of may-alias instructions
  for(set<InstrPair>::iterator I = MayAliasPairs.begin(), IE = MayAliasPairs.end(); I != IE; ++I)
  {
    // debug print
    DEBUG(dbgs() << "-----------------------------------------------------------\n");
    DEBUG(dbgs() << "may-alias instructions\n");
    DEBUG(dbgs() << "-----------------------------------------------------------\n");
    DEBUG(dbgs() << *(I->first) << "\n");
    DEBUG(dbgs() << *(I->second) << "\n");

    ValueSet& basePtrs1 = getOrInsertBasePtrs(I->first);
    ValueSet& basePtrs2 = getOrInsertBasePtrs(I->second);

    // it seems we reached a load instruction, thus we cannot decide for aliasing
    if(basePtrs1.count(nullptr) || basePtrs2.count(nullptr)) continue;

    // debug print
    DEBUG(dbgs() << "-----------------------------------------------------------\n");
    DEBUG(dbgs() << "base ptrs of instr1\n");
    DEBUG(dbgs() << "-----------------------------------------------------------\n");
    for(ValueSet::iterator I1 = basePtrs1.begin(), IE1 = basePtrs1.end(); I1 != IE1; ++I1) { DEBUG(dbgs() << *(cast<Value>(*I1)) << "\n"); }
    DEBUG(dbgs() << "-----------------------------------------------------------\n");
    DEBUG(dbgs() << "base ptrs of instr2\n");
    DEBUG(dbgs() << "-----------------------------------------------------------\n");
    for(ValueSet::iterator I2 = basePtrs2.begin(), IE2 = basePtrs2.end(); I2 != IE2; ++I2) { DEBUG(dbgs() << *(cast<Value>(*I2)) << "\n"); }

    // create pairs of base pointers
    for(ValueSet::iterator I1 = basePtrs1.begin(), IE1 = basePtrs1.end(); I1 != IE1; ++I1)
    {
      for(ValueSet::iterator I2 = basePtrs2.begin(), IE2 = basePtrs2.end(); I2 != IE2; ++I2)
      {
        if(*I1 == *I2) continue;

	basePtrPairs.insert(orderedPair(*I1, *I2));
      }
    }
  }

  rebuildAllBasePtrs();
}


/**************************** PUBLIC API ***************************/

BasePtrInfo::BasePtrInfo(llvm::Loop* loop, llvm::DominatorTree& tree, llvm::AliasAnalysis& aa)
 : entry{loop->getLoopPreheader()}
 , domTree{tree}
 , aliasAnalysis(aa)
{
  list<Instruction*> ModRefInstructions;

  // find all memory accesses in the loop body
  for(Loop::block_iterator B = loop->block_begin(), BE = loop->block_end(); B != BE; ++B)
  {
    BasicBlock *bb = *B;

    for(BasicBlock::iterator I = bb->begin(), IE = bb->end(); I != IE; ++I)
    {
      Instruction *i = I;

      //if(i->mayReadOrWriteMemory())
      if(mayReadOrWriteMemory(i))
        ModRefInstructions.push_back(i);
    }
  }

  buildInfo(ModRefInstructions);
}

BasePtrInfo::BasePtrInfo(llvm::Region* region, llvm::DominatorTree& tree, llvm::AliasAnalysis& aa)
 : entry{region->getEnteringBlock()}
 , domTree{tree}
 , aliasAnalysis(aa)
{
  list<Instruction*> ModRefInstructions;

  // find all memory accesses in the loop body
  for(auto bb : region->blocks())
  {
    for(BasicBlock::iterator I = bb->begin(), IE = bb->end(); I != IE; ++I)
    {
      Instruction *i = I;

      //if(i->mayReadOrWriteMemory())
      if(mayReadOrWriteMemory(i))
        ModRefInstructions.push_back(i);
    }
  }

  buildInfo(ModRefInstructions);
}

BasePtrInfo::~BasePtrInfo()
{
  for(InstructionMap::iterator I = basePtrs_for_instruction.begin(), IE = basePtrs_for_instruction.end(); I != IE; ++I)
    delete I->second;
}

set<ValuePair>& BasePtrInfo::getBasePtrPairs()
{
  return basePtrPairs;
}

InstructionMap& BasePtrInfo::getInstructionMap()
{
  return basePtrs_for_instruction;
}


ValueSet& BasePtrInfo::getBasePtrs(Instruction *i)
{
  assert(basePtrs_for_instruction.count(i));

  return *basePtrs_for_instruction[i];
}

const ValueSet& BasePtrInfo::getAllBasePtrs() const
{
  return allBasePtrs;
}

/// remove all data for the given set of base ptr pairs
void BasePtrInfo::filter(const std::set<ValuePair>& badPairs)
{
  // remove unwanted pairs
  for (auto badPair : badPairs)
  {
    auto it = basePtrPairs.find(badPair);

    if (it != basePtrPairs.end())
      basePtrPairs.erase(it);
  }

  rebuildAllBasePtrs();
}

