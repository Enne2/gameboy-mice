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
#include "victory_bg.h"

#include "rat.h"
#include "music.h"
#include "cursor.h"
#include "bomb.h"
#include "pause_gfx.h"
#include "numbers_gfx.h"

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
    
    // Inizializza le palette
    BGP_REG = 0b11100100;
    OBP0_REG = 0b11100100; // Normale (3=Nero, 2=GrigioS, 1=GrigioC, 0=Trasparente)
    OBP1_REG = 0b11000000; // Pausa (3=Nero, 2=Bianco, 1=Bianco, 0=Trasparente)
    
    // Attendi la pressione di START
    play_title_music();
    while (1) {
        update_music();
        if (joypad() & J_START) {
            break;
        }
        wait_vbl_done();
    }
    
    // Attendi il rilascio del tasto per non passarlo al gioco
    waitpadup();
    
    // Spegni il display per caricare i tile del gioco in sicurezza
    DISPLAY_OFF;
    
    // Inizializza il seme casuale.
    initrand(DIV_REG);
    
    // Invia i dati grafici del gioco alla VRAM
    set_bkg_data(0, 22, TileData); // 6 pavimenti + 16 varianti autotile
    
    // Inizializza la grafica della PAUSA come Sprite
    set_sprite_data(11, 5, PauseTiles); // 5 tile per la pausa (P,A,U,S,E)
    // Nascondi gli sprite del menu pausa e imposta OBP1
    for (uint8_t i = 20; i <= 24; i++) {
        set_sprite_prop(i, S_PALETTE); // Usa OBP1
        move_sprite(i, 0, 0);
    }
    
    // Inizializza i tile dei numeri (0-9) per il timer (li carichiamo all'indice 25)
    set_sprite_data(25, 10, NumberTiles);
    
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
                // Scegli una variante casuale di pavimento
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
    
    // Variabili per il timer (formato BCD array per evitare divisioni a 16 bit)
    uint8_t timer_digits[4] = {0, 0, 0, 0};
    uint8_t timer_frames = 0;
    
    // Setup iniziale del timer (prima di entrare nel loop)
    set_sprite_tile(25, 25);
    set_sprite_tile(26, 25);
    set_sprite_tile(27, 25);
    set_sprite_tile(28, 25);
    
    set_sprite_prop(25, S_PALETTE);
    set_sprite_prop(26, S_PALETTE);
    set_sprite_prop(27, S_PALETTE);
    set_sprite_prop(28, S_PALETTE);
    
    // Y in basso (152 = margine inferiore visibile: 152 - 16 = 136), X a destra
    move_sprite(25, 136, 152);
    move_sprite(26, 144, 152);
    move_sprite(27, 152, 152);
    move_sprite(28, 160, 152);
    
    // Game Loop primario
    while (1) {
        if (game_over_flag || victory_flag) {
            HIDE_SPRITES;
            move_bkg(0, 0); // Resetta lo scrolling hardware
            
            // Ripristina la palette normale (Nero=3, Bianco=0)
            BGP_REG = 0b11100100;
            
            if (victory_flag) {
                // Carica background di vittoria
                set_bkg_data(0, 256, victory_bg_tiles);
                set_bkg_tiles(0, 0, 20, 18, victory_bg_map);
                play_victory_music();
            } else {
                // Carica background di sconfitta
                set_bkg_data(0, 256, rat_bg_tiles);
                set_bkg_tiles(0, 0, 20, 18, rat_bg_map);
                play_game_over_music();
            }
            
            SHOW_SPRITES;
            while(1) {
                update_music();
                
                if (victory_flag) {
                    // Disegna il timer (punteggio finale) sopra la vittoria
                    set_sprite_tile(25, 25 + timer_digits[0]);
                    set_sprite_tile(26, 25 + timer_digits[1]);
                    set_sprite_tile(27, 25 + timer_digits[2]);
                    set_sprite_tile(28, 25 + timer_digits[3]);
                    
                    set_sprite_prop(25, S_PALETTE);
                    set_sprite_prop(26, S_PALETTE);
                    set_sprite_prop(27, S_PALETTE);
                    set_sprite_prop(28, S_PALETTE);
                    
                    // Centrato e in basso
                    move_sprite(25, 68, 144);
                    move_sprite(26, 76, 144);
                    move_sprite(27, 84, 144);
                    move_sprite(28, 92, 144);
                }
                
                wait_vbl_done();
                uint8_t keys = joypad();
                if ((keys & J_START) && !(main_prev_keys & J_START)) {
                    reset();
                }
                main_prev_keys = keys;
            }
        }
        
        // Logica del timer (incrementa ogni 60 frame = 1 secondo)
        timer_frames++;
        if (timer_frames >= 60) {
            timer_frames = 0;
            
            // Incremento stile BCD per evitare divisioni dispendiose
            timer_digits[3]++;
            if (timer_digits[3] > 9) {
                timer_digits[3] = 0;
                timer_digits[2]++;
                if (timer_digits[2] > 9) {
                    timer_digits[2] = 0;
                    timer_digits[1]++;
                    if (timer_digits[1] > 9) {
                        timer_digits[1] = 0;
                        timer_digits[0]++;
                        if (timer_digits[0] > 9) {
                            // Cap a 9999
                            timer_digits[0] = 9;
                            timer_digits[1] = 9;
                            timer_digits[2] = 9;
                            timer_digits[3] = 9;
                        }
                    }
                }
            }
            
            // Aggiorna i tile SOLO una volta al secondo invece di ogni frame!
            set_sprite_tile(25, 25 + timer_digits[0]);
            set_sprite_tile(26, 25 + timer_digits[1]);
            set_sprite_tile(27, 25 + timer_digits[2]);
            set_sprite_tile(28, 25 + timer_digits[3]);
        }
        
        uint8_t keys = joypad();
        
        // Controllo per la Pausa
        if ((keys & J_START) && !(main_prev_keys & J_START)) {
            // Effetto sonoro pausa
            NR10_REG = 0x00;
            NR11_REG = 0x81;
            NR12_REG = 0x43;
            NR13_REG = 0x73;
            NR14_REG = 0x86;
            
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
                    // Effetto sonoro resume
                    NR10_REG = 0x00;
                    NR11_REG = 0x81;
                    NR12_REG = 0x43;
                    NR13_REG = 0x73;
                    NR14_REG = 0x86;
                    break; // Esci dalla pausa
                }
                // update_music(); // MUSICA BLOCCATA (commentato intenzionalmente)
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
