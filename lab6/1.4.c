#include <stdio.h>
#include <stdlib.h>

extern char **environ;

int main(int argc, char *argv[]) {
    char **ptr;
    int a = atoi(argv[1]);
    for (ptr = environ; *ptr != NULL && ptr - environ < a; ptr++) {
        printf("%s\n", *ptr);
    }
    return 0;
}

