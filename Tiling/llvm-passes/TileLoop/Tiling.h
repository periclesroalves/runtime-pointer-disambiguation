#ifndef TILING_H
#define TILING_H

#include <set>
#include <vector>

#include "Tile.h"
#include "Graph.h"
#include "ParseTools.h"

using namespace llvm;

namespace llvm {

class Tiling {
public:
  Graph& Target;

  int getUnrollFactor(void);
  int setUnrollFactor(int NewFactor);

  const std::vector<Tile *>& getTiles(void);
  const std::set<Edge *>& getSpilledEdges(void);
  const std::set<Edge *>& getPromotedEdges(void);
  const std::set<Edge *>& getCrossTilePromotedEdges(void);
  void concatenateTile(Tile * NewTile);

  static map<std::string,Tiling*> &parseTiling(string path, map<std::string,Graph*> &graphMap);


  Tiling(int UnrollCount, std::string LoopName, Graph& BaseGraph) :
    Target(BaseGraph),
    UnrollFactor(UnrollCount),
    LoopName(LoopName)
  {};

  ~Tiling(void) {
    for (auto It = Tiles.begin(); It != Tiles.end(); ++It)
      delete *It;
  };

private:
  int UnrollFactor;
  std::string LoopName; 
  std::vector<Tile *> Tiles;
  std::set<Edge *> SpilledEdges;
  std::set<Edge *> PromotedEdges;
  std::set<Edge *> CrossTilePromotedEdges;
};

} // end of namespace llvm


#endif//TILING_H
