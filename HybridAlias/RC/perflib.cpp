
#include "RC/perflib.h"
#include <errno.h>                      // for errno
#include <error.h>                      // for error
#include <stdio.h>                      // for fprintf, asprintf, fopen, etc
#include <map>                          // for map, map<>::mapped_type
#include <string>                       // for string, basic_string
#include <utility>                      // for pair
#include <vector>                       // for vector

// TODO: do it all in plain C
using namespace std;

void perf_printSummary(const char *module, size_t num, ProfilePoint *points) {
	char *path;

	if (asprintf(&path, "%s.cputime", module) == -1)
		error(1, errno, "perflib: Error writing file path buffer");

	printf("opening %s\n", path);

	FILE *file = fopen(path, "w");

	if (!file)
		error(1, errno, "perflib: Could not open perf log file '%s' for writing", path);

	// group by function
	map<string, vector<ProfilePoint>> per_function;

	for (size_t i = 0; i < num; i++)
	{
		ProfilePoint& pp = points[i];

		per_function[pp.function].emplace_back(pp);
	}

	file = stdout;

	// print
	for (auto mapping : per_function)
	{
		fprintf(file, "- \"%s\":\n", mapping.first.c_str());

		for (auto& pp : mapping.second)
		{
			fprintf(file, "    \"%s\": %zu\n", pp.region, pp.cycle_count);
		}
	}
}

