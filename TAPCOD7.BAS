$COM1 2048
:
CLEAR:DEFINT A-Z
:
DIM DR$(11)
OPEN "A:TAPCOD.CNF" FOR INPUT AS #1
FOR N=1 TO 11
  LINE INPUT #1,DR$(N)
NEXT N
CLOSE
:
PW=1:GOSUB PASSWORD
:
INK=VAL(DR$(1)):PAPER=0:INKH=PAPER:PAPERH=INK
BLANK$=STRING$(15,32):NULL$=STRING$(10,0)
VER=VAL(DR$(2)):SER=VAL(DR$(3)):POSCUR=VAL(DR$(4)):FD1=VAL(DR$(5))
DS$=DR$(6):FLP1$=DR$(7):FLP3$=DR$(9):FLP4$=DR$(10):AGENT=0 'A1=1, A2=2...
:
KEY OFF:X$="":FOR N=1 TO 10:KEY N,X$:NEXT N
DIM ALF(128),RALF(128),ALPH(128),RALPH0(128),RALPH1(128)
ON ERROR GOTO ERMESG
GOTO MENU
:
MENU:
  COLOR INK,PAPER
  DO
    M=0:BF=0:NM$="!#+":ERON=-1:EROFF=0:ERF=EROFF
    FLP2$=DR$(8):RAM$=DR$(11)
    IF VER THEN
      VER$="Keyword Version":XPOS=34
    ELSE
      XPOS=35:LOCATE 4,XPOS-1:PRINT BLANK$
      VER$="Disk  Version"
    END IF
    GOSUB BORDER:LOCATE 2,31:COLOR INKH,PAPERH:PRINT" T A P E   C O D E R ":COLOR INK,PAPER
    LOCATE 4,XPOS:PRINT VER$
    LOCATE 6,36:COLOR INKH,PAPERH:PRINT" MAIN MENU ":COLOR INK,PAPER
    LOCATE 8,25:PRINT"F1  : Load messages from disk"
    LOCATE 9,25:PRINT"F2  : Save messages onto disk"
    LOCATE 10,25:PRINT"F3  : Delete messages on disk"
    LOCATE 12,25:PRINT"F4  : Encipher messages in memory"
    LOCATE 13,25:PRINT"F5  : Decipher messages in memory"
    LOCATE 15,25:PRINT"F6  : Type a new message"
    LOCATE 16,25:PRINT"F7  : Edit/read a message"
    LOCATE 17,25:PRINT"F8  : Rename files"
    LOCATE 18,25:PRINT"F9  : Send & Receive"
    LOCATE 20,25:PRINT"F10 : Quit"
    LOCATE 23,2:PRINT"Version 7.11"
    LOCATE 23,60:PRINT"Switch: Alt D, Alt K"
    DO UNTIL M>0 AND M<11
      DO WHILE LEN(CH$)<2
        CH$=INKEY$
      LOOP
      CH$=RIGHT$(CH$,1)
      V=ASC(CH$)-32
      IF V=0 THEN
        VER=0:XPOS=35:LOCATE 4,XPOS-1:PRINT BLANK$:VER$="Disk  Version"
      ELSE
        IF V=5 THEN VER=1:XPOS=34:VER$="Keyword Version"
      END IF
      LOCATE 4,XPOS:PRINT VER$
      M=ASC(CH$)-58
      SELECT CASE M
        CASE 1:GOSUB LOADA
        CASE 2:GOSUB SAVA
        CASE 3:GOSUB DELLA
        CASE 4:GOSUB ENCA
        CASE 5:GOSUB DECA
        CASE 6:GOSUB NEWDOC
        CASE 7:GOSUB OLDOC
        CASE 8:GOSUB RENNA
        CASE 9:GOSUB TRANSFER
        CASE 10:GOSUB QUITTA
      END SELECT
    LOOP
  LOOP
:
LOADA:
  1:GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"LOAD MESSAGES FROM DRIVE ";FLP2$;" INTO MEMORY":COLOR INK,PAPER
  PRINT:FILES FLP2$+"\*.*"
  PRINT:PRINT CHR$(186);" Type in name of message to load, or new drive\subdirectory"
  PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
  PRINT:PRINT CHR$(186);:PRINT " Message name: ":UP=0
  DO
    V=CSRLIN-UP:LOCATE V-1,15:PRINT SPC(15):LOCATE V-1,15:INPUT": ",NM$:NM$=UCASE$(NM$)
    IF NM$="" THEN EXIT LOOP
    IF INSTR(NM$,":") OR INSTR(NM$,"\") THEN FLP2$=NM$:GOTO 1
    11:IF INSTR(NM$,"*")=0 THEN OPEN FLP2$+"\"+NM$ FOR INPUT AS#1:CLOSE
    SHELL "COPY "+FLP2$+"\"+NM$+" "+RAM$
    V=SCREEN(POS(0),CSRLIN)
    UP=POSCUR:VD=CSRLIN+(POSCUR-1):LOCATE VD,1:PRINT CHR$(186)
  LOOP
RETURN
:
SAVA:
  2:GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"SAVE MESSAGES IN MEMORY ONTO DRIVE ";FLP2$:COLOR INK,PAPER
  PRINT:FILES RAM$+"*.*"
  PRINT:PRINT CHR$(186);" Type in name of message to save, or new drive\subdirectory"
  PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
  PRINT:PRINT CHR$(186);:PRINT " Message name: ":UP=0
  DO
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
  DO
    3:GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"DELETE MESSAGES ON DRIVE ";FLP2$:COLOR INK,PAPER
    PRINT:FILES FLP2$+"\*.*"
    PRINT:PRINT CHR$(186);" Type in name of message to delete, or new drive\subdirectory"
    PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
    PRINT:PRINT CHR$(186);:INPUT " Message name: ",NM$:NM$=UCASE$(NM$)
    IF NM$="" THEN EXIT LOOP
    IF INSTR(NM$,":") OR INSTR(NM$,"\") THEN FLP2$=NM$:GOTO 3
    31:IF INSTR(NM$,"*")=0 THEN OPEN FLP2$+"\"+NM$ FOR INPUT AS #1:CLOSE
    ERF=ERON
    KILL FLP2$+"\"+NM$
  LOOP
RETURN
:
ENCA:
  DO
    4:GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH
    PRINT "ENCIPHER A MESSAGE (";VER$;")":COLOR INK,PAPER
    PRINT:FILES RAM$+"*"
    PRINT:PRINT CHR$(186);" Type in name of message to encipher"
    PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
    PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$:NM$=UCASE$(NM$)
    IF NM$="" THEN EXIT LOOP
    41:OPEN RAM$+NM$ FOR INPUT AS #1
    LMSG&=LOF(1)
    IF LMSG&>27290 THEN BF=17:GOTO ERRA
    CLOSE
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
    PUT$ #1,SS$
    OPEN RAM$+NM$ FOR BINARY AS #2
    GET$ #2,LOF(2),MSG$
    LENMSG=LEN(MSG$)
    IF VER THEN
      BM=0:CT=2
      IF IMPT THEN GOSUB IMPRINT
      CALL ENCKEY(MSG$,LENMSG,ALPH())
      LOCATE ,,0
    ELSE
      BM=0:CP=0:CT=1
      IF IMPT THEN GOSUB IMPRINT
      CALL ENCDISK(MSG$,LENMSG,SALF$,SNUM$)
      CLOSE:SALF$="":SNUM$=""
      GOSUB ENCFLUSH
    END IF
    CLOSE
  LOOP
RETURN
:
GETENCKEY:
  GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT "ENCIPHER '";NM$;"'":COLOR INK,PAPER
  LOCATE 4,3:PRINT"Enter page number, line number and key or press ENTER to return to Main Menu"
  LOCATE 6,3:PRINT"Book page number: [   ]"
  LOCATE 8,3:PRINT"Line number     : [  ]"
  LOCATE 10,3:PRINT"26 character key: [                          ]"
  LOCATE 6,22:PRINT CHR$(219)
  K=0:Y=6:X=22:LOLIM=48:UPLIM=57:CRS=3:GOSUB KEYA
  IF VAL(STNG$)>127 THEN BF=2:GOTO ERRA
  PAGE=VAL(STNG$):PAGE$=CHR$(159-PAGE)
  LOCATE 8,22:PRINT CHR$(219)
  Y=8:X=22:LOLIM=48:UPLIM=57:CRS=2:GOSUB KEYA
  IF VAL(STNG$)>96 THEN BF=3:GOTO ERRA
  LNE=VAL(STNG$):LNE$=CHR$(128-LNE)
  LOCATE 10,22:PRINT CHR$(219)
  K=1:Y=10:X=22:LOLIM=32:UPLIM=126:CRS=26:GOSUB KEYA
  KEA$=STNG$:DIM CKS(26)
  GOSUB BORDER:LOCATE 6,3:PRINT"Please wait. Enciphering '";NM$;"'...";:LOCATE ,,1
  SM$=STRING$(5,177)
  IF AGENT THEN
    RANDOMIZE TIMER:AN=13+(AGENT*20)+INT(RND*20)
    AN$=STRING$(3,AN)
    SS$=AN$+SM$+LNE$+PAGE$
  ELSE
    SS$=SM$+LNE$+PAGE$
  END IF
  SR=PAGE*LNE:RANDOMIZE SR
  SK=INT(RND*25)+1:KEA$=RIGHT$(KEA$,26-SK)+LEFT$(KEA$,SK)
  CKSUM=0
  FOR N=26 TO 1 STEP -1
    CKSUM=(CKSUM+ASC(MID$(KEA$,N,1)))
    CKS(N)=CKSUM
  NEXT N
  RANDOMIZE CKSUM+VAL(PAGE$)+VAL(LNE$)
  FOR N=0 TO 127
    IF N MOD 5=0 THEN RANDOMIZE CKS(N/5+1)
    DO
      CH=INT(RND*128)
    LOOP WHILE ALF(CH)=-1
    ALF(CH)=-1
    ALPH(N)=CH
  NEXT N
  ERASE ALF
RETURN
:
GETENCDISK:
  42:GOSUB BORDER:LOCATE 6,3:PRINT"Please wait. Enciphering '";NM$;"'..."
  OPEN "I",1,FLP2$+"SETNUM":INPUT#1,GETNUM:CLOSE
  IF GETNUM>99 THEN BF=1:GOTO ERRA
  LOCATE 18,3:PRINT "Using data set no:";GETNUM+1
  OPEN FLP2$+"SALF" FOR BINARY AS #1
  SEEK #1,GETNUM*128:GET$ #1,128,SALF$
  OPEN FLP2$+"SNUM" FOR BINARY AS #2
  G&=GETNUM
  SEEK #2,G&*3000:GET$ #2,3000,SNUM$
  IF INSTR(SALF$,NULL$) OR INSTR(SNUM$,NULL$) THEN
    INCR GETNUM:OPEN "O",3,FLP2$+"SETNUM":PRINT#3,GETNUM:CLOSE
    BF=18:GOTO ERRA
  END IF
  OPEN FLP2$+"SDNO" FOR BINARY AS #3
  SEEK #3,GETNUM:GET$ #3,1,DNO$:CLOSE
  SM$=STRING$(5,176)
  IF AGENT THEN
    RANDOMIZE TIMER:AN=13+(AGENT*20)+INT(RND*20)
    AN$=STRING$(3,AN)
    SS$=AN$+SM$+CHR$(ASC(DNO$)+32)
  ELSE
    SS$=SM$+CHR$(ASC(DNO$)+32)
  END IF
RETURN
:
SUB ENCKEY(MS$,LM,ALF0(1))
  SHARED BM,CT
  LOCAL CD,CH,EM$,GK,RL,SLET$
  FOR GK=1 TO LM
    RL=INT(RND*256)
    CD=(ALF0(ASC(MID$(MS$,GK,1))) XOR RL) MOD 128
    INCR CT
    SLET$=CHR$(CD+32)
    IF CT MOD 10=0 THEN SLET$=SLET$+CHR$(160+BM):INCR BM
    PUT$ #1,SLET$
    IF RL MOD 4=0 THEN RANDOMIZE (ALF0((RND*128)+1)+CT)
    BM=BM MOD 15
  NEXT GK
  EM$=STRING$(5,175)
  PUT$ #1,EM$
  MS$=""
END SUB
:
SUB ENCDISK(MS$,LM,SLF$,SNM$)
  SHARED BM,CP,CT
  LOCAL CD,CH,EM$,GD,RL,SLET$
  LOCATE 18,3:PRINT"Character number: ";STRING$(10,32)
  FOR GD=1 TO LM
    CH=ASC(MID$(SLF$,ASC(MID$(MS$,GD,1))+1,1))
    INCR CP:INCR CT
    RL=ASC(MID$(SNM$,CP,1))
    CD=(CH XOR RL) MOD 128
    SLET$=CHR$(CD+32)
    IF CT MOD 10=0 THEN SLET$=SLET$+CHR$(160+BM):INCR BM
    PUT$ #1,SLET$
    CP=CP MOD 3000:BM=BM MOD 15
    LOCATE 18,21:PRINT CT-1
  NEXT GD
  EM$=STRING$(5,175)
  PUT$ #1,EM$
  MS$=""
END SUB
:
ENCFLUSH:
  43:GOSUB BORDER:LOCATE 6,3:PRINT"Enciphering finished. Flushing disk..."
  LOCATE 18,3:PRINT"Message length: ";CT-1;" characters"
  OPEN FLP2$+"SETNUM" FOR INPUT AS #1:CLOSE
  OPEN FLP2$+"SALF" FOR BINARY AS #1
  DSA$=STRING$(128,0):SEEK #1,GETNUM*128:PUT$ #1,DSA$
  OPEN FLP2$+"SNUM" FOR BINARY AS #2
  G&=GETNUM
  DSN$=STRING$(3000,0):SEEK #2,G&*3000:PUT$ #2,DSN$
  INCR GETNUM:OPEN "O",3,FLP2$+"SETNUM":PRINT#3,GETNUM
RETURN
:
DECA:
  DO
    5:GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT "DECIPHER A MESSAGE":COLOR INK,PAPER
    PRINT:FILES RAM$+"\*.*"
    PRINT:PRINT CHR$(186);" Type in name of message to decipher"
    PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
    PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$:NM$=UCASE$(NM$)
    IF NM$="" THEN EXIT LOOP
    51:OPEN RAM$+NM$ FOR INPUT AS #1:CLOSE
    OPEN RAM$+NM$ FOR BINARY AS #1
    GET$ #1,15,VR$:CLOSE
    IF INSTR(VR$,STRING$(3,177)) THEN
      VER=1:GOSUB GETDECKEY
    ELSEIF INSTR(VR$,STRING$(3,176)) THEN
      VER=0:DSK$="DATA"
      GOSUB WARNDISK
      GOSUB GETDECDISK
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
    SEEK #2,IN
    GET$ #2,LOF(2),CGM$
    LENCGM=LEN(CGM$)-2
    IF VER THEN
      CALL DECKEY(CGM$,LENCGM,RALPH0(),RALPH1())
      CGM$="":LOCATE ,,0
    ELSE
      GOSUB BORDER
      LOCATE 2,3:COLOR INKH,PAPERH:PRINT"Message '";NM$;"' reads (ESCape to quit):":COLOR INK,PAPER
      CALL DECDISK(CGM$,LENCGM,RALF$,RNUM$)
      CLOSE
      RALF$="":RNUM$="":CGM$=""
      IF INSTAT THEN MENU
      GOSUB DECFLUSH
    END IF
    CLOSE
  LOOP
RETURN
:
GETDECDISK:
  52:GOSUB BORDER:LOCATE 6,3:PRINT"Please wait. Deciphering '";NM$;"'..."
  OPEN RAM$+NM$ FOR BINARY AS #1
  IN=0:SC=0:N=0:RALF$="":RNUM$=""
  DO
    GET$ #1,1,SET$:INCR IN
    IF SET$=CHR$(176) THEN INCR SC
  LOOP UNTIL SC>2 AND ASC(SET$)<>176
  53:OPEN FLP2$+"RDNO" FOR INPUT AS #2:CLOSE
  OPEN FLP2$+"RDNO" FOR BINARY AS #2
  GET$ #2,100,RDNO$:CLOSE
  SET$=CHR$(ASC(SET$)-32)
  DNO=INSTR(RDNO$,SET$):D&=DNO-1
  IF DNO=100 THEN BF=4:GOTO ERRA
  54:LOCATE 18,3:PRINT "Using data set no:";DNO
  OPEN FLP2$+"RALF" FOR BINARY AS #1
  SEEK #1,(DNO-1)*128:GET$ #1,128,RALF$
  OPEN FLP2$+"RNUM" FOR BINARY AS #2
  SEEK #2,D&*3000:GET$ #2,3000,RNUM$
  IF INSTR(RALF$,NULL$) OR INSTR(RNUM$,NULL$) THEN BF=16:CLOSE:GOTO ERRA
  CLOSE
RETURN
:
GETDECKEY:
  OPEN RAM$+NM$ FOR BINARY AS #1
  55:IN=0:SC=0
  DO
    GET$ #1,1,L$:INCR IN
    IF INSTR(L$,CHR$(177)) THEN INCR SC
  LOOP UNTIL SC>3 AND ASC(L$)<>177
  GET$ #1,1,P$:INCR IN:CLOSE
  LNE=128-(ASC(L$)):PAGE=159-(ASC(P$))
  GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"DECIPHER '";NM$;"'":COLOR INK,PAPER
  LOCATE 4,3:PRINT"Book page number is: ";PAGE
  LOCATE 6,3:PRINT"Line number is     : ";LNE
  LOCATE 8,3:PRINT"Type key or press ENTER to return to Main Menu"
  LOCATE 10,3:PRINT"26 character key: [                          ]"
  LOCATE 10,22:PRINT CHR$(219)
  K=1:Y=10:X=22:LOLIM=32:UPLIM=126:CRS=26:GOSUB KEYA
  KEA$=STNG$:DIM CKR(26)
  GOSUB BORDER:LOCATE 6,3:PRINT"Please wait. Deciphering '";NM$;"'...";:LOCATE ,,1
  SR=PAGE*LNE:RANDOMIZE SR
  SK=INT(RND*25)+1:KEA$=RIGHT$(KEA$,26-SK)+LEFT$(KEA$,SK)
  CKSUM=0
  FOR N=26 TO 1 STEP -1
    CKSUM=(CKSUM+ASC(MID$(KEA$,N,1)))
    CKR(N)=CKSUM
  NEXT N
  RANDOMIZE CKSUM+PAGE+LNE
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
SUB DECKEY(CG$,LC,RALF0(1),RALF1(1))
  LOCAL BM,BX,CG,CH,CK,CR CT,EC,PL,RL,RLET$
  BX=1:CH=2:CT=2
  FOR GK=1 TO LC
    BX=1+((BX-1) MOD 15)
    CG=ASC(MID$(CG$,GK,1))-32
    SELECT CASE CG
      CASE 0 TO 127:EXIT SELECT
      CASE 128 TO 142:BM=CG-127:CK=1:EXIT SELECT
      CASE=143:GOTO 500
      CASE <0,>143:CG=0
    END SELECT
    IF CH>9 THEN BM=BX:CK=1
    KCHEK:
    IF CK THEN
      IF CH=10 THEN
        IF BM=BX THEN INCR BX:CH=0:CK=0:GOTO 500
        IF BM<>BX THEN INCR BX:CH=0
      END IF
      BX=1+((BX-1) MOD 15)
    END IF
    RL=INT(RND*256)
    PL=(CG XOR RL) MOD 128:INCR CT
    RLET$=CHR$(RALF1(PL))
    IF RL MOD 4=0 THEN RANDOMIZE (RALF0((RND*128)+1)+CT)
    IF CK THEN RLET$="?"
    PUT$ #1,RLET$
    INCR CH
    IF CK THEN KCHEK
  500:NEXT GK
  CG$=""
END SUB
:
SUB DECDISK(CG$,LC,RLF$,RNM$)
  LOCAL BX,CG,CH,CK,CP,CT,EC,PL,RL,R,C,RLET$
  BX=1:CH=1:CT=1:R=4:C=3
  FOR GD=1 TO LC
    BX=1+((BX-1) MOD 15)
    CG=ASC(MID$(CG$,GD,1))-32
    SELECT CASE CG
      CASE 0 TO 127:EXIT SELECT
      CASE 128 TO 142:BM=CG-127:CK=1:EXIT SELECT
      CASE 143:GOTO 501
      CASE <0,>143:CG=0
    END SELECT
    IF CH>9 THEN BM=BX:CK=1
    DCHEK:
    IF CK THEN
      IF CH=10 THEN
        IF INSTAT THEN EXIT SUB
        IF BM=BX THEN INCR BX:CH=0:CK=0:GOTO 501
        IF BM<>BX THEN INCR BX:CH=0
      END IF
      BX=1+((BX-1) MOD 15)
    END IF
    INCR CP
    RL=ASC(MID$(RNM$,CP,1))
    PL=(CG XOR RL) MOD 128:INCR CT
    RLET$=CHR$(ASC(MID$(RLF$,PL+1,1)))
    IF CK THEN RLET$="?"
    LOCATE R,C:PRINT RLET$:PUT$ #1,RLET$
    INCR C:INCR CH:CP=CP MOD 3000
    IF C=79 THEN C=3:INCR R
    R=4+((R-4) MOD 15)
    IF CK THEN DCHEK
  501:NEXT GD
  CG$=""
END SUB
:
DECFLUSH:
  LOCATE 19,1:PRINT CHR$(204):LOCATE 19,2:PRINT BDR$:LOCATE 19,80:PRINT CHR$(185)
  LOCATE 20,3:PRINT"This message is in memory. It can be read in the editor, printed and saved"
  LOCATE 21,3:PRINT"Press ESCape to redo or any other key to flush disk & return to  Main Menu"
  CNT$=INPUT$(1)
  IF ASC(CNT$)=27 THEN MENU
  56:GOSUB BORDER:LOCATE 6,3:PRINT "Deciphering finished. Flushing disk..."
  OPEN FLP2$+"SETNUM" FOR INPUT AS #1:CLOSE
  OPEN FLP2$+"RALF" FOR BINARY AS #1
  DRA$=STRING$(128,0):SEEK #1,(DNO-1)*128:PUT$ #1,DRA$
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
  7:IF RAM$=DR$(11) THEN DRV$="IN MEMORY" ELSE DRV$="ON DRIVE "+RAM$
  GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"EDIT/READ A MESSAGE ";DRV$:COLOR INK,PAPER
  PRINT:FILES RAM$+"\*.*"
  PRINT:PRINT CHR$(186);" Type in name of message to edit/read, or new drive\subdirectory"
  PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
  PRINT:PRINT CHR$(186);:INPUT" Message name: ",NM$:NM$=UCASE$(NM$)
  IF NM$="" THEN RETURN
  IF INSTR(NM$,":") OR INSTR(NM$,"\") THEN RAM$=NM$:GOTO 7
  71:OPEN RAM$+"\"+NM$ FOR INPUT AS #1:CLOSE
  GOSUB EDIT
RETURN
:
EDIT:
  IF FD1 THEN DSK$="PROGRAM":GOSUB WARNDISK
  IF SER THEN GOSUB SETBAUD
  67:OPEN FLP3$+"\EDIT.EXE" FOR INPUT AS #1:CLOSE
  SHELL FLP3$+"\EDIT "+RAM$+"\"+NM$
RETURN
:
RENNA:
  DO
    8:GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"RENAME FILES ON DRIVE ";RAM$:COLOR INK,PAPER
    PRINT:FILES RAM$+"\*.*"
    PRINT:PRINT CHR$(186);" Type in name of file to rename, or new drive\subdirectory"
    PRINT:PRINT CHR$(186);" or press ENTER to return to Main Menu"
    PRINT:PRINT CHR$(186);:PRINT" File name:                                      New name:"
    LOCATE CSRLIN-1,12:INPUT": ",NM$
    IF NM$="" THEN EXIT LOOP
    IF INSTR(NM$,":") OR INSTR(NM$,"\") THEN RAM$=UCASE$(NM$):GOTO 8
    LOCATE CSRLIN-1,59:INPUT": ",NNM$
    IF NNM$="" THEN EXIT LOOP
    81:OPEN RAM$+"\"+NM$ FOR INPUT AS #1:CLOSE
    NAME RAM$+"\"+NM$ AS RAM$+"\"+NNM$
  LOOP
RETURN
:
TRANSFER:
  GOSUB BORDER:LOCATE 5,35:COLOR INKH,PAPERH:PRINT"TRANSFER MENU":COLOR INK,PAPER
  LOCATE 10,29:PRINT"S   : Send/Save on tape"
  LOCATE 12,29:PRINT"R   : Receive from tape"
  LOCATE 14,29:PRINT"D   : Disk directory
  LOCATE 17,29:PRINT"ESC : Return to Main Menu"
  DO
    ESAU$=UCASE$(INPUT$(1))
    IF ASC(ESAU$)=27 OR ASC(ESAU$)=13 THEN RETURN
  LOOP UNTIL ESAU$="R" OR ESAU$="S" OR ESAU$="D"
  IF ESAU$="D" THEN
    GOSUB DIRRA
  ELSEIF ESAU$="S" THEN
    GOSUB SEND
  ELSE
    GOSUB RECEIVE
  END IF
RETURN
:
DIRRA:
  DO
    GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"LIST FILES":COLOR INK,PAPER
    PRINT:PRINT CHR$(186);" Type drive number [\subdirectory] to list files on disk"
    PRINT:PRINT CHR$(186);" or press ENTER to return to Utilities Menu"
    PRINT:PRINT CHR$(186);:INPUT " Drive number: ",NM$
    IF NM$="" THEN EXIT LOOP
    IF INSTR(NM$,":")=0 THEN BF=17:GOTO DIRRA
    991:CLS:SHELL "DIR "+NM$+"\ /P"
    LOCATE 25,1:PRINT "Press any key to continue . . .";
    CNT$=INPUT$(1)
  LOOP
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
    GOSUB BORDER:LOCATE 6,3:PRINT"Sending/saving '";NM$;"'...";:LOCATE ,,1:COLOR INK,PAPER
    LATER#=TIMER+5
    WHILE TIMER<LATER#
    WEND
    OPEN "COM1:300,N,8,1,CS,DS" AS #1
    OPEN RAM$+NM$ FOR BINARY AS #2
    DO UNTIL EOF(2) OR INSTAT
      GET$ #2,1,TAPNM$
      PRINT #1,TAPNM$;
    LOOP
    CLOSE
    IF INSTAT THEN EXIT LOOP
  LOOP
  LOCATE ,,0
RETURN
:
RECEIVE:
  DO
    GOSUB BORDER:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"RECEIVE AN ENCIPHERED MESSAGE FROM TAPE":COLOR INK,PAPER
    LOCATE 4,3:PRINT"Give a name to the message to be received from tape"
    LOCATE 5,3:PRINT"or press ENTER to return to Main Menu"
    LOCATE 7,3:PRINT"The name you give must:"
    LOCATE 9,3:PRINT"- only contain alphabet keys"
    LOCATE 10,3:PRINT"- not be longer than 8 characters"
    LOCATE 11,3:PRINT"- not contain spaces"
    LOCATE 12,3:PRINT"- not have an extension"
    LOCATE 14,3:INPUT"Message name: ",NM$:NM$=UCASE$(NM$)
    IF NM$="" THEN EXIT LOOP
    IF INSTR(NM$," ") THEN BF=9:GOTO ERRA
    IF INSTR(NM$,".") THEN BF=10:GOTO ERRA
    IF LEN(NM$)>8 THEN BF=11:GOTO ERRA
    IF ASC(LEFT$(NM$,1))>47 AND ASC(LEFT$(NM$,1))<58 THEN BF=12:GOTO ERRA
    GOSUB BORDER:BEEP:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"** Ensure modem is on and connected to recorder properly **":COLOR INK,PAPER
    LOCATE 20,3:PRINT"Press any key when ready. ESCape to return to Main Menu"
    CNT$=INPUT$(1)
    IF ASC(CNT$)=27 THEN EXIT LOOP
    GOSUB GETREC
  LOOP
RETURN
:
GETREC:
  92:GOSUB BORDER:BEEP:LOCATE 2,3:COLOR INKH,PAPERH:PRINT"Press PLAY on recorder to transfer '";NM$;"' (ESCape to quit)":COLOR INK,PAPER
  CALL GETTA(NM$,RAM$,DS$)
  CLOSE
  IF INSTAT THEN RETURN
  LOCATE 19,1:PRINT CHR$(204):LOCATE 19,2:PRINT BDR$:LOCATE 19,80:PRINT CHR$(185)
  LOCATE 20,3:PRINT"This message is in memory. It can now be deciphered"
  LOCATE 21,3:PRINT"Press ESCape to redo or any other key to transfer next"
  CNT$=INPUT$(1)
  IF ASC(CNT$)=27 THEN GETREC
RETURN
:
SUB GETTA(NN$,RM$,DX$)
  LOCAL B$,EC,C,R
  OPEN "COM1:300,N,8,1,CS,"+DX$ AS #1
  OPEN RM$+NN$ FOR OUTPUT AS #2
  C=3:R=4
  ON ERROR GOTO 0:ON ERROR GOTO 99
  DO
    98:B$=INPUT$(1,#1)
    99:IF ERR=57 THEN RESUME 98
    IF ASC(B$)=175 THEN INCR EC
    IF ASC(B$)<32 OR ASC(B$)>177 THEN B$=" "
    LOCATE R,C:PRINT B$:PRINT#2,B$;:INCR C
    IF C=79 THEN C=3:INCR R
    R=4+((R-4) MOD 15)
  LOOP UNTIL EC=3 OR INSTAT
  ON ERROR GOTO 0:ON ERROR GOTO ERMESG
END SUB
:
QUITTA:
  DSK$="PROGRAM":GOSUB WARNDISK
  100:OPEN FLP1$+"\TAPCOD.EXE" FOR INPUT AS #1:CLOSE
  CLS:END
RETURN
:
ERRA:
  LOCATE ,,0:GOSUB BORDER:SOUND 88,8:LOCATE 2,3:COLOR INKH,PAPERH
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
    CASE=15:PRINT"** Header missing. Plaintext or un-decipherable message **"
    CASE=16:PRINT"** This message has already been deciphered **"
    CASE=17:PRINT"** Message too long by";LMSG&-27290;"bytes **"
    CASE=18:PRINT"** Wrong data disk or data already used. Change disk or re-encipher **"
  END SELECT
  COLOR INK,PAPER
  LOCATE 4,3:PRINT"Try again"
  LOCATE 20,3:PRINT"Press any key to continue. ESCape to return to Main Menu"
  CLOSE
  CNT$=INPUT$(1)
  IF ASC(CNT$)=27 THEN MENU
  SELECT CASE BF
    CASE=2,3:GOTO GETENCKEY
    CASE=4:GOTO 54
    CASE=5,6,7,8:GOTO NEWDOC
    CASE=9,10,11,12:GOTO RECEIVE
    CASE=13:GOTO SEND
    CASE=1,14:GOTO ENCA
    CASE=15,16:GOTO DECA
    CASE=17,18:GOTO MENU
  END SELECT
:
ERMESG:
  LOCATE ,,0
  IF ERF=ERON THEN RESUME MENU
  REM IF ERR=24 AND ERL=92 THEN RESUME 92
  GOSUB BORDER:SOUND 88,8:LOCATE 2,3:COLOR INKH,PAPERH:NM$=UCASE$(NM$)
  SELECT CASE ERR
    CASE=5
      SELECT CASE ERL
        CASE=53,55:PRINT"** You've tried to decipher an un-enciphered message **"
      END SELECT
    CASE=6:PRINT"** File too long **"
    CASE=7:PRINT"** Out of memory **"
    CASE=24,25,27:PRINT"** Printer/modem off line, not connected or printer out of paper **"
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
        CASE=43:PRINT"** Wrong disk. Replace DATA disk in drive **"
	CASE= 5:PRINT"** There are no messages in memory to decipher **"
	CASE=51:PRINT"** There is no message '";NM$;"' in memory to decipher **"
        CASE=53:PRINT"** Wrong disk. Place DATA disk in drive **"
	CASE=56:PRINT"** Wrong disk. Replace DATA disk in drive **"
	CASE= 7:PRINT"** There are no messages on this disk to edit/read **"
	CASE=71:PRINT"** There is no message '";NM$;"' on this disk to edit/read **"
	CASE= 8:PRINT"** There are no files on this disk to rename **"
	CASE=81:PRINT"** There is no file '";NM$;"' to rename **"
	CASE= 9:PRINT"** There are no messages in memory to send/save on tape **"
	CASE=91:PRINT"** There is no message '";NM$;"' in memory to send/save on tape **"
        CASE=67,100:PRINT"** PROGRAM disk not in drive **"
      END SELECT
      CASE=58:PRINT"** A file with the name you chose already exists **"
      CASE=61:PRINT"** Disk/memory full. Delete files to make space **"
      CASE=70:PRINT"** Disk write-protected. Shift tab to continue **"
      CASE=71:PRINT"** Disk not in drive or door open **"
      CASE=72:PRINT"** Disk corrupted **"
      CASE=75:PRINT"** Path/File access error **"
      CASE=76:PRINT"** Path not found **"
    END SELECT
  COLOR INK,PAPER
  LOCATE 4,3:PRINT"Try again"
  LOCATE 20,3:PRINT"Press any key to continue. ESCape to return to Main Menu"
  LOCATE 23,3:COLOR 26,PAPER:PRINT"Error number: ";ERR:COLOR INK,PAPER
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
    CASE=43:RESUME 43                      'encipher 4
    CASE= 5:RESUME MENU                    'decipher 1
    CASE=51:RESUME DECA                    'decipher 2
    CASE=52:RESUME 52                      'decipher 3
    CASE=53:RESUME 52                      'decipher 4
    CASE=55:RESUME MENU                    'decipher 5
    CASE=56:RESUME 56                      'decipher 6
    CASE= 7:RESUME MENU                    'edit/read 1
    CASE=71:RESUME OLDOC                   'edit/read 2
    CASE=67:RESUME 67                      'editor
    CASE= 8:RESUME MENU                    'rename 1
    CASE=81:RESUME RENNA                   'rename 2
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
  SHELL FLP4$+"\MODE COM1:9600,N,8,1,P"
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
  DO WHILE L<CRS
    I$=INPUT$(1)
    IF L=0 AND PW=0 AND ASC(I$)=13 THEN MENU
    IF K=0 AND ASC(I$)=13 THEN
      LOCATE Y,X:PRINT CHR$(32)
      EXIT LOOP
    END IF
    IF L>0 AND ASC(I$)=8 THEN
      STNG$=LEFT$(STNG$,LEN(STNG$)-1)
      LOCATE Y,X-1:PRINT CHR$(219);" "
      DECR X:DECR L:GOTO 45
    END IF
    IF ASC(I$)<LOLIM OR ASC(I$)>UPLIM THEN SOUND 88,8:GOTO 45
    LOCATE Y,X
    IF L<CRS-1 THEN
      IF PW THEN
        PRINT "*";CHR$(219)
      ELSE
        PRINT I$;CHR$(219)
      END IF
    ELSE
      IF PW THEN
        PRINT "*"
      ELSE
        PRINT I$
      END IF
    END IF
    STNG$=STNG$+I$:INCR L:INCR X
    IF PW THEN
      STNG$=UCASE$(STNG$)
      IF STNG$=PR$ OR STNG$=PF$ THEN RETURN
    END IF
  45:LOOP
RETURN
:
PASSWORD:
  PR$(9)=CHR$(66):PR$(4)=CHR$(66):PR$(1)=CHR$(84):PR$(5)=CHR$(79):PR$(2)=CHR$(73)
  PR$(3)=CHR$(77):PR$(6)=CHR$(66):PR$(8)=CHR$(77):PR$(10)=CHR$(79):PR$(7)=CHR$(73)
  PF$(9)=CHR$(66):PF$(4)=CHR$(66):PF$(1)=CHR$(84):PF$(5)=CHR$(79):PF$(2)=CHR$(73)
  PF$(3)=CHR$(77):PF$(6)=CHR$(66):PF$(8)=CHR$(77):PF$(10)=CHR$(79):PF$(7)=CHR$(73)
  PR$="":PF$="":LR=10:LF=10
  FOR N=1 TO LR:PR$=PR$+PR$(N):NEXT N
  FOR N=1 TO LF:PF$=PF$+PF$(N):NEXT N
  DO
    CLS:LOCATE 12,20:PRINT "ENTER PASSWORD: [               ]"
    LOCATE 12,37:PRINT CHR$(219)
    Y=12:X=37:LOLIM=32:UPLIM=126:CRS=15:GOSUB KEYA
    PSW$=STNG$
    IF PSW$="" THEN CLS:END
    IF PSW$=PR$ OR PSW$=PF$ THEN EXIT LOOP
    SOUND 88,8:PW=1
  LOOP
  IF PSW$=PR$ THEN IMPT=0
  IF PSW$=PF$ AND PF$<>PR$ THEN IMPT=1
  PW=0
RETURN
:
IMPRINT:
  IF VER=0 THEN
    FOR X=1 TO 5
      MS=ASC(MID$(SALF$,89,1)):INCR CP
      RL=ASC(MID$(SNUM$,CP,1))
      CD=(MS XOR RL) MOD 128:INCR CT
      SLET$=CHR$(CD+32)
      PUT$ #1,SLET$
    NEXT X
  ELSE
    FOR X=1 TO 5
      MS=ALPH(88)
      RL=INT(RND*256)
      CD=(MS XOR RL) MOD 128:INCR CT
      SLET$=CHR$(CD+32)
      PUT$ #1,SLET$
      IF RL MOD 4=0 THEN RANDOMIZE (ALPH((RND*128)+1)+CT)
    NEXT X
  END IF
RETURN
