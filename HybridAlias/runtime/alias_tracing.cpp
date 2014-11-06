#include "alias_tracing.hpp"
#include "alloc.h"

#include <stdio.h>
#include <cassert>
#include <cerrno>
#include <cstdio>
#include <map>
#include <error.h>
#include <malloc.h>

using namespace std;

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

typedef std::map< void *, void *, std::greater<void *>, BootstrapAllocator< std::pair<void *, void *> > > Map;

static Map  *lut;
static FILE *file;

// TODO: pass all alias pairs for a loop in at once
int32_t gcg_trace_alias_pair(const char *loop, const char *name1, void *ptr1, const char *name2, void *ptr2) 
{
  assert(file);

  int32_t alias = (ptr1 == ptr2) || (gcg_getBasePtr(ptr1) == gcg_getBasePtr(ptr2));

  fprintf(file, "LOOP '%s' - '%s' vs '%s' - %s\n", loop, name1, name2, alias ? "ALIAS" : "NOALIAS");

  // 0 means no-alias
  // 1 means alias
  return alias;
}

extern "C" void memtrack_dumpArrayBounds(const char *region, const char *valueName, void *value, void *lowGuess, void *upGuess)
{
  auto it = lut->lower_bound(value);

  if(it->first == nullptr)
    error(1, errno, "Could not track value '%s'\n", valueName);

  fprintf(stdout, "Region '%s' - Value '%s' :\n- value = %p\n- guess = [ %p , %p ]\n- real  = [ %p , %p ]\n", 
                       region,   valueName,           value,        lowGuess, upGuess,    it->first, it->second);
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
  file = init_tracer();

  save_old_hooks();
  restore_our_own_hooks();
}

static void * __attribute__((deprecated)) my_malloc_hook(size_t size, const void *caller)
{
  void *ptr;

  restore_old_hooks();

  /* Call recursively */
  ptr = malloc(size);

  save_old_hooks();

  /* Save address mapping for allocated region */
  lut->insert(pair<void*,void*>(ptr, reinterpret_cast<void *>(reinterpret_cast<char *>(ptr) + size-1)));

  restore_our_own_hooks();

  return ptr;
}

static void * __attribute__((deprecated)) my_memalign_hook(size_t alignment, size_t size, const void *caller)
{
  void *ptr;

  restore_old_hooks();

  /* Call recursively */
  ptr = memalign(alignment, size);

  save_old_hooks();

  /* Save address mapping for allocated region */
  lut->insert(pair<void*,void*>(ptr, reinterpret_cast<void *>(reinterpret_cast<char *>(ptr) + size-1)));

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

