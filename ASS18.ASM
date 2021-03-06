.MODEL SMALL
.STACK 256H

DAT SEGMENT
	INP DB 'ENTER BINARY VALUE: $'
	OUTP DB 'DECIMAL EQUIVALENT VALUE: $'
DAT ENDS

COD SEGMENT
	ASSUME CS:COD, DS:DAT
	MAIN PROC
		MOV AX, DAT
		MOV DS, AX
		MOV AH, 9
		LEA DX, INP
		INT 21H
		CALL GETBINNUM
		MOV AX, BX
		MOV CX, AX
		MOV AH, 9
		LEA DX, OUTP
		INT 21H
		MOV AX, CX
		CALL PRINTINT
		CALL ENDPROG
	MAIN ENDP

	; HEX2DEC PROC
		; MOV BX, AX
		; MOV AX, 0
		; MOV CX, 16
		; LOOP1:
		 ; ROL BX, 1
		; JNC HASNOT
		 ; ADD AX, 1
		; HASNOT:
		; ROL AX, 1
		; LOOP LOOP1
	; HEX2DEC ENDP


	NUM2STRPRINT PROC
		MOV  BX, 10
		MOV  CX, 0
		CYCLE1:
			MOV  DX, 0
			DIV  BX
			PUSH DX
			INC  CX
			CMP  AX, 0
		JNE  CYCLE1
		;NOW RETRIEVE PUSHED DIGITS.
		CYCLE2:
			POP  DX
			ADD  DL, 48 ;CONVERT DIGIT TO CHARACTER.
			MOV AH, 2
			INT 21H
		LOOP CYCLE2
		RET
	NUM2STRPRINT ENDP

	PRINTINT PROC
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		CALL NUM2STRPRINT
		POP DX
		POP CX
		POP BX
		POP AX
		RET
	PRINTINT ENDP

	NLINE PROC
		PUSH DX
		PUSH AX
		MOV DL, 10
		MOV AH, 02H
		INT 21H
		MOV DL, 13
		MOV AH, 02H
		INT 21H
		POP AX
		POP DX
		RET
	NLINE ENDP

	ENDPROG PROC
		MOV AH, 4CH
		INT 21H
	ENDPROG ENDP

	GETBINNUM PROC
		MOV BX, 0
		MOV AX, 0030H
		LOOPGETNUM:
			SUB AL, 30H
			SAL BX, 1
			ADD BL, AL
			MOV AH, 1
			INT 21H
			CMP AL, 0DH ;ENTER KEY PRESSED, EXIT
		JNE LOOPGETNUM
		RET
	GETBINNUM ENDP


END MAIN