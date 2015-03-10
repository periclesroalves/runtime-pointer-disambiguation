/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#ifndef _GCG_ALIAS_TRACING_HPP
#define _GCG_ALIAS_TRACING_HPP 1

#include "memtrack.h"
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

// Checks if two pointers alias
// @return 0 if there is no alias, non-zero otherwise
void gcg_trace_alias_pair(
	const char *loop,
	const char *name1, void *ptr1,
	const char *name2, void *ptr2
);

#ifdef __cplusplus
} // end extern "C"
#endif

#endif // end _GCG_ALIAS_TRACING_HPP
