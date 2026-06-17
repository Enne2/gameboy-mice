#include <gb/gb.h>
#include <stdio.h>

#define N_C5  0x706
#define N_E5  0x739
#define N_G5  0x759
#define N_REST 0x000

const uint16_t arp[16] = {
    N_C5, N_REST, N_E5, N_REST, N_G5, N_REST, N_E5, N_REST,
    N_C5, N_REST, N_E5, N_REST, N_G5, N_REST, N_E5, N_REST
};

static uint8_t tick = 0;
static uint8_t frame_counter = 0;

void init_music() {
    NR52_REG = 0x00;
    NR52_REG = 0x80;
    NR50_REG = 0x77;
    NR51_REG = 0xFF;
}

void update_music() {
    if (frame_counter == 0) {
        uint16_t f1 = arp[tick];
        if (f1 == N_REST) {
            NR11_REG = 0x00;
            NR12_REG = 0x00;
            NR13_REG = 0x00;
            NR14_REG = 0x80;
        } else {
            NR10_REG = 0x00; 
            NR11_REG = 0x80; 
            NR12_REG = 0xF2; 
            NR13_REG = (uint8_t)(f1 & 0xFF);
            NR14_REG = 0x80 | ((f1 >> 8) & 0x07);
        }
        
        tick++;
        if (tick >= 16) tick = 0;
        
        frame_counter = 15; // Lento
    } else {
        frame_counter--;
    }
}

void main() {
    printf("   AUDIO TEST 2\n\n");
    printf(" Tracker Test in Esecuzione...\n");
    
    init_music();
    
    while(1) {
        update_music();
        wait_vbl_done();
    }
}
