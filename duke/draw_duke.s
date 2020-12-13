
	;=========================
	; move duke
	;=========================
move_duke:

	jsr	duke_get_feet_location	; get location of feet

	jsr	check_falling

	jsr	handle_jumping

	lda	DUKE_WALKING
	beq	done_move_duke

	lda	DUKE_DIRECTION
	bmi	move_left

	lda	DUKE_X
	cmp	#22
	bcc	duke_walk_right

duke_scroll_right:

	inc	TILEMAP_X

	jsr	copy_tilemap_subset

	jmp	done_move_duke

duke_walk_right:
	inc	DUKE_X

	jmp	done_move_duke

move_left:

	lda	DUKE_X
	cmp	#14
	bcs	duke_walk_left

duke_scroll_left:

	dec	TILEMAP_X

	jsr	copy_tilemap_subset

	jmp	done_move_duke

duke_walk_left:
	dec	DUKE_X

	jmp	done_move_duke

done_move_duke:

	rts



	;=========================
	; duke collide
	;=========================
	; only check above head if jumping

duke_collide:

	rts


	;=========================
	; check_jumping
	;=========================
handle_jumping:

	lda	DUKE_JUMPING
	beq	done_handle_jumping

	dec	DUKE_Y
	dec	DUKE_Y
	dec	DUKE_JUMPING

done_handle_jumping:
	rts




	;=======================
	; duke_get_feet_location
	;=======================

	;		xx	0
	;		xx	1
	; xx	0	xx	2
	; xx	1	xx	3
	;------		-----
	; xx	2	xx	4
	; xx	3	xx	5
	; xx	4	xx	6
	; xx	5	xx	7
	;------		-------
	; xx	6	xx	8
	; xx	7	xx	9
	; xx    8
	; xx	9
	;-----------------------
duke_get_feet_location:

	; this is tricky as we are 10 tall but tiles are 4 tall

	; + 1 is because sprite is 4 pixels wide?

	; screen is 16 wide, but ofsset 4 in

	; block index of foot is (feet approximately 8 lower than Y)
	; INT((y+8)/4)*16 + (x-4+1/2)

	; if 18,18 -> INT(26/4)*16 = 96 + 7 = 103 = 6R7

	; 0 = 32 (2)
	; 1 = 32 (2)
	; 2 = 32 (2)
	; 3 = 32 (2)
	; 4 = 48 (3)
	; 5 = 48 (3)
	; 6 = 48 (3)
	; 7 = 48 (3)



	lda	DUKE_Y
	clc
	adc	#8		; +8
	lsr			; / 4 (INT)
	lsr

	asl			; *4
	asl
	asl
	asl

	sta	DUKE_FOOT_OFFSET

	sec
	lda	DUKE_X
	sbc	#3
	lsr			; (x-3)/2

	clc
	adc	DUKE_FOOT_OFFSET
	sta	DUKE_FOOT_OFFSET

	rts


	;=========================
	; check_falling
	;=========================
check_falling:

	lda	DUKE_JUMPING
	bne	done_check_falling	; don't check falling if jumping

	lda	DUKE_FOOT_OFFSET
	clc
	adc	#16			; underfoot is 16 more

	tax
	lda	TILEMAP,X

	; if tile# < 32 then we fall
	cmp	#32
	bcs	feet_on_ground		; bge

	;=======================
	; falling

	; scroll but only if Y=18

	lda	DUKE_Y
	cmp	#18
	bne	scroll_fall

	inc	DUKE_Y
	inc	DUKE_Y
	jmp	done_check_falling


scroll_fall:
	inc	TILEMAP_Y

	jsr	copy_tilemap_subset
	jmp	done_check_falling

feet_on_ground:

	; check to see if Y still hi, if so scroll back down

	lda	DUKE_Y
	cmp	#18
	bcs	done_check_falling	; bge

	; too high up on screen, adjust down ad also adjust tilemap down

	inc	DUKE_Y
	inc	DUKE_Y
	dec	TILEMAP_Y		; share w above?
	jsr	copy_tilemap_subset

done_check_falling:
	rts




	;=========================
	; draw duke
	;=========================
draw_duke:

	lda	DUKE_X
	sta	XPOS
	lda	DUKE_Y
	sta	YPOS

	lda	DUKE_DIRECTION
	bmi	duke_facing_left

	lda	#<duke_sprite_stand_right
	sta	INL
	lda	#>duke_sprite_stand_right
	jmp	actually_draw_duke
duke_facing_left:

	lda	#<duke_sprite_stand_left
	sta	INL
	lda	#>duke_sprite_stand_left

actually_draw_duke:
	sta	INH
	jsr	put_sprite_crop

	rts

duke_sprite_stand_right:
	.byte 4,5
	.byte $AA,$dA,$dA,$AA
	.byte $AA,$dd,$bb,$AA
	.byte $AA,$b3,$7A,$7A
	.byte $AA,$66,$6b,$AA
	.byte $AA,$56,$65,$AA

duke_sprite_stand_left:
	.byte 4,5
	.byte $AA,$dA,$dA,$AA
	.byte $AA,$bb,$dd,$AA
	.byte $7A,$7A,$b3,$AA
	.byte $AA,$6b,$66,$AA
	.byte $AA,$65,$56,$AA

