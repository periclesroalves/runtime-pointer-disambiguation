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

enum memtrackAliasType {
	MEMTRACK_NO_HEAP_ALIAS  = 1,
	MEMTRACK_NO_RANGE_ALIAS = 2,
	MEMTRACK_EXACT_ALIAS    = 3,
	MEMTRACK_END
};

typedef enum memtrackAliasType memtrackAliasType;

// Logs alias behaviour of two pointers
void memtrack_traceAlias(
	const char *function, // name of function pointers live in
	const char *ptr1,     // name of first pointer
	const char *ptr2,     // name of second pointer
	uint8_t alias,        // 0 iff the alias check failed
	uint8_t alias_type    // what kind of alias check was done
	                      // (see memtrackAliasType)
);

#ifdef __cplusplus
} // end extern "C"
#endif

#endif // end _GCG_ALIAS_TRACING_HPP
