#include <stdio.h>

int foo(char *pw, char *in) {
  char i;
  unsigned int differentbits = 0;
  char* pe = pw + 7;
  while (pw != pe) {
    differentbits |= *pw ^ *in;
    pw++;
    in++;
  }
  return 1;
}

int main() {
  foo("something", "s");
}
