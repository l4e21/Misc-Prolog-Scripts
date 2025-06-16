#include "SWI-Prolog.h"
#include <stdio.h>

static foreign_t pl_hello(term_t t) {
    printf("Hello from C!\n");
    return PL_unify_integer(t, 42);
}

int factorial(int n) {
  if (n > 0) {
    return n*factorial(n-1);
  }
  else {
    return 1;
  };
}

static foreign_t pl_factorial_entry(term_t t_n, term_t t_r) {
  int n;
  if (!PL_get_integer(t_n, &n)) return FALSE;
  printf("Int %d \n", n);
  return PL_unify_integer(t_r, factorial(n));
}

install_t install() {
    PL_register_foreign("hello", 1, pl_hello, 0);
    PL_register_foreign("factorial", 2, pl_factorial_entry, 0);
}
