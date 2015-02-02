/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include <cstddef>

#include <benchmark/benchmark.h>
#include <benchmark/macros.h>

#include "bench_util.hpp"

extern "C" __attribute__((noinline)) size_t AA_sum(size_t n, size_t *src, size_t *k) {
	size_t sum = 0;

	// #pragma clang loop vectorize(enable) interleave(enable)
	for (size_t i = 0; i < n; i++) {
		sum    += *k + src[i];
		src[i] += *k + src[i];
	}

	// return *sum;
	return sum;
}

static void BM_sum(benchmark::State &state) {
	size_t  n   = state.range_x();
	size_t *src = bench_calloc<size_t>(n);
	size_t *val = bench_calloc<size_t>(1);

	while (state.KeepRunning()) {
		size_t sum = AA_sum(n, src, src);

		assert(sum == 0);
		blackhole(sum);
	}

	blackhole(src);
}


BENCHMARK(BM_sum)->Range(1000, 30000);
