;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Linux)
;--------------------------------------------------------
	.module main
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _update_bombs
	.globl _init_bombs
	.globl _update_cursor
	.globl _init_cursor
	.globl _play_victory_music
	.globl _play_title_music
	.globl _play_game_over_music
	.globl _update_music
	.globl _init_music
	.globl _update_rats
	.globl _init_rats
	.globl _generate_maze
	.globl _rand
	.globl _initrand
	.globl _set_sprite_data
	.globl _set_bkg_tiles
	.globl _set_bkg_data
	.globl _display_off
	.globl _wait_vbl_done
	.globl _reset
	.globl _waitpadup
	.globl _joypad
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_main_prev_keys:
	.ds 1
;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area _DABS (ABS)
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area _HOME
	.area _GSINIT
	.area _GSFINAL
	.area _GSINIT
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;src/main.c:30: void main(void) {
;	---------------------------------
; Function main
; ---------------------------------
_main::
	add	sp, #-15
;src/main.c:35: wait_vbl_done();
	call	_wait_vbl_done
;src/main.c:36: set_bkg_data(0, 256, title_bg_tiles);
	ld	de, #_title_bg_tiles
	push	de
	xor	a, a
	rrca
	push	af
	call	_set_bkg_data
	add	sp, #4
;src/main.c:37: set_bkg_tiles(0, 0, 20, 18, title_bg_map);
	ld	de, #_title_bg_map
	push	de
	ld	hl, #0x1214
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_bkg_tiles
	add	sp, #6
;src/main.c:39: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;src/main.c:40: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/main.c:41: BGP_REG = 0b11100100;
	ld	a, #0xe4
	ldh	(_BGP_REG + 0), a
;src/main.c:44: BGP_REG = 0b11100100;
	ld	a, #0xe4
	ldh	(_BGP_REG + 0), a
;src/main.c:45: OBP0_REG = 0b11100100; // Normale (3=Nero, 2=GrigioS, 1=GrigioC, 0=Trasparente)
	ld	a, #0xe4
	ldh	(_OBP0_REG + 0), a
;src/main.c:46: OBP1_REG = 0b11000000; // Pausa (3=Nero, 2=Bianco, 1=Bianco, 0=Trasparente)
	ld	a, #0xc0
	ldh	(_OBP1_REG + 0), a
;src/main.c:49: play_title_music();
	call	_play_title_music
;src/main.c:50: while (1) {
00104$:
;src/main.c:51: update_music();
	call	_update_music
;src/main.c:52: if (joypad() & J_START) {
	call	_joypad
	rlca
	jr	C, 00105$
;src/main.c:55: wait_vbl_done();
	call	_wait_vbl_done
	jr	00104$
00105$:
;src/main.c:59: waitpadup();
	call	_waitpadup
;src/main.c:62: DISPLAY_OFF;
	call	_display_off
;src/main.c:65: initrand(DIV_REG);
	ldh	a, (_DIV_REG + 0)
	ld	b, #0x00
	ld	c, a
	push	bc
	call	_initrand
	pop	hl
;src/main.c:68: set_bkg_data(0, 22, TileData); // 6 pavimenti + 16 varianti autotile
	ld	de, #_TileData
	push	de
	ld	hl, #0x1600
	push	hl
	call	_set_bkg_data
	add	sp, #4
;src/main.c:71: set_sprite_data(11, 5, PauseTiles); // 5 tile per la pausa (P,A,U,S,E)
	ld	de, #_PauseTiles
	push	de
	ld	hl, #0x50b
	push	hl
	call	_set_sprite_data
	add	sp, #4
;src/main.c:73: for (uint8_t i = 20; i <= 24; i++) {
	ld	c, #0x14
00212$:
	ld	a, #0x18
	sub	a, c
	jr	C, 00106$
;/home/enne2/.local/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	l, c
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	ld	e, l
	ld	d, h
	ld	hl,#_shadow_OAM + 1
	add	hl,de
	inc	hl
	inc	hl
	ld	(hl), #0x10
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
	add	hl, de
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/main.c:73: for (uint8_t i = 20; i <= 24; i++) {
	inc	c
	jr	00212$
00106$:
;src/main.c:79: set_sprite_data(25, 10, NumberTiles);
	ld	de, #_NumberTiles
	push	de
	ld	hl, #0xa19
	push	hl
	call	_set_sprite_data
	add	sp, #4
;src/main.c:83: for (y = 0; y < 32; y++) {
	ld	c, #0x00
;src/main.c:84: for (x = 0; x < 32; x++) {
00228$:
	ld	b, #0x00
00214$:
;src/main.c:85: uint8_t solid_hedge = 21; 
;src/main.c:86: set_bkg_tiles(x, y, 1, 1, &solid_hedge);
	ldhl	sp,#3
	ld	(hl), #0x15
	push	hl
	ld	hl, #0x101
	push	hl
	ld	a, c
	push	af
	inc	sp
	push	bc
	inc	sp
	call	_set_bkg_tiles
	add	sp, #6
;src/main.c:84: for (x = 0; x < 32; x++) {
	inc	b
	ld	a, b
	sub	a, #0x20
	jr	C, 00214$
;src/main.c:83: for (y = 0; y < 32; y++) {
	inc	c
	ld	a, c
	sub	a, #0x20
	jr	C, 00228$
;src/main.c:91: generate_maze();
	call	_generate_maze
;src/main.c:94: for (y = 0; y < MAZE_HEIGHT; y++) {
	ldhl	sp,	#12
	ld	(hl), #0x00
;src/main.c:95: for (x = 0; x < MAZE_WIDTH; x++) {
00242$:
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x10
	ld	a, #0x00
	rla
	ldhl	sp,	#4
	ld	(hl), a
	ldhl	sp,	#13
	ld	(hl), #0x00
00218$:
;src/main.c:96: uint8_t tile_idx = maze[y][x];
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ld	d, #0x00
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, a
	rl	d
	add	a, a
	rl	d
	ld	e, a
	ld	hl, #_maze
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#7
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#6
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#13
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#3
	ld	(hl), a
;src/main.c:97: if (tile_idx == 1) { // Se è un muro, usa autotiling
	dec	a
	jp	NZ, 00125$
;src/main.c:98: uint8_t mask = 0;
	ldhl	sp,	#14
;src/main.c:99: if (y > 0 && maze[y-1][x] == 1) mask |= 8; // Nord
	xor	a, a
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	or	a, a
	jr	Z, 00110$
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0001
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#11
	ld	(hl-), a
	ld	(hl), e
	ld	a, #0x05
00500$:
	ldhl	sp,	#10
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00500$
	ld	de, #_maze
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#13
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	dec	a
	jr	NZ, 00110$
	ldhl	sp,	#14
	ld	(hl), #0x08
00110$:
;src/main.c:100: if (x < MAZE_WIDTH-1 && maze[y][x+1] == 1) mask |= 4; // Est
	ldhl	sp,	#13
	ld	a, (hl)
	ldhl	sp,	#7
	ld	(hl), a
	ldhl	sp,	#13
	ld	a, (hl)
	sub	a, #0x12
	jr	NC, 00113$
	ldhl	sp,	#7
	ld	a, (hl-)
	ld	e, a
	inc	e
	ld	d, #0x00
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	dec	a
	jr	NZ, 00113$
	ldhl	sp,	#14
	ld	a, (hl)
	ld	(hl), a
	set	2, (hl)
00113$:
;src/main.c:101: if (y < MAZE_HEIGHT-1 && maze[y+1][x] == 1) mask |= 2; // Sud
	ldhl	sp,	#4
	ld	a, (hl)
	or	a, a
	jr	Z, 00116$
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl), a
	ld	a, #0x05
00505$:
	ldhl	sp,	#10
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00505$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_maze
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#13
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	dec	a
	jr	NZ, 00116$
	ldhl	sp,	#14
	ld	a, (hl)
	ld	(hl), a
	set	1, (hl)
00116$:
;src/main.c:102: if (x > 0 && maze[y][x-1] == 1) mask |= 1; // Ovest
	ldhl	sp,	#13
	ld	a, (hl)
	or	a, a
	jr	Z, 00119$
	ldhl	sp,	#7
	ld	a, (hl)
	dec	a
	ldhl	sp,	#11
	ld	(hl), a
	ld	e, (hl)
	ld	d, #0x00
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#12
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#11
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	dec	a
	jr	NZ, 00119$
	ldhl	sp,	#14
	ld	a, (hl)
	ld	(hl), a
	set	0, (hl)
00119$:
;src/main.c:103: tile_idx = 6 + mask; // Offset 6 per le siepi
	ldhl	sp,	#14
	ld	a, (hl)
	add	a, #0x06
	ldhl	sp,	#3
	ld	(hl), a
	jr	00126$
00125$:
;src/main.c:106: uint8_t r = rand() % 10;
	call	_rand
	ldhl	sp,#14
	ld	(hl), e
	ld	a, (hl)
	ld	e, #0x0a
	call	__moduchar
	ldhl	sp,#14
	ld	(hl), c
	ld	a, (hl)
;src/main.c:107: if (r < 5) tile_idx = 0;
	cp	a, #0x05
	jr	NC, 00122$
	ldhl	sp,	#3
	ld	(hl), #0x00
	jr	00126$
00122$:
;src/main.c:108: else tile_idx = 1 + (r % 5);
	ld	e, #0x05
	call	__moduchar
	ld	a, c
	inc	a
	ldhl	sp,	#3
	ld	(hl), a
00126$:
;src/main.c:110: set_bkg_tiles(x, y, 1, 1, &tile_idx);
	ld	hl, #3
	add	hl, sp
	push	hl
	ld	hl, #0x101
	push	hl
	ldhl	sp,	#16
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
	push	de
	call	_set_bkg_tiles
	add	sp, #6
;src/main.c:95: for (x = 0; x < MAZE_WIDTH; x++) {
	ldhl	sp,	#13
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x13
	jp	C, 00218$
;src/main.c:94: for (y = 0; y < MAZE_HEIGHT; y++) {
	dec	hl
	inc	(hl)
	ld	a, (hl)
	sub	a, #0x11
	jp	C, 00242$
;/home/enne2/.local/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	ld	a, #0xfc
	ldh	(_SCX_REG + 0), a
	ld	a, #0xfc
	ldh	(_SCY_REG + 0), a
;src/main.c:118: init_rats();
	call	_init_rats
;src/main.c:121: init_cursor();
	call	_init_cursor
;src/main.c:123: init_bombs();
	call	_init_bombs
;src/main.c:126: init_music();
	call	_init_music
;src/main.c:128: SHOW_BKG;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x01
	ldh	(_LCDC_REG + 0), a
;src/main.c:129: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;src/main.c:130: DISPLAY_ON;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x80
	ldh	(_LCDC_REG + 0), a
;src/main.c:133: uint8_t timer_digits[4] = {0, 0, 0, 0};
	ldhl	sp,	#0
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x00
;src/main.c:134: uint8_t timer_frames = 0;
	ldhl	sp,	#14
	ld	(hl), #0x00
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 102)
	ld	(hl), #0x19
	ld	hl, #(_shadow_OAM + 106)
	ld	(hl), #0x19
	ld	hl, #(_shadow_OAM + 110)
	ld	(hl), #0x19
	ld	hl, #(_shadow_OAM + 114)
	ld	(hl), #0x19
;/home/enne2/.local/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	hl, #(_shadow_OAM + 103)
	ld	(hl), #0x10
	ld	hl, #(_shadow_OAM + 107)
	ld	(hl), #0x10
	ld	hl, #(_shadow_OAM + 111)
	ld	(hl), #0x10
	ld	hl, #(_shadow_OAM + 115)
	ld	(hl), #0x10
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 100)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl), #0x98
	inc	hl
	ld	(hl), #0x88
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 104)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl), #0x98
	inc	hl
	ld	(hl), #0x90
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 108)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl), #0x98
	inc	hl
	ld	(hl), #0x98
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 112)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl), #0x98
	inc	hl
	ld	(hl), #0xa0
;src/main.c:154: while (1) {
00162$:
;src/main.c:155: if (game_over_flag || victory_flag) {
	ld	a, (#_game_over_flag)
	or	a, a
	jr	NZ, 00140$
	ld	a, (#_victory_flag)
	or	a, a
	jp	Z, 00141$
00140$:
;src/main.c:156: HIDE_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	and	a, #0xfd
	ldh	(_LCDC_REG + 0), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1461: SCX_REG=x, SCY_REG=y;
	xor	a, a
	ldh	(_SCX_REG + 0), a
	xor	a, a
	ldh	(_SCY_REG + 0), a
;src/main.c:160: BGP_REG = 0b11100100;
	ld	a, #0xe4
	ldh	(_BGP_REG + 0), a
;src/main.c:162: if (victory_flag) {
	ld	a, (#_victory_flag)
	or	a, a
	jr	Z, 00130$
;src/main.c:164: set_bkg_data(0, 256, victory_bg_tiles);
	ld	de, #_victory_bg_tiles
	push	de
	xor	a, a
	rrca
	push	af
	call	_set_bkg_data
	add	sp, #4
;src/main.c:165: set_bkg_tiles(0, 0, 20, 18, victory_bg_map);
	ld	de, #_victory_bg_map
	push	de
	ld	hl, #0x1214
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_bkg_tiles
	add	sp, #6
;src/main.c:166: play_victory_music();
	call	_play_victory_music
	jr	00131$
00130$:
;src/main.c:169: set_bkg_data(0, 256, rat_bg_tiles);
	ld	de, #_rat_bg_tiles
	push	de
	xor	a, a
	rrca
	push	af
	call	_set_bkg_data
	add	sp, #4
;src/main.c:170: set_bkg_tiles(0, 0, 20, 18, rat_bg_map);
	ld	de, #_rat_bg_map
	push	de
	ld	hl, #0x1214
	push	hl
	xor	a, a
	rrca
	push	af
	call	_set_bkg_tiles
	add	sp, #6
;src/main.c:171: play_game_over_music();
	call	_play_game_over_music
00131$:
;src/main.c:174: SHOW_SPRITES;
	ldh	a, (_LCDC_REG + 0)
	or	a, #0x02
	ldh	(_LCDC_REG + 0), a
;src/main.c:175: while(1) {
00138$:
;src/main.c:176: update_music();
	call	_update_music
;src/main.c:178: if (victory_flag) {
	ld	a, (#_victory_flag)
	or	a, a
	jr	Z, 00133$
;src/main.c:180: set_sprite_tile(25, 25 + timer_digits[0]);
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#14
	ld	(hl), a
	ld	a, (hl)
	add	a, #0x19
	ld	c, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 102)
	ld	(hl), c
;src/main.c:181: set_sprite_tile(26, 25 + timer_digits[1]);
	ldhl	sp,	#1
	ld	a, (hl)
	add	a, #0x19
	ld	c, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 106)
	ld	(hl), c
;src/main.c:182: set_sprite_tile(27, 25 + timer_digits[2]);
	ldhl	sp,	#2
	ld	a, (hl)
	add	a, #0x19
	ld	c, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 110)
	ld	(hl), c
;src/main.c:183: set_sprite_tile(28, 25 + timer_digits[3]);
	ldhl	sp,	#3
	ld	a, (hl)
	add	a, #0x19
	ld	c, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 114)
	ld	(hl), c
;/home/enne2/.local/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	hl, #(_shadow_OAM + 103)
	ld	(hl), #0x10
	ld	hl, #(_shadow_OAM + 107)
	ld	(hl), #0x10
	ld	hl, #(_shadow_OAM + 111)
	ld	(hl), #0x10
	ld	hl, #(_shadow_OAM + 115)
	ld	(hl), #0x10
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 100)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	a, #0x90
	ld	(hl+), a
	ld	(hl), #0x44
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 104)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	a, #0x90
	ld	(hl+), a
	ld	(hl), #0x4c
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 108)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	a, #0x90
	ld	(hl+), a
	ld	(hl), #0x54
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 112)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	a, #0x90
	ld	(hl+), a
	ld	(hl), #0x5c
;src/main.c:194: move_sprite(28, 92, 144);
00133$:
;src/main.c:197: wait_vbl_done();
	call	_wait_vbl_done
;src/main.c:198: uint8_t keys = joypad();
	call	_joypad
	ld	c, a
;src/main.c:199: if ((keys & J_START) && !(main_prev_keys & J_START)) {
	bit	7, c
	jr	Z, 00135$
	ld	a, (_main_prev_keys)
	rlca
	jr	C, 00135$
;src/main.c:200: reset();
	push	bc
	call	_reset
	pop	bc
00135$:
;src/main.c:202: main_prev_keys = keys;
	ld	hl, #_main_prev_keys
	ld	(hl), c
	jp	00138$
00141$:
;src/main.c:207: timer_frames++;
	ldhl	sp,	#14
	inc	(hl)
;src/main.c:208: if (timer_frames >= 60) {
	ld	a, (hl)
	sub	a, #0x3c
	jr	C, 00152$
;src/main.c:209: timer_frames = 0;
	ld	(hl), #0x00
;src/main.c:212: timer_digits[3]++;
	ldhl	sp,	#3
	inc	(hl)
	ld	a, (hl)
;src/main.c:213: if (timer_digits[3] > 9) {
	cp	a, #0x0a
	jr	C, 00150$
;src/main.c:214: timer_digits[3] = 0;
;src/main.c:215: timer_digits[2]++;
	xor	a, a
	ld	(hl-), a
	inc	(hl)
	ld	a, (hl)
;src/main.c:216: if (timer_digits[2] > 9) {
	cp	a, #0x0a
	jr	C, 00150$
;src/main.c:217: timer_digits[2] = 0;
;src/main.c:218: timer_digits[1]++;
	xor	a, a
	ld	(hl-), a
	inc	(hl)
	ld	a, (hl)
;src/main.c:219: if (timer_digits[1] > 9) {
	cp	a, #0x0a
	jr	C, 00150$
;src/main.c:220: timer_digits[1] = 0;
;src/main.c:221: timer_digits[0]++;
	xor	a, a
	ld	(hl-), a
	inc	(hl)
	ld	a, (hl)
;src/main.c:222: if (timer_digits[0] > 9) {
	cp	a, #0x0a
	jr	C, 00150$
;src/main.c:224: timer_digits[0] = 9;
;src/main.c:225: timer_digits[1] = 9;
;src/main.c:226: timer_digits[2] = 9;
	ld	a,#0x09
	ld	(hl+),a
	ld	(hl+), a
;src/main.c:227: timer_digits[3] = 9;
	ld	a, #0x09
	ld	(hl+), a
	ld	(hl), #0x09
00150$:
;src/main.c:234: set_sprite_tile(25, 25 + timer_digits[0]);
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, #0x19
	ld	c, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 102)
	ld	(hl), c
;src/main.c:235: set_sprite_tile(26, 25 + timer_digits[1]);
	ldhl	sp,	#1
	ld	a, (hl)
	add	a, #0x19
	ld	c, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 106)
	ld	(hl), c
;src/main.c:236: set_sprite_tile(27, 25 + timer_digits[2]);
	ldhl	sp,	#2
	ld	a, (hl)
	add	a, #0x19
	ld	c, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 110)
	ld	(hl), c
;src/main.c:237: set_sprite_tile(28, 25 + timer_digits[3]);
	ldhl	sp,	#3
	ld	a, (hl)
	add	a, #0x19
	ld	c, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 114)
	ld	(hl), c
;src/main.c:237: set_sprite_tile(28, 25 + timer_digits[3]);
00152$:
;src/main.c:240: uint8_t keys = joypad();
	call	_joypad
;src/main.c:243: if ((keys & J_START) && !(main_prev_keys & J_START)) {
	bit	7, a
	jp	Z, 00159$
	ld	hl, #_main_prev_keys
	ld	h, (hl)
	add	hl, hl
	jp	C, 00159$
;src/main.c:245: NR10_REG = 0x00;
	xor	a, a
	ldh	(_NR10_REG + 0), a
;src/main.c:246: NR11_REG = 0x81;
	ld	a, #0x81
	ldh	(_NR11_REG + 0), a
;src/main.c:247: NR12_REG = 0x43;
	ld	a, #0x43
	ldh	(_NR12_REG + 0), a
;src/main.c:248: NR13_REG = 0x73;
	ld	a, #0x73
	ldh	(_NR13_REG + 0), a
;src/main.c:249: NR14_REG = 0x86;
	ld	a, #0x86
	ldh	(_NR14_REG + 0), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 82)
	ld	(hl), #0x0b
	ld	hl, #(_shadow_OAM + 86)
	ld	(hl), #0x0c
	ld	hl, #(_shadow_OAM + 90)
	ld	(hl), #0x0d
	ld	hl, #(_shadow_OAM + 94)
	ld	(hl), #0x0e
	ld	hl, #(_shadow_OAM + 98)
	ld	(hl), #0x0f
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 80)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	a, #0x58
	ld	(hl+), a
	ld	(hl), #0x44
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 84)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	a, #0x58
	ld	(hl+), a
	ld	(hl), #0x4c
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 88)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	a, #0x58
	ld	(hl+), a
	ld	(hl), #0x54
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 92)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	a, #0x58
	ld	(hl+), a
	ld	(hl), #0x5c
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 96)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	a, #0x58
	ld	(hl+), a
	ld	(hl), #0x64
;src/main.c:263: waitpadup(); // Aspetta che START sia rilasciato
	call	_waitpadup
;src/main.c:265: while (1) {
00156$:
;src/main.c:266: uint8_t p_keys = joypad();
	call	_joypad
;src/main.c:267: if (p_keys & J_START) {
	rlca
	jr	NC, 00154$
;src/main.c:269: NR10_REG = 0x00;
	xor	a, a
	ldh	(_NR10_REG + 0), a
;src/main.c:270: NR11_REG = 0x81;
	ld	a, #0x81
	ldh	(_NR11_REG + 0), a
;src/main.c:271: NR12_REG = 0x43;
	ld	a, #0x43
	ldh	(_NR12_REG + 0), a
;src/main.c:272: NR13_REG = 0x73;
	ld	a, #0x73
	ldh	(_NR13_REG + 0), a
;src/main.c:273: NR14_REG = 0x86;
	ld	a, #0x86
	ldh	(_NR14_REG + 0), a
;src/main.c:274: break; // Esci dalla pausa
	jr	00157$
00154$:
;src/main.c:277: wait_vbl_done();
	call	_wait_vbl_done
	jr	00156$
00157$:
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 80)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 84)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 88)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 92)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 96)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/main.c:287: waitpadup(); // Aspetta il rilascio
	call	_waitpadup
;src/main.c:288: keys = joypad(); // Rileggi per evitare salti
	call	_joypad
00159$:
;src/main.c:290: main_prev_keys = keys;
	ld	(#_main_prev_keys),a
;src/main.c:293: update_music();
	call	_update_music
;src/main.c:296: update_rats();
	call	_update_rats
;src/main.c:299: update_cursor();
	call	_update_cursor
;src/main.c:302: update_bombs();
	call	_update_bombs
;src/main.c:305: wait_vbl_done();
	call	_wait_vbl_done
	jp	00162$
;src/main.c:307: }
	add	sp, #15
	ret
	.area _CODE
	.area _INITIALIZER
__xinit__main_prev_keys:
	.db #0x00	; 0
	.area _CABS (ABS)
