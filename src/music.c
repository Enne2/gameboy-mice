#include "music.h"
#include <gb/gb.h>
#include <stdint.h>

#define N_C4  0x60B
#define N_CS4 0x624
#define N_D4  0x641
#define N_DS4 0x65A
#define N_E4  0x672
#define N_F4  0x689
#define N_FS4 0x69E
#define N_G4  0x6B2
#define N_GS4 0x6C6
#define N_A4  0x6D6
#define N_AS4 0x6E8
#define N_B4  0x6F7
#define N_C5  0x706
#define N_CS5 0x712
#define N_D5  0x721
#define N_DS5 0x72D
#define N_E5  0x739
#define N_F5  0x744
#define N_FS5 0x74F
#define N_G5  0x759
#define N_GS5 0x764
#define N_A5  0x76B
#define N_AS5 0x774
#define N_B5  0x77B
#define N_C6  0x783
#define N_CS6 0x789
#define N_D6  0x790
#define N_DS6 0x796
#define N_E6  0x79C
#define N_REST 0x000

// ==========================================
// TRACK 1: ARPEGGIO (CH1)
// ==========================================
#define A_C N_C4
#define A_E N_E4
#define A_F N_F4
#define A_G N_G4
#define A_GS N_GS4
#define A_A N_A4
#define A_B N_B4
#define A_D N_D4
#define A_C5 N_C5
#define A_E5 N_E5

const uint16_t trk_arp_0[64] = {
    A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E,
    A_F, A_A, A_C5, A_A, A_F, A_A, A_C5, A_A, A_F, A_A, A_C5, A_A, A_F, A_A, A_C5, A_A,
    A_G, A_B, A_D, A_B, A_G, A_B, A_D, A_B, A_G, A_B, A_D, A_B, A_G, A_B, A_D, A_B,
    A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_C5, A_E, A_G, A_C5, A_E
};
const uint16_t trk_arp_1[64] = {
    A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E,
    A_F, A_A, A_C5, A_A, A_F, A_A, A_C5, A_A, A_F, A_A, A_C5, A_A, A_F, A_A, A_C5, A_A,
    A_G, A_B, A_D, A_B, A_G, A_B, A_D, A_B, A_G, A_B, A_D, A_B, A_G, A_B, A_D, A_B,
    A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E
};
const uint16_t trk_arp_2[64] = {
    A_F, A_A, A_C5, A_A, A_F, A_A, A_C5, A_A, A_F, A_A, A_C5, A_A, A_F, A_A, A_C5, A_A,
    A_G, A_B, A_D, A_B, A_G, A_B, A_D, A_B, A_G, A_B, A_D, A_B, A_G, A_B, A_D, A_B,
    A_E, A_GS, A_B, A_GS, A_E, A_GS, A_B, A_GS, A_E, A_GS, A_B, A_GS, A_E, A_GS, A_B, A_GS,
    A_A, A_C5, A_E5, A_C5, A_A, A_C5, A_E5, A_C5, A_A, A_C5, A_E5, A_C5, A_A, A_C5, A_E5, A_C5
};
const uint16_t trk_arp_3[64] = {
    A_F, A_A, A_C5, A_A, A_F, A_A, A_C5, A_A, A_F, A_A, A_C5, A_A, A_F, A_A, A_C5, A_A,
    A_G, A_B, A_D, A_B, A_G, A_B, A_D, A_B, A_G, A_B, A_D, A_B, A_G, A_B, A_D, A_B,
    A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E,
    A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_E, A_C, A_E, A_G, A_C5, A_E, A_G, A_C5, A_E
};
const uint16_t* const arp_parts[4] = { trk_arp_0, trk_arp_1, trk_arp_2, trk_arp_3 };

// ==========================================
// TRACK 2: MELODY (CH2)
// ==========================================
#define M_C N_C5
#define M_D N_D5
#define M_E N_E5
#define M_F N_F5
#define M_G N_G5
#define M_GS N_GS5
#define M_A N_A5
#define M_B N_B5
#define M_C6 N_C6
#define M_D6 N_D6
#define M_E6 N_E6
#define M__ N_REST

const uint16_t trk_mel_0[64] = {
    M_E, M__, M_D, M_C, M__, M_G, M__, M__, M_E, M__, M_D, M_C, M__, M_G, M__, M__,
    M_F, M__, M_E, M_D, M__, M_A, M__, M__, M_F, M__, M_E, M_D, M__, M_A, M__, M__,
    M_G, M__, M_F, M_E, M__, M_B, M__, M__, M_G, M__, M_F, M_E, M__, M_B, M__, M__,
    M_C6, M__, M_B, M_A, M_G, M_F, M_E, M_D, M_C, M__, M__, M__, M__, M__, M__, M__
};
const uint16_t trk_mel_1[64] = {
    M_E, M__, M_E, M__, M_D, M_C, M_G, M__, M_E, M__, M_D, M_C, M__, M_G, M__, M__,
    M_F, M__, M_F, M__, M_E, M_D, M_A, M__, M_F, M__, M_E, M_D, M__, M_A, M__, M__,
    M_G, M__, M_G, M__, M_F, M_E, M_B, M__, M_G, M__, M_F, M_E, M__, M_B, M__, M__,
    M_C6, M_G, M_A, M_B, M_C6, M__, M__, M__, M_C, M__, M__, M__, M__, M__, M__, M__
};
const uint16_t trk_mel_2[64] = {
    M_A, M__, M_C6, M_A, M_F, M__, M__, M__, M_A, M__, M_C6, M_A, M_F, M__, M__, M__,
    M_B, M__, M_D6, M_B, M_G, M__, M__, M__, M_B, M__, M_D6, M_B, M_G, M__, M__, M__,
    M_GS, M__, M_B, M_GS, M_E, M__, M__, M__, M_GS, M__, M_B, M_GS, M_E, M__, M__, M__,
    M_A, M__, M_C6, M_A, M_E, M__, M__, M__, M_A, M__, M_A, M__, M_A, M__, M_A, M__
};
const uint16_t trk_mel_3[64] = {
    M_A, M__, M_G, M_F, M__, M_C6, M__, M__, M_A, M__, M_G, M_F, M__, M_C6, M__, M__,
    M_B, M__, M_A, M_G, M__, M_D6, M__, M__, M_B, M__, M_A, M_G, M__, M_D6, M__, M__,
    M_E6, M__, M_D6, M_C6, M_B, M_A, M_G, M_F, M_E, M_D, M_C, M__, M__, M__, M__, M__,
    M_C, M__, M_D, M__, M_E, M__, M_G, M__, M_C6, M__, M__, M__, M__, M__, M__, M__
};
const uint16_t* const mel_parts[4] = { trk_mel_0, trk_mel_1, trk_mel_2, trk_mel_3 };

// ==========================================
// TRACK 3: BASS (CH3 - Wave)
// ==========================================
#define B_C N_C4
#define B_D N_D4
#define B_E N_E4
#define B_F N_F4
#define B_G N_G4
#define B_GS N_GS4
#define B_A N_A4
#define B_B N_B4
#define B_C5 N_C5
#define B_E5 N_E5
#define B__ N_REST

const uint16_t trk_bass_0[64] = {
    B_C, B__, B_C, B__, B_E, B__, B_G, B__, B_C, B__, B_C, B__, B_G, B__, B_E, B__,
    B_F, B__, B_F, B__, B_A, B__, B_C5, B__, B_F, B__, B_F, B__, B_C5, B__, B_A, B__,
    B_G, B__, B_G, B__, B_B, B__, B_D, B__, B_G, B__, B_G, B__, B_D, B__, B_B, B__,
    B_C, B__, B_C, B__, B_E, B__, B_G, B__, B_C, B__, B_E, B__, B_G, B__, B_C5, B__
};
const uint16_t trk_bass_1[64] = {
    B_C, B__, B_C, B__, B_E, B__, B_G, B__, B_C, B__, B_C, B__, B_G, B__, B_E, B__,
    B_F, B__, B_F, B__, B_A, B__, B_C5, B__, B_F, B__, B_F, B__, B_C5, B__, B_A, B__,
    B_G, B__, B_G, B__, B_B, B__, B_D, B__, B_G, B__, B_G, B__, B_D, B__, B_B, B__,
    B_C, B__, B_C, B__, B_E, B__, B_G, B__, B_C, B__, B__, B__, B__, B__, B__, B__
};
const uint16_t trk_bass_2[64] = {
    B_F, B__, B_A, B__, B_C5, B__, B_A, B__, B_F, B__, B_A, B__, B_C5, B__, B_A, B__,
    B_G, B__, B_B, B__, B_D, B__, B_B, B__, B_G, B__, B_B, B__, B_D, B__, B_B, B__,
    B_E, B__, B_GS, B__, B_B, B__, B_GS, B__, B_E, B__, B_GS, B__, B_B, B__, B_GS, B__,
    B_A, B__, B_C5, B__, B_E5, B__, B_C5, B__, B_A, B__, B__, B__, B_G, B__, B__, B__
};
const uint16_t trk_bass_3[64] = {
    B_F, B__, B_A, B__, B_C5, B__, B_A, B__, B_F, B__, B_A, B__, B_C5, B__, B_A, B__,
    B_G, B__, B_B, B__, B_D, B__, B_B, B__, B_G, B__, B_B, B__, B_D, B__, B_B, B__,
    B_C, B__, B_E, B__, B_G, B__, B_E, B__, B_C, B__, B_E, B__, B_G, B__, B_E, B__,
    B_C, B__, B_G, B__, B_C5, B__, B_G, B__, B_C, B__, B__, B__, B__, B__, B__, B__
};
const uint16_t* const bass_parts[4] = { trk_bass_0, trk_bass_1, trk_bass_2, trk_bass_3 };

const uint8_t wave_ram[16] = {
    0x02, 0x46, 0x8A, 0xCE, 0xFF, 0xFE, 0xEC, 0xA8,
    0x64, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};

// ==========================================
// TRACK 4: DRUMS (CH4 - Noise)
// ==========================================
const uint8_t trk_drum_0[64] = {
    1, 3, 3, 3, 2, 3, 3, 3, 1, 3, 3, 3, 2, 3, 3, 3,
    1, 3, 3, 3, 2, 3, 3, 3, 1, 3, 1, 3, 2, 3, 3, 3,
    1, 3, 3, 3, 2, 3, 3, 3, 1, 3, 3, 3, 2, 3, 3, 3,
    1, 3, 3, 3, 2, 3, 3, 3, 1, 1, 3, 3, 2, 2, 1, 1
};
const uint8_t trk_drum_1[64] = {
    1, 3, 3, 3, 2, 3, 3, 3, 1, 3, 3, 3, 2, 3, 3, 3,
    1, 3, 3, 3, 2, 3, 3, 3, 1, 3, 1, 3, 2, 3, 3, 3,
    1, 3, 3, 3, 2, 3, 3, 3, 1, 3, 3, 3, 2, 3, 3, 3,
    1, 3, 3, 3, 2, 3, 3, 3, 1, 2, 1, 2, 1, 2, 1, 2
};
const uint8_t trk_drum_2[64] = {
    1, 3, 3, 3, 2, 3, 3, 3, 1, 3, 3, 3, 2, 3, 3, 3,
    1, 3, 3, 3, 2, 3, 3, 3, 1, 3, 1, 3, 2, 3, 3, 3,
    1, 3, 3, 3, 2, 3, 3, 3, 1, 3, 3, 3, 2, 3, 3, 3,
    1, 3, 3, 3, 2, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2
};
const uint8_t trk_drum_3[64] = {
    1, 3, 1, 3, 2, 3, 1, 3, 1, 3, 1, 3, 2, 3, 1, 3,
    1, 3, 1, 3, 2, 3, 1, 3, 1, 3, 1, 3, 2, 3, 1, 3,
    1, 3, 1, 3, 2, 3, 1, 3, 1, 3, 1, 3, 2, 3, 1, 3,
    1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0
};
const uint8_t* const drum_parts[4] = { trk_drum_0, trk_drum_1, trk_drum_2, trk_drum_3 };

static uint16_t tick = 0;
static uint8_t frame_counter = 0;
static uint8_t sfx_timer = 0;
#define FRAMES_PER_TICK 8 // Velocità del tracker

void play_sfx_moan(void) {
    // Gemito: sweep up e vibrato
    NR10_REG = 0x45; 
    NR11_REG = 0x80;
    NR12_REG = 0xF3; 
    NR13_REG = 0x40;
    NR14_REG = 0x86; 
    sfx_timer = 40; // Blocca CH1 per 40 frame
}

void play_sfx_plop(void) {
    // Plop: tono acuto e brevissimo
    NR10_REG = 0x00;
    NR11_REG = 0x80;
    NR12_REG = 0xF1;
    NR13_REG = 0xFF;
    NR14_REG = 0x87;
    sfx_timer = 15;
}

void init_music(void) {
    // Reset e attivazione master sound
    NR52_REG = 0x00;
    NR52_REG = 0x80;
    NR50_REG = 0x77;
    NR51_REG = 0xFF;
    
    // Inizializza CH3 Wave RAM (0xFF30 - 0xFF3F)
    NR30_REG = 0x00; // Disable DAC
    volatile uint8_t *wave_ptr = (volatile uint8_t *)0xFF30;
    for (uint8_t i = 0; i < 16; i++) {
        wave_ptr[i] = wave_ram[i];
    }
    NR30_REG = 0x80; // Enable DAC
    
    tick = 0;
    frame_counter = 0;
    sfx_timer = 0;
}

void update_music(void) {
    if (sfx_timer > 0) sfx_timer--;
    
    if (frame_counter == 0) {
        
        uint8_t part = (tick >> 6) & 0x03; // tick / 64
        uint8_t sub = tick & 0x3F;         // tick % 64
        
        // --- CH1: Arpeggio ---
        if (sfx_timer == 0) {
            uint16_t f1 = arp_parts[part][sub];
            NR10_REG = 0x00; 
            NR11_REG = 0x80; 
            NR12_REG = 0x51; // Volume basso, decadimento rapido
            NR13_REG = (uint8_t)(f1 & 0xFF);
            NR14_REG = 0x80 | ((f1 >> 8) & 0x07);
        }
        
        // --- CH2: Melody ---
        uint16_t f2 = mel_parts[part][sub];
        if (f2 == N_REST) {
            NR21_REG = 0x00; NR22_REG = 0x00; NR23_REG = 0x00; NR24_REG = 0x80;
        } else {
            NR21_REG = 0x80; 
            NR22_REG = 0xF2; // Volume alto
            NR23_REG = (uint8_t)(f2 & 0xFF);
            NR24_REG = 0x80 | ((f2 >> 8) & 0x07);
        }
        
        // --- CH3: Bass ---
        uint16_t f3 = bass_parts[part][sub];
        if (f3 == N_REST) {
            NR32_REG = 0x00; // Vol 0
            NR34_REG = 0x80;
        } else {
            NR32_REG = 0x20; // Vol 100%
            NR33_REG = (uint8_t)(f3 & 0xFF);
            NR34_REG = 0x80 | ((f3 >> 8) & 0x07);
        }
        
        // --- CH4: Drums ---
        uint8_t d4 = drum_parts[part][sub];
        if (d4 == 1) { // Kick
            NR41_REG = 0x00;
            NR42_REG = 0xF1;
            NR43_REG = 0x11;
            NR44_REG = 0x80;
        } else if (d4 == 2) { // Snare
            NR41_REG = 0x00;
            NR42_REG = 0xF2;
            NR43_REG = 0x51;
            NR44_REG = 0x80;
        } else if (d4 == 3) { // Hi-Hat
            NR41_REG = 0x00;
            NR42_REG = 0x51;
            NR43_REG = 0x21;
            NR44_REG = 0x80;
        }
        
        // Avanza il tracker
        tick++;
        if (tick >= 256) tick = 0; // Loop completo
        
        frame_counter = FRAMES_PER_TICK;
    } else {
        frame_counter--;
    }
}
