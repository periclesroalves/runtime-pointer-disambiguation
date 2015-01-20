/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include "ilc/perflib.h"
#include <assert.h>                     // for assert
#include <string.h>                     // for strdup
#include <errno.h>                      // for errno
#include <error.h>                      // for error
#include <stdio.h>                      // for fprintf, asprintf, fopen, etc
#include <stdlib.h>                     // for getenv

static const char* getPath(const char *module)
{
	errno = 0;

	const char *path;

	if (const char* env_path = getenv("TRACE_FILE")) {
		path = strdup(env_path);

		if (!path)
			error(1, errno, "perflib: Could not get path for trace file");
	} else {
		char *buf;

		if (asprintf(&buf, "%s.cputime", module) == -1)
			error(1, errno, "perflib: Error writing file path buffer");

		path = buf;
	}

	return path;
}

void perf_printSummary(const char *module, size_t num, ProfileData *data) {
	const char *path = getPath(module);

	FILE *file = fopen(path, "w");

	if (!file)
		error(1, errno, "perflib: Could not open perf log file '%s' for writing", path);

	for (size_t i = 0; i < num; i++)
	{
		ProfileData *pd = data + i;

		fprintf(file, "    - function:      %s\n",  pd->function);
		fprintf(file, "      loop:          %s\n",  pd->region);
		fprintf(file, "      sample_count:  %zu\n", pd->sample_count);
		fprintf(file, "      cycle_count:   %zu\n", pd->cycle_count);
	}
}

