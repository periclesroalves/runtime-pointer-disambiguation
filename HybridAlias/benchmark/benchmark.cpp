/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include <benchmark/benchmark.h>

int main(int argc, const char **argv, const char **envp) {
	// put some pressure on the shadow-malloc
	for (int i = 0; i < 5000; i++) {
		for (int j = 0; j < 100; j++)
			malloc(i);
	}

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
