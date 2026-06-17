/**
 * @file rat.h
 * @brief Header per la gestione del personaggio "ratto" autonomo.
 */

#ifndef RAT_H
#define RAT_H

#include <stdint.h>

/**
 * @brief Inizializza il ratto alle coordinate logiche specificate.
 * @param start_x Coordinata X (in tiles) nel labirinto.
 * @param start_y Coordinata Y (in tiles) nel labirinto.
 */
void init_rat(uint8_t start_x, uint8_t start_y);

/**
 * @brief Aggiorna la posizione e la logica del ratto.
 * 
 * Da chiamare ogni frame nel game loop principale.
 */
void update_rat(void);

#endif
