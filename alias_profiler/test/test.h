
#pragma once

#include <stdlib.h>

#define BLACKHOLE(...) blackhole(0, __VA_ARGS__)

#define CHECK(EXPR, FMT, ...) \
  ((EXPR) ? ((void) 0) \
          : test_error(1, "FAIL: " #EXPR ": " FMT, __VA_ARGS__))
#define CHECK0(EXPR, MSG) \
  ((EXPR) ? ((void) 0) \
          : test_error(1, "FAIL: " #EXPR ": " MSG))

#define CHECKED_ALLOC(TYPE, DST, ALLOCATION)     \
	TYPE  DST        = (ALLOCATION);             \
	void* DST ## _id = gcg_getBasePtr(DST);      \
	CHECK0((DST),        #ALLOCATION "failed");  \
	CHECK0((DST ## _id), "allocation was not registered");

#ifdef __cplusplus
extern "C" {
#endif

void blackhole(int dummy, ...);

/// Prints message to stdout and exits with exit_status
void test_error(int exit_status, const char *msg, ...);

#ifdef __cplusplus
} // end extern "C"
#endif
