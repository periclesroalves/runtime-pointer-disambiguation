/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include "alias_tracing.hpp"
#include "alloc.h"

#include <stdio.h>
#include <cassert>
#include <cerrno>
#include <cstdio>
#include <map>
#include <error.h>
#include <malloc.h>
#include <limits.h>

using namespace std;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

typedef std::map< void *, void *, std::greater<void *>, BootstrapAllocator< std::pair<void *, void *> > > Map;

static size_t  sampling_rate;
static Map    *lut;
static FILE   *file;

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

	assert(file);

	fprintf(file, "LOOP '%s' - '%s' vs '%s' - ", loop, name1, name2);

	if (ptr1 == ptr2) {
		fprintf(file, "EXACT_ALIAS\n");
	} else if (gcg_getBasePtr(ptr1) == gcg_getBasePtr(ptr2)) {
		fprintf(file, "ALIAS\n");
	} else {
		fprintf(file, "NOALIAS\n");
	}
}

extern "C" void memtrack_dumpArrayBounds(const char *region, const char *valueName, void *value, void *lowGuess, void *upGuess)
{
  auto it = lut->lower_bound(value);

  if(it->first == nullptr)
    error(1, errno, "Could not track value '%s'\n", valueName);

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
  auto chunkA = lut->lower_bound((void*) ptrA);
  auto chunkB = lut->lower_bound((void*) ptrB);

  fprintf(file, "- { "
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
  auto lower_bound = lut->lower_bound(address);

  return ((lower_bound->second >= address) ? lower_bound->first : nullptr);
}


// create a write stream to trace file
static inline FILE *init_tracer()
{
  const char *path;

  if (const char* env_path = getenv("TRACE_FILE"))
    path = env_path;
  else
    path = "alias.trace";

  FILE *file = fopen(path, "w");

  if(file == nullptr)
    error(1, errno, "Could not open trace file '%s'", path);

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
      error(1, errno, "Error parsing SAMPLING_RATE");

    if (endptr == env_rate) {
      fprintf(stderr, "Error parsing SAMPLING_RATE: No digits were found\n");
      exit(EXIT_FAILURE);
    }

    // If we got here, strtol() successfully parsed a number

    if (*endptr != '\0') {
      fprintf(stderr, "Error parsing SAMPLING_RATE: Characters after number: %s\n", endptr);
      exit(EXIT_FAILURE);
    }

    rate = val;
  }

  return rate;
}

__attribute__((constructor))
static void init_alias_tracer()
{
	if (file)
		return;

	file          = init_tracer();
	sampling_rate = init_sampling_rate();
}

// Prototypes for our hooks.
static void  my_init_hook  (void);
static void *my_malloc_hook(size_t, const void *);
static void *my_memalign_hook(size_t, size_t, const void *);
static void  my_free_hook  (void*, const void *);

// Override initializing hook from the C library.
void   (* volatile __malloc_initialize_hook) (void) = my_init_hook;
void * (*          old_malloc_hook)          (size_t, const void *);
void * (* volatile old_memalign_hook)        (size_t, size_t, const void *);
void   (*          old_free_hook)            (void*, const void *);

static inline void save_old_hooks()
{
	old_malloc_hook   = __malloc_hook;
	old_memalign_hook = __memalign_hook;
	old_free_hook     = __free_hook;
}
static inline void restore_old_hooks()
{
	__malloc_hook   = old_malloc_hook;
	__memalign_hook = old_memalign_hook;
	__free_hook     = old_free_hook;
}
static inline void restore_our_own_hooks()
{
	__malloc_hook   = my_malloc_hook;
	__memalign_hook = my_memalign_hook;
	__free_hook     = my_free_hook;
}

static void __attribute__((deprecated)) my_init_hook (void)
{
  // allocate map
  lut = new Map();

  // set file
  if (!file)
	  file = init_tracer();

  save_old_hooks();
  restore_our_own_hooks();
}

static void * __attribute__((deprecated)) my_malloc_hook(size_t size, const void *caller)
{
  void *ptr;

  restore_old_hooks();

  // printf("malloc %zu\n", size);

  /* Call recursively */
  ptr = malloc(size);

  save_old_hooks();

  /* Save address mapping for allocated region */
  lut->insert(pair<void*,void*>(ptr, reinterpret_cast<void *>(reinterpret_cast<char *>(ptr) + size)));

  restore_our_own_hooks();

  return ptr;
}

static void * __attribute__((deprecated)) my_memalign_hook(size_t alignment, size_t size, const void *caller)
{
  void *ptr;

  restore_old_hooks();

  // printf("memalign %zu\n", size);

  /* Call recursively */
  ptr = memalign(alignment, size);

  save_old_hooks();

  /* Save address mapping for allocated region */
  lut->insert(pair<void*,void*>(ptr, reinterpret_cast<void *>(reinterpret_cast<char *>(ptr) + size)));

  restore_our_own_hooks();

  return ptr;
}

static void __attribute__((deprecated)) my_free_hook(void *ptr, const void *caller)
{
  if(ptr == nullptr) return;

  restore_old_hooks();

  /* Call recursively */
  free(ptr);

  save_old_hooks();

  /* Delete address mapping for freed region */
  lut->erase(ptr);

  restore_our_own_hooks();
}
#pragma GCC diagnostic pop

