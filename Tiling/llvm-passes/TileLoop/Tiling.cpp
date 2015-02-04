#include <vector>

#include "Tiling.h"


using namespace llvm;


int Tiling::getUnrollFactor() {
	return UnrollFactor;
}

int Tiling::setUnrollFactor(int NewFactor) {
	UnrollFactor = NewFactor;
	return UnrollFactor;
}

const std::vector<Tile *>& Tiling::getTiles() {
	return Tiles;
}

const std::set<Edge *>& Tiling::getSpilledEdges() {
  return SpilledEdges;
}

const std::set<Edge *>& Tiling::getPromotedEdges() {
  return PromotedEdges;
}

const std::set<Edge *>& Tiling::getCrossTilePromotedEdges() {
  return CrossTilePromotedEdges;
}

void Tiling::concatenateTile(Tile * NewTile) {
	Tiles.push_back(NewTile);
}


map<std::string,Tiling*> &Tiling::parseTiling(string path, map<std::string,Graph*> &graphMap)
{   
    assert(path.length()>0);
    errs() <<"reading file: "<<path<<"\n";
    std::basic_ifstream<char> is(path.c_str());        
    map<std::string,Tiling*> &tilingMap = *(new map<std::string,Tiling*>());
    
    if(is.is_open() && !ParseTools::testIsEof(is))
    {
        int indentLoops= ParseTools::IGNORE_INDENT;
        ParseTools::consumeEmptyLines(is);
        while(ParseTools::testIsArrayElement(is,indentLoops))
        {
            indentLoops = ParseTools::consumeArrayElement(is, indentLoops);
            string loopName = ParseTools::consumeKeyValStr(is,"loopName");
            int unrollFactor = ParseTools::consumeKeyValInt(is,"unrollFactor");
            
            Graph* graph = graphMap[loopName];
            assert(graph);            
            Tiling* tiling = new Tiling(unrollFactor,loopName,*graph);
            tilingMap[loopName] = tiling;
            
            ParseTools::consumeKey(is,"tileAr");
            int indentTiles = ParseTools::IGNORE_INDENT;
            Tile* tile = (Tile*)0;
            //for each tile
            while(ParseTools::testIsArrayElement(is,indentTiles))
            {
                indentTiles = ParseTools::consumeArrayElement(is,indentTiles);                
                int width = ParseTools::consumeKeyValInt(is,"width");
                tile = new Tile(*tiling, width);
                
                ParseTools::consumeKey(is,"sNodeAr");                
                int indentSNodes = ParseTools::IGNORE_INDENT;
                //for each super node
                while(ParseTools::testIsArrayElement(is,indentSNodes))
                {
                    indentSNodes = ParseTools::consumeArrayElement(is,indentSNodes);
                    ParseTools::consumeKey(is,"nodeAr");
                    SuperNode superNode;                    
                    int indentNodes = ParseTools::IGNORE_INDENT;
                    //for each node
                    while(ParseTools::testIsArrayElement(is,indentNodes))
                    {
                        indentNodes = ParseTools::consumeArrayElement(is, indentNodes);
                        string id = ParseTools::consumeKeyValStr(is,"id");       
                        Node* node = graph->getNodeById(id);
                        assert(node);
                        superNode.push_back(node);
                    }    
                    tile->concatenateSuperNode(superNode);
                }
                tiling->concatenateTile(tile);
            }
            
            ParseTools::consumeKey(is,"spillAr");
            if(ParseTools::testIsNull(is))
            {
                ParseTools::consumeNull(is);
            }
            else
            {
                int indentNodes = ParseTools::IGNORE_INDENT;
                while(ParseTools::testIsArrayElement(is,indentNodes))
                {
                    indentNodes = ParseTools::consumeArrayElement(is, indentNodes);                    
                    string id = ParseTools::consumeKeyValStr(is,"id");
                    Edge* edge = graph->getEdgeById(id);
                    assert(edge);
                    tiling->SpilledEdges.insert(edge);
                } 
            }           

            ParseTools::consumeKey(is,"promoAr");
            if(ParseTools::testIsNull(is))
            {
                ParseTools::consumeNull(is);
            }
            else
            {
                int indentNodes = ParseTools::IGNORE_INDENT;
                while(ParseTools::testIsArrayElement(is,indentNodes))
                {
                    indentNodes = ParseTools::consumeArrayElement(is, indentNodes);
                    string id = ParseTools::consumeKeyValStr(is,"id");
                    Edge* edge = graph->getEdgeById(id);
                    assert(edge);
                    tiling->PromotedEdges.insert(edge);
                } 
            }           


            ParseTools::consumeKey(is,"promoXTileAr");
            if(ParseTools::testIsNull(is))
            {
                ParseTools::consumeNull(is);
            }
            else
            {
                int indentNodes = ParseTools::IGNORE_INDENT;
                while(ParseTools::testIsArrayElement(is,indentNodes))
                {
                    indentNodes = ParseTools::consumeArrayElement(is, indentNodes);               
                    string id = ParseTools::consumeKeyValStr(is,"id");
                    Edge* edge = graph->getEdgeById(id);
                    assert(edge);
                    tiling->CrossTilePromotedEdges.insert(edge);
                }            
            }
         }
         ParseTools::consumeEof(is);
    }
    
    return tilingMap;
}

