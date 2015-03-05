#include <stdio.h>

typedef struct {
  int a[100];
  int size;
} S;

void foo(S s) {
  for (int i = 0; i < s.size; i++)
    s.a[i] = 0;
}

int main() {
  S s;
  s.size = 100;

  foo(s);
}
