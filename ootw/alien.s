; draw/move the bad guy aliens

MAX_ALIENS	= 3

alien_out:
	alien0_out:		.byte	0
	alien1_out:		.byte	0
	alien2_out:		.byte	0

alien_room:
	alien0_room:		.byte	0
	alien1_room:		.byte	0
	alien2_room:		.byte	0

alien_x:
	alien0_x:		.byte	0
	alien1_x:		.byte	0
	alien2_x:		.byte	0

alien_y:
	alien0_y:		.byte	0
	alien1_y:		.byte	0
	alien2_y:		.byte	0

alien_state:
	alien0_state:		.byte	0
	alien1_state:		.byte	0
	alien2_state:		.byte	0

A_STANDING		= 0
A_WALKING		= 1
A_RUNNING		= 2
A_CROUCHING		= 3
A_TURNING		= 4
A_YELLING		= 5
A_SHOOTING_UP		= 6
A_DISINTEGRATING	= 7


alien_gait:
	alien0_gait:		.byte	0
	alien1_gait:		.byte	0
	alien2_gait:		.byte	0

alien_direction:
	alien0_direction:	.byte	0
	alien1_direction:	.byte	0
	alien2_direction:	.byte	0

alien_gun:
	alien0_gun:		.byte	0
	alien1_gun:		.byte	0
	alien2_gun:		.byte	0





	;=======================================
	; Move alien based on current state
	;

move_alien:
	; FIXME: loop through all alieans
	ldx	#0

	lda	alien_out,X
	beq	done_move_alien

	lda	alien_state,X

	cmp	#A_WALKING
	beq	move_alien_walking
	cmp	#A_RUNNING
	beq	move_alien_running
	cmp	#A_YELLING
	beq	move_alien_yelling
	cmp	#A_SHOOTING_UP
	beq	move_alien_yelling
done_move_alien:
	rts

	;======================
	; yelling
move_alien_yelling:
	inc	alien_gait,X		; cycle through animation
	rts

	;======================
	; walking

move_alien_walking:
	inc	alien_gait,X		; cycle through animation

	lda     alien_gait,X
	and     #$f
	cmp     #$8			; only walk roughly 1/8 of time
	bne     alien_no_move_walk

	lda	alien_direction,X
	beq	a_walk_left

	inc	alien_x,X		; walk right
	rts
a_walk_left:
	dec     alien_x,X		; walk left
alien_no_move_walk:
	rts

	;======================
	; running
move_alien_running:
	inc	alien_gait,X		; cycle through animation

	lda     alien_gait,X
	and     #$3
	cmp     #$2			; only run roughly 1/4 of time
	bne     alien_no_move_run

	lda	alien_direction,X
	beq	a_run_left

	inc	alien_x,X			; run right
	rts
a_run_left:
	dec	alien_x,X			; run left
alien_no_move_run:
	rts

	;======================
	; standing

move_alien_standing:





astate_table_lo:
	.byte <alien_standing	; 00
	.byte <alien_walking	; 01
	.byte <alien_running	; 02
	.byte <alien_crouching	; 03
	.byte <alien_turning	; 04
	.byte <alien_yelling	; 05
	.byte <alien_shooting_up; 06
	.byte <alien_disintegrating; 07

astate_table_hi:
	.byte >alien_standing	; 00
	.byte >alien_walking	; 01
	.byte >alien_running	; 02
	.byte >alien_crouching	; 03
	.byte >alien_turning	; 04
	.byte >alien_yelling	; 05
	.byte >alien_shooting_up; 06
	.byte >alien_disintegrating; 07

; Urgh, make sure this doesn't end up at $FF or you hit the
;	NMOS 6502 bug

.align 2

ajump:
	.word	$0000

.align 1

;======================================
;======================================
; draw alien
;======================================
;======================================

draw_alien:
	; FIXME
	ldx	#0

	lda	alien_out,X
	beq	no_alien

	lda	alien_state,X
	tay
	lda	astate_table_lo,y
	sta	ajump
	lda	astate_table_hi,y
	sta	ajump+1
	jmp	(ajump)

no_alien:
	rts

;==================================
; STANDING
;==================================

alien_standing:

	lda	#<alien_stand
	sta	INL

	lda	#>alien_stand
	sta	INH

	jmp	finally_draw_alien


;===================================
; CROUCHING
;===================================

alien_crouching:

	; FIXME: we have an animation?

	lda	#<alien_crouch2
	sta	INL

	lda	#>alien_crouch2
	sta	INH

	jmp	finally_draw_alien


;===============================
; Walking
;================================

alien_walking:
	lda	alien_gait,X
	cmp	#64
	bcc	alien_gait_fine	; blt

	lda	#0
	sta	alien_gait,X

alien_gait_fine:
	lsr
	lsr
	and	#$fe

	tay

	lda	alien_gun,X
	beq	alien_walk_nogun

alien_walk_gun:

	lda	alien_walk_gun_progression,Y
	sta	INL

	lda	alien_walk_gun_progression+1,Y
	sta	INH

	jmp	finally_draw_alien

alien_walk_nogun:
	lda	alien_walk_progression,Y
	sta	INL

	lda	alien_walk_progression+1,Y
	sta	INH

	jmp	finally_draw_alien

;===============================
; Running
;================================

alien_running:
	lda	alien_gait,X
	cmp	#32
	bcc	alien_run_gait_fine	; blt

	lda	#0
	sta	alien_gait,X

alien_run_gait_fine:
	lsr
	and	#$fe

	tay

	lda	alien_run_progression,Y
	sta	INL

	lda	alien_run_progression+1,Y
	sta	INH

	jmp	finally_draw_alien

;===============================
; Turning
;================================

alien_turning:

	dec	alien_gait,X
	bpl	alien_draw_turning

	lda	#0
	sta	alien_gait,X

	; switch direction
	lda	alien_direction,X
	eor	#$1
	sta	alien_direction,X

	lda	#A_WALKING
	sta	alien_state,X

alien_draw_turning:
	lda	#<alien_turning_sprite
	sta	INL

	lda	#>alien_turning_sprite
	sta	INH

	jmp	finally_draw_alien



;===============================
; Yelling
;================================

alien_yelling:
	lda	alien_gait,X

	; 00
	; 01
	; 10
	; 11

	and	#$40
	bne	alien_yelling_no_waving

	lda	alien_gait,X

alien_yelling_no_waving:
	and	#$10
	lsr
	lsr
	lsr
	and	#2

	tay

	lda	alien_yell_progression,Y
	sta	INL

	lda	alien_yell_progression+1,Y
	sta	INH

	jmp	finally_draw_alien


;===============================
; Disintegrating
;================================

alien_disintegrating:
	lda	alien_gait,X

	cmp	#13
	bne	alien_keep_disintegrating

	lda	#0
	sta	alien_out,X

	dec	ALIEN_OUT

	rts

alien_keep_disintegrating:

	asl
	tay

	lda	alien_disintegrating_progression,Y
	sta	INL

	lda	alien_disintegrating_progression+1,Y
	sta	INH

	lda	FRAMEL
	and	#$7
	bne	slow_disintegration

	inc	alien_gait,X
slow_disintegration:

	jmp	finally_draw_alien


;===============================
; Shooting Upward
;================================

alien_shooting_up:
	lda	alien_gait,X
	and	#$30

	;  000 000
	;  010 000
	;  100 000
	;  110 000

	lsr
	lsr
	lsr

	and	#6
	tay

	lda	alien_shoot_up_progression,Y
	sta	INL

	lda	alien_shoot_up_progression+1,Y
	sta	INH

	cpy	#0

	lda	alien_gait,X
;	and	#$ff
	bne	finally_draw_alien

	lda	#32
	sta	SHOOTING_BOTTOM
	lda	#28
	sta	SHOOTING_TOP

	inc	LITTLEGUY_OUT

;	bne	finally_draw_alien	; bra



;=============================
; Actually Draw Alien
;=============================


finally_draw_alien:
	lda	alien_x,X
	sta	XPOS

	lda	alien_y,X
	sta	YPOS

	lda	alien_direction,X
	bne	alien_facing_right

alien_facing_left:
        jmp	put_sprite_crop

alien_facing_right:
	jmp	put_sprite_flipped_crop


	;==================
	;==================
	; clear aliens
	;==================
	;==================
clear_aliens:
	lda	#0
	sta	alien0_out
	sta	alien1_out
	sta	alien2_out

	rts


	;==============================
	;==============================
	; alien room init
	;==============================
	;==============================

alien_room_init:
	;==============================
        ; if alien in room, set ALIEN_OUT

        lda     #0
        sta     ALIEN_OUT

        ldx     #0
alien_room_loop:
        lda     alien_out,X
        beq     alien_room_continue

        lda     alien_room,X
        cmp     WHICH_ROOM
        bne     alien_room_continue

        inc     ALIEN_OUT

alien_room_continue:
        inx
        cpx     #MAX_ALIENS
        bne     alien_room_loop

	rts
