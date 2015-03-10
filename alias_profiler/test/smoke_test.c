
#include "memtrack.h"
#include "test.h"
#include <stdlib.h>
#include <assert.h>

int main(int argc, char **argv) {
	CHECKED_ALLOC(void*, p1, malloc(64));
	CHECKED_ALLOC(void*, p2, malloc(64));

	CHECK0(p1_id != p2_id, "Two allocations have the same id");

	free(p1);
	free(p2);

	return 0;
}
