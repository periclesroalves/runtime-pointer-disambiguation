/*
 * interval_tree.hpp
 */

/* Forward declarations */
class IntervalTreeNode;
class IntervalTree;

#ifndef INTERVAL_TREE_HPP
#define INTERVAL_TREE_HPP

#include <cstdlib>


class IntervalTreeNode {
public:
  int Floor;
  int Ceiling;
  IntervalTreeNode * Parent;
  IntervalTreeNode * Low;
  IntervalTreeNode * High;
  IntervalTreeNode * Trash;

  IntervalTreeNode(int F, int C, IntervalTreeNode * P) :
    Floor(F),
    Ceiling(C),
    Parent(P),
    Low(NULL),
    High(NULL),
    Trash(NULL)
  {}

  ~IntervalTreeNode(void) {
    if (Low) {
      delete Low;
      Low = NULL;
    }

    if (High) {
      delete High;
      High = NULL;
    }
  }

  void addInterval(int F, int C);
  void addFloor(int F);
  void addCeiling(int C);
  IntervalTreeNode * checkInclusion(int Value);
  void displaceIntervals(int Start, int Stop, int Offset);

private:
  void fuseNeighbours(void);
};


class IntervalTree {
public:
  int Floor;
  int Ceiling;
  IntervalTreeNode * Root;

  IntervalTree(void) :
    Floor(0),
    Ceiling(0),
    Root(NULL)
  {}

  ~IntervalTree(void) {
    if (Root)
      delete Root;
  }

  void addInterval(int F, int C);
  IntervalTreeNode * checkInclusion(int Value);
  void displaceIntervals(int Start, int Stop, int Offset);
};

#endif // INTERVAL_TREE_HPP
