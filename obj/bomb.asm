;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Linux)
;--------------------------------------------------------
	.module bomb
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _set_sprite_data
	.globl _play_sfx_bomb_drop
	.globl _play_sfx_explosion
	.globl _kill_rats_at
	.globl _init_bombs
	.globl _drop_bomb
	.globl _update_bombs
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_bomb:
	.ds 5
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
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
;src/bomb.c:27: void init_bombs(void) {
;	---------------------------------
; Function init_bombs
; ---------------------------------
_init_bombs::
;src/bomb.c:28: bomb.state = BOMB_STATE_INACTIVE;
	ld	hl, #_bomb
	ld	(hl), #0x00
;src/bomb.c:29: set_sprite_data(5, 6, BombSpriteData);
	ld	de, #_BombSpriteData
	push	de
	ld	hl, #0x605
	push	hl
	call	_set_sprite_data
	add	sp, #4
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 152)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/bomb.c:31: for(uint8_t i = 0; i < EXP_POOL_SIZE; i++) {
	ld	c, #0x00
00105$:
	ld	a, c
	sub	a, #0x0d
	ret	NC
;src/bomb.c:32: move_sprite(exp_sprite_pool[i], 0, 0);
	ld	hl, #_exp_sprite_pool
	ld	b, #0x00
	add	hl, bc
	ld	b, (hl)
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	xor	a, a
	ld	l, b
	ld	h, a
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/bomb.c:31: for(uint8_t i = 0; i < EXP_POOL_SIZE; i++) {
	inc	c
;src/bomb.c:34: }
	jr	00105$
_exp_sprite_pool:
	.db #0x14	; 20
	.db #0x15	; 21
	.db #0x16	; 22
	.db #0x17	; 23
	.db #0x1d	; 29
	.db #0x1e	; 30
	.db #0x1f	; 31
	.db #0x20	; 32
	.db #0x21	; 33
	.db #0x22	; 34
	.db #0x23	; 35
	.db #0x24	; 36
	.db #0x25	; 37
;src/bomb.c:36: void drop_bomb(uint8_t x, uint8_t y) {
;	---------------------------------
; Function drop_bomb
; ---------------------------------
_drop_bomb::
	ld	c, a
;src/bomb.c:37: if (bomb.state == BOMB_STATE_INACTIVE) {
	ld	hl, #_bomb
	ld	a, (hl)
	or	a, a
	ret	NZ
;src/bomb.c:38: bomb.state = BOMB_STATE_TICKING;
	ld	(hl), #0x01
;src/bomb.c:39: bomb.x = x;
	ld	hl, #_bomb + 1
	ld	(hl), c
;src/bomb.c:40: bomb.y = y;
	ld	hl, #_bomb + 2
	ld	(hl), e
;src/bomb.c:41: bomb.timer = 180; // 3 seconds
	ld	hl, #(_bomb + 3)
	ld	a, #0xb4
	ld	(hl+), a
	ld	(hl), #0x00
;src/bomb.c:42: play_sfx_bomb_drop(); // Suono innesco
;src/bomb.c:44: }
	jp	_play_sfx_bomb_drop
;src/bomb.c:46: static void hide_explosion(void) {
;	---------------------------------
; Function hide_explosion
; ---------------------------------
_hide_explosion:
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 152)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/bomb.c:48: for(uint8_t i = 0; i < EXP_POOL_SIZE; i++) {
	ld	c, #0x00
00105$:
	ld	a, c
	sub	a, #0x0d
	ret	NC
;src/bomb.c:49: move_sprite(exp_sprite_pool[i], 0, 0);
	ld	hl, #_exp_sprite_pool
	ld	b, #0x00
	add	hl, bc
	ld	b, (hl)
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	xor	a, a
	ld	l, b
	ld	h, a
	add	hl, hl
	add	hl, hl
	ld	de, #_shadow_OAM
	add	hl, de
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
;src/bomb.c:48: for(uint8_t i = 0; i < EXP_POOL_SIZE; i++) {
	inc	c
;src/bomb.c:51: }
	jr	00105$
;src/bomb.c:53: static void do_explosion_damage(uint8_t ex, uint8_t ey) {
;	---------------------------------
; Function do_explosion_damage
; ---------------------------------
_do_explosion_damage:
;src/bomb.c:54: kill_rats_at(ex, ey);
;src/bomb.c:55: }
	jp	_kill_rats_at
;src/bomb.c:57: void update_bombs(void) {
;	---------------------------------
; Function update_bombs
; ---------------------------------
_update_bombs::
	add	sp, #-6
;src/bomb.c:58: if (bomb.state == BOMB_STATE_TICKING) {
	ld	a, (#_bomb + 0)
;src/bomb.c:59: bomb.timer--;
;src/bomb.c:58: if (bomb.state == BOMB_STATE_TICKING) {
	ldhl	sp,#5
	ld	(hl), a
	ld	a, (hl)
	dec	a
	jp	NZ, 00145$
;src/bomb.c:59: bomb.timer--;
	ld	hl, #(_bomb + 3)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	dec	bc
	ld	hl, #(_bomb + 3)
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/bomb.c:61: uint8_t px = bomb.x * 8 + 12;
	ld	a, (#(_bomb + 1) + 0)
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x0c
	ldhl	sp,	#2
;src/bomb.c:62: uint8_t py = bomb.y * 8 + 20;
	ld	(hl+), a
	ld	a, (#(_bomb + 2) + 0)
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x14
	ld	(hl), a
;src/bomb.c:64: if (bomb.timer > 120) {
	ld	a, #0x78
	cp	a, c
	ld	a, #0x00
	sbc	a, b
	jr	NC, 00108$
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 154)
	ld	(hl), #0x05
;src/bomb.c:65: set_sprite_tile(38, 5); // bomb_3
	jr	00109$
00108$:
;src/bomb.c:66: } else if (bomb.timer > 60) {
	ld	hl, #(_bomb + 3)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ld	e, c
	ld	d, b
	ld	a, #0x3c
	cp	a, e
	ld	a, #0x00
	sbc	a, d
	jr	NC, 00105$
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 154)
	ld	(hl), #0x06
;src/bomb.c:67: set_sprite_tile(38, 6); // bomb_2
	jr	00109$
00105$:
;src/bomb.c:69: if (bomb.timer & 4) {
	bit	2, c
	jr	Z, 00102$
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 154)
	ld	(hl), #0x07
;src/bomb.c:70: set_sprite_tile(38, 7); // bomb_1
	jr	00109$
00102$:
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 154)
	ld	(hl), #0x05
;src/bomb.c:72: set_sprite_tile(38, 5);
00109$:
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+152
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ldhl	sp,	#3
	ld	a, (hl-)
	ld	(bc), a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
;src/bomb.c:78: if (bomb.timer == 0) {
	ld	hl, #(_bomb + 3)
	ld	a, (hl+)
	or	a, (hl)
	jp	NZ, 00162$
;src/bomb.c:79: bomb.state = BOMB_STATE_EXPLODING;
	ld	hl, #_bomb
	ld	(hl), #0x02
;src/bomb.c:80: bomb.timer = 30; // 0.5s explosion
	ld	hl, #(_bomb + 3)
	ld	a, #0x1e
	ld	(hl+), a
	ld	(hl), #0x00
;src/bomb.c:82: play_sfx_explosion();
	call	_play_sfx_explosion
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 154)
	ld	(hl), #0x08
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	bc, #_shadow_OAM+152
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ldhl	sp,	#3
	ld	a, (hl-)
	ld	(bc), a
	inc	bc
	ld	a, (hl)
	ld	(bc), a
;src/bomb.c:86: do_explosion_damage(bomb.x, bomb.y);
	ld	hl, #(_bomb + 2)
	ld	e, (hl)
	ld	a, (#(_bomb + 1) + 0)
	call	_do_explosion_damage
;src/bomb.c:91: uint8_t yy = bomb.y;
	ld	a, (#(_bomb + 2) + 0)
	ldhl	sp,	#4
	ld	(hl), a
;src/bomb.c:92: while (yy > 0) {
	ldhl	sp,	#5
	ld	(hl), #0x00
00114$:
	ldhl	sp,	#4
	ld	a, (hl)
	or	a, a
	jr	Z, 00116$
;src/bomb.c:93: yy--;
	dec	(hl)
;src/bomb.c:94: if (maze[yy][bomb.x] != 0) break;
	ld	c, (hl)
	xor	a, a
	ld	l, c
	ld	h, a
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
	ld	hl, #(_bomb + 1)
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	a, (hl)
	or	a, a
	jr	NZ, 00116$
;src/bomb.c:95: if (pool_idx < EXP_POOL_SIZE) {
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0x0d
	jr	NC, 00113$
;src/bomb.c:96: uint8_t sp = exp_sprite_pool[pool_idx++];
	ld	de, #_exp_sprite_pool
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	inc	sp
	inc	sp
	push	hl
	ldhl	sp,	#5
	inc	(hl)
	pop	de
	push	de
	ld	a, (de)
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	ld	e, l
	ld	d, h
	ld	hl,#_shadow_OAM + 1
	add	hl,de
	inc	hl
	ld	(hl), #0x0a
;src/bomb.c:98: move_sprite(sp, px, (yy * 8) + 20);
	ldhl	sp,	#4
	ld	a, (hl)
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x14
	ld	c, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
	add	hl, de
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	a, c
	ld	(hl+), a
	ld	c, l
	ld	b, h
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(bc), a
;src/bomb.c:98: move_sprite(sp, px, (yy * 8) + 20);
00113$:
;src/bomb.c:100: do_explosion_damage(bomb.x, yy);
	ld	a, (#(_bomb + 1) + 0)
	ldhl	sp,	#4
	ld	e, (hl)
	call	_do_explosion_damage
	jr	00114$
00116$:
;src/bomb.c:104: yy = bomb.y;
	ld	hl, #(_bomb + 2)
	ld	c, (hl)
;src/bomb.c:105: while (yy < MAZE_HEIGHT - 1) {
00121$:
;src/bomb.c:61: uint8_t px = bomb.x * 8 + 12;
	ld	hl, #(_bomb + 1)
	ld	b, (hl)
;src/bomb.c:105: while (yy < MAZE_HEIGHT - 1) {
	ld	a, c
	sub	a, #0x10
	jr	NC, 00123$
;src/bomb.c:106: yy++;
	inc	c
;src/bomb.c:107: if (maze[yy][bomb.x] != 0) break;
	ld	l, c
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #_maze
	add	hl, de
	ld	e, b
	ld	d, #0x00
	add	hl, de
	ld	a, (hl)
	or	a, a
	jr	NZ, 00123$
;src/bomb.c:108: if (pool_idx < EXP_POOL_SIZE) {
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0x0d
	jr	NC, 00120$
;src/bomb.c:109: uint8_t sp = exp_sprite_pool[pool_idx++];
	ld	de, #_exp_sprite_pool
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ldhl	sp,	#5
	inc	(hl)
	ld	a, (de)
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	ld	e, l
	ld	d, h
	ld	hl,#_shadow_OAM + 1
	add	hl,de
	inc	hl
	ld	(hl), #0x0a
;src/bomb.c:111: move_sprite(sp, px, (yy * 8) + 20);
	ld	a, c
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x14
	ld	b, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
	add	hl, de
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	a, b
	ld	(hl+), a
	ld	e, l
	ld	d, h
	ldhl	sp,	#2
	ld	a, (hl)
	ld	(de), a
;src/bomb.c:111: move_sprite(sp, px, (yy * 8) + 20);
00120$:
;src/bomb.c:113: do_explosion_damage(bomb.x, yy);
	ld	a, (#(_bomb + 1) + 0)
	push	bc
	ld	e, c
	call	_do_explosion_damage
	pop	bc
	jr	00121$
00123$:
;src/bomb.c:117: uint8_t xx = bomb.x;
	ldhl	sp,	#4
;src/bomb.c:118: while (xx > 0) {
	ld	a, b
	ld	(hl+), a
	ld	c, (hl)
00128$:
	ldhl	sp,	#4
	ld	a, (hl)
	or	a, a
	jr	Z, 00130$
;src/bomb.c:119: xx--;
	dec	(hl)
;src/bomb.c:120: if (maze[bomb.y][xx] != 0) break;
	ld	hl, #(_bomb + 2)
	ld	l, (hl)
	ld	h, #0x00
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
	ldhl	sp,	#4
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	e, l
	ld	d, h
	ld	a, (de)
	or	a, a
	jr	NZ, 00130$
;src/bomb.c:121: if (pool_idx < EXP_POOL_SIZE) {
	ld	a, c
	sub	a, #0x0d
	jr	NC, 00127$
;src/bomb.c:122: uint8_t sp = exp_sprite_pool[pool_idx++];
	ld	de, #_exp_sprite_pool
	ld	l, c
	ld	h, #0x00
	add	hl, de
	push	hl
	ld	a, l
	ldhl	sp,	#3
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#2
	ld	(hl-), a
	inc	c
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	a, (de)
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	ld	e, l
	ld	d, h
	ld	hl,#_shadow_OAM + 1
	add	hl,de
	inc	hl
	ld	(hl), #0x09
;src/bomb.c:124: move_sprite(sp, (xx * 8) + 12, py);
	ldhl	sp,	#4
	ld	a, (hl)
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x0c
	ld	b, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
	add	hl, de
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	push	hl
	ldhl	sp,	#5
	ld	a, (hl)
	pop	hl
	ld	(hl+), a
	ld	(hl), b
;src/bomb.c:124: move_sprite(sp, (xx * 8) + 12, py);
00127$:
;src/bomb.c:126: do_explosion_damage(xx, bomb.y);
	ld	a, (#(_bomb + 2) + 0)
	push	bc
	ld	e, a
	ldhl	sp,	#6
	ld	a, (hl)
	call	_do_explosion_damage
	pop	bc
	jr	00128$
00130$:
;src/bomb.c:130: xx = bomb.x;
	ld	a, (#(_bomb + 1) + 0)
	ldhl	sp,	#4
	ld	(hl), a
;src/bomb.c:131: while (xx < MAZE_WIDTH - 1) {
	ldhl	sp,	#5
	ld	(hl), c
00135$:
	ldhl	sp,	#4
	ld	a, (hl)
	sub	a, #0x12
	jp	NC, 00162$
;src/bomb.c:132: xx++;
	inc	(hl)
;src/bomb.c:133: if (maze[bomb.y][xx] != 0) break;
	ld	hl, #(_bomb + 2)
	ld	l, (hl)
	xor	a, a
	ld	h, a
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
	ldhl	sp,	#4
	ld	l, (hl)
	ld	h, #0x00
	add	hl, bc
	ld	c, l
	ld	b, h
	ld	a, (bc)
	or	a, a
	jr	NZ, 00162$
;src/bomb.c:134: if (pool_idx < EXP_POOL_SIZE) {
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0x0d
	jr	NC, 00134$
;src/bomb.c:135: uint8_t sp = exp_sprite_pool[pool_idx++];
	ld	de, #_exp_sprite_pool
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ldhl	sp,	#5
	inc	(hl)
	ld	a, (bc)
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	l, a
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	ld	e, l
	ld	d, h
	ld	hl,#_shadow_OAM + 1
	add	hl,de
	inc	hl
	ld	(hl), #0x09
;src/bomb.c:137: move_sprite(sp, (xx * 8) + 12, py);
	ldhl	sp,	#4
	ld	a, (hl)
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x0c
	ld	c, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #_shadow_OAM
	add	hl, de
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	push	hl
	ldhl	sp,	#5
	ld	a, (hl)
	pop	hl
	ld	(hl+), a
	ld	(hl), c
;src/bomb.c:137: move_sprite(sp, (xx * 8) + 12, py);
00134$:
;src/bomb.c:139: do_explosion_damage(xx, bomb.y);
	ld	a, (#(_bomb + 2) + 0)
	ld	e, a
	ldhl	sp,	#4
	ld	a, (hl)
	call	_do_explosion_damage
	jr	00135$
00145$:
;src/bomb.c:142: } else if (bomb.state == BOMB_STATE_EXPLODING) {
	ldhl	sp,	#5
	ld	a, (hl)
	sub	a, #0x02
	jr	NZ, 00162$
;src/bomb.c:143: bomb.timer--;
	ld	hl, #(_bomb + 3)
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	dec	bc
	ld	hl, #(_bomb + 3)
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/bomb.c:144: if (bomb.timer == 0) {
	ld	a, b
	or	a, c
	jr	NZ, 00162$
;src/bomb.c:145: bomb.state = BOMB_STATE_INACTIVE;
	ld	hl, #_bomb
	ld	(hl), #0x00
;src/bomb.c:146: hide_explosion();
	call	_hide_explosion
00162$:
;src/bomb.c:149: }
	add	sp, #6
	ret
	.area _CODE
	.area _INITIALIZER
	.area _CABS (ABS)
