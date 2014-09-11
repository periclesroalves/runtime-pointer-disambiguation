#include <stdio.h>

void foo (int *restrict A, int *restrict B, int n) {
  for (int i = 0; i < n; i++) {
    A[i+5] = i;
    B [i] = A[i];
  }
}

int main () {
  int A[100], B[100];

  foo (A, B, 100);

  printf ("%d\n", B[5]);
}
