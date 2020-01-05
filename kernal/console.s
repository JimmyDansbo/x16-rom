;----------------------------------------------------------------------
; VERA Console Library
;----------------------------------------------------------------------
; (C)2020 Michael Steil, License: 2-clause BSD

.include "../regs.inc"
.include "../mac.inc"
.include "../io.inc"
.include "../banks.inc"

.import screen_set_mode
.import GRAPH_set_window
.import GRAPH_put_char
.import GRAPH_move_rect
.import GRAPH_draw_rect
.import GRAPH_get_char_size
.import GRAPH_draw_image
.import col1, col2, col_bg
.import leftMargin, windowTop, rightMargin, windowBottom

.import kbd_get

.import sprite_set_image, sprite_set_position

bsout = $ffd2

.export console_init, console_put_char, console_get_char, console_put_image

.segment "KVARSB0"

bufsize  = 80

; XXX outbuf may run into inbuf, but there is no check yet
; XXX whether it overruns that one
outbuf:	.res 80
inbuf:	.res bufsize+1 ; (+ trailing CR)

outbufidx:
	.res 1
inbufidx:
	.res 1
style:
	.res 1
baseline:
	.res 1
override_height:
	.res 2

px:	.res 2
py:	.res 2

.segment "CONSOLE"

;---------------------------------------------------------------
; console_init
;
; Function:  Initializes the console.
;---------------------------------------------------------------
console_init:
	KVARS_START

	jsr GRAPH_set_window

	lda #$0f ; ISO mode
	jsr bsout

	stz outbufidx
	stz style
	stz inbuf
	stz inbufidx
	stz override_height
	stz override_height+1

	lda #147 ; clear screen
	clc
	jsr console_put_char
	lda #$92 ; attribute reset
	clc
	jsr console_put_char

	KVARS_END
	rts

; fallthrough

;---------------------------------------------------------------
; console_put_char
;
; Function:  Prints a character to the console.
;
; Pass:      a   ASCII character
;            c   0: character wrapping, 1: word wrapping
;
; Note:      If C is 1, the text will be word-wrapped. For this,
;            characters will be buffered until a SPACE, CR or LF
;            character is printed. So to flush the buffer at the
;            end, make sure to print SPACE, CR or LF.
;            If C is 0, character wrapping and therefore no
;            buffering is performed.
;---------------------------------------------------------------
; XXX * preserve r0-r3!
; XXX * update override_height at least once every time the font
; XXX   is changed
console_put_char:
	KVARS_START

	bcc @flush
	cmp #' '
	beq @flush
	cmp #10
	beq @flush
	cmp #13
	beq @flush

	ldy outbufidx
	sta outbuf,y
	inc outbufidx

	KVARS_END
	rts
	
@flush:
	pha

; measure word
	lda outbufidx
	beq @no_x_overflow
	MoveW px, r3 ; start with x pos
	ldy #0
:	lda outbuf,y
	phy
	ldx style
	jsr GRAPH_get_char_size
	ply
	bcc @1    ; control character?
	stx style ; yes: update style
	bra @2    ;      and don't add any width
@1:	stx r2L
	stz r2H
	AddW r2, r3 ; add width to x pos
@2:	iny
	cpy outbufidx
	bne :-

	CmpW r3, rightMargin
	bcc @no_x_overflow

	MoveW px, r0
	MoveW py, r1
	jsr new_line
	MoveW r0, px
	MoveW r1, py

@no_x_overflow:
	jsr scroll_maybe

	MoveW px, r0
	MoveW py, r1

	lda outbufidx
	beq @l1

	ldy #0
:	lda outbuf,y
	phy
	jsr GRAPH_put_char
	ply
	iny
	cpy outbufidx
	bne :-

	stz outbufidx

@l1:	pla
	pha
	jsr GRAPH_put_char
	bcc :+ ; did fit, skip

; character wrapping
	jsr new_line
	MoveW r0, px
	MoveW r1, py
	jsr scroll_maybe
	MoveW px, r0
	MoveW py, r1

	pla
	jsr GRAPH_put_char
	jmp @l2

:	pla
@l2:	MoveW r0, px
	MoveW r1, py

	KVARS_END
	rts

; preserves r0, r1, r2
scroll_maybe:
	jsr get_font_size
	sty r14L
	inc r14L
	stz r14H ; font height + 1
scroll_if_less_than_r14_pixels:
	MoveW windowBottom, r15
	SubW r14, r15
	CmpW py, r15
	bcs :+
	rts

:	PushW r0
	PushW r1
	PushW r2
	
	MoveW r14, r6
	AddVW 2, r6 ; scrollAmount = font height + 2

; scroll
	; source x = leftMargin
	MoveW leftMargin, r0
	; source y = windowTop + scrollAmount
	MoveW windowTop, r1
	AddW r6, r1
	; target x = leftMargin
	MoveW leftMargin, r2
	; target y = windowTop
	MoveW windowTop, r3
	; width = rightMargin - leftMargin + 1
	MoveW rightMargin, r4
	SubW leftMargin, r4
	IncW r4
	PushW r4 ; we need it again later
	; height = windowBottom - windowTop - scrollAmount + 1
	MoveW windowBottom, r5
	SubW windowTop, r5
	SubW r6, r5
	IncW r5
	jsr GRAPH_move_rect

; fill
	; x = leftMargin
	MoveW leftMargin, r0
	; y = windowBottom - scrollAmount + 1
	MoveW windowBottom, r1
	SubW r6, r1
	IncW r1
	; width = rightMargin - leftMargin + 1
	PopW r2 ; take result from before
	; height = scrollAmount
	MoveW r6, r3
	; corner radius
	LoadW r4, 0

	PushB col1
	PushB col2
	lda col_bg  ; draw with bg color
	sta col1
	sta col2
	sec
	jsr GRAPH_draw_rect
	PopB col2
	PopB col1

	SubW r6, py
	
	PopW r2
	PopW r1
	PopW r0
	
	rts

;---------------------------------------------------------------
; console_put_image
;
; Function:  Draw an image in GRAPH_draw_image format at the
;            current cursor position and advance the cursor.
;
; Pass:      r0   image pointer
;            r1   width
;            r2   height
;---------------------------------------------------------------
console_put_image:
	KVARS_START

	PushW r0
	PushW r1
	PushW r2

	lda #0
	clc
	jsr console_put_char
	
	PopW r2
	PopW r1
	PopW r0

	MoveW r2, r14
	jsr scroll_if_less_than_r14_pixels

	MoveW r2, override_height

	MoveW r2, r4
	MoveW r1, r3
	MoveW r0, r2
	MoveW px, r0
	MoveW py, r1

	; get baseline
	jsr get_font_size
	sta r5L

	; subtract baseline
	lda r1L
	sec
	sbc r5L
	sta r1L
	bcs :+
	dec r1H
:
	jsr GRAPH_draw_image

	AddW r3, px ; advance cursor by image width

	KVARS_END
	rts

new_line:
	lda override_height
	ora override_height+1
	beq @1

	; check whether override_height > font height + 1
	jsr get_font_size
	tya
	inc
	sec
	sbc override_height
	lda #0
	sbc override_height+1
	bcs @1 ; font is higher -> regular newline

	; newline, but advance override_height vertically
	PushW r1
	lda #10
	jsr GRAPH_put_char
	PopW r1
	AddW override_height, r1
	bra @2

	; regular newline
@1:	lda #10
	jsr GRAPH_put_char
	
@2:	stz override_height
	stz override_height+1
	rts

get_font_size:
	ldx #0
	lda #' '
	jsr GRAPH_get_char_size
	rts

;---------------------------------------------------------------
; console_get_char
;
; Return:    a   ASCII character
;
; Note: This function returns a character from the keyboard.
;       It will buffer characters until a CR or LF is received
;       and then return the buffer character by character.
;       The last character to be sent is a CR code.
;       Editing the buffer allows deleting the last character
;       using BS/DEL, but no cursor movement or other control
;       characters.
;---------------------------------------------------------------
console_get_char:
	KVARS_START

	lda inbuf
	beq @input_line
	jmp @return_char

@input_line:
	lda #$92 ; attribute reset
	clc
	jsr console_put_char
	stz style

; get height + baseline
	jsr get_font_size
	sta baseline

; create sprite
	tya     ; character height
	inc     ; cursor is 1 pixel higher
	asl
	sta r0L ; cursor height * 2

	; color map
	ldx #32
:	stz inbuf,x     ; 0: black, 1: white
	dex
	bpl :-
	; transparency map
	ldx #0
	lda #%10000000; 0: transparent, 1: opaque
:	sta inbuf+32,x
	inx
	stz inbuf+32,x
	inx
	cpx r0L
	bne :-
@l1:	cpx #32
	bcs @s2
	stz inbuf+32,x
	inx
	bra @l1
@s2:	LoadW r0, inbuf
	LoadW r1, inbuf+32
	LoadB r2L, 1 ; 1 bpp
	ldx #16      ; width
	ldy #16      ; height
	lda #1       ; sprite 1
	sec          ; apply mask
	jsr sprite_set_image

@input_loop:
	MoveW px, r0
	MoveW py, r1

; position cursor
	PushW r0
	PushW r1
	IncW r0
	lda r1L
	sec
	sbc baseline
	sta r1L
	lda r1H
	sbc #0
	sta r1H
	lda #1
	jsr sprite_set_position
	PopW r1
	PopW r0

; N.B.: We're accepting both PETSCII control codes (CR, DEL)
;       and ASCII control codes (LF, BS), so this would work
;       with both kinds of input drivers.
@again:	jsr kbd_get
	beq @again
	cmp #8   ; ASCII BACKSPACE
	beq @b2
	cmp #$14 ; PETSCII DELETE
	bne :+
@b2:	jmp @backspace
:	cmp #10
	beq @input_end
	cmp #13
	beq @input_end
	cmp #$20
	bcc @again
	cmp #$80
	bcc @ok
	cmp #$a0
	bcc @again
@ok:	ldx inbufidx
	cpx #bufsize
	beq @again
	pha
	jsr GRAPH_put_char
	MoveW r0, px
	MoveW r1, py
	pla
	bcs @again ; out of bounds, didn't print
	ldx inbufidx
	sta inbuf,x
	inc inbufidx
	jmp @input_loop

@input_end:
	ldx inbufidx
	lda #13
	sta inbuf,x ; store CR
	stz inbufidx

	clc
	jsr console_put_char ; print CR

	; disable cursor
	LoadB r0H, $ff
	lda #1
	jsr sprite_set_position

@return_char:
	ldx inbufidx
	lda inbuf,x
	cmp #13
	bne :+
	stz inbufidx
	stz inbuf
	bra @end
:	inc inbufidx

@end:	KVARS_END
	rts

; Tipp-Ex
@backspace:
	ldx inbufidx
	bne :+
	jmp @again ; empty buffer
:
	; kill character
	dex
	stx inbufidx
	
	; character to delete
	lda inbuf,x
	pha

	; r2L = width
	ldx #0
	jsr GRAPH_get_char_size
	stx r2L

	; r0 = r0 - width
	lda r0L
	sec
	sbc r2L
	sta r0L
	lda r0H
	sbc #0
	sta r0H
	
	plx ; character
	PushW r0
	PushB col1
	lda col_bg
	sta col1
	txa
	jsr GRAPH_put_char
	PopB col1
	PopW r0

	MoveW r0, px
	MoveW r1, py

	jmp @input_loop