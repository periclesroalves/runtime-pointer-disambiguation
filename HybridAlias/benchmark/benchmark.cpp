
#include <benchmark/benchmark.h>

int main(int argc, const char **argv, const char **envp) {
	// put some pressure on the shadow-malloc
	for (int i = 0; i < 5000; i++) {
		for (int j = 0; j < 100; j++)
			malloc(i);
	}

	benchmark::Initialize(&argc, argv);
	benchmark::RunSpecifiedBenchmarks();

	return 0;
}
