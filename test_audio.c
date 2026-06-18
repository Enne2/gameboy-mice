#include <gb/gb.h>
#include <stdio.h>
#include "music.h"

void main(void) {
    uint8_t prev_keys = 0;
    
    printf("   AUDIO TEST MICE!\n\n");
    printf("UP: Explosion\n");
    printf("DOWN: Shotgun\n");
    printf("LEFT: Bomb Drop\n");
    printf("RIGHT: Moan\n");
    printf("A: Plop\n");
    printf("B: Victory Jingle\n");
    printf("START: Game Over Jingle\n");
    printf("SELECT: Toggle Music\n");
    
    init_music();
    
    while(1) {
        update_music();
        wait_vbl_done();
        
        uint8_t keys = joypad();
        
        if ((keys & J_UP) && !(prev_keys & J_UP)) {
            play_sfx_explosion();
        }
        if ((keys & J_DOWN) && !(prev_keys & J_DOWN)) {
            play_sfx_shotgun();
        }
        if ((keys & J_LEFT) && !(prev_keys & J_LEFT)) {
            play_sfx_bomb_drop();
        }
        if ((keys & J_RIGHT) && !(prev_keys & J_RIGHT)) {
            play_sfx_moan();
        }
        if ((keys & J_A) && !(prev_keys & J_A)) {
            play_sfx_plop();
        }
        if ((keys & J_B) && !(prev_keys & J_B)) {
            play_victory_music();
        }
        if ((keys & J_START) && !(prev_keys & J_START)) {
            play_game_over_music();
        }
        if ((keys & J_SELECT) && !(prev_keys & J_SELECT)) {
            toggle_music();
        }
        
        prev_keys = keys;
    }
}
