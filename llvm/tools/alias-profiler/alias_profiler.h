/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#ifndef _GCG_ALIAS_TRACING_HPP
#define _GCG_ALIAS_TRACING_HPP 1

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Checks if two pointers alias
void gcg_trace_alias_pair(
	const char *loop,
	const char *ptr1_name, void *ptr1,
	const char *ptr2_name, void *ptr2);

// returns the start of the malloc block for the given address
void *gcg_getBasePtr(void *address);

void gcg_trace_malloc_chunk(const char *loop, const char *ptr_name, void *ptr);

#ifdef __cplusplus
} // end extern "C"
#endif

#endif // end _GCG_ALIAS_TRACING_HPP
