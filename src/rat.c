#include "rat.h"
#include "maze.h"
#include "music.h"
#include <gb/gb.h>
#include <rand.h>

const unsigned char RatSpriteData[] = {
    // 0: Destra - Metà Sinistra (Coda/Posteriore) ruotata a partire da Giù
    0x00, 0x00, 0x07, 0x07, 0x3F, 0x38, 0x5E, 0x71, 0x5B, 0x74, 0x3F, 0x38, 0x07, 0x07, 0x00, 0x00,
    // 1: Destra - Metà Destra (Testa/Occhi/Naso) ruotata a partire da Giù
    0x00, 0x00, 0xF0, 0xF0, 0xC8, 0x08, 0xD4, 0x1C, 0xD4, 0x1C, 0xC8, 0x08, 0xF0, 0xF0, 0x00, 0x00,
    
    // 2: Giù - Metà Superiore (Coda/Schiena)
    0x00, 0x00, 0x18, 0x18, 0x24, 0x3C, 0x3C, 0x3C, 0x3C, 0x24, 0x6E, 0x52, 0x7E, 0x42, 0x76, 0x4A,
    // 3: Giù - Metà Inferiore (Occhi/Naso)
    0x7E, 0x42, 0x7E, 0x42, 0x42, 0x42, 0x5A, 0x5A, 0x24, 0x3C, 0x18, 0x18, 0x00, 0x00, 0x00, 0x00
};

typedef struct {
    uint8_t active;
    uint8_t rat_x;
    uint8_t rat_y;
    uint8_t target_x;
    uint8_t target_y;
    uint8_t pixel_x;
    uint8_t pixel_y;
    uint8_t current_dir;
    uint8_t sprite_base_idx;
    uint8_t reproduce_timer;
    uint8_t cooldown_timer;
    uint8_t is_mother; // flag per far partorire un solo ratto
} Rat;

static Rat rats[MAX_RATS];
uint8_t game_over_flag = 0;

static uint8_t get_opposite(uint8_t dir) {
    if (dir == 0) return 1;
    if (dir == 1) return 0;
    if (dir == 2) return 3;
    if (dir == 3) return 2;
    return 255;
}

void init_rats(void) {
    // Carica tutti i 4 tile per le combinazioni 16x8 e 8x16
    set_sprite_data(0, 4, RatSpriteData);
    OBP0_REG = 0xE4; // Palette standard
    
    // Posizioni iniziali garantite vuote (coordinate dispari)
    uint8_t start_pos[2][2] = {
        {1, 1},
        {17, 15}
    };
    
    for (uint8_t i = 0; i < MAX_RATS; i++) {
        rats[i].active = 0;
        rats[i].reproduce_timer = 0;
        rats[i].cooldown_timer = 0;
        rats[i].is_mother = 0;
        rats[i].sprite_base_idx = i * 2;
        // Nascondi sprite
        move_sprite(rats[i].sprite_base_idx, 0, 0);
        move_sprite(rats[i].sprite_base_idx + 1, 0, 0);
    }
    
    // Attiva i primi due topi
    for (uint8_t i = 0; i < 2; i++) {
        rats[i].active = 1;
        rats[i].rat_x = start_pos[i][0];
        rats[i].rat_y = start_pos[i][1];
        rats[i].target_x = start_pos[i][0];
        rats[i].target_y = start_pos[i][1];
        rats[i].pixel_x = rats[i].rat_x * 8;
        rats[i].pixel_y = rats[i].rat_y * 8;
        rats[i].current_dir = 255;
    }
}

void spawn_rat(uint8_t x, uint8_t y) {
    for (uint8_t i = 0; i < MAX_RATS; i++) {
        if (!rats[i].active) {
            rats[i].active = 1;
            rats[i].rat_x = x;
            rats[i].rat_y = y;
            rats[i].target_x = x;
            rats[i].target_y = y;
            rats[i].pixel_x = x * 8;
            rats[i].pixel_y = y * 8;
            rats[i].current_dir = 255;
            rats[i].reproduce_timer = 0;
            rats[i].cooldown_timer = 120; // Il cucciolo non si riproduce subito
            rats[i].is_mother = 0;
            play_sfx_plop(); // Suono di nascita!
            
            uint8_t count = 0;
            for (uint8_t j = 0; j < MAX_RATS; j++) {
                if (rats[j].active) count++;
            }
            if (count >= MAX_RATS) {
                game_over_flag = 1;
            }
            break;
        }
    }
}

void update_rats(void) {
    static uint8_t frame_counter = 0;
    frame_counter++;
    uint8_t do_move = (frame_counter & 1); // Muovi di 1 pixel ogni 2 frame
    
    // 1. Controlla collisioni per riproduzione usando una SPATIAL HASH GRID (O(N))
    // Questa tecnica rimpiazza il doppio ciclo O(N^2) da 105 iterazioni.
    // Usiamo array pre-allocati per creare "Linked Lists" statiche senza usare malloc!
    uint8_t head[16];
    uint8_t next_rat[MAX_RATS];
    
    // Inizializza i bucket dell'hash grid a vuoto (255)
    for (uint8_t i = 0; i < 16; i++) head[i] = 255;
    
    // Popola la grid: ogni topo calcola il suo hash basato sulle coordinate e si inserisce in testa alla lista
    for (uint8_t i = 0; i < MAX_RATS; i++) {
        if (!rats[i].active || rats[i].reproduce_timer > 0 || rats[i].cooldown_timer > 0) {
            next_rat[i] = 255;
            continue;
        }
        uint8_t h = (rats[i].rat_x ^ rats[i].rat_y) & 15; // Hash velocissimo
        next_rat[i] = head[h];
        head[h] = i;
    }
    
    // Ora per ogni topo controlliamo solo i topi che sono finiti nello STESSO bucket!
    for (uint8_t i = 0; i < MAX_RATS; i++) {
        if (!rats[i].active || rats[i].reproduce_timer > 0 || rats[i].cooldown_timer > 0) continue;
        
        // Attraversa la linked list partendo dal topo "sotto" di lui nel bucket
        uint8_t j = next_rat[i]; 
        while (j != 255) {
            if (rats[i].rat_x == rats[j].rat_x && rats[i].rat_y == rats[j].rat_y &&
                rats[i].pixel_x == rats[j].pixel_x && rats[i].pixel_y == rats[j].pixel_y) {
                
                // Incontro riproduttivo!
                // Usa 64 frames invece di 60 perché è un multiplo esatto di 16.
                rats[i].reproduce_timer = 64; 
                rats[j].reproduce_timer = 64;
                rats[i].is_mother = 1; // Solo i farà spawnare il cucciolo
                rats[j].is_mother = 0;
                play_sfx_moan(); // Suono d'amore
                break;
            }
            j = next_rat[j]; // Passa al prossimo topo nello stesso bucket
        }
    }
    
    // 2. Aggiorna lo stato di ogni topo
    for (uint8_t i = 0; i < MAX_RATS; i++) {
        Rat* r = &rats[i];
        if (!r->active) continue;
        
        if (r->cooldown_timer > 0) {
            r->cooldown_timer--;
        }
        
        // Se si stanno riproducendo, aspetta
        if (r->reproduce_timer > 0) {
            r->reproduce_timer--;
            if (r->reproduce_timer == 0) {
                // Finito di riprodursi, imposta il cooldown
                r->cooldown_timer = 120; // 2 secondi di pausa
                if (r->is_mother) {
                    r->is_mother = 0;
                    spawn_rat(r->rat_x, r->rat_y);
                }
            }
            continue;
        }
        
        if (r->rat_x == r->target_x && r->rat_y == r->target_y) {
            uint8_t valid_dirs[4];
            uint8_t num_valid = 0;
            
            if (r->rat_y < MAZE_HEIGHT - 1 && maze[r->rat_y + 1][r->rat_x] == 0) valid_dirs[num_valid++] = 0;
            if (r->rat_y > 0 && maze[r->rat_y - 1][r->rat_x] == 0) valid_dirs[num_valid++] = 1;
            if (r->rat_x > 0 && maze[r->rat_y][r->rat_x - 1] == 0) valid_dirs[num_valid++] = 2;
            if (r->rat_x < MAZE_WIDTH - 1 && maze[r->rat_y][r->rat_x + 1] == 0) valid_dirs[num_valid++] = 3;
            
            if (num_valid > 0) {
                if (num_valid > 1 && r->current_dir != 255) {
                    uint8_t opp = get_opposite(r->current_dir);
                    uint8_t filtered[4];
                    uint8_t num_filtered = 0;
                    for (uint8_t j = 0; j < num_valid; j++) {
                        if (valid_dirs[j] != opp) {
                            filtered[num_filtered++] = valid_dirs[j];
                        }
                    }
                    if (num_filtered > 0) {
                        uint8_t rnd;
                        if (num_filtered == 1) rnd = 0;
                        else if (num_filtered == 2) rnd = rand() & 1; // 0 o 1
                        else { 
                            do { rnd = rand() & 3; } while(rnd >= num_filtered); 
                        }
                        r->current_dir = filtered[rnd];
                    }
                    else {
                        uint8_t rnd;
                        if (num_valid == 1) rnd = 0;
                        else if (num_valid == 2) rnd = rand() & 1;
                        else { 
                            do { rnd = rand() & 3; } while(rnd >= num_valid); 
                        }
                        r->current_dir = valid_dirs[rnd];
                    }
                } else {
                    uint8_t rnd;
                    if (num_valid == 1) rnd = 0;
                    else if (num_valid == 2) rnd = rand() & 1;
                    else { 
                        do { rnd = rand() & 3; } while(rnd >= num_valid); 
                    }
                    r->current_dir = valid_dirs[rnd];
                }
                
                if (r->current_dir == 0) r->target_y++;
                else if (r->current_dir == 1) r->target_y--;
                else if (r->current_dir == 2) r->target_x--;
                else if (r->current_dir == 3) r->target_x++;
            }
        }
        
        uint8_t target_px = r->target_x * 8;
        uint8_t target_py = r->target_y * 8;
        
        if (do_move) {
            if (r->pixel_x < target_px) r->pixel_x++;
            else if (r->pixel_x > target_px) r->pixel_x--;
            if (r->pixel_y < target_py) r->pixel_y++;
            else if (r->pixel_y > target_py) r->pixel_y--;
        }
        
        if (r->pixel_x == target_px && r->pixel_y == target_py) {
            r->rat_x = r->target_x;
            r->rat_y = r->target_y;
        }
        
        // Ottimizzazione: aggiorna tile e flag SOLO quando si cambia direzione.
        // Possiamo rilevarlo facilmente: se rat_x == target_x e rat_y == target_y, la direzione
        // viene scelta di nuovo (o mantenuta, ma è il momento in cui potrebbe cambiare).
        // Tuttavia, per essere super sicuri ed evitare sfarfallii iniziali, creiamo una
        // variabile "dirty" implicita, o semplicemente aggiorniamo i tile SOLO 
        // nel blocco in cui viene assegnata current_dir (poco sopra).
        
        // Visto che non vogliamo riscrivere troppo, e sappiamo che la CPU sta faticando
        // con le troppe chiamate a set_sprite_*, spostiamo questa logica!
        // Invece di farla in base_x/base_y qui sotto, la lasciamo fissa e ottimizziamo:
        
        // Invece di chiamare set_sprite_tile/prop 30 volte a frame (che è devastante per il GBDK),
        // aggiorniamo gli sprite in VRAM *solo* quando do_move è vero (ogni 2 frame) 
        // e solo calcolando l'offset.
        if (do_move || r->current_dir == 255) {
            uint8_t base_x = r->pixel_x + 12;
            uint8_t base_y = r->pixel_y + 20;
            uint8_t s0 = r->sprite_base_idx;
            uint8_t s1 = r->sprite_base_idx + 1;
            
            if (r->current_dir == 0 || r->current_dir == 255) { // Giù
                set_sprite_tile(s0, 2);
                set_sprite_tile(s1, 3);
                set_sprite_prop(s0, 0);
                set_sprite_prop(s1, 0);
                move_sprite(s0, base_x, base_y - 4);
                move_sprite(s1, base_x, base_y + 4);
            } else if (r->current_dir == 1) { // Su
                set_sprite_tile(s0, 3);
                set_sprite_tile(s1, 2);
                set_sprite_prop(s0, S_FLIPY);
                set_sprite_prop(s1, S_FLIPY);
                move_sprite(s0, base_x, base_y - 4);
                move_sprite(s1, base_x, base_y + 4);
            } else if (r->current_dir == 2) { // Sinistra
                set_sprite_tile(s0, 1);
                set_sprite_tile(s1, 0);
                set_sprite_prop(s0, S_FLIPX);
                set_sprite_prop(s1, S_FLIPX);
                move_sprite(s0, base_x - 4, base_y);
                move_sprite(s1, base_x + 4, base_y);
            } else if (r->current_dir == 3) { // Destra
                set_sprite_tile(s0, 0);
                set_sprite_tile(s1, 1);
                set_sprite_prop(s0, 0);
                set_sprite_prop(s1, 0);
                move_sprite(s0, base_x - 4, base_y);
                move_sprite(s1, base_x + 4, base_y);
            }
        }
    }
}
