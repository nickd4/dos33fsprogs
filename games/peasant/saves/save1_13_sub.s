; SAVE1 -- After getting the sub

.include "zp.inc"

; want to load this to address $90

;
.byte LOAD_PEASANT4	; WHICH_LOAD	= 	$90
.byte 10		; PEASANT_X	=	$91
.byte 100		; PEASANT_Y	=	$92
.byte PEASANT_DIR_UP	; PEASANT_DIR	=	$93
.byte 0			; MAP_X		=	$94
.byte 1			; MAP_Y		=	$95
.byte LOCATION_OUTSIDE_LADY	; MAP_LOCATION	=	$96
.byte	TALKED_TO_MENDELEV | HALDO_TO_DONGOLEV | ARROW_BEATEN| GARY_SCARED | TRINKET_GIVEN | LADY_GONE
	; BABY_IN_WELL | BUCKET_DOWN_WELL
			; GAME_STATE_0	=	$97
.byte PUDDLE_WET
	; RAINING
	; FISH_FED | IN_HAY_BALE | NIGHT | POT_ON_HEAD | WEARING_ROBE
		; GAME_STATE_1	=	$98
.byte TALKED_TO_KNIGHT
	; ON_FIRE | COTTAGE_ROCK_MOVED | KNUCKLES_BLEED
	; DRESSER_OPEN | COVERED_IN_MUD | GOT_MUDDY_ALREADY
			; GAME_STATE_2	=	$99
.byte $00		; NED_STATUS	=	$9A
.byte BUSH_1_SEARCHED | BUSH_2_SEARCHED | BUSH_3_SEARCHED | BUSH_4_SEARCHED
		; BUSH_STATUS	=	$9B
.byte KERREK_ROW1 | KERREK_DECOMPOSING	; KERREK_STATE	=	$9C
.byte $00		; ARROW_SCORE	=	$9D
.byte $00		; SCORE_HUNDREDS=	$9E
.byte $20		; SCORE_TENSONES=	$9F
.byte INV1_ARROW | INV1_BABY | INV1_KERREK_BELT | INV1_BOW | INV1_MONSTER_MASK | INV1_PEBBLES
		; INVENTORY_1	=	$A0
.byte INV2_RICHES|INV2_MEATBALL_SUB | INV2_TRINKET
			; INVENTORY_2	=	$A1
.byte INV3_SHIRT|INV3_MAP
			; INVENTORY_3	=	$A2
.byte INV1_ARROW|INV1_PEBBLES
			; INVENTORY_1_GONE =	$A3
.byte INV2_RICHES | INV2_TRINKET
			; INVENTORY_2_GONE_=	$A4
.byte $00		; INVENTORY_3_GONE =	$A5
.byte 22		; KERREK_X	=	$A6
.byte 76		; KERREK_Y	=	$A7

