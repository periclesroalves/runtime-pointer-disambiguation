/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include "alias_profiler.h"

#include <map> // the only C++ dependency

#include <dlfcn.h>
#include <errno.h>
#include <limits.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>

/// we can't use libc's assert since that calls malloc
#ifdef NDEBUG
# define ASSERT(EXPR, FMT, ARGS...) static_cast<void>(0)
#else
# define ASSERT(EXPR, FMT, ARGS...) \
  ((EXPR) ? static_cast<void>(0) \
          : _error(1, "Assertion failure: " #EXPR ": " FMT, ## ARGS))
#endif

static void _error(int exit_status, const char *msg, ...);

#include "bootstrap_allocator.hpp"

using Map = std::map<void*, void*, std::greater<void*>, BootstrapAllocator<std::pair<void*,void*>>>;

static size_t  sampling_rate;
static FILE   *trace_file;
static char    lut[sizeof(Map)];

static void *(*libc_malloc)(size_t);
static void *(*libc_memalign)(size_t, size_t);
static void (*libc_free)(void*);

static Map& malloc_table();

// TODO: pass all alias pairs for a loop in at once
void gcg_trace_alias_pair(const char *loop, const char *name1, void *ptr1, const char *name2, void *ptr2) 
{
	static size_t sample_count = SIZE_MAX;

	if (sample_count < sampling_rate)
	{
		sample_count++;
		return;
	}

	sample_count = 0;

	ASSERT(trace_file, "gcg_trace_alias_pair called before init_alias_tracer");

	fprintf(trace_file, "LOOP '%s' - '%s' vs '%s' - ", loop, name1, name2);

	if (ptr1 == ptr2) {
		fprintf(trace_file, "EXACT_ALIAS\n");
	} else if (gcg_getBasePtr(ptr1) == gcg_getBasePtr(ptr2)) {
		fprintf(trace_file, "ALIAS\n");
	} else {
		fprintf(trace_file, "NOALIAS\n");
	}
}

extern "C" void memtrack_dumpArrayBounds(const char *region, const char *valueName, void *value, void *lowGuess, void *upGuess)
{
  auto it = malloc_table().lower_bound(value);

  ASSERT(it->first, "Could not track value '%s'\n", valueName);

  fprintf(stdout, "Region '%s' - Value '%s' :\n- value = %p\n- guess = [ %p , %p ]\n- real  = [ %p , %p ]\n", 
                       region,   valueName,           value,        lowGuess, upGuess,    it->first, it->second);
}

void gcg_trace_array_bounds_check(
	const char *region,
	const char *baseA,
	const void *ptrA,
	const void *guessLoA,
	const void *guessHiA,
	const char *baseB,
	const void *ptrB,
	const void *guessLoB,
	const void *guessHiB,
	int32_t alias
)
{
  auto chunkA = malloc_table().lower_bound((void*) ptrA);
  auto chunkB = malloc_table().lower_bound((void*) ptrB);

  fprintf(trace_file, "- { "
  	"region: \"%s\", "
  	"nameA: \"%s\", "
  	"ptrA: %p, "
  	"guessLoA: %p, "
  	"guessHiA: %p, "
  	"loA: %p, "
  	"hiA: %p, "
  	"nameB: \"%s\", "
  	"ptrB: %p, "
  	"guessLoB: %p, "
  	"guessHiB: %p, "
  	"loB: %p, "
  	"hiB: %p, "
  	"alias: %d"
  	" }\n",
  	region,
  	baseA,
  	ptrA,
  	guessLoA,
  	guessHiA,
  	chunkA->first,
  	chunkA->second,
  	baseB,
  	ptrB,
  	guessLoB,
  	guessHiB,
  	chunkB->first,
  	chunkB->second,
  	alias
  );
}

void *gcg_getBasePtr(void *address)
{
  auto lower_bound = malloc_table().lower_bound(address);

  return ((lower_bound->second >= address) ? lower_bound->first : nullptr);
}


static inline FILE *init_trace_file()
{
  const char *path;

  if (const char* env_path = getenv("TRACE_FILE"))
    path = env_path;
  else
    path = "alias.trace";

  FILE *file = fopen(path, "w");

  if(file == nullptr)
    _error(1, "Could not open trace file '%s'", path);

  return file;
}

static inline size_t init_sampling_rate()
{
  size_t rate = 1;

  if (const char* env_rate = getenv("SAMPLING_RATE"))
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

    rate = val;
  }

  return rate;
}

__attribute__((constructor))
static void init_alias_tracer()
{
  ASSERT(trace_file    == nullptr, "init_alias_tracer called twice");
  ASSERT(sampling_rate == 0,       "init_alias_tracer called twice");

  /// must be done before `malloc', `free', etc., are called

  new (reinterpret_cast<void*>(&lut)) Map();

  libc_malloc   = (void *(*)(size_t))         (void*) dlsym(RTLD_NEXT, "malloc");
  libc_memalign = (void *(*)(size_t, size_t)) (void*) dlsym(RTLD_NEXT, "memalign");
  libc_free     = (void (*)(void*))           (void*) dlsym(RTLD_NEXT, "free");

  /// these call malloc

  trace_file    = init_trace_file();
  sampling_rate = init_sampling_rate();
}

void* malloc(size_t size) {
  ASSERT(libc_malloc, "malloc called before init_alias_tracer");

  void *ptr = libc_malloc(size);

  malloc_table().insert(std::make_pair(ptr, reinterpret_cast<void *>(reinterpret_cast<char *>(ptr) + size)));

  return ptr;
}

void free(void *ptr) {
  ASSERT(libc_free, "free called before init_alias_tracer");
 
  libc_free(ptr);

  malloc_table().erase(ptr);
}

void *memalign(size_t alignment, size_t size) {
  ASSERT(libc_memalign, "memalign called before init_alias_tracer");

  void *ptr = libc_memalign(alignment, size);

  malloc_table().insert(std::make_pair(ptr, reinterpret_cast<void *>(reinterpret_cast<char *>(ptr) + size)));

  return ptr;
}

static void _error(int exit_status, const char *msg, ...) {
  // printf (according to Francois) does not use malloc
  // so we should be fine using it in our custom ASSERT macro

  va_list ap;

  fprintf(stderr, "Error: ");
  va_start(ap, msg);
  vfprintf(stderr, msg, ap);
  va_end(ap);
  if (errno)
    fprintf(stderr, ": %s", strerror(errno));
  fprintf(stderr, "\n");
  exit(exit_status);
}

static Map& malloc_table() {
  return *reinterpret_cast<Map*>(&lut);
}
