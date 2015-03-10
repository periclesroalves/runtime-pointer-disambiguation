/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include "memtrack.h"
#include "misc.h"

#include <dlfcn.h>

#include <errno.h>
#include <limits.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>
#include <malloc.h>
#include <inttypes.h>
#include <limits.h>

#include "rb_tree.inc"

/// globals

static rb_tree tree;

static void *startup_malloc(size_t);
static void *startup_calloc(size_t,size_t);
static void *startup_realloc(void*,size_t);
static void *startup_memalign(size_t, size_t);
static int   startup_posix_memalign(void**, size_t, size_t);
static void  startup_free(void*);

/// ** the allocators everyone knows
static void *(*libc_malloc)(size_t)           = startup_malloc;
static void *(*libc_calloc)(size_t,size_t)    = startup_calloc;
static void *(*libc_realloc)(void*,size_t)    = startup_realloc;
static void  (*libc_free)(void*)              = startup_free;
/// ** aligned allocators
static void *(*libc_memalign)(size_t, size_t)                      = startup_memalign;
static int   (*libc_posix_memalign)(void **memptr, size_t, size_t) = startup_posix_memalign;
static void *(*libc_aligned_alloc)(size_t, size_t)                 = startup_memalign;

/// helpers

static inline void*    insert_allocation(rb_node *node, rb_size_and_alignment info);
static inline rb_node* remove_allocation(void *ptr);
static inline size_t   div_round_up(size_t a, size_t b);
static inline size_t   alignment_encode(size_t alignment);
static inline size_t   alignment_decode(size_t alignment);
static inline void aligned_header_size(
  size_t alignment, size_t size,
  size_t* actual_alignment, size_t* actual_size,
  rb_size_and_alignment* info,
  size_t* rb_node_offset
);


//******************************************************************************
// public API

void *gcg_getBasePtr(void *address) {
  return rb_find_chunk(&tree, address);
}

static void print_node(rb_node *node, unsigned indent) {
  for (unsigned i = indent; i; i--)
    printf("  ");

  printf("* ");

  if (node) {
    printf("%p - %p (%s)\n",
      rb_chunk_begin(node),
      rb_chunk_end(node),
      rb_is_red(node) ? "RED" : "BLACK"
    );

    print_node(node->left,  indent + 1);
    print_node(node->right, indent + 1);
  } else {
    printf("null\n");
  }
}

void gcg_print_tree() {
  print_node(tree.root, 0);
}


//******************************************************************************
// lazily load actual allocation functions

static inline void loadFunction(void **dst, const char *name) {
  void *sym = dlsym(RTLD_NEXT, name);

  const char *error = dlerror();
  if (error)
    _error(EXIT_FAILURE, "%s", error);

  *dst = sym;
}

/// is a `constructor' to make sure we are initialized before entering `main'
__attribute__((constructor))
static void init_memtrack()
{
  if (libc_calloc != startup_calloc) {
    ASSERT0(
      (libc_malloc   != startup_malloc)   &&
      (libc_realloc  != startup_realloc)  &&
      (libc_memalign != startup_memalign) &&
      (libc_free     != startup_free)     &&
      1,
      "Error in initializization of memory tracker"
    );
    return;
  }

  /// load libc `malloc' etc.

  loadFunction((void**) &libc_malloc,         "malloc");
  loadFunction((void**) &libc_calloc,         "calloc");
  loadFunction((void**) &libc_realloc,        "realloc");
  loadFunction((void**) &libc_memalign,       "memalign");
  loadFunction((void**) &libc_posix_memalign, "posix_memalign");
  loadFunction((void**) &libc_aligned_alloc,  "aligned_alloc");
  loadFunction((void**) &libc_free,           "free");
}

//******************************************************************************
//***** IMPLEMENTATION OF `malloc', etc. that is picked up by dlsym

void* memtrack_malloc(size_t size) {
  // printf("malloc(%zu, %zu)\n", nmemb, size);

  // TODO: handle overflow
  size_t actual_size = size + sizeof(rb_node);

  rb_node* node = libc_malloc(actual_size);
  if (!node)
    return 0;

  rb_size_and_alignment info = { .alignment = 0, .size = size };

  return insert_allocation(node, info);
}

void* memtrack_calloc(size_t nmemb, size_t size) {
  // printf("calloc(%zu, %zu)\n", nmemb, size);

  // TODO: handle overflow
  size_t requested_size = nmemb * size;
  size_t actual_size    = requested_size + sizeof(rb_node);

  /// be conservative ask for memory that will be 16byte aligned.
  size_t new_nmemb = div_round_up(actual_size, 16);

  rb_node* node = libc_calloc(new_nmemb, 16);
  if (!node)
    return 0;

  rb_size_and_alignment info = { .alignment = 0, .size = size };

  return insert_allocation(node, info);
}

void* memtrack_realloc(void *ptr, size_t size) {
  // printf("realloc(%p, %zu)\n", ptr, size);

  if (!ptr)
    return malloc(size);

  size_t actual_size = size + sizeof(rb_node);

  /// for glibc and most other allocators we could assume that if realloc
  /// shrinks the allocation the node is preserved and we wouldn't have to
  /// remove+insert.
  /// Unfortunately that is unsafe in general.
  rb_node *old_node = remove_allocation(ptr);
  rb_node *new_node = libc_realloc(old_node, actual_size);
  if (!new_node)
    return 0;

  rb_size_and_alignment info = { .alignment = 0, .size = size };

  return insert_allocation(new_node, info);
}

void *memtrack_memalign(size_t alignment, size_t size) {
  // printf("memalign(%zu, %zu)\n", alignment, size);

  size_t actual_alignment;
  size_t actual_size;
  rb_size_and_alignment info;
  size_t rb_node_offset;

  aligned_header_size(alignment, size, &actual_alignment, &actual_size, &info, &rb_node_offset);

  char *base = libc_memalign(actual_alignment, actual_size);
  if (!base)
    return 0;

  rb_node *node = (rb_node*) (base + rb_node_offset);
  void*    ptr  = insert_allocation(node, info);

  ASSERT0((alignment == 0) || ((((uintptr_t) ptr) % alignment) == 0),
    "memalign wrapper produced wrong alignment");

  return ptr;
}

int memtrack_posix_memalign(void **memptr, size_t alignment, size_t size) {
  // printf("posix_memalign(%p, %zu, %zu)\n", memptr, alignment, size);

  size_t actual_alignment;
  size_t actual_size;
  rb_size_and_alignment info;
  size_t rb_node_offset;

  aligned_header_size(alignment, size, &actual_alignment, &actual_size, &info, &rb_node_offset);

  void *base;
  int err = libc_posix_memalign(&base, actual_alignment, actual_size);
  if (err != 0)
    return err;

  rb_node* node = (rb_node*) (((char*) base) + rb_node_offset);
  void*    ptr  = insert_allocation(node, info);

  ASSERT0((alignment == 0) || ((((uintptr_t) ptr) % alignment) == 0),
    "posix_memalign wrapper produced wrong alignment");

  *memptr = ptr;
  return 0;
}

void *memtrack_aligned_alloc(size_t alignment, size_t size) {
  // printf("aligned_alloc(%zu, %zu)\n", alignment, size);

  size_t actual_alignment;
  size_t actual_size;
  rb_size_and_alignment info;
  size_t rb_node_offset;

  aligned_header_size(alignment, size, &actual_alignment, &actual_size, &info, &rb_node_offset);

  char*    base = libc_aligned_alloc(actual_alignment, actual_size);
  rb_node* node = (rb_node*) (base + rb_node_offset);
  void*    ptr  = insert_allocation(node, info);

  ASSERT0((alignment == 0) || ((((uintptr_t) ptr) % alignment) == 0),
    "aligned_alloc wrapper produced wrong alignment");

  return ptr;
}

void memtrack_free(void *ptr) {
  if (!ptr)
    return;

  /// get rb node from ptr
  rb_node *node = remove_allocation(ptr);

  /// get real base ptr of allocation
  size_t chunk_alignment = node->chunk_info.alignment;

  void* base;

  if (!chunk_alignment) {
    base = node;
  } else {
    size_t actual_alignment;
    size_t actual_size;
    rb_size_and_alignment info;
    size_t rb_node_offset;

    aligned_header_size(alignment_decode(chunk_alignment), 0, &actual_alignment, &actual_size, &info, &rb_node_offset);
    base = ((char*) node) - rb_node_offset;
  }

  libc_free(base);
}

// TODO:

void *memtrack_valloc(size_t size) {
  _error(1, "TODO: wrap valloc");
  return 0;
}
void *memtrack_pvalloc(size_t size) {
  _error(1, "TODO: wrap pvalloc");
  return 0;
}


//******************************************************************************
//***** WRAPPERS AROUND `malloc', `free', etc.

void* malloc(size_t size) {
  return memtrack_malloc(size);
}

void* calloc(size_t nmemb, size_t size) {
  return memtrack_calloc(nmemb, size);
}

void* realloc(void *ptr, size_t size) {
  return memtrack_realloc(ptr, size);
}

void *memalign(size_t alignment, size_t size) {
  return memtrack_memalign(alignment, size);
}

int posix_memalign(void **memptr, size_t alignment, size_t size) {
  return memtrack_posix_memalign(memptr, alignment, size);
}

void *aligned_alloc(size_t alignment, size_t size) {
  return memtrack_aligned_alloc(alignment, size);
}

void free(void *ptr) {
  memtrack_free(ptr);
}

// TODO:

void *valloc(size_t size) {
  return memtrack_valloc(size);
}
void *pvalloc(size_t size) {
  return memtrack_pvalloc(size);
}

//******************************************************************************
//***** VERSIONS OF `malloc', `free', etc. USED AT STARTUP

/// functions for lazy initialization our internal data structures
/// These only get called if someone uses malloc, etc., before `main' is
/// entered.

static void* startup_malloc(size_t size) {
  init_memtrack();
  ASSERT0(libc_malloc != startup_malloc, "");

  return libc_malloc(size);
}

static void* startup_realloc(void *ptr, size_t size) {
  init_memtrack();
  ASSERT0(libc_calloc != startup_calloc, "");

  return libc_realloc(ptr, size);
}

static void* startup_memalign(size_t alignment, size_t size) {
  init_memtrack();
  ASSERT0(libc_memalign != startup_memalign, "");

  return libc_memalign(alignment, size);
}

static int startup_posix_memalign(void **memptr, size_t alignment, size_t size) {
  init_memtrack();
  ASSERT0(libc_posix_memalign != startup_posix_memalign, "");

  return libc_posix_memalign(memptr, alignment, size);
}

static void startup_free(void *ptr) {
  init_memtrack();
  ASSERT0(libc_free != startup_free, "");

  // libc_free(ptr);
  _error(1, "startup free was called");
}

/// the startup versions of is different since on linux dlsym calls calloc.
/// This means calloc get called while actually looking up the underlying
/// libc calloc implementation.
/// At least glibc's dlsym implementation uses a static buffer if our calloc
/// fails
/// see: https://sourceware.org/ml/libc-help/2008-11/msg00000.html
/// and: https://code.google.com/p/chromium/issues/detail?id=28244

static void* startup_calloc(size_t nmemb, size_t size) {
  errno = ENOMEM;
  return 0;
}

//******************************************************************************
//***** HELPERS

static inline void* insert_allocation(rb_node *node, rb_size_and_alignment info) {
  ASSERT0(node, "nullptr in insert_allocation");

  void *ptr = rb_chunk_begin(node);

  node->chunk_info = info;

  rb_insert(&tree, node);

  return ptr;
}

static inline rb_node* remove_allocation(void *ptr) {
  ASSERT0(ptr, "null ptr in remove_allocation");

  rb_node *node = rb_from_ptr(ptr);

  rb_remove(&tree, node);

  return node;
}


/// Divide a by b, result is rounded up instead of down
static inline size_t div_round_up(size_t a, size_t b) {
  // TODO: handle overflow
  return (a + (b - 1)) / b;
}

/// Compute size of additional header that must be allocated
/// so that prepending the header does not break alignment requirements.
/// Returns the number of wasted bytes in the header, i.e., the distance between
/// the start of the actual allocation and the start of our rb_node
static inline void aligned_header_size(
  /// in:
  /// size and alignment requested by user
  size_t alignment, size_t size,
  /// out:
  /// size and alignment we will pass on to underlying allocator
  size_t* actual_alignment, size_t* actual_size,
  /// size and alignment we will store in rb_node
  rb_size_and_alignment* info,
  /// distance between base of actual allocation and start of rb_node header
  size_t* rb_node_offset
) {
  if (_Alignof(rb_node) >= alignment) {
    info->alignment = 0;
    alignment       = _Alignof(rb_node);
  } else {
    info->alignment = alignment_encode(alignment);
  }
  info->size = size;

  size_t header_size = alignment * div_round_up(sizeof(rb_node), alignment);

  *actual_alignment = alignment;
  *actual_size      = size + header_size;
   info->size       = size;
  *rb_node_offset   = header_size - sizeof(rb_node);
}

static inline size_t alignment_encode(size_t alignment) {
# define SIZE_T_BITS (sizeof(size_t) * CHAR_BIT)

  // all alignments <= 8 map to zero
  alignment >>= 3;

  if (sizeof(size_t) == sizeof(unsigned))
    return SIZE_T_BITS - 1 - __builtin_clz(alignment | 1);
  else if (sizeof(size_t) == sizeof(unsigned long))
    return SIZE_T_BITS - 1 - __builtin_clzl(alignment | 1);
  else if (sizeof(size_t) == sizeof(unsigned long long))
    return SIZE_T_BITS - 1 - __builtin_clzll(alignment | 1);
  else
    ASSERT0(0, "size_t has unsupported number of bits");
}

static inline size_t alignment_decode(size_t alignment) {
  return 1 << (alignment + 3);
}
