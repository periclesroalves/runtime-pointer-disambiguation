#include "Graph.h"
#include "TileHeuristic.h"

#include <string>
#include <cstdlib>


using namespace llvm;


int TileEvaluator::validTile(int Low, int High) {
  int NewWidth;
  int CurrentWidth = INT32_MAX;
  int CurrentSliceCost = 0;
  int RemainingStateSize;
  Node * Before = NULL;

  if (Low == High) {
    Before = Parent.Base.getNodeByOrder(Low);
    if (Parent.MemoryCapacity < getStateSize(Before))
      return 1;
    else
      return -1;
  }

  for (int I = Low; I < High; ++I) {
    Before = Parent.Base.getNodeByOrder(I);

    for (auto I2 = Before->inEdgeAr.begin(), E = Before->inEdgeAr.end();
        I2 != E; ++I2) {
      if (Parent.Base.getNodeById((*I2)->srcId)->order >= Low)
        CurrentSliceCost -= (*I2)->weight;
    }

    for (auto I2 = Before->outEdgeAr.begin(), E = Before->outEdgeAr.end();
        I2 != E; ++I2) {
      if (Parent.Base.getNodeById((*I2)->dstId)->order <= High)
        CurrentSliceCost += (*I2)->weight;
    }

    RemainingStateSize = Parent.MemoryCapacity - CurrentSliceCost;
    if (RemainingStateSize < 0)
      return 0;

    if (RemainingStateSize > getStateSize(Before)) {
      RemainingStateSize -= getStateSize(Before);
      NewWidth = 1 + RemainingStateSize / CurrentSliceCost;
      if (NewWidth < CurrentWidth)
        CurrentWidth = NewWidth;
    } else {
      CurrentWidth = 1;
    }
  }
  return CurrentWidth;
}


void TileEvaluator::tileCost(Tile * Target) {
  int CurrentIoCost = 0;
  int CurrentStateCost = 0;

  for (int I = Target->Floor; I <= Target->Ceiling; ++I) {
    Node * Current = Parent.Base.getNodeByOrder(I);

    for (auto I2 = Current->inEdgeAr.begin(), E = Current->inEdgeAr.end();
        I2 != E; ++I2) {
      if (Parent.Base.getNodeById((*I2)->srcId)->order < Target->Floor)
        CurrentIoCost += (*I2)->weight;
    }

    CurrentStateCost+= getStateSize(Current);
  }

  Target->Cost =
    CurrentIoCost / (Target->Ceiling - Target->Floor + 1);
  if (Target->Width >= -1)
    Target->Cost += CurrentStateCost / Target->Width;
}


int TileEvaluator::getStateSize(Node * Target) {
  int StateSize = 0;

  for (auto I = Target->outEdgeAr.begin(), E = Target->outEdgeAr.end(); I != E;
      ++I)
    StateSize += (*I)->weight * (*I)->dist;

  return StateSize;
}


Tile * TileHeuristic::newTile(int Low, int High) {
  Tile * NewTile = new Tile(Low, High);
  NewTile->Width = TileEvaluation->validTile(Low, High);
  TileEvaluation->tileCost(NewTile);
  return NewTile;
}


void TileHeuristic::run() {
  for (auto I = EdgesForTiling.begin(), E = EdgesForTiling.end(); I != E; ++I) {
    switch (edgeInTile(*I)) {
      case 0:
      case 1:
      case 2:
      case 3:
        break;
        
      case 4:
        {
          Node * Source = Base.getNodeById((*I)->srcId);
          Node * Destination = Base.getNodeById((*I)->dstId);
          if (TileEvaluation->validTile(Source->order, Destination->order) > 0) {
            Tile * NewTile = newTile(Source->order, Destination->order);
            extendTile(NewTile);
            insertTile(NewTile);
          }
        }
        break;

      default:
        exit(EXIT_FAILURE);
    }
  }

  fillHoles();
}


int TileHeuristic::getTotalCost() {
  int Cost = 0;

  for (auto I = Tiles.begin(), E = Tiles.end(); I != E; ++I)
    Cost += (*I)->Cost * ((*I)->Ceiling - (*I)->Floor + 1);

  return Cost;
}


int TileHeuristic::edgeInTile(Edge * CheckedEdge) {
  int Start = Base.getNodeById(CheckedEdge->srcId)->order;
  int Stop = Base.getNodeById(CheckedEdge->dstId)->order;

  for (auto I = Tiles.begin(), E = Tiles.end(); I != E; ++I) {
    if (Stop < (*I)->Floor)
      break;
    else if ((*I)->Ceiling < Start)
      continue;

    if ((*I)->Floor <= Start) {
      if (Stop <= (*I)->Ceiling) {
        return 0;
      } else {
        if ((++I == Tiles.end()) || (Stop < (*I)->Floor))
          return 2;

        while (++I != Tiles.end()) {
          if (((*I)->Floor <= Stop) && (Stop <= (*I)->Ceiling))
            return 1;
          else if (Stop < (*I)->Floor)
            return 3;
        }

        return 3;
      }
    } else {
      if (Stop <= (*I)->Ceiling) {
        return 2;
      } else {
        if ((++I == Tiles.end()) || (Stop < (*I)->Floor))
          return 2;
        else
          return 3;
      }
    }
  }

  return 4;
}


bool TileHeuristic::compareEdges(Edge * A, Edge * B) {
  Node * SrcA, * SrcB, * DstA, * DstB;
  if (A->weight != B->weight) {
    return (A->weight > B->weight);
  }

  SrcA = Base.getNodeById(A->srcId);
  SrcB = Base.getNodeById(B->srcId);
  DstA = Base.getNodeById(A->dstId);
  DstB = Base.getNodeById(B->srcId);

  return ((DstA->order - SrcA->order) <= (DstB->order - SrcB->order));
}


void TileHeuristic::fillHoles() {
  int TileLimit = -1;

  for (auto I = Tiles.begin(), E = Tiles.end(); I != E; ++I) {
    if (TileLimit + 1 < (*I)->Floor) {
      Tile * NewTile = newTile(TileLimit + 1, TileLimit + 1);
      extendTile(NewTile);
      I = Tiles.insert(I, NewTile);
    }

    TileLimit = (*I)->Ceiling;
  }

  while (TileLimit < (int) Base.getNodesInLoop() - 1) {
    Tile * NewTile = newTile(TileLimit + 1, TileLimit + 1);
    extendTile(NewTile);
    TileLimit = NewTile->Ceiling;
    Tiles.push_back(NewTile);
  }
}


void TileHeuristic::insertTile(Tile * NewTile) {
  for (auto I = Tiles.begin(), E = Tiles.end(); I != E; ++I) {
    if (NewTile->Ceiling < (*I)->Floor) {
      Tiles.insert(I, NewTile);
      return;
    } else if (NewTile->Floor <= (*I)->Ceiling) {
      exit(EXIT_FAILURE);
    }
  }

  Tiles.push_back(NewTile);
}


void TileHeuristic::extendTile(Tile * Target) {
  int CurrentFloor = Target->Floor;
  int CurrentCeiling = Target->Ceiling;
  int BestSpan = Target->Ceiling - Target->Floor;
  Tile * CurrentTile;
  Tile * BestTile = Target;
  Tile * PrevTile = retrievePrevTile(CurrentFloor);
  Tile * NextTile = retrieveNextTile(CurrentCeiling);

  TileEvaluation->tileCost(Target);

  while (CurrentFloor >= 0) {
    if (PrevTile && (CurrentFloor == PrevTile->Ceiling)) {
      break;
    } else if (TileEvaluation->validTile(CurrentFloor, CurrentCeiling) <= 0) {
      break;
    }

    CurrentFloor--;
  }

  while (++CurrentFloor <= Target->Floor) {
    while (++CurrentCeiling < (int) Base.getNodesInLoop()) {
      if (NextTile && (CurrentCeiling == NextTile->Floor))
        break;
      else if (TileEvaluation->validTile(CurrentFloor, CurrentCeiling) <= 0)
        break;

      CurrentTile = newTile(CurrentFloor, CurrentCeiling);

      if ((CurrentTile->Cost < BestTile->Cost) ||
          ((CurrentTile->Cost == BestTile->Cost) &&
           ((CurrentCeiling - CurrentFloor) > BestSpan))) {
        BestTile = CurrentTile;
        BestSpan = CurrentCeiling - CurrentFloor;
      } else {
        delete CurrentTile;
      }
    }
  }

  if (BestTile != Target) {
    Target->Floor = BestTile->Floor;
    Target->Ceiling = BestTile->Ceiling;
    Target->Width = TileEvaluation->validTile(Target->Floor, Target->Ceiling);
    TileEvaluation->tileCost(Target);
    delete BestTile;
  }
}


Tile * TileHeuristic::retrievePrevTile(int Order) {
  for (auto I = Tiles.begin(), E = Tiles.end(); I != E; ++I) {
    if (((*I)->Floor <= Order) && ((*I)->Ceiling >= Order)) {
      return (*I);
    } else if ((*I)->Floor > Order) {
      if (I == Tiles.begin())
        return NULL;
      else
        return (*(--I));
    }
  }

  return NULL;
}


Tile * TileHeuristic::retrieveNextTile(int Order) {
  for (auto I = Tiles.begin(), E = Tiles.end(); I != E; ++I) {
    if (((*I)->Floor <= Order) && ((*I)->Ceiling >= Order))
      return (*I);
    else if ((*I)->Floor > Order)
      return (*I);
  }

  return NULL;
}
