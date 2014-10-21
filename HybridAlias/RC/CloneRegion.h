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

#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/Analysis/RegionInfo.h"
#include "llvm/Analysis/RegionPass.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/Instructions.h"
#include "llvm/ADT/DenseMap.h"
#include <map>

using namespace llvm;
using namespace std;

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

/// CloneRegion. Clone dominator info. Populate VMap
/// using old blocks to new blocks mapping.
Region *cloneRegion(Region *R, /*RGPassManager *RGM,*/ RegionInfo *RI, DominatorTree *DT, /*PostDominatorTree *PDT,*/ DominanceFrontier *DF) 
{
  assert(R->isSimple() && "Region has a single entry and a single exit");
  assert((BasicBlock *)&R->getEntry()->getParent()->front() != (BasicBlock *)R->getEntry() && "Region's first bb is not the first bb of the parent function");

  ValueMap<const Value*, WeakVH> VMap;
  SmallVector<BasicBlock *, 16>  NewBlocks;
  
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

  return new Region(cast<BasicBlock>(VMap.find(R->getEntry())->second), R->getExit(), RI, DT, R->getParent());
}
