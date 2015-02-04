#include "Graph.h"

using namespace llvm;

Graph::Graph()
{
}
    
void Graph::addEdge(Edge* edge)
{
    edgeAr.push_back(edge);        
    edgeIdMap[edge->id]=edge;
    Node* srcNode = getNodeById(edge->srcId);
    Node* dstNode = getNodeById(edge->dstId);
    assert(srcNode);
    assert(dstNode);
    nodeOutEdgeMap[srcNode].insert(edge);    
    nodeInEdgeMap[dstNode].insert(edge);    
}

unordered_set<Edge*> &Graph::getNodeOutEdges(Node* node){
    return nodeOutEdgeMap[node];
}

unordered_set<Edge*> &Graph::getNodeInEdges(Node* node){
    return nodeInEdgeMap[node];
}

void Graph::addNode(Node* node)
{
    if(node->order>=0)
    {
        assert(nodeOrderMap.count(node->order)==0);
        nodeOrderMap[node->order] = node;
    }
    else if(node->order==Node::ORDER_EXTERNAL)
    {
        nodeExtSet.insert(node);
    }
    
    if(node->varId.length()>0)
    {   
        assert(nodeVarIdMap.count(node->varId)==0);
        nodeVarIdMap[node->varId] = node;
    }

    nodeIdMap[node->id]=node;
    nodeAr.push_back(node);
}

Edge* Graph::getEdgeById(string id)
{
    assert(edgeIdMap.count(id));
    return edgeIdMap[id];
}

int Graph::getNodesInLoop() {
    return (int) nodeOrderMap.size();
}

Node* Graph::getNodeByOrder(int order) {
    return nodeOrderMap[order];
}

Node* Graph::getNodeById(string id)
{
    assert(nodeIdMap.count(id));
    return nodeIdMap[id];
}

Node* Graph::getNodeByVarId(string varId)
{
    if(nodeVarIdMap.count(varId)==0)
        return (Node*) 0;
    else
        return nodeVarIdMap[varId];
}


Node* Graph::getNodeByValue(Value* value)
{
    return nodeValueMap[value];
}

bool Graph::testMatch(Node* node, string idxSfx, Instruction* instrUnr){
    bool confirmedMatch=false;
    
    string instrVarId = PassTools::getVarId(instrUnr,false);            
    string nodeVarId = node->varId;


    string nodeVarIdBase = nodeVarId;
    size_t nodeLastDot = nodeVarIdBase.find_last_of(".");
    if(nodeLastDot!=string::npos){
        nodeVarIdBase = nodeVarIdBase.substr(0,nodeLastDot);
    }

    string instrVarIdBase = instrVarId;            
    size_t instrLastDot = instrVarIdBase.find_last_of(".");
    if(instrLastDot!=string::npos){
        instrVarIdBase =instrVarIdBase.substr(0,instrLastDot);
    }



    if(StringTools::prefixMatchNoRef(nodeVarId,string("%")+PassTools::RECOMP_PFX,true)){
        if(StringTools::prefixMatchNoRef(instrVarId,string("%")+PassTools::RECOMP_PFX,true)){
            confirmedMatch = true;
        }
    }
    else{
    
        if(node->type==NodeStore && NodeStore == Node::getNodeType(instrUnr)){
            confirmedMatch = true;
        }                                
        else if(node->type==NodeBranch && NodeBranch == Node::getNodeType(instrUnr)){
            confirmedMatch = true;
        }                                                
        else if(node->type==NodeCmp && NodeCmp == Node::getNodeType(instrUnr)){
            confirmedMatch = true;
        }                   
        else if(instrVarIdBase.size()>0 && nodeVarIdBase.size()>0 ){
    
            if(instrVarIdBase.substr(0,nodeVarIdBase.size()).compare(nodeVarIdBase)==0){                                   
                confirmedMatch = true;
            }else if(nodeVarIdBase.substr(0,instrVarIdBase.size()).compare(instrVarIdBase)==0){
                confirmedMatch = true;
            }            
        }                    
    }
    
    if(idxSfx.size()>0){
        string iterIdxSfx = PassTools::getInstrUnrollIdx(instrVarId);
        if(iterIdxSfx.size()>0 && iterIdxSfx.compare(idxSfx)!=0){
            confirmedMatch = false;
        }
    }
    
    
    return confirmedMatch;
}


bool Graph::assignInstr(
    int unrollFactor,
    Instruction* indVarInstr,
    std::vector<Instruction*> &loopInstrAr,
    std::map<Value*,int> &instrOrderMap, 
    std::unordered_set<Instruction*> &extDefSet
)
{
    std::unordered_set<int> ignoreInstrTypes;
    //ignoreInstrTypes.insert(NodePhi);
    ignoreInstrTypes.insert(NodeBranch);
    ignoreInstrTypes.insert(NodeCmp);

    std::unordered_set<int> ignoreNodeTypes;
    //ignoreInstrTypes.insert(NodePhi);
    //ignoreNodeTypes.insert(NodeBranch);
    //ignoreNodeTypes.insert(NodeCmp);

    
    std::vector<Node*> bodyAr;    
    {
        int order=0;
        while(nodeOrderMap.count(order)){
            Node* node = nodeOrderMap[order];
            if(!ignoreNodeTypes.count(node->type))
            {
                bodyAr.push_back(node);            
            }        
            order++;
        }
    }
    
    std::unordered_set<Node*> nodeExtUnmatchedSet;
    for(auto it = nodeExtSet.begin();it!=nodeExtSet.end();it++){
        Node* node = *it;
        nodeExtUnmatchedSet.insert(node);
    }    
    
    
    errs() << "=== External nodes to match ==="<<"\n";
    for(auto it = nodeExtUnmatchedSet.begin();it!=nodeExtUnmatchedSet.end();it++){
        Node* node = *it;
        errs() << node->toString() <<"\n";        
    }       
     
    errs() << "=== Nodes to match ==="<<"\n";
    for(int i=0;i<bodyAr.size();i++){
        errs() << bodyAr[i]->toString() <<"\n";
    }

    errs() << "\n";
    errs() <<"Matching external instructions" << "\n";    
    for(auto it = extDefSet.begin(); it!=extDefSet.end();it++){
        Instruction* instr = *it;
        errs() << "Instruction: "<< *instr << "\n";        
        Node* node = getNodeByVarId(PassTools::getVarId(instr));
        if(node){        
            node->instr = instr;
            assert(nodeExtUnmatchedSet.count(node));
            nodeExtUnmatchedSet.erase(node);
            errs() <<"  Matched: " << node->toString() <<"\n";
        }
        else
        {
            errs() <<"  Node does not exist for instruction: "<<*instr<<"\n";
            return false;
        }
    }

        
    errs() << "\n";
    errs() <<"Matching instructions" << "\n";
    Instruction *singlePhi=0,*singleBranch=0,*singleCmp=0;        
    int matchIdx = 0;
    int iterCnt = 0;
    int order=-1;
    while(order+1<loopInstrAr.size()){
        
        if(iterCnt == unrollFactor){
            break;
        }        

        order++;
        Instruction* instrUnr = loopInstrAr[order];
        
        errs() << "Instruction: "<< *instrUnr << "\n";                
        bool confirmedMatch = false;
        
        //match external
        bool confirmedMatchExt = false;
        for(auto it = nodeExtUnmatchedSet.begin();it!=nodeExtUnmatchedSet.end();it++){
            Node* node = *it;
            if(node->type==NodePhi){
                if(Node::getNodeType(instrUnr)==NodePhi){
                    confirmedMatchExt = true;
                }
            }
            else if(testMatch(node,string(""),instrUnr)){
                confirmedMatchExt = true;
            }
            
            if(confirmedMatchExt){
                errs() <<"  Matched external: " << node->toString() <<"\n";
                if(!node->instr){
                    node->instr = instrUnr;
                }
                node->instrAr.push_back(instrUnr);                                            
                //nodeExtUnmatchedSet.erase(node);                
                break;                        
            }
            
        } 
               
        //match body
        while(!confirmedMatch)
        {   
            if(iterCnt == unrollFactor){
                break;
            }        
             
            Node* node = bodyAr[matchIdx];
                        
            string idxSfx = (iterCnt==0 ? string("") : string(".")+itostr(iterCnt));                                         
            confirmedMatch = testMatch(node,idxSfx,instrUnr);
            
            if(confirmedMatch)
            {
                errs() <<"  Matched in body: " << node->toString() <<"\n";
                //add t the node instructions            
                if(!node->instr){
                    node->instr = instrUnr;
                }
                node->instrAr.push_back(instrUnr);                                            
                node->dualMatch = confirmedMatchExt;
                matchIdx++;
                if(matchIdx>=bodyAr.size()){
                    matchIdx=0;
                    iterCnt++;
                }
                                
            }
            else
            {
                errs() <<"  NOT matched in body : " << node->toString() <<"\n";                    

                if(instrUnr==indVarInstr){
                    errs() <<"  Skip induction variable" <<"\n";
                    break;
                }                                                            
                else if(ignoreInstrTypes.count(Node::getNodeType(instrUnr))){
                    errs() <<"  Skip basing on ignoreInstrTypes" <<"\n";
                    break;
                }                                                            
                else{                                               
                    //in some unrollings the induction variable increment does not have to be matched
                    size_t dotIdx =  node->varId.find_first_of(".");
                    if(dotIdx!= string::npos && node->varId.substr(dotIdx+1,node->varId.size()-dotIdx-1).compare("next")==0){
                        //special case when the instruciton is skipped
                        errs() <<"  Skiping this instruction " <<"\n";
                        //continue
                        matchIdx++;
                        if(matchIdx>=bodyAr.size()){
                            matchIdx=0;
                            iterCnt++;
                        }                                
                    }
                    else
                    {
                        return false;
                        //assert(false);   
                    }
                }    
            }
        }
    }


    errs() <<"Found "<<iterCnt<<" unrolled iterations \n";    
    if(iterCnt!=unrollFactor){
        errs() <<"Loop unrolled too few times"<<"\n";
        return false;
    }


    errs() <<"Matching epilogue ... " <<"\n";
    vector<Instruction*> epilogueInstrAr;
    while(order+1<loopInstrAr.size()){

        order++;
        Instruction* instrUnr = loopInstrAr[order];
        
        //allow one phi one test and one branch per unrolled loop
        if(!singleBranch && NodeBranch == Node::getNodeType(instrUnr)){
            errs() <<"  Allowing singleBranch " <<"\n";
            singleBranch = instrUnr;                        
        }
        else if(!singleCmp && NodeCmp == Node::getNodeType(instrUnr)){
            errs() <<"  Allowing singleCmp " <<"\n";
            singleCmp = instrUnr;                        
        }
        else if(!singlePhi && NodePhi == Node::getNodeType(instrUnr)){
            errs() <<"  Allowing singlePhi " <<"\n";
            singlePhi = instrUnr;                        
        }
        else if(StringTools::prefixMatchNoRef(PassTools::getVarId(instrUnr,false),string("%")+PassTools::RECOMP_PFX,true)){
            errs() <<"  Allowing recomp instruction " <<"\n";
        }
        else if(StringTools::prefixMatchNoRef(PassTools::getVarId(instrUnr,false),string("%indvar.next",true))){
            errs() <<"  Allowing indvar.next instruction " <<"\n";
        }
        else{
            break;
        }
        
        epilogueInstrAr.push_back(instrUnr);            
    }    

    errs() <<"Found "<<epilogueInstrAr.size()<<" epilogue instructions \n";    
    
    if(order+1<loopInstrAr.size()){
        errs() <<"Not all loop body instructions were matched"<<"\n";
        return false;
    }
    
    //verify marching of internal nodes
    errs() << "Verifying match of loop body instructions"<<"\n";
    
    order = 0;
    bool verifOk = true;
    while(nodeOrderMap.count(order)){
        Node* node = nodeOrderMap[order];
        int expectedInstrInstances = node->ignoredInMatching() ? 0 : unrollFactor ;
        if(!(node->instrAr.size()==expectedInstrInstances)){
            errs()<<"Failed, matched "<< node->instrAr.size()<<"/"<<expectedInstrInstances<<" for " << node->toString() << "\n";                   
            verifOk = false;
        }                
        order++;
    }
    //verify marching of external nodes
    errs() << "Verifying match of external instructions"<<"\n";
    for(auto it = nodeExtSet.begin();it!=nodeExtSet.end();it++){
        Node* node = *it;
        if(!node->instr){
            errs()<<"Failed, did not match external node "<< node->toString()<<"\n";
            verifOk = false;
        }
    }    
    
    return verifOk;
}

void Graph::permuteNodes(int order1, int order2) {
  Node * A = nodeOrderMap[order1];
  Node * B = nodeOrderMap[order2];
  A->order = order2;
  B->order = order1;
  nodeOrderMap[order1] = B;
  nodeOrderMap[order2] = A;
}

const unordered_set<Node*>& Graph::getExternalNodes() {
  return nodeExtSet;
}

const vector<Edge*>& Graph::getEdges() {
  return edgeAr;
}

bool Graph::compareEdges(Edge * A, Edge * B) {
  Node * srcA, * srcB, * dstA, * dstB;
  if (A->weight != B->weight)
    return (A->weight > B->weight);

  srcA = nodeIdMap[A->srcId];
  srcB = nodeIdMap[B->srcId];
  dstA = nodeIdMap[A->dstId];
  dstB = nodeIdMap[B->dstId];
  return ((dstA - srcA) > (dstB - srcB));
}

map<std::string,Graph*> &Graph::parseGraph(string path)
{   
    assert(path.length()>0);
    errs() <<"reading file: "<<path<<"\n";
    std::basic_ifstream<char> is(path.c_str());        
    map<std::string,Graph*> &graphMap = *(new map<std::string,Graph*>());
    
    if(is.is_open() && !ParseTools::testIsEof(is))
    {
        ParseTools::consumeEmptyLines(is);
        while(ParseTools::testIsArrayElement(is))
        {
            ParseTools::consumeArrayElement(is);
            string loopName = ParseTools::consumeKeyValStr(is,"loopName");
            Graph *graph = new Graph();
            graphMap[loopName] = graph;
    
            ParseTools::consumeKey(is,"nodeAr");                        
            while(ParseTools::testIsArrayElement(is))
            {
                ParseTools::consumeArrayElement(is);
                int idx = ParseTools::consumeKeyValInt(is,"idx");
                string id = ParseTools::consumeKeyValStr(is,"id");
                int order = ParseTools::consumeKeyValInt(is,"order");                
                //ParseTools::consumeAllKeyValStr(is);                
                int type = ParseTools::consumeKeyValInt(is,"type");
                string varId = ParseTools::consumeKeyValStr(is,"varId");
                string instrId = ParseTools::consumeKeyValStr(is,"instrId");
                string dbg = ParseTools::consumeKeyValStr(is,"dbg"); 
    
                Node *node = new Node(idx,id,order,(NodeType)type,varId,instrId,dbg);
                graph->addNode(node);
            }
            ParseTools::consumeEmptyLines(is);            
            ParseTools::consumeKey(is,"edgeAr");                        
            while(ParseTools::testIsArrayElement(is))
            {
                ParseTools::consumeArrayElement(is);
                string id = ParseTools::consumeKeyValStr(is,"id");
                string srcId = ParseTools::consumeKeyValStr(is,"srcId");
                string dstId = ParseTools::consumeKeyValStr(is,"dstId");                
                int latency = ParseTools::consumeKeyValInt(is,"latency");
                int dist = ParseTools::consumeKeyValInt(is,"dist");
                int weight = ParseTools::consumeKeyValInt(is,"weight"); 
                string varId = ParseTools::consumeKeyValStr(is,"varId"); 
                int edgeType = ParseTools::consumeKeyValInt(is,"edgeType"); 
    
    
                Node* srcNode = graph->getNodeById(srcId);
                Node* dstNode = graph->getNodeById(dstId);
                Edge *edge = new Edge(id,srcNode,dstNode, weight, dist, (EdgeType)edgeType, varId);
                graph->addEdge(edge);
                srcNode->addEdge(edge);
                dstNode->addEdge(edge);
            }
            ParseTools::consumeEmptyLines(is);
        }
        ParseTools::consumeEof(is);
    }
    
    return graphMap;
}
