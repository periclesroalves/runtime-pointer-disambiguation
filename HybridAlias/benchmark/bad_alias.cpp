/*
  This file is distributed under the Modified BSD Open Source License.
  See LICENSE.TXT for details.
*/

#include <cstddef>
#include <cstdlib>
#include <algorithm>

#include <benchmark/benchmark.h>
#include <benchmark/macros.h>

#include "bench_util.hpp"

extern "C" __attribute__((noinline))
void AA_badalias(int *A, int *B, int *C, int n) {
  for (int i = 0; i < n; i++) {
    A[i] = i;
    B[i] = A[i+2];
  }

  for (int i = 0; i < n; i++) {
    B[i] = i;
    C[i+8] = B[i+3];
  }
}

void BM_badalias(benchmark::State &state) {
	int  n = state.range_x();
	int *A = bench_calloc<int>(n);
	int *B = bench_calloc<int>(n);
	int *C = bench_calloc<int>(2 * n);

	while (state.KeepRunning()) {
		AA_badalias(A, B, C, n);
	}

	blackhole(A, B, C);
}

BENCHMARK(BM_badalias)->Range(5000, 10000);
