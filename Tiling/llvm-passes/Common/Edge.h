#pragma once

#include "llvm/IR/Instruction.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/Use.h"

#include "Node.h"

using namespace llvm;
using namespace std;

namespace llvm {   
    enum EdgeType {
      Dependency = 0,
      ReuseFlow = 1,
      ReuseInput = 2
    };
    
    class Edge {
    public:
    	Edge(std::string id, class Node* srcNode, class Node* dstNode, int weight, int dist,
             EdgeType edgeType, std::string varId);
             
      std::string id;
      std::string srcId;
      std::string dstId;
      int latency = 1;
      int dist;
      int weight;
      EdgeType edgeType;
      std::string varId;
      std::string dbg;
      
      std::string toString();
    };    
}
