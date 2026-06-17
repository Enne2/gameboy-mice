/**
 * @file maze.c
 * @brief Implementazione dell'algoritmo di generazione del labirinto.
 */

#include "maze.h"
#include <rand.h>

// Istanza globale in RAM (WRAM) della mappa del labirinto.
uint8_t maze[MAZE_HEIGHT][MAZE_WIDTH];

// Stack customizzato utilizzato per l'algoritmo Recursive Backtracker.
// Si evitano le chiamate di funzione ricorsive per non esaurire
// lo spazio dello stack hardware del Game Boy.
uint8_t stack_x[100];
uint8_t stack_y[100];
uint8_t stack_ptr = 0;

/**
 * @brief Inserisce una nuova coordinata in cima allo stack.
 * @param x Posizione X della stanza.
 * @param y Posizione Y della stanza.
 */
static void push(uint8_t x, uint8_t y) {
    stack_x[stack_ptr] = x;
    stack_y[stack_ptr] = y;
    stack_ptr++;
}

/**
 * @brief Estrae e rimuove l'ultima coordinata dallo stack.
 * @param x Puntatore su cui scrivere la X rimossa.
 * @param y Puntatore su cui scrivere la Y rimossa.
 */
static void pop(uint8_t *x, uint8_t *y) {
    stack_ptr--;
    *x = stack_x[stack_ptr];
    *y = stack_y[stack_ptr];
}

void generate_maze(void) {
    uint8_t x, y;
    uint8_t nx, ny;
    uint8_t dirs[4];
    uint8_t count, r;
    
    // Fase 1: Inizializza l'intera griglia con blocchi di muro (1)
    for (y = 0; y < MAZE_HEIGHT; y++) {
        for (x = 0; x < MAZE_WIDTH; x++) {
            maze[y][x] = 1;
        }
    }
    
    // Fase 2: Imposta il punto iniziale di scavo.
    // Il punto in (1, 1) è la prima "stanza" calpestabile.
    stack_ptr = 0;
    push(1, 1);
    maze[1][1] = 0; // 0 = calpestabile
    
    // Fase 3: Scavo iterativo (Recursive Backtracker)
    while (stack_ptr > 0) {
        // Leggi la cella attuale in cima allo stack
        x = stack_x[stack_ptr - 1];
        y = stack_y[stack_ptr - 1];
        
        // Cerca direzioni inesplorate a distanza 2 (oltre il potenziale muro)
        count = 0;
        if (x >= 2 && maze[y][x - 2] == 1) dirs[count++] = 0; // Controllo Sinistra
        if (x <= MAZE_WIDTH - 3 && maze[y][x + 2] == 1) dirs[count++] = 1; // Controllo Destra
        if (y >= 2 && maze[y - 2][x] == 1) dirs[count++] = 2; // Controllo Su
        if (y <= MAZE_HEIGHT - 3 && maze[y + 2][x] == 1) dirs[count++] = 3; // Controllo Giù
        
        if (count > 0) {
            // È stata trovata almeno una direzione valida:
            // si sceglie casualmente una tra quelle esplorabili
            r = rand() % count;
            
            nx = x; ny = y;
            // Calcola la cella adiacente finale e demolisci il muro intermedio
            if (dirs[r] == 0) { nx -= 2; maze[y][x - 1] = 0; }
            else if (dirs[r] == 1) { nx += 2; maze[y][x + 1] = 0; }
            else if (dirs[r] == 2) { ny -= 2; maze[y - 1][x] = 0; }
            else if (dirs[r] == 3) { ny += 2; maze[y + 1][x] = 0; }
            
            // Imposta la nuova cella come esplorata (calpestabile)
            maze[ny][nx] = 0;
            // Pusha la nuova coordinata nello stack per espandere il ramo
            push(nx, ny);
        } else {
            // Vicolo cieco: estrae la coordinata corrente per risalire
            // al nodo precedente (backtracking)
            pop(&x, &y);
        }
    }
}
