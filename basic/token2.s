	.byt "TAB",$a8
tabtk	=$a3
	.byt "T",$cf
totk	=$a4
	.byt "F",$ce
fntk	=$a5
	.byt "SPC",$a8
spctk	=$a6
	.byt "THE",$ce
thentk	=$a7
	.byt "NO",$d4
nottk	=$a8
	.byt "STE",$d0
steptk	=$a9
	.byt $ab
plustk	=$aa
	.byt $ad
minutk	=$ab
	.byt $aa
	.byt $af
	.byt $de
	.byt "AN",$c4
	.byt "O",$d2
	.byt 190
greatk	=$b1
	.byt $bd
equltk	=$b2
	.byt 188
lesstk	=$b3
	.byt "SG",$ce
onefun	=$b4
	.byt "IN",$d4
	.byt "AB",$d3
	.byt "US",$d2
	.byt "FR",$c5
	.byt "PO",$d3
	.byt "SQ",$d2
	.byt "RN",$c4
	.byt "LO",$c7
	.byt "EX",$d0
	.byt "CO",$d3
	.byt "SI",$ce
	.byt "TA",$ce
	.byt "AT",$ce
	.byt "PEE",$cb
	.byt "LE",$ce
	.byt "STR",$a4
	.byt "VA",$cc
	.byt "AS",$c3
	.byt "CHR",$a4
lasnum	=$c7
	.byt "LEFT",$a4
	.byt "RIGHT",$a4
	.byt "MID",$a4
	.byt "G",$cf
gotk	=$cb
	.byt 0

;**************************************
reslst2	.byt "MO", 'N' + $80
	.byt "DO", 'S' + $80
	.byt "OL", 'D' + $80
	.byt "GEO", 'S' + $80
	.byt "VPOK", 'E' + $80
	.byt "VLOA", 'D' + $80
	.byt "SCREE", 'N' + $80
	.byt "PSE", 'T' + $80
	.byt "LIN", 'E' + $80
	.byt "FRAM", 'E' + $80
	.byt "REC", 'T' + $80
	.byt "CHA", 'R' + $80
	.byt "MOUS", 'E' + $80
	.byt "COLO", 'R' + $80
	.byt "TES", 'T' + $80
	.byt "RESE", 'T' + $80
	.byt "CL", 'S' + $80
	.byt "CODE", 'X' + $80
	.byt "LOCAT", 'E' + $80
	.byt "BOO", 'T' + $80
	.byt "KEYMA", 'P' + $80
	.byt "BLOA", 'D' + $80
	.byt "BVLOA", 'D' + $80
	.byt "BVERIF", 'Y' + $80
	.byt "BAN", 'K' + $80
	.byt "FMINI", 'T' + $80
	.byt "FMNOT", 'E' + $80
	.byt "FMDRU", 'M' + $80
	.byt "FMINS", 'T' + $80
	.byt "FMVI", 'B' + $80
	.byt "FMFRE", 'Q' + $80
	.byt "FMVO", 'L' + $80
	.byt "FMPA", 'N' + $80
	.byt "FMPLA", 'Y' + $80
	.byt "FMCHOR", 'D' + $80
	.byt "FMPOK", 'E' + $80
	.byt "PSGINI", 'T' + $80
	.byt "PSGNOT", 'E' + $80
	.byt "PSGVO", 'L' + $80
	.byt "PSGWA", 'V' + $80
	.byt "PSGFRE", 'Q' + $80
	.byt "PSGPA", 'N' + $80
	.byt "PSGPLA", 'Y' + $80
	.byt "PSGCHOR", 'D' + $80
	.byt 0 ; keep this last
	; The division between reslst2 and reslst3 is arbitrary, but the order
	; must be maintained. Parser will check all of reslst2 and then
	; continue onward with checking entries in reslst3.
	; realst2 is very close to max length.
reslst3	
	.byt "REBOO", 'T' + $80
	.byt "POWEROF", 'F' + $80
	.byt "I2CPOK", 'E' + $80
	.byt "SLEE", 'P' + $80
	.byt "BSAV", 'E' + $80
	.byt "MEN", 'U' + $80
	.byt "RE", 'N' + $80
	.byt "LINPUT", '#' + $80
	.byt "LINPU", 'T' + $80
	.byt "BINPUT", '#' + $80
	.byt "HEL", 'P' + $80
	.byt "BANNE", 'R' + $80
	.byt "EXE", 'C' + $80
	.byt "TIL", 'E' + $80
	.byt "EDI", 'T' + $80
	.byt "SPRIT", 'E' + $80
	.byt "SPRME", 'M' + $80
	.byt "MOVSP", 'R' + $80
	.byt "BASLOA", 'D' + $80
	.byt "OVA", 'L' + $80
	.byt "RIN", 'G' + $80
	.byt "HBLOA", 'D' + $80

	; add new statements before this line

	; functions start here
	.byt "VPEE", 'K' + $80
	.byt "M", 'X' + $80
	.byt "M", 'Y' + $80
	.byt "M", 'B' + $80
	.byt "JO", 'Y' + $80
	.byt "HEX", $a4
	.byt "BIN", $a4
	.byt "I2CPEE", 'K' + $80
	.byt "POINTE", 'R' + $80
	.byt "STRPT", 'R' + $80
	.byt "RPT", '$' + $80
	.byt "MWHEE", 'L' + $80
	.byt "TDAT", 'A' + $80
	.byt "TATT", 'R' + $80

	; add new functions before this line
	.byt 0

.assert reslst3 - reslst2 < 256, error, "<--- See line number. Too many bytes in reslst2 section. Keep the ordering of the statements but move one of the declarations from the end of reslst2 to the beginning of reslst3.  Keep the .byt 0 as the final entry of reslst2."
.assert * - reslst3 < 256, error, "<--- See line number. Too many bytes in reslst3 section."
;**************************************

err01	.byt "TOO MANY FILE",$d3
err02	.byt "FILE OPE",$ce
err03	.byt "FILE NOT OPE",$ce
err04	.byt "FILE NOT FOUN",$c4
errfnf  = 4
err05	.byt "DEVICE NOT PRESEN",$d4
errnp	=5
err06	.byt "NOT INPUT FIL",$c5
err07	.byt "NOT OUTPUT FIL",$c5
err08	.byt "MISSING FILE NAM",$c5
err09	.byt "ILLEGAL DEVICE NUMBE",$d2
err10	.byt "NEXT WITHOUT FO",$d2
errnf	=10
err11	.byt "SYNTA",$d8
errsn	=11
err12	.byt "RETURN WITHOUT GOSU",$c2
errrg	=12
err13	.byt "OUT OF DAT",$c1
errod	=13
err14	.byt "ILLEGAL QUANTIT",$d9
errfc	=14
err15	.byt "OVERFLO",$d7
errov	=15
err16	.byt "OUT OF MEMOR",$d9
errom	=16
err17	.byt "UNDEF",$27
	.byt "D STATEMEN",$d4
errus	=17
err18	.byt "BAD SUBSCRIP",$d4
errbs	=18
err19	.byt "REDIM",$27,"D ARRA",$d9
errdd	=19
err20	.byt "DIVISION BY ZER",$cf
errdvo	=20
err21	.byt "ILLEGAL DIREC",$d4
errid	=21
err22	.byt "TYPE MISMATC",$c8
errtm	=22
err23	.byt "STRING TOO LON",$c7
errls	=23
err24	.byt "FILE DAT",$c1
errbd	=24
err25	.byt "FORMULA TOO COMPLE",$d8
errst	=25
err26	.byt "CAN",$27,"T CONTINU",$c5
errcn	=26
err27	.byt "UNDEF",$27,"D FUNCTIO",$ce
erruf	=27
err28	.byt "VERIF",$d9
ervfy	=28
err29	.byt "LOA",$c4
erload	=29

; table to translate error message #
; to address of string containing message
;
errtab	.word err01
	.word err02
	.word err03
	.word err04
	.word err05
	.word err06
	.word err07
	.word err08
	.word err09
	.word err10
	.word err11
	.word err12
	.word err13
	.word err14
	.word err15
	.word err16
	.word err17
	.word err18
	.word err19
	.word err20
	.word err21
	.word err22
	.word err23
	.word err24
	.word err25
	.word err26
	.word err27
	.word err28
	.word err29
	.word err30
	.word err31
	.word err32
	.word err33
	.word err34
	.word err35
	.word err36
	.word err37
	.word err38
	.word err39
	.word err40

okmsg	.byt $d,"OK",$d,$0
err	.byt " ERROR",0
intxt	.byt " IN ",0
reddy	.byt $d,"READY.",$d,0
erbrk	=30
brktxt	.byt $d
err30	.byt "BREAK",0,$a0 ;shifted space
err31	.byt "NOT GRAPHICS MOD", 'E'+$80
errngm	=31
err32	.byt "CHANNE", 'L'+$80
erchan	=32
err33	.byt "INSTRUMEN", 'T'+$80
erinst	=33
err34	.byt "OCTAV", 'E'+$80
eroct	=34
err35	.byt "VOLUM", 'E'+$80
ervol	=35
err36	.byt "DRU", 'M'+$80
erdrum	=36
err37	.byt "DEPT", 'H'+$80
erdep	=37
err38	.byt "FREQUENC", 'Y'+$80
erfrq	=38
err39	.byt "PA", 'N'+$80
erpan	=39
err40	.byt "MACHINE CAPABILIT", 'Y'+$80
errmc	=40

forsiz	=$12
fndfor	tsx
	inx
	inx
	inx
	inx
ffloop	lda 257,x
	cmp #fortk
	bne ffrts
	lda forpnt+1
	bne cmpfor
	lda 258,x
	sta forpnt
	lda 259,x
	sta forpnt+1
cmpfor	cmp 259,x
	bne addfrs
	lda forpnt
	cmp 258,x
	beq ffrts
addfrs	txa
	clc
	adc #forsiz
	tax
	bne ffloop
ffrts	rts
bltu	jsr reason
	sta strend
	sty strend+1
bltuc	sec
	lda hightr
	sbc lowtr
	sta index
	tay
	lda hightr+1
	sbc lowtr+1
	tax
	inx
	tya
	beq decblt
	lda hightr
	sec
	sbc index
	sta hightr
	bcs blt1
	dec hightr+1
	sec
blt1	lda highds
	sbc index
	sta highds
	bcs moren1
	dec highds+1
	bcc moren1
bltlp	lda (hightr),y
	sta (highds),y
moren1	dey
	bne bltlp
	lda (hightr),y
	sta (highds),y
decblt	dec hightr+1
	dec highds+1
	dex
	bne moren1
	rts
getstk	asl a
	adc #numlev+numlev+16
	bcs omerr
	sta index
	tsx
	cpx index
	bcc omerr
	rts
reason	cpy fretop+1
	bcc rearts
	bne trymor
	cmp fretop
	bcc rearts
trymor	pha
	ldx #8+addprc
	tya
reasav	pha
	lda highds-1,x
	dex
	bpl reasav
	jsr garba2
	ldx #248-addprc
reasto	pla
	sta highds+8+addprc,x
	inx
	bmi reasto
	pla
	tay
	pla
	cpy fretop+1
	bcc rearts
	bne omerr
	cmp fretop
	bcs omerr
rearts	rts
