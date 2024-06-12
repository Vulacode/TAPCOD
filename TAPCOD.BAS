$ERROR 	PARAM+,		BOUNDS-, 	NUMERIC-,		OVERFLOW-, 		STACK-
$LIB 		LPT-, 		COM+, 		GRAPH-, 		FULLFLOAT-,  IPRINT-
$OPTION	CNTLBREAK-,					AUTODIM-

CodNM$="TAPCOD"
DEFINT A-Z
$STACK 2048
%TC=-1:%TE=0:%TK=0

$INCLUDE "BIOS.INC"
$INCLUDE "CHKERR.INC"
$INCLUDE "CODSUBS.INC"
$INCLUDE "DOS.INC"
$INCLUDE "KONST.INC"
$INCLUDE "SCROLL.INC"

DIM Salphabet(128),Ralphabet(128)
DIM FileEntry$(140),FileLen&(140),KeyFun$(1:10),DR$(1:8)

OPEN "A:\"+CodNM$+".CNF" FOR INPUT AS #1
FOR L=1 TO 8
	LINE INPUT #1,DR$(L)
NEXT L
CLOSE

CALL SetParams

PW=%TRUE:Jump=0
%NoEnc=1		:%BadName=2	:%NoCopy=3	:%BadPage=4	:%BadLine=5	:%Corrupt=6
%TooLong=7	:%DecDone=8 :%Full=9 		:%NoDir=10	:%Failed=11	:%NoFile=12
%Exists=13

FOR K=1 TO 10
	READ KeyFun$(K)
NEXT K
DATA "Load ","Save ","Del  ","Enc  ","Dec  ","Type ","Read ",Renam,"Xfer ",Quit

CALL PASSWORD
PRINT BORDER$;

MENU:
	DO
		BF=0:M=0:LenBite=10000
		KeyOn=%TRUE:Wild=%TRUE:NoDraw=%FALSE
		Title$="":WhichFiles$="*.*"
		ON ERROR GOTO ERMESG
		IF Jump THEN
			Drive$=RTRIM$(CURDIR$,"\")
			GOTO SkipMenu
		ELSE
			Drive$=RAM$
		END IF
		IF Ver THEN
			Level$=" Disk  Version "
		ELSE
			Level$="Keyword Version"
		END IF
		HL=0:LH=0:XF=%FALSE:XFH=%FALSE:XHL=0
		PRINT TOPLINE$;
		CALL ClearWindow(%TopLeft1,%BottomRight1)
		CALL ClearWindow(%TopLeft3,%BottomRight3)
		COLOR BWYellow,%Cyan:PRINT CENTRE$(2," T A P E   C O D E R ");
		COLOR %Yellow,Paper :PRINT CENTRE$(4,Level$);
		COLOR BWYellow,%Cyan:PRINT CENTRE$(6," MAIN MENU ");
		COLOR ,Paper
		Y=8:X=27
		RESTORE MENU
		FOR ROW=1 TO 13
			LOCATE Y,X
			COLOR %LCyan
			READ MenuItem$:PRINT MenuItem$
			COLOR Ink
			LOCATE Y,X+4
			READ MenuItem$:PRINT MenuItem$
			INCR Y
		NEXT ROW
		DATA F1,": Load files from disk"
		DATA F2,": Save files onto disk"
		DATA F3,": Delete files on disk"
		DATA " "," "
		DATA F4,": Encipher files"
		DATA F5,": Decipher files"
		DATA " "," "
		DATA F6,": Type a new document"
		DATA F7,": Edit/read documents"
		DATA F8,": Rename files"
		DATA F9,": Send & Receive"
		DATA " "," "
		DATA F10,": Quit"
		COLOR %Yellow
		PRINT CENTRE$(23,"  Version 8.16"+SPACE$(47)+"Version: Alt D, K");
		COLOR Ink
		DO
		  DO
				CH$=INKEY$
				IF CH$=CHR$(%Esc) OR CH$=CHR$(%Ent) THEN QUITTA
			LOOP WHILE LEN(CH$)<2
			M=ASC(RIGHT$(CH$,1))
			IF M=32 OR M=37 THEN
				IF M=32 THEN Ver=1:Level$=" Disk  Version "
				IF M=37 THEN Ver=1:Level$="Keyword Version"
				COLOR %Yellow,Paper:PRINT CENTRE$(4,Level$);
			END IF
			SkipMenu:
			IF Jump THEN M=Jump
			SELECT CASE M
				CASE %F1:GOSUB LOADA
				CASE %F2:GOSUB SAVA
				CASE %F3:GOSUB DELLA
				CASE %F4:GOSUB ENCA
				CASE %F5:GOSUB DECA
				CASE %F6:GOSUB NEWDOC
				CASE %F7:GOSUB OLDOC
				CASE %F8:GOSUB RENNA
				CASE %F9:GOSUB TRANSFER
				CASE %F10:GOSUB QUITTA
				CASE %AltF9:GOSUB CONFIG
			END SELECT
		LOOP UNTIL M=>%F1 AND M<=%F10 OR M=%AltF9
	LOOP
:
LOADA:
	Heading$="LOAD FILES INTO MEMORY"
	IF Jump=0 THEN Drive$=DDPath$
	Wild=%FALSE
	CALL DoScreen(Heading$,Title$,WhichFiles$)
	DO
		DO
			NM$=GETNM$(Drive$)
			IF NM$="" THEN RETURN
			IF Drive$=RAM$ THEN
				IF ERRA(%NoCopy) THEN RETURN
			ELSE
				EXIT LOOP
			END IF
		LOOP
		PRINT CLEARLINE$(%SelLine,77,1);
		PRINT "Copying '";NM$;"'...";
		IF LEN(RAM$)=2 THEN OutFile$=RAM$+"\" ELSE OutFile$=RAM$
		SHELL "COPY "+NM$+" "+OutFile$+" > NUL"
		PRINT CLEARLINE$(%SelLine,77,0);
	LOOP
RETURN
:
SAVA:
	Heading$="SAVE FILES IN MEMORY ONTO "
	Drive$=RAM$:OutPath$=DDPath$:Wild=%FALSE
	IF Jump AND RTRIM$(CURDIR$,"\")=Drive$ THEN
		CALL ReScreen("","",WhichFiles$)
	ELSE
		Jump=0
		CALL DoScreen(Heading$,Title$,WhichFiles$)
	END IF
	PRINT FITHEAD$(Heading$,DDPath$);
	DO
		DO
			BF=0
			DO
				CD=%FALSE
				CALL SELECTA(NM$)
				IF NM$="" OR Jump THEN RETURN
				IF MID$(NM$,2,1)=":" THEN
					IF NOT OKDIR(RTRIM$(NM$,"\")) THEN
						BF=%NoDir:EXIT LOOP
					END IF
					CD=%TRUE
					OutPath$=NM$
					PRINT FITHEAD$(Heading$,OutPath$);
				END IF
			LOOP WHILE CD
			IF BF<>%NoDir THEN
				IF OutPath$=RTRIM$(CURDIR$,"\") THEN BF=%NoCopy
				BF=CHECKFILE(NM$)
			END IF
			IF ERRA(BF) THEN RETURN
		LOOP WHILE BF
		DO
			IF INSTR(NM$,"*")=0 AND EXIST(OutPath$,NM$,0) THEN
				Msg$="Overwrite "+OutPath$+"\"+NM$+" ? (Y/N) Yes"
				LOCATE %SelLine,3:PRINT Msg$;SPACE$(77-LEN(Msg$))
				LOCATE %SelLine,LEN(Msg$),1
				SOUND 800,5
				DO
					YN$=UCASE$(INPUT$(1))
				LOOP UNTIL INSTR(YN$, ANY "YN"+CHR$(%Ent)+CHR$(%Esc))
				IF YN$=CHR$(%Esc) THEN LOCATE ,,0:RETURN
				IF YN$="N" THEN
					PRINT CLEARLINE$(%SelLine,77,1);
					EXIT LOOP
				END IF
			ELSE
				IF FileLen&(XHL)>FREESPACE&(OutPath$) THEN
					IF ERRA(%Full) THEN RETURN
					EXIT LOOP
				END IF
			END IF
			PRINT CLEARLINE$(%SelLine,77,0);
			PRINT "Copying '";NM$;"' to '";OutPath$;"\";NM$;"'...";
			IF LEN(OutPath$)=2 THEN OutPath$=OutPath$+"\"
			SHELL "COPY "+NM$+" "+OutPath$+" > NUL"
			PRINT CLEARLINE$(%SelLine,77,1);
			IF INSTR(NM$,"*")=0 THEN
				IF NOT EXIST(OutPath$,NM$,0) THEN
					IF ERRA(%Failed) THEN RETURN
					EXIT LOOP
				END IF
			END IF
		LOOP WHILE BF
	LOOP
RETURN
:
DELLA:
	Heading$="DELETE FILES"
	IF Jump=0 THEN Drive$=DDPath$
	CALL DoScreen(Heading$,Title$,WhichFiles$)
	DO
		NM$=GETNM$(Drive$)
		IF NM$="" THEN RETURN
		PRINT CLEARLINE$(%SelLine,77,1);
		PRINT "Are you sure? (Y/N) Yes"
		LOCATE %SelLine,23
		SOUND 800,5
		DO
			DO
				YN$=UCASE$(INPUT$(1))
			LOOP UNTIL INSTR(YN$, ANY "YN"+CHR$(%Ent)+CHR$(%Esc))
			IF YN$=CHR$(%Esc) THEN RETURN
			PRINT CLEARLINE$(%SelLine,77,1);
			IF YN$="N" THEN EXIT LOOP
			PRINT "Deleting '";NM$;"'...";
			CALL WipeFile(NM$)
			PRINT REFILES$(WhichFiles$);
		LOOP UNTIL INSTR(YN$, ANY "Y"+CHR$(%Ent))
	LOOP
RETURN
:
ENCA:
	Heading$="ENCIPHER FILES (V."+LEFT$(LTRIM$(Level$),1)+")"
	ReEnc:
	CALL DoScreen(Heading$,Title$,WhichFiles$)
	DO
		DO
			BF=0
			NM$=GETNM$(Drive$)
			IF NM$="" THEN RETURN
			IF INSTR(NM$,".ENC") THEN
				IF ERRA(%NoEnc) THEN RETURN ELSE EXIT LOOP
			END IF
			OPEN NM$ FOR INPUT AS #1
			LenMsg&=LOF(1):CLOSE
			MaxLength=29500
			IF LenMsg&>MaxLength THEN
				IF ERRA(%TooLong) THEN RETURN ELSE EXIT LOOP
			END IF
			Agent=VAL(DR$(8)):CKSUM=0:LNE=0:Page=0:KeyOn=%FALSE
			CALL ClearWindow(%TopLeft3,%BottomRight3)
			PRINT CLEARLINE$(%ActLine,60,0);
			IF Ver=0 THEN
				EK$=GETENCKEY$(Page,LNE)
				IF EK$=CHR$(%Esc) THEN
					RETURN
				ELSEIF EK$="" THEN
					EXIT LOOP
				END IF
			ELSE
      	IF WARNDISK(DDPath$,"SETNUM","DATA") THEN RETURN
			END IF
			PRINT CLEARLINE$(%ActLine,77,0);
			PRINT CLEARLINE$(%SelLine,77,0);
			PRINT "Enciphering '";NM$;"'...";
			COLOR Ink+%Flash:PRINT CHR$(219):COLOR Ink
			IF Ver THEN
				SetNum=0:DD$=DISKDATA$(SetNum,"SNUM")
				IF DD$="" THEN
					IF ERRA(%NoData) THEN RETURN ELSE EXIT LOOP
				END IF
				EK$=LEFT$(DD$,26)
			END IF
			CALL MakeAlpha(EK$,Salphabet(),Ralphabet())
			LOCATE %ActLine,3:PRINT "Message length:";LenMsg&;"characters";
			IF INSTR(NM$,".") THEN
				OPEN LEFT$(NM$,(INSTR(NM$,".")-1))+".ENC" FOR BINARY AS #1
			ELSE
				OPEN NM$+".ENC" FOR BINARY AS #1
			END IF
			OPEN NM$ FOR BINARY AS #2
			GET$ #2,LenMsg&,MSG$:CLOSE 2
			IF Ver=0 THEN
				SM$=STRING$(5,176)+CHR$(Page)+CHR$(LNE)
			ELSE
				RANDOMIZE TIMER
				StartRand=INT(RND*128)
				SetHide=StartRand XOR SetNum
				SM$=STRING$(5,177)+CHR$(StartRand+32)+CHR$(SetHide+32)
			END IF
			IF Agent THEN
				RANDOMIZE TIMER
				AgentNo=13+(Agent*20)+INT(RND*20)
				AgentNo$=STRING$(3,AgentNo)
				SM$=AgentNo$+SM$
			END IF
			RANDOMIZE CKSUM
			PUT$ #1,SM$
			SELECT CASE Ver
				CASE 0
					CALL EncVerKW(MSG$,Salphabet(),Ralphabet())
				CASE 1
					CALL EncVerFD(MSG$,DD$,Salphabet())
			END SELECT
			MSG$="":DD$=""
			CLOSE
			IF Ver THEN
				IF NOT EXIST(DDPath$,"SNUM",0) THEN
					IF WARNDISK(DDPath$,"SNUM","DATA") THEN RETURN
				END IF
				CALL DiskFlush(SetNum,"SNUM")
			END IF
			EXIT LOOP
		LOOP
		CALL TidyUp
		PRINT REFILES$(WhichFiles$);
	LOOP
RETURN
:
SUB EncVerKW(MSG$,SALF(),RALF())
	LOCAL BM
	LENMSG=LEN(MSG$)
	$EVENT OFF
	FOR ENC=1 TO LENMSG
		RL=INT(RND*256)
		CH=SALF(ASC(MID$(MSG$,ENC,1)))
		CD=(CH XOR RL) MOD 128
		MOUT$=CHR$(CD+32)
		IF (ENC+2) MOD 10=0 THEN MOUT$=MOUT$+CHR$(160+BM):INCR BM
		PUT$ #1,MOUT$
		IF RL MOD 5=0 THEN RANDOMIZE ENC+RALF(INT(RND*128))
		BM=BM MOD 15
	NEXT ENC
	$EVENT ON
	EM$=STRING$(5,175)
	PUT$ #1,EM$
END SUB
:
SUB EncVerFD(MSG$,SNUM$,SALF())
	LOCAL BM,CP
	LENMSG=LEN(MSG$)
	$EVENT OFF
	FOR ENC=1 TO LENMSG
		RL=ASC(MID$(SNUM$,CP+1,1))
		CH=SALF(ASC(MID$(MSG$,ENC,1)))
		CD=(RL XOR CH) MOD 128
		MOUT$=CHR$(CD+32)
		IF (ENC+2) MOD 10=0 THEN MOUT$=MOUT$+CHR$(160+BM):INCR BM
		PUT$ #1,MOUT$
		CP=ENC MOD 3000:BM=BM MOD 15
	NEXT ENC
	$EVENT ON
	EM$=STRING$(5,175)
	PUT$ #1,EM$
END SUB
:
FUNCTION GETENCKEY$(PAGE,LNE)
	PRINT CLEARLINE$(%SelLine,77,0);
	PRINT "Page No: [   ]    Line No: [  ]    ";
	PRINT "26 Char Key: [                          ]"
	FOR N=1 TO 2
		DO
			BF=0
			IF N=1 THEN
				X=13:CRS=3
			ELSE
				X=31:CRS=2
			END IF
			LOCATE %SelLine,X:PRINT CHR$(219);SPACE$(CRS-1)
			PgLn$=KEYA$(%SelLine,X,48,57,CRS)
			IF PgLn$="" OR PgLn$=CHR$(%Esc) THEN
				GETENCKEY$=PgLn$:EXIT FUNCTION
			END IF
			IF N=1 THEN
				Page=160-VAL(PgLn$)
				IF Page<33 OR Page>159 THEN
					BF=%BadPage
					IF ERRA(BF) THEN GETENKEY$="":EXIT FUNCTION
				END IF
			ELSE
				LNE=160-(VAL(PgLn$)*2)
				IF LNE<34 OR LNE>159 THEN
					BF=%BadLine
					IF ERRA(BF) THEN GETENCKEY$="":EXIT FUNCTION
				END IF
			END IF
		LOOP WHILE BF
	NEXT N
	DO
		X=52:CRS=26
		LOCATE %SelLine,X:PRINT CHR$(219);SPACE$(CRS-1)
		EncKey$=KEYA$(%SelLine,X,32,126,CRS)
		IF EncKey$="" OR EncKey$=CHR$(%Esc) THEN
			GETENCKEY$=EncKey$:EXIT FUNCTION
		END IF
		IF LEN(EncKey$)<>CRS THEN SOUND 88,8
	LOOP UNTIL LEN(EncKey$)=CRS
	RANDOMIZE Page*LNE
	GETENCKEY$=EncKey$
END FUNCTION
:
FUNCTION DISKDATA$(SetNum,DataFile$)
	SHARED DDPath$
	NULL$=STRING$(5,0)
	IF DataFile$="SNUM" THEN
		OPEN DDPath$+"\SETNUM" FOR INPUT AS #1
		INPUT #1,SetNum:CLOSE
		IF SetNum>119 THEN DISKDATA$="":EXIT FUNCTION
	END IF
	DO
		BadKey=%FALSE
		GetPos&=SetNum*3000
		OPEN DDPath$+DataFile$ FOR BINARY AS #1
		SEEK #1,GetPos&:GET$ #1,3000,DD$
		IF INSTR(DD$,NULL$) THEN
			IF DataFile$="SNUM" THEN
				BadKey=%TRUE
				INCR SetNum
				IF SetNum>119 THEN DD$="":EXIT LOOP
			ELSE
				DD$=""
				EXIT LOOP
			END IF
		END IF
	LOOP WHILE BadKey
	CLOSE
	DISKDATA$=DD$
END FUNCTION
:
SUB MakeAlpha(KeyWord$,Salphabet(),Ralphabet())
	SHARED CKSUM
	DIM DYNAMIC ALF(128),Check(26)
	FOR N=1 TO 26
		CKSUM=(CKSUM MOD 26392)+(ASC(MID$(KeyWord$,N,1))*N)
		Check(N-1)=CKSUM
	NEXT N
	FOR N=0 TO 127
		IF N MOD 5=0 THEN RANDOMIZE Check(N/5)
		DO
			CH=INT(RND*128)
		LOOP WHILE ALF(CH)=%TRUE
		ALF(CH)=%TRUE
		Salphabet(N)=(CH)
		Ralphabet(CH)=N
	NEXT N
	ERASE ALF
END SUB
:
SUB DiskFlush(SetNum,DataFile$)
	SHARED DDPath$
	DataLeft$=LTRIM$(STR$(CEIL((((SetNum+1)*3000)/360000)*100)))
	LOCATE %ActLine,3:PRINT "Data disk ";DataLeft$;" per cent used          "
	PRINT CLEARLINE$(%SelLine,77,1);
	PRINT "Wiping used data...";
	OPEN DDPath$+"\"+DataFile$ FOR BINARY AS #1
	SEEK #1,SetNum*3000
	PUT$ #1,STRING$(3000,0)
	CLOSE
	IF DataFile$="SNUM" THEN
		INCR SetNum
		OPEN DDPath$+"\SETNUM" FOR OUTPUT AS #1:PRINT #1,SetNum
	END IF
	CLOSE
END SUB
:
DECA:
	Heading$="DECIPHER FILES"
	ReDec:
	CALL DoScreen(Heading$,Title$,WhichFiles$)
	DO
		NM$=GETNM$(Drive$)
		IF NM$="" THEN RETURN
		GoIn=1:LNE=0:Page=0
		OPEN NM$ FOR BINARY AS #1
		GET$ #1,15,DecVer$:CLOSE
		DO
			DecVer=FINDVER(DecVer$,GoIn,Page,LNE)
			IF DecVer<0 THEN
				IF ERRA(%Corrupt) THEN RETURN ELSE EXIT LOOP
			END IF
			CKSUM=0:GetPos&=0:KeyOn=%FALSE
			CALL ClearWindow(%TopLeft3,%BottomRight3)
			IF DecVer=0 THEN
				PRINT CLEARLINE$(%ActLine,40,0);
				PGLN=GETPGLN(Page,LNE)
				IF PGLN=%FALSE THEN
					IF ERRA(%Corrupt) THEN RETURN ELSE EXIT LOOP
				END IF
				DK$=GETDECKEY$(Page,LNE)
				IF DK$=CHR$(%Esc) THEN
					RETURN
				ELSEIF DK$="" THEN
					EXIT LOOP
				END IF
				PRINT CLEARLINE$(%ActLine,77,0);
				PRINT CLEARLINE$(%SelLine,77,0);
				PRINT "Deciphering '";NM$;"'...";
				COLOR Ink+%Flash:PRINT CHR$(219):COLOR Ink
			ELSEIF DecVer THEN
				LOCATE %ActLine,3:PRINT SPACE$(60)
				IF WARNDISK(DDPath$,"SETNUM","DATA") THEN RETURN
				PRINT TOPLINE$;
				CALL ClearWindow(%TopLeft2,%BottomRight2)
				LOCATE %SelLine,3:PRINT "Deciphering '";NM$;"'. Message reads..."
				SetNum=Page XOR LNE
				IF SetNum<0 OR SetNum>119 THEN
					IF ERRA(%Corrupt) THEN RETURN ELSE EXIT LOOP
				END IF
				DD$=DISKDATA$(SetNum,"RNUM")
				IF DD$="" THEN
					IF ERRA(%DecDone) THEN RETURN ELSE EXIT LOOP
				END IF
				DK$=LEFT$(DD$,26)
			END IF
			CALL MakeAlpha(DK$,Salphabet(),Ralphabet())
			RANDOMIZE CKSUM
			IF INSTR(NM$,".")THEN
				DNM$=LEFT$(NM$,(INSTR(NM$,".")-1))+".DEC"
			ELSE
				DNM$=NM$+".DEC"
			END IF
			OPEN DNM$ FOR BINARY AS #1
			OPEN NM$ FOR BINARY AS #2
			LenCgm&=LOF(2)-GoIn
			LOCATE %ActLine,3
			PRINT "Message length:";INT(LenCgm&-(LenCgm&/11)-3);"characters"
			SEEK #2,GoIn:GET$ #2,LenCgm&,CGM$
			SELECT CASE DecVer
				CASE=0
					CALL DecVerKW(CGM$,Ralphabet())
				CASE=1
					CALL DecVerFD(CGM$,DD$,Ralphabet())
			END SELECT
			CGM$="":DD$=""
			CLOSE
			IF DecVer THEN
				PRINT CLEARLINE$(%SelLine,77,0);
				PRINT "Deciphering finished"
				MSG1$="This message is in memory. It can be read, printed and saved"
				MSG2$="Press any key to wipe data. ESCape for Main Menu"
				RC$=WARNCONT$(MSG1$,MSG2$)
				IF RC$=CHR$(%Esc) THEN RETURN
				IF NOT EXIST(DDPath$,"RNUM",0) THEN
					IF WARNDISK(DDPath$,"RNUM","DATA") THEN RETURN
				END IF
				CALL DiskFlush(SetNum,"RNUM")
			END IF
			EXIT LOOP
		LOOP
		CALL TidyUp
		PRINT REFILES$(WhichFiles$);
	LOOP
RETURN
:
SUB DecVerKW(CGM$,RALF())
	LOCAL BM,Check
	LENCGM=LEN(CGM$)
	BX=1:CH=2:CT=1
	$EVENT OFF
	FOR DEC=1 TO LENCGM
		BX=1+((BX-1) MOD 15)
		CG=ASC(MID$(CGM$,DEC,1))-32
		C$=MID$(CGM$,DEC,1)
		SELECT CASE CG
			CASE 0 TO 127:EXIT SELECT
			CASE 128 TO 142:BM=CG-127:Check=%TRUE:EXIT SELECT
			CASE 143:GOTO 500
			CASE ELSE:CG=0
		END SELECT
		IF CH>9 THEN BM=BX:Check=%TRUE
		ChekKW:
		IF Check THEN
			IF CH=10 THEN
				IF BM=BX THEN INCR BX:CH=0:Check=%FALSE:GOTO 500
				IF BM<>BX THEN INCR BX:CH=0
			END IF
			BX=1+((BX-1) MOD 15)
		END IF
		RL=INT(RND*256)
		PL=(CG XOR RL) MOD 128
		PL$=CHR$(RALF(PL))
		IF Check THEN PL$="?"
		PUT$ #1,PL$
		IF RL MOD 5=0 THEN RANDOMIZE CT+RALF(INT(RND*128))
		INCR CH:INCR CT
		IF Check THEN ChekKW
	500:NEXT DEC
	$EVENT ON
END SUB
:
SUB DecVerFD(CGM$,RNUM$,RALF())
	LOCAL BM,Check,CP
	LENCGM=LEN(CGM$)
	BX=1:CH=2:R=2:C=3
	$EVENT OFF
	FOR DEC=1 TO LENCGM
		BX=1+((BX-1) MOD 15)
		CG=ASC(MID$(CGM$,DEC,1))-32
		SELECT CASE CG
			CASE 0 TO 127:EXIT SELECT
			CASE 128 TO 142:BM=CG-127:Check=%TRUE:EXIT SELECT
			CASE 143:GOTO 600
			CASE ELSE:CG=0
		END SELECT
		IF CH>9 THEN BM=BX:Check=%TRUE
		ChekFD:
		IF Check THEN
			IF INSTAT THEN EXIT SUB
			IF CH=10 THEN
				IF BM=BX THEN INCR BX:CH=0:Check=%FALSE:GOTO 600
				IF BM<>BX THEN INCR BX:CH=0
			END IF
			BX=1+((BX-1) MOD 15)
		END IF
		INCR CP
		RL=ASC(MID$(RNUM$,CP,1))
		PL=(CG XOR RL) MOD 128
		PL$=CHR$(RALF(PL))
		IF Check THEN PL$="?"
		PUT$ #1,PL$
		LOCATE R,C:PRINT PL$
		INCR C:INCR CH:CP=CP MOD 3000
		IF C=79 THEN
			C=3:INCR R
			IF R>15 THEN
				R=15
				CALL Scroll(%TopLeft2,%BottomRight2)
			END IF
		END IF
		IF Check THEN ChekFD
	600:NEXT DEC
	$EVENT ON
END SUB
:
FUNCTION FINDVER(DecVer$,GoIn,Page,LNE)
	LOCAL	Ver0,Ver1,SM
	Ver0=INSTR(DecVer$,STRING$(3,176))
	Ver1=INSTR(DecVer$,STRING$(3,177))
	IF Ver0 THEN
		FINDVER=0:StartMark=176
	ELSEIF Ver1 THEN
		FINDVER=1:StartMark=177
	ELSE
		FINDVER=-1:EXIT FUNCTION
	END IF
	DO
		CharVal=ASC(MID$(DecVer$,GoIn,1)):INCR GoIn
		IF CharVal=StartMark THEN INCR SM
	LOOP UNTIL SM>3 AND CharVal<>StartMark
	Page=CharVal
	LNE=ASC(MID$(DecVer$,GoIn,1))
	IF Ver1 THEN
		DECR Page,32:DECR LNE,32
	END IF
END FUNCTION
:
FUNCTION GETPGLN(Page,LNE)
	Page=160-Page
	LNE=(160-LNE)/2
	IF Page<1 OR Page>127 OR LNE<1 OR LNE>63 THEN
		GETPGLN=%FALSE:EXIT FUNCTION
	ELSE
		GETPGLN=%TRUE
	END IF
	RANDOMIZE Page*LNE
END FUNCTION
:
FUNCTION GETDECKEY$(Page,LNE)
	PRINT CLEARLINE$(%SelLine,77,0);
	PRINT "Page No:";Page;TAB(22);"Line No:";LNE;
	PRINT TAB(38);"26 Char Key: [                          ]"
	DO
		X=52:CRS=26
		LOCATE %SelLine,52:PRINT CHR$(219);SPACE$(CRS-1)
		DecKey$=KEYA$(%SelLine,X,32,126,CRS)
		IF DecKey$="" OR DecKey$=CHR$(%Esc) THEN
			GETDECKEY$=DecKey$:EXIT FUNCTION
		END IF
		IF LEN(DecKey$)<>CRS THEN SOUND 88,8
	LOOP UNTIL LEN(DecKey$)=CRS
	GETDECKEY$=DecKey$
END FUNCTION
:
NEWDOC:
	Heading$="TYPE A NEW DOCUMENT"
	Drive$=RAM$
	NoDraw=%TRUE:KeyOn=%FALSE:Jump=0
	CALL ClearWindow(%TopLeft3,%BottomRight3)
	CALL DoScreen(Heading$,Title$,WhichFiles$)
	LOCATE %SelLine,3,0:PRINT "Document name: [            ]"
	DO
		BF=0:X=19:Y=%SelLine
		LOCATE Y,X:PRINT CHR$(219);SPACE$(11)
		NM$=KEYA$(Y,X,33,126,12)
		IF NM$=CHR$(%Esc) OR NM$="" THEN RETURN
		BF=CHECKNAME(NM$)
		IF ERRA(BF) THEN RETURN
	LOOP WHILE BF
	IF NOT EDIT(RAM$,NM$) THEN RETURN
RETURN
:
OLDOC:
	Heading$="EDIT/READ FILES"
	DO
		CALL DoScreen(Heading$,Title$,WhichFiles$)
		NM$=GETNM$(Drive$)
		IF NM$="" THEN EXIT LOOP
		Path$=RTRIM$(CURDIR$,"\")
		IF NOT EDIT(Path$,NM$) THEN EXIT LOOP
	LOOP
RETURN
:
RENNA:
	Heading$="RENAME FILES"
	Title$=SPACE$(40)+"New name: [            ]"
	CALL DoScreen(Heading$,Title$,WhichFiles$)
	DO
		PRINT TITEL$(Title$);
		NM$=GETNM$(Drive$)
		IF NM$="" THEN RETURN
		DO
			BF=0:X=54
			LOCATE %SelLine,X:PRINT CHR$(219);SPACE$(11)
			NNM$=UCASE$(KEYA$(%SelLine,X,33,126,12))
			IF NNM$=CHR$(%Esc) THEN RETURN
			IF NNM$="" THEN EXIT LOOP
			BF=CHECKNAME(NNM$)
			IF INSTR(NNM$,"*") THEN BF=%BadName
			IF NNM$=NM$ THEN BF=%Exists
			IF ERRA(BF) THEN RETURN
		LOOP WHILE BF
		IF NNM$<>"" THEN
			NAME NM$ AS NNM$
			PRINT REFILES$(WhichFiles$);
		END IF
	LOOP
RETURN
:
TRANSFER:
	Jump=0
	CALL ChPath(RAM$)
	PRINT TOPLINE$
	CALL ClearWindow(%TopLeft1,%BottomRight1)
	CALL ClearWindow(%TopLeft3,%BottomRight3)
	LOCATE 5,34:COLOR BWYellow,%Cyan:PRINT "TRANSFER MENU":COLOR Ink,PAPER
	LOCATE 10,29:COLOR %LCyan:PRINT "S";:COLOR Ink:PRINT "  : Send/Save on tape"
	LOCATE 12,29:COLOR %LCyan:PRINT "R";:COLOR Ink:PRINT "  : Receive from tape"
	LOCATE 14,29:COLOR %LCyan:PRINT "D";:COLOR Ink:PRINT "  : DOS prompt"
	PRINT ESCMAIN$;
	DO
		ESAU$=UCASE$(INPUT$(1))
		IF ESAU$=CHR$(%Esc) OR ESAU$=CHR$(%Ent) THEN RETURN MENU
	LOOP UNTIL ESAU$="R" OR ESAU$="S" OR ESAU$="D"
  IF ESAU$="D" THEN
		GOSUB DOS
  ELSEIF ESAU$="S" THEN
		GOSUB SEND
  ELSE
		GOSUB RECEIVE
  END IF
RETURN
:
SEND:
	Heading$="SEND/SAVE MESSAGES"
	WhichFiles$="*.ENC"
	CALL DoScreen(Heading$,Title$,WhichFiles$)
	ReSend:
	DO
		NM$=GETNM$(Drive$)
		IF NM$="" THEN RETURN
		PRINT CLEARLINE$(%ActLine,40,0);
		CALL ClearWindow(%TopLeft3,%BottomRight3)
		MSG1$="Ensure modem is on and connected (press RECORD button if recording)"
		MSG2$="Press any key to send/save '"+NM$+"'"
		SM$=WARNCONT$(MSG1$,MSG2$)
		IF SM$=CHR$(%Esc) THEN EXIT LOOP
		LOCATE %SelLine,3:PRINT "Sending/Saving '";NM$;"'...";
		COLOR Ink+%Flash:PRINT CHR$(219):COLOR Ink
		LATER#=TIMER+5
		WHILE TIMER<LATER#:WEND
		OPEN "COM1:300,N,8,1,CS,DS" AS #1
		OPEN NM$ FOR BINARY AS #2
		DO UNTIL EOF(2) OR INSTAT
			GET$ #2,1,TAPNM$
			PRINT #1,TAPNM$;
		LOOP
		IF INSTAT THEN
			K$=INKEY$
			CLOSE:EXIT LOOP
		END IF
		CLOSE
		CALL TidyUp
	LOOP
RETURN
:
RECEIVE:
	DO
		PRINT TOPLINE$;
		CALL ClearWindow(%TopLeft1,%BottomRight1)
		CALL ClearWindow(%TopLeft3,%BottomRight3)
		LOCATE 2,3:COLOR BWYellow,%Cyan
		PRINT "RECEIVE AN ENCIPHERED MESSAGE FROM TAPE":COLOR Ink,Paper
		LOCATE 4,3:PRINT "Give a name to the message to be received from tape"
		LOCATE 6,3:PRINT "Message name: [            ]"
		PRINT ESCMAIN$;:COLOR Ink,Paper
		DO
			BF=0:KeyOn=%FALSE:Y=6:X=18:CRS=12
			LOCATE Y,X:PRINT CHR$(219);SPACE$(CRS-1)
			NM$=KEYA$(Y,X,33,126,CRS)
			IF NM$="" OR NM$=CHR$(%Esc) THEN RETURN MENU
			BF=CHECKNAME(NM$)
			IF INSTR(NM$,"*") THEN BF=%BadName
			IF ERRA(BF) THEN RETURN
		LOOP WHILE BF
		SOUND 800,5
		MSG1$="Ensure modem is on and recorder is connected properly"
		MSG2$="Press a key and then press PLAY on recorder"
		RM$=WARNCONT$(MSG1$,MSG2$)
		IF RM$=CHR$(%Esc) THEN RETURN MENU
    GOSUB GETREC
  LOOP
RETURN
:
GETREC:
	Heading$="LOADING TAPED MESSAGE"
	NoDraw=%TRUE:KeyOn=%FALSE
	CALL DoScreen(Heading$,Title$,WhichFiles$)
	DO
		CALL GETTA(NM$,RAM$,AbortStr$)
		IF AbortStr$=CHR$(%Esc) THEN
			RETURN MENU
		ELSEIF AbortStr$<>"" THEN
			RETURN
		END IF
		PRINT CLEARLINE$(%SelLine,77,0);
		PRINT "Message loaded successfully"
		MSG1$="This message is in memory. It can now be deciphered"
		MSG2$="Press 'R' to redo or any other key to transfer next"
		GM$=WARNCONT$(MSG1$,MSG2$)
	LOOP WHILE GM$=UCASE$("R")
	IF GM$=CHR$(%Esc) THEN RETURN MENU
RETURN
:
SUB GETTA(NM$,RAM$,AbortStr$)
	SHARED Ink
	LOCAL EC
	C=3:R=2
	OPEN "COM1:300,N,8,1,CS,DS" AS #1
	OPEN RAM$+"\"+NM$ FOR OUTPUT AS #2
	ON ERROR GOTO 0:ON ERROR GOTO 99
	PRINT CLEARLINE$(%SelLine,77,0);
	PRINT "Receiving '";NM$;"'...";
	COLOR Ink+%Flash:PRINT CHR$(219):COLOR Ink
	CALL ClearWindow(%TopLeft2,%BottomRight2)
	DO
		98:B$=INPUT$(1,#1)
    99:IF ERR=57 THEN RESUME 98
    IF ASC(B$)=175 THEN INCR EC
    IF ASC(B$)<32 OR ASC(B$)>177 THEN B$=" "
		LOCATE R,C:PRINT B$:PRINT #2,B$;:INCR C
		IF C=79 THEN
			C=3:INCR R
			IF R>15 THEN
				R=15
				CALL Scroll(%TopLeft2,%BottomRight2)
			END IF
		END IF
	LOOP UNTIL EC=3 OR INSTAT
	AbortStr$=INKEY$
	ON ERROR GOTO 0:ON ERROR GOTO ERMESG
	CLOSE
END SUB
:
QUITTA:
	Jump=0:KeyOn=%FALSE
	IF WARNDISK(CDPath$,CodNM$+".EXE","PROGRAM") THEN MENU
	CALL ChPath(CDPath$)
	CLS:END
RETURN
:
CONFIG:
	PRINT TOPLINE$;
	CALL ClearWindow(%TopLeft1,%BottomRight1)
	CALL ClearWindow(%TopLeft3,%BottomRight3)
	KeyOn=%FALSE
	RESTORE CONFIG
	FOR N=1 TO 8
		READ ConfigList$
		COLOR %LCyan
		LOCATE N+1,3:PRINT CHR$(N+64);
		COLOR Ink
		PRINT TAB(7);ConfigList$;TAB(36);"-   ";DR$(N);
	NEXT N
	DATA "Colour, B&W or LCD","Default version (KW=0, DD=1)",Path for Tape Coder program
	DATA Path for data/message disk,RAM disk,Path for editor program
	DATA Name of editor program,Operator #
	PRINT HORLINE$;
	LOCATE %SelLine,3:PRINT "Press letter of option to change";TAB(52);
	COLOR %LCyan
	PRINT "S";
	COLOR Ink
	PRINT " - Save changes"
	LOCATE %HeadLine,3:COLOR BWYellow,%Cyan
	PRINT "CHANGE CONFIGURATION":COLOR Ink,Paper
	PRINT ESCMAIN$;
	ReConfig:
	DO
		DO
			LOCATE %SelLine,36
			COLOR Ink+%Flash:PRINT CHR$(219):COLOR Ink
			Choice$=UCASE$(INPUT$(1))
			IF ASC(Choice$)>64 AND ASC(Choice$)<77 THEN
				LOCATE%SelLine,36:PRINT " "
				TempName$=""
				Opt=ASC(Choice$)-64
				Y=Opt+1:X=40
				LOCATE Y,X,1,0,7
				DO
					DO
						Char$=INKEY$
					LOOP WHILE Char$=""
					IF LEN(Char$)=2 THEN
						IF ASC(RIGHT$(Char$,1))=%LfAr THEN
							Char$=CHR$(%Bsp)
						ELSE
							Char$=" "
						END IF
					END IF
					SELECT CASE Char$
						CASE CHR$(%Ent)
							IF TempName$<>"" THEN DR$(Opt)=RTRIM$(TempName$,"\")
							CALL SetParams
							Level=VAL(Level$)-1
							EXIT LOOP
						CASE CHR$(%Esc)
							LOCATE Y,40:PRINT SPACE$(40)
							LOCATE Y,40:PRINT DR$(Opt)
							EXIT LOOP
						CASE CHR$(%Bsp)
							DECR X
							IF X<40 THEN X=40:EXIT SELECT
							LOCATE Y,X:PRINT CHR$(32):LOCATE Y,X
							TempName$=LEFT$(TempName$,LEN(TempName$)-1)
						CASE ELSE
							IF X<78 THEN
								PRINT UCASE$(Char$);SPACE$(39-LEN(TempName$));
								INCR X:LOCATE Y,X
								TempName$=TempName$+UCASE$(Char$)
							ELSE
								SOUND 88,8
							END IF
					END SELECT
				LOOP
				LOCATE ,,0
			END IF
			IF Choice$="S" THEN
				IF WARNDISK(CDPath$,"TAPCOD.CNF","PROGRAM") THEN RETURN
				OPEN CDPath$+"\TAPCOD.CNF" FOR OUTPUT AS #1
				FOR N=1 TO 8
					PRINT #1,DR$(N)
				NEXT N
				CLOSE
			END IF
		LOOP UNTIL Choice$=CHR$(%Esc) OR Choice$=CHR$(%Ent)
		IF Choice$=CHR$(%Esc) OR Choice$=CHR$(%Ent) THEN
			JUMP=0:EXIT LOOP
		END IF
	LOOP
RETURN
:
DOS:
	Jump=0
	COLOR Ink,%Black
	CLS
	PRINT "Type EXIT to return to program..."
	SHELL
	PRINT BORDER$;
RETURN
:
FUNCTION ERRA(BF)
	ERRA=%FALSE
	IF BF=0 THEN EXIT FUNCTION
	SHARED KeyFun$(),KeyOn,LenMsg&,MaxLength
	CLOSE:SOUND 88,8
	SELECT CASE BF
		CASE %BadName	:ERRMSG$="Unacceptable characters in name"
		CASE %NoEnc		:ERRMSG$="You may not re-encipher an enciphered message"
		CASE %BadPage	:ERRMSG$="Unacceptable page number. Acceptable pages: 1 - 127"
		CASE %BadLine	:ERRMSG$="Unacceptable line number. Acceptable lines: 1 - 63"
		CASE %TooLong	:ERRMSG$="Message too long by"+STR$(LenMsg&-MaxLength)+" bytes"
		CASE %Corrupt	:ERRMSG$="Message undecipherable. Plaintext or corrupted file"
		CASE %NoData  :ERRMSG$="Data finished. Start a new DATA disk"
		CASE %DecDone	:ERRMSG$="This message has already been deciphered"
		CASE %Full		:ERRMSG$="Disk full"
		CASE %NoDir		:ERRMSG$="Invalid path"
		CASE %Failed	:ERRMSG$="Copy failed"
		CASE %NoFile	:ERRMSG$="File not found"
		CASE %Exists	:ERRMSG$="File already exists. Choose another name"
	END SELECT
	IF WARNERR(ERRMSG$) THEN
		ERRA=%TRUE:EXIT FUNCTION
	ELSE
		IF KeyOn THEN PRINT FUNKEY$;
	END IF
END FUNCTION
:
ERMESG:
	CLOSE:SOUND 88,8
	SELECT CASE ERR
		CASE 53:ERRMSG$="File not found"
		CASE 58:ERRMSG$="File already exists. Choose another name"
		CASE 61:ERRMSG$="Out of memory/disk full. Delete files to make space"
		CASE 64:ERRMSG$="Invalid name"
		CASE 70:ERRMSG$="Disk write-protected. Switch tab to continue"
		CASE 71:ERRMSG$="Disk not in drive or door open"
		CASE 72:ERRMSG$="Disk corrupted"
		CASE 75:ERRMSG$="Path/File access error"
		CASE 76:ERRMSG$="Path not found"
		CASE ELSE:ERRMSG$="Error number"+STR$(ERR)+" at address"+STR$(ERADR):RR=%TRUE
	END SELECT
	IF WARNERR(ERRMSG$) THEN RESUME MENU
RESUME MENU
:
SUB SetParams SHARED
	StartInk=ASCII(DR$(1))
	SELECT CASE StartInk
		CASE 66
			StartInk=&H0000
			Ink=%HWhite:Paper=%Black:BWYellow=Paper
		CASE 67
			StartInk=&H1000
			Ink=%HWhite:Paper=%Blue:BWYellow=%Yellow
		CASE 76
			StartInk=&H0000
			Ink=%White:Paper=%Black:BWYellow=Paper
	END SELECT
	Level$=DR$(2):CDPath$=DR$(3):DDPath$=DR$(4):RAM$=DR$(5)
	EDPath$=DR$(6):EDProg$=DR$(7)
	Level=VAL(Level$)-1
END SUB
:
FUNCTION WARNCONT$(MSG1$,MSG2$)
	SHARED Ink
	BlinkStars$="**"+SPACE$(LEN(MSG1$)+2)+"**"
	Msg1Pos=((80-LEN(MSG1$))/2)
	COLOR %Red+%Flash
	LOCATE 23,Msg1Pos-3:PRINT BlinkStars$;
	COLOR %Red
	LOCATE 23,Msg1Pos:PRINT MSG1$;
	COLOR Ink
	LOCATE 25,((80-LEN(MSG2$))/2):PRINT MSG2$;
	WARNCONT$=INPUT$(1)
	CALL ClearWindow(%TopLeft3,%BottomRight3)
END FUNCTION
:
SUB PASSWORD SHARED
	Pass$="":PL=10
	DIM PW$(PL)
	PW$(9)=CHR$(66):PW$(4)=CHR$(66):PW$(1)=CHR$(84):PW$(5)=CHR$(79):PW$(2)=CHR$(73)
  PW$(3)=CHR$(77):PW$(6)=CHR$(66):PW$(8)=CHR$(77):PW$(10)=CHR$(79):PW$(7)=CHR$(73)
	FOR N=1 TO PL:Pass$=Pass$+PW$(N):NEXT N
	ERASE PW$
	COLOR Ink,Paper:CLS
	LOCATE 12,20,0:PRINT "ENTER PASSWORD: [               ]"
	DO
		Y=12:X=37
		LOCATE Y,X:PRINT CHR$(219);SPACE$(14)
		PSW$=KEYA$(Y,X,32,126,15)
		IF PSW$="" THEN CLS:END
		PSW$=UCASE$(PSW$)
		IF PSW$=Pass$ THEN EXIT LOOP
		SOUND 88,8
	LOOP
	PW=%FALSE
END SUB
