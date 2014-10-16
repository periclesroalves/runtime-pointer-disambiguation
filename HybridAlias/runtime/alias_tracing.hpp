
#ifndef _GCG_ALIAS_TRACING_HPP
#define _GCG_ALIAS_TRACING_HPP 1

#include <cstdint>

extern "C" {

/// Checks if two pointers alias
/// @return 0 if there is no alias, non-zero otherwise
/// TODO: pass all alias pairs for a loop in at once
int32_t gcg_trace_alias_pair(const char *loop, const char *name1, void *ptr1, const char *name2, void *ptr2);

void *gcg_getBasePtr(void *);

} // end extern "C"

#endif // end _GCG_ALIAS_TRACING_HPP
