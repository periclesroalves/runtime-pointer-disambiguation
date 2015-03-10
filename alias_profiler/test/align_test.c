
#include "memtrack.h"
#include "test.h"
#include <stdlib.h>
#include <stdint.h>
#include <assert.h>

int main(int argc, char **argv) {
	CHECKED_ALLOC(void*, p0, aligned_alloc(0, 512));
	free(p0);

	size_t alignment = 1;

	// go up to page size
	for (int i = 0; i < 12; i++) {
		CHECKED_ALLOC(void*, p1, aligned_alloc(alignment, alignment * 2));

		CHECK0((((uintptr_t) p1) % alignment) == 0, "memtrack broke alignment requirement");

		free(p1);

		alignment <<= 1;
	}

	return 0;
}
