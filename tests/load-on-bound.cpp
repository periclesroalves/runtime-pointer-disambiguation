#include <stdio.h>

typedef struct {
  int a[10000];
  int b[10000];
  int size;
} S;

void foo(S s) {
  for (int i = 0; i < s.size; i++)
    s.a[i] = i;

  for (int i = 0; i < s.size; i++)
    s.b[i] = i * s.a[i];

  printf("%d", s.b[3]);
}

int main() {
  S s;
  s.size = 10000;

  foo(s);
}
