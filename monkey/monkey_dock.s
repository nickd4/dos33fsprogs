; stuff regarding the dock
; guybrush is a friend without pier

dock_check_exit:
;	lda	DESTINATION_Y
;	cmp	#28
;	bcc	lookout_no_exit

;	lda	DESTINATION_X
;	cmp	#28
;	bcc	lookout_no_exit
;	cmp	#35
;	bcs	lookout_no_exit

;	lda	#MONKEY_POSTER
;	sta	LOCATION
;	lda	#2
;	sta	GUYBRUSH_X
;	lda	#22
;	sta	GUYBRUSH_Y
;	jsr	change_location

dock_no_exit:
	rts

dock_adjust_destination:

dk_check_x:
;	lda	DESTINATION_X
;	cmp	#19
;	bcc	ld_x_too_small
;	cmp	#35
;	bcs	ld_x_too_big
;	jmp	ld_check_y

dk_x_too_big:
;	lda	#35
;	sta	DESTINATION_X
;	bne	ld_check_y

dk_x_too_small:
;	lda	#18
;	sta	DESTINATION_X

dk_check_y:
	; if x < 28, Y must be between 16 and 18
	; if x < 35, Y must be between  8 and 28

;	lda	DESTINATION_Y
;	cmp	#16
;	bcc	ld_y_too_small

	rts

dk_y_too_small:
;	lda	#16
;	sta	DESTINATION_Y

done_dk_adjust:
	rts




;draw_house:

;	lda	#<wall_sprite
;	sta	INL
;	lda	#>wall_sprite
;	sta	INH

;	lda	#18
;	sta	XPOS
;	lda	#22
;	sta	YPOS

;	jsr	put_sprite_crop

;	rts

;house_sprite:

