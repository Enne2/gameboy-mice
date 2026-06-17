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
#include <stdio.h>

#include "maze.h"
#include "tiles.h"
#include "rat_bg.h"

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
    set_bkg_data(0, 5, TileData); // Carichiamo 5 tile: 1 strada + 4 siepi
    
    // Inizializza il seme dei numeri casuali.
    initrand(DIV_REG);
    
    // La mappa background in memoria hardware è grande 32x32 tiles.
    // Riempiamo preventivamente tutta quest'area nascosta con siepi casuali
    for (y = 0; y < 32; y++) {
        for (x = 0; x < 32; x++) {
            uint8_t rand_hedge = 1 + (rand() % 4);
            set_bkg_tiles(x, y, 1, 1, &rand_hedge);
        }
    }
    
    // Invoca la funzione logica per popolare l'array `maze` in memoria.
    generate_maze();
    
    // Riversa l'array generato `maze` nella memoria del Background (VRAM Mappa).
    for (y = 0; y < MAZE_HEIGHT; y++) {
        for (x = 0; x < MAZE_WIDTH; x++) {
            uint8_t tile_idx = maze[y][x];
            if (tile_idx == 1) { // Se è un muro, scegli una siepe variante casuale
                tile_idx = 1 + (rand() % 4);
            }
            set_bkg_tiles(x, y, 1, 1, &tile_idx);
        }
    }
    
    // Trucco di centraggio (Hardware Scrolling):
    move_bkg(252, 252);
    
    // Inizializza i topi autonomi
    init_rats();
    
    // Inizializza il cursore controllato dal giocatore
    init_cursor();
    
    // Inizializza il sequencer musicale
    init_music();
    
    SHOW_BKG;
    SHOW_SPRITES;
    DISPLAY_ON;
    
    // Game Loop primario
    while (1) {
        if (game_over_flag) {
            HIDE_SPRITES;
            move_bkg(0, 0); // Resetta lo scrolling hardware
            
            // Ripristina la palette normale (Nero=3, Bianco=0)
            BGP_REG = 0b11100100;
            
            // Carica i 256 tiles generati dall'immagine completa
            set_bkg_data(0, 256, rat_bg_tiles);
            
            // Disegna la mappa 20x18 a tutto schermo
            set_bkg_tiles(0, 0, 20, 18, rat_bg_map);
            
            // Avvia la tragica sequenza musicale di Game Over
            play_game_over_music();
            
            while(1) {
                update_music();
                wait_vbl_done();
            }
        }
        
        // Aggiorna la musica in background
        update_music();
        
        // Aggiorna l'intelligenza artificiale e l'animazione dei topi
        update_rats();
        
        // Aggiorna l'input del cursore del giocatore
        update_cursor();
        
        // Attendi la sincronizzazione con il monitor
        wait_vbl_done();
    }
}
