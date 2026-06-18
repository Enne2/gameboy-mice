#include <gb/gb.h>
#include <stdio.h>
#include "music.h"

void main() {
    printf("   AUDIO TEST MICE!\n\n");
    printf(" Soundtrack in Loop...\n");
    
    init_music();
    
    while(1) {
        update_music();
        wait_vbl_done();
        
        uint8_t keys = joypad();
        // Optional test logic for SFX could go here if needed.
    }
}
