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

void init_bombs(void) {
    bomb.state = BOMB_STATE_INACTIVE;
    set_sprite_data(5, 6, BombSpriteData);
    for(uint8_t i = 34; i <= 38; i++) {
        move_sprite(i, 0, 0);
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

static void hide_explosion() {
    for(uint8_t i = 34; i <= 38; i++) {
        move_sprite(i, 0, 0);
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
            
            if (bomb.y > 0 && maze[bomb.y - 1][bomb.x] == 0) {
                set_sprite_tile(34, 10);
                move_sprite(34, px, py - 8);
                do_explosion_damage(bomb.x, bomb.y - 1);
            }
            if (bomb.y < MAZE_HEIGHT - 1 && maze[bomb.y + 1][bomb.x] == 0) {
                set_sprite_tile(35, 10);
                move_sprite(35, px, py + 8);
                do_explosion_damage(bomb.x, bomb.y + 1);
            }
            if (bomb.x > 0 && maze[bomb.y][bomb.x - 1] == 0) {
                set_sprite_tile(36, 9);
                move_sprite(36, px - 8, py);
                do_explosion_damage(bomb.x - 1, bomb.y);
            }
            if (bomb.x < MAZE_WIDTH - 1 && maze[bomb.y][bomb.x + 1] == 0) {
                set_sprite_tile(37, 9);
                move_sprite(37, px + 8, py);
                do_explosion_damage(bomb.x + 1, bomb.y);
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
