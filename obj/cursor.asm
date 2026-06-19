;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Linux)
;--------------------------------------------------------
	.module cursor
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _toggle_music
	.globl _drop_bomb
	.globl _set_sprite_data
	.globl _joypad
	.globl _CursorSpriteData
	.globl _init_cursor
	.globl _update_cursor
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_update_cursor_cursor_timer_10000_148:
	.ds 1
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_cursor_x:
	.ds 1
_cursor_y:
	.ds 1
_previous_keys:
	.ds 1
_blink:
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
;src/cursor.c:36: static uint8_t cursor_timer = 0;
	xor	a, a
	ld	hl, #_update_cursor_cursor_timer_10000_148
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
;src/cursor.c:18: void init_cursor(void) {
;	---------------------------------
; Function init_cursor
; ---------------------------------
_init_cursor::
;src/cursor.c:19: cursor_x = 1;
	ld	hl, #_cursor_x
	ld	(hl), #0x01
;src/cursor.c:20: cursor_y = 1;
	ld	hl, #_cursor_y
	ld	(hl), #0x01
;src/cursor.c:21: previous_keys = 0;
;src/cursor.c:22: blink = 0;
	xor	a, a
	ld	(#_previous_keys), a
	ld	(#_blink),a
;src/cursor.c:26: set_sprite_data(4, 1, CursorSpriteData);
	ld	de, #_CursorSpriteData
	push	de
	ld	hl, #0x104
	push	hl
	call	_set_sprite_data
	add	sp, #4
;/home/enne2/.local/gbdk/include/gb/gb.h:1887: shadow_OAM[nb].tile=tile;
	ld	hl, #(_shadow_OAM + 158)
	ld	(hl), #0x04
;src/cursor.c:29: set_sprite_tile(39, 4); 
;src/cursor.c:30: }
	ret
_CursorSpriteData:
	.db #0xff	; 255
	.db #0xff	; 255
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0x81	; 129
	.db #0xff	; 255
	.db #0xff	; 255
;src/cursor.c:32: void update_cursor(void) {
;	---------------------------------
; Function update_cursor
; ---------------------------------
_update_cursor::
;src/cursor.c:33: uint8_t keys = joypad();
	call	_joypad
	ld	c, a
;src/cursor.c:37: uint8_t moved = 0;
	ld	b, #0x00
;src/cursor.c:40: uint8_t dpad = keys & (J_UP | J_DOWN | J_LEFT | J_RIGHT);
	ld	a, c
	and	a, #0x0f
	ld	e, a
;src/cursor.c:42: if (dpad) {
	or	a, a
	jr	Z, 00108$
;src/cursor.c:43: if (cursor_timer == 0) {
	ld	a, (#_update_cursor_cursor_timer_10000_148)
	or	a, a
	jr	NZ, 00105$
;src/cursor.c:44: moved = 1;
	ld	b, #0x01
;src/cursor.c:46: if (!(previous_keys & dpad)) {
	ld	a, (#_previous_keys)
	and	a, e
	jr	NZ, 00102$
;src/cursor.c:47: cursor_timer = 12; // Initial delay
	ld	hl, #_update_cursor_cursor_timer_10000_148
	ld	(hl), #0x0c
	jr	00109$
00102$:
;src/cursor.c:49: cursor_timer = 6;  // Repeat delay (il moltiplicatore di velocità)
	ld	hl, #_update_cursor_cursor_timer_10000_148
	ld	(hl), #0x06
	jr	00109$
00105$:
;src/cursor.c:52: cursor_timer--;
	ld	hl, #_update_cursor_cursor_timer_10000_148
	dec	(hl)
	jr	00109$
00108$:
;src/cursor.c:55: cursor_timer = 0; // Azzera il timer se si rilasciano le frecce
	xor	a, a
	ld	(#_update_cursor_cursor_timer_10000_148),a
00109$:
;src/cursor.c:58: if (moved) {
	ld	a, b
	or	a, a
	jr	Z, 00130$
;src/cursor.c:59: if (keys & J_UP) {
	bit	2, c
	jr	Z, 00127$
;src/cursor.c:60: if (cursor_y > 1) cursor_y--;
	ld	a, #0x01
	ld	hl, #_cursor_y
	sub	a, (hl)
	jr	NC, 00130$
	dec	(hl)
	jr	00130$
00127$:
;src/cursor.c:61: } else if (keys & J_DOWN) {
	bit	3, c
	jr	Z, 00124$
;src/cursor.c:62: if (cursor_y < MAZE_HEIGHT - 2) cursor_y++;
	ld	hl, #_cursor_y
	ld	a, (hl)
	sub	a, #0x0f
	jr	NC, 00130$
	inc	(hl)
	jr	00130$
00124$:
;src/cursor.c:63: } else if (keys & J_LEFT) {
	bit	1, c
	jr	Z, 00121$
;src/cursor.c:64: if (cursor_x > 1) cursor_x--;
	ld	a, #0x01
	ld	hl, #_cursor_x
	sub	a, (hl)
	jr	NC, 00130$
	dec	(hl)
	jr	00130$
00121$:
;src/cursor.c:65: } else if (keys & J_RIGHT) {
	bit	0, c
	jr	Z, 00130$
;src/cursor.c:66: if (cursor_x < MAZE_WIDTH - 2) cursor_x++;
	ld	hl, #_cursor_x
	ld	a, (hl)
	sub	a, #0x11
	jr	NC, 00130$
	inc	(hl)
00130$:
;src/cursor.c:71: if ((keys & J_A) && !(previous_keys & J_A)) {
	bit	4, c
	jr	Z, 00132$
	ld	a, (_previous_keys)
	bit	4, a
	jr	NZ, 00132$
;src/cursor.c:72: drop_bomb(cursor_x, cursor_y);
	push	bc
	ld	a, (_cursor_y)
	ld	e, a
	ld	a, (_cursor_x)
	call	_drop_bomb
	pop	bc
00132$:
;src/cursor.c:76: if ((keys & J_SELECT) && !(previous_keys & J_SELECT)) {
	bit	6, c
	jr	Z, 00135$
	ld	a, (_previous_keys)
	bit	6, a
	jr	NZ, 00135$
;src/cursor.c:77: toggle_music();
	push	bc
	call	_toggle_music
	pop	bc
00135$:
;src/cursor.c:80: previous_keys = keys;
	ld	hl, #_previous_keys
	ld	(hl), c
;src/cursor.c:83: blink++;
	ld	hl, #_blink
	inc	(hl)
;src/cursor.c:84: if (blink & 0x10) {
	ld	a, (hl)
	bit	4, a
	jr	Z, 00138$
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 156)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl), #0x00
	inc	hl
	ld	(hl), #0x00
;src/cursor.c:85: move_sprite(39, 0, 0); // Nascondi spostandolo fuori schermo
	ret
00138$:
;src/cursor.c:88: move_sprite(39, cursor_x * 8 + 12, cursor_y * 8 + 20);
	ld	a, (_cursor_y)
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x14
	ld	b, a
	ld	a, (_cursor_x)
	add	a, a
	add	a, a
	add	a, a
	add	a, #0x0c
	ld	c, a
;/home/enne2/.local/gbdk/include/gb/gb.h:1973: OAM_item_t * itm = &shadow_OAM[nb];
	ld	hl, #(_shadow_OAM + 156)
;/home/enne2/.local/gbdk/include/gb/gb.h:1974: itm->y=y, itm->x=x;
	ld	(hl), b
	inc	hl
	ld	(hl), c
;src/cursor.c:88: move_sprite(39, cursor_x * 8 + 12, cursor_y * 8 + 20);
;src/cursor.c:90: }
	ret
	.area _CODE
	.area _INITIALIZER
__xinit__cursor_x:
	.db #0x01	; 1
__xinit__cursor_y:
	.db #0x01	; 1
__xinit__previous_keys:
	.db #0x00	; 0
__xinit__blink:
	.db #0x00	; 0
	.area _CABS (ABS)
