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
void AA_fft(int n, float z[], float w[], float e[]) {
  int i, j, k, l, m;
  m = n / 2;
  l = 1;

  do {
    k = 0;
    j = l;
    i = 1;
    do {
      do {
        w[i + k] = z[i] + z[m + i];
        w[i + j] = e[k + 1] * (z[i] - z[i + m])
          - e[k + 1] * (z[i] - z[i + m]);
        w[i + j] = e[k + 1] * (z[i] - z[i + m])
          + e[k + 1] * (z[i] - z[i + m]);
        i = i + 1;
      } while (i <= j);
      k = j;
      j = k + l;
    } while (j <= m);
    l++;
  } while (l <= m);
}

float* genVec(unsigned n) {
  float* f = bench_calloc<float>(n);
  int i;
  for (i = 0; i < n; i++) {
    f[i] = 2.5 + i;
  }
  return f;
}

static void BM_fft(benchmark::State &state) {
	int    n = state.range_x();
	float* z = genVec(n);
	float* w = genVec(n);
	float* e = genVec(n);

	while (state.KeepRunning()) {
		AA_fft(n, z, w, e);
	}

	blackhole(z, w, e);
}

BENCHMARK(BM_fft)->Range(2, 128);
