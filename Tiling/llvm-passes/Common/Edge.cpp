#include "Edge.h"

using namespace llvm;
    
    Edge::Edge(std::string id, Node* srcNode, Node* dstNode, int weight, int dist,
          EdgeType edgeType, std::string varId) :
        id(id),
        srcId(srcNode->id),
        dstId(dstNode->id),
        weight(weight),
        dist(dist),
        edgeType(edgeType),
        varId(varId)
        {};
    
    std::string Edge::toString() {
        std::string retValue("");
    
        retValue += "Edge{ srcId: " + srcId + ", dstId: " + dstId + ", latency: ";
        retValue += itostr(latency) + ", dist: " + itostr(dist) + ", weight: ";
        retValue += itostr(weight) + ", edgeType: ";
        switch (edgeType) {
          case Dependency:
            retValue += "Dependency }";
            break;
          case ReuseFlow:
            retValue += "ReuseFlow }";
            break;
          case ReuseInput:
            retValue += "ReuseInput }";
            break;
          default:
            retValue += "Err }";
        }
        return retValue;
    }
    
