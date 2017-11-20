;SHOWN TO SIR
.MODEL SMALL
.STACK 300H
.DATA
STRING1 DB 48H,23H,61H,12H,25H,60H,26H,45H
MSG1 DB "Greater than 40 - $"
MSG2 DB "Smaller than 20 - $"
MSG3 DB "Between 20 and 40 - $"
NUMMIN DB ?
NUMMAX DB ?
NUMMID DB ?
lbk    db 13,10,'$'   ;LINE BREAK.
res db 10 dup('$')


PRINT MACRO MSG
MOV AH, 09H
LEA DX, MSG
INT 21H
;INT 3
ENDM

.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX

START:

LEA SI, STRING1
MOV CX, 08H

MOV BL,14H
MOV AL,28H
MOV BH,[SI]
MOV NUMMIN, 00H
MOV NUMMAX, 00H
MOV NUMMID, 00H

LOOP3: MOV BH,[SI]
	CMP AL, BH
	JG IF11
	INC NUMMAX
	
IF11: CMP BL, BH
	JL IF22
	INC NUMMIN
	
IF22: CMP AL, BH
	JL LABEL3
	CMP BL, BH
	JG LABEL3
	INC NUMMID
	
LABEL3:INC SI
	LOOP LOOP3

;MOV NUMMAX,AH
;MOV NUMMIN,AL

PRINT MSG1
MOV AL, NUMMAX
MOV AH,00H
lea si,res
call hex2dec
lea dx,res	;display the string of numbers from hex
mov ah,9
int 21h

MOV DL,10
MOV AH,02H
INT 21H
MOV DL,13
MOV AH,02H
INT 21H

PRINT MSG2
MOV AL,NUMMIN
MOV AH,00H
lea si,res
call hex2dec
lea dx,res	;display the string of numbers from hex
mov ah,9
int 21h

MOV DL,10
MOV AH,02H
INT 21H
MOV DL,13
MOV AH,02H
INT 21H

PRINT MSG3
MOV AL,NUMMID
MOV AH,00H
lea si,res
call hex2dec
lea dx,res	;display the string of numbers from hex
mov ah,9
int 21h

COMMENT @
	MOV AH,0
	mov AL,NUMMIN
	lea si,res
    call hex2dec
    lea dx,res	;display the string of numbers from hex
    mov ah,9
    int 21h
	@

MOV AH,4CH
INT 21H

MAIN ENDP

hex2dec proc near	;conversion
        mov cx,0
        mov bx,10

loop1: mov dx,0
        div bx
        add dl,30h	;for character
        push dx
        inc cx
        cmp ax,9
        jg loop1

        add al,30h
        mov [si],al

loop2: pop ax
        inc si
        mov [si],al
        loop loop2
        ret
hex2dec endp

END MAIN

