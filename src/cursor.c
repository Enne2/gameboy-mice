#include "cursor.h"
#include "maze.h"
#include <gb/gb.h>
#include "bomb.h"
#include "music.h"

const unsigned char CursorSpriteData[] = {
    // Bordo quadrato 8x8 (Nero, colore 3 -> 11)
    0xFF,0xFF, 0x81,0x81, 0x81,0x81, 0x81,0x81,
    0x81,0x81, 0x81,0x81, 0x81,0x81, 0xFF,0xFF
};

static uint8_t cursor_x = 1;
static uint8_t cursor_y = 1;
static uint8_t previous_keys = 0;
static uint8_t blink = 0;

void init_cursor(void) {
    cursor_x = 1;
    cursor_y = 1;
    previous_keys = 0;
    blink = 0;
    
    // Carica il tile del cursore nell'indice 4 della VRAM degli Sprite
    // (Gli indici 0-3 sono usati dai tile del topo)
    set_sprite_data(4, 1, CursorSpriteData);
    
    // Usa lo sprite hardware numero 39 (lasciando 0-38 liberi per i ratti)
    set_sprite_tile(39, 4); 
}

void update_cursor(void) {
    uint8_t keys = joypad();
    
    // Movimento controllato dal D-PAD
    if ((keys & J_UP) && !(previous_keys & J_UP)) {
        if (cursor_y > 1) cursor_y--;
    }
    if ((keys & J_DOWN) && !(previous_keys & J_DOWN)) {
        if (cursor_y < MAZE_HEIGHT - 2) cursor_y++;
    }
    if ((keys & J_LEFT) && !(previous_keys & J_LEFT)) {
        if (cursor_x > 1) cursor_x--;
    }
    if ((keys & J_RIGHT) && !(previous_keys & J_RIGHT)) {
        if (cursor_x < MAZE_WIDTH - 2) cursor_x++;
    }
    
    // Tasto A per sganciare la bomba
    if ((keys & J_A) && !(previous_keys & J_A)) {
        drop_bomb(cursor_x, cursor_y);
    }
    
    // Tasto SELECT per attivare/disattivare la musica
    if ((keys & J_SELECT) && !(previous_keys & J_SELECT)) {
        toggle_music();
    }
    
    previous_keys = keys;
    
    // Effetto lampeggiante: nascondi il cursore per metà del ciclo (ogni 16 frame)
    blink++;
    if (blink & 0x10) {
        move_sprite(39, 0, 0); // Nascondi spostandolo fuori schermo
    } else {
        // Posiziona il cursore calcolando offset (12, 20) per centrarlo sulla griglia 8x8
        move_sprite(39, cursor_x * 8 + 12, cursor_y * 8 + 20);
    }
}
