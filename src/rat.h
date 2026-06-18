#ifndef RAT_H
#define RAT_H

#include <stdint.h>

#define MAX_RATS 10

extern uint8_t game_over_flag;
extern uint8_t victory_flag;

void init_rats(void);
void update_rats(void);
void kill_rats_at(uint8_t x, uint8_t y);

#endif
