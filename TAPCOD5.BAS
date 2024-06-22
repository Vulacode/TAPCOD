REM VERSION 5.05
CLEAR:DEFINT A-Z
INK=15:PAPER=0:INKH=0:PAPERH=15
GOSUB PASSWORD
VER=1:SER=1:POSCUR=1:FD1=0:DS$="DS":DOS$="C:\MS_DOS\"
KEY OFF:X$="":FOR N=1 TO 10:KEY N,X$:NEXT N
DIM ALF(128),RALF(128),ALPH(128),RALPH0(128),RALPH1(128)
ON ERROR GOTO ERMESG
GOTO MENU
:
MENU:
  COLOR INK,PAPER
  DO
    M=0:BF=0:NM$="!#+":ERON=-1:EROFF=0:ERF=EROFF
    FLP1$="C:\CODA\":FLP2$="A:":RAM$="D:"
    IF VER THEN VER$=" Keyword Version" ELSE VER$="  Disk Version "
    GOSUB BORDER:LOCATE 2,35:COLOR INKH,PAPERH:PRINT" TAPE  CODER ":COLOR INK,PAPER
    LOCATE 4,33:PRINT VER$
    LOCATE 6,36:COLOR INKH,PAPERH:PRINT" MAIN MENU ":COLOR INK,PAPER
    LOCATE 8,25:PRINT"F1  : Load messages from disk"
    LOCATE 9,25:PRINT"F2  : Save messages onto disk"
    LOCATE 10,25:PRINT"F3  : Delete messages on disk"
    LOCATE 12,25:PRINT"F4  : Encipher a message in memory"
    LOCATE 13,25:PRINT"F5  : Decipher a message in memory"
    LOCATE 15,25:PRINT"F6  : Type new messages"
    LOCATE 16,25:PRINT"F7  : Edit/read messages in memory"
    LOCATE 17,25:PRINT"F8  : Print messages in memory"
    LOCATE 18,25:PRINT"F9  : Send & Receive"
    LOCATE 20,25:PRINT"F10 : Quit"
    LOCATE 21,58:PRINT"(Switch: Alt D, Alt K)"
    DO UNTIL M>0 AND M<11
      DO WHILE LEN(CH$)<2
        CH$=INKEY$
      LOOP
      CH$=RIGHT$(CH$,1)
      V=ASC(CH$)-32
      IF V=0 THEN VER=0:VER$="  Disk  Version ":LOCATE 4,33:PRINT VER$
      IF V=5 THEN VER=1:VER$=" Keyword Version":LOCATE 4,33:PRINT VER$
      M=ASC(CH$)-58
      SELECT CASE M
        CASE 1:GOSUB LOADA
        CASE 2:GOSUB SAVA
        CASE 3:GOSUB DELLA
        CASE 4:GOSUB ENCA
        CASE 5:GOSUB DECA
        CASE 6:GOSUB NEWDOC
        CASE 7:GOSUB OLDOC
        CASE 8:GOSUB PRINTA
        CASE 9:GOSUB TRANSFER
        CASE 10:GOSUB QUITTA
      END SELECT
    LOOP
  LOOP
:
LOADA:
  IF VER=0 THEN DSK$="MESSAGE":GOSUB WARNDISK
  1:GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"LOAD MESSAGES FROM DRIVE ";FLP2$;" INTO MEMORY":COLOR INK,PAPER
  PRINT:FILES FLP2$+"*.*"
  PRINT:PRINT CHR$(186);" Type in name of message to load"
  PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
  PRINT:PRINT CHR$(186);:PRINT " Message name: ":UP=0
  DO UNTIL NM$=""
    V=CSRLIN-UP:LOCATE V-1,15:PRINT SPC(15):LOCATE V-1,15:INPUT": ",NM$:NM$=UCASE$(NM$)
    IF NM$="" THEN RETURN
    IF INSTR(NM$,":") OR INSTR(NM$,"\") THEN FLP2$=NM$:GOTO 1
    11:IF INSTR(NM$,"*")=0 THEN OPEN FLP2$+NM$ FOR INPUT AS#1:CLOSE
    SHELL "COPY "+FLP2$+NM$+" "+RAM$
    V=SCREEN(POS(0),CSRLIN)
    UP=POSCUR:VD=CSRLIN+(POSCUR-1):LOCATE VD,1:PRINT CHR$(186)
  LOOP
RETURN
:
SAVA:
  IF VER=0 THEN DSK$="MESSAGE":GOSUB WARNDISK
  2:GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"SAVE MESSAGES IN MEMORY ONTO DRIVE ";FLP2$:COLOR INK,PAPER
  PRINT:FILES RAM$+"*.*"
  PRINT:PRINT CHR$(186);" Type in name of message to save"
  PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
  PRINT:PRINT CHR$(186);:PRINT " Message name: ":UP=0
  DO UNTIL NM$=""
    V=CSRLIN-UP:LOCATE V-1,15:PRINT SPC(15):LOCATE V-1,15:INPUT": ",NM$:NM$=UCASE$(NM$)
    IF NM$="" THEN EXIT LOOP
    IF INSTR(NM$,":") OR INSTR(NM$,"\") THEN FLP2$=NM$:GOTO 2
    21:IF INSTR(NM$,"*")=0 THEN OPEN RAM$+NM$ FOR INPUT AS #1:CLOSE
    SHELL "COPY "+RAM$+NM$+" "+FLP2$
    UP=POSCUR:VD=CSRLIN+(POSCUR-1):LOCATE VD,1:PRINT CHR$(186)
  LOOP
RETURN
:
DELLA:
  IF VER=0 THEN DSK$="MESSAGE":GOSUB WARNDISK
  DO UNTIL NM$=""
    3:GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"DELETE MESSAGES ON DRIVE ";FLP2$:COLOR INK,PAPER
    PRINT:FILES FLP2$+"*.*"
    PRINT:PRINT CHR$(186);" Type in name of message to delete"
    PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
    PRINT:PRINT CHR$(186);:INPUT " Message name: ",NM$:NM$=UCASE$(NM$)
    IF NM$="" THEN EXIT LOOP
    IF INSTR(NM$,":") OR INSTR(NM$,"\") THEN FLP2$=NM$:GOTO 3
    31:IF INSTR(NM$,"*")=0 THEN OPEN FLP2$+NM$ FOR INPUT AS #1:CLOSE
    ERF=ERON
    KILL FLP2$+NM$
  LOOP
RETURN
:
ENCA:
  4:GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT "ENCIPHER A MESSAGE":COLOR INK,PAPER
  PRINT:FILES RAM$+"*"
  PRINT:PRINT CHR$(186);" Type in name of message to encipher"
  PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
  PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$:NM$=UCASE$(NM$)
  IF NM$="" THEN RETURN
  41:OPEN RAM$+NM$ FOR INPUT AS #1:CLOSE
  IF INSTR(NM$,".ENC") THEN BF=14:GOTO ERRA
  IF VER THEN
    GOSUB GETENCKEY
  ELSE
    DSK$="DATA":GOSUB WARNDISK:GOSUB GETENCDISK
  END IF
  IF INSTR(NM$,".") THEN
    OPEN RAM$+LEFT$(NM$,(INSTR(NM$,".")-1))+".ENC" FOR BINARY AS #1
  ELSE
    OPEN RAM$+NM$+".ENC" FOR BINARY AS #1
  END IF
  OPEN RAM$+NM$ FOR BINARY AS #2
  IF VER THEN
    CALL ENCKEY
  ELSE
    CALL ENCDISK
    GOSUB ENCFLUSH
  END IF
  CLOSE
RETURN
:
GETENCDISK:
  42:GOSUB BORDER:LOCATE 6,3:PRINT"Enciphering '";NM$;"'. Please wait..."
  OPEN "I",1,FLP2$+"SETNUM":INPUT#1,GETNUM:CLOSE
  IF GETNUM>99 THEN BF=1:GOTO ERRA
  43:LOCATE 18,2:PRINT 99-GETNUM;" sets of data left after this message"
  OPEN FLP2$+"SALF" FOR BINARY AS #1
  SEEK #1,GETNUM*128:GET$ #1,128,SALF$
  OPEN FLP2$+"SNUM" FOR BINARY AS #2
  G&=GETNUM
  SEEK #2,G&*3000:GET$ #2,3000,SNUM$
  OPEN FLP2$+"SDNO" FOR BINARY AS #3
  SEEK #3,GETNUM:GET$ #3,1,DNO$:CLOSE
  SM$=STRING$(5,166)
  SS$=SM$+DNO$
RETURN
:
GETENCKEY:
  GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT "ENCIPHER '";NM$;"'":COLOR INK,PAPER
  LOCATE 4,3:PRINT"Enter page number, line number and key or press ENTER to return to Main Menu"
  LOCATE 6,3:PRINT"Book page number: [   ]"
  LOCATE 8,3:PRINT"Line number: [  ]"
  LOCATE 10,3:PRINT"26 character key: [                          ]"
  LOCATE 6,22:PRINT CHR$(219)
  K=0:Y=6:X=22:LOLIM=48:UPLIM=57:CHARS=3:GOSUB KEYA
  IF VAL(STNG$)>127 THEN BF=2:GOTO ERRA
  PAGE$=STNG$:PAGE$=CHR$(159-VAL(PAGE$))
  LOCATE 8,17:PRINT CHR$(219)
  Y=8:X=17:LOLIM=48:UPLIM=57:CHARS=2:GOSUB KEYA
  IF VAL(STNG$)>96 THEN BF=3:GOTO ERRA
  LNE$=STNG$:LNE$=CHR$(128-VAL(LNE$))
  LOCATE 10,22:PRINT CHR$(219)
  K=1:Y=10:X=22:LOLIM=32:UPLIM=126:CHARS=26:GOSUB KEYA
  KEA$=STNG$
  GOSUB BORDER:LOCATE 6,3:PRINT"Enciphering '";NM$;"'. Please wait..."
  CKSUM=0
  FOR N=1 TO 26
    CKSUM=(CKSUM+ASC(MID$(KEA$,N,1))) MOD 256
    CKS(N)=CKSUM
  NEXT N
  RANDOMIZE CKSUM
  FOR N=0 TO 127
    IF N MOD 5=0 THEN RANDOMIZE CKS(N/5+1)
    DO
      CH=INT(RND*128)
    LOOP WHILE ALF(CH)=-1
    ALF(CH)=-1
    ALPH(N)=CH
  NEXT N
  SM$=STRING$(5,167)
  SS$=SM$+LNE$+PAGE$
  ERASE ALF
RETURN
:
SUB ENCKEY
  SHARED CKS,ALF,ALPH(),SS$
  LOCAL CR,CT,BM,MS$,MS,RL,CD,SLET$,BX,N,EM$
  PUT$ #1,SS$
  CR=0:CT=0:BM=0
  DO UNTIL EOF(2)
    GET$ #2,1,MS$:MS=ALPH(ASC(MS$))
    RL=INT(RND*256)
    CD=(MS XOR RL) MOD 128:INCR CT
    SLET$=CHR$(CD+32)
    IF CT MOD 5=0 THEN SLET$=SLET$+CHR$(160+BM):INCR BM
    PUT$ #1,SLET$
    IF RL MOD 3=0 THEN RANDOMIZE (ALPH(CR)+CT) MOD 256:INCR CR
    BM=BM MOD 5:CR=CR MOD 128:CT=CT MOD 32760
  LOOP
  EM$=STRING$(5,165)
  PUT$ #1,EM$
END SUB
:
SUB ENCDISK
  SHARED SS$,SALF$,SNUM$,CT
  LOCAL CP,BM,MS$,MS,RL$,RL,SLET$,N,DSA$,DSN$,EM$
  PUT$ #1,SS$
  LOCATE 18,3:PRINT"Character number: ";SPC(25)
  CT=0:CP=0:BM=0
  DO UNTIL EOF(2)
    GET$ #2,1,MS$:INCR CP
    MS=ASC(MID$(SALF$,ASC(MS$)+1,1))
    RL=ASC(MID$(SNUM$,CP,1))
    CD=(MS XOR RL) MOD 128:INCR CT
    SLET$=CHR$(CD+32)
    IF CT MOD 5=0 THEN SLET$=SLET$+CHR$(160+BM):INCR BM
    PUT$ #1,SLET$
    CP=CP MOD 3000:BM=BM MOD 5
    LOCATE 18,21:PRINT CT
  LOOP
  EM$=STRING$(5,165)
  PUT$ #1,EM$
  CLOSE
END SUB
:
ENCFLUSH:
  44:GOSUB BORDER:LOCATE 6,3:PRINT"Enciphering finished. Flushing disk..."
  LOCATE 18,3:PRINT"Message length: ";CT;" characters"
  OPEN FLP2$+"SALF" FOR INPUT AS #1:CLOSE
  OPEN FLP2$+"SALF" FOR BINARY AS #1
  DSA$=STRING$(100,0):SEEK #1,GETNUM*100:PUT$ #1,DSA$
  OPEN FLP2$+"SNUM" FOR BINARY AS #2
  G&=GETNUM
  DSN$=STRING$(3000,0):SEEK #2,G&*3000:PUT$ #2,DSN$
  INCR GETNUM:OPEN "O",3,FLP2$+"SETNUM":PRINT#3,GETNUM
RETURN
:
DECA:
  5:GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT "DECIPHER A MESSAGE":COLOR INK,PAPER
  PRINT:FILES RAM$+"*.*"
  PRINT:PRINT CHR$(186);" Type in name of message to decipher"
  PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
  PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$:NM$=UCASE$(NM$)
  IF NM$="" THEN RETURN
  51:OPEN RAM$+NM$ FOR INPUT AS #1:CLOSE
  OPEN RAM$+NM$ FOR BINARY AS #1
  GET$ #1,10,VR$:CLOSE
  IF INSTR(VR$,CHR$(166)) THEN
    VER=0:DSK$="DATA"
    GOSUB WARNDISK
    GOSUB GETDECDISK
  ELSEIF INSTR(VR$,CHR$(167)) THEN
    VER=1:GOSUB GETDECKEY
  ELSE
    BF=15:GOTO ERRA
  END IF
  CLOSE
  IF INSTR(NM$,".") THEN
    OPEN RAM$+LEFT$(NM$,(INSTR(NM$,".")-1))+".DEC" FOR BINARY AS #1
  ELSE
    OPEN RAM$+NM$+".DEC" FOR BINARY AS #1
  END IF
  OPEN RAM$+NM$ FOR BINARY AS #2
  IF VER THEN
    CALL DECKEY
  ELSE
    GOSUB BORDER
    LOCATE 2,3:COLOR INKH,PAPERH:PRINT"Message '";NM$;"' reads (ESCape to quit):":COLOR INK,PAPER
    CALL DECDISK
    GOSUB DECFLUSH
  END IF
  CLOSE
RETURN
:
GETDECDISK:
  52:GOSUB BORDER:LOCATE 6,3:PRINT"Deciphering '";NM$;"'. Please wait..."
  OPEN RAM$+NM$ FOR BINARY AS #1
  IN=0:SC=0:N=0:RALF$="":RNUM$="":NULL$=STRING$(10,0)
  DO
    GET$ #1,1,SET$:INCR IN
    IF SET$=CHR$(166) THEN INCR SC
  LOOP UNTIL SC>2 AND ASC(SET$)<>166
  53:OPEN FLP2$+"RDNO" FOR INPUT AS #2:CLOSE
  OPEN FLP2$+"RDNO" FOR BINARY AS #2
  GET$ #2,100,RDNO$:CLOSE
  DNO=INSTR(RDNO$,SET$):D&=DNO-1
  IF DNO=100 THEN BF=4:GOTO ERRA
  54:LOCATE 18,2:PRINT 100-DNO;" sets of data left after this message"
  OPEN FLP2$+"RALF" FOR BINARY AS #1
  SEEK #1,(DNO-1)*128:GET$ #1,128,RALF$
  OPEN FLP2$+"RNUM" FOR BINARY AS #2
  SEEK #2,D&*3000:GET$ #2,3000,RNUM$
  IF INSTR(RNUM$,NULL$) THEN BF=16:CLOSE:GOTO ERRA
  CLOSE
RETURN
:
GETDECKEY:
  OPEN RAM$+NM$ FOR BINARY AS #1
  55:IN=0:SC=0
  DO
    GET$ #1,1,L$:INCR IN
    IF INSTR(L$,CHR$(167)) THEN INCR SC
  LOOP UNTIL SC>3 AND ASC(L$)<>167
  GET$ #1,1,P$:INCR IN:CLOSE
  LNE=128-(ASC(L$)):PAGE=159-(ASC(P$))
  GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"DECIPHER '";NM$;"'":COLOR INK,PAPER
  LOCATE 4,3:PRINT"Book page number is: ";PAGE
  LOCATE 6,3:PRINT"Line number is: ";LNE
  LOCATE 8,3:PRINT"Type key or press ENTER to return to Main Menu"
  LOCATE 10,3:PRINT"26 character key: [                          ]"
  LOCATE 10,22:PRINT CHR$(219)
  K=1:Y=10:X=22:LOLIM=32:UPLIM=126:CHARS=26:GOSUB KEYA
  KEA$=STNG$
  GOSUB BORDER:LOCATE 6,3:PRINT"Deciphering '";NM$;"'. Please wait..."
  CKSUM=0
  FOR N=1 TO 26
    CKSUM=(CKSUM+ASC(MID$(KEA$,N,1))) MOD 256
    CKR(N)=CKSUM
  NEXT N
  RANDOMIZE CKSUM
  FOR N=0 TO 127
    IF N MOD 5=0 THEN RANDOMIZE CKR(N/5+1)
    DO
      CH=INT(RND*128)
    LOOP WHILE RALF(CH)=-1
    RALF(CH)=-1
    RALPH0(N)=CH
    RALPH1(CH)=N
  NEXT N
  ERASE RALF
RETURN
:
SUB DECKEY
  SHARED IN,RALF(),RALPH0(),RALPH1()
  LOCAL IP$,IP,BM,BX,CH,CK,CR CT,EC,RL,PL,RLET$
  BX=1:CH=0:CK=0:CR=0:CT=0:EC=0:SEEK #2,IN
  DK:
  DO UNTIL EC=3
    BX=1+((BX-1) MOD 5)
    GET$ #2,1,IP$:IP=ASC(IP$)-32
    SELECT CASE IP
      CASE 0 TO 127:EXIT SELECT
      CASE 128 TO 132:BM=IP-127:CK=1:EXIT SELECT
      CASE=133:INCR EC:GOTO DK
      CASE <0,>133:IP=0
    END SELECT
    IF CH>4 THEN BM=BX:CK=1
    KCHEK:
    IF CK THEN
      IF CH=5 THEN
        IF BM=BX THEN INCR BX:CH=0:CK=0:GOTO DK
        IF BM<>BX THEN INCR BX:CH=0
      END IF
      BX=1+((BX-1) MOD 5)
    END IF
    RL=INT(RND*256)
    PL=(IP XOR RL) MOD 128:INCR CT
    RLET$=CHR$(RALPH1(PL))
    IF RL MOD 3=0 THEN RANDOMIZE (RALPH0(CR)+CT) MOD 256:INCR CR
    CR=CR MOD 128:CT=CT MOD 32760
    IF CK THEN RLET$="?"
    PUT$ #1,RLET$
    INCR CH
    IF CK THEN KCHEK
  LOOP
END SUB
:
SUB DECDISK
  SHARED IN,RALF$,RNUM$
  LOCAL SC,CH,CP,EC,RL,PL,R,C,CT,CK,BX,IP$,IP,RLET$
  SC=0:CH=0:CP=0:EC=0:R=4:C=3:CT=0:CK=0:BX=1:SEEK #2,IN
  DD:
  DO UNTIL EC=3 OR INSTAT
    BX=1+((BX-1) MOD 5)
    GET$ #2,1,IP$
    IP=ASC(IP$)-32
    SELECT CASE IP
      CASE 0 TO 127:EXIT SELECT
      CASE 128 TO 132:BM=IP-127:CK=1:EXIT SELECT
      CASE 133:INCR EC:GOTO DD
      CASE <0,>133:IP=0
    END SELECT
    IF CH>4 THEN BM=BX:CK=1
    DCHEK:
    IF CK THEN
      IF CH=5 THEN
        IF BM=BX THEN INCR BX:CH=0:CK=0:GOTO DD
        IF BM<>BX THEN INCR BX:CH=0
      END IF
      BX=1+((BX-1) MOD 5)
    END IF
    INCR CP
    RL=ASC(MID$(RNUM$,CP,1))
    PL=(IP XOR RL) MOD 128:INCR CT
    RLET$=CHR$(ASC(MID$(RALF$,PL+1,1)))
    IF CK THEN RLET$="?"
    LOCATE R,C:PRINT RLET$:PUT$ #1,RLET$
    INCR C:INCR CH:CP=CP MOD 3000
    IF C=79 THEN C=3:INCR R
    R=4+((R-4) MOD 15)
    IF CK THEN DCHEK
  LOOP
  CLOSE
  IF INSTAT THEN MENU
END SUB
:
DECFLUSH:
  LOCATE 19,1:PRINT CHR$(204):LOCATE 19,2:PRINT BDR$:LOCATE 19,80:PRINT CHR$(185)
  LOCATE 20,3:PRINT"This message is in memory. It can be read in the editor, printed and saved"
  LOCATE 21,3:PRINT"Press ESCape to redo or any other key to flush disk & return to  Main Menu"
  CNT$=INPUT$(1)
  IF ASC(CNT$)=27 THEN MENU
  56:GOSUB BORDER:LOCATE 6,3:PRINT "Deciphering finished. Flushing disk..."
  OPEN FLP2$+"RALF" FOR INPUT AS #1:CLOSE
  OPEN FLP2$+"RALF" FOR BINARY AS #1
  DRA$=STRING$(100,0):SEEK #1,(DNO-1)*100:PUT$ #1,DRA$
  OPEN FLP2$+"RNUM" FOR BINARY AS #2
  D&=DNO-1
  DRN$=STRING$(3000,0):SEEK #2,D&*3000:PUT$ #2,DRN$
RETURN
:
NEWDOC:
  GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"TYPE NEW MESSAGES":COLOR INK,PAPER
  LOCATE 4,3:PRINT"Give a name to the message you are about to type"
  LOCATE 5,3:PRINT"or press ENTER to return to Main Menu"
  LOCATE 7,3:PRINT"The name you give must:"
  LOCATE 9,3:PRINT"- only contain alphabet keys"
  LOCATE 10,3:PRINT"- not be longer than 8 characters"
  LOCATE 11,3:PRINT"- not contain spaces"
  LOCATE 12,3:PRINT"- not have an extension"
  LOCATE 14,3:INPUT "Message name: ",NM$
  IF NM$="" THEN RETURN
  IF INSTR(NM$," ") THEN BF=5:GOTO ERRA
  IF INSTR(NM$,".") THEN BF=6:GOTO ERRA
  IF LEN(NM$)>8 THEN BF=7:GOTO ERRA
  IF ASC(LEFT$(NM$,1))>47 AND ASC(LEFT$(NM$,1))<58 THEN BF=8:GOTO ERRA
  GOSUB EDIT
RETURN
:
OLDOC:
  7:GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"EDIT/READ MESSAGES IN MEMORY":COLOR INK,PAPER
  PRINT:FILES RAM$+"*.*"
  PRINT:PRINT CHR$(186);" Type in name of message to edit or read"
  PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
  PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$
  IF NM$="" THEN RETURN
  71:OPEN RAM$+NM$ FOR INPUT AS #1:CLOSE
  GOSUB EDIT
RETURN
:
EDIT:
  IF FD1 THEN DSK$="PROGRAM":GOSUB WARNDISK
  IF SER THEN GOSUB SETBAUD
  67:OPEN FLP1$+"EDIT.EXE" FOR INPUT AS #1:CLOSE
  SHELL FLP1$+"EDIT "+RAM$+NM$
RETURN
:
PRINTA:
  8:GOSUB BORDER:WIDTH "LPT1:",79:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"PRINT MESSAGES IN MEMORY":COLOR INK,PAPER
  PRINT:FILES RAM$+"*.*"
  PRINT:PRINT CHR$(186);" Type in name of message to print"
  PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
  PRINT:PRINT CHR$(186);:PRINT" Message name: ":UP=0
  DO UNTIL NM$=""
    V=CSRLIN-UP:LOCATE V-1,15:PRINT SPC(15):LOCATE V-1,15:INPUT": ",NM$:NM$=UCASE$(NM$)
    IF NM$="" THEN EXIT LOOP
    81:OPEN RAM$+NM$ FOR INPUT AS #1:CLOSE
    IF SER THEN GOSUB SETBAUD
    82:LPRINT CHR$(27);CHR$(64);CHR$(27);CHR$(82);CHR$(3)
    SHELL "TYPE "+RAM$+NM$+" > PRN"
    LPRINT CHR$(12)
    UP=POSCUR:VD=CSRLIN+(POSCUR-1):LOCATE VD,1:PRINT CHR$(186)
  LOOP
RETURN
:
TRANSFER:
  GOSUB BORDER:LOCATE 5,35:COLOR INKH,PAPERH:PRINT"TRANSFER MENU":COLOR INK,PAPER
  LOCATE 10,29:PRINT"S   : Send/Save on tape"
  LOCATE 12,29:PRINT"R   : Receive from tape"
  LOCATE 14,29:PRINT"ESC : Return to Main Menu"
  DO
    ESAU$=UCASE$(INPUT$(1))
    IF ASC(ESAU$)=27 THEN RETURN
  LOOP UNTIL ESAU$="R" OR ESAU$="S"
  IF ESAU$="S" THEN GOSUB SEND ELSE GOSUB RECEIVE
RETURN
:
SEND:
  DO
    9:GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"SEND/SAVE ENCIPHERED MESSAGES":COLOR INK,PAPER
    PRINT:FILES RAM$+"*.ENC"
    PRINT:PRINT CHR$(186);" Type in name of enciphered message to send/save"
    PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
    PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$:NM$=UCASE$(NM$)
    IF NM$="" THEN EXIT LOOP
    91:OPEN RAM$+NM$ FOR INPUT AS #1:CLOSE
    IF INSTR(NM$,".ENC")=0 THEN BF=13:GOTO ERRA
    GOSUB BORDER:BEEP:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"** Ensure modem is on and connected properly **":COLOR INK,PAPER
    LOCATE 4,3:PRINT"(Press RECORD on tape recorder to save '";NM$;"')"
    LOCATE 20,3:PRINT"Press any key to send/save '";NM$;"'. ESCape to return to Main Menu"
    CNT$=INPUT$(1)
    IF ASC(CNT$)=27 THEN EXIT LOOP
    GOSUB BORDER:LOCATE 6,3:PRINT"Sending/saving '";NM$;"'...":COLOR INK,PAPER
    LATER#=TIMER+5
    WHILE TIMER<LATER#
    WEND
    OPEN "COM1:300,N,8,1,CS,DS" AS #1
    OPEN RAM$+NM$ FOR BINARY AS #2
    FC=0
    DO UNTIL FC=LOF(2) OR INSTAT
      GET$ #2,1,TAPNM$:INCR FC
      PRINT #1,TAPNM$;
    LOOP
    CLOSE
    IF INSTAT THEN EXIT LOOP
  LOOP
RETURN
:
RECEIVE:
  GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"RECEIVE AN ENCIPHERED MESSAGE FROM TAPE":COLOR INK,PAPER
  LOCATE 4,3:PRINT"Give a name to the message to be received from tape"
  LOCATE 5,3:PRINT"or press ENTER to return to Main Menu"
  LOCATE 7,3:PRINT"The name you give must:"
  LOCATE 9,3:PRINT"- only contain alphabet keys"
  LOCATE 10,3:PRINT"- not be longer than 8 characters"
  LOCATE 11,3:PRINT"- not contain spaces"
  LOCATE 12,3:PRINT"- not have an extension"
  LOCATE 14,3:INPUT"Message name: ",NM$:NM$=UCASE$(NM$)
  IF NM$="" THEN MENU
  IF INSTR(NM$," ") THEN BF=9:GOTO ERRA
  IF INSTR(NM$,".") THEN BF=10:GOTO ERRA
  IF LEN(NM$)>8 THEN BF=11:GOTO ERRA
  IF ASC(LEFT$(NM$,1))>47 AND ASC(LEFT$(NM$,1))<58 THEN BF=12:GOTO ERRA
  GOSUB BORDER:BEEP:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"** Ensure modem is on and connected to recorder properly **":COLOR INK,PAPER
  LOCATE 20,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
  CNT$=INPUT$(1)
  IF ASC(CNT$)=27 THEN MENU
  GOSUB GETREC
RETURN
:
GETREC:
  GOSUB BORDER:BEEP:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"Press PLAY on recorder to transfer '";NM$;"' (ESCape to quit)":COLOR INK,PAPER
  CALL GETTA
  PRINT#2,CHR$(26):CLOSE
  IF INSTAT THEN RETURN
  LOCATE 19,1:PRINT CHR$(204):LOCATE 19,2:PRINT BDR$:LOCATE 19,80:PRINT CHR$(185)
  LOCATE 20,3:PRINT"This message is in memory. It can now be deciphered"
  LOCATE 21,3:PRINT"Press ESCape to redo or any other key for Main Menu"
  CNT$=INPUT$(1)
  IF ASC(CNT$)=27 THEN GETREC
RETURN
:
SUB GETTA
  SHARED NM$,RAM$,DS$
  LOCAL B$,EC,C,R
  OPEN "COM1:300,N,8,1,CS,"+DS$ AS #1
  OPEN "O",2,RAM$+NM$
  EC=0:C=3:R=4
  ON ERROR GOTO 0:ON ERROR GOTO 99
  DO
    98:B$=INPUT$(1,#1)
    99:IF ERR=57 THEN RESUME 98
    IF INSTR(B$,CHR$(165)) THEN INCR EC
    IF ASC(B$)>167 THEN B$=" "
    LOCATE R,C:PRINT B$:PRINT#2,B$;:INCR C
    IF C=79 THEN C=3:INCR R
    R=4+((R-4) MOD 15)
  LOOP UNTIL EC=3 OR INSTAT
  ON ERROR GOTO 0:ON ERROR GOTO ERMESG
END SUB
:
QUITTA:
  DSK$="PROGRAM":GOSUB WARNDISK
  100:OPEN FLP2$+"TAPCOD5.EXE" FOR INPUT AS #1:CLOSE
  CLS:END
RETURN
:
ERRA:
  GOSUB BORDER:SOUND 88,8:LOCATE 2,3:COLOR INKH,PAPERH
  SELECT CASE BF
    CASE=1:PRINT"** Data finished. Start a new DATA disk  **"
    CASE=2:PRINT"** Page number too high. Maximum page number is 127 **"
    CASE=3:PRINT"** Line number too high. Maximum line number is 96 **"
    CASE=4:PRINT"** Last set of data. Start a new DATA disk next time **"	
    CASE=5,9:PRINT"** No spaces allowed in name **"
    CASE=6,10:PRINT"** No extensions allowed in name **"
    CASE=7,11:PRINT"** Name too long **"
    CASE=8,12:PRINT"** Numbers not allowed in name **"
    CASE=13:PRINT"** '";NM$;"' is not enciphered. It may not be sent/saved on tape **"
    CASE=14:PRINT"** You may not encipher an enciphered message **"
    CASE=15:PRINT"** Header missing. Un-decipherable or plaintext message **"
    CASE=16:PRINT"** This message has already been deciphered **"
  END SELECT
  COLOR INK,PAPER
  LOCATE 4,3:PRINT"Try again"
  LOCATE 20,3:PRINT"Press any key to continue. ESCape to return to Main Menu"
  CNT$=INPUT$(1)
  IF ASC(CNT$)=27 THEN MENU
  SELECT CASE BF
    CASE=1:GOTO MENU
    CASE=2:GOTO GETENCKEY
    CASE=3:GOTO GETENCKEY
    CASE=4:GOTO 54
    CASE=5:GOTO NEWDOC
    CASE=6:GOTO NEWDOC
    CASE=7:GOTO NEWDOC
    CASE=8:GOTO NEWDOC
    CASE=9:GOTO RECEIVE
    CASE=10:GOTO RECEIVE
    CASE=11:GOTO RECEIVE
    CASE=12:GOTO RECEIVE
    CASE=13:GOTO SEND
    CASE=14:GOTO 4
    CASE=15:GOTO MENU
    CASE=16:GOTO MENU
  END SELECT
:
ERMESG:
  IF ERF=ERON THEN RESUME MENU
  GOSUB BORDER:SOUND 88,8:LOCATE 2,3:COLOR INKH,PAPERH:NM$=UCASE$(NM$)
  SELECT CASE ERR
    CASE=5
      SELECT CASE ERL
        CASE=53,55:PRINT"** You've tried to decipher an un-enciphered message **"
      END SELECT
    CASE=24,25,27:PRINT"** Printer off line, not connected or out of paper **"
    CASE=53
      SELECT CASE ERL
        CASE= 1:PRINT"** There are no messages on this disk to load **"
	CASE=11:PRINT"** There is no message '";NM$;"' on this disk to load **"
	CASE= 2:PRINT"** There are no messages in memory to save **"
	CASE=21:PRINT"** There is no message '";NM$;"' in memory to save **"
	CASE= 3:PRINT"** There are no files on this disk to delete **"
	CASE=31:PRINT"** There is no file '";NM$;"' on this disk to delete **"
	CASE= 4:PRINT"** There are no messages in memory to encipher **"
	CASE=41:PRINT"** There is no message '";NM$;"' in memory to encipher **"
        CASE=42:PRINT"** Wrong disk. Place DATA disk in drive **"
        CASE=44:PRINT"** Wrong disk. Replace DATA disk in drive **"
	CASE= 5:PRINT"** There are no messages in memory to decipher **"
	CASE=51:PRINT"** There is no message '";NM$;"' in memory to decipher **"
        CASE=53:PRINT"** Wrong disk. Place DATA disk in drive **"
	CASE=56:PRINT"** Wrong disk. Replace DATA disk in drive **"
	CASE= 7:PRINT"** There are no messages in memory to edit/read **"
	CASE=71:PRINT"** There is no message '";NM$;"' in memory to edit/read **"
	CASE=67:PRINT"** PROGRAM disk not in drive **"
	CASE= 8:PRINT"** There are no messages in memory to print out **"
	CASE=81:PRINT"** There is no message '";NM$;"' in memory to print out **"
	CASE= 9:PRINT"** There are no messages in memory to send/save on tape **"
	CASE=91:PRINT"** There is no message '";NM$;"' in memory to send/save on tape **"
        CASE=100:PRINT"** PROGRAM disk not in drive **"
      END SELECT
      CASE=61:PRINT"** Disk/memory full. Delete files to make space **"
      CASE=70:PRINT"** Disk write-protected. Shift tab to continue **"
      CASE=71:PRINT"** Disk not in drive or door open **"
      CASE=72:PRINT"** Disk corrupted **"
      CASE=76:PRINT"** Path not found **"
    END SELECT
  COLOR INK,PAPER
  LOCATE 4,3:PRINT"Try again"
  LOCATE 6,3:PRINT ERR,ERL,ERADR
  LOCATE 20,3:PRINT"Press any key to continue. ESCape to return to Main Menu"
  CLOSE
  CNT$=INPUT$(1)
  IF ASC(CNT$)=27 THEN MENU
  SELECT CASE ERL
    CASE= 1:RESUME MENU                    'load 1
    CASE=11:RESUME 1                       'load 2
    CASE= 2:RESUME MENU                    'save 1
    CASE=21:RESUME 2                       'save 2
    CASE= 3:RESUME MENU                    'delete 1
    CASE=31:RESUME 3                       'delete 2
    CASE= 4:RESUME MENU                    'encipher 1
    CASE=41:RESUME ENCA                    'encipher 2
    CASE=42:RESUME 42                      'encipher 3
    CASE=44:RESUME 44                      'encipher 4
    CASE= 5:RESUME MENU                    'decipher 1
    CASE=51:RESUME DECA                    'decipher 2
    CASE=52:RESUME 52                      'decipher 3
    CASE=53:RESUME 52                      'decipher 4
    CASE=55:RESUME MENU                    'decipher 5
    CASE=56:RESUME 56                      'decipher 6
    CASE= 7:RESUME MENU                    'edit/read 1
    CASE=71:RESUME OLDOC                   'edit/read 2
    CASE=67:RESUME 67                      'editor
    CASE= 8:RESUME MENU                    'print 1
    CASE=81:RESUME PRINTA                  'print 2
    CASE=82:RESUME PRINTA                  'print 3
    CASE= 9:RESUME MENU                    'stape 1
    CASE=91:RESUME SEND                    'stape 2
    CASE=100:RESUME 100                    'quit
  END SELECT
  CLOSE:RESUME MENU
:
BORDER:
  CLS:LOCATE 1,1:PRINT CHR$(201)
  BDR$=STRING$(78,205):LOCATE 1,2:PRINT BDR$
  LOCATE 1,80:PRINT CHR$(187)
  FOR V=2 TO 21:LOCATE V,1:PRINT CHR$(186):LOCATE V,80:PRINT CHR$(186):NEXT V
  LOCATE 22,1:PRINT CHR$(200)
  LOCATE 22,2:PRINT BDR$
  LOCATE 22,80:PRINT CHR$(188)
RETURN
:
SETBAUD:
  SHELL DOS$+"MODE COM1:9600,N,8,1,P"
RETURN
:
WARNDISK:
  GOSUB BORDER:BEEP:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"** Ensure ";DSK$;" disk is in drive **":COLOR INK,PAPER
  LOCATE 20,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
  CNT$=INPUT$(1)
  IF ASC(CNT$)=27 THEN MENU
RETURN
:
KEYA:
  L=0:STNG$=""
  DO WHILE L<CHARS
    45:I$=INPUT$(1)
    IF L=0 AND ASC(I$)=13 THEN MENU
    IF K=0 AND ASC(I$)=13 THEN
      LOCATE Y,X:PRINT CHR$(32)
      EXIT LOOP
    END IF
    IF L>0 AND ASC(I$)=8 THEN
      STNG$=LEFT$(STNG$,LEN(STNG$)-1)
      LOCATE Y,X-1:PRINT CHR$(219);" "
      DECR X:DECR L:GOTO 45:
    END IF
    IF ASC(I$)<LOLIM OR ASC(I$)>UPLIM THEN SOUND 88,8:GOTO 45
    LOCATE Y,X
    IF L<CHARS-1 THEN
      PRINT I$;CHR$(219)
    ELSE
      PRINT I$
    END IF
    STNG$=STNG$+I$:INCR L:INCR X
  LOOP
RETURN
:
PASSWORD:
  PS$(9)=CHR$(66):PS$(4)=CHR$(66):PS$(1)=CHR$(84):PS$(5)=CHR$(79):PS$(2)=CHR$(73)
  PS$(3)=CHR$(77):PS$(6)=CHR$(66):PS$(8)=CHR$(77):PS$(10)=CHR$(79):PS$(7)=CHR$(73)
  PW$="":FOR N=1 TO 10:PW$=PW$+PS$(N):NEXT N
  DO
    CLS:LOCATE 12,20:INPUT"ENTER PASSWORD: ",PSW$
    PSW$=UCASE$(PSW$)
    IF PSW$="" THEN END
    IF PSW$<>PW$ THEN SOUND 88,8
  LOOP UNTIL PSW$=PW$
RETURN
