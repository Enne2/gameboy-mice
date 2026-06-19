#include "bomb.h"
#include "maze.h"
#include "rat.h"
#include "music.h"
#include <gb/gb.h>

extern const unsigned char BombSpriteData[];

#define BOMB_STATE_INACTIVE 0
#define BOMB_STATE_TICKING 1
#define BOMB_STATE_EXPLODING 2

typedef struct {
    uint8_t state;
    uint8_t x;
    uint8_t y;
    uint16_t timer;
} Bomb;

static Bomb bomb;

static const uint8_t exp_sprite_pool[] = {
    20, 21, 22, 23, 29, 30, 31, 32, 33, 34, 35, 36, 37
};
#define EXP_POOL_SIZE 13

void init_bombs(void) {
    bomb.state = BOMB_STATE_INACTIVE;
    set_sprite_data(5, 6, BombSpriteData);
    move_sprite(38, 0, 0); // Bomba centrale
    for(uint8_t i = 0; i < EXP_POOL_SIZE; i++) {
        move_sprite(exp_sprite_pool[i], 0, 0);
    }
}

void drop_bomb(uint8_t x, uint8_t y) {
    if (bomb.state == BOMB_STATE_INACTIVE) {
        bomb.state = BOMB_STATE_TICKING;
        bomb.x = x;
        bomb.y = y;
        bomb.timer = 180; // 3 seconds
        play_sfx_bomb_drop(); // Suono innesco
    }
}

static void hide_explosion(void) {
    move_sprite(38, 0, 0);
    for(uint8_t i = 0; i < EXP_POOL_SIZE; i++) {
        move_sprite(exp_sprite_pool[i], 0, 0);
    }
}

static void do_explosion_damage(uint8_t ex, uint8_t ey) {
    kill_rats_at(ex, ey);
}

void update_bombs(void) {
    if (bomb.state == BOMB_STATE_TICKING) {
        bomb.timer--;
        
        uint8_t px = bomb.x * 8 + 12;
        uint8_t py = bomb.y * 8 + 20;
        
        if (bomb.timer > 120) {
            set_sprite_tile(38, 5); // bomb_3
        } else if (bomb.timer > 60) {
            set_sprite_tile(38, 6); // bomb_2
        } else {
            if (bomb.timer & 4) {
                set_sprite_tile(38, 7); // bomb_1
            } else {
                set_sprite_tile(38, 5);
            }
        }
        
        move_sprite(38, px, py);
        
        if (bomb.timer == 0) {
            bomb.state = BOMB_STATE_EXPLODING;
            bomb.timer = 30; // 0.5s explosion
            
            play_sfx_explosion();
            
            set_sprite_tile(38, 8);
            move_sprite(38, px, py);
            do_explosion_damage(bomb.x, bomb.y);
            
            uint8_t pool_idx = 0;
            
            // Su
            uint8_t yy = bomb.y;
            while (yy > 0) {
                yy--;
                if (maze[yy][bomb.x] != 0) break;
                if (pool_idx < EXP_POOL_SIZE) {
                    uint8_t sp = exp_sprite_pool[pool_idx++];
                    set_sprite_tile(sp, 10); // Fiamma verticale
                    move_sprite(sp, px, (yy * 8) + 20);
                }
                do_explosion_damage(bomb.x, yy);
            }
            
            // Giù
            yy = bomb.y;
            while (yy < MAZE_HEIGHT - 1) {
                yy++;
                if (maze[yy][bomb.x] != 0) break;
                if (pool_idx < EXP_POOL_SIZE) {
                    uint8_t sp = exp_sprite_pool[pool_idx++];
                    set_sprite_tile(sp, 10); // Fiamma verticale
                    move_sprite(sp, px, (yy * 8) + 20);
                }
                do_explosion_damage(bomb.x, yy);
            }
            
            // Sinistra
            uint8_t xx = bomb.x;
            while (xx > 0) {
                xx--;
                if (maze[bomb.y][xx] != 0) break;
                if (pool_idx < EXP_POOL_SIZE) {
                    uint8_t sp = exp_sprite_pool[pool_idx++];
                    set_sprite_tile(sp, 9); // Fiamma orizzontale
                    move_sprite(sp, (xx * 8) + 12, py);
                }
                do_explosion_damage(xx, bomb.y);
            }
            
            // Destra
            xx = bomb.x;
            while (xx < MAZE_WIDTH - 1) {
                xx++;
                if (maze[bomb.y][xx] != 0) break;
                if (pool_idx < EXP_POOL_SIZE) {
                    uint8_t sp = exp_sprite_pool[pool_idx++];
                    set_sprite_tile(sp, 9); // Fiamma orizzontale
                    move_sprite(sp, (xx * 8) + 12, py);
                }
                do_explosion_damage(xx, bomb.y);
            }
        }
    } else if (bomb.state == BOMB_STATE_EXPLODING) {
        bomb.timer--;
        if (bomb.timer == 0) {
            bomb.state = BOMB_STATE_INACTIVE;
            hide_explosion();
        }
    }
}
