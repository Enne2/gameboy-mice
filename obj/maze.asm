;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Linux)
;--------------------------------------------------------
	.module maze
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _rand
	.globl _stack_ptr
	.globl _stack_y
	.globl _stack_x
	.globl _maze
	.globl _generate_maze
;--------------------------------------------------------
; special function registers
;--------------------------------------------------------
	.area _HRAM
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _DATA
_maze::
	.ds 544
_stack_x::
	.ds 100
_stack_y::
	.ds 100
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area _INITIALIZED
_stack_ptr::
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
;src/maze.c:24: static void push(uint8_t x, uint8_t y) {
;	---------------------------------
; Function push
; ---------------------------------
_push:
	ld	d, a
;src/maze.c:25: stack_x[stack_ptr] = x;
	ld	a, #<(_stack_x)
	ld	hl, #_stack_ptr
	add	a, (hl)
	ld	c, a
	ld	a, #>(_stack_x)
	adc	a, #0x00
	ld	b, a
	ld	a, d
	ld	(bc), a
;src/maze.c:26: stack_y[stack_ptr] = y;
	ld	a, #<(_stack_y)
	add	a, (hl)
	ld	c, a
	ld	a, #>(_stack_y)
	adc	a, #0x00
	ld	b, a
	ld	a, e
	ld	(bc), a
;src/maze.c:27: stack_ptr++;
	inc	(hl)
;src/maze.c:28: }
	ret
;src/maze.c:35: static void pop(uint8_t *x, uint8_t *y) {
;	---------------------------------
; Function pop
; ---------------------------------
_pop:
	push	de
;src/maze.c:36: stack_ptr--;
	ld	hl, #_stack_ptr
	dec	(hl)
;src/maze.c:37: *x = stack_x[stack_ptr];
	ld	a, #<(_stack_x)
	add	a, (hl)
	ld	e, a
	ld	a, #>(_stack_x)
	adc	a, #0x00
	ld	d, a
	ld	a, (de)
	pop	hl
	push	hl
	ld	(hl), a
;src/maze.c:38: *y = stack_y[stack_ptr];
	ld	a, #<(_stack_y)
	ld	hl, #_stack_ptr
	add	a, (hl)
	ld	e, a
	ld	a, #>(_stack_y)
	adc	a, #0x00
	ld	d, a
	ld	a, (de)
	ld	(bc), a
;src/maze.c:39: }
	inc	sp
	inc	sp
	ret
;src/maze.c:41: void generate_maze(void) {
;	---------------------------------
; Function generate_maze
; ---------------------------------
_generate_maze::
	add	sp, #-11
;src/maze.c:48: for (y = 0; y < MAZE_HEIGHT; y++) {
	ldhl	sp,	#1
	ld	(hl), #0x00
	ld	c, #0x00
00134$:
;src/maze.c:49: for (x = 0; x < MAZE_WIDTH; x++) {
	ldhl	sp,	#0
	ld	(hl), #0x00
	ld	e, #0x00
00132$:
;src/maze.c:50: maze[y][x] = 1;
	ldhl	sp,	#9
	ld	a, c
	ld	(hl+), a
	ld	(hl), #0x00
	ld	a, #0x05
00273$:
	ldhl	sp,	#9
	sla	(hl)
	inc	hl
	rl	(hl)
	dec	a
	jr	NZ, 00273$
	push	de
	ld	de, #_maze
	ld	a, (hl-)
	ld	l, (hl)
	ld	h, a
	add	hl, de
	pop	de
	ld	d, #0x00
	add	hl, de
	ld	(hl), #0x01
;src/maze.c:49: for (x = 0; x < MAZE_WIDTH; x++) {
	inc	e
	ldhl	sp,	#0
	ld	a,e
	ld	(hl),a
	sub	a, #0x13
	jr	C, 00132$
;src/maze.c:48: for (y = 0; y < MAZE_HEIGHT; y++) {
	ld	a, #0x13
	ld	(hl+), a
	inc	c
	ld	a,c
	ld	(hl),a
	sub	a, #0x11
	jr	C, 00134$
;src/maze.c:56: stack_ptr = 0;
	ld	(hl), #0x11
	xor	a, a
	ld	(#_stack_ptr),a
;src/maze.c:57: push(1, 1);
	ld	a,#0x01
	ld	e,a
	call	_push
;src/maze.c:58: maze[1][1] = 0; // 0 = calpestabile
	ld	hl, #_maze + 33
	ld	(hl), #0x00
;src/maze.c:61: while (stack_ptr > 0) {
00129$:
	ld	hl, #_stack_ptr
	ld	a, (hl)
	or	a, a
	jp	Z, 00136$
;src/maze.c:63: x = stack_x[stack_ptr - 1];
	ld	a, (hl)
	dec	a
	ld	e, a
	rlca
	sbc	a, a
	ld	d, a
	ld	hl, #_stack_x
	add	hl, de
	ld	b, (hl)
	ldhl	sp,	#0
	ld	(hl), b
;src/maze.c:64: y = stack_y[stack_ptr - 1];
	ld	hl, #_stack_y
	add	hl, de
	ld	e, (hl)
	ldhl	sp,	#1
	ld	(hl), e
;src/maze.c:67: count = 0;
	ld	c, #0x00
;src/maze.c:68: if (x >= 2 && maze[y][x - 2] == 1) dirs[count++] = 0; // Controllo Sinistra
	ld	a, b
	sub	a, #0x02
	jr	C, 00104$
	ld	l, e
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	de, #_maze
	add	hl, de
	ld	e, b
	dec	e
	dec	e
	ld	d, #0x00
	add	hl, de
	ld	a, (hl)
	dec	a
	jr	NZ, 00104$
	ld	c, #0x01
	ldhl	sp,	#2
	ld	(hl), #0x00
00104$:
;src/maze.c:69: if (x <= MAZE_WIDTH - 3 && maze[y][x + 2] == 1) dirs[count++] = 1; // Controllo Destra
	ld	a, #0x10
	ldhl	sp,	#0
	sub	a, (hl)
	jr	C, 00107$
	inc	hl
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
	ldhl	sp,	#0
	ld	a, (hl)
	add	a, #0x02
	ld	l, a
	ld	h, #0x00
	add	hl, de
	ld	a, (hl)
	dec	a
	jr	NZ, 00107$
	ld	e, c
	inc	c
	ld	d, #0x00
	ld	hl, #2
	add	hl, sp
	add	hl, de
	ld	(hl), #0x01
00107$:
;src/maze.c:70: if (y >= 2 && maze[y - 2][x] == 1) dirs[count++] = 2; // Controllo Su
	ldhl	sp,	#1
	ld	a, (hl)
	sub	a, #0x02
	jr	C, 00110$
	ld	b, (hl)
	xor	a, a
	ld	l, b
	ld	h, a
	dec	hl
	dec	hl
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
	ldhl	sp,	#0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	a, (hl)
	dec	a
	jr	NZ, 00110$
	ld	e, c
	inc	c
	ld	d, #0x00
	ld	hl, #2
	add	hl, sp
	add	hl, de
	ld	(hl), #0x02
00110$:
;src/maze.c:71: if (y <= MAZE_HEIGHT - 3 && maze[y + 2][x] == 1) dirs[count++] = 3; // Controllo Giù
	ld	a, #0x0e
	ldhl	sp,	#1
	sub	a, (hl)
	jr	C, 00113$
	ld	b, (hl)
	xor	a, a
	ld	l, b
	ld	h, a
	inc	hl
	inc	hl
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
	ldhl	sp,	#0
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	a, (hl)
	dec	a
	jr	NZ, 00113$
	ld	e, c
	inc	c
	ld	d, #0x00
	ld	hl, #2
	add	hl, sp
	add	hl, de
	ld	(hl), #0x03
00113$:
;src/maze.c:73: if (count > 0) {
	ld	a, c
	or	a, a
	jp	Z, 00127$
;src/maze.c:76: r = rand() % count;
	call	_rand
	ld	a, e
	ld	e, c
;src/maze.c:78: nx = x; ny = y;
	call	__moduchar
	ldhl	sp,	#0
	ld	a, (hl+)
	ld	d, a
	ld	e, (hl)
;src/maze.c:80: if (dirs[r] == 0) { nx -= 2; maze[y][x - 1] = 0; }
	push	de
	ld	e, c
	ld	d, #0x00
	ld	hl, #4
	add	hl, sp
	add	hl, de
	pop	de
	ld	a, (hl)
	ldhl	sp,	#6
	ld	(hl), a
;src/maze.c:69: if (x <= MAZE_WIDTH - 3 && maze[y][x + 2] == 1) dirs[count++] = 1; // Controllo Destra
	ldhl	sp,	#0
	ld	a, (hl)
	ldhl	sp,	#7
;src/maze.c:80: if (dirs[r] == 0) { nx -= 2; maze[y][x - 1] = 0; }
	ld	(hl+), a
	ld	(hl), d
	ld	l, e
	ld	h, #0x00
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	bc, #_maze
	add	hl, bc
	push	hl
	ld	a, l
	ldhl	sp,	#11
	ld	(hl), a
	pop	hl
	ld	a, h
	ldhl	sp,	#10
	ld	(hl), a
	ldhl	sp,	#6
	ld	a, (hl)
	or	a, a
	jr	NZ, 00124$
	inc	hl
	inc	hl
	ld	a, (hl-)
	ld	d, a
	dec	d
	dec	d
	ld	a, (hl+)
	inc	hl
	dec	a
	push	de
	ld	e, a
	ld	d, #0x00
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	jr	00125$
00124$:
;src/maze.c:81: else if (dirs[r] == 1) { nx += 2; maze[y][x + 1] = 0; }
	ldhl	sp,	#6
	ld	a, (hl)
	dec	a
	jr	NZ, 00121$
	ldhl	sp,	#8
	ld	a, (hl-)
	ld	d, a
	inc	d
	inc	d
	ld	a, (hl+)
	inc	hl
	inc	a
	push	de
	ld	e, a
	ld	d, #0x00
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	pop	de
	ld	c, l
	ld	b, h
	xor	a, a
	ld	(bc), a
	jr	00125$
00121$:
;src/maze.c:69: if (x <= MAZE_WIDTH - 3 && maze[y][x + 2] == 1) dirs[count++] = 1; // Controllo Destra
	ldhl	sp,	#1
	ld	c, (hl)
	ld	b, #0x00
;src/maze.c:82: else if (dirs[r] == 2) { ny -= 2; maze[y - 1][x] = 0; }
	ld	l, e
	push	hl
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x02
	pop	hl
	jr	NZ, 00118$
	ld	e, l
	dec	e
	dec	e
	dec	bc
	ld	l, c
	ld	h, b
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	bc, #_maze
	add	hl, bc
	ld	c, d
	ld	b, #0x00
	add	hl, bc
	ld	(hl), #0x00
	jr	00125$
00118$:
;src/maze.c:83: else if (dirs[r] == 3) { ny += 2; maze[y + 1][x] = 0; }
	push	hl
	ldhl	sp,	#8
	ld	a, (hl)
	sub	a, #0x03
	pop	hl
	jr	NZ, 00125$
	ld	e, l
	inc	e
	inc	e
	ld	l, c
	ld	h, b
	inc	hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	bc, #_maze
	add	hl, bc
	ld	c, d
	ld	b, #0x00
	add	hl, bc
	ld	(hl), #0x00
00125$:
;src/maze.c:86: maze[ny][nx] = 0;
	ld	l, e
	xor	a, a
	ld	h, a
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	add	hl, hl
	ld	bc, #_maze
	add	hl, bc
	ld	c, d
	ld	b, #0x00
	add	hl, bc
	ld	(hl), #0x00
;src/maze.c:88: push(nx, ny);
	ld	a, d
	call	_push
	jp	00129$
00127$:
;src/maze.c:92: pop(&x, &y);
	ldhl	sp,	#1
	ld	c, l
	ld	b, h
	ldhl	sp,	#0
	ld	e, l
	ld	d, h
	call	_pop
	jp	00129$
00136$:
;src/maze.c:95: }
	add	sp, #11
	ret
	.area _CODE
	.area _INITIALIZER
__xinit__stack_ptr:
	.db #0x00	; 0
	.area _CABS (ABS)
