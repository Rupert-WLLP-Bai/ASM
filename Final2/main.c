#include <stddef.h>
#include <stdio.h>

extern double sum(double[], long);
extern long add_long(long a, long b);
extern size_t strlen(const char *s);
extern char *strcpy(char *dest, const char *src);
extern char *strncpy(char *dest, const char *src, size_t n);

void add_long_test() {
  long a = 1;
  long b = 2;
  long c = add_long(a, b);
  printf("add_long(%ld, %ld) = %ld\n", a, b, c);
}

void double_sum_test() {
  double d[] = {1.0, 2.0, 3.0};
  double e = sum(d, 3);
  printf("sum([1.0, 2.0, 3.0], 3) = %f\n", e);
}

void strlen_test() {
  char *s = "Hello, world!";
  size_t len = strlen(s);
  printf("strlen(\"%s\") = %ld\n", s, len);
}

void strcpy_test() {
  char *s = "Hello, world!";
  char buf[100];
  strcpy(buf, s);
  printf("strcpy(\"%s\") = \"%s\"\n", s, buf);
}

void strncpy_test() {
  char *s = "Hello, world!";
  char buf[100];
  strncpy(buf, s, 5);
  printf("strncpy(\"%s\") = \"%s\"\n", s, buf);
}

int main() {
  add_long_test();
  double_sum_test();
  strlen_test();
  strcpy_test();
  strncpy_test();
  return 0;
}