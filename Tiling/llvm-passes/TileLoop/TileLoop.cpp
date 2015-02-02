//===- ScalarEvolutionMustDependenceAnalysis.cpp - SCEV-based Alias Analysis -------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the TileLoop pass, which implements a
// simple alias analysis implemented in terms of ScalarEvolution queries.
//
// This differs from traditional loop dependence analysis in that it tests
// for dependencies within a single iteration of a loop, rather than
// dependencies between different iterations.
//
// ScalarEvolution has a more complete understanding of pointer arithmetic
// than BasicAliasAnalysis' collection of ad-hoc analyses.
//
//===----------------------------------------------------------------------===//


/*
scev diff in both directions
shaddow edge removes an anti dep
if shaddow edge has negetive dist it removes dep
mem dep compute in bot directions (split flow and anti)
  - what to do with output and input? double dependence in both directions?


*/

/*
http://llvm.org/docs/doxygen/html/IndVarSimplify_8cpp_source.html
 */
#include <typeinfo>
#include <algorithm>
#include <vector>
#include <utility>

#include "llvm/Analysis/Passes.h"
#include "llvm/Analysis/AliasAnalysis.h"
//#include "llvm/Analysis/GlobalsModRef.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/Pass.h"
//#include "llvm/User.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/Analysis/MemoryDependenceAnalysis.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/CommandLine.h"

#include "PassTools.h"
#include "Graph.h"
#include "ParseTools.h"
#include "Tile.h"
#include "Tiling.h"

#define MY_MOD
#define LOOP_PASS

using namespace llvm;


namespace llvm {
  class PassRegistry;
  class FunctionPass;
  void initializeTileLoopPass(PassRegistry&);
  FunctionPass *createTileLoopPass();

  cl::opt<std::string> TileGraphFileIn(
      "tile-graph-file-in", 
      cl::desc("Specify input file path to read tiling dependence graphs"), 
      cl::value_desc("File path")
  );

  cl::opt<std::string> TilingFileIn(
      "tiling-file-in", 
      cl::desc("Specify input file path to read tiling result"), 
      cl::value_desc("File path")
  );

  cl::opt<std::string> SelectedLoopNames(
      "selected-loop-names", 
      cl::desc("Specify loop name")
  );

}


namespace {
class TileLoop :
#ifdef LOOP_PASS
                 public LoopPass,
#else
                 public FunctionPass,
#endif
                                      public AliasAnalysis {
 ScalarEvolution *seaa;

public:
  static char ID; // Class identification, replacement for typeinfo
  TileLoop() :
#ifdef LOOP_PASS
    LoopPass(ID),
#else
    FunctionPass(ID),
#endif//LOOP_PASS
    seaa(0)
  {
#ifndef MY_MOD
    initializeTileLoopPass(*PassRegistry::getPassRegistry());
#endif//MY_MOD
  }

  /// getAdjustedAnalysisPointer - This method is used when a pass implements
  /// an analysis interface through multiple inheritance.  If needed, it
  /// should override this to adjust the this pointer as needed for the
  /// specified pass info.
  virtual void *getAdjustedAnalysisPointer(AnalysisID PI) {
    if (PI == &AliasAnalysis::ID)
      return (AliasAnalysis*)this;

    return this;
  }

private:
  static map<std::string,Graph*> *graphMap;   
  static map<std::string,Tiling*> *tilingMap;   

  Instruction * UnrollScheduling(const TileSchedule& Scheduling,
      int UnrollFactor, int UnrollOffset, Instruction * StartInst);
  void rescheduleFromTiling(Tiling * CurrentTiling);
  void promoteNodeEdges(Node * Source, Tile * CurrentTile);
  void promoteFromTiling(Tiling * CurrentTiling);

  virtual void getAnalysisUsage(AnalysisUsage &AU) const;

#ifdef LOOP_PASS
  virtual bool runOnLoop(Loop *loop, LPPassManager &LPM);
#else
  virtual bool runOnFunction(Function &F);
#endif//LOOP_PASS
};
}  // End of anonymous namespace


// Register this pass...
#ifndef MY_MOD
char TileLoop::ID = 0;
INITIALIZE_AG_PASS_BEGIN(TileLoop, AliasAnalysis, "scev-tile-loop",
                   "ScalarEvolution-based Alias Analysis", false, true, false)
INITIALIZE_PASS_DEPENDENCY(ScalarEvolution)
INITIALIZE_PASS_DEPENDENCY(AliasAnalysis)
INITIALIZE_PASS_DEPENDENCY(MemoryDependenceAnalysis)
INITIALIZE_AG_PASS_END(TileLoop, AliasAnalysis, "scev-tile-loop",
                    "ScalarEvolution-based Alias Analysis", false, true, false)
                    
FunctionPass *llvm::createTileLoopPass() {
  return new TileLoop();
}
#endif//MY_MOD

void
TileLoop::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.addRequiredTransitive<ScalarEvolution>();
  //MemDepPrinter.cpp
  AU.addRequiredTransitive<AliasAnalysis>();
  AU.addRequiredTransitive<MemoryDependenceAnalysis>();
  AU.setPreservesAll();
  AliasAnalysis::getAnalysisUsage(AU);
}

map<std::string,Graph*> *TileLoop::graphMap = (map<std::string,Graph*>*)0;   
map<std::string,Tiling*> *TileLoop::tilingMap = (map<std::string,Tiling*>*)0;   


Instruction * TileLoop::UnrollScheduling(const TileSchedule& Scheduling,
    int UnrollFactor, int UnrollOffset, Instruction * StartInst) {
  Instruction * LastInst = StartInst;

  for (auto ScheduleIt = Scheduling.begin(); ScheduleIt != Scheduling.end();
      ++ScheduleIt) {
    for (int UnrollIt = 0; UnrollIt < UnrollFactor; ++UnrollIt) {
      for (auto NodeIt = (*ScheduleIt)->begin(); NodeIt != (*ScheduleIt)->end();
          ++NodeIt) {
        if ((*NodeIt)->dualMatch)
          continue;

        switch ((*NodeIt)->type) {
          case NodePhi:
          case NodeAlloc:
          case NodeBranch:
          case NodeCmp:
            // Do nothing
            break;
          default:
            if ((*NodeIt)->instr) { // Check if the instr is not removed in tiling
              Instruction * InstCopy = (*NodeIt)->instrAr[UnrollOffset + UnrollIt];

              if (InstCopy != LastInst) {
                InstCopy->removeFromParent();
                InstCopy->insertAfter(LastInst);
                LastInst = InstCopy;
              }
            }
            break;
        }
      }
    }
  }

  return LastInst;
}


void TileLoop::rescheduleFromTiling(Tiling * CurrentTiling) {
  std::set<Node *> RescheduledNodes;
  std::list<Node *> External;
  const std::unordered_set<Node *>& ExternalNodes = CurrentTiling->Target.getExternalNodes();
  const std::vector<Tile *>& Tiles = CurrentTiling->getTiles();
  int UnrollFactor = CurrentTiling->getUnrollFactor();
  Node * TargetNode;
  Instruction * LastInst = NULL;

  // Prepare a list with the external nodes
  for (auto I = ExternalNodes.begin(), E = ExternalNodes.end(); I != E; ++I)
    External.push_back(*I);

  // Go through the list of external nodes and reschedules those whose
  // incoming dependencies have already been rescheduled.
  for (auto I = External.begin(), E = External.end(); I != E; ++I) {
    if ((*I)->instrAr.size() <= 1)
      continue;

    if (!LastInst)
      LastInst = (*I)->instrAr[0]->getParent()->getFirstInsertionPt();

    assert(LastInst);

    if ((*I)->inEdgeAr.size() != 0) {
      auto I2 = (*I)->inEdgeAr.begin();
      auto E2 = (*I)->inEdgeAr.end();
      for (; I2 != E2; ++I2) {
        TargetNode = CurrentTiling->Target.getNodeById((*I2)->dstId);
        if ((TargetNode->order == Node::ORDER_EXTERNAL) && (RescheduledNodes.count(TargetNode) == 0)) {
          External.push_back(*I);
          I = External.erase(I);
          --I;
          break;
        }
      }

      if (I2 != E2)
        continue; // A dependency is not yet satisfied
    }

    // Reschedule the clones corresponding to this node
    for (auto I2 = (*I)->instrAr.begin(), E2 = (*I)->instrAr.end(); I2 != E2; ++I2) {
      (*I2)->removeFromParent();
      (*I2)->insertAfter(LastInst);
      LastInst = *I2;
    }

    // Mark the node as rescheduled
    RescheduledNodes.insert(*I);
  }

  // Reschedule all the nodes internal to the loop
  for (auto It = Tiles.begin(); It != Tiles.end(); ++It) {
    int Width = (*It)->getWidth();

    int TileUnrollFactor = CurrentTiling->getUnrollFactor() / Width;
    int UnrollTailFactor = CurrentTiling->getUnrollFactor() % Width;

    const TileSchedule& Scheduling = (*It)->getScheduling();

    if (!LastInst) {
      LastInst = (*It)->getFirstInstruction();
      LastInst = LastInst->getParent()->getFirstInsertionPt();
    }
    assert(LastInst);

    for (int TileIt = 0; TileIt < TileUnrollFactor; ++TileIt)
      LastInst = UnrollScheduling(Scheduling, Width, TileIt * Width, LastInst);

    UnrollScheduling(Scheduling, UnrollTailFactor, TileUnrollFactor * Width,
        LastInst);
  }
}


void TileLoop::promoteNodeEdges(Node * Source, Tile * CurrentTile) {
  int UnrollFactor;
  int * PromotedInstances;
  Value * PromotedValue;

  // Only promote edges when the source node is a store instruction
  if (!Source->instr ||
      (Source->instrAr[0]->getOpcode() != Instruction::Store))
    return;

  UnrollFactor = CurrentTile->Parent.getUnrollFactor();
  PromotedInstances = new int[UnrollFactor] {0};

  for (auto I = Source->outEdgeAr.begin(), E = Source->outEdgeAr.end(); I != E; ++I) {
    int TileWidth;
    Node * Target;

    if (CurrentTile->Parent.getPromotedEdges().count(*I) == 0)
      continue;

    TileWidth = CurrentTile->getWidth();
    Target = CurrentTile->Parent.Target.getNodeById((*I)->dstId);

    int PromotionInstancesNumber = CurrentTile->Parent.getUnrollFactor() - (*I)->dist;
    for (int I2 = 0; I2 < PromotionInstancesNumber; ++I2) {
      if (((I2 / TileWidth) == ((I2 + (*I)->dist) / TileWidth)) ||
        (CurrentTile->Parent.getCrossTilePromotedEdges().count(*I))) {
        // Get the value that is being stored replace the loaded values uses
        // with it and delete the load instruction
        PromotedValue = Source->instrAr[I2]->getOperand(0);
        Target->instrAr[I2 + (*I)->dist]->replaceAllUsesWith(PromotedValue);
        Target->instrAr[I2 + (*I)->dist]->eraseFromParent();

        // Register the promotion in the dedicated table
        PromotedInstances[I2]++;
      }
    }
  }

  // Verify for each instance of the store if all outgoing edges have been
  // promoted. If so delete the store instruction. Pay attention to stores
  // without a following dependency.
  int OutEdgeNumber = Source->outEdgeAr.size();
  if (OutEdgeNumber == 0)
    return;

  for (int I = 0; I < UnrollFactor; ++I) {
    if (PromotedInstances[I] == OutEdgeNumber)
      Source->instrAr[I]->eraseFromParent();
  }
}


void TileLoop::promoteFromTiling(Tiling * CurrentTiling) {
  const std::vector<Tile *>& Tiles = CurrentTiling->getTiles();

  for (auto I = Tiles.begin(), E = Tiles.end(); I != E; ++I) {
    const TileSchedule& Schedule = (*I)->getScheduling();

    for (auto I2 = Schedule.begin(), E2 = Schedule.end(); I2 != E2; ++I2) {
      for (auto I3 = (*I2)->begin(), E3 = (*I2)->end(); I3 != E3; ++I3) {
        promoteNodeEdges(*I3, *I);
      }
    }
  }
}


#ifdef LOOP_PASS
bool TileLoop::runOnLoop(Loop *loop, LPPassManager &LPM) {
  PassTools::incrLoopCnt();
  
  //loop->print(errs());
  //we are interested only in innermost loops

  //InitializeMemoryDependenceAnalysis(this);
  MemoryDependenceAnalysis * memdep = &getAnalysis<MemoryDependenceAnalysis>();
  //GlobalsModRef * aa = &getAnalysis<GlobalsModRef>();
  AliasAnalysis * aa = &getAnalysis<AliasAnalysis>();
  //errs() <<"AAType: "<< typeid(*aa).name() << "\n";
  InitializeAliasAnalysis(this);
  seaa = &getAnalysis<ScalarEvolution>();

  if (loop->getSubLoops().size() > 0)
    return false;

  //get loop name
  string loopName = PassTools::getLoopName(loop);
  assert(loopName.size()>0);
  PassTools::setLoopName(loop,loopName);

  //if some loop is selected  
  if(!PassTools::processLoop(SelectedLoopNames,loop)){
    return false;
  }
  
  if(!TileLoop::graphMap)
  {
    errs() << "=== Parsing tile graph from file: " << TileGraphFileIn << "\n";  
    TileLoop::graphMap = &Graph::parseGraph(string(TileGraphFileIn.c_str()));
  }
  
  if(!TileLoop::tilingMap)
  {
    errs() << "=== Parsing tiling from file: " << TilingFileIn << "\n";  
    TileLoop::tilingMap = &Tiling::parseTiling(string(TilingFileIn.c_str()), (*TileLoop::graphMap));
  }
      
  errs() << "\n";
  errs() << "loopName: " << loopName << "\n";
  errs() << "loopData: "<< PassTools::getLoopData(loop) << "\n";

  Graph *graph = (*TileLoop::graphMap)[loopName];
  if(graph==0){
      errs() << "WARNING: no graph defined for loop "<< "\n";
      return false;
  } 
  assert(graph!=0);

  Tiling *tiling = (*TileLoop::tilingMap)[loopName];
  if(tiling==0){
      errs() << "WARNING: no tiling defined for loop "<< "\n";
      return false;
  } 

  errs() << "=== Loop\n";
  loop->print(errs());
  for (Loop::block_iterator blockIt = loop->block_begin(); blockIt != loop->block_end(); ++blockIt) {
    BasicBlock *block = *blockIt;
    errs() << "=== Block";
    block->print(errs());    
  }

  //check if indvar.next exists after phi if not add it after phi 
  //connect all consumers of phi to this indvar next
  //the consumers of phi should be only in the first iteration

  const SCEVAddRecExpr* indVarScev = 0;
  Instruction *indVarInstr = 0;
  int indVarIncr=-1;
  int indVarDivUnroll = -1; 
  PassTools::findInductionVariable(loop,seaa,indVarScev,indVarInstr,indVarIncr);


  std::vector<Instruction*> loopInstrAr;
  std::map<Value*,int> instrOrderMap;
  std::unordered_set<Instruction*> extDefSet;
  PassTools::fillInInstructionCollections(loop,PassTools::WHOLE_LOOP,loopInstrAr,instrOrderMap,extDefSet);

  bool matched = graph->assignInstr(tiling->getUnrollFactor(),indVarInstr,loopInstrAr,instrOrderMap,extDefSet);
  if(!matched){
      errs() << "Match loop failed, loopName: "<<loopName << "\n";
      return false;  
  }
  else{
      errs() << "Match loop successfull, loopName: "<<loopName << "\n";
  }

  rescheduleFromTiling(tiling);
  promoteFromTiling(tiling);

  return false;
}

#else

bool TileLoop::runOnFunction(Function &F) {
  errs() << "Hello: ";
  errs().write_escaped(F.getName()) << '\n';
  InitializeAliasAnalysis(this);
  SE = &getAnalysis<ScalarEvolution>();

  return false;
}
#endif//LOOP_PASS


#ifdef MY_MOD
char TileLoop::ID = 0;
static RegisterPass<TileLoop> X("scev-tile-loop",
    "Scalar evolution must dependence pass", false, false);
#endif//MY_MOD
