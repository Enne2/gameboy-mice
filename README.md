# Game Boy Maze Generator & Rat Hunt

Un progetto per Game Boy, scritto in linguaggio C usando **GBDK-2020**. Nata come semplice generazione procedurale di un labirinto perfetto (Recursive Backtracker), l'applicazione si è evoluta integrando intelligenza artificiale, interattività e un motore audio custom.

![Screenshot del Gioco](screenshot.png)

## Funzionalità Aggiunte
- **Intelligenza Artificiale (Rat)**: Un topolino animato (costruito tramite *Meta-Sprite* 16x8 per ottimizzare la memoria) esplora autonomamente e fluidamente i percorsi del labirinto.
- **Cursore Interattivo (Giocatore)**: Un cursore lampeggiante controllabile dal giocatore tramite il D-Pad. Pone le basi per le meccaniche future di caccia al topo (piazzamento bombe).
- **Tracker Musicale a 4 Canali**: Una sontuosa colonna sonora chiptune generata da un sequencer nativo scritto in C, senza l'uso di engine esterni. Sfrutta l'onda quadra, la Wave RAM customizzata per il basso, e il Noise per le percussioni, ruotando su una traccia in quattro parti da ~35 secondi.

## Struttura del Progetto
Al fine di mantenere un codice ordinato, pulito ed espandibile, i sorgenti sono stati suddivisi:

- `src/` : Contiene tutto il codice sorgente del gioco.
  - `main.c`: Entry point, loop principale, inizializzazione hardware e rendering (scrolling).
  - `maze.c` / `maze.h`: Core algoritmico per la generazione del labirinto.
  - `rat.c` / `rat.h`: Logica dell'automa e gestione degli sprite hardware per l'animazione del topo.
  - `cursor.c` / `cursor.h`: Logica interattiva del selettore del giocatore.
  - `music.c` / `music.h`: Mini-tracker musicale, sequencer e definizione dei registri audio.
  - `tiles.c` / `tiles.h`: Dichiarazione e definizione della grafica dei tile utilizzati.
- `obj/` : Cartella autogenerata durante il processo di compilazione per immagazzinare i file intermedi (`.o` e metadati).
- `tests/` : Script e utilities di testing.
  - `test_pyboy.py`: Esegue l'emulatore PyBoy in modalità headless, salvando la prova del funzionamento in un'immagine temporanea.
- `Makefile` : Sistema di build preconfigurato per GBDK-2020.
- `maze.gb` : La ROM finale giocabile (generata dopo il build).
- `test_audio.gb` / `test_audio.c`: Micro-rom dedicata alla diagnostica dell'hardware sonoro.

## Come Compilare
Assicurati di aver installato la toolchain **GBDK-2020** nel path corretto (solitamente configurato su `~/.local/gbdk` in base a questo repository).
Per compilare la ROM, basterà lanciare:
```bash
make
```

## Come Testare
Se vuoi validare la compilazione senza aprire GUI o se sei su un server remoto, puoi lanciare lo script headless:
```bash
python3 tests/test_pyboy.py
```
Questo genererà un file PNG in locale (`/tmp/maze_gb.png`) per farti visualizzare l'output atteso della ROM. Puoi anche testare le ROM su emulatori diretti da terminale come `pyboy maze.gb`.
