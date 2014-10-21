#include "llvm/Transforms/Instrumentation.h"
#include "llvm/Transforms/Utils/Cloning.h"
#include "llvm/Pass.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Function.h"
#include "llvm/Analysis/RegionInfo.h"
#include "llvm/Analysis/RegionPass.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/Analysis/DominanceFrontier.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/Support/raw_ostream.h"
#include "CloneRegion.h"
#include <set>

using namespace llvm;
using namespace std;

namespace 
{
  struct CloneRegion : public RegionPass
  {
    static char ID;
 
    CloneRegion() : RegionPass(ID) {}

    bool        runOnRegion(Region *R, RGPassManager &RGM) override;
    const char *getPassName()                              const override { return "CloneRegion"; }
    void        getAnalysisUsage(AnalysisUsage &AU)        const override 
    { 
      AU.addRequired<RegionInfo>(); 
      AU.addRequired<DominatorTreeWrapperPass>();
      //AU.addRequired<PostDominatorTree>();
      AU.addRequired<DominanceFrontier>();
    }

  private:
    Region            *currReg;
    Region            *clonedReg;
    //set<Region *>      clonedRegs;
    RegionInfo        *RI;
    DominatorTree     *DT;
    //PostDominatorTree *PDT;
    DominanceFrontier *DF;
  };
}

char   CloneRegion::ID = 0;
static RegisterPass<CloneRegion> X("cloneRegion", "Region Cloning", false, false);

static void printRegion(Region *R)
{
  errs() << "========================================================\nFunction = "                
         << R->getEntry()->getParent()->getName() << ", RegEntry = " << R->getEntry()->getName()
         << ")\n========================================================\n";

  for (Region::block_iterator I = R->block_begin(), E = R->block_end(); I != E; ++I)
    if(*I) errs() << ((BasicBlock *)*I)->getName() << "\n";
    else errs() << "null\n";
}

bool CloneRegion::runOnRegion(Region *R, RGPassManager &RGM)
{
  //cannot clone regions with more that one entries or more than one exits
  if(!R->isSimple()) return false;

  //do not clone already cloned regions
  //if(clonedRegs.count(R)) return false;

  //R->print(errs());
  printRegion(R);

  //set instance variables
  currReg = R;
  RI      = &getAnalysis<RegionInfo>();
  DT      = &getAnalysis<DominatorTreeWrapperPass>().getDomTree();
  //PDT     = &getAnalysis<PostDominatorTree>(); 
  DF      = &getAnalysis<DominanceFrontier>();

  //clone region
  clonedReg = cloneRegion(R, /*&RGM,*/ RI, DT, /*PDT,*/ DF);
  //clonedRegs.insert(clonedReg);

  printRegion(clonedReg);

  //fix control flow
  Instruction *Branch = &R->getEnteringBlock()->back();  
  IRBuilder<> IRB(R->getEnteringBlock());
  IRB.CreateCondBr(IRB.getTrue(), clonedReg->getEntry() /*true path*/, R->getEntry() /*false path*/);
  Branch->eraseFromParent();

  return true;
}

