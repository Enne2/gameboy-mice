/**
 * @file maze.h
 * @brief Strutture e funzioni per la generazione procedurale del labirinto.
 */

#ifndef MAZE_H
#define MAZE_H

#include <stdint.h>

// Dimensioni logiche del labirinto in numero di tiles (1 tile = 8x8 px).
// Manteniamo dimensioni dispari (19x17) in modo da poter creare un
// labirinto simmetrico circondato da muri uniformi una volta centrato.
#define MAZE_WIDTH 19
#define MAZE_HEIGHT 17

/**
 * @brief Matrice globale che rappresenta la mappa del labirinto in RAM.
 * 
 * Il valore 1 rappresenta un Muro (Tile Nero).
 * Il valore 0 rappresenta un Percorso (Tile Bianco).
 */
extern uint8_t maze[MAZE_HEIGHT][MAZE_WIDTH];

/**
 * @brief Esegue l'algoritmo di generazione del labirinto.
 * 
 * Utilizza la logica di tipo Recursive Backtracker (implementata iterativamente
 * con array custom per non sforare lo stack di sistema limitato).
 */
void generate_maze(void);

#endif
