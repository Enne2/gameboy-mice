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
#include "title_bg.h"

#include "rat.h"
#include "music.h"
#include "cursor.h"
#include "bomb.h"
#include "pause_gfx.h"

static uint8_t main_prev_keys = 0;

void main(void) {
    uint8_t y, x;
    uint8_t black = 1;
    
    // --- SCHERMATA DEL TITOLO ---
    wait_vbl_done();
    set_bkg_data(0, 256, title_bg_tiles);
    set_bkg_tiles(0, 0, 20, 18, title_bg_map);
    
    SHOW_BKG;
    DISPLAY_ON;
    BGP_REG = 0b11100100;
    
    // Attendi la pressione di START
    while (1) {
        if (joypad() & J_START) {
            break;
        }
        wait_vbl_done();
    }
    
    // Attendi il rilascio del tasto per non passarlo al gioco
    waitpadup();
    
    // Spegni il display per caricare i tile del gioco in sicurezza
    DISPLAY_OFF;
    
    // Inizializza il seme casuale. Poiché il giocatore ha aspettato
    // un tempo imprevedibile nel menu, DIV_REG produrrà un labirinto sempre nuovo!
    initrand(DIV_REG);
    
    // Invia i dati grafici del gioco alla VRAM
    set_bkg_data(0, 22, TileData); // 6 pavimenti + 16 varianti autotile
    
    // Inizializza la grafica della PAUSA come Sprite
    set_sprite_data(11, 5, PauseTiles); // 5 tile per la pausa (P,A,U,S,E)
    // Nascondi gli sprite del menu pausa all'avvio
    move_sprite(20, 0, 0);
    move_sprite(21, 0, 0);
    move_sprite(22, 0, 0);
    move_sprite(23, 0, 0);
    move_sprite(24, 0, 0);
    
    // La mappa background in memoria hardware è grande 32x32 tiles.
    // Inizializziamo il "fuori mappa" con siepi solide (mask 15 -> indice 21)
    for (y = 0; y < 32; y++) {
        for (x = 0; x < 32; x++) {
            uint8_t solid_hedge = 21; 
            set_bkg_tiles(x, y, 1, 1, &solid_hedge);
        }
    }
    
    // Invoca la funzione logica per popolare l'array `maze` in memoria.
    generate_maze();
    
    // Riversa l'array generato `maze` nella memoria del Background (VRAM Mappa).
    for (y = 0; y < MAZE_HEIGHT; y++) {
        for (x = 0; x < MAZE_WIDTH; x++) {
            uint8_t tile_idx = maze[y][x];
            if (tile_idx == 1) { // Se è un muro, usa autotiling
                uint8_t mask = 0;
                if (y > 0 && maze[y-1][x] == 1) mask |= 8; // Nord
                if (x < MAZE_WIDTH-1 && maze[y][x+1] == 1) mask |= 4; // Est
                if (y < MAZE_HEIGHT-1 && maze[y+1][x] == 1) mask |= 2; // Sud
                if (x > 0 && maze[y][x-1] == 1) mask |= 1; // Ovest
                tile_idx = 6 + mask; // Offset 6 per le siepi
            } else {
                // Scegli una variante casuale di pavimento per le stanze e i percorsi
                // 0 è la base pulita, 1-5 sono crepe e detriti (rarità maggiore per la 0)
                uint8_t r = rand() % 10;
                if (r < 5) tile_idx = 0;
                else tile_idx = 1 + (r % 5);
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
    
    init_bombs();
    
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
        
        uint8_t keys = joypad();
        
        // Controllo per la Pausa
        if ((keys & J_START) && !(main_prev_keys & J_START)) {
            // Mostra la scritta PAUSE al centro dello schermo usando gli sprite
            set_sprite_tile(20, 11);
            set_sprite_tile(21, 12);
            set_sprite_tile(22, 13);
            set_sprite_tile(23, 14);
            set_sprite_tile(24, 15);
            move_sprite(20, 68, 88);
            move_sprite(21, 76, 88);
            move_sprite(22, 84, 88);
            move_sprite(23, 92, 88);
            move_sprite(24, 100, 88);
            
            waitpadup(); // Aspetta che START sia rilasciato
            
            while (1) {
                uint8_t p_keys = joypad();
                if (p_keys & J_START) {
                    break; // Esci dalla pausa
                }
                update_music(); // La musica continua in pausa
                wait_vbl_done();
            }
            
            // Nascondi gli sprite
            move_sprite(20, 0, 0);
            move_sprite(21, 0, 0);
            move_sprite(22, 0, 0);
            move_sprite(23, 0, 0);
            move_sprite(24, 0, 0);
            
            waitpadup(); // Aspetta il rilascio
            keys = joypad(); // Rileggi per evitare salti
        }
        main_prev_keys = keys;
        
        // Aggiorna la musica in background
        update_music();
        
        // Aggiorna l'intelligenza artificiale e l'animazione dei topi
        update_rats();
        
        // Aggiorna l'input del cursore del giocatore
        update_cursor();
        
        // Aggiorna le bombe
        update_bombs();
        
        // Attendi la sincronizzazione con il monitor
        wait_vbl_done();
    }
}
