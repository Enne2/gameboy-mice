#include <gb/gb.h>
#include "mockup_gfx.h"

void main(void) {
    DISPLAY_OFF;
    
    // Palette GBDK standard
    BGP_REG = 0b11100100;
    
    // Non sappiamo quanti tile ci sono, ma sono <= 256. Lo script genera la dimensione esatta.
    // Usiamo 256 per coprire tutti i tile
    set_bkg_data(0, 256, MockupTileData);
    
    // Scriviamo direttamente l'intera mappa 20x18
    set_bkg_tiles(0, 0, 20, 18, MockupMapData);
    
    SHOW_BKG;
    DISPLAY_ON;
    
    while(1) {
        wait_vbl_done();
    }
}
