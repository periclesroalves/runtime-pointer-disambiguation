#include "ScheduleHeuristic.h"


void ScheduleHeuristic::run() {
  for (auto I = EdgesForScheduling.begin(), E = EdgesForScheduling.end();
      I != E; ++I) {
    Node * Origin = Base.getNodeById((*I)->srcId);
    Node * Destination = Base.getNodeById((*I)->dstId);

    advanceScheduling(Destination, Origin->order);
    delayScheduling(Origin, Destination->order);

    FixedIntervals.addInterval(Origin->order, Destination->order);
  }
}

void ScheduleHeuristic::rotate(int Start, int Stop, bool Forward) {
  if (Start >= Stop)
    return;

  if (Forward) {
    for (int I = Stop; I > Start; --I)
      Base.permuteNodes(I, I - 1);
  } else {
    for (int I = Start; I < Stop; ++I)
      Base.permuteNodes(I, I + 1);
  }
}


int ScheduleHeuristic::getAdvancedOrder(int Target) {
  IntervalTreeNode * Interval;

  if ((Interval = FixedIntervals.checkInclusion(Target + 1)))
    return Interval->Ceiling + 1;
  else
    return Target + 1;
}


int ScheduleHeuristic::getDelayedOrder(int Target) {
  IntervalTreeNode * Interval;

  if ((Interval = FixedIntervals.checkInclusion(Target - 1)))
    return Interval->Floor - 1;
  else
    return Target - 1;
}


int ScheduleHeuristic::getLatestParent(Node * Origin) {
  int Latest = -1, Order;

  for (auto I = Origin->inEdgeAr.begin(), E = Origin->inEdgeAr.end(); I != E;
      ++I) {
    Order = Base.getNodeById((*I)->srcId)->order;
    if (Order > Latest)
      Latest = Order;
  }

  return Latest;
}


int ScheduleHeuristic::getEarliestChild(Node * Origin) {
  int Earliest = Base.getNodesInLoop(), Order;

  for (auto I = Origin->outEdgeAr.begin(), E = Origin->outEdgeAr.end(); I != E;
      ++I) {
    Order = Base.getNodeById((*I)->dstId)->order;
    if (Order < Earliest)
      Earliest = Order;
  }

  return Earliest;
}


void ScheduleHeuristic::advanceScheduling(Node * Source, int Target) {
  if (Target >= Source->order)
    return;

  if (FixedIntervals.checkInclusion(Source->order))
    return;

  for (auto I = Source->inEdgeAr.begin(), E = Source->inEdgeAr.end(); I != E;
      ++I)
    advanceScheduling(Base.getNodeById((*I)->srcId), Target);

  rotate(getAdvancedOrder(getLatestParent(Source)), Source->order, true);
}


void ScheduleHeuristic::delayScheduling(Node * Source, int Target) {
  if (Target <= Source->order)
    return;

  if (FixedIntervals.checkInclusion(Source->order))
    return;

  for (auto I = Source->outEdgeAr.begin(), E = Source->outEdgeAr.end(); I != E;
      ++I)
    delayScheduling(Base.getNodeById((*I)->dstId), Target);

  rotate(getDelayedOrder(getEarliestChild(Source)), Source->order, false);
}
