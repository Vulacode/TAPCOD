10 SHELL "CLS"
20 GOSUB 5520:LOCATE 5,33:PRINT"TAPE CODER"
30 LOCATE 9,27:PRINT"TOSHIBA 1FD version 2.10"
40 LOCATE 11,32:PRINT"one-time coder"
50 LOCATE 13,33:PRINT" April 1988"
60 GOSUB 5620
70 CLEAR:KEY OFF
80 X$="":FOR N=1 TO 10:KEY N,X$:NEXT N
90 DIM ALPH$(100,1),DALPH$(100),SN$(20),RN$(20)
100 :
110 REM **** Main Menu ****
120 M=0:BF=0:ER=-1
130 ON ERROR GOTO 4790
140 WHILE M=0
150   GOSUB 5520:LOCATE 3,35:PRINT"TAPE CODER"
160   LOCATE 5,30:PRINT"Toshiba 1fd Ver.2.10"
170   LOCATE 7,36:PRINT"MAIN MENU"
180   LOCATE 9,24:PRINT"F1  : Load messages from disk"
190   LOCATE 10,24:PRINT"F2  : Save messages onto disk"
200   LOCATE 11,24:PRINT"F3  : Delete messages on disk"
210   LOCATE 13,24:PRINT"F4  : Encipher a message in memory"
220   LOCATE 14,24:PRINT"F5  : Decipher a message in memory"
230   LOCATE 16,24:PRINT"F6  : Type a new message"
240   LOCATE 17,24:PRINT"F7  : Edit/read a message in memory"
250   LOCATE 18,24:PRINT"F8  : Print a file"
260   LOCATE 19,24:PRINT"F9  : Save on/Receive from tape"
270   LOCATE 21,24:PRINT"F10 : Quit"
280   CH$=INKEY$:IF CH$="" THEN 280
290   IF LEN(CH$)=2 THEN CH$=RIGHT$(CH$,1)
300   M=ASC(CH$)-58
310 :
320 REM **** Load a file ****
330   WHILE M=1
340     GOSUB 5520:BEEP:LOCATE 2,3:PRINT"LOAD MESSAGES FROM DISK INTO MEMORY"
350     LOCATE 4,3:PRINT"** Ensure 'MESSAGE' disk is in drive **"
360     LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
370     CNT$=INKEY$:IF CNT$="" THEN 370
380     IF ASC(CNT$)=27 THEN M=0
390     GOSUB 5520:LOCATE 2,3:PRINT"LOAD MESSAGES FROM DISK"
400     ER=0:PRINT:FILES "A:*.*"
410     PRINT:PRINT CHR$(186);" Type in name of message to load"
420     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
430     PRINT:PRINT CHR$(186);:PRINT" Message name: ":NM$="œ$%":UP=0
440     WHILE NM$<>""
450       V=CSRLIN-UP:LOCATE V-1,15:PRINT"                ":LOCATE V-1,15:INPUT": ",NM$
460       IF NM$="" THEN 110
470       ER=1:NAME "A:"+NM$ AS "A:"+NM$
480       L$="COPY A:"+NM$+" E:"
490       SHELL L$
500       UP=2:VD=CSRLIN:LOCATE VD,1:PRINT CHR$(186)
510     WEND
520   WEND
530 :
540 REM **** Save a file ****
550   WHILE M=2
560     GOSUB 5520:BEEP:LOCATE 2,3:PRINT"SAVE MESSAGES IN MEMORY ONTO DISK"
570     LOCATE 4,3:PRINT"** Ensure 'MESSAGE' disk is in drive **"
580     LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
590     CNT$=INKEY$:IF CNT$="" THEN 590
600     IF ASC(CNT$)=27 THEN M=0
610     GOSUB 5520:LOCATE 2,3:PRINT"SAVE MESSAGES IN MEMORY ONTO DISK"
620     ER=2:PRINT:FILES "E:*.*"
630     PRINT:PRINT CHR$(186);" Type in name of message to save"
640     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
650     PRINT:PRINT CHR$(186);:PRINT" Message name: ":NM$="+?,":UP=0
660     WHILE NM$<>""
670       V=CSRLIN-UP:LOCATE V-1,15:PRINT"               ":LOCATE V-1,15:INPUT": ",NM$
680       IF NM$="" THEN 110
690       ER=3:NAME "E:"+NM$ AS "E:"+NM$
700       S$="COPY E:"+NM$+" A:"
710       SHELL S$
720       UP=2:VD=CSRLIN:LOCATE VD,1:PRINT CHR$(186)
730     WEND
740   WEND
750 :
760 REM **** Delete a file ****
770   WHILE M=3
780     GOSUB 5520:BEEP:LOCATE 2,3:PRINT"DELETE MESSAGES ON DISK"
790     LOCATE 4,3:PRINT"** Ensure 'MESSAGE' disk is in drive **"
800     LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
810     CNT$=INKEY$:IF CNT$="" THEN 810
820     IF ASC(CNT$)=27 THEN M=0 ELSE M=3.1
830     WHILE M=3.1
840       GOSUB 5520
850       LOCATE 2,3:PRINT"DELETE MESSAGES ON DISK"
860       ER=4:PRINT:FILES "A:*.*"
870       PRINT:PRINT CHR$(186);" Type in name of message to delete"
880       PRINT:PRINT CHR$(186);" or ENTER to return to Main Menu"
890       PRINT:PRINT CHR$(186);:INPUT " Message name: ",NM$
900       IF NM$="" THEN 110
910      ER=5:NAME "A:"+NM$ AS "A:"+NM$
920      KILL "A:"+NM$
930     WEND
940   WEND
950 :
960 REM **** Encipher ****
970   WHILE M=4
980     GOSUB 5520:BEEP:LOCATE 2,3:PRINT "ENCIPHER A MESSAGE"
990     LOCATE 4,3:PRINT"** Ensure data disk is in drive **"
1000     LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
1010     CNT$=INKEY$:IF CNT$="" THEN 1010
1020     IF ASC(CNT$)=27 THEN M=0 ELSE M=4.1
1030     WHILE M=4.1
1040       GOSUB 5520
1050       LOCATE 2,3:PRINT "ENCIPHER A MESSAGE"
1060       ER=6:PRINT:FILES "E:*"
1070       PRINT:PRINT CHR$(186);" Type in name of message to encipher"
1080       PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
1090       PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$
1100       IF NM$="" THEN 110
1110       ER=6.1:NAME "E:"+NM$ AS "E:"+NM$
1120       M=4.2
1130       WHILE M=4.2
1140         CLS:GOSUB 5520:LOCATE 6,3:PRINT"Enciphering. Please wait..."
1150         ER=7:OPEN "I",1,"A:SETNUM":INPUT#1,GETNUM:CLOSE 1
1160         IF GETNUM>99 THEN BF=5:GOTO 4540
1170         LOCATE 18,2:PRINT 99-GETNUM;" sets of numbers left"
1180         OPEN "I",1,"A:SDNO":INPUT#1,DINOS$:CLOSE 1
1190         DNO=VAL(MID$(DINOS$,GETNUM*2+1,2))
1200         OPEN "O",1,"D:ALFA.TMP"
1210         OPEN "R",2,"A:SALFJOIN",200
1220         FIELD#2,200 AS FSA$
1230         GET#2,GETNUM+1
1240         SA$=FSA$
1250         PRINT#1,SA$:CLOSE
1260         OPEN "O",1,"D:NUMS.TMP"
1270         OPEN "R",2,"A:SNUMJOIN",130
1280         FIELD#2,130 AS FSN$
1290         FOR N=1 TO 20:GET#2,(GETNUM*20)+N:SN$(N)=FSN$:NEXT N
1300         FOR P=1 TO 20:PRINT#1,SN$(P);:NEXT P
1310         CLOSE
1320         OPEN "I",1,"D:ALFABET"
1330         OPEN "I",2,"D:ALFA.TMP"
1340         OPEN "I",3,"D:NUMS.TMP"
1350         FOR BET = 0 TO 99
1360           ALPH$(BET,0)=INPUT$(1,#1)
1370           VL1$=INPUT$(1,#2)
1380           VL2$=INPUT$(1,#2)
1390           ALPH$(BET,1)=VL1$+VL2$
1400         NEXT BET
1410         CLOSE 1:CLOSE 2
1420         OPEN "O",1,"E:"+NM$+".ENC"
1430         OPEN "I",2,"E:"+NM$
1440         DNO$=ALPH$(DNO,0):RANDOMIZE TIMER
1450         AGNO$=CHR$(INT(33+(20*RND)))
1460         FOR N=1 TO 5:PRINT#1,AGNO$;:NEXT N
1470         FOR N=1 TO 4:PRINT#1,CHR$(133);:NEXT N:PRINT#1,DNO$;
1480         LOCATE 18,3:PRINT"Character number: "
1490         LENGTH=0:COUNT=1:SLET$=""
1500         WHILE NOT EOF(2)
1510           AX=ASC(INPUT$(1,#2))
1520           IF AX<32 THEN AX=32
1530           IF AX>131 THEN AX=32
1540           LENGTH=LENGTH+1
1550           LV$=ALPH$(AX-32,1)
1560           RN1$=INPUT$(1,#3):COUNT=COUNT+1
1570           RN2$=INPUT$(1,#3):COUNT=COUNT+1
1580           IF COUNT MOD 2601=0 THEN CLOSE 3:OPEN "I",3,"D:NUMS.TMP":COUNT=1
1590           CD1=VAL(LEFT$(LV$,1))+VAL(RN1$):IF CD1>9 THEN CD1=CD1-10
1600           CD2=VAL(RIGHT$(LV$,1))+VAL(RN2$):IF CD2>9 THEN CD2=CD2-10
1610           CD=CD2*10+CD1:SLET$=""
1620           IF CD<100 THEN SLET$=ALPH$(CD,0)
1630           IF LENGTH MOD 5=0 THEN SLET$=SLET$+CHR$(132)
1640           PRINT#1,SLET$;
1650           LOCATE 18,21:PRINT LENGTH;"   "
1660         WEND
1670         FOR N=1 TO 4:PRINT#1,CHR$(134);:NEXT N
1680         PRINT#1,CHR$(13):CLOSE
1690         ER=8:NAME "A:SETNUM" AS "A:SETNUM"
1700         GOSUB 5520:LOCATE 6,3:PRINT"Enciphering finished. Flushing disk..."
1710         LOCATE 18,3:PRINT"Message length: ";LENGTH;" characters"
1720         OPEN "R",1,"A:SALFJOIN",200
1730         FIELD#1,200 AS DSA$
1740         LSET DSA$=STRING$(200,0):PUT#1,GETNUM+1
1750         CLOSE
1760         OPEN "R",1,"A:SNUMJOIN",130
1770         FIELD#1,130 AS DSN$
1780         FOR N=1 TO 20:LSET DSN$=STRING$(130,0):PUT#1,(GETNUM*20)+N:NEXT N
1790         CLOSE
1800         KILL "D:*.TMP"
1810         GETNUM=GETNUM+1
1820         OPEN "O",1,"A:SETNUM":PRINT#1,GETNUM:CLOSE
1830         GOTO 110
1840       WEND
1850     WEND
1860   WEND
1870 :
1880 REM **** Decipher ****
1890   WHILE M=5
1900     GOSUB 5520:BEEP:LOCATE 2,3:PRINT "DECIPHER A MESSAGE"
1910     LOCATE 4,3:PRINT"** Ensure data disk is in drive **"
1920     LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
1930     CNT$=INKEY$:IF CNT$="" THEN 1930
1940     IF ASC(CNT$)=27 THEN M=0 ELSE M=5.1
1950     WHILE M=5.1
1960       GOSUB 5520
1970       LOCATE 2,3:PRINT "DECIPHER A MESSAGE"
1980       ER=9:PRINT:FILES "E:*"
1990       PRINT:PRINT CHR$(186);" Type in name of message to decipher"
2000       PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
2010       PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$
2020       IF NM$="" THEN 110
2030       ER=99:NAME "E:"+NM$ AS "E:"+NM$
2040       M=5.2
2050       WHILE M=5.2
2060         GOSUB 5520:LOCATE 6,3:PRINT"Deciphering. Please wait..."
2070         SC=0
2080         OPEN "I",1,"E:"+NM$
2090         IP$=INPUT$(1,#1)
2100         IF SC=0 AND ASC(IP$)<>133 THEN 2090
2110         IF ASC(IP$)<32 OR ASC(IP$)>133 THEN 2090
2120         IF ASC(IP$)=133 THEN SC=SC+1:GOTO 2090
2130         IF ASC(IP$)>31 AND ASC(IP$)<133 AND SC>=2 THEN DECNO$=IP$
2140         CLOSE
2150         DNO=ASC(DECNO$)-32:N=0
2160         ER=10:OPEN "I",1,"A:RDNO":INPUT#1,DX$:CLOSE
2170         WHILE DNO<>N
2180           N=N+1
2190           IF VAL(MID$(DX$,N*2-1,2))=DNO THEN DNO=N
2200         WEND
2210         OPEN "O",1,"D:DALFA.TMP"
2220         OPEN "R",2,"A:RALFJOIN",100
2230         FIELD#2,100 AS FRA$
2240         GET#2,DNO
2250         RA$=FRA$
2260         PRINT#1,RA$:CLOSE
2270         OPEN "O",1,"D:DNUMS.TMP"
2280         OPEN "R",2,"A:RNUMJOIN",130
2290         FIELD#2,130 AS FRN$
2300         FOR N=1 TO 20:GET#2,((DNO-1)*20)+N:RN$(N)=FRN$:NEXT N
2310         FOR P=1 TO 20:PRINT#1,RN$(P);:NEXT P
2320         CLOSE
2330         OPEN "I",1,"E:"+NM$
2340         OPEN "I",2,"D:DALFA.TMP"
2350         OPEN "I",3,"D:DNUMS.TMP"
2360         FOR DBET=0 TO 99
2370           LT$=INPUT$(1,#2)
2380           DALPH$(DBET)=LT$
2390         NEXT DBET
2400         CLOSE 2
2410         IF INSTR(NM$,".enc") OR INSTR(NM$,".ENC") THEN NM$=LEFT$(NM$,LEN(NM$)-4)
2420         OPEN "O",2,"E:"+NM$+".DEC"
2430         GOSUB 5520:LOCATE 2,3:PRINT"Message reads:"
2440         SC=0:DN=0:CT=0:EC=0:R=4:C=3:COUNT=1:CHEKKA=0:STP=0
2450         WHILE EC<=3
2460           IP$=INPUT$(1,#1)
2470           IF SC=0 AND ASC(IP$)<>133 THEN 2460
2480           IF ASC(IP$)=133 AND DN=0 THEN SC=SC+1
2490           IF ASC(IP$)>31 AND ASC(IP$)<133 AND DN=0 AND SC>=2 THEN DN=DN+1:GOTO 2460
2500           IF ASC(IP$)=134 AND DN>0 THEN EC=EC+1
2510           WHILE ASC(IP$)>31 AND ASC(IP$)<133 AND SC>=2 AND DN>0
2520             D=ASC(IP$)-32
2530             IF D=100 THEN CHEKKA=1:GOTO 2550
2540             IF CT=5 THEN CT=0:GOTO 2460
2550             WHILE CHEKKA
2560               IF CT=5 THEN CT=0:CHEKKA=0:GOTO 2460
2570               IF CT<5 THEN D=99:GOTO 2590
2580             WEND
2590             DNR$=STR$(D):IF D<10 THEN DNR$="0"+DNR$
2600             D2$=MID$(DNR$,2,1):D1$=RIGHT$(DNR$,1)
2610             SUBT1$=INPUT$(1,#3):COUNT=COUNT+1
2620             IF VAL(D1$)<VAL(SUBT1$) THEN D1$=STR$(VAL(D1$)+10)
2630             DNUM1$=STR$(VAL(D1$)-VAL(SUBT1$))
2640             SUBT2$=INPUT$(1,#3):COUNT=COUNT+1
2650             IF COUNT MOD 2601=0 THEN CLOSE 3:OPEN "I",3,"D:DNUMS.TMP":COUNT=1
2660             IF VAL(D2$)<VAL(SUBT2$) THEN D2$=STR$(VAL(D2$)+10)
2670             DNUM2$=STR$(VAL(D2$)-VAL(SUBT2$))
2680             DNUM$=DNUM1$+DNUM2$
2690             DNUM=VAL(DNUM$)
2700             PLAIN$=DALPH$(DNUM)
2710             LOCATE R,C:PRINT PLAIN$;:PRINT#2,PLAIN$;
2720             C=C+1:CT=CT+1
2730             IF C=79 THEN C=3:R=R+1
2740             IF R=20 THEN R=4
2750             IF CHEKKA THEN 2560
2760             GOTO 2460
2770           WEND
2780         WEND
2790         CLOSE
2800         LOCATE 20,1:PRINT CHR$(204):LOCATE 20,2:PRINT BDR$:LOCATE 20,80:PRINT CHR$(185)
2810         LOCATE 21,3:PRINT"This message is in memory. It can be printed out and saved on disk."
2820         LOCATE 22,3:PRINT"Press ESCape to redo or any other key to clear screen and flush disk"
2830         CNT$=INKEY$:IF CNT$="" THEN 2830
2840         IF ASC(CNT$)=27 THEN CLOSE:GOTO 60
2850         ER=10.1:NAME "A:RALFJOIN" AS "A:RALFJOIN"
2860         GOSUB 5520:LOCATE 6,3:PRINT"Flushing disk..."
2870         OPEN "R",1,"A:RALFJOIN",100
2880         FIELD#1,100 AS DRA$
2890         LSET DRA$=STRING$(100,0):PUT#1,DNO
2900         CLOSE
2910         OPEN "R",1,"A:RNUMJOIN",130
2920         FIELD#1,130 AS DRN$
2930         FOR N=1 TO 20:LSET DRN$=STRING$(130,0):PUT#1,((DNO-1)*20)+N:NEXT N
2940         CLOSE
2950         KILL "D:*.TMP"
2960         GOTO 110
2970       WEND
2980     WEND
2990   WEND
3000 :
3010 REM **** Type a new message ****
3020   WHILE M=6
3030     GOSUB 5520:BEEP:LOCATE 2,3:PRINT"TYPE A NEW MESSAGE"
3040     LOCATE 4,3:PRINT"** Ensure program disk is in drive **"
3050     LOCATE 20,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
3060     CNT$=INKEY$:IF CNT$="" THEN 3060
3070     IF ASC(CNT$)=27 THEN 110
3080     GOSUB 5520:LOCATE 2,3:PRINT"TYPE A NEW MESSAGE"
3090     LOCATE 4,3:PRINT"Give a name to the message you are about to type"
3100     LOCATE 5,3:PRINT"or press ENTER to return to Main Menu"
3110     LOCATE 7,3:PRINT"The name you give must:"
3120     LOCATE 9,3:PRINT"- only contain alphabet keys"
3130     LOCATE 10,3:PRINT"- not be longer than 8 characters"
3140     LOCATE 11,3:PRINT"- not contain spaces"
3150     LOCATE 12,3:PRINT"- not have an extension"
3160     ER=12:LOCATE 14,3:INPUT "Message name: ",NM$
3170     IF NM$="" THEN 110
3180     IF ASC(LEFT$(NM$,1))>47 AND ASC(LEFT$(NM$,1))<58 THEN BF=4:GOTO 4540
3190     IF INSTR(NM$," ") THEN BF=1:GOTO 4540
3200     IF INSTR(NM$,".") THEN BF=2:GOTO 4540
3210     IF LEN(NM$)>8 THEN BF=3:GOTO 4540
3220     NAME "E:"+NM$ AS "E:"+NM$
3230     M=20
3240   WEND
3250 :
3260 REM **** Edit a message in memory ****
3270   WHILE M=7
3280     GOSUB 5520:BEEP:LOCATE 2,3:PRINT"EDIT/READ A MESSAGE IN MEMORY"
3290     LOCATE 4,3:PRINT"** Ensure program disk is in drive **"
3300     LOCATE 20,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
3310     CNT$=INKEY$:IF CNT$="" THEN 3310
3320     IF ASC(CNT$)=27 THEN 110
3330     GOSUB 5520:LOCATE 2,3:PRINT"EDIT/READ A MESSAGE IN MEMORY"
3340     ER=13:PRINT:FILES "E:*.*"
3350     PRINT:PRINT CHR$(186);" Type in name of message to edit or read"
3360     PRINT:PRINT CHR$(186);" or ENTER to return to Main Menu"
3370     PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$
3380     IF NM$="" THEN 110
3390     NAME "E:"+NM$ AS "E:"+NM$
3400     M=20
3410   WEND
3420 :
3430 REM **** Message editor ****
3440   WHILE M=20
3450     ER=14:SHELL "EDIT E:"+NM$
3460     M=0
3470   WEND
3480 :
3490 REM **** Print file ****
3500   WHILE M=8
3510     GOSUB 5520:LOCATE 2,3:PRINT"PRINT A FILE"
3520     ER=15:PRINT:FILES "E:*.*"
3530     PRINT:PRINT CHR$(186);" Type in name of file you wish to print"
3540     PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
3550     PRINT:PRINT CHR$(186);:PRINT" Message name: ":NM$="*/A":UP=0
3560     WHILE NM$<>""
3570       V=CSRLIN-UP:LOCATE V-1,15:PRINT"               ":LOCATE V-1,15:INPUT": ",NM$
3580       IF NM$="" THEN 110
3590       ER=16:NAME "E:"+NM$ AS "E:"+NM$
3600       LPRINT CHR$(27);CHR$(64);CHR$(15)
3610       P$="TYPE E:"+NM$+" >prn"
3620       SHELL P$
3630       LPRINT CHR$(18);CHR$(12)
3640       UP=2:VD=CSRLIN:LOCATE VD,1:PRINT CHR$(186)
3650     WEND
3660   WEND
3670 :
3680 REM **** Tape ****
3690   WHILE M=9
3700     GOSUB 5520:LOCATE 5,31:PRINT"TAPE RECORDER MENU"
3710     LOCATE 10,29:PRINT"S   : Save on tape"
3720     LOCATE 12,29:PRINT"R   : Receive from tape"
3730     LOCATE 14,29:PRINT"ESC : Return to Main Menu"
3740     ESAU$=INKEY$:IF ESAU$="" THEN 3740
3750     IF ASC(ESAU$)=27 THEN 110
3760     IF ESAU$<>"R" AND ESAU$="r" AND ESAU$<>"S" AND ESAU$="s" THEN 3740
3770     WHILE ESAU$="s" OR ESAU$="S"
3780       GOSUB 5520:LOCATE 2,3:PRINT"SAVE AN ENCIPHERED MESSAGE ON TAPE"
3790       ER=17:PRINT:FILES "E:*.ENC"
3800       PRINT:PRINT CHR$(186);" Type in name of enciphered message to save on tape"
3810       PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
3820       PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$
3830       IF NM$="" THEN 110
3840       ER=18:NAME "E:"+NM$ AS "E:"+NM$
3850       GOSUB 5520:BEEP:LOCATE 2,3:PRINT"** Ensure modem is on and connected to recorder properly **"
3860       LOCATE 4,3:PRINT"Press PLAY and RECORD on tape recorder"
3870       LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
3880       CNT$=INKEY$:IF CNT$="" THEN 3880
3890       IF ASC(CNT$)=27 THEN ESAU$="":GOTO 110
3900       GOSUB 5520:LOCATE 6,3:PRINT"Saving to tape..."
3910       LATER=TIMER+5
3920       WHILE TIMER<LATER
3930       WEND
3940       ER=19:OPEN "COM1:300,N,8,1,CS,DS,CD" AS #1
3950       OPEN "I",2,"E:"+NM$
3960       WHILE NOT EOF (2)
3970         TAPNM$=INPUT$(1,#2):PRINT#1,TAPNM$;
3980       WEND
3990       CLOSE:GOTO 110
4000     WEND
4010     WHILE ESAU$="r" OR ESAU$="R"
4020       GOSUB 5520:LOCATE 2,3:PRINT"RECEIVE AN ENCIPHERED MESSAGE FROM TAPE"
4030       LOCATE 4,3:PRINT"Give a name to the message to be received from tape"
4040       LOCATE 5,3:PRINT"or press ENTER to return to Main Menu"
4050       LOCATE 7,3:PRINT"The name you give must:"
4060       LOCATE 9,3:PRINT"- only contain alphabet keys"
4070       LOCATE 10,3:PRINT"- not be longer than 8 characters"
4080       LOCATE 11,3:PRINT"- not contain spaces"
4090       LOCATE 12,3:PRINT"- not have an extension"
4100       LOCATE 14,3:INPUT"Message name: ",NM$
4110       IF NM$="" THEN 110
4120       IF ASC(LEFT$(NM$,1))>47 AND ASC(LEFT$(NM$,1))<58 THEN BF=4:GOTO 4540
4130       IF INSTR(NM$," ") THEN BF=1:GOTO 4540
4140       IF INSTR(NM$,".") THEN BF=2:GOTO 4540
4150       IF LEN(NM$)>8 THEN BF=3:GOTO 4540
4160       GOSUB 5520:BEEP:LOCATE 2,3:PRINT"** Ensure modem is on and connected to recorder properly **"
4170       LOCATE 21,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
4180       CNT$=INKEY$:IF CNT$="" THEN 4180
4190       IF ASC(CNT$)=27 THEN 110
4200       GOSUB 5510:BEEP:LOCATE 2,3:PRINT"Press PLAY on recorder to transfer '";NM$;"'"
4210       ER=20:EC=0:C=3:R=4
4220       OPEN "COM1:300,N,8,1,CS,DS,CD" AS #1
4230       OPEN "O",2,"E:"+NM$
4240       WHILE EC<=3
4250         BIT$=INPUT$(1,#1)
4260         IF ASC(BIT$)=134 THEN EC=EC+1
4270         LOCATE R,C:PRINT BIT$;:PRINT#2,BIT$;:C=C+1
4280         IF C=79 THEN C=3:R=R+1
4290         IF R=20 THEN R=4
4300       WEND
4310       PRINT#2,CHR$(13):CLOSE
4320       LOCATE 20,1:PRINT CHR$(204):LOCATE 20,2:PRINT BDR$:LOCATE 20,80:PRINT CHR$(185)
4330       LOCATE 21,3:PRINT"This message is in memory. It can now be deciphered"
4340       LOCATE 22,3:PRINT"Press any key to clear screen"
4350       CNT$=INKEY$:IF CNT$="" THEN 4350
4360       GOTO 110
4370     WEND
4380   WEND
4390 :
4400 REM **** Quit ****
4410   WHILE M=10
4420     GOSUB 5520:LOCATE 6,23:BEEP:PRINT"** Are you sure you want to quit? **"
4430     LOCATE 8,20:PRINT"Type Y to quit or N to return to Main Menu"
4440     QUIT$=INKEY$:IF QUIT$="" THEN 4440
4450     IF QUIT$<>"Y" AND QUIT$<>"y" THEN 70
4460     GOSUB 5520:LOCATE 2,3:BEEP:PRINT"** Ensure program disk is in drive **"
4470     LOCATE 21,3:PRINT"Press any key to continue"
4480     CNT$=INKEY$:IF CNT$="" THEN 4480
4490     IF QUIT$="y" OR QUIT$="Y" THEN SYSTEM
4500   WEND
4510 :
4520 WEND
4530 :
4540 REM **** Errors ****
4550 GOSUB 5520:FOR N=1 TO 3:BEEP:NEXT N:LOCATE 2,3
4560 IF BF=0 THEN PRINT"** You pressed the wrong key **"
4570 IF BF=1 OR BF=7 THEN PRINT"** No spaces allowed in name **"
4580 IF BF=2 OR BF=8 THEN PRINT"** No extensions allowed in name **"
4590 IF BF=3 OR BF=9 THEN PRINT"** Name too long **"
4600 IF BF=4 OR BF=10 THEN PRINT"** Numbers not allowed in name **"
4610 IF BF=5 THEN PRINT"** All the numbers on this disk have been used. Start a new disk **"
4620 IF BF=6 THEN PRINT"** '";NM$;"' does not exist or may not be edited **"
4630 LOCATE 4,3:PRINT"Try again"
4640 LOCATE 21,3:PRINT"Press a key to continue. ESCape to return to Main Menu"
4650 CNT$=INKEY$:IF CNT$="" THEN 4650
4660 IF ASC(CNT$)=27 THEN GOTO 110
4670 IF BF=0 THEN 110
4680 IF BF=1 THEN 3080
4690 IF BF=2 THEN 3080
4700 IF BF=3 THEN 3080
4710 IF BF=4 THEN 3080
4720 IF BF=5 THEN 110
4730 IF BF=6 THEN 3330
4740 IF BF=7 THEN 4020
4750 IF BF=8 THEN 4020
4760 IF BF=9 THEN 4020
4770 IF BF=10 THEN 4020
4780 :
4790 REM **** Error Messages ****
4800 IF ERR=58 THEN RESUME NEXT
4810 IF ER=12 OR ER=13 AND ERR=53 THEN RESUME NEXT
4820 GOSUB 5520:FOR N=1 TO 3:BEEP:NEXT N:LOCATE 2,3
4830 IF ERR=53 AND ER=0 THEN PRINT"** There are no files on this disk to load **"
4840 IF ERR=71 THEN PRINT"** Disk not in drive or door open **"
4850 IF ERR=53 AND ER=1 THEN PRINT"** There is no file '";NM$;"' to load from this disk **"
4860 IF ERR=53 AND ER=2 THEN PRINT"** There are no files in memory to save **"
4870 IF ERR=53 AND ER=3 THEN PRINT"** There is no file '";NM$;"' in memory to save **"
4880 IF ERR=53 AND ER=4 THEN PRINT"** There are no files on this disk to delete **"
4890 IF ERR=53 AND ER=5 THEN PRINT"** There is no file '";NM$;"' to delete on this disk **"
4900 IF ERR=70 AND ER=5 THEN PRINT"** Disk write-protected **"
4910 IF ERR=53 AND ER=6 THEN PRINT"** There is no message in memory to encipher! **"
4920 IF ERR=53 AND ER=6.1 THEN PRINT"** There is no file '";NM$"' in memory to encipher! **"
4930 IF ERR=53 AND ER=7 THEN PRINT"** Wrong disk. Place data disk in drive **"
4940 IF ERR=53 AND ER=8 THEN PRINT"** Wrong disk. Place data disk in drive **"
4950 IF ERR=70 AND ER=8 THEN PRINT"** Disk write protected. Switch tab to delete numbers **"
4960 IF ERR=53 AND ER=9 THEN PRINT"** There is no file in memory to decipher! **"
4970 IF ERR=5 AND ER=99 THEN PRINT"** You've tried to decipher an un-enciphered message! **":M=5.1
4980 IF ERR=62 AND ER=99 THEN PRINT"** You've tried to decipher an un-enciphered message! **"
4990 IF ERR=53 AND ER=99 THEN PRINT"** There is no file '";NM$"' in memory to decipher! **"
5000 IF ERR=62 THEN PRINT"** You've tried to decipher an un-enciphered message! **"
5010 IF ERR=9 AND ER=10 THEN PRINT"** Bad data. Can't continue. Print out up to here **"
5020 IF ERR=53 AND ER=10 THEN PRINT"** Wrong disk. Place data disk in drive **"
5030 IF ERR=62 AND ER=10 THEN PRINT"** Ending missing. Read in editor or print out **"
5040 IF ERR=53 AND ER=10.1 THEN PRINT"** Wrong disk. Place data disk in drive **"
5050 IF ERR=70 AND ER=10.1 THEN PRINT"** Disk write protected. Switch tab to delete numbers **"
5060 IF ERR=53 AND ER=11 THEN PRINT"** Wrong disk. Place data disk in drive **"
5070 IF ERR=58 AND ER=12 THEN PRINT"** You've already used '";NM$"'. Use another name **"
5080 IF ERR=13 AND ER=12 THEN PRINT"** No numbers allowed in name **"
5090 IF ERR=53 AND ER=13 THEN PRINT"** There is no message in memory to edit! **"
5100 IF ERR=53 AND ER=14 THEN PRINT"** Program disk not in drive **"
5110 IF ERR=71 AND ER=14 THEN PRINT"** Program disk not in drive **"
5120 IF ERR=53 AND ER=15 THEN PRINT"** There are no messages in memory to print out **"
5130 IF ERR=53 AND ER=16 THEN PRINT"** There is no message '";NM$;"' to print out **"
5140 IF ERR=25 THEN PRINT"** Printer off or not connected **"
5150 IF ERR=27 THEN PRINT"** Printer off or not connected or out of paper **"
5160 IF ERR=53 AND ER=17 THEN PRINT"** There are no messages in memory to save on tape **"
5170 IF ERR=53 AND ER=18 THEN PRINT"** There is no message '";NM$;"' to save on tape **"
5180 IF ERR=57 AND ER=20 THEN PRINT"** Signal corrupted or volume incorrect **"
5190 LOCATE 4,3:PRINT"Try again"
5200 LOCATE 21,3:PRINT"Press a key to continue. ESCape to return to Main Menu"
5210 CNT$=INKEY$:IF CNT$="" THEN 5210
5220 IF ASC(CNT$)=27 THEN CLOSE:GOTO 70
5230 IF ER=0 THEN RESUME 70                            'load 1
5240 IF ER=1 THEN RESUME 390                           'load 2
5250 IF ER=2 THEN RESUME 70                            'save 1
5260 IF ER=3 THEN RESUME 610                           'save 2
5270 IF ER=4 THEN RESUME 70                            'delete 1
5280 IF ER=5 THEN RESUME 830                           'delete 2
5290 IF ER=6 THEN RESUME 70                            'encipher 1
5300 IF ER=6.1 THEN RESUME 1030                        'encipher 2
5310 IF ER=7 THEN RESUME 1130                          'encipher 3
5320 IF ER=8 THEN RESUME 1700                          'encipher 4
5330 IF ER=9 THEN RESUME 70                            'decipher 1
5340 IF ER=99 THEN CLOSE:RESUME 1960                   'decipher 2
5350 IF ER=10 AND ERR=9 THEN CLOSE:RESUME 70           'decipher 3
5360 IF ER=10 AND ERR=62 THEN CLOSE:RESUME 70          'decipher 4
5370 IF ER=10 THEN CLOSE:RESUME 2050                   'decipher 5
5380 IF ER=10.1 THEN RESUME 2860                       'decipher 6
5390 IF ER=11 THEN RESUME 2860                         'decipher 7
5400 IF ER=12 THEN RESUME 3020                         'new
5410 IF ER=13 THEN RESUME 3270                         'old
5420 IF ER=14 THEN RESUME 3440                         'edit
5430 IF ER=15 THEN RESUME 70                           'print 1
5440 IF ER=16 THEN RESUME 3500                         'print 2
5450 IF ER=17 THEN RESUME 70                           'tape 1
5460 IF ER=18 THEN RESUME 3770                         'tape 2
5470 IF ER=20 THEN CLOSE:RESUME 4200                   'tape 3
5480 IF ERR=64 THEN RESUME NEXT
5490 IF ER<0 OR ER>20 THEN CLOSE:RESUME 70
5500 CLOSE:GOTO 70
5510 :
5520 REM **** border ****
5530 CLS:LOCATE 1,1:PRINT CHR$(201)
5540 BDR$=STRING$(78,205):LOCATE 1,2:PRINT BDR$
5550 LOCATE 1,80:PRINT CHR$(187)
5560 FOR V=2 TO 22:LOCATE V,1:PRINT CHR$(186):LOCATE V,80:PRINT CHR$(186):NEXT V
5570 LOCATE 23,1:PRINT CHR$(200)
5580 LOCATE 23,2:PRINT BDR$
5590 LOCATE 23,80:PRINT CHR$(188)
5600 RETURN
5610 :
5620 REM **** Create alphabet ****
5630 OPEN "D:ALFABET" FOR OUTPUT AS#1
5640 FOR N=32 TO 131:PRINT#1,CHR$(N);:NEXT N
5650 CLOSE 1
5660 RETURN
5670 :
5680 OPEN "O",1,"A:SETNUM":PRINT#1,"0":CLOSE
