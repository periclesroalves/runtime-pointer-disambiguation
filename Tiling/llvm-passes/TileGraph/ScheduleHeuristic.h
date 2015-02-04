#ifndef SCHEDULE_HEURISTIC_H
#define SCHEDULE_HEURISTIC_H

#include "Graph.h"
#include "IntervalTree.h"

#include <list>

namespace llvm {

class ScheduleHeuristic {
public:
  void run(void);

  ScheduleHeuristic(Graph& G, list<Edge *>& E) :
    Base(G),
    EdgesForScheduling(E)
  {};

private:
  Graph& Base;
  list<Edge *>& EdgesForScheduling;
  IntervalTree FixedIntervals;

  void rotate(int Start, int Stop, bool Forward);
  int getAdvancedOrder(int Target);
  int getDelayedOrder(int Target);
  int getLatestParent(Node * Origin);
  int getEarliestChild(Node * Origin);
  void advanceScheduling(Node * Source, int Target);
  void delayScheduling(Node * Source, int Target);
};

}; // End of namespace llvm

#endif//SCHEDULE_HEURISTIC_H
