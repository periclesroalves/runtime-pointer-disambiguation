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


static const char *alias_type_names[] = {
  [MEMTRACK_NO_HEAP_ALIAS]  = "NO_HEAP_ALIAS",
  [MEMTRACK_NO_RANGE_ALIAS] = "NO_RANGE_ALIAS",
  [MEMTRACK_EXACT_ALIAS]    = "EXACT_ALIAS",
};

// TODO: pass all alias pairs for a loop in at once
void memtrack_traceAlias(
  const char *function,
  const char *ptr1,
  const char *ptr2,
  uint8_t alias,
  uint8_t alias_type
) {
  static size_t sample_count = SIZE_MAX;

  if (sample_count < sampling_rate)
  {
    sample_count++;
    return;
  }

  sample_count = 0;

  ASSERT(trace_file, "%s called before init_alias_tracer", __FUNCTION__);

  if (alias_type >= MEMTRACK_END) {
      fprintf(stderr, "Invalid alias behaviour type %u\n", alias_type);
      exit(1);
  }

  const char *alias_str      = alias ? "Y" : "N";
  const char *alias_type_str = alias_type_names[alias_type];

  fprintf(trace_file, "CHECK '%s' - '%s' vs '%s' - %s - %s\n", function, ptr1, ptr2, alias_type_str, alias_str);
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
  size_t rate = 0;

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
