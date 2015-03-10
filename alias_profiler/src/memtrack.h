/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#ifndef ALIAS_PROFILER_MEMTRACK_HPP
#define ALIAS_PROFILER_MEMTRACK_HPP 1

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>

/// returns the start of the malloc block for the given address
void *gcg_getBasePtr(void *address);

/// prints the tree holding all allocations
void gcg_print_tree();

void *memtrack_malloc(size_t);
void *memtrack_calloc(size_t,size_t);
void *memtrack_realloc(void*,size_t);
void *memtrack_memalign(size_t, size_t);
int   memtrack_posix_memalign(void**, size_t, size_t);
void  memtrack_free(void*);

#ifdef __cplusplus
} // end extern "C"
#endif

#endif // ALIAS_PROFILER_MEMTRACK_HPP
