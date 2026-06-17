#ifndef BOMB_H
#define BOMB_H

#include <stdint.h>

void init_bombs(void);
void drop_bomb(uint8_t x, uint8_t y);
void update_bombs(void);

#endif
