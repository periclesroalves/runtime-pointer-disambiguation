
#include <cstddef>

#include <benchmark/benchmark.h>
#include <benchmark/macros.h>

#include "bench_util.hpp"

extern "C" __attribute__((noinline)) int AA_dotprod(short a[],short b[], int N)
{
  int sum;
  int i;

  sum = 0;
  for(i=0; i<N; i++){
    sum += (a[i] * b[i]);
  }

  return(sum);
}

static void BM_dotprod(benchmark::State &state) {
	size_t  n    = 1 * 2048;
	short  *vec1 = bench_calloc<short>(n);
	short  *vec2 = bench_calloc<short>(n);

	int sum = 0;

	while (state.KeepRunning()) {
		sum += AA_dotprod(vec1, vec2, n);
	}

	blackhole(vec1);
	blackhole(vec2);
	blackhole(sum);
}

BENCHMARK(BM_dotprod);
