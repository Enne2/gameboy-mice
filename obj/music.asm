;--------------------------------------------------------
; File Created by SDCC : free open source ISO C Compiler
; Version 4.5.1 #15267 (Linux)
;--------------------------------------------------------
	.module music
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _music_enabled
	.globl _victory_bass
	.globl _victory_mel
	.globl _title_bass
	.globl _title_mel
	.globl _go_drum
	.globl _go_arp
	.globl _go_bass
	.globl _go_mel
	.globl _drum_parts
	.globl _trk_drum_3
	.globl _trk_drum_2
	.globl _trk_drum_1
	.globl _trk_drum_0
	.globl _wave_ram
	.globl _bass_parts
	.globl _trk_bass_3
	.globl _trk_bass_2
	.globl _trk_bass_1
	.globl _trk_bass_0
	.globl _mel_parts
	.globl _trk_mel_3
	.globl _trk_mel_2
	.globl _trk_mel_1
	.globl _trk_mel_0
	.globl _arp_parts
	.globl _trk_arp_3
	.globl _trk_arp_2
	.globl _trk_arp_1
	.globl _trk_arp_0
	.globl _toggle_music
	.globl _play_sfx_moan
	.globl _play_sfx_plop
	.globl _init_music
	.globl _update_music
	.globl _play_game_over_music
	.globl _play_sfx_explosion
	.globl _play_sfx_bomb_drop
	.globl _play_title_music
	.globl _play_victory_music
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
_tick:
	.ds 2
_frame_counter:
	.ds 1
_sfx_timer:
	.ds 1
_game_over_mode:
	.ds 1
_music_enabled::
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
;src/music.c:279: void toggle_music(void) {
;	---------------------------------
; Function toggle_music
; ---------------------------------
_toggle_music::
;src/music.c:280: music_enabled = !music_enabled;
	ld	hl, #_music_enabled
	ld	a, (hl)
	sub	a, #0x01
	ld	a, #0x00
	rla
	ld	(hl), a
;src/music.c:281: if (!music_enabled) {
	ld	a, (hl)
;src/music.c:283: NR12_REG = 0x00; NR14_REG = 0x80;
	or	a, a
	ret	NZ
	ldh	(_NR12_REG + 0), a
	ld	a, #0x80
	ldh	(_NR14_REG + 0), a
;src/music.c:284: NR22_REG = 0x00; NR24_REG = 0x80;
	xor	a, a
	ldh	(_NR22_REG + 0), a
	ld	a, #0x80
	ldh	(_NR24_REG + 0), a
;src/music.c:285: NR32_REG = 0x00; NR34_REG = 0x80;
	xor	a, a
	ldh	(_NR32_REG + 0), a
	ld	a, #0x80
	ldh	(_NR34_REG + 0), a
;src/music.c:286: NR42_REG = 0x00; NR44_REG = 0x80;
	xor	a, a
	ldh	(_NR42_REG + 0), a
	ld	a, #0x80
	ldh	(_NR44_REG + 0), a
;src/music.c:288: }
	ret
_trk_arp_0:
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0706
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0706
	.dw #0x0672
_trk_arp_1:
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
_trk_arp_2:
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x0672
	.dw #0x06c6
	.dw #0x06f7
	.dw #0x06c6
	.dw #0x0672
	.dw #0x06c6
	.dw #0x06f7
	.dw #0x06c6
	.dw #0x0672
	.dw #0x06c6
	.dw #0x06f7
	.dw #0x06c6
	.dw #0x0672
	.dw #0x06c6
	.dw #0x06f7
	.dw #0x06c6
	.dw #0x06d6
	.dw #0x0706
	.dw #0x0739
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0706
	.dw #0x0739
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0706
	.dw #0x0739
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0706
	.dw #0x0739
	.dw #0x0706
_trk_arp_3:
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x06b2
	.dw #0x06f7
	.dw #0x0641
	.dw #0x06f7
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0706
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0706
	.dw #0x0672
_arp_parts:
	.dw _trk_arp_0
	.dw _trk_arp_1
	.dw _trk_arp_2
	.dw _trk_arp_3
_trk_mel_0:
	.dw #0x0739
	.dw #0x0000
	.dw #0x0721
	.dw #0x0706
	.dw #0x0000
	.dw #0x0759
	.dw #0x0000
	.dw #0x0000
	.dw #0x0739
	.dw #0x0000
	.dw #0x0721
	.dw #0x0706
	.dw #0x0000
	.dw #0x0759
	.dw #0x0000
	.dw #0x0000
	.dw #0x0744
	.dw #0x0000
	.dw #0x0739
	.dw #0x0721
	.dw #0x0000
	.dw #0x076b
	.dw #0x0000
	.dw #0x0000
	.dw #0x0744
	.dw #0x0000
	.dw #0x0739
	.dw #0x0721
	.dw #0x0000
	.dw #0x076b
	.dw #0x0000
	.dw #0x0000
	.dw #0x0759
	.dw #0x0000
	.dw #0x0744
	.dw #0x0739
	.dw #0x0000
	.dw #0x077b
	.dw #0x0000
	.dw #0x0000
	.dw #0x0759
	.dw #0x0000
	.dw #0x0744
	.dw #0x0739
	.dw #0x0000
	.dw #0x077b
	.dw #0x0000
	.dw #0x0000
	.dw #0x0783
	.dw #0x0000
	.dw #0x077b
	.dw #0x076b
	.dw #0x0759
	.dw #0x0744
	.dw #0x0739
	.dw #0x0721
	.dw #0x0706
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
_trk_mel_1:
	.dw #0x0739
	.dw #0x0000
	.dw #0x0739
	.dw #0x0000
	.dw #0x0721
	.dw #0x0706
	.dw #0x0759
	.dw #0x0000
	.dw #0x0739
	.dw #0x0000
	.dw #0x0721
	.dw #0x0706
	.dw #0x0000
	.dw #0x0759
	.dw #0x0000
	.dw #0x0000
	.dw #0x0744
	.dw #0x0000
	.dw #0x0744
	.dw #0x0000
	.dw #0x0739
	.dw #0x0721
	.dw #0x076b
	.dw #0x0000
	.dw #0x0744
	.dw #0x0000
	.dw #0x0739
	.dw #0x0721
	.dw #0x0000
	.dw #0x076b
	.dw #0x0000
	.dw #0x0000
	.dw #0x0759
	.dw #0x0000
	.dw #0x0759
	.dw #0x0000
	.dw #0x0744
	.dw #0x0739
	.dw #0x077b
	.dw #0x0000
	.dw #0x0759
	.dw #0x0000
	.dw #0x0744
	.dw #0x0739
	.dw #0x0000
	.dw #0x077b
	.dw #0x0000
	.dw #0x0000
	.dw #0x0783
	.dw #0x0759
	.dw #0x076b
	.dw #0x077b
	.dw #0x0783
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
_trk_mel_2:
	.dw #0x076b
	.dw #0x0000
	.dw #0x0783
	.dw #0x076b
	.dw #0x0744
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x076b
	.dw #0x0000
	.dw #0x0783
	.dw #0x076b
	.dw #0x0744
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x077b
	.dw #0x0000
	.dw #0x0790
	.dw #0x077b
	.dw #0x0759
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x077b
	.dw #0x0000
	.dw #0x0790
	.dw #0x077b
	.dw #0x0759
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0764
	.dw #0x0000
	.dw #0x077b
	.dw #0x0764
	.dw #0x0739
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0764
	.dw #0x0000
	.dw #0x077b
	.dw #0x0764
	.dw #0x0739
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x076b
	.dw #0x0000
	.dw #0x0783
	.dw #0x076b
	.dw #0x0739
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x076b
	.dw #0x0000
	.dw #0x076b
	.dw #0x0000
	.dw #0x076b
	.dw #0x0000
	.dw #0x076b
	.dw #0x0000
_trk_mel_3:
	.dw #0x076b
	.dw #0x0000
	.dw #0x0759
	.dw #0x0744
	.dw #0x0000
	.dw #0x0783
	.dw #0x0000
	.dw #0x0000
	.dw #0x076b
	.dw #0x0000
	.dw #0x0759
	.dw #0x0744
	.dw #0x0000
	.dw #0x0783
	.dw #0x0000
	.dw #0x0000
	.dw #0x077b
	.dw #0x0000
	.dw #0x076b
	.dw #0x0759
	.dw #0x0000
	.dw #0x0790
	.dw #0x0000
	.dw #0x0000
	.dw #0x077b
	.dw #0x0000
	.dw #0x076b
	.dw #0x0759
	.dw #0x0000
	.dw #0x0790
	.dw #0x0000
	.dw #0x0000
	.dw #0x079c
	.dw #0x0000
	.dw #0x0790
	.dw #0x0783
	.dw #0x077b
	.dw #0x076b
	.dw #0x0759
	.dw #0x0744
	.dw #0x0739
	.dw #0x0721
	.dw #0x0706
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
	.dw #0x0721
	.dw #0x0000
	.dw #0x0739
	.dw #0x0000
	.dw #0x0759
	.dw #0x0000
	.dw #0x0783
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
_mel_parts:
	.dw _trk_mel_0
	.dw _trk_mel_1
	.dw _trk_mel_2
	.dw _trk_mel_3
_trk_bass_0:
	.dw #0x060b
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x0672
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x0672
	.dw #0x0000
	.dw #0x0689
	.dw #0x0000
	.dw #0x0689
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
	.dw #0x0689
	.dw #0x0000
	.dw #0x0689
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x0641
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x0641
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x0672
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x0672
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
_trk_bass_1:
	.dw #0x060b
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x0672
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x0672
	.dw #0x0000
	.dw #0x0689
	.dw #0x0000
	.dw #0x0689
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
	.dw #0x0689
	.dw #0x0000
	.dw #0x0689
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x0641
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x0641
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x0672
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
_trk_bass_2:
	.dw #0x0689
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x0689
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x0641
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x0641
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x0672
	.dw #0x0000
	.dw #0x06c6
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x06c6
	.dw #0x0000
	.dw #0x0672
	.dw #0x0000
	.dw #0x06c6
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x06c6
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
	.dw #0x0739
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
_trk_bass_3:
	.dw #0x0689
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x0689
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
	.dw #0x06d6
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x0641
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x0641
	.dw #0x0000
	.dw #0x06f7
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x0672
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x0672
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x0672
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x0672
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x0706
	.dw #0x0000
	.dw #0x06b2
	.dw #0x0000
	.dw #0x060b
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
_bass_parts:
	.dw _trk_bass_0
	.dw _trk_bass_1
	.dw _trk_bass_2
	.dw _trk_bass_3
_wave_ram:
	.db #0x02	; 2
	.db #0x46	; 70	'F'
	.db #0x8a	; 138
	.db #0xce	; 206
	.db #0xff	; 255
	.db #0xfe	; 254
	.db #0xec	; 236
	.db #0xa8	; 168
	.db #0x64	; 100	'd'
	.db #0x20	; 32
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
_trk_drum_0:
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x01	; 1
_trk_drum_1:
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x02	; 2
	.db #0x01	; 1
	.db #0x02	; 2
_trk_drum_2:
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
	.db #0x02	; 2
_trk_drum_3:
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x02	; 2
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x03	; 3
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
_drum_parts:
	.dw _trk_drum_0
	.dw _trk_drum_1
	.dw _trk_drum_2
	.dw _trk_drum_3
_go_mel:
	.dw #0x0706
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x0706
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x0706
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x0721
	.dw #0xffff
	.dw #0x072d
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x0721
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x0706
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x0706
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x0706
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x0706
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x06f7
	.dw #0xffff
	.dw #0x0706
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x06b2
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
_go_bass:
	.dw #0x060b
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x06b2
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x0689
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x06b2
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
	.dw #0xffff
_go_arp:
	.dw #0x060b
	.dw #0xffff
	.dw #0x065a
	.dw #0xffff
	.dw #0x069e
	.dw #0xffff
	.dw #0x06d6
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0x065a
	.dw #0xffff
	.dw #0x069e
	.dw #0xffff
	.dw #0x06d6
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0x065a
	.dw #0xffff
	.dw #0x0689
	.dw #0xffff
	.dw #0x06f7
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0x065a
	.dw #0xffff
	.dw #0x069e
	.dw #0xffff
	.dw #0x06d6
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0x065a
	.dw #0xffff
	.dw #0x069e
	.dw #0xffff
	.dw #0x06d6
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0x065a
	.dw #0xffff
	.dw #0x069e
	.dw #0xffff
	.dw #0x06d6
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0x0641
	.dw #0xffff
	.dw #0x0689
	.dw #0xffff
	.dw #0x06b2
	.dw #0xffff
	.dw #0x060b
	.dw #0xffff
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
	.dw #0x0000
_go_drum:
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x01	; 1
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
	.db #0x00	; 0
_title_mel:
	.dw #0x0706
	.dw #0x0000
	.dw #0x0739
	.dw #0x0000
	.dw #0x0759
	.dw #0x0000
	.dw #0x0783
	.dw #0x0000
	.dw #0x076b
	.dw #0x0000
	.dw #0x0759
	.dw #0x0000
	.dw #0x0739
	.dw #0x0721
	.dw #0x0706
	.dw #0x0000
_title_bass:
	.dw #0x060b
	.dw #0x060b
	.dw #0x0672
	.dw #0x0672
	.dw #0x06b2
	.dw #0x06b2
	.dw #0x0706
	.dw #0x0706
	.dw #0x0689
	.dw #0x0689
	.dw #0x0672
	.dw #0x0672
	.dw #0x060b
	.dw #0x06b2
	.dw #0x060b
	.dw #0x0000
_victory_mel:
	.dw #0x0706
	.dw #0x0739
	.dw #0x0759
	.dw #0x0000
	.dw #0x0783
	.dw #0x0759
	.dw #0x0739
	.dw #0x0000
	.dw #0x0744
	.dw #0x076b
	.dw #0x0783
	.dw #0x0000
	.dw #0x079c
	.dw #0x0783
	.dw #0x0759
	.dw #0x0000
_victory_bass:
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x060b
	.dw #0x0672
	.dw #0x06b2
	.dw #0x0672
	.dw #0x0689
	.dw #0x06d6
	.dw #0x0706
	.dw #0x06d6
	.dw #0x060b
	.dw #0x06b2
	.dw #0x060b
	.dw #0x0000
;src/music.c:292: void play_sfx_moan(void) {
;	---------------------------------
; Function play_sfx_moan
; ---------------------------------
_play_sfx_moan::
;src/music.c:294: NR10_REG = 0x45; 
	ld	a, #0x45
	ldh	(_NR10_REG + 0), a
;src/music.c:295: NR11_REG = 0x80;
	ld	a, #0x80
	ldh	(_NR11_REG + 0), a
;src/music.c:296: NR12_REG = 0xF3; 
	ld	a, #0xf3
	ldh	(_NR12_REG + 0), a
;src/music.c:297: NR13_REG = 0x40;
	ld	a, #0x40
	ldh	(_NR13_REG + 0), a
;src/music.c:298: NR14_REG = 0x86; 
	ld	a, #0x86
	ldh	(_NR14_REG + 0), a
;src/music.c:299: sfx_timer = 40; // Blocca CH1 per 40 frame
	ld	hl, #_sfx_timer
	ld	(hl), #0x28
;src/music.c:300: }
	ret
;src/music.c:302: void play_sfx_plop(void) {
;	---------------------------------
; Function play_sfx_plop
; ---------------------------------
_play_sfx_plop::
;src/music.c:304: NR10_REG = 0x00;
	xor	a, a
	ldh	(_NR10_REG + 0), a
;src/music.c:305: NR11_REG = 0x80;
	ld	a, #0x80
	ldh	(_NR11_REG + 0), a
;src/music.c:306: NR12_REG = 0xF1;
	ld	a, #0xf1
	ldh	(_NR12_REG + 0), a
;src/music.c:307: NR13_REG = 0xFF;
	ld	a, #0xff
	ldh	(_NR13_REG + 0), a
;src/music.c:308: NR14_REG = 0x87;
	ld	a, #0x87
	ldh	(_NR14_REG + 0), a
;src/music.c:309: sfx_timer = 15;
	ld	hl, #_sfx_timer
	ld	(hl), #0x0f
;src/music.c:310: }
	ret
;src/music.c:312: void init_music(void) {
;	---------------------------------
; Function init_music
; ---------------------------------
_init_music::
;src/music.c:314: NR52_REG = 0x00;
	xor	a, a
	ldh	(_NR52_REG + 0), a
;src/music.c:315: NR52_REG = 0x80;
	ld	a, #0x80
	ldh	(_NR52_REG + 0), a
;src/music.c:316: NR50_REG = 0x77;
	ld	a, #0x77
	ldh	(_NR50_REG + 0), a
;src/music.c:317: NR51_REG = 0xFF;
	ld	a, #0xff
	ldh	(_NR51_REG + 0), a
;src/music.c:320: NR30_REG = 0x00; // Disable DAC
	xor	a, a
	ldh	(_NR30_REG + 0), a
;src/music.c:322: for (uint8_t i = 0; i < 16; i++) {
	ld	c, #0x00
00103$:
;src/music.c:323: wave_ptr[i] = wave_ram[i];
	ld	a,c
	cp	a,#0x10
	jr	NC, 00101$
	add	a, #0x30
	ld	e, a
	ld	a, #0x00
	adc	a, #0xff
	ld	d, a
	ld	hl, #_wave_ram
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	(de), a
;src/music.c:322: for (uint8_t i = 0; i < 16; i++) {
	inc	c
	jr	00103$
00101$:
;src/music.c:325: NR30_REG = 0x80; // Enable DAC
	ld	a, #0x80
	ldh	(_NR30_REG + 0), a
;src/music.c:327: tick = 0;
	xor	a, a
	ld	hl, #_tick
	ld	(hl+), a
	ld	(hl), a
;src/music.c:328: frame_counter = 0;
;src/music.c:329: sfx_timer = 0;
	xor	a, a
	ld	(#_frame_counter), a
	ld	(#_sfx_timer),a
;src/music.c:330: game_over_mode = 0;
	xor	a, a
	ld	(#_game_over_mode),a
;src/music.c:331: }
	ret
;src/music.c:333: void update_music(void) {
;	---------------------------------
; Function update_music
; ---------------------------------
_update_music::
	add	sp, #-9
;src/music.c:334: if (game_over_mode == 2) return; // Traccia terminata
	ld	a, (#_game_over_mode)
	sub	a, #0x02
	jp	Z, 00187$
;src/music.c:336: if (sfx_timer > 0) sfx_timer--;
	ld	hl, #_sfx_timer
	ld	a, (hl)
	or	a, a
	jr	Z, 00104$
	dec	(hl)
00104$:
;src/music.c:338: if (frame_counter == 0) {
	ld	a, (#_frame_counter)
	or	a, a
	jp	NZ, 00185$
;src/music.c:341: if (tick >= 16) {
	ld	a, (#_tick)
	ldhl	sp,	#7
	ld	(hl), a
	ld	a, (#_tick + 1)
	ldhl	sp,	#8
	ld	(hl-), a
	ld	a, (hl+)
	sub	a, #0x10
	ld	a, (hl-)
	dec	hl
	sbc	a, #0x00
	ld	a, #0x00
	rla
	ld	(hl), a
;src/music.c:339: if (game_over_mode == 3) {
	ld	a, (#_game_over_mode)
	sub	a, #0x03
	jp	NZ, 00182$
;src/music.c:341: if (tick >= 16) {
	ldhl	sp,	#6
	bit	0, (hl)
	jr	NZ, 00106$
;src/music.c:342: tick = 0; // LOOP
	xor	a, a
	ld	hl, #_tick
	ld	(hl+), a
	ld	(hl), a
00106$:
;src/music.c:345: uint16_t f2 = title_mel[tick];
	ld	a, (_tick)
	ld	c, a
	ld	hl, #_tick + 1
	ld	b, (hl)
	sla	c
	rl	b
	ld	hl, #_title_mel
	add	hl, bc
	ld	a,	(hl+)
	ld	h, (hl)
;src/music.c:346: if (f2 == N_REST) {
	ld	l, a
;src/music.c:347: NR22_REG = 0x00;
	or	a, h
	jr	NZ, 00108$
	ldh	(_NR22_REG + 0), a
	jr	00109$
00108$:
;src/music.c:349: NR21_REG = 0x80; NR22_REG = 0xF2;
	ld	a, #0x80
	ldh	(_NR21_REG + 0), a
	ld	a, #0xf2
	ldh	(_NR22_REG + 0), a
;src/music.c:350: NR23_REG = (uint8_t)(f2 & 0xFF); NR24_REG = 0x80 | ((f2 >> 8) & 0x07);
	push	hl
	ld	a, l
	ldh	(_NR23_REG + 0), a
	pop	hl
	ld	a, h
	and	a, #0x07
	or	a, #0x80
	ldh	(_NR24_REG + 0), a
00109$:
;src/music.c:353: uint16_t f3 = title_bass[tick];
	ld	hl, #_title_bass
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;src/music.c:354: if (f3 == N_REST) {
	ld	a, b
;src/music.c:355: NR32_REG = 0x00;
	or	a, c
	jr	NZ, 00111$
	ldh	(_NR32_REG + 0), a
	jr	00112$
00111$:
;src/music.c:357: NR32_REG = 0x20; 
	ld	a, #0x20
	ldh	(_NR32_REG + 0), a
;src/music.c:358: NR33_REG = (uint8_t)(f3 & 0xFF); NR34_REG = 0x80 | ((f3 >> 8) & 0x07);
	ld	a, c
	ldh	(_NR33_REG + 0), a
	ld	a, b
	and	a, #0x07
	or	a, #0x80
	ldh	(_NR34_REG + 0), a
00112$:
;src/music.c:362: if (tick % 4 == 0) {
	ld	a, (_tick)
	ld	c, a
	ld	hl, #_tick + 1
	ld	b, (hl)
	ld	a, c
;src/music.c:363: NR41_REG = 0x00; NR42_REG = 0xF1; NR43_REG = 0x11; NR44_REG = 0x80;
	and	a,#0x03
	jr	NZ, 00117$
	ldh	(_NR41_REG + 0), a
	ld	a, #0xf1
	ldh	(_NR42_REG + 0), a
	ld	a, #0x11
	ldh	(_NR43_REG + 0), a
	ld	a, #0x80
	ldh	(_NR44_REG + 0), a
	jr	00118$
00117$:
;src/music.c:364: } else if (tick % 2 == 0) {
	bit	0, c
	jr	NZ, 00114$
;src/music.c:365: NR41_REG = 0x00; NR42_REG = 0x51; NR43_REG = 0x21; NR44_REG = 0x80;
	xor	a, a
	ldh	(_NR41_REG + 0), a
	ld	a, #0x51
	ldh	(_NR42_REG + 0), a
	ld	a, #0x21
	ldh	(_NR43_REG + 0), a
	ld	a, #0x80
	ldh	(_NR44_REG + 0), a
	jr	00118$
00114$:
;src/music.c:367: NR42_REG = 0x00;
	xor	a, a
	ldh	(_NR42_REG + 0), a
00118$:
;src/music.c:370: tick++;
	ld	hl, #_tick
	inc	(hl)
	jr	NZ, 00443$
	inc	hl
	inc	(hl)
00443$:
;src/music.c:371: frame_counter = 8; // Veloce e allegro
	ld	hl, #_frame_counter
	ld	(hl), #0x08
	jp	00187$
00182$:
;src/music.c:372: } else if (game_over_mode == 4) {
	ld	a, (#_game_over_mode)
	sub	a, #0x04
	jp	NZ, 00179$
;src/music.c:374: if (tick >= 16) {
	ldhl	sp,	#6
	bit	0, (hl)
	jr	NZ, 00120$
;src/music.c:375: tick = 0; // LOOP
	xor	a, a
	ld	hl, #_tick
	ld	(hl+), a
	ld	(hl), a
00120$:
;src/music.c:378: uint16_t f2 = victory_mel[tick];
	ld	a, (_tick)
	ld	c, a
	ld	hl, #_tick + 1
	ld	b, (hl)
	sla	c
	rl	b
	ld	hl, #_victory_mel
	add	hl, bc
	ld	a,	(hl+)
	ld	h, (hl)
;src/music.c:379: if (f2 == N_REST) {
	ld	l, a
;src/music.c:380: NR22_REG = 0x00;
	or	a, h
	jr	NZ, 00122$
	ldh	(_NR22_REG + 0), a
	jr	00123$
00122$:
;src/music.c:382: NR21_REG = 0x80; NR22_REG = 0xF2;
	ld	a, #0x80
	ldh	(_NR21_REG + 0), a
	ld	a, #0xf2
	ldh	(_NR22_REG + 0), a
;src/music.c:383: NR23_REG = (uint8_t)(f2 & 0xFF); NR24_REG = 0x80 | ((f2 >> 8) & 0x07);
	push	hl
	ld	a, l
	ldh	(_NR23_REG + 0), a
	pop	hl
	ld	a, h
	and	a, #0x07
	or	a, #0x80
	ldh	(_NR24_REG + 0), a
00123$:
;src/music.c:386: uint16_t f3 = victory_bass[tick];
	ld	hl, #_victory_bass
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;src/music.c:387: if (f3 == N_REST) {
	ld	a, b
;src/music.c:388: NR32_REG = 0x00;
	or	a, c
	jr	NZ, 00125$
	ldh	(_NR32_REG + 0), a
	jr	00126$
00125$:
;src/music.c:390: NR32_REG = 0x20; 
	ld	a, #0x20
	ldh	(_NR32_REG + 0), a
;src/music.c:391: NR33_REG = (uint8_t)(f3 & 0xFF); NR34_REG = 0x80 | ((f3 >> 8) & 0x07);
	ld	a, c
	ldh	(_NR33_REG + 0), a
	ld	a, b
	and	a, #0x07
	or	a, #0x80
	ldh	(_NR34_REG + 0), a
00126$:
;src/music.c:394: if (tick % 2 == 0) {
	ld	a, (_tick)
	ld	hl, #_tick + 1
	ld	c, (hl)
	rrca
	jr	C, 00128$
;src/music.c:395: NR41_REG = 0x00; NR42_REG = 0x51; NR43_REG = 0x21; NR44_REG = 0x80;
	xor	a, a
	ldh	(_NR41_REG + 0), a
	ld	a, #0x51
	ldh	(_NR42_REG + 0), a
	ld	a, #0x21
	ldh	(_NR43_REG + 0), a
	ld	a, #0x80
	ldh	(_NR44_REG + 0), a
	jr	00129$
00128$:
;src/music.c:397: NR42_REG = 0x00;
	xor	a, a
	ldh	(_NR42_REG + 0), a
00129$:
;src/music.c:400: tick++;
	ld	hl, #_tick
	inc	(hl)
	jr	NZ, 00449$
	inc	hl
	inc	(hl)
00449$:
;src/music.c:401: frame_counter = 6; // Molto veloce e festoso
	ld	hl, #_frame_counter
	ld	(hl), #0x06
	jp	00187$
00179$:
;src/music.c:370: tick++;
	ld	hl, #_tick
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ld	l, e
	ld	h, d
	inc	hl
	inc	sp
	inc	sp
	push	hl
;src/music.c:402: } else if (game_over_mode == 1) {
	ld	a, (#_game_over_mode)
	dec	a
	jp	NZ, 00176$
;src/music.c:404: if (tick >= 64) {
	ldhl	sp,	#7
	ld	a, (hl+)
	sub	a, #0x40
	ld	a, (hl)
	sbc	a, #0x00
	jr	C, 00131$
;src/music.c:405: game_over_mode = 2; // Fine
	ld	hl, #_game_over_mode
	ld	(hl), #0x02
;src/music.c:406: NR22_REG = 0x00; NR32_REG = 0x00; NR42_REG = 0x00; NR12_REG = 0x00;
	xor	a, a
	ldh	(_NR22_REG + 0), a
	xor	a, a
	ldh	(_NR32_REG + 0), a
	xor	a, a
	ldh	(_NR42_REG + 0), a
	xor	a, a
	ldh	(_NR12_REG + 0), a
;src/music.c:407: return;
	jp	00187$
00131$:
;src/music.c:410: uint16_t f1 = go_arp[tick];
	ld	a, (_tick)
	ld	c, a
	ld	hl, #_tick + 1
	ld	b, (hl)
	sla	c
	rl	b
	ld	hl, #_go_arp
	add	hl, bc
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
;src/music.c:411: if (f1 != N_SUST) {
	ld	e, l
	ld	d, h
	ld	a, e
	and	a, d
	inc	a
	jr	Z, 00136$
;src/music.c:412: if (f1 == N_REST) {
	ld	a, h
;src/music.c:413: NR12_REG = 0x00;
	or	a, l
	jr	NZ, 00133$
	ldh	(_NR12_REG + 0), a
	jr	00136$
00133$:
;src/music.c:415: NR10_REG = 0x00; NR11_REG = 0x80; NR12_REG = 0x61;
	xor	a, a
	ldh	(_NR10_REG + 0), a
	ld	a, #0x80
	ldh	(_NR11_REG + 0), a
	ld	a, #0x61
	ldh	(_NR12_REG + 0), a
;src/music.c:416: NR13_REG = (uint8_t)(f1 & 0xFF); NR14_REG = 0x80 | ((f1 >> 8) & 0x07);
	push	hl
	ld	a, l
	ldh	(_NR13_REG + 0), a
	pop	hl
	ld	a, h
	and	a, #0x07
	or	a, #0x80
	ldh	(_NR14_REG + 0), a
00136$:
;src/music.c:420: uint16_t f2 = go_mel[tick];
	ld	hl, #_go_mel
	add	hl, bc
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
;src/music.c:421: if (f2 != N_SUST) {
	ld	e, l
	ld	d, h
	ld	a, e
	and	a, d
	inc	a
	jr	Z, 00141$
;src/music.c:422: if (f2 == N_REST) {
	ld	a, h
;src/music.c:423: NR22_REG = 0x00;
	or	a, l
	jr	NZ, 00138$
	ldh	(_NR22_REG + 0), a
	jr	00141$
00138$:
;src/music.c:425: NR21_REG = 0x80; NR22_REG = 0xF7; // Lento decadimento
	ld	a, #0x80
	ldh	(_NR21_REG + 0), a
	ld	a, #0xf7
	ldh	(_NR22_REG + 0), a
;src/music.c:426: NR23_REG = (uint8_t)(f2 & 0xFF); NR24_REG = 0x80 | ((f2 >> 8) & 0x07);
	push	hl
	ld	a, l
	ldh	(_NR23_REG + 0), a
	pop	hl
	ld	a, h
	and	a, #0x07
	or	a, #0x80
	ldh	(_NR24_REG + 0), a
00141$:
;src/music.c:430: uint16_t f3 = go_bass[tick];
	ld	hl, #_go_bass
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;src/music.c:431: if (f3 != N_SUST) {
	ld	e, c
	ld	d, b
	ld	a, e
	and	a, d
	inc	a
	jr	Z, 00146$
;src/music.c:432: if (f3 == N_REST) {
	ld	a, b
;src/music.c:433: NR32_REG = 0x00;
	or	a, c
	jr	NZ, 00143$
	ldh	(_NR32_REG + 0), a
	jr	00146$
00143$:
;src/music.c:435: NR32_REG = 0x20; 
	ld	a, #0x20
	ldh	(_NR32_REG + 0), a
;src/music.c:436: NR33_REG = (uint8_t)(f3 & 0xFF); NR34_REG = 0x80 | ((f3 >> 8) & 0x07);
	ld	a, c
	ldh	(_NR33_REG + 0), a
	ld	a, b
	and	a, #0x07
	or	a, #0x80
	ldh	(_NR34_REG + 0), a
00146$:
;src/music.c:440: uint8_t d4 = go_drum[tick];
	ld	a, #<(_go_drum)
	ld	hl, #_tick
	add	a, (hl)
	inc	hl
	ld	c, a
	ld	a, #>(_go_drum)
	adc	a, (hl)
	ld	b, a
	ld	a, (bc)
;src/music.c:441: if (d4 == 1) {
;src/music.c:442: NR41_REG = 0x00; NR42_REG = 0xF4; // Rullante profondo
	dec	a
	jr	NZ, 00148$
	ldh	(_NR41_REG + 0), a
	ld	a, #0xf4
	ldh	(_NR42_REG + 0), a
;src/music.c:443: NR43_REG = 0x33; NR44_REG = 0x80;
	ld	a, #0x33
	ldh	(_NR43_REG + 0), a
	ld	a, #0x80
	ldh	(_NR44_REG + 0), a
00148$:
;src/music.c:446: tick++;
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(#_tick),a
	ldhl	sp,	#1
	ld	a, (hl)
	ld	(#_tick + 1),a
;src/music.c:447: frame_counter = 20; // Lento e funereo
	ld	hl, #_frame_counter
	ld	(hl), #0x14
	jp	00187$
00176$:
;src/music.c:451: uint8_t part = (tick >> 6) & 0x03; // tick / 64
	ld	hl, #_tick
	ld	a, (hl+)
	ld	c, a
;src/music.c:452: uint8_t sub = tick & 0x3F;         // tick % 64
	ld	a, (hl-)
	ld	b, a
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	srl	b
	rr	c
	ld	a, c
	and	a, #0x03
	ld	e, a
	ld	a, (hl)
	and	a, #0x3f
	ldhl	sp,	#2
	ld	(hl), a
;src/music.c:456: uint16_t f1 = arp_parts[part][sub];
	ld	d, #0x00
	ld	a, (hl+)
	ld	c, a
	ld	b, #0x00
	sla	e
	rl	d
	ld	a, e
	ld	(hl+), a
	ld	a, d
	ld	(hl+), a
	sla	c
	rl	b
	ld	a, c
	ld	(hl+), a
	ld	(hl), b
;src/music.c:455: if (sfx_timer == 0 && music_enabled) {
	ld	a, (#_sfx_timer)
	or	a, a
	jr	NZ, 00150$
	ld	a, (#_music_enabled)
	or	a, a
	jr	Z, 00150$
;src/music.c:456: uint16_t f1 = arp_parts[part][sub];
	ld	de, #_arp_parts
	ldhl	sp,	#3
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
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
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, de
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;src/music.c:457: NR10_REG = 0x00; 
	xor	a, a
	ldh	(_NR10_REG + 0), a
;src/music.c:458: NR11_REG = 0x80; 
	ld	a, #0x80
	ldh	(_NR11_REG + 0), a
;src/music.c:459: NR12_REG = 0x51; // Volume basso, decadimento rapido
	ld	a, #0x51
	ldh	(_NR12_REG + 0), a
;src/music.c:460: NR13_REG = (uint8_t)(f1 & 0xFF);
	ld	a, c
	ldh	(_NR13_REG + 0), a
;src/music.c:461: NR14_REG = 0x80 | ((f1 >> 8) & 0x07);
	ld	a, b
	and	a, #0x07
	or	a, #0x80
	ldh	(_NR14_REG + 0), a
00150$:
;src/music.c:465: if (music_enabled) {
	ld	a, (#_music_enabled)
	or	a, a
	jr	Z, 00156$
;src/music.c:466: uint16_t f2 = mel_parts[part][sub];
	ld	bc, #_mel_parts+0
	ldhl	sp,	#3
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;src/music.c:467: if (f2 == N_REST) {
	ld	a, b
;src/music.c:468: NR21_REG = 0x00; NR22_REG = 0x00; NR23_REG = 0x00; NR24_REG = 0x80;
	or	a, c
	jr	NZ, 00153$
	ldh	(_NR21_REG + 0), a
	xor	a, a
	ldh	(_NR22_REG + 0), a
	xor	a, a
	ldh	(_NR23_REG + 0), a
	ld	a, #0x80
	ldh	(_NR24_REG + 0), a
	jr	00156$
00153$:
;src/music.c:470: NR21_REG = 0x80; 
	ld	a, #0x80
	ldh	(_NR21_REG + 0), a
;src/music.c:471: NR22_REG = 0xF2; // Volume alto
	ld	a, #0xf2
	ldh	(_NR22_REG + 0), a
;src/music.c:472: NR23_REG = (uint8_t)(f2 & 0xFF);
	ld	a, c
	ldh	(_NR23_REG + 0), a
;src/music.c:473: NR24_REG = 0x80 | ((f2 >> 8) & 0x07);
	ld	a, b
	and	a, #0x07
	or	a, #0x80
	ldh	(_NR24_REG + 0), a
00156$:
;src/music.c:478: if (music_enabled) {
	ld	a, (#_music_enabled)
	or	a, a
	jr	Z, 00161$
;src/music.c:479: uint16_t f3 = bass_parts[part][sub];
	ld	bc, #_bass_parts+0
	ldhl	sp,	#3
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
	ldhl	sp,	#5
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
	add	hl, bc
	ld	a, (hl+)
	ld	c, a
	ld	b, (hl)
;src/music.c:480: if (f3 == N_REST) {
	ld	a, b
;src/music.c:481: NR32_REG = 0x00; // Vol 0
	or	a, c
	jr	NZ, 00158$
	ldh	(_NR32_REG + 0), a
;src/music.c:482: NR34_REG = 0x80;
	ld	a, #0x80
	ldh	(_NR34_REG + 0), a
	jr	00161$
00158$:
;src/music.c:484: NR32_REG = 0x20; // Vol 100%
	ld	a, #0x20
	ldh	(_NR32_REG + 0), a
;src/music.c:485: NR33_REG = (uint8_t)(f3 & 0xFF);
	ld	a, c
	ldh	(_NR33_REG + 0), a
;src/music.c:486: NR34_REG = 0x80 | ((f3 >> 8) & 0x07);
	ld	a, b
	and	a, #0x07
	or	a, #0x80
	ldh	(_NR34_REG + 0), a
00161$:
;src/music.c:491: if (sfx_timer == 0 && music_enabled) {
	ld	a, (#_sfx_timer)
	or	a, a
	jr	NZ, 00171$
	ld	a, (#_music_enabled)
	or	a, a
	jr	Z, 00171$
;src/music.c:492: uint8_t d4 = drum_parts[part][sub];
	ld	de, #_drum_parts
	ldhl	sp,	#3
	ld	a,	(hl+)
	ld	h, (hl)
	ld	l, a
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
	ld	a, (hl-)
	ld	d, a
	ld	a, (de)
	ld	(hl+), a
	inc	de
	ld	a, (de)
	ld	(hl-), a
	ld	a, (hl+)
	ld	e, a
	ld	d, (hl)
	ldhl	sp,	#2
	ld	l, (hl)
	ld	h, #0x00
	add	hl, de
	ld	c, l
	ld	b, h
	ld	a, (bc)
;src/music.c:493: if (d4 == 1) { // Kick
	cp	a, #0x01
	jr	NZ, 00168$
;src/music.c:494: NR41_REG = 0x00;
	xor	a, a
	ldh	(_NR41_REG + 0), a
;src/music.c:495: NR42_REG = 0xF1;
	ld	a, #0xf1
	ldh	(_NR42_REG + 0), a
;src/music.c:496: NR43_REG = 0x11;
	ld	a, #0x11
	ldh	(_NR43_REG + 0), a
;src/music.c:497: NR44_REG = 0x80;
	ld	a, #0x80
	ldh	(_NR44_REG + 0), a
	jr	00171$
00168$:
;src/music.c:498: } else if (d4 == 2) { // Snare
	cp	a, #0x02
	jr	NZ, 00165$
;src/music.c:499: NR41_REG = 0x00;
	xor	a, a
	ldh	(_NR41_REG + 0), a
;src/music.c:500: NR42_REG = 0xF2;
	ld	a, #0xf2
	ldh	(_NR42_REG + 0), a
;src/music.c:501: NR43_REG = 0x51;
	ld	a, #0x51
	ldh	(_NR43_REG + 0), a
;src/music.c:502: NR44_REG = 0x80;
	ld	a, #0x80
	ldh	(_NR44_REG + 0), a
	jr	00171$
00165$:
;src/music.c:503: } else if (d4 == 3) { // Hi-Hat
	sub	a, #0x03
	jr	NZ, 00171$
;src/music.c:504: NR41_REG = 0x00;
	xor	a, a
	ldh	(_NR41_REG + 0), a
;src/music.c:505: NR42_REG = 0x51;
	ld	a, #0x51
	ldh	(_NR42_REG + 0), a
;src/music.c:506: NR43_REG = 0x21;
	ld	a, #0x21
	ldh	(_NR43_REG + 0), a
;src/music.c:507: NR44_REG = 0x80;
	ld	a, #0x80
	ldh	(_NR44_REG + 0), a
00171$:
;src/music.c:512: tick++;
	ldhl	sp,	#0
	ld	a, (hl)
	ld	(#_tick),a
	ldhl	sp,	#1
	ld	a, (hl)
	ld	hl, #_tick + 1
;src/music.c:513: if (tick >= 256) tick = 0; // Loop completo
	ld	(hl-), a
	ld	a, (hl+)
	ld	a, (hl)
	sub	a, #0x01
	jr	C, 00174$
	dec	hl
	xor	a, a
	ld	(hl+), a
	ld	(hl), a
00174$:
;src/music.c:515: frame_counter = FRAMES_PER_TICK;
	ld	hl, #_frame_counter
	ld	(hl), #0x08
	jr	00187$
00185$:
;src/music.c:518: frame_counter--;
	ld	hl, #_frame_counter
	dec	(hl)
00187$:
;src/music.c:520: }
	add	sp, #9
	ret
;src/music.c:522: void play_game_over_music(void) {
;	---------------------------------
; Function play_game_over_music
; ---------------------------------
_play_game_over_music::
;src/music.c:524: game_over_mode = 1;
	ld	hl, #_game_over_mode
	ld	(hl), #0x01
;src/music.c:525: tick = 0;
	xor	a, a
	ld	hl, #_tick
	ld	(hl+), a
	ld	(hl), a
;src/music.c:526: frame_counter = 0;
;src/music.c:528: NR22_REG = 0x00; NR32_REG = 0x00; NR42_REG = 0x00; // Zittisce tutto
	xor	a, a
	ld	(#_frame_counter), a
	ldh	(_NR22_REG + 0), a
	xor	a, a
	ldh	(_NR32_REG + 0), a
	xor	a, a
	ldh	(_NR42_REG + 0), a
;src/music.c:529: }
	ret
;src/music.c:531: void play_sfx_explosion(void) {
;	---------------------------------
; Function play_sfx_explosion
; ---------------------------------
_play_sfx_explosion::
;src/music.c:533: NR42_REG = 0xF7; 
	ld	a, #0xf7
	ldh	(_NR42_REG + 0), a
;src/music.c:534: NR43_REG = 0x6E; 
	ld	a, #0x6e
	ldh	(_NR43_REG + 0), a
;src/music.c:535: NR44_REG = 0xC0;
	ld	a, #0xc0
	ldh	(_NR44_REG + 0), a
;src/music.c:536: sfx_timer = 30; // Proteggi CH4 e CH1
	ld	hl, #_sfx_timer
	ld	(hl), #0x1e
;src/music.c:537: }
	ret
;src/music.c:539: void play_sfx_bomb_drop(void) {
;	---------------------------------
; Function play_sfx_bomb_drop
; ---------------------------------
_play_sfx_bomb_drop::
;src/music.c:541: NR41_REG = 0x01; // Corto
	ld	a, #0x01
	ldh	(_NR41_REG + 0), a
;src/music.c:542: NR42_REG = 0xA2; // Volume alto, decadimento rapido
	ld	a, #0xa2
	ldh	(_NR42_REG + 0), a
;src/music.c:543: NR43_REG = 0x22; // Frequenza alta, noise
	ld	a, #0x22
	ldh	(_NR43_REG + 0), a
;src/music.c:544: NR44_REG = 0xC0; // Trigger
	ld	a, #0xc0
	ldh	(_NR44_REG + 0), a
;src/music.c:545: sfx_timer = 15; // Proteggi per la durata del suono
	ld	hl, #_sfx_timer
	ld	(hl), #0x0f
;src/music.c:546: }
	ret
;src/music.c:548: void play_title_music(void) {
;	---------------------------------
; Function play_title_music
; ---------------------------------
_play_title_music::
;src/music.c:550: NR52_REG = 0x00;
	xor	a, a
	ldh	(_NR52_REG + 0), a
;src/music.c:551: NR52_REG = 0x80;
	ld	a, #0x80
	ldh	(_NR52_REG + 0), a
;src/music.c:552: NR50_REG = 0x77;
	ld	a, #0x77
	ldh	(_NR50_REG + 0), a
;src/music.c:553: NR51_REG = 0xFF;
	ld	a, #0xff
	ldh	(_NR51_REG + 0), a
;src/music.c:556: NR30_REG = 0x00;
	xor	a, a
	ldh	(_NR30_REG + 0), a
;src/music.c:558: for (uint8_t i = 0; i < 16; i++) {
	ld	c, #0x00
00103$:
;src/music.c:559: wave_ptr[i] = wave_ram[i];
	ld	a,c
	cp	a,#0x10
	jr	NC, 00101$
	add	a, #0x30
	ld	e, a
	ld	a, #0x00
	adc	a, #0xff
	ld	d, a
	ld	hl, #_wave_ram
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	(de), a
;src/music.c:558: for (uint8_t i = 0; i < 16; i++) {
	inc	c
	jr	00103$
00101$:
;src/music.c:561: NR30_REG = 0x80;
	ld	a, #0x80
	ldh	(_NR30_REG + 0), a
;src/music.c:563: game_over_mode = 3;
	ld	hl, #_game_over_mode
	ld	(hl), #0x03
;src/music.c:564: tick = 0;
	xor	a, a
	ld	hl, #_tick
	ld	(hl+), a
	ld	(hl), a
;src/music.c:565: frame_counter = 0;
;src/music.c:567: NR12_REG = 0; NR22_REG = 0; NR32_REG = 0; NR42_REG = 0;
	xor	a, a
	ld	(#_frame_counter), a
	ldh	(_NR12_REG + 0), a
	xor	a, a
	ldh	(_NR22_REG + 0), a
	xor	a, a
	ldh	(_NR32_REG + 0), a
	xor	a, a
	ldh	(_NR42_REG + 0), a
;src/music.c:568: }
	ret
;src/music.c:570: void play_victory_music(void) {
;	---------------------------------
; Function play_victory_music
; ---------------------------------
_play_victory_music::
;src/music.c:572: NR52_REG = 0x00;
	xor	a, a
	ldh	(_NR52_REG + 0), a
;src/music.c:573: NR52_REG = 0x80;
	ld	a, #0x80
	ldh	(_NR52_REG + 0), a
;src/music.c:574: NR50_REG = 0x77;
	ld	a, #0x77
	ldh	(_NR50_REG + 0), a
;src/music.c:575: NR51_REG = 0xFF;
	ld	a, #0xff
	ldh	(_NR51_REG + 0), a
;src/music.c:577: NR30_REG = 0x00;
	xor	a, a
	ldh	(_NR30_REG + 0), a
;src/music.c:579: for (uint8_t i = 0; i < 16; i++) {
	ld	c, #0x00
00103$:
;src/music.c:580: wave_ptr[i] = wave_ram[i];
	ld	a,c
	cp	a,#0x10
	jr	NC, 00101$
	add	a, #0x30
	ld	e, a
	ld	a, #0x00
	adc	a, #0xff
	ld	d, a
	ld	hl, #_wave_ram
	ld	b, #0x00
	add	hl, bc
	ld	a, (hl)
	ld	(de), a
;src/music.c:579: for (uint8_t i = 0; i < 16; i++) {
	inc	c
	jr	00103$
00101$:
;src/music.c:582: NR30_REG = 0x80;
	ld	a, #0x80
	ldh	(_NR30_REG + 0), a
;src/music.c:584: game_over_mode = 4; // Victory mode
	ld	hl, #_game_over_mode
	ld	(hl), #0x04
;src/music.c:585: tick = 0;
	xor	a, a
	ld	hl, #_tick
	ld	(hl+), a
	ld	(hl), a
;src/music.c:586: frame_counter = 0;
;src/music.c:588: NR12_REG = 0; NR22_REG = 0; NR32_REG = 0; NR42_REG = 0;
	xor	a, a
	ld	(#_frame_counter), a
	ldh	(_NR12_REG + 0), a
	xor	a, a
	ldh	(_NR22_REG + 0), a
	xor	a, a
	ldh	(_NR32_REG + 0), a
	xor	a, a
	ldh	(_NR42_REG + 0), a
;src/music.c:589: }
	ret
	.area _CODE
	.area _INITIALIZER
__xinit__tick:
	.dw #0x0000
__xinit__frame_counter:
	.db #0x00	; 0
__xinit__sfx_timer:
	.db #0x00	; 0
__xinit__game_over_mode:
	.db #0x00	; 0
__xinit__music_enabled:
	.db #0x01	; 1
	.area _CABS (ABS)
