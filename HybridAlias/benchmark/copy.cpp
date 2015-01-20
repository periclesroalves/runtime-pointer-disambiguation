/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include <cstddef>

#include <benchmark/benchmark.h>
#include <benchmark/macros.h>

#include "bench_util.hpp"

extern "C" __attribute__((noinline)) void AA_copy(char* a, char* b, char* r, int N) {
	for (int i = 0; i < N; i++) {
		r[i] = a[i];
		if (!b[i])
			r[i] = b[i];
	}
}

static void BM_copy(benchmark::State &state) {
	size_t  N = 10 * 2048;
	char   *a = bench_malloc<char>(N);
	char   *b = bench_malloc<char>(N);
	char   *r = bench_malloc<char>(N);

	while (state.KeepRunning()) {
		AA_copy(a, b, r, N);
	}

	free(a);
	free(b);
	free(r);

	blackhole(a, b, r, N);
}

BENCHMARK(BM_copy);
