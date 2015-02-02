#ifndef TILE_HEURISTIC_H
#define TILE_HEURISTIC_H

#include "Graph.h"

#include <list>


namespace llvm {

/* Forward class declarations */
class Tile;
class TileEvaluator;
class TileHeuristic;


class Tile {
public:
  int Width;
  int Floor;
  int Ceiling;
  int Cost;

  Tile(void) :
    Width(0),
    Floor(0),
    Ceiling(0),
    Cost(-1.0)
  {};

  Tile(int Low, int High):
    Width(0),
    Floor(Low),
    Ceiling(High),
    Cost(-1.0)
  {};
};


class TileEvaluator {
public:
  int validTile(int Low, int High);
  void tileCost(Tile * Target);

  TileEvaluator(TileHeuristic &Heuristic) :
    Parent(Heuristic)
  {};

private:
  TileHeuristic &Parent;

  int getStateSize(Node * Target);
};


class TileHeuristic {
public:
  list<Tile *> Tiles;
  int MemoryCapacity;
  Graph& Base;

  Tile * newTile(int Low, int High);
  void run(void);
  int getTotalCost(void);

  TileHeuristic(Graph& G, list<Edge *>& E) :
    MemoryCapacity(0 /* TODO */),
    Base(G),
    EdgesForTiling(E),
    TileEvaluation(new TileEvaluator(*this))
  {};

  ~TileHeuristic(void) {
    delete TileEvaluation;
  };

protected:
  list<Edge *>& EdgesForTiling;
  TileEvaluator * TileEvaluation;

  int edgeInTile(Edge * CheckedEdge);
  bool compareEdges(Edge * A, Edge * B);
  void fillHoles(void);
  void insertTile(Tile * NewTile);
  void extendTile(Tile * Target);
  Tile * retrievePrevTile(int Order);
  Tile * retrieveNextTile(int Order);
};

} // End of namespace llvm

#endif//TILE_HEURISTIC_H
