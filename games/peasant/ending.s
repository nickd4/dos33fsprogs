; Peasant's Quest Ending

; The credits scenes

; by Vince `deater` Weaver	vince@deater.net

.include "hardware.inc"
.include "zp.inc"

.include "qload.inc"

ending:
;	lda	#0
;	sta	GAME_OVER

	jsr	hgr_make_tables

	jsr	HGR2		; Hi-res graphics, no text at bottom
				; Y=0, A=0 after this called


	lda	#0
	sta	FRAME

	; update score

	jsr	update_score


	;=====================
	; re-start music
	;=====================
	; need to un-do any patching
	; reset to beginning of song
	; and start interrupts

	; FIXME: only if mockingboard enabled

	cli


	;=====================
	;=====================
	; boat scene
	;=====================
	;=====================
boat:

	lda	#<lake_e_boat_lzsa
	sta	getsrc_smc+1
	lda	#>lake_e_boat_lzsa
	sta	getsrc_smc+2

	lda	#$40

	jsr	decompress_lzsa2_fast

	jsr	update_top

	; draw rectangle

	lda     #$80            ; color is black2
	sta     VGI_RCOLOR

	lda     #12
	sta     VGI_RX1
	lda     #38
	sta     VGI_RY1
	lda	#202
	sta	VGI_RXRUN
	lda	#20
        sta     VGI_RYRUN
        jsr     vgi_simple_rectangle

	lda     #214
	sta     VGI_RX1
	lda     #38
	sta     VGI_RY1
	lda	#45
	sta	VGI_RXRUN
	lda	#20
        sta     VGI_RYRUN
        jsr     vgi_simple_rectangle


	lda	#<boat_string
	sta	OUTL
	lda	#>boat_string
	sta	OUTH

	jsr	disp_put_string


	;======================
	; animate catching fish


	jsr	wait_until_keypress


	;=======================
	;=======================
	; waterfall
	;=======================
	;=======================

waterfall:

	lda	#<waterfall_lzsa
	sta	getsrc_smc+1
	lda	#>waterfall_lzsa
	sta	getsrc_smc+2

	lda	#$40

	jsr	decompress_lzsa2_fast

	jsr	update_top

	; draw rectangle

	lda     #$80            ; color is black2
	sta     VGI_RCOLOR

	lda     #44
	sta     VGI_RX1
	lda     #48
	sta     VGI_RY1
	lda	#192
	sta	VGI_RXRUN
	lda	#20
        sta     VGI_RYRUN
        jsr     vgi_simple_rectangle

	lda	#<waterfall_string
	sta	OUTL
	lda	#>waterfall_string
	sta	OUTH

	jsr	disp_put_string

	;=========================
	; animate baby

	lda	#10
	sta	CURSOR_X
	lda	#120
	sta	CURSOR_Y

	ldx	#0
	stx	BABY_COUNT
baby_loop:

	; baby 0

	jsr	save_bg_14x14

	ldx	BABY_COUNT
	lda	baby_pointers_l,X
	sta	INL
	lda	baby_pointers_h,X
	sta	INH

	jsr	hgr_draw_sprite_14x14

	jsr	wait_until_keypress

	jsr	restore_bg_14x14

	jsr	wait_until_keypress

	inc	BABY_COUNT
	lda	BABY_COUNT
	cmp	#11
	bne	baby_loop

	;
	;===========================

	jsr	wait_until_keypress


	;=========================
	;=========================
	; jhonka
	;=========================
	;=========================

jhonka:

	lda	#<jhonka_lzsa
	sta	getsrc_smc+1
	lda	#>jhonka_lzsa
	sta	getsrc_smc+2

	lda	#$40

	jsr	decompress_lzsa2_fast

	jsr	update_top

	; draw rectangle

	lda     #$80            ; color is black2
	sta     VGI_RCOLOR

	lda     #44
	sta     VGI_RX1
	lda     #58
	sta     VGI_RY1
	lda	#180
	sta	VGI_RXRUN
	lda	#12
        sta     VGI_RYRUN
        jsr     vgi_simple_rectangle

;	lda     #214
;	sta     VGI_RX1
;	lda     #58
;	sta     VGI_RY1
;	lda	#8
;	sta	VGI_RXRUN
;	lda	#20
 ;       sta     VGI_RYRUN
  ;      jsr     vgi_simple_rectangle


	lda	#<jhonka_string
	sta	OUTL
	lda	#>jhonka_string
	sta	OUTH

	jsr	disp_put_string

	;=================
	; animate jhonka

	jsr	wait_until_keypress

	;========================
	;========================
	; cottage
	;========================
	;========================

cottage:

	lda	#<cottage_lzsa
	sta	getsrc_smc+1
	lda	#>cottage_lzsa
	sta	getsrc_smc+2

	lda	#$40

	jsr	decompress_lzsa2_fast

	jsr	update_top


	; draw rectangle

	lda     #$80            ; color is black2
	sta     VGI_RCOLOR

	lda     #40
	sta     VGI_RX1
	lda     #48
	sta     VGI_RY1
	lda	#192
	sta	VGI_RXRUN
	lda	#32
        sta     VGI_RYRUN
        jsr     vgi_simple_rectangle


	lda	#<cottage_string
	sta	OUTL
	lda	#>cottage_string
	sta	OUTH

	jsr	disp_put_string

	lda	#42
	jsr	wait_a_bit

	;====================
	; second message

	lda     #11
	sta     VGI_RX1
	lda     #48
	sta     VGI_RY1
	lda	#192
	sta	VGI_RXRUN
	lda	#32
        sta     VGI_RYRUN
        jsr     vgi_simple_rectangle

	lda     #203
	sta     VGI_RX1
	lda     #48
	sta     VGI_RY1
	lda	#60
	sta	VGI_RXRUN
	lda	#32
        sta     VGI_RYRUN
        jsr     vgi_simple_rectangle


	lda	#<cottage_string2
	sta	OUTL
	lda	#>cottage_string2
	sta	OUTH

	jsr	disp_put_string

	lda	#42
	jsr	wait_a_bit


	;========================
	;========================
	; final screen
	;========================
	;========================
final_screen:

	lda	#<the_end_lzsa
	sta	getsrc_smc+1
	lda	#>the_end_lzsa
	sta	getsrc_smc+2

	lda	#$40

	jsr	decompress_lzsa2_fast

	jsr	update_top

	jsr	wait_until_keypress

game_over:

	jmp	boat


peasant_text:
	.byte 25,2,"Peasant's Quest",0


.include "decompress_fast_v2.s"
.include "wait_keypress.s"

.include "hgr_font.s"
.include "draw_box.s"
.include "hgr_rectangle.s"

.include "hgr_1x5_sprite.s"
.include "hgr_partial_save.s"
.include "hgr_input.s"
.include "hgr_tables.s"
.include "hgr_text_box.s"

;.include "draw_peasant.s"
;.include "hgr_save_restore.s"
;.include "clear_bottom.s"
;.include "gr_offsets.s"
;.include "gr_copy.s"
;.include "version.inc"

.include "hgr_14x14_sprite_mask.s"

.include "score.s"

.include "wait_a_bit.s"

.include "graphics_end/ending_graphics.inc"

.include "sprites/ending_sprites.inc"

boat_string:
	.byte 2,40
	.byte "         Peasant's Quest",13
	.byte "Written by Matt, Jonathan, and Mike",0

waterfall_string:
	.byte 7,50
	.byte "  Programmed by Jonathan",13
	.byte "Apple ][ support by Deater",0

jhonka_string:
	.byte 7,60
	.byte "Graphics by Mike and Matt",0

cottage_string:
	.byte 6,50
	.byte " Quality Assurance Types:",13
	.byte "      Neal Stamper,",13
	.byte "Don Chapman, and John Radle",0

cottage_string2:
	.byte 2,58
	.byte "Nice work on winning and everything.",0


baby_pointers_l:
	.byte	<baby0_sprite
	.byte	<baby1_sprite
	.byte	<baby2_sprite
	.byte	<baby3_sprite
	.byte	<baby4_sprite
	.byte	<baby5_sprite
	.byte	<baby6_sprite
	.byte	<baby7_sprite
	.byte	<baby8_sprite
	.byte	<baby9_sprite
	.byte	<baby10_sprite

baby_pointers_h:
	.byte	>baby0_sprite
	.byte	>baby1_sprite
	.byte	>baby2_sprite
	.byte	>baby3_sprite
	.byte	>baby4_sprite
	.byte	>baby5_sprite
	.byte	>baby6_sprite
	.byte	>baby7_sprite
	.byte	>baby8_sprite
	.byte	>baby9_sprite
	.byte	>baby10_sprite


update_top:
	; put peasant text

	lda	#<peasant_text
	sta	OUTL
	lda	#>peasant_text
	sta	OUTH

	jsr	hgr_put_string

	; put score

	jsr	print_score

	rts
