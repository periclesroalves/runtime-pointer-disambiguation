#include <stdio.h>
#include <algorithm>

void foo (int *A, int *B, int n) {
  for (int i = 0; i < n; i++) {
    A[i] = B[3];
  }
}

int main () {
  int A[100], B[100];

  foo (A, B, 100); 

  printf ("%d\n", A[5]);
}
