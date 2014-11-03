
#include <cstring>

#include <benchmark/benchmark.h>
#include <benchmark/macros.h>

#include "bench_util.hpp"

extern "C" __attribute__((noinline)) void* AA_memset(void *p, const char *c, int n) {
	char *it = (char*) p, *end = it + n;

	for (; it != end; ++it)
		*it = *c;

	return end;
}

static void BM_bar(benchmark::State& state) {
	char *buf = bench_malloc<char>(512);

	while (state.KeepRunning()) {
		AA_memset((void*) buf, "x", 512);
	}

	blackhole(buf);
}

BENCHMARK(BM_bar);
