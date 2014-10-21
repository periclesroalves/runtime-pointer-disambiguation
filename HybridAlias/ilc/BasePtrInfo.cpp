
#include "ilc/BasePtrInfo.hpp"

#include <llvm/Analysis/AliasAnalysis.h>
#include <llvm/IR/Dominators.h>

#define DEBUG_TYPE "base-ptrs"

using namespace llvm;
using namespace std;

using InstrPair = pair<Instruction*, Instruction*>;

struct BasePtrBuilder {
	BasePtrBuilder(Loop* loop, DominatorTree& tree, AliasAnalysis& aa)
	 : loop{loop}
	 , entry{loop->getLoopPreheader()}
	 , domTree{tree}
	 , aliasAnalysis{aa}
	{}

	BasePtrInfo build();
private:
	void getBasePtrs(Value *ptr, set<Value*>& basePtrs);
	void getBasePtrs(Value *ptr, set<Value*>& basePtrs, set<Value*>& visited);

	AliasAnalysis::Location getLocation(Instruction *inst);
	static Value* getPointerOperand(Instruction *instr);

	const Loop* const       loop;
	const BasicBlock* const entry;
	const DominatorTree&    domTree;
	AliasAnalysis&          aliasAnalysis;
};

BasePtrInfo::BasePtrInfo() : dirty{true} {}

BasePtrInfo BasePtrInfo::compute(llvm::Loop*          loop,
	                             llvm::DominatorTree& tree,
	                             llvm::AliasAnalysis& aa)
{
	BasePtrBuilder builder{loop, tree, aa};

	return builder.build();
}

static set<Value*> collectBasePtrs(const set<BasePtrPair>& pairs);
static bool        isGlobalOrArgument(const Value *v);

template<typename T>
static pair<T*, T*> orderedPair(T* a, T* b);

const std::set<llvm::Value*>& BasePtrInfo::getAllBasePtrs()
{
	if (dirty)
	{
		allBasePtrs = collectBasePtrs(basePtrPairs);
		dirty = false;
	}

	return allBasePtrs;
}

const std::set<BasePtrPair>&  BasePtrInfo::getBasePtrPairs()
{
	return basePtrPairs;
}

const std::set<llvm::Value*>& BasePtrInfo::getBasePtrsForInstruction(const llvm::Instruction *i)
{
	auto i2 = const_cast<Instruction*>(i);

	assert(basePtrs_for_instruction.count(i2));

	return basePtrs_for_instruction[i2];
}

/// remove all data for the given set of base ptr pairs
void BasePtrInfo::filter(const std::set<BasePtrPair>& badPairs)
{
	set<Value*> badPtrs = collectBasePtrs(badPairs);

	// remove unwanted pairs
	for (auto badPair : badPairs)
	{
		auto it = basePtrPairs.find(badPair);

		if (it != basePtrPairs.end())
			basePtrPairs.erase(it);
	}

	// make sure allBasePtrs is recomputed when needed
	dirty = true;

	// remove unwanted base ptrs for instructions
	for (auto& mapping : basePtrs_for_instruction)
	{
		auto& basePtrs = mapping.second;

		for (Value *badPtr : badPtrs)
		{
			auto it = basePtrs.find(badPtr);

			if (it != basePtrs.end())
				basePtrs.erase(it);
		}
	}
}

AliasAnalysis::Location BasePtrBuilder::getLocation(Instruction *instr)
{
	/* TODO: check the above cases
	  - MemTransfer    --
	  - MemIntrinsic    |
	  - Fence           | May Read/Write
	  - GetElementPtr   | memory operations
	  - Invoke          |
	  - Call           --
	*/
	switch(instr->getOpcode())
	{
		case Instruction::Load:
		  	return aliasAnalysis.getLocation(cast<LoadInst>(instr));
		case Instruction::Store:
	  		return aliasAnalysis.getLocation(cast<StoreInst>(instr));
		case Instruction::VAArg:
	  		return aliasAnalysis.getLocation(cast<VAArgInst>(instr));
		case Instruction::AtomicCmpXchg:
	  		return aliasAnalysis.getLocation(cast<AtomicCmpXchgInst>(instr));
		case Instruction::AtomicRMW:
	  		return aliasAnalysis.getLocation(cast<AtomicRMWInst>(instr));
		default:
			llvm_unreachable("Unhandled type of memory instruction");
	}
}

Value* BasePtrBuilder::getPointerOperand(Instruction *instr)
{
	/* TODO: check the above cases
	  - MemTransfer    --
	  - MemIntrinsic    |
	  - Fence           | May Read/Write
	  - GetElementPtr   | memory operations
	  - Invoke          |
	  - Call           --
	*/
	switch(instr->getOpcode())
	{
		case Instruction::Load:
	  		return cast<LoadInst>(instr)->getPointerOperand();
		case Instruction::Store:
	  		return cast<StoreInst>(instr)->getPointerOperand();
		case Instruction::VAArg:
	  		return cast<VAArgInst>(instr)->getPointerOperand();
		case Instruction::AtomicCmpXchg:
	  		return cast<AtomicCmpXchgInst>(instr)->getPointerOperand();
		case Instruction::AtomicRMW:
	  		return cast<AtomicRMWInst>(instr)->getPointerOperand();
		default:
			llvm_unreachable("Unhandled type of memory instruction");
	}
}

BasePtrInfo BasePtrBuilder::build()
{
	set<Value*> allBasePtrs;
	set<pair<Value*,Value*>> basePtrPairs;
	BasePtrInfo::InstructionMap basePtrs_for_instruction;

	// memory accessing instructions
	vector<Instruction*> mem_instrs;
	// list of may-alias location pairs
	set<InstrPair> MayAliasPairs;

  // find all memory accesses in the loop body
  for(BasicBlock *BB : loop->getBlocks())
  {
    for(BasicBlock::iterator I = BB->begin(), IE = BB->end(); I != IE; ++I)
    {
      Instruction *instr = I;

    	if (instr->mayReadOrWriteMemory())
    		mem_instrs.push_back(instr);
		}
	}

  // check each possible pair of memory accesses that may alias
	for (auto it1 = mem_instrs.begin(), end1 = mem_instrs.end(); it1 != end1; ++it1)
	{
		Instruction             *instr1 = *it1;
		AliasAnalysis::Location  loc1   = getLocation(instr1);

		for (auto it2 = mem_instrs.begin(); it2 != it1; ++it2)
		{
			Instruction             *instr2 = *it2;
			AliasAnalysis::Location  loc2   = getLocation(instr2);

			if(aliasAnalysis.alias(loc1, loc2) == AliasAnalysis::MayAlias)
      	MayAliasPairs.insert(orderedPair(instr1, instr2));
		}
	}

  // find the base pointers of each pair of may-alias instructions
  for(auto I : MayAliasPairs)
  {
		// debug print
		DEBUG(dbgs() << "-----------------------------------------------------------\n");
		DEBUG(dbgs() << "may-alias locations\n");
		DEBUG(dbgs() << "-----------------------------------------------------------\n");
		DEBUG(dbgs() << *(I.first)  << "\n");
		DEBUG(dbgs() << *(I.second) << "\n");

		set<Value*> basePtrs1;
		getBasePtrs(getPointerOperand(I.first), basePtrs1);

		set<Value*> basePtrs2;
		getBasePtrs(getPointerOperand(I.second), basePtrs2);

		// it seems we reached a load instruction, thus we cannot decide for aliasing
		if ((basePtrs1.count(nullptr) != 0) || (basePtrs2.count(nullptr) != 0))
			continue;

		if (basePtrs_for_instruction.count(I.first) == 0)
		 	basePtrs_for_instruction[I.first]  = basePtrs1;

		if (basePtrs_for_instruction.count(I.second) == 0)
			basePtrs_for_instruction[I.second] = basePtrs2;

		// debug print
		DEBUG(dbgs() << "-----------------------------------------------------------\n");
		DEBUG(dbgs() << "base ptrs loc1\n");
		DEBUG(dbgs() << "-----------------------------------------------------------\n");
		for(set<Value*>::iterator I1 = basePtrs1.begin(), IE1 = basePtrs1.end(); I1 != IE1; ++I1) { DEBUG(dbgs() << *I1 << "\n"); }
		DEBUG(dbgs() << "-----------------------------------------------------------\n");
		DEBUG(dbgs() << "base ptrs loc2\n");
		DEBUG(dbgs() << "-----------------------------------------------------------\n");
		for(set<Value*>::iterator I2 = basePtrs2.begin(), IE2 = basePtrs2.end(); I2 != IE2; ++I2) { DEBUG(dbgs() << *I2 << "\n"); }

		// create pairs of base pointers
		for(set<Value*>::iterator I1 = basePtrs1.begin(), IE1 = basePtrs1.end(); I1 != IE1; ++I1)
		{
		  for(set<Value*>::iterator I2 = basePtrs2.begin(), IE2 = basePtrs2.end(); I2 != IE2; ++I2)
		  {
		  	Value *ptr1 = *I1;
		  	Value *ptr2 = *I2;

		    if(ptr1 == ptr2)
		    	continue;

		    auto pair = orderedPair(ptr1, ptr2);

			allBasePtrs.insert(ptr1);
			allBasePtrs.insert(ptr2);

			basePtrPairs.insert(pair);
		  }
		}
	}

	BasePtrInfo info;

	info.basePtrPairs             = std::move(basePtrPairs);
	info.basePtrs_for_instruction = std::move(basePtrs_for_instruction);

	return info;
}

void BasePtrBuilder::getBasePtrs(Value *pointerVal, set<Value*>& basePtrs)
{
	set<Value*> visited;

	getBasePtrs(pointerVal, basePtrs, visited);
}

void BasePtrBuilder::getBasePtrs(Value *ModRefVal, set<Value*>& basePtrs, set<Value*>& visited)
{
  if (visited.count(ModRefVal))
  	return;
  visited.insert(ModRefVal);

	Instruction *ModRefInstr = dyn_cast<Instruction>(ModRefVal);

	assert(isa<Instruction>(ModRefVal) || isGlobalOrArgument(ModRefVal));

	if(isGlobalOrArgument(ModRefVal) || domTree.dominates(ModRefInstr->getParent(), entry))
	{
    basePtrs.insert(ModRefVal);
    return;
	}

  // TODO: think if we need to check more cases
  switch(ModRefInstr->getOpcode())
  {
    case Instruction::Load:
    case Instruction::Call:
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
      for(int i=0; i<ModRefInstr->getNumOperands(); ++i)
      {
        Value *pointerOp = ModRefInstr->getOperand(i);
        // do not track the condition operand of the select instruction
        if(!pointerOp->getType()->isPointerTy()) continue;
        getBasePtrs(pointerOp, basePtrs, visited);
      }
      return;
    default:
      ModRefInstr->print(errs());
      llvm_unreachable("Unhandled type of instruction");
      assert(false);
  }

	getBasePtrs(ModRefVal, basePtrs, visited);
}

static set<Value*> collectBasePtrs(const set<BasePtrPair>& pairs)
{
	set<Value*> bases;

	for (auto pair : pairs)
	{
		assert(pair.first);
		assert(pair.second);

		bases.insert(pair.first);
		bases.insert(pair.second);
	}

	return bases;
}


static bool isGlobalOrArgument(const Value *v)
{
	return isa<GlobalValue>(v) || isa<Argument>(v);
}

template<typename T>
static pair<T*, T*> orderedPair(T* a, T* b)
{
	return (a < b ? make_pair(a, b) : make_pair(b, a));
}
