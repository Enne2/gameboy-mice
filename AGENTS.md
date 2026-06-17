# AGENTS.md — gameboy-hello

Knowledge base for this Game Boy Hello World project and related tools/workflow.

## Project overview

- **Repository**: `ssh://git@git.enne2.net:222/enne2/gameboy-hello.git`
- **Local path**: `/home/enne2/Development/gameboy-hello`
- **Goal**: Minimal Game Boy "Hello World" using GBDK-2020 (C) and headless verification with PyBoy.
- **Artifacts**:
  - `main.c` — C source (`<gb/gb.h>`, `<stdio.h>`, `printf("Hello Game Boy!")`).
  - `Makefile` — builds `hello.gb` with `/home/enne2/.local/gbdk/bin/lcc`.
  - `hello.gb` — generated 32 KB Game Boy ROM.
  - `README.md` — user-facing build/run instructions.
  - This `AGENTS.md` — captured knowledge for coding agents.

## Game Boy development stack

### Toolchain: GBDK-2020

- **Location**: `/home/enne2/.local/gbdk` (downloaded from GitHub release, no system install needed).
- **Compiler frontend**: `/home/enne2/.local/gbdk/bin/lcc`
- **Typical flags used**:
  - `-Wl-yt1` — MBC type 1 (ROM only).
  - `-Wl-ya4` — 4 RAM banks.
- **Build command**:
  ```bash
  cd /home/enne2/Development/gameboy-hello
  make
  ```
- **Important**: GBDK C is compiled to SM83/Z80-like assembly by SDCC. It is higher-level than RGBDS assembly but slower and with larger ROM footprint. Critical sections can still be written in assembly if needed.

### Hello World source pattern

```c
#include <gb/gb.h>
#include <stdio.h>

void main(void) {
    printf("Hello Game Boy!");
    while (1) {
        wait_vbl_done();
    }
}
```

- `wait_vbl_done()` synchronizes with the vertical blank interval; always call inside the main loop.
- `printf` renders to the Game Boy's text console/tilemap area.

### Emulation / verification

- **PyBoy** installed via `pip install --user pyboy`.
- **Headless screenshot test** (useful for CI/agent verification):
  ```python
  from pyboy import PyBoy
  pyboy = PyBoy('hello.gb', window='null')
  for _ in range(60 * 5):
      pyboy.tick()
  pyboy.screen.image.save('/tmp/hello_gb.png')
  pyboy.stop()
  ```
- **SDL2 window test**:
  ```python
  from pyboy import PyBoy
  pyboy = PyBoy('hello.gb', window='SDL2')
  for _ in range(60 * 30):
      pyboy.tick()
  pyboy.stop()
  ```
- ROM validation: check Nintendo logo at offset `0x104` (48 bytes) and header checksum at `0x14D`.

## Game Boy hardware limits (relevant for future expansion)

- **CPU**: Sharp SM83 @ ~4.19 MHz (Z80-like).
- **VRAM**: 8 KB; only writable during VBlank/HBlank.
- **OAM sprites**: max 40 total, max 10 per scanline.
- **Tilemap**: 20×18 visible or 32×32 total.
- **Audio**: 4 channels (2 square, 1 wave, 1 noise).
- **Cartridge MBC**: this project uses MBC1 with `-Wl-yt1 -Wl-ya4`.

## Reverse-engineering Tetris (original Game Boy)

Learned from `kaspermeerts/tetris` disassembly and other sources:

- **Piece representation**: each piece is a 4-block sprite rendered into OAM; rotation is selected by the lowest 2 bits of a state byte (4 pre-rotated sprites per piece type).
- **Rotation logic**: `RotateAndShiftPiece` increments/decrements orientation, renders into OAM buffer, calls `DetectCollision`, and **cancels the rotation on collision** (no SRS-style wall kicks).
- **Collision detection**: done on the rendered OAM sprites by looking up background tiles; a non-space tile means collision.
- **Randomizer (`PickRandomPiece`)**: uses `rDIV` hardware divider as entropy and rerolls up to 3 times if the new piece matches the previous one (history of 1). It is NOT a modern 7-bag randomizer.
- **DAS (Delayed Auto Shift)**: 23 frames before auto-repeat, then 9 frames per repeat.
- **Scoring**: BCD arithmetic, level-dependent multipliers.
- **Bugs/trivia**:
  - Top two rows can never be cleared (only 16 of 18 rows are checked).
  - When clearing multiple lines, the top row is duplicated below — likely an oversight.
  - Demo recording code exists but is unused.

## pi-hitl-programming extension knowledge

- **Goal**: Human-in-the-Loop gate for `write`/`edit` on programming/config files.
- **Source**: `/home/enne2/Development/pi-hitl/src/index.ts`
- **Behavior**:
  - Intercepts `write`/`edit` for file extensions like `.py`, `.js`, `.ts`, `.c`, `.cpp`, `.go`, `.rs`, `.sh`, `.html`, `.css`, `.json`, `.yaml`, `.toml`, `.md`, etc.
  - Generates a short LLM explanation of the proposed code.
  - Shows a scrollable panel with explanation + proposed code.
  - Lets user choose: Accept / Modify / Discuss / Reject.
  - Can be toggled with `F10` or `/hitl on|off`.
- **Lessons learned**:
  - Long explanations cause UI flashing and scrolling issues; keep explanation prompt to 5–6 lines.
  - Use fixed-height scrollable panel for code preview; avoid full-screen expansion.
  - Avoid `PageUp`/`PageDown` bindings that may crash; use `Ctrl+U`/`Ctrl+D` instead.
  - Pass the full source code (up to 60k chars) to the LLM for explanation, not only the TUI preview.

## General workflow rules

- When writing or modifying files, always use the `write` or `edit` tool; never use shell redirections to bypass HITL review.
- For C/C++ code, `<` in content may be truncated by certain providers; use placeholder replacement if needed.
- Prefer `python3 -m py_compile` for quick syntax checks on Python scripts.
- Use `tmux` for interactive TUI tests when the agent cannot open a real terminal.

## Follow-up ideas

- Expand this project into a real Game Boy Tetris faithful to the original:
  - Use sprite OAM for pieces (4 blocks per piece).
  - Implement the original orientation-based rotation and collision cancel logic.
  - Replicate the original `rDIV`-based randomizer with 1-history reroll.
  - Add DAS, BCD scoring, and proper line-clear behavior.
