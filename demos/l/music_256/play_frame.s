play_frame:

	;============================
	; see if still counting down

song_countdown_smc:
	lda	#$FF			; initially negative so we enter loop
	bpl	done_update_song

set_notes_loop:

	;==================
	; load next byte

	pla			; located on stack

	;==================
	; see if hit end

	; this song only 16 notes so valid notes always positive
	bpl	not_end

	;====================================
	; if at end, loop back to beginning

	asl			; reset song offset to 0
	tax
	txs
	beq	set_notes_loop

not_end:

	; NNNNNECC -- c=channel, e=end, n=note

	sta	SAVE			; save note

	and	#3
	tax

	ldy	#$0E
	sty	AY_REGS+8,X		; $08 set volume A,B,C

	asl
	tax				; put channel offset in X


	lda	SAVE			; restore note
	tay
	and	#$4
	sta	song_countdown_smc+1	; always 4 long?

	tya
	lsr
	lsr
	lsr				; get note in A

	tay				; lookup in table

	lda	frequencies_high,Y
	sta	AY_REGS+1,X
;	sta	$500,X

	lda	frequencies_low,Y
	sta	AY_REGS,X		; set proper register value

	; visualization
blah_urgh:
	sta	$400,Y
	inc	blah_urgh+1


	;============================
	; point to next

	; don't have to, PLA did it for us

done_update_song:
	dec	song_countdown_smc+1
	bmi	set_notes_loop
