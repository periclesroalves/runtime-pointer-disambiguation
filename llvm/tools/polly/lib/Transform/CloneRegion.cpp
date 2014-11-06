//===- CloneRegion.cpp - Clone region nest ------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the CloneRegion interface which makes a copy of a region.
//
//===----------------------------------------------------------------------===//

#include "polly/CloneRegion.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/Analysis/RegionInfo.h"
#include "llvm/Analysis/RegionPass.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/Support/Debug.h"
#include <map>
#include <set>

using namespace llvm;
using namespace std;

#define DEBUG_TYPE "polly-clone-region"

using ValueSet = set<Value*>;
using InstrSet = set<Instruction*>;

/// CloneDominatorInfo - Clone basicblock's dominator tree and, if available,
/// dominance info. It is expected that basic block is already cloned.
static void CloneDominatorInfo(BasicBlock *BB,
                               ValueMap<const Value*, WeakVH> &VMap,
                               DominatorTree *DT,
                               DominanceFrontier *DF)
{
  assert (DT && "DominatorTree is not available");
  ValueMap<const Value*, WeakVH>::iterator BI = VMap.find(BB);
  assert (BI != VMap.end() && "BasicBlock clone is missing");
  BasicBlock *NewBB = cast<BasicBlock>(BI->second);

  // NewBB already got dominator info.
  if (DT->getNode(NewBB)) return;

  assert (DT->getNode(BB) && "BasicBlock does not have dominator info");

  // Entry block is not expected here. Infinite loops are not to cloned.
  assert (DT->getNode(BB)->getIDom() && "BasicBlock does not have immediate dominator");

  BasicBlock *BBDom = DT->getNode(BB)->getIDom()->getBlock();
  // NewBB's dominator is either BB's dominator or BB's dominator's clone.
  BasicBlock *NewBBDom = BBDom;
  ValueMap<const Value*, WeakVH>::iterator BBDomI = VMap.find(BBDom);

  if (BBDomI != VMap.end())
  {
    NewBBDom = cast<BasicBlock>(BBDomI->second);
    if (!DT->getNode(NewBBDom)) CloneDominatorInfo(BBDom, VMap, DT, DF);
  }
  DT->addNewBlock(NewBB, NewBBDom);

  // Copy cloned dominance frontiner set
  if (DF)
  {
    DominanceFrontier::DomSetType NewDFSet;
    DominanceFrontier::iterator DFI = DF->find(BB);
    if ( DFI != DF->end())
    {
      DominanceFrontier::DomSetType S = DFI->second;
      for (DominanceFrontier::DomSetType::iterator I = S.begin(), E = S.end(); I != E; ++I)
      {
        BasicBlock *DB = *I;
        ValueMap<const Value*, WeakVH>::iterator IDM = VMap.find(DB);
        if (IDM != VMap.end()) NewDFSet.insert(cast<BasicBlock>(IDM->second));
        else NewDFSet.insert(DB);
      }
    }
    DF->addBasicBlock(NewBB, NewDFSet);
  }
}

/// Find values created in region used outside of it
static void findOutputs(Region *region, InstrSet& outputs) {
	for (auto BB : region->blocks()) {
		// If an instruction is used outside the region, it's an output.
		for (BasicBlock::iterator II = BB->begin(), IE = BB->end(); II != IE; ++II) {
			for (User *user : II->users()) {
				// an instruction can only be used by instructions, right?
				auto *using_instr = cast<Instruction>(user);

				if (!region->contains(using_instr))
					outputs.insert(II);
			}
		}
	}
}

/// CloneRegion. Clone dominator info. Populate VMap
/// using old blocks to new blocks mapping.
Region *polly::cloneRegion(Region *R, RGPassManager *RGM, RegionInfo *RI, DominatorTree *DT, DominanceFrontier *DF)
{
  assert(R->isSimple() && "Region has a single entry and a single exit");
  assert((BasicBlock *)&R->getEntry()->getParent()->front() != (BasicBlock *)R->getEntry() && "Region's first bb is not the first bb of the parent function");

  ValueMap<const Value*, WeakVH> VMap;
  SmallVector<BasicBlock *, 16>  NewBlocks;
  InstrSet                       outputs;

  // find outputs of region
  findOutputs(R, outputs);

  // Clone Basic Blocks.
  for (Region::block_iterator I = R->block_begin(), E = R->block_end(); I != E; ++I)
  {
    BasicBlock *BB = *I;
    BasicBlock *NewBB = CloneBasicBlock(BB, VMap, ".clone");
    VMap[BB] = NewBB;
    NewBlocks.push_back(NewBB);
  }

  // Clone dominator info.
  if(DT)
  {
    for (Region::block_iterator I = R->block_begin(), E = R->block_end(); I != E; ++I)
    {
      BasicBlock *BB = *I;
      CloneDominatorInfo(BB, VMap, DT, DF);
    }
  }

  // Remap instructions to reference operands from VMap.
  for(SmallVector<BasicBlock *, 16>::iterator NBItr = NewBlocks.begin(), NBE = NewBlocks.end();  NBItr != NBE; ++NBItr)
  {
    BasicBlock *NB = *NBItr;
    for(BasicBlock::iterator BI = NB->begin(), BE = NB->end(); BI != BE; ++BI)
    {
      Instruction *Insn = BI;
      for (unsigned index = 0, num_ops = Insn->getNumOperands(); index != num_ops; ++index)
      {
        Value *Op = Insn->getOperand(index);
        ValueMap<const Value*, WeakVH>::iterator OpItr = VMap.find(Op);
        if (OpItr != VMap.end()) Insn->setOperand(index, OpItr->second);

        // Fix phi-functions
        if(Insn->getOpcode() == Instruction::PHI)
        {
          PHINode *phiNode = (PHINode *)Insn;
          ValueMap<const Value*, WeakVH>::iterator I = VMap.find(phiNode->getIncomingBlock(index));
          if(I != VMap.end()) phiNode->setIncomingBlock(index, cast<BasicBlock>(I->second));
        }
      }
    }
  }

  Function *F = R->getEnteringBlock()->getParent();
  F->getBasicBlockList().insert(R->getEntry(), NewBlocks.begin(), NewBlocks.end());

  auto newRegion = new Region(cast<BasicBlock>(VMap.find(R->getEntry())->second), R->getExit(), RI, DT, R->getParent());

  // **** alter Phi's in exit block of region

	// ** add cloned basic blocks to phi's that use blocks of the original region
	// yes, this can happen. -O3, for example, sometimes produces phi's with only one choice in the exit block

	for (auto BB : R->blocks())
	{
		auto terminator = BB->getTerminator();

		assert(terminator);

		for (unsigned i = 0, end = terminator->getNumSuccessors(); i < end; i++)
		{
			auto succ = terminator->getSuccessor(i);

			// only update PHIs outside the region
			if (R->contains(succ))
				continue;

			for (auto it = succ->begin(), end = succ->end(); it != end; ++it)
			{
				PHINode *PN = dyn_cast<PHINode>(it);

				if (!PN)
					break;

				// if the phi uses the original block we must add the cloned version
				int idx = PN->getBasicBlockIndex(BB);

				if (idx < 0)
					continue;

				auto value = PN->getIncomingValue(idx);

				assert(VMap[BB]);
				assert(VMap[value]);

				PN->addIncoming(VMap[value], cast<BasicBlock>(VMap[BB]));
			}
		}
	}

	// ** replace uses of values produced inside region with phi that merges in the value of the cloned region
  auto exiting = R->getExitingBlock(); // inside  region
  auto exit    = R->getExit();         // outside region

  assert(exiting);
  assert(exit);
  assert(exit == newRegion->getExit());

	BasicBlock *cloned_exiting = [&]() {
		auto it = VMap.find(exiting);

		assert(it != VMap.end());

		return cast<BasicBlock>(it->second);
	}();

	IRBuilder<> irb{exit->begin()};

	for (Value *output : outputs)
	{
		DEBUG(dbgs() << "Updating uses of " << *output << "\n");

		assert(VMap.count(output));

		PHINode *phi = irb.CreatePHI(output->getType(), 2);

		// replace all uses of output OUTSIDE of loop with phi

		for (User *user : output->users()) {
			// an instruction can only be used by instructions, right?
			auto *using_instr = cast<Instruction>(user);

			if (R->contains(using_instr))
				continue;

			DEBUG(dbgs() << "Updating use:\n");
			DEBUG(dbgs() << "  user:        " << *using_instr << "\n");
			DEBUG(dbgs() << "  old operand: " << *output      << "\n");
			DEBUG(dbgs() << "  new operand: " << *phi         << "\n");

			using_instr->replaceUsesOfWith(output, phi);
		}

		// can't add these before, otherwise use in new phi would be replaced
		phi->addIncoming(output,       exiting);
		phi->addIncoming(VMap[output], cloned_exiting);
	}

	exit->dump();

  return newRegion;
}
