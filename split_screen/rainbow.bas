10 A = 9200 :B = 13168:C=100:X=279
20 TEXT : HOME :GOTO 40
30 HPLOT 0,Y TO X,Y:RETURN
40 DATA 173,87,192,173,83,192,173,84,192,173,80,192
50 DATA 208,251,173,86,192,160,22,136,208,253,234,173,87,192,76,9,3
60 FOR I = 768 TO 796:READ N:POKE I,N:NEXT
70 HGR : POKE  - 16302,0
80 HCOLOR= 4:HPLOT 0,0: CALL 62454
90 HCOLOR= 2:Y=63:GOSUB 30:Y=62:GOSUB 30
100 HCOLOR= 6:Y=61:GOSUB 30:Y=60:GOSUB 30
110 HCOLOR= 1:Y=59:GOSUB 30:Y=58:GOSUB 30
120 HCOLOR= 5:Y=55:GOSUB 30:Y=54:GOSUB 30
130 HCOLOR= 0:X=C
140 Y=123:GOSUB 30:Y=122:GOSUB 30
150 Y=119:GOSUB 30:Y=118:GOSUB 30
160 COLOR= 0:FOR I = 0 TO 39:VLIN 0,39 AT I:NEXT
170 COLOR= 13:HLIN 0,39 AT 14
180 FOR I = 0 TO 7:POKE A + I,0:POKE B + I,0:NEXT
190 COLOR= 1:HLIN 0,39 AT 13
200 VTAB 21:PRINT TAB(16)"RAINBOW"
210 PRINT:PRINT "MIXED GRAPHICS (HI-RES/COLOR)"
220 CALL 768 
