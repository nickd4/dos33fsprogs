
	; updates the time left
update_time:

	; update explosion timer
	; not ideal (first second might be short)

	ldy	#0
update_exploding_loop:
	lda	lemming_exploding,Y
	beq	not_done_exploding


	tya
	tax
	inc	lemming_exploding,X
	lda	lemming_exploding,Y
	cmp	#6
	bne	not_done_exploding

	lda	#LEMMING_EXPLODING
	sta	lemming_status,Y
	lda	#0
	sta	lemming_frame,Y
	sta	lemming_exploding,Y

not_done_exploding:

	iny
	cpy	#MAX_LEMMINGS
	bne	update_exploding_loop



	sed

	sec
	lda	TIME_SECONDS
	sbc	#1
	cmp	#$99
	bne	no_time_uflo
	lda	#$59
	dec	TIME_MINUTES

no_time_uflo:
	sta	TIME_SECONDS

	cld

	lda	TIME_MINUTES
	bne	not_over
	lda	TIME_SECONDS
	bne	not_over

	; out of time


	lda	#LEVEL_FAIL
	sta	LEVEL_OVER


not_over:


draw_time:

	; draw minute
	ldy	TIME_MINUTES

	lda	bignums_l,Y
	sta	INL
	lda	bignums_h,Y
	sta	INH

	; 246, 152

	ldx	#35		; 245
        stx     XPOS
	lda	#152
	sta	YPOS

	jsr	hgr_draw_sprite_autoshift

	; draw seconds
	lda	TIME_SECONDS
	lsr
	lsr
	lsr
	lsr
	tay

	lda	bignums_l,Y
	sta	INL
	lda	bignums_h,Y
	sta	INH

	ldx	#37
        stx     XPOS
	lda	#152
	sta	YPOS

	jsr	hgr_draw_sprite_autoshift


	; draw seconds
	lda	TIME_SECONDS
	and	#$f
	tay

	lda	bignums_l,Y
	sta	INL
	lda	bignums_h,Y
	sta	INH

	ldx	#38
        stx     XPOS
	lda	#152
	sta	YPOS

	jsr	hgr_draw_sprite_autoshift

	rts

	;===========================
	;===========================
	; update lemmings out number
	;===========================
	;===========================

	; TODO: combine with time drawing code?

update_lemmings_out:

	; draw tens
	lda	LEMMINGS_OUT
	lsr
	lsr
	lsr
	lsr
	beq	lemmings_out_ones
lemmings_out_tens:

	tay
	lda	bignums_l,Y
	sta	INL
	lda	bignums_h,Y
	sta	INH

	ldx	#15		; 105
        stx     XPOS
	lda	#152
	sta	YPOS

	jsr	hgr_draw_sprite_autoshift


lemmings_out_ones:
	lda	LEMMINGS_OUT
	and	#$f
	tay

	lda	bignums_l,Y
	sta	INL
	lda	bignums_h,Y
	sta	INH

	ldx	#16		; 112
        stx     XPOS
	lda	#152
	sta	YPOS

	jsr	hgr_draw_sprite_autoshift

	rts



bignums_l:
.byte	<big0_sprite,<big1_sprite,<big2_sprite,<big3_sprite,<big4_sprite
.byte	<big5_sprite,<big6_sprite,<big7_sprite,<big8_sprite,<big9_sprite

bignums_h:
.byte	>big0_sprite,>big1_sprite,>big2_sprite,>big3_sprite,>big4_sprite
.byte	>big5_sprite,>big6_sprite,>big7_sprite,>big8_sprite,>big9_sprite
