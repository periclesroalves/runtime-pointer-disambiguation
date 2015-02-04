//===- TileGraph.cpp - SCEV-based Alias
//Analysis -------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the TileGraph pass, which implements a
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
#include <fstream>
#include <string>
#include <unordered_set>
#include <list>

#include "llvm/Analysis/Passes.h"
#include "llvm/Analysis/AliasAnalysis.h"
//#include "llvm/Analysis/GlobalsModRef.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/Pass.h"
//#include "llvm/User.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/Analysis/MemoryDependenceAnalysis.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/CommandLine.h"

#include "PassTools.h"
#include "Graph.h"
#include "Node.h"
#include "Edge.h"
#include "ParseTools.h"
#include "ScheduleHeuristic.h"
#include "TileHeuristic.h"

#define MY_MOD
#define LOOP_PASS

using namespace llvm;


namespace llvm {
  void initializeTileGraphPass(PassRegistry&);
  FunctionPass *createTileGraphPass();

  cl::opt<std::string> TileGraphFileOut(
      "tile-graph-file-out", 
      cl::desc("Specify output file path to dump tiling graphs"), 
      cl::value_desc("File path")
  );
  
  cl::opt<std::string> SelectedLoopNames(
      "selected-loop-names", 
      cl::desc("Specify loop name")
  );

  cl::opt<std::string> UnrollFactor(
      "unroll-factor", 
      cl::desc("Specify unroll factor for analised loop")
  );  
}


namespace {
/// TileGraph - This is a simple alias analysis implementation that uses
/// ScalarEvolution to answer queries.

enum ScevEdgeType {
  ScevEdgeConst=0,
  ScevEdgeRange=1
};


class ScevEdge {
public:
  ScevEdge(int srcIdx, int dstIdx,int dist, ScevEdgeType type, int distMax=0) :
      srcIdx(srcIdx),
      dstIdx(dstIdx),
      dist(dist),
      type(type),
      distMax(distMax)
    {};

  int srcIdx;
  int dstIdx;
  int dist;
  ScevEdgeType type;
  int getDistMax() {
      assert(type==ScevEdgeRange);
      return(distMax);
  }

private: 
  int distMax; //max of the range for ScevEdgeRange   	
};


enum DepType {
  Flow = 0,
  Anti = 1,
  Output = 2,
  Input = 3
};


class MemDepEdge {
public:
  MemDepEdge(int srcIdx, int dstIdx,int dist, DepType depType) :
      srcIdx(srcIdx),
      dstIdx(dstIdx),
      dist(dist),
      depType(depType)
    {};

  int srcIdx;
  int dstIdx;
  int dist;
  DepType depType;
  std::string toString() {
    std::string retValue("");
    retValue += "MemDepEdge{ srcIdx: " + itostr(srcIdx) + ", dstIdx: ";
    retValue += itostr(dstIdx) + ", dist: " + itostr(dist) + ", depType: ";
    switch (depType) {
      case Flow:
        retValue += "Flow }";
        break;
      case Anti:
        retValue += "Anti }";
        break;
      case Output:
        retValue += "Output }";
        break;
      case Input:
        retValue += "Input }";
        break;
      default:
        retValue += "Err }";
    }
    return retValue;
  }

};

class NodeCollection {
private:
  std::vector<Node*> nodeAr;
  std::map<Value*,Node*> valNodeMap;
  std::map<std::string,Node*> idNodeMap;

public:
  Node* add(Value* instr, int order) {
    return add(instr,"N",nodeAr.size(),order);
  }

  Node* add(Value* instr, std::string idPrefix, int idSuffix, int order) {
    //print to string
    std::string dbgStr;
    raw_string_ostream sstream(dbgStr);
    sstream << *instr;
    //build id
		std::string id = idPrefix + itostr(idSuffix);
    assert(idNodeMap.count(id) == 0);
    //build the node
    Node* node = new Node(nodeAr.size(), id, order, Node::getNodeType(instr),PassTools::getVarId(instr,false),PassTools::getInstrId(instr),dbgStr);        
    node->setInstr(instr);    
    return add(node);
  }
  
  Node* add(Node* node)
  {
    assert(node->instr!=0);
    nodeAr.push_back(node);
    valNodeMap[node->instr] = node;
    idNodeMap[node->id] = node;    
    return node;
  }

  Node* get(int idx) {
    if (idx < nodeAr.size())
      return nodeAr[idx];
    else
      return 0;
  }

  Node* get(Value* instr) {
    if (valNodeMap.count(instr))
      return valNodeMap[instr];
    else
      return 0;
  }

  Node* get(std::string id) {
    if (idNodeMap.count(id))
      return idNodeMap[id];
    else
      return 0;
  }


  typename std::vector<Node*>::iterator begin() {
    return nodeAr.begin();
  }

  typename std::vector<Node*>::iterator end() {
    return nodeAr.end();
  }

  int size() {
    return nodeAr.size();
  }
};


struct EdgeCmp {
  std::string z(std::string nodeId) {
    int val = atoi(nodeId.substr(1).c_str());
    if (val < 10)
      return std::string("00") + itostr(val);

    if (val < 100)
      return std::string("0") + itostr(val);

    return std::string("") + itostr(val);    
    }

  bool operator()(const Edge * e1, const Edge * e2) {            
    return (z(e1->srcId) + " " + z(e1->dstId)) <
      (z(e2->srcId) + " " + z(e2->dstId));
    }
};


class EdgeCollection {
private:
  std::vector<Edge*> edgeAr;
  std::map<std::string,Edge*> idEdgeMap;
	
  Edge* add(std::string idPrefix, int idSuffix, Node* srcNode, Node* dstNode,
      int weight, int dist, EdgeType edgeType, std::string varId) {
    //build id
		std::string id = idPrefix+itostr(idSuffix);
    assert(idEdgeMap.count(id)==0);
    //build the node
    Edge* edge = new Edge(id, srcNode, dstNode, weight, dist, edgeType, varId);
		edgeAr.push_back(edge);
    idEdgeMap[id] = edge;

    return edge;
}

public:
  Edge* add(Node* srcNode, Node* dstNode, int weight, int dist,
      EdgeType edgeType, std::string varId) {
    return add("E", edgeAr.size(), srcNode, dstNode, weight, dist, edgeType,
        varId);
  }

  void sort() {
    std::sort(edgeAr.begin(), edgeAr.end(), EdgeCmp()); 
  }

  std::vector<Edge*>::iterator begin() { return edgeAr.begin(); }
  std::vector<Edge*>::iterator end() { return edgeAr.end(); }
};


template <typename T>
class NestedMap {
private:
  bool ordered;
  bool noOverwrite;

public:
  NestedMap(bool ordered = true, bool noOverwrite = true) :
    ordered(ordered),
    noOverwrite(noOverwrite)
  {};
  
  std::map<int,std::map<int,T> > map;
  std::vector<T> vec;
  void add(int key1Raw, int key2Raw, T value) {  
    int key1 = (ordered || key1Raw<key2Raw) ? key1Raw : key2Raw;
    int key2 = (ordered || key1Raw<key2Raw) ? key2Raw : key1Raw;

    if (noOverwrite && contains(key1Raw, key2Raw))
      assert(false);
  
    map[key1][key2] = value;

    vec.push_back(value);
  }

  bool contains(int key1Raw, int key2Raw) {
    int key1 = (ordered || key1Raw<key2Raw) ? key1Raw : key2Raw;
    int key2 = (ordered || key1Raw<key2Raw) ? key2Raw : key1Raw;

    if (!map.count(key1))
      return false;
    if (map[key1].count(key2))
      return true;
    else
      return false;
  }

  T get(int key1Raw, int key2Raw) {
    if (!contains(key1Raw, key2Raw))
      return (T)0;

    int key1 = (ordered || key1Raw<key2Raw) ? key1Raw : key2Raw;
    int key2 = (ordered || key1Raw<key2Raw) ? key2Raw : key1Raw;
    return map[key1][key2];
  }

  typename std::vector<T>::iterator begin() {
    return vec.begin();
  }

  typename std::vector<T>::iterator end() {
    return vec.end();
  }
};


class TileGraph :
#ifdef LOOP_PASS
                  public LoopPass,
#else
                  public FunctionPass,
#endif//LOOP_PASS
                  public AliasAnalysis {
  ScalarEvolution *seaa;

public:
  static char ID; // Class identification, replacement for typeinfo
  TileGraph() :
#ifdef LOOP_PASS
    LoopPass(ID),
#else
    FunctionPass(ID),
#endif//LOOP_PASS
    seaa(0)
  {
#ifndef MY_MOD
    initializeTileGraphPass(*PassRegistry::getPassRegistry());
#endif//MY_MOD
  }

  /// getAdjustedAnalysisPointer - This method is used when a pass implements
  /// an analysis interface through multiple inheritance.  If needed, it
  /// should override this to adjust the this pointer as needed for the
  /// specified pass info.
  virtual void *getAdjustedAnalysisPointer(AnalysisID PI) {
    if (PI == &AliasAnalysis::ID)
      return (AliasAnalysis*) this;
    
    return this;
  }

private: 
  virtual bool isLoopIndependent(const SCEV *scev , const Loop *loop);
  virtual void writeProbdef(raw_ostream &ostr, EdgeCollection &edgeCol,
      NodeCollection &nodeCol, std::string loopName);

  virtual std::vector<MemDepEdge*> getMemDepsFromAA(AliasAnalysis * aa);
  bool isValidReuse(MemDepEdge* memDep, NestedMap<ScevEdge*> &scevDiffNom,
      std::vector<Instruction*> &loopInstrAr, AliasAnalysis* aa);

  virtual void getAnalysisUsage(AnalysisUsage &AU) const;
#ifdef LOOP_PASS
  virtual bool runOnLoop(Loop *loop, LPPassManager &LPM);
#else
  virtual bool runOnFunction(Function &F);
#endif//LOOP_PASS
};
}  // End of anonymous namespace


// Create a graph from a node and an edge collection.
// The graph is independant as far as deep-copies are made of nodes and edges.
static Graph * graphFromCollections(NodeCollection& nodeCol, EdgeCollection& edgeCol) {
  Graph * graph = new Graph();
  
  for (auto it = nodeCol.begin(); it != nodeCol.end(); ++it) {
    Node * copyNode = new Node((*it)->idx, (*it)->id, (*it)->order, (*it)->type, (*it)->varId, (*it)->instrId);
    graph->addNode(copyNode);
  }

  for (auto it = edgeCol.begin(); it != edgeCol.end(); ++it) {
    Node * source = graph->getNodeById((*it)->srcId);
    Node * destination = graph->getNodeById((*it)->dstId);
    Edge * copyEdge = new Edge((*it)->id, source, destination, (*it)->weight, (*it)->dist, (*it)->edgeType, (*it)->varId);
    source->addEdge(copyEdge);
    destination->addEdge(copyEdge);
    graph->addEdge(copyEdge);
  }

  return graph;
}


// Register this pass...
#ifndef MY_MOD
char TileGraph::ID = 0;
INITIALIZE_AG_PASS_BEGIN(TileGraph, AliasAnalysis, "scev-tile-graph",
                   "ScalarEvolution-based Alias Analysis", false, true, false)
INITIALIZE_PASS_DEPENDENCY(ScalarEvolution)
INITIALIZE_PASS_DEPENDENCY(AliasAnalysis)
INITIALIZE_PASS_DEPENDENCY(MemoryDependenceAnalysis)
INITIALIZE_AG_PASS_END(TileGraph, AliasAnalysis, "scev-tile-graph",
                    "ScalarEvolution-based Alias Analysis", false, true, false)

FunctionPass *createTileGraphPass() {
  return new TileGraph();
}
#endif//MY_MOD

void TileGraph::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.addRequiredTransitive<ScalarEvolution>();
  //MemDepPrinter.cpp
  AU.addRequiredTransitive<AliasAnalysis>();
  AU.addRequiredTransitive<MemoryDependenceAnalysis>();
  AU.setPreservesAll();
  AliasAnalysis::getAnalysisUsage(AU);
}

std::vector<MemDepEdge*> TileGraph::getMemDepsFromAA(AliasAnalysis * aa) {
  std::vector<MemDepEdge*> memDepAr;
  return memDepAr;
}

void TileGraph::writeProbdef(raw_ostream &ostr, EdgeCollection &edgeCol,
    NodeCollection &nodeCol, std::string loopName) {
  bool first;

  ostr << "-" << "\n";
  ostr << "  loopName: " << loopName << "\n";
  first = true;  
  ostr << "  nodeAr: " << "\n";
  
  for (std::vector<Node*>::iterator nodeIt = nodeCol.begin();
      nodeIt != nodeCol.end(); ++nodeIt) {
    Node *node = *nodeIt;
    ostr << "    -" << "\n";
    ostr << "      idx: " << node->idx << "\n";
    ostr << "      id: " << node->id << "\n";
    ostr << "      order: " << node->order << "\n";
    ostr << "      type: " << node->type << "\n";
    ostr << "      varId: \"" << node->varId << "\"\n";
    ostr << "      instrId: \"" << node->instrId << "\"\n";
    ostr << "      dbg: \"" << node->dbg << "\"\n";
  }
  ostr << "\n" ;

  first = true;
  ostr << "  edgeAr: " << "\n";
  for (std::vector<Edge*>::iterator edgeIt = edgeCol.begin();
      edgeIt != edgeCol.end(); ++edgeIt)
  {
    Edge *edge = *edgeIt;
    ostr << "    -" << "\n";
    ostr << "      id: " << edge->id << "\n";
    ostr << "      srcId: " << edge->srcId << "\n";
    ostr << "      dstId: " << edge->dstId << "\n";
    ostr << "      latency: " << edge->latency << " \n";
    ostr << "      dist: " << edge->dist << " \n";
    ostr << "      weight: " << edge->weight << " \n";
    ostr << "      varId: " << "\"" << edge->varId << "\"" << " \n";
    ostr << "      edgeType: " << edge->edgeType << " \n";
  }
  ostr << "\n" ;
}

#ifdef LOOP_PASS
bool TileGraph::runOnLoop(Loop *loop, LPPassManager &LPM) {
  PassTools::incrLoopCnt();

  //we are interested only in innermost loops
  if (loop->getSubLoops().size() > 0)
    return false;    

  //get/set loop name
  string loopName = PassTools::getLoopName(loop);
  if(loopName.size()==0){  
      loopName = PassTools::getCurrentLoopName();
  }
  PassTools::setLoopName(loop,loopName);  

  //if some loop is selected skip others  
  if(!PassTools::processLoop(SelectedLoopNames,loop)){
    return false;
  }

  //InitializeMemoryDependenceAnalysis(this);
  MemoryDependenceAnalysis * memdep = &getAnalysis<MemoryDependenceAnalysis>();
  //GlobalsModRef * aa = &getAnalysis<GlobalsModRef>();
  AliasAnalysis * aa = &getAnalysis<AliasAnalysis>();
  //errs() << "AAType: "<< typeid(*aa).name() << "\n";

  InitializeAliasAnalysis(this);
  seaa = &getAnalysis<ScalarEvolution>();

  std::map<Instruction*,const SCEV*> instrScevMap;
 
  
  errs() << "\n";
  errs() << "loopName: " << loopName << "\n";
  errs() << "loopData: "<< PassTools::getLoopData(loop) << "\n";

  int unrollFactor =  UnrollFactor.size()>0?atoi(UnrollFactor.c_str()):1;
  int guessedUnrollFactor = PassTools::guessUnrollFactor(loop);
  if(guessedUnrollFactor != unrollFactor){
    errs() << "guessedUnrollFactor is "<<guessedUnrollFactor<<" not "<< unrollFactor << " as expected, exiting ..." <<"\n";
    return false;
  }
 
  const SCEVAddRecExpr* indVarScev = 0;
  Instruction *indVarInstr = 0;
  int indVarIncr=-1;
  int indVarDivUnroll = -1; 
  PassTools::findInductionVariable(loop,seaa,indVarScev,indVarInstr,indVarIncr);
  
  if(indVarIncr<0){
    errs() << "Unknown induction variable increment, exiting ..." <<"\n";
    return false; 
  }
  else{
    errs()<<"indVarIncr: "<<indVarIncr<<"\n" ;
  }  
  errs()<<"unrollFactor: "<<unrollFactor<<"\n" ;  

  if(indVarIncr%unrollFactor!=0){
      errs() << "Induction variable increment is not a multiple of unroll factor, exiting ... "<<"\n";
      return false;
  }  
  indVarDivUnroll=indVarIncr/unrollFactor;
  
  if(indVarDivUnroll!=1){
    errs()<<"Only cannonical loops allowed, indVarDivUnroll is "<<indVarDivUnroll<<", exiting ...\n" ;
    return false;
  }  
        
  std::vector<Instruction*> loopInstrAr;
  std::map<Value*,int> instrOrderMap;
  std::unordered_set<Instruction*> extDefSet;
  int iter = 2; //PassTools::WHOLE_LOOP;  
  PassTools::fillInInstructionCollections(loop,iter,loopInstrAr,instrOrderMap,extDefSet);
  errs() << "Instructions in loop: "<<loopInstrAr.size()<<"\n"; 
  errs() << "External instructions: "<< extDefSet.size()<< "\n";  
  
  // Guarantee that the loop body contains no conditional code as this could
  // lead to potential issues when rescheduling.
  for (Loop::block_iterator blockIt = loop->block_begin();
     blockIt != loop->block_end(); ++blockIt) {
    BranchInst * bInst;
    SwitchInst * sInst;
    TerminatorInst * blockEnd = (*blockIt)->getTerminator();

    if ((bInst = dyn_cast<BranchInst>(blockEnd))) {
      if (bInst->isConditional()) {
        Value * condition = bInst->getCondition();
        Instruction * cInst = dyn_cast<Instruction>(condition);
        assert(cInst);

        // When a conditional branch is found check that the condition depends
        // on the induction variable
        if (CmpInst::classof(cInst)) {
          if ((!cInst->getOperand(1)->getName().str().find("indvar")) &&
            (!cInst->getOperand(1)->getName().str().find("indvar")))
            return false;
        }
      }
    } else if ((sInst = dyn_cast<SwitchInst>(blockEnd))) {
      // A loop containing a switch can not be tiled
      return false;
    }
  }
  /*
  // Guarantee that each load or store operations is associated with a unique
  // getelementptr computation. Clone when necessary.
  for (Loop::block_iterator blockIt = loop->block_begin();
     blockIt != loop->block_end(); ++blockIt) {
    for (auto instIt = (*blockIt)->begin(); instIt != (*blockIt)->end(); ++instIt) {
      if (GetElementPtrInst::classof(instIt)) {
        while (!instIt->hasOneUse()) {
          auto use = instIt->use_begin();
          Instruction * newGEP = instIt->clone();

          use->set(newGEP);
          newGEP->insertAfter(instIt);
        }
      }
    }
  }
  */
  
  // find all memory accesses in the loop body    
  errs() << "=== Loop\n";
  loop->print(errs());
  for (Loop::block_iterator blockIt = loop->block_begin();
      blockIt != loop->block_end(); ++blockIt) {
    BasicBlock *block = *blockIt;
    errs() << "=== Block";        
    errs() << *block;
  }

  errs() << "\n";
  errs() << "=== Instructions \n";
  // find all memory accesses in the loop body
  for (std::vector<Instruction*>::iterator instrIt = loopInstrAr.begin();
      instrIt != loopInstrAr.end(); ++instrIt) {
    Instruction *instr = *instrIt;

    errs() << "Instr: valId: " << instrOrderMap.at(instr) << " ,name: \"";
    errs() << instr->getName() << "\"";
    //errs() << " ,typeid: \"" <<typeid(*instr).name()<<"\"";
    errs() << " ,print: " << *instr << "\n";

    //http://llvm.org/docs/doxygen/html/MemDepPrinter_8cpp_source.html
    if (Instruction * depInst = memdep->getDependency(instr).getInst()) {
      MemDepResult memDepRes = memdep->getDependency(instr);
      errs() << " MemDep: valId: " << (instrOrderMap.count(depInst)?itostr(instrOrderMap.at(depInst)):"??") << " ,print: ";
      errs() << *depInst << ", isClobber:" << memDepRes.isClobber();
      errs() << ", isDef:" << memDepRes.isDef() << ", isNonLocal:";
      errs() << memDepRes.isNonLocal() << ", isNonFuncLocal:";
      errs() << memDepRes.isNonFuncLocal() << ", isUnknown:";
      errs() << memDepRes.isUnknown() << "\n";
    }

    for (int i = 0 ; i < loopInstrAr.size(); i++) {
      if (const GetElementPtrInst * tmp =
            dyn_cast<GetElementPtrInst>(loopInstrAr[i])) {
        Instruction * instrAlias = loopInstrAr[i];
        AliasResult ar = aa->alias(instrAlias,instr);

        if (!(NoAlias == ar)) {
          errs() << " Alias: valId:" << i << ", print:" << *instrAlias;
          errs() << ", type: " << ar << "\n";
        }
      }
    }

    for (User::op_iterator opIt = instr->op_begin(); opIt != instr->op_end();
        ++opIt) {
      Use *use = opIt;
      Value *useValue = (use->operator Value *());
      /*
      errs() << " Use: ";
      errs() << *useValue;
      //errs() << (use->operator Value *())->getValueID();
      errs() << "\n";
      */
    }

    //Machine.getLocalSlot(instr);
    //instr->get
    const SCEV *scev = seaa->getSCEV(instr);//const_cast<Value *>(LocA.Ptr));
    errs() << " SCEV: ";
    scev->print(errs());
    errs() << "\n";
    
    // remember the scev
    Type &type = *scev->getType();
    bool scevable = seaa->isSCEVable(instr->getType());
    if (seaa->isSCEVable(instr->getType()))
      instrScevMap[instr] = scev;
  }

  errs() << "=== SCEV diff: " << "\n";
  if (false) {
    for (auto it1 = instrScevMap.begin(); it1 != instrScevMap.end(); ++it1) {
      auto it2 = it1;
      it2++;
      for (it2 = instrScevMap.begin(); it2 != instrScevMap.end(); ++it2) {
        //SCEV *scev1 = it1->second;

        if (it1->second != it2->second) {
          const  SCEV *scevDiff = seaa->getMinusSCEV(it1->second, it2->second);
          Instruction* instr1 = it1->first;
          Instruction* instr2 = it2->first;
          const SCEV* scev1 = it1->second;
          const SCEV* scev2 = it2->second;

          errs() << "\n";
          errs() << "Instr: valId: " << instrOrderMap.at(instr1);
          errs() << " ,print: " << *instr1 << "\n";
          errs() << "SCEV1: ";
          scev1->print(errs());
          errs() << "\n";
          errs() << "Instr: valId: " << instrOrderMap.at(instr2);
          errs() << " ,print: " << *instr2 << "\n";
          errs() << "SCEV2: ";
          scev2->print(errs());
          errs() << "\n";
          errs() << "diff: valIdPair: " << instrOrderMap.at(instr1) <<"-";
          errs() << instrOrderMap.at(instr2) << " ,scev: " << *scevDiff;
          errs() << "\n";

          errs() << "diffStats: ";

          errs() << ", SCEVConstant: ";
          errs() << (dyn_cast<SCEVConstant>(scevDiff) ? 1 : 0);
          errs() << ", SCEVCastExpr: ";
          errs() << (dyn_cast<SCEVCastExpr>(scevDiff) ? 1 : 0);
          errs() << ", SCEVTruncateExpr: ";
          errs() << (dyn_cast<SCEVTruncateExpr>(scevDiff) ? 1 : 0);
          errs() << ", SCEVZeroExtendExpr: ";
          errs() << (dyn_cast<SCEVZeroExtendExpr>(scevDiff) ? 1 : 0);
          errs() << ", SCEVSignExtendExpr: ";
          errs() << (dyn_cast<SCEVSignExtendExpr>(scevDiff) ? 1 : 0);
          errs() << ", SCEVNAryExpr: ";
          errs() << (dyn_cast<SCEVNAryExpr>(scevDiff) ? 1 : 0);
          errs() << ", SCEVCommutativeExpr: ";
          errs() << (dyn_cast<SCEVCommutativeExpr>(scevDiff) ? 1 : 0);
          errs() << ", SCEVAddExpr: ";
          errs() << (dyn_cast<SCEVAddExpr>(scevDiff) ? 1 : 0);
          errs() << ", SCEVMulExpr: ";
          errs() << (dyn_cast<SCEVMulExpr>(scevDiff) ? 1 : 0);
          errs() << ", SCEVUDivExpr: ";
          errs() << (dyn_cast<SCEVUDivExpr>(scevDiff) ? 1 : 0);
          errs() << ", SCEVAddRecExpr: ";
          errs() << (dyn_cast<SCEVAddRecExpr>(scevDiff) ? 1 : 0); //!!
          errs() << ", SCEVSMaxExpr: ";
          errs() << (dyn_cast<SCEVSMaxExpr>(scevDiff) ? 1 : 0);
          errs() << ", SCEVUMaxExpr: ";
          errs() << (dyn_cast<SCEVUMaxExpr>(scevDiff) ? 1 : 0);
          errs() << ", SCEVUnknown: ";
          errs() << (dyn_cast<SCEVUnknown>(scevDiff) ? 1 : 0);
          errs() << ", SCEVCouldNotCompute: ";
          errs() << (dyn_cast<SCEVCouldNotCompute>(scevDiff) ? 1 : 0);
          errs() << "\n";

          if (const SCEVAddRecExpr *sare = dyn_cast<SCEVAddRecExpr>(scevDiff)) {
            errs() << ", getStepRecurrence: ";
            errs() << *sare->getStepRecurrence(*seaa);
            errs() << ", evaluateAtIteration: ";
            errs() << *sare->evaluateAtIteration(scevDiff, *seaa);
            errs() << ", getLoop: ";
            errs() << (sare->getLoop() ==
                loop ? "[thisLoop], " : "[otherLoop], ");
            errs() << ", getNumOperands: " << sare->getNumOperands();

            errs() << ", Operands: ";
            //for(SCEVAddRecExpr::op_iterator opIt = sare->op_begin(); opIt != sare->op_end(); ++opIt)
            for (int i = 0; i < sare->getNumOperands(); i++) {
              const SCEV *scevOperand  = sare->getOperand(i);
              errs() << *scevOperand << ", ";

              //if the operrand is a recursive expression
              if (const SCEVAddRecExpr *sareOperand =
                  dyn_cast<SCEVAddRecExpr>(scevOperand)) {
                //get the loop
                if (sareOperand->getLoop() == loop)
                  errs() << "[thisLoop], ";
                else
                  errs() << "[otherLoop], ";
              }
            }

            errs() << "\n";
          }
        }
      }
    }
  }

  /*
  {
    int id1=10;
    int id2=6;
    errs() << "=== Custom alias \n";    
    errs() << "Instr: valId: "<< instrOrderMap.at(loopInstrAr[id1]) <<" ,print: "<< *loopInstrAr[id1] << "\n";
    errs() << "Instr: valId: "<< instrOrderMap.at(loopInstrAr[id2]) <<" ,print: "<< *loopInstrAr[id2] << "\n";
    AliasResult ar = aa->alias(loopInstrAr[id1],loopInstrAr[id2]);    
    errs() <<"AliasResult: " <<ar<< "\n";
  }
  */

  errs() << "=== Load Store dep : " << "\n";

  std::vector<ScevEdge*> scevEdgeAr;
  NestedMap<ScevEdge*> scevDiffNom;

  std::vector<MemDepEdge*> memDepAr;

  //for each pair of instructions
  for (auto instrIt1 = loopInstrAr.begin(); instrIt1 != loopInstrAr.end();
      ++instrIt1) {
    Instruction *instr1 = *instrIt1;

    for (auto instrIt2 = loopInstrAr.begin(); instrIt2 != loopInstrAr.end();
        ++instrIt2) {
      Instruction *instr2 = *instrIt2;

      //if we have a load store pair
      if ((dyn_cast<StoreInst>(instr1) ? 1 : 0) ||
          (dyn_cast<LoadInst>(instr1) ? 1 : 0)) {
        //instr1
        Value * instr1PtrInstr;
        unsigned instr1OpTypeSize;
        bool instr1IsStore;
        int instr1Idx = instrOrderMap.at(instr1);

        if (const LoadInst * loadInst = dyn_cast<LoadInst>(instr1)) {
          instr1PtrInstr = const_cast<Value*>(loadInst->getPointerOperand());
          instr1OpTypeSize = PassTools::getLoadStoreByteSize(loadInst);
          instr1IsStore = false;
        } else if (const StoreInst * storeInst = dyn_cast<StoreInst>(instr1)) {
          instr1PtrInstr = const_cast<Value*>(storeInst->getPointerOperand());
          instr1OpTypeSize = PassTools::getLoadStoreByteSize(storeInst);
          instr1IsStore = true;
        }


        if ((dyn_cast<StoreInst>(instr2) ? 1 : 0) ||
            (dyn_cast<LoadInst>(instr2) ? 1 : 0)) {
          //instr2
          Value * instr2PtrInstr;
          unsigned instr2OpTypeSize;
          bool instr2IsStore;
          int instr2Idx = instrOrderMap.at(instr2);

          if (const LoadInst * loadInst = dyn_cast<LoadInst>(instr2)) {
            instr2PtrInstr = const_cast<Value*>(loadInst->getPointerOperand());
            instr2OpTypeSize = PassTools::getLoadStoreByteSize(loadInst);
            instr2IsStore = false;
          } else if (const StoreInst * storeInst =
              dyn_cast<StoreInst>(instr2)) {
            instr2PtrInstr =
              const_cast<Value*>(storeInst->getPointerOperand());
            instr2OpTypeSize = PassTools::getLoadStoreByteSize(storeInst);
            instr2IsStore = true;
          }

          //TODO: also reuse acress iterations
          //report the pair
          errs() << "\n";
          errs() << "Pair " << instrOrderMap.at(instr1) << "-";
          errs() << instrOrderMap.at(instr2) << "\n";

          //restrict to ordered pairs
          if (instr1Idx < instr2Idx) {
            //compute alias
            AliasResult ar = aa->alias(instr1PtrInstr, instr2PtrInstr);
            if (!(NoAlias == ar)) {
              MemDepEdge * memDepEdge;
              if ((instr1IsStore && !instr2IsStore) ||
                  (instr2IsStore && !instr1IsStore)) {
                //case: store <-> load
                int storeIdx = instr1IsStore ? instr1Idx : instr2Idx;
                int loadIdx = instr1IsStore ? instr2Idx : instr1Idx;

                //flow edge
                memDepEdge = new MemDepEdge(storeIdx, loadIdx,
                    storeIdx<loadIdx ? 0 : 1, Flow);
                memDepAr.push_back(memDepEdge);
                errs() << memDepEdge->toString() << "\n";

                //anti edge
                memDepEdge = new MemDepEdge(loadIdx, storeIdx,
                    loadIdx<storeIdx ? 0 : 1, Anti);
                memDepAr.push_back(memDepEdge);
                errs() << memDepEdge->toString() << "\n";
              } else if (instr1IsStore && instr2IsStore) {
                //case: store - store
                assert(instr1Idx < instr2Idx);
                memDepEdge = new MemDepEdge(instr1Idx, instr2Idx, 0, Output);
                memDepAr.push_back(memDepEdge);
                errs() << memDepEdge->toString() << "\n";

                memDepEdge = new MemDepEdge(instr2Idx, instr1Idx, 0, Output);
                memDepAr.push_back(memDepEdge);
                errs() << memDepEdge->toString() << "\n";
              } else if (!instr1IsStore && !instr2IsStore) {
                //case: load - load
                //reuse
                assert(instr1Idx < instr2Idx);
                memDepEdge = new MemDepEdge(instr1Idx, instr2Idx, 0, Input);
                memDepAr.push_back(memDepEdge);
                errs() << memDepEdge->toString() << "\n";

                //test both directions
                memDepEdge = new MemDepEdge(instr2Idx, instr1Idx, 0, Input);
                memDepAr.push_back(memDepEdge);
                errs() << memDepEdge->toString() << "\n";
              } else {
                assert(false);
              }

              //memDepAr.push_back(new MemDepEdge(instr1Idx,));
            }
          }

          //no ordering
          {
            //compute scev distance
            const SCEV * instr1PtrScev  = seaa->getSCEV(instr1PtrInstr);
            const SCEV * instr2PtrScev  = seaa->getSCEV(instr2PtrInstr);


            errs() << "Instr: valId: "<< instrOrderMap.at(instr1);
            errs() << " ,print: " << *instr1 << "\n";
            errs() << "Instr: valId: "<< instrOrderMap.at(instr2);
            errs() << " ,print: " << *instr2 << "\n";

            bool bothGetElemPtr = (dyn_cast<GetElementPtrInst>(instr1PtrInstr) ? 1 : 0) && (dyn_cast<GetElementPtrInst>(instr2PtrInstr) ? 1 : 0);
            if(!bothGetElemPtr){
                errs() << "WARNING: not both pointers are GetElementPtrInst" << "\n";
            }    
            //assert((dyn_cast<GetElementPtrInst>(instr1PtrInstr) ? 1 : 0) && (dyn_cast<GetElementPtrInst>(instr2PtrInastr) ? 1 : 0));
            //assert(loadAllign == storeAllign);
            int opTypeSize = instr2OpTypeSize;
            const  SCEV *loadStoreScevDiff =
              seaa->getMinusSCEV(instr1PtrScev, instr2PtrScev);

            errs() << "storeAddrScev: " << *instr1PtrScev << "\n";
            errs() << "loadAddrScev: " << *instr2PtrScev << "\n";

            /*
            //check for aliasing
            for (int i = 0 ;i< loopInstrAr.size(); i++) {
              if (const GetElementPtrInst * tmp =
                  dyn_cast<GetElementPtrInst>(loopInstrAr[i])) {
                Instruction * instrAlias = loopInstrAr[i];
                AliasResult ar = aa->alias(instrAlias, instr2PtrInstr);

                if (!(NoAlias == ar)) {
                  errs() << "Alias: valId:" << i << ", print:";
                  errs() << *instrAlias << ", type: " << ar << "\n";
                }
              }
            }
            */

            //if the load and store alligns
            int intDiffConst;
            int intDiffConstMax;
            ScevEdgeType scevEdgeType;
            bool edgeFound = false;
            if (instr1OpTypeSize == instr2OpTypeSize) {
              errs() << "opTypeSize:" << opTypeSize << "\n";
              errs() << "addrScevDiff: " << *loadStoreScevDiff << "\n";

              if (!(seaa->getSignedRange(loadStoreScevDiff).getSignedMin().slt(-999)
                  && seaa->getSignedRange(loadStoreScevDiff).getSignedMax().sgt(999))) {
                errs() << "addrScevDiffMin: ";
                errs() << seaa->getSignedRange(loadStoreScevDiff).getSignedMin() << "\n";
                errs() << "addrScevDiffMax: ";
                errs() << seaa->getSignedRange(loadStoreScevDiff).getSignedMax() << "\n";
              }
                            
              //if diff does not depend on the inner loop (but depends on the outer loop)
              //if diff is constant
              if (isLoopIndependent(loadStoreScevDiff, loop) &&
                  (dyn_cast<SCEVConstant>(loadStoreScevDiff) ? 1 : 0)) {
                //if diff is constant
                if (const SCEVConstant * loadStoreScevDiffConst =
                    dyn_cast<SCEVConstant>(loadStoreScevDiff)) {
                  intDiffConst =
                    loadStoreScevDiffConst->getValue()->getSExtValue();
                  intDiffConstMax = intDiffConst;
                  scevEdgeType = ScevEdgeConst;
                  edgeFound = true;
                  errs() << "A3, ScevEdgeConst, intDiffConst:" << intDiffConst;
                  errs() << "\n";                  
                }
              } else { //if(false)
                //try to reason about scev ranges
                int rangePositiveInfinity = 9999;            
                int rangeNegativeInfinity = -rangePositiveInfinity;
                if (!(seaa->getSignedRange(loadStoreScevDiff).getSignedMin().slt(rangeNegativeInfinity)
                      && seaa->getSignedRange(loadStoreScevDiff).getSignedMax().sgt(rangePositiveInfinity))) {
                  long rangeMin = seaa->getSignedRange(loadStoreScevDiff).getSignedMin().getSExtValue();
                  long rangeMax = seaa->getSignedRange(loadStoreScevDiff).getSignedMax().getSExtValue();

                  intDiffConst = rangeMax > 0 ? max((long) 0, rangeMin) : rangeMax;
                  intDiffConstMax = rangeMax;
                  scevEdgeType = ScevEdgeRange;                                
                  edgeFound = true;
                  errs() << "A4, ScevEdgeRange, intDiffConst:"<< intDiffConst;
                  errs() << ", intDiffConstMax: " << intDiffConstMax << "\n";                  
                }
              }

              if (edgeFound) {
                //if((intDiffConst/opTypeSize) % indVarIncrAbs == 0)
                {   
                  //if diff is a multiple of the step
                  //TODO: instead of allign use the size 
                  assert(intDiffConst % opTypeSize == 0);                                                                                                                               
                  //TODO: if the difference is not an integer multiple of
                  //the step there is no dependence? or is it an error?
                  assert(intDiffConst / opTypeSize % indVarDivUnroll == 0);
                  int distance  =(((intDiffConst / opTypeSize)) / indVarDivUnroll);
                  // indVarIncrAbs;
                  
                  int distanceMax = (((intDiffConstMax / opTypeSize)) / indVarDivUnroll);
                  errs() << "distance: " << distance << "\n";

                  ScevEdge *scevEdge = new ScevEdge(instrOrderMap.at(instr1),
                      instrOrderMap.at(instr2), distance, scevEdgeType,
                      distanceMax);
                  scevEdgeAr.push_back(scevEdge);
                  scevDiffNom.add(instrOrderMap.at(instr1),
                      instrOrderMap.at(instr2), scevEdge);
                }                                
              }
            }
          }
        }
      }
    }
  }

  errs() << "=== ProbDef: " << "\n";

  NodeCollection nodeCol;
  EdgeCollection edgeCol;

  //nodes
  for (auto instrIt = loopInstrAr.begin(); instrIt != loopInstrAr.end();
      ++instrIt) {
    //get instruction
    Instruction *instr = *instrIt;
    nodeCol.add(instr, instrOrderMap.at(instr));
  }

  //edges
  for (int i = 0; i < memDepAr.size(); i++) {
    MemDepEdge* memDep = memDepAr[i];
    Edge* edge = (Edge*) 0; 
    
    errs() << "Analyzing " << memDep->srcIdx << "-" << memDep->dstIdx << " ";
    errs() << memDep->toString() << "\n";
    
    ScevEdge* srcDstScevDiff = scevDiffNom.get(memDep->srcIdx, memDep->dstIdx);
    if (srcDstScevDiff) {            
      assert(memDep->srcIdx == srcDstScevDiff->srcIdx
          && memDep->dstIdx == srcDstScevDiff->dstIdx); 
      if(memDep->depType == Anti) {
        if(srcDstScevDiff->type == ScevEdgeConst) {                
          if (memDep->srcIdx < memDep->dstIdx ? srcDstScevDiff->dist >= 0 :
               srcDstScevDiff->dist > 0) {
            //for both ScevEdgeRange and ScevEdgeConst
            errs() << "  Edge from ScevEdgeConst scev\n";
            edge = edgeCol.add(nodeCol.get(loopInstrAr[memDep->srcIdx]),
                nodeCol.get(loopInstrAr[memDep->dstIdx]), 0,
                srcDstScevDiff->dist, Dependency, "");
          } else {
            errs() << "  no Edge, dist condition fail for ScevEdgeConst\n";
          }
        } else if (srcDstScevDiff->type == ScevEdgeRange) {
          if (srcDstScevDiff->dist >= 0 && (memDep->srcIdx <
                memDep->dstIdx ? true : srcDstScevDiff->getDistMax() >= 1)) {
            errs() << "  Edge from ScevEdgeRange\n";
            edge = edgeCol.add(nodeCol.get(loopInstrAr[memDep->srcIdx]),
                nodeCol.get(loopInstrAr[memDep->dstIdx]), 0,
                memDep->srcIdx < memDep->dstIdx ? srcDstScevDiff->dist :
                max(1, srcDstScevDiff->dist), Dependency, "");
          } else {
            errs() << "  no Edge, dist condition fail for ScevEdgeRange\n";
          }
        }
      } else if (memDep->depType == Flow) {
        if (srcDstScevDiff->type == ScevEdgeConst) {
          if (isValidReuse(memDep, scevDiffNom, loopInstrAr, aa)) {
            errs() << "  Edge from ScevEdgeConst\n";
            if (memDep->srcIdx < memDep->dstIdx ? srcDstScevDiff->dist >= 0 :
                srcDstScevDiff->dist > 0) {
              edge = edgeCol.add(nodeCol.get(loopInstrAr[memDep->srcIdx]),
                  nodeCol.get(loopInstrAr[memDep->dstIdx]), 1,
                  srcDstScevDiff->dist, ReuseFlow, "");
            }
          } else {
            errs() << "  dist condition fail for ScevEdgeConst\n";
          }      
        } else if (srcDstScevDiff->type == ScevEdgeRange) {
          //this is not a valid reuse but there is a range scev so we can
          //put a more accurate lower bound on the distance 
          if (srcDstScevDiff->dist >= 0 && (memDep->srcIdx <
              memDep->dstIdx ? true : srcDstScevDiff->getDistMax() >= 1)) {
            errs() << "  edge from ScevEdgeRange\n";
            edge = edgeCol.add(nodeCol.get(loopInstrAr[memDep->srcIdx]),
                nodeCol.get(loopInstrAr[memDep->dstIdx]), 0,
                memDep->srcIdx < memDep->dstIdx ? srcDstScevDiff->dist :
                max(1, srcDstScevDiff->dist), Dependency, "");
          } else {
            errs() << "  no Edge, dist condition fail for ScevEdgeRange\n";
          }
        }                             
      } else if (memDep->depType == Input) {
        if(srcDstScevDiff->type == ScevEdgeConst) {                
          if (isValidReuse(memDep, scevDiffNom, loopInstrAr, aa)) {
            errs() << "  Edge from ScevEdgeConst\n";
            edge = edgeCol.add(nodeCol.get(loopInstrAr[memDep->srcIdx]),
            nodeCol.get(loopInstrAr[memDep->dstIdx]), 1,
            srcDstScevDiff->dist, ReuseInput, "");
          }                                                
        } else if (srcDstScevDiff->type == ScevEdgeRange) {
          //There is no edge in this case because two loads that reuse
          //data do not have to be ordered
          errs() << "  no Edge from ScevEdgeRange\n";
        }                               
      } else if (memDep->depType == Output) {
        if (memDep->srcIdx < memDep->dstIdx ? srcDstScevDiff->dist >= 0 :
            srcDstScevDiff->dist > 0) {
          errs() << "  Edge from ";
          errs() << (srcDstScevDiff->type == ScevEdgeRange ?
              "ScevEdgeRange" : "ScevEdgeConst");
          errs() << "\n";
          edge = edgeCol.add(nodeCol.get(loopInstrAr[memDep->srcIdx]),
              nodeCol.get(loopInstrAr[memDep->dstIdx]), 0,
              srcDstScevDiff->dist, Dependency, "");
        } else {
          errs() << "  no Edge from ScevEdge because dist<0 or dist<1\n";
        }
      } else {
        assert(false);
      }
    } else {
      errs() << "  Edge from MemDep, didn't find scev\n";
      //memory dependency does not occur in the scev diff map
      if (memDep->depType == Anti || memDep->depType == Flow) {
        edge = edgeCol.add(nodeCol.get(loopInstrAr[memDep->srcIdx]),
            nodeCol.get(loopInstrAr[memDep->dstIdx]), 0, memDep->dist,
            Dependency, "");
      }
    }

    if (edge)
      errs() << "  " << edge->toString() << "\n";
  }

  //ssa graph
  int externalCount = 0;
  for (int i = 0; i < loopInstrAr.size(); i++) {
    Instruction* instr = loopInstrAr[i];
    for (User::op_iterator opIt = instr->op_begin(); opIt != instr->op_end();
        ++opIt) {
      Use *use = opIt;
      Value *useValue = (use->operator Value *());
      if (Instruction * useInst = dyn_cast<Instruction>(useValue)) {
        Node* srcNode = (Node*)0;
        Node* dstNode = nodeCol.get(instr);
        int distance;
        errs() << *useInst <<"\n";
        if (nodeCol.get(useInst) > 0) {
          srcNode = nodeCol.get(useInst);
          distance = srcNode->order<dstNode->order ? 0 : 1;
        } else {
          //remember this external definition
          externalCount++;          
          assert(extDefSet.count(useInst));
          //create new node for an external definition
          srcNode = nodeCol.add(useInst, Node::ORDER_EXTERNAL);

          //fixed distance for edges comming from external definitions
          distance = 0;
        }

        Edge* edge = edgeCol.add(srcNode, dstNode, 1, distance, ReuseFlow,
            PassTools::getVarId(useInst));
      } else {
        //errs() << "UseValueType: " << typeid(*useValue).name() << "\n";
        //errs() << "  " << *useValue << "\n";
      }
    }
  }
  assert(extDefSet.size()==externalCount);
  
  /*
  // Get an upper-bound to the tiling cost with heuristics
  // The graph on which we compute is independant: it's a deep-copy so no data is altered
  Graph *graph = graphFromCollections(nodeCol, edgeCol);
  list<Edge *> edgeList;

  for (auto it = graph->getEdges().begin(); it != graph->getEdges().end(); ++it) {
    Node * source = graph->getNodeById((*it)->srcId);
    Node * destination = graph->getNodeById((*it)->dstId);
    if ((source->order != -1) && (destination->order != -1))
      edgeList.push_back(*it);
  }
  
  auto comparisonPointer = std::bind(&Graph::compareEdges, *graph, std::placeholders::_1, std::placeholders::_2);
  edgeList.sort(comparisonPointer);

  ScheduleHeuristic * scheduler = new ScheduleHeuristic(*graph, edgeList);
  scheduler->run();
  TileHeuristic * tiler = new TileHeuristic(*graph, edgeList);
  tiler->run();
  int costUpperBound = tiler->getTotalCost();

  errs() << "*** UpperBound : " << costUpperBound << " ***\n";

  delete graph;
  delete scheduler;
  delete tiler;
  // End of cost upper-bound computation
  // */

  edgeCol.sort();
   
  if(false){
      errs() << "=== ProbDefStart:\n";  
      writeProbdef(errs(), edgeCol, nodeCol, loopName);
      errs() << "=== ProbDefEnd:\n";
  }

  std::error_code ec;
  errs() << "FileWrite: " << TileGraphFileOut << "\n";
  raw_fd_ostream fostr(TileGraphFileOut.c_str(), ec, sys::fs::F_Append);    
  writeProbdef(fostr, edgeCol, nodeCol, loopName);
  if(ec.message().compare("Success")!=0)
    errs()<< "FileWriteError: " << ec.message() << "\n";
  fostr.close();  

  return false;
}

bool TileGraph::isValidReuse(MemDepEdge* memDep,
    NestedMap<ScevEdge*> &scevDiffNom, std::vector<Instruction*> &loopInstrAr,
    AliasAnalysis* aa) {
  errs() << "  Testing reuse: "; /*<< memDep->srcIdx <<"-"<< memDep->dstIdx*/
  errs() << "\n";

  assert((dyn_cast<StoreInst>(loopInstrAr[memDep->srcIdx]) ? 1 : 0) ||
      (dyn_cast<LoadInst>(loopInstrAr[memDep->srcIdx]) ? 1 : 0));  
  assert((dyn_cast<LoadInst>(loopInstrAr[memDep->dstIdx]) ? 1 : 0));  

  //get the pointer instr of the source load instruction
  Value * srcPtrInstr;
  if ((dyn_cast<LoadInst>(loopInstrAr[memDep->srcIdx]) ? 1 : 0)) {
    srcPtrInstr =
      const_cast<Value*>(dyn_cast<LoadInst>(loopInstrAr[memDep->srcIdx])->getPointerOperand());
      errs() << "    type load-load\n";
  } else {
    srcPtrInstr =
      const_cast<Value*>(dyn_cast<StoreInst>(loopInstrAr[memDep->srcIdx])->getPointerOperand());
    errs() << "    type store-load\n";
  }


  ScevEdge* srcDstScevDiff = scevDiffNom.get(memDep->srcIdx, memDep->dstIdx);
  //if this scev is of const distance (not range)
  if (srcDstScevDiff && srcDstScevDiff->type == ScevEdgeConst) {        
    //if the distance is nonegative
    if (srcDstScevDiff->dist >= 0) {
      //if there is no store operation that aliases with src, between src and dst
      bool noAliasBetween = true;
      int dist = 0;

      for (int aliasCandidateIdx = memDep->srcIdx + 1;
          aliasCandidateIdx != memDep->srcIdx &&
          (aliasCandidateIdx!=memDep->dstIdx ||
           dist < min(1, srcDstScevDiff->dist));
          aliasCandidateIdx++) {
        //wrap around
        if (aliasCandidateIdx >= loopInstrAr.size()) {
          aliasCandidateIdx = 0;
          dist++;
        }
        //errs() << j << "\n";

        //is it a sotre, test whether the src instr data is overwritten by the store
        if (const StoreInst * storeInst =
            dyn_cast<StoreInst>(loopInstrAr[aliasCandidateIdx])) {
          Value * storePtrInstr =
            const_cast<Value*>(storeInst->getPointerOperand());

          //if scev exists test scev
          if (scevDiffNom.contains(memDep->srcIdx, aliasCandidateIdx)) {
          ScevEdge* scevEdgeAliasCandidate =
            scevDiffNom.get(memDep->srcIdx, aliasCandidateIdx);

            int candidateIsAfterDst = aliasCandidateIdx>memDep->dstIdx ?
              1 : 0;
            int candidateIsBeforeSrc = aliasCandidateIdx<memDep->srcIdx ?
              1 : 0;
          
            if (0 + candidateIsBeforeSrc <= scevEdgeAliasCandidate->dist &&
                scevEdgeAliasCandidate->dist <=
                srcDstScevDiff->dist - candidateIsAfterDst) {
              noAliasBetween = false;
              errs() << "    invalid because of ";
              errs() << (scevEdgeAliasCandidate->type == ScevEdgeRange ?
                  "ScevEdgeRange" : "ScevEdgeConst");
              errs() << " with " << aliasCandidateIdx << "\n";
            }

            if (scevEdgeAliasCandidate->type == ScevEdgeRange) {
              if (0 + candidateIsBeforeSrc <=
                  scevEdgeAliasCandidate->getDistMax() &&
                  scevEdgeAliasCandidate->getDistMax() <=
                  srcDstScevDiff->dist - candidateIsAfterDst) {
                noAliasBetween = false;
                errs() << "    invalid because of ";
                errs() << (scevEdgeAliasCandidate->type == ScevEdgeRange ?
                    "ScevEdgeRange" : "ScevEdgeConst");
                errs() << " with " << aliasCandidateIdx << "\n";
              }
            }
          } else {
            //otherwise test alias
            AliasResult ar = aa->alias(srcPtrInstr, storePtrInstr);
            //does it alias with the src?
            if (!(NoAlias == ar)) {
              noAliasBetween = false;
              errs() << "    invalid because of alias with ";
              errs() << aliasCandidateIdx << "\n";
            }
          }
        }
      }

      if (noAliasBetween)
        errs() << "    valid\n";      

      return noAliasBetween;
    } else {
      errs() << "    invalid because of const SCEV diff negative (";
      errs() << srcDstScevDiff->dist << ")\n";      
      return false;
    }
  } else {
    errs() << "    invalid because no const SCEV" << "\n";
    return false;
  }
}

bool TileGraph::isLoopIndependent(const SCEV *scev, const Loop * loop) {
  if (const SCEVAddRecExpr *sare = dyn_cast<SCEVAddRecExpr>(scev)) {
    if (sare->getLoop() == loop)
      return false;

    
    for(int i = 0; i < sare->getNumOperands(); i++) {
      if (!isLoopIndependent(sare->getOperand(i), loop))
        return false;
    }
  }
  return true;
}

#else
bool TileGraph::runOnFunction(Function &F) {
  errs() << "Hello: ";
  errs().write_escaped(F.getName()) << "\n";
  InitializeAliasAnalysis(this);
  SE = &getAnalysis<ScalarEvolution>();

  return false;
}
#endif//LOOP_PASS

#ifdef MY_MOD
char TileGraph::ID = 0;
static RegisterPass<TileGraph> X("scev-tile-graph",
    "Scalar evolution must dependence pass", false, false);
#endif
