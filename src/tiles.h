/**
 * @file tiles.h
 * @brief Definizioni per i dati grafici dei tile.
 * 
 * Questo file dichiara le risorse grafiche utilizzate dal gioco, 
 * in particolare i tile per disegnare il labirinto e i muri.
 */

#ifndef TILES_H
#define TILES_H

/**
 * @brief Array contenente i dati grezzi dei tile.
 * 
 * Formato planare Game Boy (2 bit per pixel, 16 byte per tile).
 * - Tile 0: Bianco (usato per i percorsi)
 * - Tile 1: Nero (usato per i muri)
 */
extern const unsigned char TileData[];

#endif
