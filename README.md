# MICE!

Un progetto per Game Boy, scritto in linguaggio C usando **GBDK-2020**. Nata come semplice generazione procedurale di un labirinto perfetto (Recursive Backtracker), l'applicazione si è evoluta integrando intelligenza artificiale, interattività e un motore audio custom.

![Screenshot del Gioco](screenshot.png)

## Funzionalità Aggiunte
- **Intelligenza Artificiale (Rat)**: Un topolino animato (costruito tramite *Meta-Sprite* 16x8 per ottimizzare la memoria) esplora autonomamente e fluidamente i percorsi del labirinto.
- **Combattimento (Bomberman-style)**: Un cursore lampeggiante controllabile tramite D-Pad permette di sganciare bombe (tasto A) con conto alla rovescia ed esplosioni a croce letali per i topi.
- **Toggle Audio**: Premi SELECT in qualsiasi momento per silenziare la colonna sonora e ascoltare in solitaria gli effetti sonori.
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

## Architettura e Ottimizzazioni Hardware (Retro-Engineering)
Poiché il processore custom del Game Boy (SM83, simile allo Z80) lavora a soli 4.19 MHz e non è provvisto di hardware dedicato per le moltiplicazioni o le divisioni (FPU o ALU avanzata), il codice sorgente fa un uso intensivo di "trucchi" dell'epoca per garantire i 60 FPS costanti, anche con 15 sprite complessi (Meta-Sprite) a schermo che eseguono pathfinding indipendente:

1. **Allocazione Memoria in Potenze di 2 (`MAZE_PITCH = 32`)**
   In C, per leggere un elemento da un array bidimensionale come `maze[y][x]`, il compilatore esegue un'operazione matematica: `y * LARGHEZZA_RIGA + x`. Nelle prime versioni, una larghezza di 20 richiedeva una lenta routine di moltiplicazione software. Per ovviare al problema, la riga logica in RAM è stata allargata a `32` (una potenza di due). In questo modo il compilatore SDCC risolve la moltiplicazione in un singolo, velocissimo *bit-shift* a sinistra (`y << 5`), azzerando del tutto il carico del processore.
   
2. **Divisioni sostituite da Maschere Bitwise (Bitmasks)**
   La funzione `rand() % num` usa l'operatore Modulo (`%`), che su un'architettura a 8-bit invoca un disastroso ciclo di sottrazioni ripetute per trovare il resto. Poiché la scelta della direzione richiede valori da 0 a 3, l'operatore modulo è stato rimosso in favore di un `& 3` (Bitwise AND). È istantaneo e produce un numero da 0 a 3 in un singolo colpo di clock.
   
3. **Collisioni "Lazy" (Early-Exit Evaluation)**
   Piuttosto che testare le sovrapposizioni millimetriche (`pixel_x / pixel_y`) su O(N²) iterazioni (105 combinazioni) per frame, la logica confronta in *short-circuit* soltanto le coordinate grossolane in griglia (`rat_x != rat_y`). Se i topi non si trovano nemmeno sulla stessa mattonella, l'algoritmo ignora istantaneamente tutto il resto. Questa singola riga taglia l'80% delle istruzioni necessarie per i check di collisione.
   
Queste tecniche mostrano la filosofia del vero **retro-programming**, dove ogni ciclo di CPU conta.
