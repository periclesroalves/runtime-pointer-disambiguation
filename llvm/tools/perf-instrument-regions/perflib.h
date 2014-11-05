
#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>

struct ProfileData {
	const char *function;
	const char *region;
	size_t      guard_sample_count;  // how often the guard was executed
	size_t      guard_cycle_count;   // how much time was spent in the guard
	size_t      region_sample_count; // how often the region was executed
	size_t      region_cycle_count;  // how much time was spent in the region
};

void perf_printSummary(const char *module, size_t num, ProfileData *data);

#ifdef __cplusplus
} // end extern "C"
#endif
