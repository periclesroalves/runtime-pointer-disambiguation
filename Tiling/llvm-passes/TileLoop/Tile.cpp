#include "Tile.h"


namespace llvm {

int Tile::getWidth() {
	return Width;
}

int Tile::setWidth(int NewWidth) {
	Width = NewWidth;
	return Width;
}

const TileSchedule& Tile::getScheduling() {
	return Scheduling;
}

void Tile::concatenateSuperNode(SuperNode &NextSuperNode) {
	Scheduling.push_back(new SuperNode(NextSuperNode));
}

bool Tile::containsNode(Node * Candidate) {
  for (auto I = Scheduling.begin(), E = Scheduling.end(); I != E; ++I) {
    for (auto I2 = (*I)->begin(), E2 = (*I)->end(); I2 != E2; ++I2) {
      if (*I2 == Candidate)
        return true;
    }
  }
  return false;
}

Instruction * Tile::getFirstInstruction() {
  for (auto I = Scheduling.begin(), E = Scheduling.end(); I != E; ++I) {
    for (auto I2 = (*I)->begin(), E2 = (*I)->end(); I2 != E2; ++I2) {
      if ((*I2)->instr)
        return (*I2)->instrAr[0];
    }
  }
  return NULL;
}

Node * Tile::getNextNode(bool Reset) {
  if (Reset || (SuperNodeIt == Scheduling.end())) {
    SuperNodeIt = Scheduling.begin();
    NodeIt = (*SuperNodeIt)->begin();
    return *NodeIt;
  }

  ++NodeIt;
  if (NodeIt != (*SuperNodeIt)->end())
    return *NodeIt;

  ++SuperNodeIt;
  if (SuperNodeIt != Scheduling.end()) {
    NodeIt = (*SuperNodeIt)->begin();
    return *NodeIt;
  }

  return NULL;
}

} // end of namespace llvm
