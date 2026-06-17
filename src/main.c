/**
 * @file main.c
 * @brief Entry point e inizializzazione hardware del Game Boy.
 * 
 * Questo modulo funge da collante: inizializza le periferiche video,
 * semina la randomicità per il generatore, invoca l'algoritmo logico e
 * disegna i tile sullo schermo del Game Boy, manipolando i registri hardware.
 */

#include <gb/gb.h>
#include <stdint.h>
#include <rand.h>

#include "maze.h"
#include "tiles.h"

#include "rat.h"
#include "music.h"
#include "cursor.h"

void main(void) {
    uint8_t y, x;
    uint8_t black = 1;
    
    // Attende il termine dell'aggiornamento verticale dello schermo (VBLANK).
    // Caricare dati in VRAM al di fuori di questo periodo può causare tearing o artefatti.
    wait_vbl_done();
    
    // Invia i dati grafici (array TileData) dal banco ROM alla VRAM a partire dall'indice 0.
    set_bkg_data(0, 2, TileData);
    
    // La mappa background in memoria hardware è grande 32x32 tiles.
    // Riempiamo preventivamente tutta quest'area nascosta con il tile Nero (indice 1),
    // utile per mascherare i bordi quando lo schermo verrà "scrollato" successivamente.
    for (y = 0; y < 32; y++) {
        for (x = 0; x < 32; x++) {
            set_bkg_tiles(x, y, 1, 1, &black);
        }
    }
    
    // Inizializza il seme dei numeri casuali.
    initrand(DIV_REG);
    
    // Invoca la funzione logica per popolare l'array `maze` in memoria.
    generate_maze();
    
    // Riversa l'array generato `maze` nella memoria del Background (VRAM Mappa).
    for (y = 0; y < MAZE_HEIGHT; y++) {
        for (x = 0; x < MAZE_WIDTH; x++) {
            set_bkg_tiles(x, y, 1, 1, &maze[y][x]);
        }
    }
    
    // Trucco di centraggio (Hardware Scrolling):
    move_bkg(252, 252);
    
    // Inizializza il topo autonomo nel punto di partenza (1, 1)
    init_rat(1, 1);
    
    // Inizializza il cursore controllato dal giocatore
    init_cursor();
    
    // Inizializza il sequencer musicale
    init_music();
    
    SHOW_BKG;
    SHOW_SPRITES;
    DISPLAY_ON;
    
    // Game Loop primario
    while (1) {
        // Aggiorna la musica in background
        update_music();
        
        // Aggiorna l'intelligenza artificiale e l'animazione del topo
        update_rat();
        
        // Aggiorna l'input del cursore del giocatore
        update_cursor();
        
        // Attendi la sincronizzazione con il monitor
        wait_vbl_done();
    }
}
