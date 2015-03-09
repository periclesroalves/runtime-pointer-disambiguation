
#include <stdint.h>
#include <stddef.h>
#include <limits.h>

enum rb_color {
	RB_BLACK = 0,
	RB_RED   = 1,
};

typedef struct rb_tree               rb_tree;
typedef struct rb_node               rb_node;
typedef struct rb_size_and_alignment rb_size_and_alignment;
typedef enum   rb_color              rb_color;

struct rb_size_and_alignment {
	/// 1 byte to store alignment of wrapped allocation
	size_t alignment : CHAR_BIT;
	/// 7 bytes to store size of wrapped allocation
	size_t size      : (sizeof(size_t) - 1) * CHAR_BIT;
};

struct rb_node {
	rb_node *left;
	rb_node *right;
	union {
		rb_node  *parent;
		uintptr_t color;
	};
	rb_size_and_alignment chunk_info;
	char  data[0];
};

_Static_assert(sizeof(rb_node) == (4 * sizeof(uintptr_t)), "rb_node has wrong size");
_Static_assert(_Alignof(rb_node) >= 8, "rb_node has wrong alignment");

struct rb_tree {
	rb_node *root;
};

///*****************************************************************************
/// Getters/Setters

/// parent

static inline rb_node *rb_get_parent(const rb_node *node) {
	return (rb_node*) (node->color & ~1UL);
}

static inline void rb_set_parent(rb_node *node, rb_node *parent) {
	node->color = ((uintptr_t) parent) | (node->color & 1);
}

static inline _Bool rb_is_root(rb_node *node) {
	return rb_get_parent(node) == NULL;
}

/// children

static inline rb_node *rb_get_left(const rb_node *node) {
	return node->left;
}

static inline rb_node *rb_get_right(const rb_node *node) {
	return node->right;
}

static inline void rb_set_left(rb_node *node, rb_node *child) {
	node->left = child;
}

static inline void rb_set_right(rb_node *node, rb_node *child) {
	node->right = child;
}

static inline void rb_set_child(rb_node *node, rb_node *child, _Bool left) {
	if (left)
		rb_set_left(node, child);
	else
		rb_set_right(node, child);
}

/// color

static inline rb_color rb_get_color(const rb_node *node) {
	return node->color & 1;
}

static inline void rb_set_color(rb_node *node, rb_color color) {
	node->color = (node->color & ~1UL) | color;
}

static inline _Bool rb_is_black(rb_node *node) {
	return rb_get_color(node) == RB_BLACK;
}

static inline _Bool rb_is_red(rb_node *node) {
	return !rb_is_black(node);
}


///*****************************************************************************
/// Tree traversals

static inline rb_node *rb_get_minimum(rb_node *node) {
	while (node->left)
		node = node->left;
	return node;
}


///*****************************************************************************
/// Get node contents

static inline void *rb_chunk_begin(rb_node *node) {
	ASSERT0(node, "null ptr");

	return node->data;
}

static inline void *rb_chunk_end(rb_node *node) {
	return (void*) (((char*)node->data) + node->chunk_info.size);
}

static inline rb_node *rb_from_ptr(void *ptr) {
	ASSERT0(ptr, "null ptr");

	return (rb_node*) (((char*) ptr) - sizeof(rb_node));
}


///*****************************************************************************
/// Rotations used to restore red-black tree properties

static inline void rb_rotate_left(rb_tree *tree, rb_node *node) {
	rb_node *p      = node;
	rb_node *q      = node->right;
	rb_node *parent = rb_get_parent(p);

	ASSERT0(q, "Right child in rb_rotate_left is NULL");

	if (!rb_is_root(p)) {
		if (parent->left == p)
			parent->left = q;
		else
			parent->right = q;
	} else {
		tree->root = q;
	}
	rb_set_parent(q, parent);
	rb_set_parent(p, q);

	p->right = q->left;
	if (p->right)
		rb_set_parent(p->right, p);
	q->left = p;
}

static inline void rb_rotate_right(rb_tree *tree, rb_node *node) {
	rb_node *p      = node;
	rb_node *q      = node->left;
	rb_node *parent = rb_get_parent(p);

	ASSERT0(q, "Left child in rb_rotate_right is NULL");

	if (!rb_is_root(p)) {
		if (parent->left == p)
			parent->left = q;
		else
			parent->right = q;
	} else {
		tree->root = q;
	}
	rb_set_parent(q, parent);
	rb_set_parent(p, q);

	p->left = q->right;
	if (p->left)
		rb_set_parent(p->left, p);
	q->right = p;
}


///*****************************************************************************
/// Public API

static inline void rb_insert(rb_tree *tree, rb_node *new) {
	/// find place where new node should be inserted
	rb_node *parent  = NULL;
	_Bool    is_left = 0;

	{
		rb_node *node = tree->root;

		while (node) {
			ASSERT0(node != new, "Two allocations start at the same address!");

			parent = node;

			if (node >= new) {
				node    = node->left;
				is_left = 1;
			} else {
				node    = node->right;
				is_left = 0;
			}
		}
	}

	/// insert new node into tree

	new->left  = NULL;
	new->right = NULL;
	rb_set_color(new, RB_RED);
	rb_set_parent(new, parent);

	if (parent)
		rb_set_child(parent, new, is_left);
	else
		tree->root = new;

	/// Repair red-black tree properties of the modified tree by
	/// recoloring nodes and performing rotations
	rb_node *node = new;

	while ((parent = rb_get_parent(node)) && rb_is_red(parent)) {
		rb_node *grandpa = rb_get_parent(parent);

		if (parent == grandpa->left) {
			rb_node *uncle = rb_get_right(grandpa);

			if (uncle && rb_is_red(uncle)) {
				rb_set_color(parent,  RB_BLACK);
				rb_set_color(uncle,   RB_BLACK);
				rb_set_color(grandpa, RB_RED);
				node = grandpa;
			} else {
				if (node == parent->right) {
					rb_rotate_left(tree, parent);
					node = parent;
					parent = rb_get_parent(node);
				}
				rb_set_color(parent, RB_BLACK);
				rb_set_color(grandpa, RB_RED);
				rb_rotate_right(tree, grandpa);
			}
		} else {
			rb_node *uncle = grandpa->left;

			if (uncle && rb_is_red(uncle)) {
				rb_set_color(parent,  RB_BLACK);
				rb_set_color(uncle,   RB_BLACK);
				rb_set_color(grandpa, RB_RED);
				node = grandpa;
			} else {
				if (node == parent->left) {
					rb_rotate_right(tree, parent);
					node = parent;
					parent = rb_get_parent(node);
				}
				rb_set_color(parent,  RB_BLACK);
				rb_set_color(grandpa, RB_RED);
				rb_rotate_left(tree, grandpa);
			}
		}
	}
	rb_set_color(tree->root, RB_BLACK);
}

static inline void rb_remove(rb_tree *tree, rb_node *node) {
	ASSERT0(tree->root, "Can't remove node from empty tree");

	rb_node *parent = rb_get_parent(node);
	rb_node *left   = node->left;
	rb_node *right  = node->right;
	rb_node *next;
	rb_color color;

	if (!left)
		next = right;
	else if (!right)
		next = left;
	else
		next = rb_get_minimum(right);

	if (parent)
		rb_set_child(parent, next, parent->left == node);
	else
		tree->root = next;

	if (left && right) {
		color = rb_get_color(next);
		rb_set_color(next, rb_get_color(node));

		next->left = left;
		rb_set_parent(left, next);

		if (next != right) {
			parent = rb_get_parent(next);
			rb_set_parent(next, rb_get_parent(node));

			node         = next->right;
			parent->left = node;

			next->right = right;
			rb_set_parent(right, next);
		} else {
			rb_set_parent(next, parent);
			parent = next;
			node   = next->right;
		}
	} else {
		color = rb_get_color(node);
		node = next;
	}

	/// `node' is now the sole successor's child and `parent' its
	/// new parent (since the successor could have been moved).
	if (node)
		rb_set_parent(node, parent);

	if (color == RB_RED)
		return;
	if (node && rb_is_red(node)) {
		rb_set_color(node, RB_BLACK);
		return;
	}

	rb_node *const root = tree->root;

	do {
		if (node == root)
			break;

		if (node == parent->left) {
			rb_node *sibling = parent->right;

			if (rb_is_red(sibling)) {
				rb_set_color(sibling, RB_BLACK);
				rb_set_color(parent,  RB_RED);
				rb_rotate_left(tree, parent);
				sibling = parent->right;
			}
			if ((!sibling->left  || rb_is_black(sibling->left)) &&
			    (!sibling->right || rb_is_black(sibling->right))) {
				rb_set_color(sibling, RB_RED);
				node = parent;
				parent = rb_get_parent(parent);
				continue;
			}
			if (!sibling->right || rb_is_black(sibling->right)) {
				rb_set_color(sibling->left, RB_BLACK);
				rb_set_color(sibling,       RB_RED);
				rb_rotate_right(tree, sibling);
				sibling = parent->right;
			}
			rb_set_color(sibling,        rb_get_color(parent));
			rb_set_color(parent,         RB_BLACK);
			rb_set_color(sibling->right, RB_BLACK);
			rb_rotate_left(tree, parent);
			node = root;
			break;
		} else {
			/// same as above with left/right switched

			rb_node *sibling = parent->left;

			if (rb_is_red(sibling)) {
				rb_set_color(sibling, RB_BLACK);
				rb_set_color(parent,  RB_RED);
				rb_rotate_right(tree, parent);
				sibling = parent->left;
			}
			if ((!sibling->left  || rb_is_black(sibling->left)) &&
			    (!sibling->right || rb_is_black(sibling->right))) {
				rb_set_color(sibling, RB_RED);
				node = parent;
				parent = rb_get_parent(parent);
				continue;
			}
			if (!sibling->left || rb_is_black(sibling->left)) {
				rb_set_color(sibling->right, RB_BLACK);
				rb_set_color(sibling,        RB_RED);
				rb_rotate_left(tree, sibling);
				sibling = parent->left;
			}
			rb_set_color(sibling,       rb_get_color(parent));
			rb_set_color(parent,        RB_BLACK);
			rb_set_color(sibling->left, RB_BLACK);
			rb_rotate_right(tree, parent);
			node = root;
			break;
		}
	} while (rb_is_black(node));

	if (node)
		rb_set_color(node, RB_BLACK);
}

static inline void* rb_find_chunk(rb_tree *tree, void *key) {
	void *begin = 0;
	void *end   = 0;

	rb_node *node = tree->root;

	while (node) {
		void *chunk_begin = rb_chunk_begin(node);

		if (chunk_begin >= key) {
			begin = chunk_begin;
			end   = rb_chunk_end(node);
			node  = node->left;
		} else {
			node  = node->right;
		}
	}

	return (key < end) ? begin : NULL;
}
