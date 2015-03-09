
#include "test.h"
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void blackhole(int dummy, ...) {
	// we don't actually use the arguments.
}

void test_error(int exit_status, const char *msg, ...) {
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
