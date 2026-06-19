;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Linux)
;--------------------------------------------------------
	.module rat
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _spawn_rat
	.globl _rand
	.globl _set_sprite_data
	.globl _play_sfx_plop
	.globl _play_sfx_moan
	.globl _victory_flag
	.globl _game_over_flag
	.globl _RatSpriteData
	.globl _init_rats
	.globl _update_rats
	.globl _kill_rats_at
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_rats:
	.ds 120
_update_rats_frame_counter_10000_262:
	.ds 1
_update_rats_single_rat_timer_10000_262:
	.ds 2
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_game_over_flag::
	.ds 1
_victory_flag::
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
;src/rat.c:148: static uint8_t frame_counter = 0;
;src/rat.c:149: static uint16_t single_rat_timer = 0;
	xor	a, a
	ld	(#_update_rats_frame_counter_10000_262), a
	ld	hl, #_update_rats_single_rat_timer_10000_262
	ld	(hl+), a
	ld	(hl), a
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area _HOME
	.area _HOME
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area _CODE
;src/rat.c:38: static uint8_t get_opposite(uint8_t dir) {
;	---------------------------------
; Function get_opposite
; ---------------------------------
_get_opposite:
;src/rat.c:39: if (dir == 0) return 1;
	or	a, a
	jr	NZ, 00102$
	ld	a, #0x01
	ret
00102$:
;src/rat.c:40: if (dir == 1) return 0;
	cp	a, #0x01
	jr	NZ, 00104$
	xor	a, a
	ret
00104$:
;src/rat.c:41: if (dir == 2) return 3;
	cp	a, #0x02
	jr	NZ, 00106$
	ld	a, #0x03
	ret
00106$:
;src/rat.c:42: if (dir == 3) return 2;
	sub	a, #0x03
;src/rat.c:43: return 255;
	ld	a, #0x02
	ret	Z
	ld	a, #0xff
;src/rat.c:44: }
	ret
_RatSpriteData:
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x3f	; 63
	.db #0x38	; 56	'8'
	.db #0x5e	; 94
	.db #0x71	; 113	'q'
	.db #0x5b	; 91
	.db #0x74	; 116	't'
	.db #0x3f	; 63
	.db #0x38	; 56	'8'
	.db #0x07	; 7
	.db #0x07	; 7
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0xc8	; 200
	.db #0x08	; 8
	.db #0xd4	; 212
	.db #0x1c	; 28
	.db #0xd4	; 212
	.db #0x1c	; 28
	.db #0xc8	; 200
	.db #0x08	; 8
	.db #0xf0	; 240
	.db #0xf0	; 240
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x24	; 36
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x3c	; 60
	.db #0x24	; 36
	.db #0x6e	; 110	'n'
	.db #0x52	; 82	'R'
	.db #0x7e	; 126
	.db #0x42	; 66	'B'
	.db #0x76	; 118	'v'
	.db #0x4a	; 74	'J'
	.db #0x7e	; 126
	.db #0x42	; 66	'B'
	.db #0x7e	; 126
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x42	; 66	'B'
	.db #0x5a	; 90	'Z'
	.db #0x5a	; 90	'Z'
	.db #0x24	; 36
	.db #0x3c	; 60
	.db #0x18	; 24
	.db #0x18	; 24
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
;src/rat.c:46: void init_rats(void) {
;	---------------------------------
; Function init_rats
; ---------------------------------
_init_rats::
	add	sp, #-19
;src/rat.c:48: set_sprite_data(0, 4, RatSpriteData);
	ld	de, #_RatSpriteData
	push	de
	ld	hl, #0x400
	push	hl
	call	_set_sprite_data
	add	sp, #4
;src/rat.c:49: OBP0_REG = 0xE4; // Palette standard
	ld	a, #0xe4
	ldh	(_OBP0_REG + 0), a
;src/rat.c:52: uint8_t start_pos[4][2] = {
	ldhl	sp,	#0
	ld	a,#0x01
	ld	(hl+),a
	ld	(hl+), a
	ld	a, #0x11
	ld	(hl+), a
	ld	a, #0x0f
	ld	(hl+), a
	ld	a, #0x11
	ld	(hl+), a
	ld	a,#0x01
	ld	(hl+),a
	ld	(hl+), a
	ld	(hl), #0x0f
;src/rat.c:59: for (uint8_t i = 0; i < MAX_RATS; i++) {
	ldhl	sp,	#18
	ld	(hl), #0x00
00106$:
	ldhl	sp,	#18
	ld	a, (hl)
	sub	a, #0x0a
	jr	NC, 00101$
;src/rat.c:60: rats[i].active = 0;
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	bc, #_rats
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#18
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#17
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;src/rat.c:61: rats[i].reproduce_timer = 0;
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;src/rat.c:62: rats[i].cooldown_timer = 0;
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;src/rat.c:63: rats[i].is_mother = 0;
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;src/rat.c:64: rats[i].sprite_base_idx = i * 2;
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#18
	ld	a, (hl)
	add	a, a
	ld	(bc), a
;src/rat.c:66: move_sprite(rats[i].sprite_base_idx, 0, 0);
	ld	e, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/rat.c:67: move_sprite(rats[i].sprite_base_idx + 1, 0, 0);
	ld	a, (bc)
	ld	e, a
	inc	e
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+0
	xor	a, a
	ld	l, e
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, bc
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/rat.c:59: for (uint8_t i = 0; i < MAX_RATS; i++) {
	ldhl	sp,	#18
	inc	(hl)
	jr	00106$
00101$:
;src/rat.c:71: for (uint8_t i = 0; i < 4; i++) {
	ldhl	sp,	#18
	ld	(hl), #0x00
00109$:
	ldhl	sp,	#18
	ld	a, (hl)
	sub	a, #0x04
	jp	NC, 00111$
;src/rat.c:72: rats[i].active = 1;
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	bc, #_rats
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#10
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#9
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
;src/rat.c:73: rats[i].rat_x = start_pos[i][0];
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
	ldhl	sp,	#18
	ld	c, (hl)
	xor	a, a
	ld	b, a
	sla	c
	rl	b
	ld	hl, #0
	add	hl, sp
	add	hl, bc
	ld	c, l
	ld	b, h
	ldhl	sp,	#12
	ld	a, c
	ld	(hl+), a
	ld	a, b
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#10
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/rat.c:74: rats[i].rat_y = start_pos[i][1];
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#16
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#15
	ld	(hl+), a
	inc	bc
	ld	a, c
	ld	(hl+), a
	ld	a, b
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#14
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/rat.c:75: rats[i].target_x = start_pos[i][0];
	ldhl	sp,	#8
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	inc	bc
	ldhl	sp,#12
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(bc), a
;src/rat.c:76: rats[i].target_y = start_pos[i][1];
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#16
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	(bc), a
;src/rat.c:77: rats[i].pixel_x = rats[i].rat_x * 8;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#10
	ld	a, (hl+)
	ld	e, a
;src/rat.c:78: rats[i].pixel_y = rats[i].rat_y * 8;
	ld	a, (hl-)
	dec	hl
	dec	hl
	ld	d, a
	ld	a, (de)
	add	a, a
	add	a, a
	add	a, a
	ld	(bc), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,#14
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	add	a, a
	add	a, a
	add	a, a
	ld	(bc), a
;src/rat.c:79: rats[i].current_dir = 255;
	ldhl	sp,#8
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	ld	(hl), #0xff
;src/rat.c:71: for (uint8_t i = 0; i < 4; i++) {
	ldhl	sp,	#18
	inc	(hl)
	jp	00109$
00111$:
;src/rat.c:81: }
	add	sp, #19
	ret
;src/rat.c:83: void spawn_rat(uint8_t x, uint8_t y, uint8_t initial_dir) {
;	---------------------------------
; Function spawn_rat
; ---------------------------------
_spawn_rat::
	add	sp, #-13
	ldhl	sp,	#12
	ld	(hl-), a
	ld	(hl), e
;src/rat.c:84: for (uint8_t i = 0; i < MAX_RATS; i++) {
	ldhl	sp,	#8
	xor	a, a
	ld	(hl+), a
	inc	hl
	ld	(hl), #0x00
00169$:
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x0a
	jp	NC, 00171$
;src/rat.c:85: if (!rats[i].active) {
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a, #<(_rats)
	ld	c, a
	ld	a, h
	adc	a, #>(_rats)
	ld	b, a
	ld	l, c
	ld	h, b
	ld	a, (hl)
	or	a, a
	jp	NZ, 00170$
;src/rat.c:86: rats[i].active = 1;
	ld	(hl), #0x01
;src/rat.c:87: rats[i].rat_x = x;
	ld	e, c
	ld	d, b
	inc	de
	ldhl	sp,	#12
;src/rat.c:88: rats[i].rat_y = y;
	ld	a, (hl-)
	ld	(de), a
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	ld	a, (hl)
	ld	(de), a
;src/rat.c:91: rats[i].current_dir = initial_dir;
	ld	hl, #0x0007
	add	hl, bc
	ld	e, l
	ld	d, h
	ldhl	sp,	#15
	ld	a, (hl)
	ld	(de), a
;src/rat.c:92: rats[i].target_x = x;
	ld	e, c
	ld	d, b
	inc	de
	inc	de
	inc	de
	ldhl	sp,	#12
;src/rat.c:93: rats[i].target_y = y;
	ld	a, (hl-)
	ld	(de), a
	inc	bc
	inc	bc
	inc	bc
	inc	bc
	ld	a, (hl)
	ld	(bc), a
;src/rat.c:94: if (initial_dir == 0 && y < MAZE_HEIGHT - 1 && maze[y+1][x] == 0) rats[i].target_y++;
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
;src/rat.c:95: else if (initial_dir == 1 && y > 0 && maze[y-1][x] == 0) rats[i].target_y--;
	xor	a, a
	ld	(hl-), a
	dec	hl
	ld	e, (hl)
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_rats
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
;src/rat.c:98: else rats[i].current_dir = 255; // Nessuna direzione valida trovata
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#6
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#5
	ld	(hl), a
;src/rat.c:94: if (initial_dir == 0 && y < MAZE_HEIGHT - 1 && maze[y+1][x] == 0) rats[i].target_y++;
	ldhl	sp,	#15
	ld	a, (hl)
	or	a, a
	jr	NZ, 00117$
	ldhl	sp,	#11
	ld	a, (hl)
	sub	a, #0x10
	jr	NC, 00117$
	dec	hl
	dec	hl
	ld	de, #_maze+0
	ld	a, (hl)
	ld	h, #0x00
	ld	l, a
	inc	hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#12
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	or	a, a
	jr	NZ, 00117$
	ld	a, (bc)
	inc	a
	ld	(bc), a
	jp	00118$
00117$:
;src/rat.c:95: else if (initial_dir == 1 && y > 0 && maze[y-1][x] == 0) rats[i].target_y--;
	ldhl	sp,	#15
	ld	a, (hl)
	dec	a
	jr	NZ, 00112$
	ldhl	sp,	#11
	ld	a, (hl)
	or	a, a
	jr	Z, 00112$
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	dec	bc
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a, #<(_maze)
	ld	c, a
	ld	a, h
	adc	a, #>(_maze)
	ld	b, a
	ldhl	sp,	#12
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00112$
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	dec	a
	ld	(bc), a
	jr	00118$
00112$:
;src/rat.c:96: else if (initial_dir == 2 && x > 0 && maze[y][x-1] == 0) rats[i].target_x--;
	ldhl	sp,	#12
	ld	a, (hl)
	ldhl	sp,	#8
	ld	(hl), a
	ld	a, #0x05
00337$:
	ldhl	sp,	#9
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00337$
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	inc	bc
	inc	bc
	inc	bc
	ldhl	sp,	#15
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00107$
	ldhl	sp,	#12
	ld	a, (hl)
	or	a, a
	jr	Z, 00107$
	ld	de, #_maze
	ldhl	sp,	#9
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#8
	ld	a, (hl)
	dec	a
	ld	l, a
	ld	h, #0x00
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	NZ, 00107$
	ld	a, (bc)
	dec	a
	ld	(bc), a
	jr	00118$
00107$:
;src/rat.c:97: else if (initial_dir == 3 && x < MAZE_WIDTH - 1 && maze[y][x+1] == 0) rats[i].target_x++;
	ldhl	sp,	#15
	ld	a, (hl)
	sub	a, #0x03
	jr	NZ, 00102$
	ldhl	sp,	#12
	ld	a, (hl)
	sub	a, #0x12
	jr	NC, 00102$
	ld	de, #_maze
	ldhl	sp,	#9
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#8
	ld	l, (hl)
	inc	l
	ld	h, #0x00
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	NZ, 00102$
	ld	a, (bc)
	inc	a
	ld	(bc), a
	jr	00118$
00102$:
;src/rat.c:98: else rats[i].current_dir = 255; // Nessuna direzione valida trovata
	ldhl	sp,	#4
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0xff
00118$:
;src/rat.c:100: rats[i].pixel_x = x * 8;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#12
	ld	a, (hl)
	add	a, a
	add	a, a
	add	a, a
	ld	(bc), a
;src/rat.c:101: rats[i].pixel_y = y * 8;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#11
	ld	a, (hl)
	add	a, a
	add	a, a
	add	a, a
	ld	l, a
	ld	(de), a
;src/rat.c:105: uint8_t base_x = rats[i].pixel_x + 12;
	ld	a, (bc)
	add	a, #0x0c
	push	hl
	ldhl	sp,	#8
	ld	(hl), a
	pop	hl
;src/rat.c:106: uint8_t base_y = rats[i].pixel_y + 20;
	ld	a, l
	add	a, #0x14
	ldhl	sp,	#7
	ld	(hl), a
;src/rat.c:107: uint8_t s0 = rats[i].sprite_base_idx;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#8
;src/rat.c:108: uint8_t s1 = rats[i].sprite_base_idx + 1;
	ld	(hl+), a
	inc	a
	ld	(hl), a
;src/rat.c:110: if (rats[i].current_dir == 0 || rats[i].current_dir == 255) {
	ldhl	sp,#4
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#10
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00129$
	ld	a, (hl)
	inc	a
	jp	NZ, 00130$
00129$:
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00344$:
	ldhl	sp,	#4
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00344$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	inc	hl
	inc	hl
	ld	(hl), #0x02
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00345$:
	ldhl	sp,	#9
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00345$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	inc	hl
	inc	hl
	ld	(hl), #0x03
;/home/enne2/.local/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	de, #_shadow_OAM
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	inc	hl
	inc	hl
	inc	hl
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	ld	de, #_shadow_OAM
	ldhl	sp,	#9
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	inc	hl
	inc	hl
	inc	hl
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;src/rat.c:113: move_sprite(s0, base_x, base_y - 4); move_sprite(s1, base_x, base_y + 4);
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	(hl), a
	ld	a, (hl-)
	add	a, #0xfc
	ld	(hl), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	de, #_shadow_OAM
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ldhl	sp,	#7
	ld	a, (hl-)
	ld	(bc), a
	inc	bc
;src/rat.c:113: move_sprite(s0, base_x, base_y - 4); move_sprite(s1, base_x, base_y + 4);
	ld	a, (hl+)
	inc	hl
	ld	(bc), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	a, (hl+)
	ld	c, a
	inc	c
	inc	c
	inc	c
	inc	c
	ld	de, #_shadow_OAM
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	a, c
	ld	(de), a
	inc	de
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(de), a
;src/rat.c:113: move_sprite(s0, base_x, base_y - 4); move_sprite(s1, base_x, base_y + 4);
	jp	00131$
00130$:
;src/rat.c:114: } else if (rats[i].current_dir == 1) {
	ldhl	sp,	#10
	ld	a, (hl)
	dec	a
	jp	NZ, 00127$
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00348$:
	ldhl	sp,	#4
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00348$
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	inc	hl
	inc	hl
	ld	(hl), #0x03
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00349$:
	ldhl	sp,	#9
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00349$
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	inc	hl
	inc	hl
	ld	(hl), #0x02
;/home/enne2/.local/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	bc, #_shadow_OAM+0
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x40
	ld	bc, #_shadow_OAM+0
	ldhl	sp,	#9
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x40
;src/rat.c:117: move_sprite(s0, base_x, base_y - 4); move_sprite(s1, base_x, base_y + 4);
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	e, a
	add	a, #0xfc
	ld	(hl), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+0
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ldhl	sp,	#8
	ld	a, (hl-)
	dec	hl
	ld	(bc), a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
;src/rat.c:117: move_sprite(s0, base_x, base_y - 4); move_sprite(s1, base_x, base_y + 4);
	inc	e
	inc	e
	inc	e
	inc	e
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+0
	ldhl	sp,	#9
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	c, l
	ld	b, h
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	a, e
	ld	(bc), a
	inc	bc
	ldhl	sp,	#6
	ld	a, (hl)
	ld	(bc), a
;src/rat.c:117: move_sprite(s0, base_x, base_y - 4); move_sprite(s1, base_x, base_y + 4);
	jp	00131$
00127$:
;src/rat.c:118: } else if (rats[i].current_dir == 2) {
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x02
	jp	NZ, 00124$
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00352$:
	ldhl	sp,	#4
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00352$
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	inc	hl
	inc	hl
	ld	(hl), #0x01
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00353$:
	ldhl	sp,	#9
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00353$
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	inc	sp
	inc	sp
	ld	c, l
	ld	b, h
	push	bc
	inc	bc
	inc	bc
	xor	a, a
	ld	(bc), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	bc, #_shadow_OAM+0
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x20
	ld	bc, #_shadow_OAM+0
	ldhl	sp,	#9
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	inc	hl
	inc	hl
	inc	hl
	ld	(hl), #0x20
;src/rat.c:121: move_sprite(s0, base_x - 4, base_y); move_sprite(s1, base_x + 4, base_y);
	ldhl	sp,	#6
	ld	a, (hl+)
	inc	hl
	ld	c, a
	add	a, #0xfc
	ld	(hl), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	de, #_shadow_OAM+0
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	(de), a
	inc	de
;src/rat.c:121: move_sprite(s0, base_x - 4, base_y); move_sprite(s1, base_x + 4, base_y);
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	a, (hl+)
	ld	(de), a
	inc	c
	inc	c
	inc	c
	inc	c
	ld	de, #_shadow_OAM+0
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(de), a
	inc	de
	ld	a, c
	ld	(de), a
;src/rat.c:121: move_sprite(s0, base_x - 4, base_y); move_sprite(s1, base_x + 4, base_y);
	jp	00131$
00124$:
;src/rat.c:122: } else if (rats[i].current_dir == 3) {
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x03
	jp	NZ, 00131$
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ldhl	sp,	#8
	ld	a, (hl)
	ldhl	sp,	#4
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00356$:
	ldhl	sp,	#4
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00356$
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	inc	sp
	inc	sp
	ld	c, l
	ld	b, h
	push	bc
	inc	bc
	inc	bc
	xor	a, a
	ld	(bc), a
	ldhl	sp,	#9
	ld	a, (hl)
	ldhl	sp,	#0
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#9
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00357$:
	ldhl	sp,	#9
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00357$
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	inc	hl
	inc	hl
	ld	(hl), #0x01
;/home/enne2/.local/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	bc, #_shadow_OAM+0
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	inc	hl
	inc	hl
	inc	hl
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	ld	bc, #_shadow_OAM+0
	ldhl	sp,	#9
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	inc	hl
	inc	hl
	inc	hl
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
;src/rat.c:125: move_sprite(s0, base_x - 4, base_y); move_sprite(s1, base_x + 4, base_y);
	ldhl	sp,	#6
	ld	a, (hl+)
	inc	hl
	ld	c, a
	add	a, #0xfc
	ld	(hl), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	de, #_shadow_OAM+0
	ldhl	sp,	#4
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ldhl	sp,	#7
	ld	a, (hl+)
	ld	(de), a
	inc	de
;src/rat.c:125: move_sprite(s0, base_x - 4, base_y); move_sprite(s1, base_x + 4, base_y);
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	a, (hl+)
	ld	(de), a
	inc	c
	inc	c
	inc	c
	inc	c
	ld	de, #_shadow_OAM+0
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	e, l
	ld	d, h
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ldhl	sp,	#7
	ld	a, (hl)
	ld	(de), a
	inc	de
	ld	a, c
	ld	(de), a
;src/rat.c:125: move_sprite(s0, base_x - 4, base_y); move_sprite(s1, base_x + 4, base_y);
00131$:
;src/rat.c:130: rats[i].reproduce_timer = 60; 
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x3c
;src/rat.c:131: rats[i].cooldown_timer = 120; // Il cucciolo non si riproduce subito
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x78
;src/rat.c:132: rats[i].is_mother = 0;
	ldhl	sp,#2
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;src/rat.c:133: play_sfx_plop(); // Suono di nascita!
	call	_play_sfx_plop
;src/rat.c:136: for (uint8_t j = 0; j < MAX_RATS; j++) {
	ldhl	sp,	#9
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00166$:
	ldhl	sp,	#10
	ld	a, (hl)
	sub	a, #0x0a
	jr	NC, 00135$
;src/rat.c:137: if (rats[j].active) count++;
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
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
	ld	hl, #_rats
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#9
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	Z, 00167$
	inc	hl
	inc	(hl)
00167$:
;src/rat.c:136: for (uint8_t j = 0; j < MAX_RATS; j++) {
	ldhl	sp,	#10
	inc	(hl)
	jr	00166$
00135$:
;src/rat.c:139: if (count >= MAX_RATS) {
	ldhl	sp,	#9
	ld	a, (hl)
	sub	a, #0x0a
	jr	C, 00171$
;src/rat.c:140: game_over_flag = 1;
	ld	hl, #_game_over_flag
	ld	(hl), #0x01
;src/rat.c:142: break;
	jr	00171$
00170$:
;src/rat.c:84: for (uint8_t i = 0; i < MAX_RATS; i++) {
	ldhl	sp,	#10
	inc	(hl)
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	jp	00169$
00171$:
;src/rat.c:145: }
	add	sp, #13
	pop	hl
	inc	sp
	jp	(hl)
;src/rat.c:147: void update_rats(void) {
;	---------------------------------
; Function update_rats
; ---------------------------------
_update_rats::
	add	sp, #-59
;src/rat.c:150: frame_counter++;
	ld	hl, #_update_rats_frame_counter_10000_262
	inc	(hl)
;src/rat.c:151: uint8_t do_move = (frame_counter & 1); // Muovi di 1 pixel ogni 2 frame
	ld	a, (hl)
	and	a, #0x01
	ldhl	sp,	#36
	ld	(hl), a
;src/rat.c:155: for (uint8_t i = 0; i < MAX_RATS; i++) {
	ldhl	sp,	#57
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00266$:
	ldhl	sp,	#58
	ld	a, (hl)
	sub	a, #0x0a
	jr	NC, 00103$
;src/rat.c:156: if (rats[i].active) active_count++;
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#55
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#54
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_rats
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#57
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#56
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	Z, 00267$
	inc	hl
	inc	(hl)
00267$:
;src/rat.c:155: for (uint8_t i = 0; i < MAX_RATS; i++) {
	ldhl	sp,	#58
	inc	(hl)
	jr	00266$
00103$:
;src/rat.c:159: if (active_count == 1) {
	ldhl	sp,	#57
	ld	a, (hl)
	dec	a
	jr	NZ, 00111$
;src/rat.c:160: single_rat_timer++;
	ld	hl, #_update_rats_single_rat_timer_10000_262
	inc	(hl)
	jr	NZ, 00812$
	inc	hl
	inc	(hl)
00812$:
;src/rat.c:161: if (single_rat_timer >= 600) { // 10 secondi a 60 fps
	ld	a, (_update_rats_single_rat_timer_10000_262)
	ld	c, a
	ld	hl, #_update_rats_single_rat_timer_10000_262 + 1
	ld	b, (hl)
	ld	a, c
	sub	a, #0x58
	ld	a, b
	sbc	a, #0x02
	jr	C, 00294$
;src/rat.c:162: single_rat_timer = 0;
	dec	hl
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/rat.c:164: for(uint8_t s = 0; s < 2; s++) {
	ld	c, #0x00
00269$:
	ld	a, c
	sub	a, #0x02
	jr	NC, 00294$
;src/rat.c:166: do {
00104$:
;src/rat.c:167: rx = rand() % MAZE_WIDTH;
	call	_rand
	ld	a, e
	push	bc
	ld	e, #0x13
	call	__moduchar
	ld	a, c
	pop	bc
	ldhl	sp,	#57
	ld	(hl), a
;src/rat.c:168: ry = rand() % MAZE_HEIGHT;
	call	_rand
	ld	a, e
	push	bc
	ld	e, #0x11
	call	__moduchar
	ld	a, c
	pop	bc
	ldhl	sp,	#58
	ld	(hl), a
;src/rat.c:169: } while(maze[ry][rx] != 0);
	ld	b, (hl)
	xor	a, a
	ld	l, b
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	a, l
	add	a, #<(_maze)
	ld	e, a
	ld	a, h
	adc	a, #>(_maze)
	ld	d, a
	ldhl	sp,	#57
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	or	a, a
	jr	NZ, 00104$
;src/rat.c:170: spawn_rat(rx, ry, rand() % 4);
	call	_rand
	ld	a, e
	and	a, #0x03
	push	bc
	push	af
	inc	sp
	ldhl	sp,	#61
	ld	a, (hl-)
	ld	e, a
	ld	a, (hl)
	call	_spawn_rat
	pop	bc
;src/rat.c:164: for(uint8_t s = 0; s < 2; s++) {
	inc	c
	jr	00269$
00111$:
;src/rat.c:174: single_rat_timer = 0;
	xor	a, a
	ld	hl, #_update_rats_single_rat_timer_10000_262
	ld	(hl+), a
	ld	(hl), a
;src/rat.c:184: for (uint8_t i = 0; i < 16; i++) head[i] = 255;
00294$:
	ldhl	sp,	#2
	ld	e, l
	ld	d, h
	ld	c, #0x00
00272$:
	ld	a, c
	sub	a, #0x10
	jr	NC, 00113$
	ld	l, c
	ld	h, #0x00
	add	hl, de
	ld	(hl), #0xff
	inc	c
	jr	00272$
00113$:
;src/rat.c:187: for (uint8_t i = 0; i < MAX_RATS; i++) {
	ldhl	sp,	#58
	ld	(hl), #0x00
00275$:
	ldhl	sp,	#58
	ld	a, (hl)
	sub	a, #0x0a
	jp	NC, 00119$
;src/rat.c:188: if (!rats[i].active || rats[i].reproduce_timer > 0 || rats[i].cooldown_timer > 0) {
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	ld	bc, #_rats
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#56
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#55
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	Z, 00114$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#58
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#57
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	NZ, 00114$
	dec	hl
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00115$
00114$:
;src/rat.c:189: next_rat[i] = 255;
	push	hl
	ld	hl, #20
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#58
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	(hl), #0xff
;src/rat.c:190: continue;
	jr	00118$
00115$:
;src/rat.c:192: uint8_t h = (rats[i].rat_x ^ rats[i].rat_y) & 15; // Hash velocissimo
	ldhl	sp,	#54
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl-)
	ld	b, a
	inc	bc
	ld	a, (bc)
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	inc	hl
	inc	hl
	ld	c, (hl)
	xor	a, c
	and	a, #0x0f
	ld	e, a
;src/rat.c:193: next_rat[i] = head[h];
	push	de
	push	hl
	ld	hl, #22
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#60
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	ld	d, #0x00
	ld	hl, #2
	add	hl, sp
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	(bc), a
;src/rat.c:194: head[h] = i;
	ldhl	sp,	#58
	ld	a, (hl)
	ld	(de), a
00118$:
;src/rat.c:187: for (uint8_t i = 0; i < MAX_RATS; i++) {
	ldhl	sp,	#58
	inc	(hl)
	jp	00275$
00119$:
;src/rat.c:198: for (uint8_t i = 0; i < MAX_RATS; i++) {
	ld	c, #0x00
00277$:
	ld	a, c
	sub	a, #0x0a
	jp	NC, 00133$
;src/rat.c:199: if (!rats[i].active || rats[i].reproduce_timer > 0 || rats[i].cooldown_timer > 0) continue;
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#59
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#58
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_rats
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#52
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#51
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jp	Z, 00132$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#54
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#53
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jp	NZ, 00132$
	dec	hl
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	or	a, a
	jp	NZ, 00132$
;src/rat.c:202: uint8_t j = next_rat[i]; 
	ld	e, c
	ld	d, #0x00
	ld	hl, #18
	add	hl, sp
	add	hl, de
	ld	b, (hl)
;src/rat.c:203: while (j != 255) {
00129$:
	ld	a, b
	inc	a
	jp	Z, 00132$
;src/rat.c:204: if (rats[i].rat_x == rats[j].rat_x && rats[i].rat_y == rats[j].rat_y &&
	ldhl	sp,	#50
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	ld	a, (de)
	ldhl	sp,	#54
	ld	(hl), a
	ld	e, b
	ld	d, #0x00
	ld	l, e
	ld	h, d
	add	hl, hl
	add	hl, de
	add	hl, hl
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#57
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#56
	ld	(hl), a
	ld	de, #_rats
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#59
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#58
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	inc	hl
	ld	e, (hl)
	ldhl	sp,	#54
	ld	a, (hl)
	sub	a, e
	jp	NZ, 00125$
	ldhl	sp,	#50
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	inc	de
	inc	de
	ld	a, (de)
	ldhl	sp,	#57
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	inc	hl
	inc	hl
	ld	e, (hl)
	sub	a, e
	jr	NZ, 00125$
;src/rat.c:205: rats[i].pixel_x == rats[j].pixel_x && rats[i].pixel_y == rats[j].pixel_y) {
	ldhl	sp,#50
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#56
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, a
	ldhl	sp,	#56
	ld	a, (hl)
	sub	a, e
	jr	NZ, 00125$
	ldhl	sp,#50
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#56
	ld	(hl+), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ld	e, a
	ldhl	sp,	#56
	ld	a, (hl)
	sub	a, e
	jr	NZ, 00125$
;src/rat.c:209: rats[i].reproduce_timer = 64; 
	ldhl	sp,	#52
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x40
;src/rat.c:210: rats[j].reproduce_timer = 64;
	ldhl	sp,#57
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	(hl), #0x40
;src/rat.c:211: rats[i].is_mother = 1; // Solo i farà spawnare il cucciolo
	ldhl	sp,#50
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	ld	(hl), #0x01
;src/rat.c:212: rats[j].is_mother = 0;
	ldhl	sp,#57
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	ld	e, l
	ld	d, h
	xor	a, a
	ld	(de), a
;src/rat.c:213: play_sfx_moan(); // Suono d'amore
	push	bc
	call	_play_sfx_moan
	pop	bc
;src/rat.c:214: break;
	jr	00132$
00125$:
;src/rat.c:216: j = next_rat[j]; // Passa al prossimo topo nello stesso bucket
	ld	e, b
	ld	d, #0x00
	ld	hl, #18
	add	hl, sp
	add	hl, de
	ld	b, (hl)
	jp	00129$
00132$:
;src/rat.c:198: for (uint8_t i = 0; i < MAX_RATS; i++) {
	inc	c
	jp	00277$
00133$:
;src/rat.c:221: for (uint8_t i = 0; i < MAX_RATS; i++) {
	ldhl	sp,	#56
	ld	(hl), #0x00
00282$:
	ldhl	sp,	#56
	ld	a, (hl)
	sub	a, #0x0a
	jp	NC, 00283$
;src/rat.c:222: Rat* r = &rats[i];
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#56
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#55
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_rats
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#59
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#58
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#37
	ld	(hl), a
	ldhl	sp,	#58
	ld	a, (hl)
	ldhl	sp,	#38
;src/rat.c:223: if (!r->active) continue;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#58
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jp	Z, 00239$
;src/rat.c:225: if (r->cooldown_timer > 0) {
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	Z, 00137$
;src/rat.c:226: r->cooldown_timer--;
	dec	a
	ld	(bc), a
00137$:
;src/rat.c:230: if (r->reproduce_timer > 0) {
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0009
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#58
	ld	(hl), a
;src/rat.c:237: spawn_rat(r->rat_x, r->rat_y, get_opposite(r->current_dir));
	push	de
	ldhl	sp,#39
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0007
	add	hl, de
	pop	de
	push	hl
	ld	a, l
	ldhl	sp,	#41
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#40
	ld	(hl-), a
	dec	hl
	dec	hl
	push	de
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	pop	de
	push	hl
	ld	a, l
	ldhl	sp,	#43
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#42
	ld	(hl), a
	push	de
	ldhl	sp,#39
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	pop	de
	inc	sp
	inc	sp
	push	hl
;src/rat.c:230: if (r->reproduce_timer > 0) {
	ldhl	sp,	#58
	ld	a, (hl)
	or	a, a
	jr	Z, 00143$
;src/rat.c:231: r->reproduce_timer--;
	ld	a, (hl)
	dec	a
	ld	(de), a
;src/rat.c:232: if (r->reproduce_timer == 0) {
	or	a, a
	jp	NZ, 00239$
;src/rat.c:234: r->cooldown_timer = 120; // 2 secondi di pausa
	ld	a, #0x78
	ld	(bc), a
;src/rat.c:235: if (r->is_mother) {
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x000b
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jp	Z, 00239$
;src/rat.c:236: r->is_mother = 0;
	xor	a, a
	ld	(bc), a
;src/rat.c:237: spawn_rat(r->rat_x, r->rat_y, get_opposite(r->current_dir));
	ldhl	sp,#39
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	call	_get_opposite
	ld	b, a
	ldhl	sp,#41
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	pop	de
	push	de
	ld	a, (de)
	push	bc
	inc	sp
	ld	e, c
	call	_spawn_rat
;src/rat.c:240: continue;
	jp	00239$
00143$:
;src/rat.c:243: if (r->rat_x == r->target_x && r->rat_y == r->target_y) {
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#43
	ld	(hl), a
	ldhl	sp,	#1
	ld	a, (hl)
	ldhl	sp,	#44
	ld	(hl), a
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#58
	ld	(hl), a
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#47
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#46
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0004
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#49
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#48
	ld	(hl), a
	ldhl	sp,	#58
	ld	a, (hl)
	sub	a, c
	jp	NZ, 00207$
	ldhl	sp,#41
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#55
	ld	(hl), a
	ldhl	sp,	#47
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	dec	hl
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#55
	ld	a, (hl)
	sub	a, c
	jp	NZ, 00207$
;src/rat.c:245: uint8_t num_valid = 0;
	ldhl	sp,	#57
;src/rat.c:247: if (r->rat_y < MAZE_HEIGHT - 1 && maze[r->rat_y + 1][r->rat_x] == 0) valid_dirs[num_valid++] = 0;
	xor	a, a
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	sub	a, #0x10
	jr	NC, 00145$
	ld	a, (hl)
	ldhl	sp,	#52
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#56
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#55
	ld	(hl), a
	ld	a, #0x05
00826$:
	ldhl	sp,	#54
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00826$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_maze
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#54
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#53
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#58
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#56
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#55
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	NZ, 00145$
	inc	hl
	inc	hl
	ld	(hl), #0x01
	ldhl	sp,	#28
	ld	(hl), #0x00
00145$:
;src/rat.c:248: if (r->rat_y > 0 && maze[r->rat_y - 1][r->rat_x] == 0) valid_dirs[num_valid++] = 1;
	ldhl	sp,#41
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#58
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00148$
	ld	a, (hl)
	ldhl	sp,	#52
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0001
	ld	a, e
	sub	a, l
	ld	e, a
	ld	a, d
	sbc	a, h
	ldhl	sp,	#55
	ld	(hl-), a
	ld	(hl), e
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ldhl	sp,	#55
	ld	a, (hl-)
	dec	hl
	ld	(hl), a
	ld	a, #0x05
00827$:
	ldhl	sp,	#52
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00827$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_maze
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#56
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#55
	ld	(hl), a
	pop	de
	push	de
	ld	a, (de)
	ld	e, a
	ld	d, #0x00
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00148$
	ldhl	sp,	#57
	ld	e, (hl)
	inc	(hl)
	ld	d, #0x00
	ld	hl, #28
	add	hl, sp
	add	hl, de
	ld	(hl), #0x01
00148$:
;src/rat.c:249: if (r->rat_x > 0 && maze[r->rat_y][r->rat_x - 1] == 0) valid_dirs[num_valid++] = 2;
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#58
	ld	(hl), a
	ld	a, (hl)
	or	a, a
	jr	Z, 00151$
	ldhl	sp,#41
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#55
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x05
00828$:
	ldhl	sp,	#52
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00828$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_maze
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#56
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#55
	ld	(hl), a
	ldhl	sp,	#58
	ld	e, (hl)
	dec	e
	ld	d, #0x00
	ldhl	sp,	#54
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00151$
	ldhl	sp,	#57
	ld	e, (hl)
	inc	(hl)
	ld	d, #0x00
	ld	hl, #28
	add	hl, sp
	add	hl, de
	ld	(hl), #0x02
00151$:
;src/rat.c:250: if (r->rat_x < MAZE_WIDTH - 1 && maze[r->rat_y][r->rat_x + 1] == 0) valid_dirs[num_valid++] = 3;
	pop	de
	push	de
	ld	a, (de)
	ldhl	sp,	#58
	ld	(hl), a
	ld	a, (hl)
	sub	a, #0x12
	jr	NC, 00154$
	ldhl	sp,#41
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#55
	ld	(hl), a
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x05
00829$:
	ldhl	sp,	#52
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00829$
	dec	hl
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_maze
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#56
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#55
	ld	(hl), a
	ldhl	sp,	#58
	inc	(hl)
	ld	e, (hl)
	ld	d, #0x00
	ldhl	sp,	#54
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#54
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#53
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	NZ, 00154$
	ldhl	sp,	#57
	ld	e, (hl)
	inc	(hl)
	ld	d, #0x00
	ld	hl, #28
	add	hl, sp
	add	hl, de
	ld	(hl), #0x03
00154$:
;src/rat.c:252: if (num_valid > 0) {
	ldhl	sp,	#57
	ld	a, (hl)
	or	a, a
	jp	Z, 00207$
;src/rat.c:273: if (num_valid == 1) rnd = 0;
	ld	a, (hl)
	dec	a
	ld	a, #0x01
	jr	Z, 00831$
	xor	a, a
00831$:
	ldhl	sp,	#51
	ld	(hl), a
;src/rat.c:274: else if (num_valid == 2) rnd = rand() & 1;
	ldhl	sp,	#57
	ld	a, (hl)
	sub	a, #0x02
	ld	a, #0x01
	jr	Z, 00833$
	xor	a, a
00833$:
	ldhl	sp,	#52
	ld	(hl), a
;src/rat.c:253: if (num_valid > 1 && r->current_dir != 255) {
	ld	a, #0x01
	ldhl	sp,	#57
	sub	a, (hl)
	jp	NC, 00190$
	ldhl	sp,	#39
	ld	a, (hl)
	ldhl	sp,	#53
	ld	(hl), a
	ldhl	sp,	#40
	ld	a, (hl)
	ldhl	sp,	#54
	ld	(hl), a
	ldhl	sp,#39
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	cp	a, #0xff
	jp	Z, 00190$
;src/rat.c:254: uint8_t opp = get_opposite(r->current_dir);
	call	_get_opposite
	ld	c, a
;src/rat.c:257: for (uint8_t j = 0; j < num_valid; j++) {
	ldhl	sp,	#58
	ld	(hl), #0x00
	ld	b, #0x00
00279$:
	ld	a, b
	ldhl	sp,	#57
	sub	a, (hl)
	jr	NC, 00362$
;src/rat.c:258: if (valid_dirs[j] != opp) {
	ld	e, b
	ld	d, #0x00
	ld	hl, #28
	add	hl, sp
	add	hl, de
	ld	a, (hl)
	ldhl	sp,	#55
	ld	(hl), a
	ld	a, c
	ldhl	sp,	#55
	sub	a, (hl)
	jr	Z, 00280$
;src/rat.c:259: filtered[num_filtered++] = valid_dirs[j];
	push	hl
	ld	hl, #34
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#58
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#58
	inc	(hl)
	ldhl	sp,	#55
	ld	a, (hl)
	ld	(de), a
00280$:
;src/rat.c:257: for (uint8_t j = 0; j < num_valid; j++) {
	inc	b
	jr	00279$
00362$:
	ldhl	sp,	#58
	ld	a, (hl)
	ldhl	sp,	#55
	ld	(hl), a
;src/rat.c:262: if (num_filtered > 0) {
	ldhl	sp,	#58
	ld	a, (hl)
	or	a, a
	jr	Z, 00178$
;src/rat.c:264: if (num_filtered == 1) rnd = 0;
	ld	a, (hl)
	dec	a
	jr	NZ, 00166$
	ldhl	sp,	#58
	ld	(hl), #0x00
	jr	00167$
00166$:
;src/rat.c:265: else if (num_filtered == 2) rnd = rand() & 1; // 0 o 1
	ldhl	sp,	#58
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00159$
	call	_rand
	ldhl	sp,#58
	ld	(hl), e
	ld	a, (hl)
	and	a, #0x01
	ld	(hl), a
	jr	00167$
;src/rat.c:267: do { rnd = rand() & 3; } while(rnd >= num_filtered); 
00159$:
	call	_rand
	ld	a, e
	and	a, #0x03
	ldhl	sp,	#58
	ld	(hl), a
	ld	a, (hl)
	ldhl	sp,	#55
	sub	a, (hl)
	jr	NC, 00159$
00167$:
;src/rat.c:269: r->current_dir = filtered[rnd];
	push	hl
	ld	hl, #34
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#58
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#53
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	jp	00191$
00178$:
;src/rat.c:273: if (num_valid == 1) rnd = 0;
	ldhl	sp,	#51
	ld	a, (hl)
	or	a, a
	jr	Z, 00175$
	ldhl	sp,	#58
	ld	(hl), #0x00
	jr	00176$
00175$:
;src/rat.c:274: else if (num_valid == 2) rnd = rand() & 1;
	ldhl	sp,	#52
	ld	a, (hl)
	or	a, a
	jr	Z, 00168$
	call	_rand
	ldhl	sp,#58
	ld	(hl), e
	ld	a, (hl)
	and	a, #0x01
	ld	(hl), a
	jr	00176$
;src/rat.c:276: do { rnd = rand() & 3; } while(rnd >= num_valid); 
00168$:
	call	_rand
	ld	a, e
	and	a, #0x03
	ldhl	sp,	#58
	ld	(hl), a
	ld	a, (hl-)
	sub	a, (hl)
	jr	NC, 00168$
00176$:
;src/rat.c:278: r->current_dir = valid_dirs[rnd];
	push	hl
	ld	hl, #30
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#58
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#53
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	jr	00191$
00190$:
;src/rat.c:282: if (num_valid == 1) rnd = 0;
	ldhl	sp,	#51
	ld	a, (hl)
	or	a, a
	jr	Z, 00187$
	ldhl	sp,	#58
	ld	(hl), #0x00
	jr	00188$
00187$:
;src/rat.c:283: else if (num_valid == 2) rnd = rand() & 1;
	ldhl	sp,	#52
	ld	a, (hl)
	or	a, a
	jr	Z, 00180$
	call	_rand
	ldhl	sp,#58
	ld	(hl), e
	ld	a, (hl)
	and	a, #0x01
	ld	(hl), a
	jr	00188$
;src/rat.c:285: do { rnd = rand() & 3; } while(rnd >= num_valid); 
00180$:
	call	_rand
	ld	a, e
	and	a, #0x03
	ldhl	sp,	#58
	ld	(hl), a
	ld	a, (hl-)
	sub	a, (hl)
	jr	NC, 00180$
00188$:
;src/rat.c:287: r->current_dir = valid_dirs[rnd];
	push	hl
	ld	hl, #30
	add	hl, sp
	ld	e, l
	ld	d, h
	pop	hl
	ldhl	sp,	#58
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ldhl	sp,	#39
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
00191$:
;src/rat.c:290: if (r->current_dir == 0) r->target_y++;
	ldhl	sp,#39
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	NZ, 00202$
	ldhl	sp,#49
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	inc	a
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	jr	00207$
00202$:
;src/rat.c:291: else if (r->current_dir == 1) r->target_y--;
	cp	a, #0x01
	jr	NZ, 00199$
	ldhl	sp,#49
	ld	a, (hl+)
	ld	e, a
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	dec	a
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
	jr	00207$
00199$:
;src/rat.c:243: if (r->rat_x == r->target_x && r->rat_y == r->target_y) {
	ldhl	sp,#45
	ld	e, (hl)
	inc	hl
	ld	d, (hl)
	push	af
	ld	a, (de)
	ld	c, a
	pop	af
;src/rat.c:292: else if (r->current_dir == 2) r->target_x--;
	cp	a, #0x02
	jr	NZ, 00196$
	dec	c
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	ld	(hl), c
	jr	00207$
00196$:
;src/rat.c:293: else if (r->current_dir == 3) r->target_x++;
	sub	a, #0x03
	jr	NZ, 00207$
	inc	c
	ldhl	sp,	#45
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
00207$:
;src/rat.c:297: uint8_t target_px = r->target_x * 8;
	ldhl	sp,#45
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	add	a, a
	add	a, a
	add	a, a
	ldhl	sp,	#52
	ld	(hl), a
;src/rat.c:298: uint8_t target_py = r->target_y * 8;
	ldhl	sp,#47
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	add	a, a
	add	a, a
	add	a, a
	ldhl	sp,	#53
	ld	(hl), a
;src/rat.c:301: if (r->pixel_x < target_px) r->pixel_x++;
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0005
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#56
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#55
	ld	(hl), a
;src/rat.c:303: if (r->pixel_y < target_py) r->pixel_y++;
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0006
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#59
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#58
	ld	(hl), a
;src/rat.c:300: if (do_move) {
	ldhl	sp,	#36
	ld	a, (hl)
	or	a, a
	jr	Z, 00220$
;src/rat.c:301: if (r->pixel_x < target_px) r->pixel_x++;
	ldhl	sp,#54
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#52
	sub	a, (hl)
	jr	NC, 00212$
	inc	hl
	inc	hl
	inc	c
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
	jr	00213$
00212$:
;src/rat.c:302: else if (r->pixel_x > target_px) r->pixel_x--;
	ldhl	sp,	#52
	ld	a, (hl)
	sub	a, c
	jr	NC, 00213$
	inc	hl
	inc	hl
	dec	c
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
00213$:
;src/rat.c:303: if (r->pixel_y < target_py) r->pixel_y++;
	ldhl	sp,#57
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#53
	sub	a, (hl)
	jr	NC, 00217$
	inc	c
	ldhl	sp,	#57
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
	jr	00220$
00217$:
;src/rat.c:304: else if (r->pixel_y > target_py) r->pixel_y--;
	ldhl	sp,	#53
	ld	a, (hl)
	sub	a, c
	jr	NC, 00220$
	dec	c
	ldhl	sp,	#57
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), c
00220$:
;src/rat.c:307: if (r->pixel_x == target_px && r->pixel_y == target_py) {
	ldhl	sp,#54
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#52
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00222$
	ldhl	sp,#57
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ld	c, a
	ldhl	sp,	#53
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00222$
;src/rat.c:308: r->rat_x = r->target_x;
	ldhl	sp,#45
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#43
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
;src/rat.c:309: r->rat_y = r->target_y;
	ldhl	sp,#47
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#41
	ld	e, (hl)
	inc	hl
	ld	h, (hl)
	ld	l, e
	ld	(hl), a
00222$:
;src/rat.c:237: spawn_rat(r->rat_x, r->rat_y, get_opposite(r->current_dir));
	ldhl	sp,#39
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	ldhl	sp,	#53
	ld	(hl), a
;src/rat.c:326: if (do_move || r->current_dir == 255) {
	ld	a, (hl)
	inc	a
	ld	a, #0x01
	jr	Z, 00851$
	xor	a, a
00851$:
	ld	c, a
	ldhl	sp,	#36
	ld	a, (hl)
	or	a, a
	jr	NZ, 00236$
	or	a, c
	jp	Z, 00239$
00236$:
;src/rat.c:327: uint8_t base_x = r->pixel_x + 12;
	ldhl	sp,#54
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	add	a, #0x0c
	ld	(hl), a
;src/rat.c:328: uint8_t base_y = r->pixel_y + 20;
	ldhl	sp,#57
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	add	a, #0x14
	ld	(hl), a
;src/rat.c:329: uint8_t s0 = r->sprite_base_idx;
	ldhl	sp,#37
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0008
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	ldhl	sp,	#54
	ld	(hl), a
;src/rat.c:330: uint8_t s1 = r->sprite_base_idx + 1;
	inc	a
	ldhl	sp,	#57
	ld	(hl), a
;src/rat.c:332: if (r->current_dir == 0 || r->current_dir == 255) { // Giù
	ldhl	sp,	#53
	ld	a, (hl)
	or	a, a
	jr	Z, 00232$
	ld	a, c
	or	a, a
	jp	Z, 00233$
00232$:
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ldhl	sp,	#54
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00852$:
	ldhl	sp,	#53
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00852$
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#53
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#52
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x02
	ldhl	sp,	#57
	ld	c, (hl)
	xor	a, a
	sla	c
	adc	a, a
	sla	c
	adc	a, a
	ldhl	sp,	#51
	ld	(hl), c
	inc	hl
	ld	(hl), a
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#49
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#48
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x03
;/home/enne2/.local/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	de, #_shadow_OAM
	ldhl	sp,	#53
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#49
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#48
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ld	de, #_shadow_OAM
	ldhl	sp,	#51
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#49
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#48
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;src/rat.c:337: move_sprite(s0, base_x, base_y - 4);
	ldhl	sp,	#58
	ld	a, (hl-)
	add	a, #0xfc
	ld	(hl), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ldhl	sp,#53
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#53
	ld	(hl), a
	ldhl	sp,	#50
	ld	a, (hl)
	ldhl	sp,	#54
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#57
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#53
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#55
	ld	a, (hl)
	ld	(de), a
;src/rat.c:338: move_sprite(s1, base_x, base_y + 4);
	ldhl	sp,	#58
	inc	(hl)
	inc	(hl)
	inc	(hl)
	inc	(hl)
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ldhl	sp,#51
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#55
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#54
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#58
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,	#53
	ld	a, (hl+)
	ld	c, a
	ld	a, (hl+)
	ld	b, a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
;src/rat.c:338: move_sprite(s1, base_x, base_y + 4);
	jp	00239$
00233$:
;src/rat.c:339: } else if (r->current_dir == 1) { // Su
	ldhl	sp,	#53
	ld	a, (hl)
	dec	a
	jp	NZ, 00230$
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ldhl	sp,	#54
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00856$:
	ldhl	sp,	#53
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00856$
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#53
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#52
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x03
	ldhl	sp,	#57
	ld	c, (hl)
	xor	a, a
	sla	c
	adc	a, a
	sla	c
	adc	a, a
	ldhl	sp,	#51
	ld	(hl), c
	inc	hl
	ld	(hl), a
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#49
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#48
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x02
;/home/enne2/.local/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	de, #_shadow_OAM
	ldhl	sp,	#53
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#49
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#48
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x40
	ld	de, #_shadow_OAM
	ldhl	sp,	#51
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#49
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#48
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x40
;src/rat.c:344: move_sprite(s0, base_x, base_y - 4);
	ldhl	sp,	#58
	ld	a, (hl-)
	add	a, #0xfc
	ld	(hl), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ldhl	sp,#53
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_shadow_OAM
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#53
	ld	(hl), a
	ldhl	sp,	#50
	ld	a, (hl)
	ldhl	sp,	#54
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#57
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#53
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#55
	ld	a, (hl)
	ld	(de), a
;src/rat.c:345: move_sprite(s1, base_x, base_y + 4);
	ldhl	sp,	#58
	inc	(hl)
	inc	(hl)
	inc	(hl)
	inc	(hl)
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	de, #_shadow_OAM
	ldhl	sp,	#51
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#55
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#54
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#58
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#53
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#59
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#58
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#55
	ld	a, (hl)
	ld	(de), a
;src/rat.c:345: move_sprite(s1, base_x, base_y + 4);
	jp	00239$
00230$:
;src/rat.c:346: } else if (r->current_dir == 2) { // Sinistra
	ldhl	sp,	#53
	ld	a, (hl)
	sub	a, #0x02
	jp	NZ, 00227$
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ldhl	sp,	#54
	ld	a, (hl-)
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00860$:
	ldhl	sp,	#53
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00860$
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#53
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#52
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
	ldhl	sp,	#57
	ld	c, (hl)
	xor	a, a
	sla	c
	adc	a, a
	sla	c
	adc	a, a
	ldhl	sp,	#51
	ld	(hl), c
	inc	hl
	ld	(hl), a
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#49
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#48
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;/home/enne2/.local/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	de, #_shadow_OAM
	ldhl	sp,	#53
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#49
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#48
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x20
	ld	de, #_shadow_OAM
	ldhl	sp,	#51
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#49
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#48
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x20
;src/rat.c:351: move_sprite(s0, base_x - 4, base_y);
	ldhl	sp,	#55
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, #0xfc
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	(hl-), a
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#53
	ld	(hl), a
	ldhl	sp,	#50
	ld	a, (hl)
	ldhl	sp,	#54
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#58
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#53
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#55
;src/rat.c:352: move_sprite(s1, base_x + 4, base_y);
	ld	a, (hl+)
	inc	hl
	ld	(de), a
	inc	(hl)
	inc	(hl)
	inc	(hl)
	inc	(hl)
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	de, #_shadow_OAM
	ldhl	sp,	#51
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#56
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#55
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#58
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#54
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#54
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#53
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#57
	ld	a, (hl)
	ld	(de), a
;src/rat.c:352: move_sprite(s1, base_x + 4, base_y);
	jp	00239$
00227$:
;src/rat.c:353: } else if (r->current_dir == 3) { // Destra
	ldhl	sp,	#53
	ld	a, (hl)
	sub	a, #0x03
	jp	NZ, 00239$
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ldhl	sp,	#54
	ld	a, (hl-)
	ld	(hl+), a
	xor	a, a
	ld	(hl-), a
	ld	a, (hl-)
	dec	hl
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00864$:
	ldhl	sp,	#51
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00864$
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#55
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#54
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ldhl	sp,	#57
	ld	a, (hl)
	ldhl	sp,	#53
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x02
00865$:
	ldhl	sp,	#53
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00865$
	ld	de, #_shadow_OAM
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#49
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#48
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0002
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x01
;/home/enne2/.local/gbdk/include/gb/gb.h:1946: shadow_OAM[nb].prop=prop;
	ld	de, #_shadow_OAM
	ldhl	sp,	#51
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#49
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#48
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
	ld	de, #_shadow_OAM
	ldhl	sp,	#53
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#49
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#48
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #0x0003
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;src/rat.c:358: move_sprite(s0, base_x - 4, base_y);
	ldhl	sp,	#55
	ld	a, (hl+)
	inc	hl
	ld	(hl), a
	ld	a, (hl-)
	dec	hl
	add	a, #0xfc
	ld	(hl), a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	de, #_shadow_OAM
	ldhl	sp,	#51
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#58
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#51
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#51
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#50
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#55
;src/rat.c:359: move_sprite(s1, base_x + 4, base_y);
	ld	a, (hl+)
	inc	hl
	ld	(de), a
	inc	(hl)
	inc	(hl)
	inc	(hl)
	inc	(hl)
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	de, #_shadow_OAM
	ldhl	sp,	#53
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#53
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#52
	ld	(hl-), a
	ld	a, (hl)
	ldhl	sp,	#54
	ld	(hl-), a
	dec	hl
	ld	a, (hl)
	ldhl	sp,	#55
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#58
	ld	a, (hl)
	ld	(de), a
	ldhl	sp,#54
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	push	hl
	ld	a, l
	ldhl	sp,	#54
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#53
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#57
	ld	a, (hl)
	ld	(de), a
;src/rat.c:359: move_sprite(s1, base_x + 4, base_y);
00239$:
;src/rat.c:221: for (uint8_t i = 0; i < MAX_RATS; i++) {
	ldhl	sp,	#56
	inc	(hl)
	jp	00282$
00283$:
;src/rat.c:363: }
	add	sp, #59
	ret
;src/rat.c:365: void kill_rats_at(uint8_t x, uint8_t y) {
;	---------------------------------
; Function kill_rats_at
; ---------------------------------
_kill_rats_at::
	add	sp, #-8
	ldhl	sp,	#5
	ld	(hl-), a
;src/rat.c:367: for (uint8_t i = 0; i < MAX_RATS; i++) {
	ld	a, e
	ld	(hl+), a
	inc	hl
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00115$:
	ldhl	sp,	#7
	ld	a, (hl)
	sub	a, #0x0a
	jp	NC, 00109$
;src/rat.c:368: if (rats[i].active) {
	ld	c, (hl)
	ld	b, #0x00
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, bc
	add	hl, hl
	add	hl, hl
	push	hl
	ld	a, l
	ldhl	sp,	#4
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#3
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	hl, #_rats
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,	#0
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	inc	hl
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
	or	a, a
	jr	Z, 00116$
;src/rat.c:371: if ((rats[i].rat_x == x && rats[i].rat_y == y) ||
	pop	hl
	push	hl
	inc	hl
	ld	c, (hl)
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00106$
	pop	hl
	push	hl
	inc	hl
	inc	hl
	ld	c, (hl)
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, c
	jr	Z, 00101$
00106$:
;src/rat.c:372: (rats[i].target_x == x && rats[i].target_y == y)) {
	pop	hl
	push	hl
	inc	hl
	inc	hl
	inc	hl
	ld	c, (hl)
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00102$
	pop	de
	push	de
	ld	hl, #0x0004
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
	ld	c, a
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, c
	jr	NZ, 00102$
00101$:
;src/rat.c:373: rats[i].active = 0;
	ldhl	sp,	#2
	ld	a, (hl+)
	ld	h, (hl)
	ld	l, a
	ld	(hl), #0x00
;src/rat.c:374: move_sprite(rats[i].sprite_base_idx, 0, 0);
	pop	de
	push	de
	ld	hl, #0x0008
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/rat.c:375: move_sprite(rats[i].sprite_base_idx + 1, 0, 0);
	ld	a, (bc)
	ld	c, a
	inc	c
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	xor	a, a
	ld	l, c
	ld	h, a
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/rat.c:375: move_sprite(rats[i].sprite_base_idx + 1, 0, 0);
	jr	00116$
00102$:
;src/rat.c:377: active_count++;
	ldhl	sp,	#6
	inc	(hl)
00116$:
;src/rat.c:367: for (uint8_t i = 0; i < MAX_RATS; i++) {
	ldhl	sp,	#7
	inc	(hl)
	jp	00115$
00109$:
;src/rat.c:381: if (active_count == 0) {
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	NZ, 00117$
;src/rat.c:382: victory_flag = 1;
	ld	hl, #_victory_flag
	ld	(hl), #0x01
00117$:
;src/rat.c:384: }
	add	sp, #8
	ret
	.area _CODE
	.area _INITIALIZER
__xinit__game_over_flag:
	.db #0x00	; 0
__xinit__victory_flag:
	.db #0x00	; 0
	.area _CABS (ABS)
