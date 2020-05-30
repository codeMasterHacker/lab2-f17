#include "types.h"
#include "user.h"

int main(int argc, char** argv)
{
    int size = 6192;

    if (argc > 1)
        size = 8192;

    char buffer[size];
    memset(buffer, 0, size); 

    exit();
    return 0;
}
