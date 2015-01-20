/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#pragma once

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>

struct ProfileData {
	const char *function;
	const char *region;
	size_t      sample_count; // how often the region was executed
	size_t      cycle_count;  // how much time was spent in the region
};

void perf_printSummary(const char *module, size_t num, ProfileData *data);

#ifdef __cplusplus
} // end extern "C"
#endif
