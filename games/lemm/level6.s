.include "zp.inc"
.include "hardware.inc"
.include "qload.inc"
.include "lemm.inc"
.include "lemming_status.inc"

.byte 6		; level 6

do_level6:


	;======================
	; set up initial stuff
	;======================
	lda	#3
	sta	DOOR_X
	lda	#20
	sta	DOOR_Y

	lda	#6
	sta	INIT_X
	lda	#30
	sta	INIT_Y

	; flame locations

	lda	#35			;
	sta	l_flame_x_smc+1
	lda	#69
	sta	l_flame_y_smc+1
        sta	r_flame_y_smc+1

	lda	#37			;
	sta	r_flame_x_smc+1

	; door exit location

	lda	#33			;
	sta	exit_x1_smc+1
	lda	#36
	sta	exit_x2_smc+1

	lda	#64
	sta	exit_y1_smc+1
	lda	#100
	sta	exit_y2_smc+1


	;==============
	; set up intro
	;==============

	lda	#<level6_preview_lzsa
	sta	level_preview_l_smc+1
	lda	#>level6_preview_lzsa
	sta	level_preview_h_smc+1

	lda	#<level6_intro_text
	sta	intro_text_smc_l+1
	lda	#>level6_intro_text
	sta	intro_text_smc_h+1

	lda	#$20			; BCD
	sta	PERCENT_NEEDED
	lda	#$10
	sta	PERCENT_ADD


	;==============
	; set up music
	;==============

	lda	#0
	sta	CURRENT_CHUNK
	sta	DONE_PLAYING
	sta	BASE_FRAME_L
	sta	BUTTON_LOCATION

	; set up first song

	lda	#<music12_parts_l
	sta	chunk_l_smc+1
	lda	#>music12_parts_l
	sta	chunk_l_smc+2

	lda	#<music12_parts_h
	sta	chunk_h_smc+1
	lda	#>music12_parts_h
	sta	chunk_h_smc+2


	lda	#$D0
	sta	CHUNK_NEXT_LOAD		; Load at $D0
	jsr	load_song_chunk

	lda	#$D0			; music starts at $d000
	sta	CHUNK_NEXT_PLAY
	sta	BASE_FRAME_H

	lda	#1
	sta	LOOP
	sta	CURRENT_CHUNK



        ;=======================
        ; show title screen
        ;=======================

	jsr	intro_level

        ;=======================
        ; Load Graphics
        ;=======================

	lda	#$20
	sta	HGR_PAGE
	jsr	hgr_make_tables

	bit	SET_GR
	bit	PAGE0
	bit	HIRES
	bit	FULLGR

	lda     #<level6_lzsa
	sta     getsrc_smc+1	; LZSA_SRC_LO
	lda     #>level6_lzsa
	sta     getsrc_smc+2	; LZSA_SRC_HI

	lda	#$20

	jsr	decompress_lzsa2_fast

	lda     #<level6_lzsa
	sta     getsrc_smc+1	; LZSA_SRC_LO
	lda     #>level6_lzsa
	sta     getsrc_smc+2	; LZSA_SRC_HI

	lda	#$40

	jsr	decompress_lzsa2_fast


        ;=======================
        ; Setup cursor
        ;=======================

	lda	#$FF
	sta	OVER_LEMMING
	lda	#10
	sta	CURSOR_X
	lda	#100
	sta	CURSOR_Y


	;=======================
	; init vars
	;=======================

	lda	#10
	sta	LEMMINGS_TO_RELEASE

	; set up time

	lda	#$5
	sta	TIME_MINUTES
	lda	#$00
	sta	TIME_SECONDS
	sta	TIMER_COUNT		; 1/50

	jsr	init_level

	;=======================
	; Play "Let's Go"
	;=======================

	jsr	play_letsgo


	;===================
	;===================
	; Main Loop
	;===================
	;===================
l6_main_loop:

	;=========================
	; load next chunk of music
	; if necessary
	;=========================

	jsr	load_music



l6_no_load_chunk:


	lda	DOOR_OPEN
	bne	l6_door_is_open

	jsr	draw_door

l6_door_is_open:

	;======================
	; release lemmings
	;======================

	jsr	release_lemming

	;=====================
	; animate flames
	;=====================

	jsr	draw_flames

	jsr	update_timer

	; main drawing loop

	jsr	erase_lemming

	jsr	erase_pointer

	jsr	move_lemmings

	jsr	draw_lemming

	jsr	handle_keypress

	jsr	draw_pointer

	lda	#$ff
	jsr	wait

	inc	FRAMEL

	lda	LEVEL_OVER
	bne	l6_level_over

	jmp	l6_main_loop


l6_level_over:

	rts

.include "update_timer.s"

.include "graphics/graphics_level6.inc"


music12_parts_h:
	.byte >lemm12_part1_lzsa,>lemm12_part2_lzsa,>lemm12_part3_lzsa
	.byte >lemm12_part4_lzsa,>lemm12_part5_lzsa,>lemm12_part6_lzsa
	.byte >lemm12_part7_lzsa,>lemm12_part8_lzsa
	.byte $00

music12_parts_l:
	.byte <lemm12_part1_lzsa,<lemm12_part2_lzsa,<lemm12_part3_lzsa
	.byte <lemm12_part4_lzsa,<lemm12_part5_lzsa,<lemm12_part6_lzsa
	.byte <lemm12_part7_lzsa,<lemm12_part8_lzsa



lemm12_part1_lzsa:
.incbin "music/lemm12.part1.lzsa"
lemm12_part2_lzsa:
.incbin "music/lemm12.part2.lzsa"
lemm12_part3_lzsa:
.incbin "music/lemm12.part3.lzsa"
lemm12_part4_lzsa:
.incbin "music/lemm12.part4.lzsa"
lemm12_part5_lzsa:
.incbin "music/lemm12.part5.lzsa"
lemm12_part6_lzsa:
.incbin "music/lemm12.part6.lzsa"
lemm12_part7_lzsa:
.incbin "music/lemm12.part7.lzsa"
lemm12_part8_lzsa:
.incbin "music/lemm12.part8.lzsa"


level6_intro_text:
.byte  0, 8,"LEVEL 6",0
.byte  8, 8,"A TASK FOR BLOCKERS AND BOMBERS",0
.byte  9,12,"NUMBER OF LEMMINGS 50",0
.byte 12,14,"20%  TO BE SAVED",0
.byte 12,16,"RELEASE RATE 50",0
.byte 13,18,"TIME 5 MINUTES",0
.byte 15,20,"RATING FUN",0
.byte  8,23,"PRESS RETURN TO CONTINUE",0
