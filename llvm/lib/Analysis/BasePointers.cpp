/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include <llvm/Analysis/BasePointers.h>
#include <llvm/Analysis/AliasAnalysis.h>
#include <llvm/Analysis/RegionInfo.h>
#include <llvm/IR/Dominators.h>
#include <llvm/IR/Constants.h>
#include <llvm/Support/CorseCommon.h>
#include <vector>

//#define DEBUG(x) x
#define DEBUG_TYPE "base-ptrs"

using namespace llvm;
using namespace std;

/************************* PRIVATE API ************************/

struct BasePtrBuilder {
  BasePtrBuilder(BasicBlock*    entry,
                 AliasAnalysis& aa,
                 DominatorTree& dom_tree)
   : entry(entry), aa(aa), dom_tree(dom_tree) {
    assert(entry);
  }

  BasePtrInfo build(std::vector<Instruction*>& mem_instrs) {
    BasePtrInfo info;

    DEBUG(dbgs() << "-----------------------------------------------------------\n");
    DEBUG(dbgs() << "computing base ptrs for " << mem_instrs.size() << "memory acces(es)\n");
    DEBUG(dbgs() << "-----------------------------------------------------------\n");

    // list of may-alias instruction pairs
    set<InstrPair> MayAliasPairs;

    // check each possible pair of memory accesses that may alias

    for (auto i = mem_instrs.begin(), end = mem_instrs.end(); i != end; ++i) {
      for (auto j = i; ++j != end;) {
        Instruction *i1 = *i;
        Instruction *i2 = *j;

        if(aa.alias(getLocation(i1), getLocation(i2)) == AliasAnalysis::MayAlias)
          MayAliasPairs.insert(orderedPair(i1, i2));
      }
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

      ValueSet& basePtrs1 = getBasePtrs(info, I->first);
      ValueSet& basePtrs2 = getBasePtrs(info, I->second);

      // it seems we reached a load instruction, thus we cannot decide for aliasing
      if(basePtrs1.count(nullptr) || basePtrs2.count(nullptr)) 
        continue;

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
          if(*I1 == *I2)
            continue;

          info.basePtrPairs.insert(orderedPair(*I1, *I2));
        }
      }
    }

    info.rebuildAllBasePtrs();

    return info;
  }
private:
  ValueSet& getBasePtrs(BasePtrInfo& info, Instruction *i)
  {
    // look up in map
    auto I = info.basePtrs_for_instruction.find(i);

    if (I != info.basePtrs_for_instruction.end())
      return I->second;

    ValueSet& basePtrs = info.basePtrs_for_instruction[i];
    ValueSet  visited;

    for (Value *op : i->operands()) {
      if (op->getType()->isPointerTy()) {
        getBasePtrs(op, basePtrs, visited);
      }
    }

    return basePtrs;
  }

  void getBasePtrs(Value *ModRefVal, ValueSet& basePtrs, ValueSet& visited)
  {
    if (visited.count(ModRefVal)) {
      return;
    } else {
      visited.insert(ModRefVal);
    }

    if (isGlobalOrArgument(ModRefVal))
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

    if (dom_tree.dominates(ModRefInstr->getParent(), entry))
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
        outs() << ">> " << *ModRefVal << " is poison\n";
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
        for(unsigned i = 0, end = ModRefInstr->getNumOperands(); i < end; ++i)
        {
          Value *pointerOp = ModRefInstr->getOperand(i);
          // do not track the condition operand of the select instruction
          if (!pointerOp->getType()->isPointerTy())
            continue;
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

  AliasAnalysis::Location getLocation(Instruction *i) {
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
        return aa.getLocation(cast<LoadInst>(i));
      case Instruction::Store:
        return aa.getLocation(cast<StoreInst>(i));
      case Instruction::VAArg:
        return aa.getLocation(cast<VAArgInst>(i));
      case Instruction::AtomicCmpXchg:
        return aa.getLocation(cast<AtomicCmpXchgInst>(i));
      case Instruction::AtomicRMW:
        return aa.getLocation(cast<AtomicRMWInst>(i));
      default:
        DEBUG(dbgs() << *i << "\n");
        llvm_unreachable("Unhandled type of memory instruction");
    }
  }

  BasicBlock*               entry;
  std::vector<Instruction*> mem_instrs;
  AliasAnalysis&            aa;
  DominatorTree&            dom_tree;
};

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

static bool mayReadOrWriteMemory(Instruction *i)
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

/**************************** PUBLIC API ***************************/

BasePtrInfo BasePtrInfo::build(llvm::Loop* loop, llvm::DominatorTree& tree, llvm::AliasAnalysis& aa)
{
  vector<Instruction*> ModRefInstructions;

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

  BasePtrBuilder builder{loop->getLoopPreheader(), aa, tree};

  return builder.build(ModRefInstructions);
}

BasePtrInfo BasePtrInfo::build(llvm::Region* region, llvm::DominatorTree& tree, llvm::AliasAnalysis& aa)
{
  vector<Instruction*> ModRefInstructions;

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

  BasePtrBuilder builder{region->getEnteringBlock(), aa, tree};

  return builder.build(ModRefInstructions);
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

  return basePtrs_for_instruction[i];
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

