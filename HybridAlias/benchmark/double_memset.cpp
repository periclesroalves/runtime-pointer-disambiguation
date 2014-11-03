
#include <cstddef>

#include <benchmark/benchmark.h>
#include <benchmark/macros.h>

#include "bench_util.hpp"

extern "C" __attribute__((noinline)) void AA_double_memset(size_t n, size_t dstA[n], size_t dstB[n], size_t *src) {
	// can't vectorize because bounds for dstA/dstB aren't statically known
	// the array annotation in their declaration doesn't help

	for (size_t i = 0; i < n; i++) {
		dstA[i] = *src;
		// src has to be loaded again here
		// because the previous write may have altered it
		dstB[i] = *src;
	}
}

static void BM_double_memset(benchmark::State &state) {
	size_t  n    = 2048;
	size_t *dstA = bench_calloc<size_t>(n);
	size_t *dstB = bench_calloc<size_t>(n);
	size_t *val  = bench_calloc<size_t>(1);

	while (state.KeepRunning()) {
		AA_double_memset(n, dstA, dstB, val);
	}

	blackhole(dstA);
	blackhole(dstB);
}


BENCHMARK(BM_double_memset);
