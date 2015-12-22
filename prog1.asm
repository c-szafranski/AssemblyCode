;This program will take 8 positive numbers [0-255]
;as input from the user and output the amount 
;of numbers that were greater than 166, between [67-166] 
;and less than 66. 
;Author Chris Szafranski

   bdos     equ    5            ; all CP/M related constants
   boot     equ    0
   sprint   equ    9            ; function number to print a string
   conin    equ    1            ; function number to input a character
   conout   equ    2            ; function number to output a character

            org    100h         ; MUST use this origin always
                                ; it is a CP/M constraint
            lxi    sp,stkpt     ; this is ESSENTIAL if subroutines are used
			mvi		c,sprint 
			lxi 	d,WELCOME	;printing welcome message
			call	bdos
			mvi		b,9
	LOOPING: 
			mvi		a,'-'
			sta		firstin		;each itteration we must reset placeholders
			sta		secondin	;firstin=hundig secondin=tendig thirdin=onedig
			sta		thirdin
			dcr		b			;decrement counter
			jz		DONE
			mvi		c,sprint
			lxi		d,MESS1
			call	bdos
			; print ask for input
			mvi		c,conin
			call	bdos
			cpi		0dh
			jz		COUNTERS
			STA		thirdin
			call	bdos
			cpi		0dh
			jz		COUNTERS
			STA		secondin
			call	bdos
			cpi		0dh
			jz		COUNTERS
			STA		firstin
			call	bdos
			cpi		0dh
			jz		COUNTERS
			jmp		COUNTERS
			 		;jump to looping if non zero
	DONE:
			;finishing code with thankyou message
			lxi		d,BIGMESS
			mvi		c,sprint
			call	bdos
			lxi		d,SPACE
			call	bdos 
			lda		BIGN
			mov		e,a   
			mvi		c, conout
			call	bdos 
			;------------------
			lxi		d,MIDMESS
			mvi		c,sprint
			call	bdos
			lxi		d,SPACE
			call	bdos 
			lda		MIDN
			mov		e,a   
			mvi		c, conout
			call	bdos
			
			;------------------
			lxi		d,SMALLMESS
			mvi		c,sprint
			call	bdos
			lxi		d,SPACE
			call	bdos 
			lda		SMALLN
			mov		e,a   
			mvi		c, conout
			call	bdos
			mvi		c,sprint 
			lxi 	d,THANKYOU
			call 	bdos 
			jmp		boot
			;Subreoutine for handling the incrementation of counters
	COUNTERS:	
			lda		firstin
			cpi		'-'			;if zero hundreds digit was never set
			jz		TWDIG		;jump to two digit routine
			jmp		THDIG
	THDIG:;checking three digit number
			lda		thirdin ;checking if hundreds digit is 2, if so it is bigger than 166 
			cpi		'2'
			jz		BIG 
			lda		secondin ;check tens digit, if its less than 6 its mid, if bigger we must check ones digit
			cpi		'6'
			jm		MID
			jz		MIDCHECK
			jmp		BIG
	MIDCHECK: ;in the case that the hunsdig is 1 and tens dig is 6 we check 
				;the boundery condition
			lda		firstin ;if one's digit is less than 6 it belings in MID 
			cpi		'6'
			jm		MID 
			jz		MID
			jmp		BIG		;else it belongs in big
	TWDIG:;for two digit number 
			lda		secondin ;if second in was not set its a one digit number
			cpi		'-'
			jz		SMAL 
			lda		thirdin ;if tens digit is lest than 6 we increment small counter
			cpi		'6'
			jm		SMAL
			jz		SMACHECK
			jmp		MID
			
	SMACHECK:
			lda	    secondin ;if ones digit is less than 6 we incement small counter 
			cpi		'6'
			jm		SMAL
			jz		SMAL
			jmp		MID 
			
	BIG:	lda		BIGN
			inr		a 		;increment counter for big number
			sta		BIGN
			jmp		LOOPING	;jump to get new number
	MID:	lda		MIDN
			inr		a 		;increment counter for big number
			sta		MIDN
			jmp		LOOPING	;jump to get new number
	SMAL:	lda		SMALLN
			inr		a 		;increment counter for big number
			sta		SMALLN
			jmp		LOOPING	;jump to get new number

WELCOME: 	db 'Welcome to the number reader', 0ah , 0dh, '$'
MESS1: 		db ' 	', 0dh, 0ah, '	Please enter a number: $' 
BIGMESS: 	db ' ', 0ah, '	Numbers bigger than 166: $'
MIDMESS:	db ' ', 0ah, '	Numbers between 166-66: $'
SMALLMESS:	db	' ', 0ah,'	Numbers less than 66: $'
THANKYOU:	db	' 	', 0dh, 0ah, '	Thank you for using the machine ', 0dh, 0ah, '	' 
			db	'Author: Chris Szafranski $'
SPACE:		db	' ', 0dh, 0dh, 0ah, '$'
firstin:	db	'-'
secondin:	db	'-'
thirdin:	db	'-'
SMALLN:		db	'0'
MIDN:		db	'0'
BIGN:		db	'0'
			ds     20           ; reserve 20 bytes for stack
   stkpt    equ    $
            end                 ; assembler directive, not an instruction		 
			
			
			
			
			
