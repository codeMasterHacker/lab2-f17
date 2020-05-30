#include "types.h"
#include "user.h"

int main(int argc, char** argv)
{
    //According to lab 3, for now, your trap handler should simply check if the page fault was caused by an access to the page right under the current top of the stack

    int size = 6192; //6192 > 4092(PGSIZE) && 6192 < 8192(2*PGSIZE), ergo the address is to the page right under the current top of the stack

    if (argc > 1)
        size = 8192; //8192 = 4092*2 = PGSIZE*2

    char buffer[size];
    memset(buffer, 0, size); 

    printf(1, "If there is no kernal panic, then the page right under the current top of the stack wass allocated and mapped. SUCCESS!\n");

    exit();
    return 0;
}
