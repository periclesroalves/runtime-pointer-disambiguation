/*
 * interval_tree.cpp
 */

#include "IntervalTree.h"

#include <cstdlib>


void IntervalTreeNode::addInterval(int F, int C)
{
  if (F < Floor) {
    if (C < Floor) {
      if (Low) {
        Low->addInterval(F, C);
        if (Trash) {
          delete Trash;
          Trash = NULL;
        }
      } else {
        Low = new IntervalTreeNode(F, C, this);
      }
    } else if (C <= Ceiling) {
      if (Low) {
        Low->addFloor(F);
        if (Trash) {
          delete Trash;
          Trash = NULL;
        }
      } else {
        Floor = F;
      }
    } else {
      Low->addFloor(F);
      if (Trash) {
        delete Trash;
        Trash = NULL;
      }

      High->addCeiling(C);
      if (Trash) {
        delete Trash;
        Trash = NULL;
      }
    }
  } else if (F <= Ceiling) {
    if (C <= Ceiling) {
      /* The interval is already included */
      return;
    } else {
      if (High) {
        High->addCeiling(C);
        if (Trash) {
          delete Trash;
          Trash = NULL;
        }
      } else {
        Ceiling = C;
      }
    }
  } else {
    if (High) {
      High->addInterval(F, C);
      if (Trash) {
        delete Trash;
        Trash = NULL;
      }
    } else {
      High = new IntervalTreeNode(F, C, this);
    }
  }

  /* Don't use this to keep more schedule freedom */
  //fuseNeighbours();
}


void IntervalTreeNode::addFloor(int F)
{
  if (F < Floor) {
    if (Low) {
      /* Register the Low branch as the new Low branch of the Parent */
      Parent->Low = Low;
      Low->Parent = Parent;

      /* Perform an addFloor on the new Low branch of the Parent */
      Low->addFloor(F);
      if (Trash) {
        delete Trash;
        Trash = NULL;
      }

      /* Prevent any mayhem when this instance is deleted */
      Low = NULL;
    } else {
      Parent->Low = NULL;
      Parent->Floor = F;
    }

    /* Set this node for destruction, including the High branch */
    Parent->Trash = this;
  } else if (F <= Ceiling) {
    /* Register the Low branch as the new Low branch of the Parent */
    Parent->Low = Low;
    if (Low)
      Low->Parent = Parent;

    /* Update the Parent's Floor to the Floor of this node */
    Parent->Floor = Floor;

    /* Prevent mayhem when this instance is deleted */
    Low = NULL;

    /* Set this node for destruction, including the High branch */
    Parent->Trash = this;
  } else {
    IntervalTreeNode * SearchNode = this;

    while (true) {
      /* Find the first node that includes or overshoots the inserted Floor */
      while (SearchNode && (SearchNode->Ceiling < F))
        SearchNode = SearchNode->High;

      if (SearchNode) {
        int FloorMemory = SearchNode->Floor;

        /* Register the SearchNode's Low branch as the new High branch
         * of the SearchNode's Parent */
        SearchNode->Parent->High = SearchNode->Low;
        if (SearchNode->Low)
          SearchNode->Low->Parent = SearchNode->Parent;

        /* Prevent any mayhem when this instance is deleted */
        SearchNode->Low = NULL;

        /* Destroy this node via the Parent */
        SearchNode->Parent->Trash = SearchNode;
        SearchNode = SearchNode->Parent;
        delete SearchNode->Trash;
        SearchNode->Trash = NULL;

        /* If the inserted Floor was included then this is the end.
         * Elsewise reStart the process at the SearchNode's Parent */
        if (FloorMemory <= F) {
          Parent->Floor = FloorMemory;
          break;
        }
      } else {
        /* No node to fuse, just enlargen the Parents interval */
        Parent->Floor = F;
        break;
      }
    }
  }
}


void IntervalTreeNode::addCeiling(int C)
{
  if (C > Ceiling) {
    if (High) {
      /* Register the High branch as the new High branch of the Parent */
      Parent->High = High;
      High->Parent = Parent;

      /* Perform an addCeiling on the new High branch of the Parent */
      High->addCeiling(C);
      if (Trash) {
        delete Trash;
        Trash = NULL;
      }

      /* Prevent any mayhem when this instance is deleted */
      High = NULL;
    } else {
      Parent->High = NULL;
      Parent->Ceiling = C;
    }

    /* Set this node for destruction, including the Low branch */
    Parent->Trash = this;
  } else if (C >= Floor) {
    /* Register the High branch as the new High branch of the Parent */
    Parent->High = High;
    if (High)
      High->Parent = Parent;

    /* Update the Parent's Ceiling to the Ceiling of this node */
    Parent->Ceiling = Ceiling;

    /* Prevent mayhem when this instance is deleted */
    High = NULL;

    /* Set this node for destruction, including the Low branch */
    Parent->Trash = this;
  } else {
    IntervalTreeNode * SearchNode = this;

    while (true) {
      /* Find the first node that includes or overshoots the inserted Ceiling */
      while (SearchNode && (SearchNode->Floor > C))
        SearchNode = SearchNode->Low;

      if (SearchNode) {
        int CeilingMemory = SearchNode->Ceiling;

        /* Register the SearchNode's High branch as the new Low branch
         * of the SearchNode's Parent */
        SearchNode->Parent->Low = SearchNode->High;
        if (SearchNode->High)
          SearchNode->High->Parent = SearchNode->Parent;

        /* Prevent any mayhem when this instance is deleted */
        SearchNode->High = NULL;

        /* Destroy this node via the Parent */
        SearchNode->Parent->Trash = SearchNode;
        SearchNode = SearchNode->Parent;
        delete SearchNode->Trash;
        SearchNode->Trash = NULL;

        /* If the inserted Floor was included then this is the end.
         * Elsewise reStart the process at the SearchNode's Parent */
        if (CeilingMemory <= C) {
          Parent->Ceiling = CeilingMemory;
          break;
        }
      } else {
        /* No node to fuse, just enlargen the Parents interval */
        Parent->Ceiling = C;
        break;
      }
    }
  }
}


IntervalTreeNode * IntervalTreeNode::checkInclusion(int Value)
{
  if ((Floor <= Value) && (Value <= Ceiling)) {
    return this;
  } else if (Value < Floor) {
    if (Low)
      return Low->checkInclusion(Value);
    else
      return NULL;
  } else {
    if (High)
      return High->checkInclusion(Value);
    else
      return NULL;
  }
}


void IntervalTreeNode::displaceIntervals(int Start, int Stop, int Offset)
{
  if ((Start <= Floor) && (Ceiling <= Stop)) {
    Floor += Offset;
    Ceiling += Offset;

    if (Low)
      Low->displaceIntervals(Start, Stop, Offset);

    if (High)
      High->displaceIntervals(Start, Stop, Offset);
  } else if (Stop < Floor) {
    if (Low)
      Low->displaceIntervals(Start, Stop, Offset);
  } else if (Start > Ceiling) {
    if (High)
      High->displaceIntervals(Start, Stop, Offset);
  } else {
    exit(EXIT_FAILURE);
  }
}


void IntervalTreeNode::fuseNeighbours()
{
  IntervalTreeNode * SearchNode;

  if (Low) {
    if (Low->Ceiling == Floor - 1) {
      Floor = Low->Floor;

      Trash = Low;
      Low = Low->Low;
      if (Low)
        Low->Parent = this;

      delete Trash;
      Trash = NULL;
    } else {
      SearchNode = Low;

      while (SearchNode->High)
        SearchNode = SearchNode->High;

      if (SearchNode->Ceiling == Floor - 1) {
        Floor = SearchNode->Floor;

        SearchNode->Parent->High = SearchNode->Low;
        if (SearchNode->Low)
          SearchNode->Low->Parent = SearchNode->Parent;

        SearchNode->Low = NULL;

        SearchNode->Parent->Trash = SearchNode;
        SearchNode = SearchNode->Parent;
        delete SearchNode->Trash;
        SearchNode->Trash = NULL;
      }
    }
  }

  if (High) {
    if (High->Floor == Ceiling + 1) {
      Ceiling = High->Ceiling;

      Trash = High;
      High = High->High;
      if (High)
        High->Parent = this;

      delete Trash;
      Trash = NULL;
    } else {
      SearchNode = High;

      while (SearchNode->Low)
        SearchNode = SearchNode->Low;

      if (SearchNode->Floor == Ceiling + 1) {
        Ceiling = SearchNode->Ceiling;

        SearchNode->Parent->Low = SearchNode->High;
        if (SearchNode->High)
          SearchNode->High->Parent = SearchNode->Parent;

        SearchNode->High = NULL;
        
        SearchNode->Parent->Trash = SearchNode;
        SearchNode = SearchNode->Parent;
        delete SearchNode->Trash;
        SearchNode->Trash = NULL;
      }
    }
  }
}


void IntervalTree::addInterval(int F, int C)
{
  if (!Root) {
    Root = new IntervalTreeNode(F, C, NULL);
    Floor = F;
    Ceiling = C;
  } else {
    Root->addInterval(F, C);
    if (F < Floor)
      Floor = F;
    
    if (C > Ceiling)
      Ceiling = C;
  }
}


IntervalTreeNode * IntervalTree::checkInclusion(int Value)
{
  if (Root) {
    if ((Value < Floor) || (Value > Ceiling))
      return NULL;
    else
      return Root->checkInclusion(Value);
  } else {
    return NULL;
  }
}


void IntervalTree::displaceIntervals(int Start, int Stop, int Offset)
{
  if (Root && (Start <= Ceiling) && (Stop >= Floor))
    Root->displaceIntervals(Start, Stop, Offset);
}
