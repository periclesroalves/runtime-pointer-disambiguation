
#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>

struct ProfilePoint {
	const char *function;
	const char *region;
	size_t      cycle_count;
};

void perf_printSummary(const char *module, size_t num, ProfilePoint *points);

#ifdef __cplusplus
} // end extern "C"
#endif
