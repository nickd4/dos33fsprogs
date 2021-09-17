; Peasant's Quest Intro Sequence

; by Vince `deater` Weaver	vince@deater.net

; with apologies to everyone

.include "hardware.inc"
.include "zp.inc"

.include "qload.inc"



peasant_quest_intro:

	lda	#0
	sta	ESC_PRESSED

	jsr	hgr_make_tables

	jsr	HGR2		; Hi-res graphics, no text at bottom
				; Y=0, A=0 after this called


	;*******************************
	; restart music, only drum loop
	;******************************

	; hack! modify the PT3 file to ignore the latter half

	lda	#$ff			; end after 4 patterns
	sta	PT3_LOC+$C9+$4

	lda	#$0			; set LOOP to 0
	sta	PT3_LOC+$66

	jsr	pt3_init_song

	cli

	;************************
	; Cottage
	;************************

	jsr	cottage

	lda	ESC_PRESSED
	bne	escape_handler

	;************************
	; Lake West
	;************************

	jsr	lake_west

	lda	ESC_PRESSED
	bne	escape_handler

	;************************
	; Lake East
	;************************

	jsr	lake_east

	lda	ESC_PRESSED
	bne	escape_handler

	;************************
	; River
	;************************

	jsr	river

	lda	ESC_PRESSED
	bne	escape_handler

	;************************
	; Knight
	;************************

	jsr knight

	;************************
	; Start actual game
	;************************

	jsr	draw_peasant

	; wait a bit

	lda	#10
	jsr	wait_a_bit

escape_handler:

	sei				; turn off music
	jsr	clear_ay_both		; clear AY state

	jsr	mockingboard_disable_interrupt

	;=============================
	; start new game
	;=============================

	lda	#LOAD_PEASANT2
	sta	WHICH_LOAD

	;=========================
	; init peasant position
	; draw at 18,108

	lda	#18
	sta	PEASANT_X
	lda	#108
	sta	PEASANT_Y

	lda	#PEASANT_DIR_RIGHT
	sta	PEASANT_DIR

	lda	#0
	sta	PEASANT_XADD
	sta	PEASANT_YADD

	lda	#1
	sta	SCORE_HUNDREDS

	lda	#$33
	sta	SCORE_TENSONES

	lda	#4
	sta	MAP_X
	lda	#1
	sta	MAP_Y

	lda	#$FF
	sta	INVENTORY_1
	sta	INVENTORY_2
	lda	#INV3_SHIRT
	sta	INVENTORY_3

	; 1100 1011
	lda	#$CB
	sta	INVENTORY_1_GONE
	; 0001 1101
	lda	#$1d
	sta	INVENTORY_2_GONE
	;
	lda	#$0
	sta	INVENTORY_3_GONE



	rts


.include "decompress_fast_v2.s"
.include "wait_keypress.s"

.include "intro_cottage.s"
.include "intro_lake_w.s"
.include "intro_lake_e.s"
.include "intro_river.s"
.include "intro_knight.s"

.include "draw_peasant.s"

.include "hgr_font.s"
.include "draw_box.s"
.include "hgr_rectangle.s"
.include "hgr_7x28_sprite.s"
.include "hgr_1x5_sprite.s"
;.include "hgr_save_restore.s"
.include "hgr_partial_save.s"
.include "hgr_input.s"
.include "hgr_tables.s"
.include "hgr_text_box.s"

.include "wait_a_bit.s"

.include "graphics/graphics_intro.inc"

