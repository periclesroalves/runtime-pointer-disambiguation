
#ifndef _GCG_ALIAS_TRACING_HPP
#define _GCG_ALIAS_TRACING_HPP 1

#include <cstdint>

extern "C" {

// Checks if two pointers alias
// @return 0 if there is no alias, non-zero otherwise
int32_t gcg_trace_alias_pair(const char *loop, const char *name1, void *ptr1, const char *name2, void *ptr2);

// returns the start of the malloc block for the given address
void *gcg_getBasePtr(void *address);

void memtrack_dumpArrayBounds(const char *region, const char *valueName, void *value, void *lowGuess, void *upGuess);


} // end extern "C"

#endif // end _GCG_ALIAS_TRACING_HPP
