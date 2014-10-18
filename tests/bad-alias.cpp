#include <stdio.h>
#include <algorithm>

void foo (int *A, int *B, float *C, int n) {
  for (int i = 0; i < n; i++) {
    A[i] = i;
    B[i] = A[i+2];
    C[i+8] = B[i+3];
  }
}

int main () {
  int A[100], B[100];
  float C[200];

  foo (A, B, C, 100); 

  printf ("%d\n", B[5]);
}
