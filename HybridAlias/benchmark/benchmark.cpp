/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include <benchmark/benchmark.h>
#include <cassert>

// prevent compiler from optimizing away useless malloc calls
extern "C" __attribute__((noinline))
void *xmalloc(size_t size) {
	assert(size);
	void *ptr = malloc(size);
	assert(ptr);
	return ptr;
}

int main(int argc, const char **argv, const char **envp) {
	// put some pressure on the shadow-malloc
	for (int i = 0; i < 5000; i++)
		for (int j = 1; j < 256; j++)
			(void) xmalloc(j);

	int         my_argc   = 3;
	const char *my_argv[] = {
		argv[0],
		"--benchmark_iterations=50000",
		"--benchmark_repetitions=3",
		NULL,
	};

	benchmark::Initialize(&my_argc, my_argv);
	benchmark::RunSpecifiedBenchmarks();

	return 0;
}
