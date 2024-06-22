10 SHELL "CLS":COLOR 15,0
20 DEFINT A-Z
30 CLEAR:KEY OFF
40 X$="":FOR N=1 TO 10:KEY N,X$:NEXT N
50 DIM ALPH$(100,1),DALPH$(100),SN$(20),RN$(20)
60 :
70 REM **** Main Menu ****
80 M=0:BF=0:ER=-1
90 ON ERROR GOTO 4510
100 WHILE M=0
110   GOSUB 5260:LOCATE 3,30:COLOR 0,15:PRINT" TAPE CODER Ver.3.08 ":COLOR 15,0
120   LOCATE 6,35:COLOR 0,15:PRINT" MAIN MENU ":COLOR 15,0
130   LOCATE 8,24:PRINT"F1  : Load messages from disk"
140   LOCATE 9,24:PRINT"F2  : Save messages onto disk"
150   LOCATE 10,24:PRINT"F3  : Delete messages on disk"
160   LOCATE 12,24:PRINT"F4  : Encipher a message in memory"
170   LOCATE 13,24:PRINT"F5  : Decipher a message in memory"
180   LOCATE 15,24:PRINT"F6  : Type a new message"
190   LOCATE 16,24:PRINT"F7  : Edit/read a message in memory"
200   LOCATE 17,24:PRINT"F8  : Print a file"
210   LOCATE 18,24:PRINT"F9  : Save on/Receive from tape"
220   LOCATE 20,24:PRINT"F10 : Quit"
230   WHILE LEN(CH$)<>2
240     CH$=INKEY$
250   WEND
260   CH$=RIGHT$(CH$,1)
270   M=ASC(CH$)-58
280 :
290 REM **** Load a file ****
300   WHILE M=1
310     GOSUB 5260:BEEP:LOCATE 2,3:PRINT"LOAD MESSAGES FROM DISK INTO MEMORY"
320     LOCATE 4,3:COLOR 0,15:PRINT"** Ensure 'MESSAGE' disk is in drive A **":COLOR 15,0
330     LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
340     CNT$=INKEY$:IF CNT$="" THEN 340
350     IF ASC(CNT$)=27 THEN 70
360     GOSUB 5260:LOCATE 2,3:COLOR 0,15:PRINT"LOAD MESSAGES FROM DISK INTO MEMORY":COLOR 15,0
370     ER=0:PRINT:FILES "A:*.*"
380     PRINT:PRINT CHR$(186);" Type in name of message to load"
390     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
400     PRINT:PRINT CHR$(186);:PRINT " Message name: ":NM$="œ@]":UP=0
410     WHILE NM$<>""
420       V=CSRLIN-UP:LOCATE V-1,15:PRINT SPC(15):LOCATE V-1,15:INPUT": ",NM$
430       IF NM$="" THEN 70
440       ER=1:NAME "A:"+NM$ AS "A:"+NM$
450       SHELL "COPY A:"+NM$+" E:":V=SCREEN(POS(0),CSRLIN)
460       UP=1:VD=CSRLIN-1:LOCATE VD,1:PRINT CHR$(186)
470     WEND
480   WEND
490 :
500 REM **** Save a file ****
510   WHILE M=2
520     GOSUB 5260:BEEP:LOCATE 2,3:PRINT"SAVE MESSAGES IN MEMORY ONTO DISK"
530     LOCATE 4,3:COLOR 0,15:PRINT"** Ensure 'MESSAGE' disk is in drive A **":COLOR 15,0
540     LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
550     CNT$=INKEY$:IF CNT$="" THEN 550
560     IF ASC(CNT$)=27 THEN 70
570     GOSUB 5260
580     LOCATE 2,3:COLOR 0,15:PRINT"SAVE MESSAGES IN MEMORY ONTO DISK":COLOR 15,0
590     ER=2:PRINT:FILES "E:*.*"
600     PRINT:PRINT CHR$(186);" Type in name of message to save"
610     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
620     PRINT:PRINT CHR$(186);:PRINT " Message name: ":NM$="+=_":UP=0
630     WHILE NM$<>""
640       V=CSRLIN-UP:LOCATE V-1,15:PRINT SPC(15):LOCATE V-1,15:INPUT": ",NM$
650       IF NM$="" THEN 70
660       ER=3:NAME "E:"+NM$ AS "E:"+NM$
670       S$="COPY E:"+NM$+" A:"
680       SHELL S$
690       UP=1:VD=CSRLIN-1:LOCATE VD,1:PRINT CHR$(186)
700     WEND
710   WEND
720 :
730 REM **** Delete a file ****
740   WHILE M=3
750     GOSUB 5260:BEEP:LOCATE 2,3:PRINT"DELETE MESSAGES ON DISK"
760     LOCATE 4,3:COLOR 0,15:PRINT"** Ensure 'MESSAGE' disk is in drive A **":COLOR 15,0
770     LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
780     CNT$=INKEY$:IF CNT$="" THEN 780
790     IF ASC(CNT$)=27 THEN 70
800     NM$="œ)&"
810     WHILE NM$<>""
820       GOSUB 5260
830       LOCATE 2,3:COLOR 0,15:PRINT"DELETE MESSAGES ON DISK":COLOR 15,0
840       ER=4:PRINT:FILES "A:*.*"
850       PRINT:PRINT CHR$(186);" Type in name of message to delete"
860       PRINT:PRINT CHR$(186);" or ENTER to return to Main Menu"
870       PRINT:PRINT CHR$(186);:INPUT " Message name: ",NM$
880       IF NM$="" THEN 70
890       ER=5:NAME "A:"+NM$ AS "A:"+NM$
900       KILL "A:"+NM$
910     WEND
920   WEND
930 :
940 REM **** Encipher ****
950   WHILE M=4
960     GOSUB 5260:BEEP:LOCATE 2,3:PRINT "ENCIPHER A MESSAGE"
970     LOCATE 4,3:COLOR 0,15:PRINT"** Ensure 'SEND' data disk is in drive A **":COLOR 15,0
980     LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
990     CNT$=INKEY$:IF CNT$="" THEN 990
1000     IF ASC(CNT$)=27 THEN 70
1010     GOSUB 5260
1020     LOCATE 2,3:COLOR 0,15:PRINT "ENCIPHER A MESSAGE":COLOR 15,0
1030     ER=6:PRINT:FILES "E:*"
1040     PRINT:PRINT CHR$(186);" Type in name of message to encipher"
1050     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
1060     PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$
1070     IF NM$="" THEN 70
1080     ER=6.1:NAME "E:"+NM$ AS "E:"+NM$
1090     CLS:GOSUB 5260:LOCATE 6,3:PRINT"Enciphering. Please wait..."
1100     ER=7:OPEN "I",1,"A:SETNUM":INPUT#1,GETNUM:CLOSE 1
1110     IF GETNUM>99 THEN BF=5:GOTO 4250
1120     LOCATE 18,2:PRINT 99-GETNUM;" sets of data left"
1130     OPEN "I",1,"A:SDNO":INPUT#1,DINOS$:CLOSE 1
1140     DNO=VAL(MID$(DINOS$,GETNUM*2+1,2))
1150     OPEN "O",1,"D:ALFA.TMP"
1160     OPEN "R",2,"A:SALFJOIN",200
1170     FIELD#2,200 AS FSA$
1180     GET#2,GETNUM+1
1190     PRINT#1,FSA$:CLOSE
1200     OPEN "O",1,"D:NUMS.TMP"
1210     OPEN "R",2,"A:SNUMJOIN",130
1220     FIELD#2,130 AS FSN$
1230     FOR N=1 TO 20:GET#2,(GETNUM*20)+N:SN$(N)=FSN$:NEXT N
1240     FOR P=1 TO 20:PRINT#1,SN$(P);:NEXT P
1250     CLOSE
1260     OPEN "I",1,"D:ALFA.TMP"
1270     FOR BET = 0 TO 99
1280       ALPH$(BET,0)=CHR$(BET+32)
1290       ALPH$(BET,1)=INPUT$(2,#1)
1300     NEXT BET
1310     CLOSE
1320     OPEN "O",1,"E:"+NM$+".ENC"
1330     OPEN "I",2,"E:"+NM$
1340     OPEN "I",3,"D:NUMS.TMP"
1350     DNO$=ALPH$(DNO,0)
1360     FOR N=1 TO 4:PRINT#1,CHR$(132);:NEXT N:PRINT#1,DNO$;
1370     LOCATE 18,3:PRINT"Character number: "
1380     LENGTH=0:COUNT=0:SLET$="":BM=133
1390     WHILE NOT EOF(2)
1400       AX=ASC(INPUT$(1,#2))
1410       IF AX<32 THEN AX=32
1420       IF AX>131 THEN AX=32
1430       LENGTH=LENGTH+1
1440       LV$=ALPH$(AX-32,1)
1450       RN1$=INPUT$(1,#3)
1460       RN2$=INPUT$(1,#3):COUNT=COUNT+2
1470       IF COUNT MOD 2600=0 THEN CLOSE 3:OPEN "I",3,"D:NUMS.TMP":COUNT=0
1480       CD1=VAL(LEFT$(LV$,1))+VAL(RN1$):IF CD1>9 THEN CD1=CD1-10
1490       CD2=VAL(RIGHT$(LV$,1))+VAL(RN2$):IF CD2>9 THEN CD2=CD2-10
1500       CD=CD2*10+CD1:SLET$=""
1510       IF CD<100 THEN SLET$=ALPH$(CD,0)
1520       IF LENGTH MOD 5=0 THEN SLET$=SLET$+CHR$(BM):BM=BM+1
1530       IF BM=138 THEN BM=133
1540       PRINT#1,SLET$;
1550       LOCATE 18,21:PRINT LENGTH;"   "
1560     WEND
1570     FOR N=1 TO 5:PRINT#1,CHR$(138);:NEXT N
1580     PRINT#1,CHR$(26):CLOSE
1590     GOSUB 5260:LOCATE 6,3:PRINT"Enciphering finished. Flushing disk..."
1600     LOCATE 18,3:PRINT"Message length: ";LENGTH;" characters"
1610     ER=8:NAME "A:SETNUM" AS "A:SETNUM"
1620     OPEN "R",1,"A:SALFJOIN",200
1630     FIELD#1,200 AS DSA$
1640     LSET DSA$=STRING$(200,0):PUT#1,GETNUM+1
1650     CLOSE
1660     OPEN "R",1,"A:SNUMJOIN",130
1670     FIELD#1,130 AS DSN$
1680     FOR N=1 TO 20:LSET DSN$=STRING$(130,0):PUT#1,(GETNUM*20)+N:NEXT N
1690     CLOSE
1700     KILL "D:*.TMP"
1710     GETNUM=GETNUM+1
1720     OPEN "O",1,"A:SETNUM":PRINT#1,GETNUM:CLOSE
1730     M=0
1740   WEND
1750 :
1760 REM **** Decipher ****
1770   WHILE M=5
1780     GOSUB 5260:BEEP:LOCATE 2,3:PRINT "DECIPHER A MESSAGE"
1790     LOCATE 4,3:COLOR 0,15:PRINT"** Ensure 'RECEIVE' data disk is in drive A **":COLOR 15,0
1800     LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
1810     CNT$=INKEY$:IF CNT$="" THEN 1810
1820     IF ASC(CNT$)=27 THEN 70
1830     GOSUB 5260
1840     LOCATE 2,3:COLOR 0,15:PRINT "DECIPHER A MESSAGE":COLOR 15,0
1850     ER=9:PRINT:FILES "E:*"
1860     PRINT:PRINT CHR$(186);" Type in name of message to decipher"
1870     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
1880     PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$
1890     IF NM$="" THEN 70
1900     ER=99:NAME "E:"+NM$ AS "E:"+NM$
1910     GOSUB 5260:LOCATE 6,3:PRINT"Deciphering. Please wait..."
1920     SC=0:N=0
1930     OPEN "I",1,"E:"+NM$
1940     IP$=INPUT$(1,#1)
1950     IF SC=0 AND ASC(IP$)<>132 THEN 1940
1960     IF ASC(IP$)<32 OR ASC(IP$)>132 THEN 1940
1970     IF ASC(IP$)=132 THEN SC=SC+1:GOTO 1940
1980     IF ASC(IP$)>31 AND ASC(IP$)<132 AND SC>=2 THEN DNO=ASC(IP$)-32
1990     CLOSE
2000     ER=10:OPEN "I",1,"A:RDNO":INPUT#1,DX$:CLOSE
2010     WHILE DNO<>N
2020       N=N+1
2030       IF VAL(MID$(DX$,N*2-1,2))=DNO THEN DNO=N
2040     WEND
2050     OPEN "O",1,"D:DALFA.TMP"
2060     OPEN "R",2,"A:RALFJOIN",100
2070     FIELD#2,100 AS FRA$
2080     GET#2,DNO
2090     RA$=FRA$
2100     PRINT#1,RA$:CLOSE
2110     OPEN "O",1,"D:DNUMS.TMP"
2120     OPEN "R",2,"A:RNUMJOIN",130
2130     FIELD#2,130 AS FRN$
2140     FOR N=1 TO 20:GET#2,((DNO-1)*20)+N:RN$(N)=FRN$:NEXT N
2150     FOR P=1 TO 20:PRINT#1,RN$(P);:NEXT P
2160     CLOSE
2170     OPEN "I",1,"D:DALFA.TMP"
2180     FOR DBET=0 TO 99
2190       DALPH$(DBET)=INPUT(1,#1)
2200     NEXT DBET
2210     CLOSE
2220     OPEN "I",1,"E:"+NM$
2230     IF INSTR(NM$,".enc") OR INSTR(NM$,".ENC") THEN NM$=LEFT$(NM$,LEN(NM$)-4)
2240     OPEN "O",2,"E:"+NM$+".DEC"
2250     OPEN "I",3,"D:DNUMS.TMP"
2260     GOSUB 5260:LOCATE 2,3:PRINT"Message reads:"
2270     SC=0:CH=0:EC=0:R=4:C=3:CT=0:CK=0:BX=1
2280     DIP$=INPUT$(1,#1)
2290     IF SC=0 AND ASC(DIP$)<>132 THEN 2280
2300     IF ASC(DIP$)=132 THEN SC=SC+1:GOTO 2280
2310     WHILE EC<3
2320       IF BX=6 THEN BX=1
2330       IP$=INPUT$(1,#1)
2340       IF ASC(IP$)<32 AND ASC(IP$)>138 THEN 2330
2350       IF ASC(IP$)=138 THEN EC=EC+1:GOTO 2630
2360       D=ASC(IP$)-32
2370       IF D>100 AND D<106 THEN BM=D-100:CK=1
2380       WHILE CK
2390         IF CH=5 AND BM=BX THEN BX=BX+1:CH=0:CK=0:GOTO 2320
2400         IF CH=5 AND BM<>BX THEN BX=BX+1:CH=0
2410         IF BX=6 THEN BX=1
2420         IF CH<5 THEN D=99:GOTO 2450
2430       WEND
2440       IF CH=5 THEN CH=0:BX=BX+1
2450       DNR$=STR$(D):IF D<10 THEN DNR$="0"+DNR$
2460       D2$=MID$(DNR$,2,1):D1$=RIGHT$(DNR$,1)
2470       SUBT1$=INPUT$(1,#3):CT=CT+1
2480       IF VAL(D1$)<VAL(SUBT1$) THEN D1$=STR$(VAL(D1$)+10)
2490       DNUM1$=STR$(VAL(D1$)-VAL(SUBT1$))
2500       SUBT2$=INPUT$(1,#3):CT=CT+1
2510       IF CT MOD 2600=0 THEN CLOSE 3:OPEN "I",3,"D:DNUMS.TMP":CT=0
2520       IF VAL(D2$)<VAL(SUBT2$) THEN D2$=STR$(VAL(D2$)+10)
2530       DNUM2$=STR$(VAL(D2$)-VAL(SUBT2$))
2540       DNUM$=DNUM1$+DNUM2$
2550       DNUM=VAL(DNUM$)
2560       PLAIN$=DALPH$(DNUM)
2570       IF CK THEN PLAIN$="?"
2580       LOCATE R,C:PRINT PLAIN$;:PRINT#2,PLAIN$;
2590       C=C+1:CH=CH+1
2600       IF C=79 THEN C=3:R=R+1
2610       IF R=20 THEN R=4
2620       IF CK THEN 2380
2630     WEND
2640     CLOSE
2650     LOCATE 20,1:PRINT CHR$(204):LOCATE 20,2:PRINT BDR$:LOCATE 20,80:PRINT CHR$(185)
2660     LOCATE 21,3:PRINT"This message is in memory. It can be read in the editor, printed and saved"
2670     LOCATE 22,3:PRINT"Press ESCape to redo or any other key to clear screen and flush disk"
2680     CNT$=INKEY$:IF CNT$="" THEN 2680
2690     IF ASC(CNT$)=27 THEN CLOSE:GOTO 30
2700     GOSUB 5260:LOCATE 6,3:PRINT"Flushing disk..."
2710     ER=10.1:NAME "A:RALFJOIN" AS "A:RALFJOIN"
2720     OPEN "R",1,"A:RALFJOIN",100
2730     FIELD#1,100 AS DRA$
2740     LSET DRA$=STRING$(100,0):PUT#1,DNO
2750     CLOSE
2760     OPEN "R",1,"A:RNUMJOIN",130
2770     FIELD#1,130 AS DRN$
2780     FOR N=1 TO 20:LSET DRN$=STRING$(130,0):PUT#1,((DNO-1)*20)+N:NEXT N
2790     CLOSE
2800     KILL "D:*.TMP"
2810     M=0
2820   WEND
2830 :
2840 REM **** Type a new message ****
2850   WHILE M=6
2860     GOSUB 5260:BEEP:LOCATE 2,3:COLOR 0,15:PRINT"TYPE A NEW MESSAGE":COLOR 15,0
2870     LOCATE 4,3:PRINT"Give a name to the message you are about to type"
2880     LOCATE 5,3:PRINT"or press ENTER to return to Main Menu"
2890     LOCATE 7,3:PRINT"The name you give must:"
2900     LOCATE 9,3:PRINT"- only contain alphabet keys"
2910     LOCATE 10,3:PRINT"- not be longer than 8 characters"
2920     LOCATE 11,3:PRINT"- not contain spaces"
2930     LOCATE 12,3:PRINT"- not have an extension"
2940     ER=12:LOCATE 14,3:INPUT "Message name: ",NM$
2950     IF NM$="" THEN 70
2960     NAME "E:"+NM$ AS "E:"+NM$
2970     IF ASC(LEFT$(NM$,1))>47 AND ASC(LEFT$(NM$,1))<58 THEN BF=4:GOTO 4250
2980     IF INSTR(NM$," ") THEN BF=1:GOTO 4250
2990     IF INSTR(NM$,".") THEN BF=2:GOTO 4250
3000     IF LEN(NM$)>8 THEN BF=3:GOTO 4250
3010     M=20
3020   WEND
3030 :
3040 REM **** Edit a message in memory ****
3050   WHILE M=7
3060     GOSUB 5260:BEEP:LOCATE 2,3:COLOR 0,15:PRINT"EDIT/READ A MESSAGE IN MEMORY":COLOR 15,0
3070     ER=13:PRINT:FILES "E:*.*"
3080     PRINT:PRINT CHR$(186);" Type in name of message to edit or read"
3090     PRINT:PRINT CHR$(186);" or ENTER to return to Main Menu"
3100     PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$
3110     IF NM$="" THEN 70
3120     NAME "E:"+NM$ AS "E:"+NM$
3130     M=20
3140   WEND
3150 :
3160 REM **** Message editor ****
3170   WHILE M=20
3180     ER=14:SHELL "EDIT E:"+NM$
3190     M=0
3200   WEND
3210 :
3220 REM **** Print file ****
3230   WHILE M=8
3240     GOSUB 5260:WIDTH "LPT1:",75:LOCATE 2,3:COLOR 0,15:PRINT"PRINT A FILE":COLOR 15,0
3250     ER=15:PRINT:FILES "E:*.*"
3260     PRINT:PRINT CHR$(186);" Type in name of file to print"
3270     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
3280     PRINT:PRINT CHR$(186);:PRINT" Message name: ":NM$="!?>":UP=0
3290     WHILE NM$<>""
3300       V=CSRLIN-UP:LOCATE V-1,15:PRINT SPC(15):LOCATE V-1,15:INPUT": ",NM$
3310       IF NM$="" THEN 70
3320       ER=16:NAME "E:"+NM$ AS "E:"+NM$
3330       LPRINT CHR$(27);CHR$(64)
3340       P$="TYPE E:"+NM$+" > prn"
3350       SHELL P$
3360       LPRINT CHR$(12)
3370       UP=1:VD=CSRLIN-1:LOCATE VD,1:PRINT CHR$(186)
3380     WEND
3390   WEND
3400 :
3410 REM **** Tape ****
3420   WHILE M=9
3430     GOSUB 5260:LOCATE 5,31:COLOR 0,15:PRINT"TAPE RECORDER MENU":COLOR 15,0
3440     LOCATE 10,29:PRINT"S   : Save on tape"
3450     LOCATE 12,29:PRINT"R   : Receive from tape"
3460     LOCATE 14,29:PRINT"ESC : Return to Main Menu"
3470     ESAU$=INKEY$:IF ESAU$="" THEN 3470
3480     IF ASC(ESAU$)=27 THEN 70
3490     IF ESAU$<>"R" AND ESAU$="r" AND ESAU$<>"S" AND ESAU$="s" THEN 3470
3500     WHILE ESAU$="s" OR ESAU$="S"
3510       GOSUB 5260:LOCATE 2,3:COLOR 0,15:PRINT"SAVE AN ENCIPHERED MESSAGE ON TAPE":COLOR 15,0
3520       ER=17:PRINT:FILES "E:*.ENC"
3530       PRINT:PRINT CHR$(186);" Type in name of enciphered message to save on tape"
3540       PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
3550       PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$
3560       IF NM$="" THEN 70
3570       ER=18:NAME "E:"+NM$ AS "E:"+NM$
3580       GOSUB 5260:BEEP:LOCATE 2,3:COLOR 0,15:PRINT"** Ensure modem is on and connected to recorder properly **":COLOR 15,0
3590       LOCATE 4,3:PRINT"Press PLAY and RECORD on tape recorder"
3600       LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
3610       CNT$=INKEY$:IF CNT$="" THEN 3610
3620       IF ASC(CNT$)=27 THEN ESAU$="":GOTO 70
3630       GOSUB 5260:LOCATE 6,3:PRINT"Saving to tape..."
3640       LATER=TIMER+5
3650       WHILE TIMER<LATER
3660       WEND
3670       ER=19:OPEN "COM1:300,N,8,1,CS,DS,CD" AS #1
3680       OPEN "I",2,"E:"+NM$
3690       WHILE NOT EOF (2)
3700         TAPNM$=INPUT$(1,#2):PRINT#1,TAPNM$;
3710       WEND
3720       CLOSE:GOTO 70
3730     WEND
3740     WHILE ESAU$="r" OR ESAU$="R"
3750       GOSUB 5260:LOCATE 2,3:COLOR 0,15:PRINT"RECEIVE AN ENCIPHERED MESSAGE FROM TAPE":COLOR 15,0
3760       LOCATE 4,3:PRINT"Give a name to the message to be received from tape"
3770       LOCATE 5,3:PRINT"or press ENTER to return to Main Menu"
3780       LOCATE 7,3:PRINT"The name you give must:"
3790       LOCATE 9,3:PRINT"- only contain alphabet keys"
3800       LOCATE 10,3:PRINT"- not be longer than 8 characters"
3810       LOCATE 11,3:PRINT"- not contain spaces"
3820       LOCATE 12,3:PRINT"- not have an extension"
3830       LOCATE 14,3:INPUT"Message name: ",NM$
3840       IF NM$="" THEN 70
3850       IF ASC(LEFT$(NM$,1))>47 AND ASC(LEFT$(NM$,1))<58 THEN BF=4:GOTO 4250
3860       IF INSTR(NM$," ") THEN BF=1:GOTO 4250
3870       IF INSTR(NM$,".") THEN BF=2:GOTO 4250
3880       IF LEN(NM$)>8 THEN BF=3:GOTO 4250
3890       GOSUB 5260:BEEP:LOCATE 2,3:COLOR 0,15:PRINT"** Ensure modem is on and connected to recorder properly **":COLOR 15,0
3900       LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
3910       CNT$=INKEY$:IF CNT$="" THEN 3910
3920       IF ASC(CNT$)=27 THEN 70
3930       GOSUB 5250:BEEP:LOCATE 2,3:COLOR 0,15:PRINT"Press PLAY on recorder to transfer '";NM$;"'":COLOR 15,0
3940       ER=20:EC=0:C=3:R=4
3950       OPEN "COM1:300,N,8,1,CS,DS,CD" AS #1
3960       OPEN "O",2,"E:"+NM$
3970       WHILE EC<=3
3980         BIT$=INPUT$(1,#1)
3990         IF ASC(BIT$)=138 THEN EC=EC+1
4000         LOCATE R,C:PRINT BIT$;:PRINT#2,BIT$;:C=C+1
4010         IF C=79 THEN C=3:R=R+1
4020         IF R=20 THEN R=4
4030       WEND
4040       PRINT#2,CHR$(13):CLOSE
4050       LOCATE 20,1:PRINT CHR$(204):LOCATE 20,2:PRINT BDR$:LOCATE 20,80:PRINT CHR$(185)
4060       LOCATE 21,3:PRINT"This message is in memory. It can now be deciphered"
4070       LOCATE 22,3:PRINT"Press ESCape to redo or any other key to clear screen"
4080       CNT$=INKEY$:IF CNT$="" THEN 4080
4090       IF ASC(CNT$)=27 THEN 3930
4100       GOTO 70
4110     WEND
4120   WEND
4130 :
4140 REM **** Quit ****
4150   WHILE M=10
4160     GOSUB 5260:LOCATE 6,23:BEEP:COLOR 0,15:PRINT"** Are you sure you want to quit? **":COLOR 15,0
4170     LOCATE 8,20:PRINT"Type Y to quit or N to return to Main Menu"
4180     QUIT$=INKEY$:IF QUIT$="" THEN 4180
4190     IF QUIT$="y" OR QUIT$="Y" THEN SYSTEM
4200     IF QUIT$<>"Y" OR QUIT$<>"y" THEN M=0
4210   WEND
4220 :
4230 WEND
4240 :
4250 REM **** Errors ****
4260 GOSUB 5260:SOUND 88,8:LOCATE 2,3:COLOR 0,15
4270 IF BF=0 THEN PRINT"** You pressed the wrong key **"
4280 IF BF=1 OR BF=7 THEN PRINT"** No spaces allowed in name **"
4290 IF BF=2 OR BF=8 THEN PRINT"** No extensions allowed in name **"
4300 IF BF=3 OR BF=9 THEN PRINT"** Name too long **"
4310 IF BF=4 OR BF=10 THEN PRINT"** Numbers not allowed in name **"
4320 IF BF=5 THEN PRINT"** All data on this disk used. Start a new 'DATA' disk **"
4330 IF BF=6 THEN PRINT"** '";NM$;"' does not exist or may not be edited **"
4340 COLOR 15,0
4350 LOCATE 4,3:PRINT"Try again"
4360 LOCATE 21,3:PRINT"Press a key to continue. ESCape to return to Main Menu"
4370 CNT$=INKEY$:IF CNT$="" THEN 4370
4380 IF ASC(CNT$)=27 THEN GOTO 70
4390 IF BF=0 THEN 70
4400 IF BF=1 THEN 2910
4410 IF BF=2 THEN 2910
4420 IF BF=3 THEN 2910
4430 IF BF=4 THEN 2910
4440 IF BF=5 THEN 70
4450 IF BF=6 THEN 3160
4460 IF BF=7 THEN 3750
4470 IF BF=8 THEN 3750
4480 IF BF=9 THEN 3750
4490 IF BF=10 THEN 3750
4500 :
4510 REM **** Error Messages ****
4520 IF ERR=58 THEN RESUME NEXT
4530 IF ER=12 OR ER=13 AND ERR=53 THEN RESUME NEXT
4540 GOSUB 5260:SOUND 88,8:LOCATE 2,3:COLOR 0,15
4550 IF ERR=53 AND ER=0 THEN PRINT"** There are no files on this disk to load **"
4560 IF ERR=71 THEN PRINT"** Disk not in drive or door open **"
4570 IF ERR=53 AND ER=1 THEN PRINT"** There is no file '";NM$;"' to load from this disk **"
4580 IF ERR=53 AND ER=2 THEN PRINT"** There are no files in memory to save **"
4590 IF ERR=53 AND ER=3 THEN PRINT"** There is no file '";NM$;"' in memory to save **"
4600 IF ERR=53 AND ER=4 THEN PRINT"** There are no files on this disk to delete **"
4610 IF ERR=53 AND ER=5 THEN PRINT"** There is no file '";NM$;"' to delete on this disk **"
4620 IF ERR=70 AND ER=5 THEN PRINT"** Disk write protected **"
4630 IF ERR=53 AND ER=6 THEN PRINT"** There is no message in memory to encipher! **"
4640 IF ERR=53 AND ER=6.1 THEN PRINT"** There is no file '";NM$"' in memory to encipher! **"
4650 IF ERR=53 AND ER=7 THEN PRINT"** Wrong disk. Place data disk in drive **"
4660 IF ERR=62 AND ER=7 THEN PRINT"** All data on this disk used. Start a new 'DATA' disk **"
4670 IF ERR=53 AND ER=8 THEN PRINT"** Wrong disk. Place data disk in drive **"
4680 IF ERR=70 AND ER=8 THEN PRINT"** Disk write protected. Switch tab to delete numbers **"
4690 IF ERR=53 AND ER=9 THEN PRINT"** There is no file in memory to decipher! **"
4700 IF ERR=5 AND ER=99 THEN PRINT"** You've tried to decipher an un-enciphered message! **":M=5.1
4710 IF ERR=62 AND ER=99 THEN PRINT"** You've tried to decipher an un-enciphered message! **"
4720 IF ERR=53 AND ER=99 THEN PRINT"** There is no file '";NM$"' in memory to decipher! **"
4730 IF ERR=62 AND ER=10 THEN PRINT"** Ending missing. Read in editor or print out **"
4740 IF ERR=9 AND ER=10 THEN PRINT"** Bad data. Can't continue. Print out up to here **"
4750 IF ERR=53 AND ER=10 THEN PRINT"** Wrong disk. Place data disk in drive **"
4760 IF ERR=53 AND ER=10.1 THEN PRINT"** Wrong disk. Place data disk in drive **"
4770 IF ERR=70 AND ER=10.1 THEN PRINT"** Disk write protected. Switch tab to delete numbers **"
4780 IF ERR=53 AND ER=11 THEN PRINT"** Wrong disk. Place data disk in drive **"
4790 IF ERR=58 AND ER=12 THEN PRINT"** You've already used '";NM$"'. Use another name **"
4800 IF ERR=13 AND ER=12 THEN PRINT"** No numbers allowed in name **"
4810 IF ERR=53 AND ER=13 THEN PRINT"** There is no message in memory to edit! **"
4820 IF ERR=53 AND ER=14 THEN PRINT"** Program disk not in drive C **"
4830 IF ERR=71 AND ER=14 THEN PRINT"** Program disk not in drive C **"
4840 IF ERR=24 AND ER=15 THEN PRINT"** Printer off line or not connected **"
4850 IF ERR=53 AND ER=15 THEN PRINT"** There are no messages in memory to print out **"
4860 IF ERR=53 AND ER=16 THEN PRINT"** There is no message '";NM$;"' to print out **"
4870 IF ERR=25 THEN PRINT"** Printer off or not connected **"
4880 IF ERR=27 THEN PRINT"** Printer off or not connected or out of paper **"
4890 IF ERR=53 AND ER=17 THEN PRINT"** There are no messages in memory to save on tape **"
4900 IF ERR=53 AND ER=18 THEN PRINT"** There is no message '";NM$;"' to save on tape **"
4910 IF ERR=57 AND ER=20 THEN PRINT"** Signal corrupted or volume incorrect **"
4920 COLOR 15,0
4930 LOCATE 4,3:PRINT"Try again"
4940 LOCATE 21,3:PRINT"Press a key to continue. ESCape to return to Main Menu"
4950 CNT$=INKEY$:IF CNT$="" THEN 4950
4960 IF ASC(CNT$)=27 THEN CLOSE:GOTO 30
4970 IF ER=0 THEN RESUME 360                           'load 1
4980 IF ER=1 THEN RESUME 360                           'load 2
4990 IF ER=2 THEN RESUME 30                            'save 1
5000 IF ER=3 THEN RESUME 570                           'save 2
5010 IF ER=4 THEN RESUME 30                            'delete 1
5020 IF ER=5 THEN RESUME 810                           'delete 2
5030 IF ER=6 THEN RESUME 30                            'encipher 1
5040 IF ER=6.1 THEN RESUME 1010                        'encipher 2
5050 IF ER=7 AND ERR=62 THEN RESUME 30                 'encipher 3
5060 IF ER=7 THEN RESUME 1090                          'encipher 4
5070 IF ER=8 THEN RESUME 1590                          'encipher 5
5080 IF ER=9 THEN RESUME 30                            'decipher 1
5090 IF ER=99 THEN CLOSE:RESUME 1830                   'decipher 2
5100 IF ER=10 AND ERR=9 THEN CLOSE:RESUME 30           'decipher 3
5110 IF ER=10 AND ERR=62 THEN CLOSE:RESUME 30          'decipher 4
5120 IF ER=10 THEN CLOSE:RESUME 1910                   'decipher 5
5130 IF ER=11 THEN RESUME 2700                         'decipher 6
5140 IF ER=12 THEN RESUME 2850                         'new
5150 IF ER=13 THEN RESUME 3050                         'old
5160 IF ER=14 THEN RESUME 3170                         'edit
5170 IF ER=15 THEN RESUME 30                           'print 1
5180 IF ER=16 THEN RESUME 3240                         'print 2
5190 IF ER=17 THEN RESUME 30                           'tape 1
5200 IF ER=18 THEN RESUME 3500                         'tape 2
5210 IF ER=20 THEN CLOSE:RESUME 3930                   'tape 3
5220 IF ERR=64 THEN RESUME NEXT
5230 IF ER<0 OR ER>20 THEN CLOSE:RESUME 30
5240 CLOSE:GOTO 30
5250 :
5260 REM **** border ****
5270 CLS:LOCATE 1,1:PRINT CHR$(201)
5280 BDR$=STRING$(78,205):LOCATE 1,2:PRINT BDR$
5290 LOCATE 1,80:PRINT CHR$(187)
5300 FOR V=2 TO 22:LOCATE V,1:PRINT CHR$(186):LOCATE V,80:PRINT CHR$(186):NEXT V
5310 LOCATE 23,1:PRINT CHR$(200)
5320 LOCATE 23,2:PRINT BDR$
5330 LOCATE 23,80:PRINT CHR$(188)
5340 RETURN
5350 :
5360 OPEN "O",1,"A:SETNUM":PRINT#1,"4":CLOSE
