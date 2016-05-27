7 TEXT:HOME
10 REM PRINT CHR$(4);"BLOAD GLOBE.HGR,A$2000"
20 AN$="ZURGTROYD":S=3
95 G=-9.8
100 EN(1)=1:ST(1)=1:FT(1)=1
101 EN(2)=2:ST(2)=2:FT(2)=1
102 EN(3)=3:ST(3)=3:FT(3)=1
103 LN=0:CQ=0:OM=0
110 HIMEM:7925
120 POKE 232,245:POKE 233,30
130 FOR L=7925 TO 8175: READ B:POKE L,B:NEXT L
1000 PRINT "ROCKET SUMMARY:":PRINT
1005 FOR I=1 TO S
1010 EM(I)=EN(I)*1.5+ST(I)*FT(I)*0.5
1012 IF I=1 THEN EM(I)=EM(I)+1.0
1014 FM(I)=ST(I)*FT(I)*4.0
1015 SF(I)=FM(I)
1016 SM(I)=EM(I)+FM(I)
1020 TM(I)=0
1022 FOR J=1 TO I
1025 TM(I)=TM(I)+SM(J)
1030 NEXT J
1035 TH(I)=EN(I)*168
1040 DV(I)=270*-G*LOG(TM(I)/(TM(I)-FM(I)))
1050 TW(I)=TH(I)/(TM(I)*-G)
1055 FF(I)=TH(I)/(270*-G)
1990 PRINT "STAGE: ";4-I
1991 PRINT "  TANKS=";ST(I)*FT(I);" ENGINES=";EN(I)
1992 PRINT "  STAGE MASS=";SM(I);" TOTAL MASS=";TM(I)
1993 PRINT "  DELTAV=";DV(I)
1995 PRINT "  TWR=";TW(I)
2000 NEXT I
2999 GET A$
3000 AN=0:GX=0:GY=-9.8:GA=0:V=0:VX=0:VY=0:AX=0:AY=0:KR=600000
3016 RX=0:RY=KR+10:RA=KR+10:TR=0:T=0
3020 HGR:ROT=0:SCALE=2:H=0
3030 REM ** LAUNCHPAD **
3035 PRINT:PRINT CHR$(4);"BLOAD LAUNCHPAD.HGR,A$2000"
3038 HCOLOR=1:HPLOT 1,80 TO 132,80: HPLOT 148,80 TO 247,80
3039 HCOLOR=3:HPLOT 110,110 TO 110,60:HPLOT TO 130,60: HPLOT 110,70 TO 130,70
3040 XDRAW 1+((S-1)*2)+TR AT 140,80
4000 REM ** LOOP **
4002 IF LN=0 GOTO 5032
4003 RR=RA-KR
4004 IF RR>1800 THEN GOTO 4012
4005 HCOLOR=0:HPLOT 1,80+H TO 132,80+H:HPLOT 148,80+H TO 247,80+H
4010 H=RR/20:HCOLOR=1:HPLOT 1,80+H TO 132,80+H:HPLOT 148,80+H TO 247,80+H
4012 IF RR<40000 AND CQ<>0 THEN GOSUB 7600
4014 IF RR<40000 GOTO 4018
4016 IF RR>40000 AND CQ<>1 THEN GOSUB 7700
4018 FL=FM(S)*100/SF(S)
4020 IF TR<>1 THEN GOTO 4050
4025 IF FM(S)<0.1 THEN FM(S)=0:AX=0:AY=0:GOTO 4050
4030 AX=(TH(S)/TM(S))*SIN(AN):AY=(TH(S)/TM(S))*COS(AN)
4040 FM(S)=FM(S)-FF(S):TM(S)=TM(S)-FF(S)
4047 GOTO 4060
4050 REM NOT THRUSTING
4055 AX=0:AY=0
4060 GA=ATN(RX/RY)
4065 IF RY<0 THEN GA=GA+3.14
4070 GY=COS(GA)*G:GX=SIN(GA)*G
4080 AY=AY+GY:AX=AX+GX
4090 ZX=VX:ZY=VY
5000 VY=ZY+AY:VX=ZX+AX
5010 V=SQR(VX*VX+VY*VY)
5012 RY=RY+0.5*(ZY+VY):RX=RX+0.5*(ZX+VX)
5018 RA=SQR(RX*RX+RY*RY)
5020 IF RA<KR THEN GOTO 8000
5030 G=-9.8/((RA/KR)*(RA/KR))
5032 VTAB 21
5040 PRINT "TIME: ";T,"STAGE: ";4-S;"      ";AN$
5045 PRINT "ALT: ";INT((RA-KR)/1000);"KM  ";AN;"   "
5060 PRINT "VEL: ";INT(V);"M/S","FUEL: ";INT(FL);"%  "
5080 REM PRINT "GRAVANGLE ";GA*180/3.14
5090 REM PRINT "X: ";RX;" Y: ";RY
5100 REM PRINT "VX: ";VX;" VY: ";VY
5110 REM PRINT "ANGLE: ";AN
5112 REM PRINT "AX: ";AX;"AY: ";AY
5113 XDRAW 1+((S-1)*2)+TR AT 140,80
5115 Q=PEEK(-16384):IF Q<128 THEN GOTO 6080
6000 A$=CHR$(Q-128):POKE 49168,0
6060 IF A$="Q" THEN END
6061 IF A$="A" THEN R=R-8:AN=AN-0.7853
6062 IF A$="D" THEN R=R+8:AN=AN+0.7853
6063 IF A$="C" THEN GOTO 8000
6064 IF A$="Z" THEN TH=1
6065 IF A$="V" THEN RA=RA+100
6066 IF A$="X" THEN TH=0
6068 IF A$=" " AND LN=1 THEN S=S-1:XX=PEEK(-16336)
6069 IF A$=" " AND LN=0 THEN GOSUB 7500
6070 IF A$="E" THEN GOSUB 8100
6073 IF R=64 THEN R=0:AN=0
6074 IF R=-8 THEN R=56
6075 IF S<0 THEN S=0
6080 ROT=R
6090 XDRAW 1+((S-1)*2)+TR AT 140,80
6118 T=T+1
6200 GOTO 4000
6500 REM ** ORBIT MODE **
6530 HX=INT(RX/25000)+140:HY=INT(-RY/25000)+85
6535 REM CHECK BOUNDS
6540 REM HPLOT HX,HY
6550 RETURN
7200 DATA 6,0,14,0,42,0,77,0,113,0
7201 DATA 156,0,200,0,219,36,36,44,44,44
7202 DATA 53,53,53,54,54,54,54,63,63,45
7203 DATA 46,46,62,63,63,39,37,37,63,36
7204 DATA 36,0,219,36,36,44,44,44,53,53
7205 DATA 53,54,54,54,54,63,63,45,46,46
7206 DATA 62,63,127,73,62,54,62,39,36,39
7207 DATA 39,37,37,63,36,36,0,219,36,36
7208 DATA 36,36,44,44,44,53,53,53,54,54
7209 DATA 54,54,54,54,54,54,63,63,45,46
7210 DATA 46,62,63,63,39,37,37,63,36,36
7211 DATA 36,36,0,219,36,36,36,36,44,44
7212 DATA 44,53,53,53,54,54,54,54,54,54
7213 DATA 54,54,63,63,45,46,46,62,63,127
7214 DATA 73,62,54,62,39,36,39,39,37,37
7215 DATA 63,36,36,36,36,0,219,36,36,36
7216 DATA 36,36,36,44,44,44,53,53,53,54
7217 DATA 54,54,54,54,54,54,54,54,54,54
7218 DATA 54,63,63,45,46,46,62,63,63,39
7219 DATA 37,37,63,36,36,36,36,36,36,0
7220 DATA 219,36,36,36,36,36,36,44,44,44
7221 DATA 53,53,53,54,54,54,54,54,54,54
7222 DATA 54,54,54,54,54,63,63,45,46,46
7223 DATA 62,63,127,73,62,54,62,39,36,39
7224 DATA 39,37,37,63,36,36,36,36,36,36
7225 DATA 0
7500 REM *** LAUNCH ***
7510 HCOLOR=0:HPLOT 110,110 TO 110,60:HPLOT TO 130,60: HPLOT 110,70 TO 130,70
7520 XX=PEEK(-16336)
7530 TR=1:LN=1
7535 GOSUB 8220
7540 RETURN
7600 REM *** GROUND ***
7610 HOME:PRINT:PRINT CHR$(4);"BLOAD LAUNCHPAD.HGR,A$2000"
7615 XDRAW 1+((S-1)*2)+TR AT 140,80
7620 CQ=0
7650 RETURN
7700 REM *** SPACE_UP ***
7710 HOME:PRINT:PRINT CHR$(4);"BLOAD ORBIT_TOP.HGR,A$2000"
7715 XDRAW 1+((S-1)*2)+TR AT 140,80
7720 CQ=1
7750 RETURN
8000 REM *** CRASH ***
8010 SCALE=3
8015 GOSUB 8200
8020 FOR I=0 TO 64 STEP 8: ROT=I:XDRAW 1+(S*2)+TH AT 140,80: XX=PEEK(-16336):NEXT I
8030 FOR I=1 TO 50
8040 X=INT(RND(1)*80)+1:Y=INT(RND(1)*80)+1
8050 C=INT(RND(1)*7)+1:HCOLOR=C
8060 HPLOT 140,80 TO 100+X,40+Y
8070 XX=PEEK(-16336)
8080 NEXT I
8090 END
8100 REM *** KERBAL EYES ***
8105 HCOLOR=3:HPLOT 258,150 TO 263,150:HPLOT 265,150 TO 270,150
8110 KE=INT(RND(1)*3)
8120 HCOLOR=0:HPLOT 258+(2*KE),150 TO 259+(2*KE),150
8125 HPLOT 265+(2*KE),150 TO 266+(2*KE),150
8130 RETURN
8200 REM *** KERBAL FROWN ***
8205 HCOLOR=1:HPLOT 259,155 TO 271,155:HPLOT 259,156 TO 271,156
8206 HCOLOR=0:HPLOT 261,155 TO 269,155:HPLOT 259,156 TO 271,156
8207 RETURN
8210 REM *** KERBAL NEUTRAL ***
8215 HCOLOR=1:HPLOT 259,155 TO 271,155:HPLOT 259,156 TO 271,156
8216 HCOLOR=0:HPLOT 259,155 TO 271,155
8217 RETURN
8220 REM *** KERBAL SMILE ***
8225 HCOLOR=1:HPLOT 259,155 TO 271,155:HPLOT 259,156 TO 271,156
8226 HCOLOR=0:HPLOT 259,155 TO 271,155:HPLOT 261,156 TO 269,156
8227 RETURN
