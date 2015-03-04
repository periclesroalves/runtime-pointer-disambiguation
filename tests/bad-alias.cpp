#include <stdio.h>

void foo (int *A, int *B, int *C, int n) {
  for (int i = 0; i < n; i++) {
    A[i] = i;
    B[i] = A[i+2];
    C[i+8] = B[i+3];
  }
}

int main () {
  int A[100], B[100];
  int C[200];

  foo (A, B, C, 100); 

  printf ("%d\n", B[5]);
}
