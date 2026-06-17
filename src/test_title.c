#include <gb/gb.h>
#include <stdint.h>
#include "title_bg.h"

void main(void) {
    // Carica il background
    set_bkg_data(0, 256, title_bg_tiles);
    set_bkg_tiles(0, 0, 20, 18, title_bg_map);
    
    // Mostra il background
    SHOW_BKG;
    DISPLAY_ON;
    
    // Palette standard
    BGP_REG = 0b11100100;
    
    while(1) {
        wait_vbl_done();
    }
}
