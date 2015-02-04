#ifndef TILE_H
#define TILE_H

#include <vector>

#include "Node.h"


using namespace llvm;


namespace llvm {

typedef std::vector<Node *> SuperNode;
typedef std::vector<SuperNode *> TileSchedule;


class Tile {
public:
  class Tiling& Parent;

  int getWidth(void);
  int setWidth(int NewWidth);

  const TileSchedule& getScheduling(void);
  void concatenateSuperNode(SuperNode &NextSuperNode);

  bool containsNode(Node * Candidate);

  Instruction * getFirstInstruction(void);
  Node * getNextNode(bool Reset = false);
  
  Tile(class Tiling& P) :
    Parent(P),
    Width(-1)
  {
    SuperNodeIt = Scheduling.begin();
  };

  Tile(class Tiling& P, int Width) :
    Parent(P),
    Width(Width)
  {};

  ~Tile(void) {
    for (auto It = Scheduling.begin(); It != Scheduling.end(); ++It)
      (*It)->clear();
    Width = -1;
  };

private:
  int Width;
  TileSchedule Scheduling;
  SuperNode::iterator NodeIt;
  TileSchedule::iterator SuperNodeIt;
};

}// end of namespace llvm

#endif//TILE_H
