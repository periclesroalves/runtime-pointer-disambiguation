#include <stdio.h>
#include <algorithm>

void foo (int *__restrict__ A, int *__restrict__ B) {
  for (int i = (int)__builtin_fmax(0, 3); i < 100; i++) {
    A[i] = i;
    B[i] = A[i];
  }
}

int main () {
  int A[100], B[100];

  foo (A, B); 

  printf ("%d\n", B[5]);
}
