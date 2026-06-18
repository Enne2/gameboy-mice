# MICE! — Documentazione Tecnica

Benvenuto nella documentazione tecnica di **MICE!**, un gioco completo per **Game Boy DMG (1989)** scritto interamente in C con la toolchain [GBDK-2020](https://github.com/gbdk-2020/gbdk-2020).

![Schermata Titolo e Gameplay](../screenshot.png)

---

## Cos'è MICE!

MICE! è un gioco di strategia in tempo reale a schermata fissa. Il labirinto viene generato proceduralmente ad ogni partita. Il giocatore controlla un cursore di mira e deve eliminare tutti i topi prima che il tempo scada. I topi si muovono autonomamente, trovano percorsi nel labirinto e si riproducono se si incontrano.

### Meccaniche principali

| Meccanica | Descrizione |
|-----------|-------------|
| **Generazione labirinto** | Recursive Backtracker iterativo, sempre risolvibile |
| **AI topi** | Pathfinding casuale senza backtracking, spatial hash per collisioni |
| **Riproduzione** | Spawn di un cucciolo a ogni incontro tra topi adulti |
| **Bomba (A)** | Esplosione a croce che si propaga lungo tutto il corridoio |
| **Fucile (B)** | Sparo istantaneo con cooldown di 3 secondi |
| **Timer** | Countdown visualizzato come HUD sprite nella barra inferiore |
| **Musica** | Tracker chiptune 4 canali nativo, jingle dedicati per vittoria/sconfitta |

---

## Struttura della Documentazione

| Sezione | Contenuto |
|---------|-----------|
| [Hardware Game Boy](hardware.md) | Vincoli fisici: SM83, VRAM, OAM, APU |
| [Architettura Moduli](architecture.md) | Grafico dei moduli C e dipendenze |
| [Loop Principale](main_loop.md) | Sequenza di inizializzazione e game loop |
| [Generazione Labirinto](maze.md) | Algoritmo Recursive Backtracker, MAZE_PITCH |
| [AI dei Topi](ai.md) | Movimento, pathfinding, riproduzione, spatial hash |
| [Rendering e Autotiling](rendering.md) | Tile system, bitmask 4-bit, hardware scrolling |
| [Sprite e OAM](sprites.md) | Allocazione 40 sprite hardware, meta-sprite 16×8 |
| [Armi e Gameplay](weapons.md) | Cursore DAS, bomba propagante, fucile con cooldown |
| [Audio](audio.md) | Mini-tracker 4 canali, SFX, Wave RAM |
| [Pipeline Asset](assets.md) | Script Python, conversione PNG → header C 2bpp |
| [Ottimizzazioni](optimizations.md) | Riepilogo di tutte le tecniche di ottimizzazione |

---

## Quick Start

```bash
# Compila tutto
make

# Gioca
pyboy -w SDL2 -s 3 --sound-volume 100 maze.gb

# Test audio interattivo
pyboy -w SDL2 -s 3 --sound-volume 100 test_audio.gb

# Validazione headless
python3 tests/test_pyboy.py
```

---

## Dati Tecnici

| Parametro | Valore |
|-----------|--------|
| **Target hardware** | Nintendo Game Boy DMG (1989) |
| **Toolchain** | GBDK-2020 + SDCC |
| **Linguaggio** | C (SM83/Z80-compatible) |
| **ROM size** | 32 KB (MBC1 `0x00`, solo ROM) |
| **Tile in VRAM** | 256 tile 8×8 @ 2bpp |
| **Sprite OAM** | 40 slot hardware (8×8 px ciascuno) |
| **RAM disponibile** | 8 KB (WRAM) |
| **FPS target** | 60 Hz (sincronizzato su VBlank) |
| **Frequenza CPU** | ~4.19 MHz |
