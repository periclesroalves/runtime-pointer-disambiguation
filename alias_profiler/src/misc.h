
#ifndef ALIAS_PROFILER_MISC_HPP
#define ALIAS_PROFILER_MISC_HPP 1

#ifdef __cplusplus
extern "C" {
#endif

/// we can't use libc's assert since that calls malloc
#ifdef NDEBUG
# define ASSERT(EXPR, FMT, ...) ((void) 0)
# define ASSERT0(EXPR, MSG)     ((void) 0)
#else
# define ASSERT(EXPR, FMT, ...) \
  ((EXPR) ? ((void) 0) \
          : _error(1, "Assertion failure: " #EXPR ": " FMT, __VA_ARGS__))
# define ASSERT0(EXPR, MSG) \
  ((EXPR) ? ((void) 0) \
          : _error(1, "Assertion failure: " #EXPR ": " MSG))
#endif

/// Prints message to stdout and exits with exit_status
void _error(int exit_status, const char *msg, ...);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // ALIAS_PROFILER_MISC_HPP
