#include "Node.h"

using namespace llvm;
    
Node::Node(int idx, std::string id,int order, NodeType type, std::string varId, std::string instrId, std::string dbg) : 
    idx(idx),
    order(order),
    id(id),
    type(type),
    varId(varId),
    instrId(instrId),
    dbg(dbg),
    instr(0)
    {};

void Node::setInstr(Value* instr){
    this->instr = instr;   
}

void Node::addEdge(Edge *edge)
{
    bool added=false;
    if(edge->srcId.compare(this->id)==0){
        outEdgeAr.push_back(edge);      
        added=true;
    }

    if(edge->dstId.compare(this->id)==0){
        inEdgeAr.push_back(edge);
        added=true;
    }          

    assert(added);
}   

bool Node::ignoredInMatching()
{
    return !instr;
}

NodeType Node::getNodeType(Value* instr) {
    if (dyn_cast<GetElementPtrInst>(instr) ? 1 : 0)
      return NodeGetPtr;
    else if (dyn_cast<LoadInst>(instr) ? 1 : 0)
      return NodeLoad;
    else if (dyn_cast<StoreInst>(instr) ? 1 : 0)
      return NodeStore;
    else if (dyn_cast<PHINode>(instr) ? 1 : 0)
      return NodePhi;
    else if (dyn_cast<AllocaInst>(instr) ? 1 : 0)
      return NodeAlloc;
    else if ((dyn_cast<BranchInst>(instr) ? 1 : 0) || (dyn_cast<IndirectBrInst>(instr) ? 1 : 0))
      return NodeBranch;
    else if ((dyn_cast<ICmpInst>(instr) ? 1 : 0) || (dyn_cast<FCmpInst>(instr) ? 1 : 0))
      return NodeCmp;
    else if (dyn_cast<TruncInst>(instr) ? 1 : 0)
      return NodeTrunc;
    else
      return NodeOther;
}
 
std::string Node::toString(){
    std::string retValue("");
    retValue += "Node{ ";
    retValue += "idx: " + itostr(idx) + ", "; 
    retValue += "id: " + id + ", "; 
    retValue += "order: " + itostr(order) + ", "; 
    retValue += "type: "; 
    switch (type) {
      case NodeOther:
        retValue += "NodeOther";
        break;
      case NodeLoad:
        retValue += "NodeLoad";
        break;
      case NodeStore:
        retValue += "NodeStore";
        break;
      case NodeGetPtr:
        retValue += "NodeGetPtr";
        break;
      case NodePhi:
        retValue += "NodePhi";
        break;
      case NodeAlloc:
        retValue += "NodeAlloc";
        break;
      case NodeBranch:
        retValue += "NodeBranch";
        break;
      case NodeCmp:
        retValue += "NodeCmp";
        break;        
      case NodeTrunc:
        retValue += "NodeTrunc";
        break;        
      default:
        retValue += "Err";
    }
    retValue += ", ";
    retValue += "varId: " + varId + ", "; 
    retValue += "instrId: " + instrId + ", "; 
    retValue += "dbg:" + dbg;
    retValue += "}";
    return retValue;

}
