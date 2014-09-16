#include <stdio.h>

void foo (int *A, int *B) {
  for (int i = 0; i < 100; i++) {
    A[i] = i;
    B [i] = A[i];
  }
}

int main () {
  int A[100], B[100];

  foo (A, B);

  printf ("%d\n", B[5]);
}
