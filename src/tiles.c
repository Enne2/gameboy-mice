/**
 * @file tiles.c
 * @brief Implementazione dei dati grafici dei tile.
 */

#include "tiles.h"

// Definizione dei dati dei tile. Ogni tile su Game Boy è 8x8 pixel.
// Ogni riga del tile è rappresentata da 2 byte (planar format).
const unsigned char TileData[] = {
    // Tile 0: Completamente bianco (tutti i bit a 0)
    // Indica la stanza scavata e i percorsi.
    0x00,0x00, 0x00,0x00, 0x00,0x00, 0x00,0x00, 
    0x00,0x00, 0x00,0x00, 0x00,0x00, 0x00,0x00,
    
    // Tile 1: Completamente nero (tutti i bit a 1)
    // Usato per disegnare i muri del labirinto.
    0xFF,0xFF, 0xFF,0xFF, 0xFF,0xFF, 0xFF,0xFF, 
    0xFF,0xFF, 0xFF,0xFF, 0xFF,0xFF, 0xFF,0xFF
};
