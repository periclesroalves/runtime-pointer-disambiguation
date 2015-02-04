#pragma once

#include "PassTools.h"
#include "Node.h"
#include "Edge.h"
#include "ParseTools.h"

#include <list>

using namespace llvm;
using namespace std;

namespace llvm {   
    
    class Graph
    {
    private:
        //nodes but only the ones constituting the loop body (not external)
        map<int,Node*> nodeOrderMap; 
        //nodes having a varId (not stores, branches, etc.)
        map<string,Node*> nodeVarIdMap;

        map<Value*,Node*> nodeValueMap;
        //all nodes by Id
        map<string,Node*> nodeIdMap;
        //all nodes in undefined ordering
        vector<Node*> nodeAr;
        
        map<Node*,unordered_set<Edge*>> nodeOutEdgeMap;        
        map<Node*,unordered_set<Edge*>> nodeInEdgeMap;        
        
        unordered_set<Node*> nodeExtSet;
        
        vector<Edge*> edgeAr;
        map<string,Edge*> edgeIdMap;
        
    private:
        bool testMatch(Node* node, string idxSfx, Instruction* instrUnr);
    
    public:
        Graph();
        
        void addEdge(Edge* edge);        
        void addNode(Node* node);        
        Node* getNodeById(string id);
        Node* getNodeByVarId(string id);
        Edge* getEdgeById(string id);    
        int getNodesInLoop(void);
        Node* getNodeByOrder(int order);
        Node* getNodeByValue(Value* value);        
        unordered_set<Edge*> &getNodeOutEdges(Node* node);
        unordered_set<Edge*> &getNodeInEdges(Node* node);
        bool assignInstr(
            int unrollFactor, 
            Instruction* indVarInstr,
            std::vector<Instruction*> &loopInstrAr,
            std::map<Value*,int> &instrOrderMap, 
            std::unordered_set<Instruction*> &extDefSet
        );       

        void permuteNodes(int order1, int order2);
        const unordered_set<Node*> &getExternalNodes(void);
        const vector<Edge*>& getEdges(void);
        bool compareEdges(Edge * A, Edge * B);
        
        
        static map<std::string,Graph*> &parseGraph(string path);

    };
}
