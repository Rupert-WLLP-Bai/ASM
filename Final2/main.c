// @File: main.c

#include <stdio.h>

extern long add(long a, long b);

int main() {
  printf("%ld\n", add(5, 7));
  return 0;
}