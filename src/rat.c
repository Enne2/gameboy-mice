/**
 * @file rat.c
 * @brief Implementazione del topo autonomo usando Meta-Sprite (16x8 / 8x16).
 */

#include "rat.h"
#include "maze.h"
#include <gb/gb.h>
#include <rand.h>

// Dati dei 4 tile per creare i meta-sprite del topo. Usa solo la forma "Giù" ruotata per tutte le direzioni!
// Colori: 0=Trasparente (Bianco), 1=Grigio Chiaro (Corpo), 2=Grigio Scuro (Macchie/Naso), 3=Nero (Contorni/Pupille)
const unsigned char RatSpriteData[] = {
    // 0: Destra - Metà Sinistra (Coda/Posteriore) ruotata a partire da Giù
    0x00, 0x00, 0x07, 0x07, 0x3F, 0x38, 0x5E, 0x71, 0x5B, 0x74, 0x3F, 0x38, 0x07, 0x07, 0x00, 0x00,
    // 1: Destra - Metà Destra (Testa/Occhi/Naso) ruotata a partire da Giù
    0x00, 0x00, 0xF0, 0xF0, 0xC8, 0x08, 0xD4, 0x1C, 0xD4, 0x1C, 0xC8, 0x08, 0xF0, 0xF0, 0x00, 0x00,
    
    // 2: Giù - Metà Superiore (Coda/Schiena)
    0x00, 0x00, 0x18, 0x18, 0x24, 0x3C, 0x3C, 0x3C, 0x3C, 0x24, 0x6E, 0x52, 0x7E, 0x42, 0x76, 0x4A,
    // 3: Giù - Metà Inferiore (Occhi/Naso)
    0x7E, 0x42, 0x7E, 0x42, 0x42, 0x42, 0x5A, 0x5A, 0x24, 0x3C, 0x18, 0x18, 0x00, 0x00, 0x00, 0x00
};

static uint8_t rat_x = 1;
static uint8_t rat_y = 1;
static uint8_t target_x = 1;
static uint8_t target_y = 1;
static uint8_t pixel_x = 0;
static uint8_t pixel_y = 0;
static uint8_t current_dir = 255;

static uint8_t get_opposite(uint8_t dir) {
    if (dir == 0) return 1;
    if (dir == 1) return 0;
    if (dir == 2) return 3;
    if (dir == 3) return 2;
    return 255;
}

void init_rat(uint8_t start_x, uint8_t start_y) {
    rat_x = target_x = start_x;
    rat_y = target_y = start_y;
    pixel_x = rat_x * 8;
    pixel_y = rat_y * 8;
    current_dir = 255;
    
    // Carica tutti i 4 tile per le combinazioni 16x8 e 8x16
    set_sprite_data(0, 4, RatSpriteData);
    OBP0_REG = 0xE4; // Palette standard
    
    // Imposta tile di default (Giù)
    set_sprite_tile(0, 2);
    set_sprite_tile(1, 3);
}

void update_rat(void) {
    if (rat_x == target_x && rat_y == target_y) {
        uint8_t valid_dirs[4];
        uint8_t num_valid = 0;
        
        if (rat_y < MAZE_HEIGHT - 1 && maze[rat_y + 1][rat_x] == 0) valid_dirs[num_valid++] = 0;
        if (rat_y > 0 && maze[rat_y - 1][rat_x] == 0) valid_dirs[num_valid++] = 1;
        if (rat_x > 0 && maze[rat_y][rat_x - 1] == 0) valid_dirs[num_valid++] = 2;
        if (rat_x < MAZE_WIDTH - 1 && maze[rat_y][rat_x + 1] == 0) valid_dirs[num_valid++] = 3;
        
        if (num_valid > 0) {
            if (num_valid > 1 && current_dir != 255) {
                uint8_t opp = get_opposite(current_dir);
                uint8_t filtered[4];
                uint8_t num_filtered = 0;
                for (uint8_t i = 0; i < num_valid; i++) {
                    if (valid_dirs[i] != opp) {
                        filtered[num_filtered++] = valid_dirs[i];
                    }
                }
                if (num_filtered > 0) current_dir = filtered[rand() % num_filtered];
                else current_dir = valid_dirs[rand() % num_valid];
            } else {
                current_dir = valid_dirs[rand() % num_valid];
            }
            
            if (current_dir == 0) target_y++;
            else if (current_dir == 1) target_y--;
            else if (current_dir == 2) target_x--;
            else if (current_dir == 3) target_x++;
        }
    }
    
    uint8_t target_px = target_x * 8;
    uint8_t target_py = target_y * 8;
    
    static uint8_t frame_counter = 0;
    frame_counter++;
    if (frame_counter & 1) {
        if (pixel_x < target_px) pixel_x++;
        else if (pixel_x > target_px) pixel_x--;
        if (pixel_y < target_py) pixel_y++;
        else if (pixel_y > target_py) pixel_y--;
    }
    
    if (pixel_x == target_px && pixel_y == target_py) {
        rat_x = target_x;
        rat_y = target_y;
    }
    
    // Aggiorna gli hardware sprite (Meta-Sprite system)
    uint8_t base_x = pixel_x + 12;
    uint8_t base_y = pixel_y + 20;
    
    if (current_dir == 0 || current_dir == 255) { // Giù (Verticale 8x16)
        set_sprite_tile(0, 2);
        set_sprite_tile(1, 3);
        set_sprite_prop(0, 0);
        set_sprite_prop(1, 0);
        move_sprite(0, base_x, base_y - 4);
        move_sprite(1, base_x, base_y + 4);
    } else if (current_dir == 1) { // Su (Verticale 8x16, FLIPPATO IN Y)
        set_sprite_tile(0, 3); // Naso diventa parte alta
        set_sprite_tile(1, 2); // Coda diventa parte bassa
        set_sprite_prop(0, S_FLIPY);
        set_sprite_prop(1, S_FLIPY);
        move_sprite(0, base_x, base_y - 4);
        move_sprite(1, base_x, base_y + 4);
    } else if (current_dir == 2) { // Sinistra (Flippato orizzontalmente per puntare a sinistra)
        set_sprite_tile(0, 1); // Naso flippato (va a sinistra)
        set_sprite_tile(1, 0); // Coda flippata (va a destra)
        set_sprite_prop(0, S_FLIPX);
        set_sprite_prop(1, S_FLIPX);
        move_sprite(0, base_x - 4, base_y);
        move_sprite(1, base_x + 4, base_y);
    } else if (current_dir == 3) { // Destra (Punta a destra nativamente)
        set_sprite_tile(0, 0); // Coda (metà sinistra)
        set_sprite_tile(1, 1); // Naso (metà destra)
        set_sprite_prop(0, 0);
        set_sprite_prop(1, 0);
        move_sprite(0, base_x - 4, base_y);
        move_sprite(1, base_x + 4, base_y);
    }
}
