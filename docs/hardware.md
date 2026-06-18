# Hardware Game Boy DMG

Capire i vincoli dell'hardware è indispensabile per capire ogni scelta architetturale del codice. Il Game Boy DMG del 1989 è una macchina meravigliosamente vincolata.

---

## CPU: Sharp SM83

Il processore è una via di mezzo tra lo Z80 e l'Intel 8080, con un set di istruzioni ridotto.

| Proprietà | Valore |
|-----------|--------|
| **Architettura** | 8-bit (con registri a 16-bit per indirizzi) |
| **Clock** | ~4.194304 MHz |
| **Moltiplicazione hardware** | ❌ Assente |
| **Divisione hardware** | ❌ Assente |
| **Virgola mobile (FPU)** | ❌ Assente |
| **Stack** | 16-bit, in HRAM o WRAM |
| **Registri generali** | A, B, C, D, E, H, L (più F flags) |

!!! warning "Niente moltiplicazioni!"
    Qualsiasi `a * b` in C viene compilato da SDCC in una subroutine di addizioni ripetute.
    Su questo hardware, `y * 19` può richiedere **20+ cicli di clock**. Il codice di MICE!
    usa esclusivamente potenze di 2 (`y << 5`) per eliminare questo costo.

---

## Memoria

```
0x0000 - 0x3FFF  ROM Bank 0     (16 KB, fisso)
0x4000 - 0x7FFF  ROM Bank 1+    (16 KB, switchable via MBC)
0x8000 - 0x9FFF  VRAM           (8 KB)
  0x8000 - 0x97FF  Tile Data    (384 tile × 16 byte = 6144 byte)
  0x9800 - 0x9BFF  BG Map 0     (32×32 tile)
  0x9C00 - 0x9FFF  BG Map 1     (32×32 tile)
0xA000 - 0xBFFF  External RAM   (cartuccia, non usata)
0xC000 - 0xDFFF  WRAM           (8 KB)
0xFE00 - 0xFE9F  OAM            (160 byte = 40 sprite × 4 byte)
0xFF00 - 0xFF7F  I/O Registers
0xFF80 - 0xFFFE  HRAM           (127 byte, velocissima)
```

!!! info "VRAM e accesso sicuro"
    La VRAM è accessibile **solo durante HBlank o VBlank**. GBDK gestisce questo
    automaticamente tramite la funzione `wait_vbl_done()` che il game loop chiama
    ogni frame per sincronizzarsi con il VBlank.

---

## Video: PPU (Pixel Processing Unit)

| Parametro | Valore |
|-----------|--------|
| **Risoluzione** | 160×144 pixel |
| **Colori** | 4 sfumature di grigio (palette software 2bpp) |
| **Tile size** | 8×8 pixel, 2 bit per pixel |
| **Tile in VRAM** | 256 (modalità $8000) o 256 (modalità $8800) |
| **Background map** | 32×32 tile (256×256 px), visibile 20×18 |
| **Sprite (OAM)** | Max **40 totali**, max **10 per scanline** |
| **Sprite size** | 8×8 o 8×16 (configurabile via LCDC) |
| **Layer** | Background + Window + Sprites |

### Palette Hardware

Il Game Boy non ha "colori" — ha 4 livelli di intensità per layer. Le palette sono configurate via registri:

```c
BGP_REG  = 0b11100100; // BG:    3=Nero, 2=Grigio Sc., 1=Grigio Ch., 0=Bianco
OBP0_REG = 0b11100100; // Sprite palette 0 (topi, cursore)
OBP1_REG = 0b11000000; // Sprite palette 1 (timer HUD - inverte contrasto)
```

Il bit 0 di ogni sprite in OAM seleziona quale palette usare (`S_PALETTE` flag).

---

## Audio: APU (Audio Processing Unit)

L'APU del Game Boy ha **4 canali** indipendenti, ciascuno controllato da registri hardware mappati in memoria.

| Canale | Tipo | Registri | Uso in MICE! |
|--------|------|----------|--------------|
| **CH1** | Square Wave con Sweep | NR10–NR14 | Arpeggio melodico |
| **CH2** | Square Wave | NR21–NR24 | Melodia principale |
| **CH3** | Wave RAM (forma d'onda custom) | NR30–NR34 + 0xFF30 | Basso |
| **CH4** | Noise (LFSR) | NR41–NR44 | Percussioni + SFX |

### Frequenza Note

Le note musicali vengono codificate come valori di frequenza nei registri `NR_3` (low byte) e `NR_4` (high 3 bit):

```
f_reg = 2048 - (131072 / Hz)
```

Esempio per C4 (261.63 Hz):

```c
#define N_C4  0x60B   // = 2048 - (131072 / 261.63) ≈ 0x60B
```

---

## OAM: Object Attribute Memory

Ogni sprite occupa **4 byte** nell'OAM:

| Byte | Contenuto |
|------|-----------|
| 0 | Y position (schermo + 16) |
| 1 | X position (schermo + 8) |
| 2 | Tile index (in VRAM sprite tiles) |
| 3 | Flags (palette, flip X/Y, priorità) |

Uno sprite è "nascosto" posizionandolo a coordinate `(0, 0)` — fuori dall'area visibile
(lo schermo inizia a Y=16, X=8 in coordinate OAM assolute).

```c
// Nascondere uno sprite in GBDK
move_sprite(sprite_index, 0, 0);
```

!!! danger "Limite 10 sprite per scanline"
    Se più di 10 sprite si trovano sulla stessa riga orizzontale (scanline),
    gli ultimi vengono semplicemente ignorati dalla PPU. In MICE! i topi sono
    disposti verticalmente nel labirinto per ridurre la probabilità di conflitti.
