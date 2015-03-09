/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include "alias_profiler.h"
#include "misc.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <limits.h>

static size_t sampling_rate;
static FILE*  trace_file;

// TODO: pass all alias pairs for a loop in at once
void gcg_trace_alias_pair(
  const char *loop,
  const char *name1, void *ptr1,
  const char *name2, void *ptr2
) {
  static size_t sample_count = SIZE_MAX;

  if (sample_count < sampling_rate)
  {
    sample_count++;
    return;
  }

  sample_count = 0;

  ASSERT0(trace_file, "gcg_trace_alias_pair called before init_alias_tracer");

  fprintf(trace_file, "LOOP '%s' - '%s' vs '%s' - ", loop, name1, name2);

  if (ptr1 == ptr2) {
    fprintf(trace_file, "EXACT_ALIAS\n");
  } else if (gcg_getBasePtr(ptr1) == gcg_getBasePtr(ptr2)) {
    fprintf(trace_file, "ALIAS\n");
  } else {
    fprintf(trace_file, "NOALIAS\n");
  }
}

static inline FILE *init_trace_file()
{
  const char *path;

  const char* env_path = getenv("TRACE_FILE");
  if (env_path)
    path = env_path;
  else
    path = "alias.trace";

  FILE *file = fopen(path, "w");

  if (!file)
    _error(1, "Could not open trace file '%s'", path);

  return file;
}

static inline size_t init_sampling_rate()
{
  size_t rate = 1;

  const char* env_rate = getenv("SAMPLING_RATE");
  if (env_rate)
  {
    char *endptr;
    errno = 0;
    long val = strtol(env_rate, &endptr, 10);

    // Check for various possible errors

    if ((errno == ERANGE && (val == LONG_MAX || val == LONG_MIN)) || (errno != 0 && val == 0))
      _error(1, "Error parsing SAMPLING_RATE");

    if (endptr == env_rate)
      _error(1, "Error parsing SAMPLING_RATE: No digits were found\n");

    // If we got here, strtol() successfully parsed a number

    if (*endptr != '\0')
      _error(1, "Error parsing SAMPLING_RATE: Characters after number: %s\n", endptr);

    if (val < 0)
      _error(1, "SAMPLING_RATE must be a positive number\n");

    rate = val;
  }

  return rate;
}

/// static initializer for all global data structures
__attribute__((constructor))
static void init_alias_tracer()
{
  trace_file    = init_trace_file();
  sampling_rate = init_sampling_rate();
}
