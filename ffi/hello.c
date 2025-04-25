#include "SWI-Prolog.h"
#include <stdio.h>

static foreign_t pl_hello(term_t t) {
    printf("Hello from C!\n");
    return PL_unify_integer(t, 42);
}

install_t install() {
    PL_register_foreign("hello", 1, pl_hello, 0);
}
