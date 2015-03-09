
#include "misc.h"
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void _error(int exit_status, const char *msg, ...) {
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
