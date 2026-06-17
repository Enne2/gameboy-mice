#include <gb/gb.h>
#include <stdio.h>

void main(void) {
    printf("Hello Game Boy!");
    while (1) {
        wait_vbl_done();
    }
}
