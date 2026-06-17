# Game Boy Hello World

Questa sottocartella contiene un minimo esempio di "Hello World" per Game Boy originale, compilato con **GBDK-2020** in C.

## Struttura

- `main.c` — sorgente C.
- `Makefile` — regola per compilare con `lcc` (GBDK-2020).
- `hello.gb` — ROM Game Boy risultante (32 KB).

## Requisiti

GBDK-2020 e installato in `/home/enne2/.local/gbdk`. Se vuoi spostarlo altrove, aggiorna il `CC` nel `Makefile`.

## Build

```bash
cd gameboy-hello
make
```

## Test con emulatore

### PyBoy (senza finestra, screenshot)

```bash
python3 - <<'PY'
from pyboy import PyBoy
rom = 'hello.gb'
pyboy = PyBoy(rom, window='null')
for _ in range(60*5):
    pyboy.tick()
pyboy.screen.image.save('/tmp/hello_gb.png')
pyboy.stop()
print('Screenshot salvato in /tmp/hello_gb.png')
PY
```

### PyBoy (con finestra SDL2)

```bash
python3 - <<'PY'
from pyboy import PyBoy
pyboy = PyBoy('hello.gb', window='SDL2')
for _ in range(60*30):
    pyboy.tick()
pyboy.stop()
PY
```

## Note

- La ROM usa il logo Nintendo corretto e il checksum di header e valido.
- Il testo viene visualizzato con `printf` sulla console testuale del Game Boy.
- Il loop principale chiama `wait_vbl_done()` per sincronizzarsi con il VBlank.

## Prossimi passi

Da qui si puo partire per un vero gioco Game Boy (ad esempio Tetris), aggiungendo:
- gestione di input tramite `joypad()`;
- sprite OAM per i pezzi;
- tilemap per il campo di gioco;
- musica/effetti sonori con i 4 canali audio del Game Boy.
