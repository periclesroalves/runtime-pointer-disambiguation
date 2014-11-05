
#include "perflib.h"
#include <errno.h>                      // for errno
#include <error.h>                      // for error
#include <stdio.h>                      // for fprintf, asprintf, fopen, etc
#include <map>                          // for map, map<>::mapped_type
#include <string>                       // for string, basic_string
#include <utility>                      // for pair
#include <vector>                       // for vector

// TODO: do it all in plain C
using namespace std;

void perf_printSummary(const char *module, size_t num, ProfileData *data) {
	char *path;

	if (asprintf(&path, "%s.cputime", module) == -1)
		error(1, errno, "perflib: Error writing file path buffer");

	printf("opening %s\n", path);

	FILE *file = fopen(path, "w");

	if (!file)
		error(1, errno, "perflib: Could not open perf log file '%s' for writing", path);

	// ** group by function
	map<string, vector<ProfileData>> per_function;

	for (size_t i = 0; i < num; i++)
	{
		ProfileData& pd = data[i];

		per_function[pd.function].push_back(pd);
	}

	file = stdout;

	// ** print
	for (auto mapping : per_function)
	{
		fprintf(file, "- \"%s\":\n", mapping.first.c_str());

		for (auto& pd : mapping.second)
		{
			fprintf(file, "    - region:              %s\n",  pd.region);
			fprintf(file, "      guard_sample_count:  %zu\n", pd.guard_sample_count);
			fprintf(file, "      guard_cycle_count:   %zu\n", pd.guard_cycle_count);
			fprintf(file, "      region_sample_count: %zu\n", pd.region_sample_count);
			fprintf(file, "      region_cycle_count:  %zu\n", pd.region_cycle_count);
		}
	}
}

