#pragma once

#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Use.h"
#include "llvm/ADT/StringExtras.h"

#include <typeinfo>
#include <algorithm>
#include <vector>
#include <utility>
#include <fstream>
#include <string>
#include <unordered_set>


#include "Edge.h"

using namespace llvm;
using namespace std;

namespace llvm {

    enum NodeType{
      NodeOther=0,
      NodeLoad=1,
      NodeStore=2,
      NodeGetPtr=3,
      NodePhi=4,
      NodeAlloc=5,
      NodeBranch=6,
      NodeCmp=7,
      NodeTrunc=8
    }; 


    class Node {
    public:
        Node(int idx, std::string id,int order, NodeType type, std::string varId, std::string instrId, std::string dbg = std::string(""));
                 
        int idx;
        std::string id;
        int order; //order in the loop body or -1 if outside of loop body
        std::string dbg;
        NodeType type;
        std::string varId;
        std::string instrId;
        bool dualMatch;
        Value* instr;
        std::vector<Instruction *> instrAr;
        
        static const int ORDER_EXTERNAL = -1;
        
        vector<class Edge*> inEdgeAr;
        vector<class Edge*> outEdgeAr;
        
        bool ignoredInMatching();
        void setInstr(Value* instr);
        static NodeType getNodeType(Value* instr);    
        void addEdge(Edge *edge);
        std::string toString(); 
    };
}
