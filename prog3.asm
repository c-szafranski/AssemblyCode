	;This program will accept user inputted chars and count 
	; how many times digits [0-9] appear 
	; the program will not allow users to enter any other chars other than
	;digits 
	
	;Author; Chris Szafranski 
	;Version: 11/10/2015 
	
	
	bdos	equ	5 ;setting variables 
	boot	equ	0
	strout	equ 9
	charin	equ	1
	charout	equ	2
			org 100h
			lxi sp,stkpt 
			mvi b, 10d 
			lxi h, Buff
			lxi d, msg1
			mvi c,strout 
			call bdos 
			lxi d, loading 
			call bdos 
			lxi h, Buff 
	loadingIT: 
			;After encountering issues with running the code mulitple times
			;I notices mem loctations set in a previous run are not re-set,
			;so i have to do it here explicitly 
			mvi a, 0d 
			mov M,a 
			inx h 
			dcr b 
			jnz loadingIT  
			
			
			lxi d, ready  ;ready message 
			call bdos 
			lxi h, Buff 
	again:  
			mvi c, charin
			call bdos 
			cpi 0dh
			jz done	
			cpi 30h
			jm fix
			cpi 40h ;so that we can accept 9 as input
			jp fix				
			call recordCount  ; asci char sitting in <a>
			jmp again 
	fix:
			mvi c,charout
			mvi e, 8h ;backspace char
			call bdos
			mvi e, 20h ;space                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
			call bdos
			mvi e, 8h ;backspace again 
			call bdos
			jmp again
	done:  
			mvi c, strout 
			
			lxi d,space 
			call bdos 
			mvi a, 0 
	printHist:
			call printOneLine ;subroutine that handles one line of Xs 
			inr a 
			cpi 10
			jz finish 
			jmp printHist 
			;call readMem
	finish:		
			lxi d,donemsg
			call bdos 
			jmp boot
			
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
	printOneLine: 
				push psw
				push h 
				push d
				push b 
				adi '0' 
				mov e, a 
				mvi c, charout 
				call bdos 
				mvi e,':'
				call bdos 
				sui '0'
				
				call printX ;subroutine dedicated to printing Xs 
				
				lxi d, space 
				mvi c, strout 
				call bdos 
				
				pop b 
				pop d 
				pop h 
				pop psw 
				ret 
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------				
	printX: 	;This is a dedicated subroutine to printing Xs 
				; equal to the number of Xs in the counter stored in memory 
				push psw
				push h 
				push d
				push b 
				lxi h, BUFF 
				cpi 0 
				jz here  
		pMove:
				inx h 
				dcr a 
				jnz pMove
		here:		
				mov a, M
				mvi e, 'X'
				mvi c, charout 
		printIt: 
				cpi 0 
				jz pdone
				call bdos 
				dcr a 
				jz pdone 
				jmp printIt 
		pdone:	
				pop b 
				pop d 
				pop h 
				pop psw 
				ret 
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
	recordCount:;input from <a> 
				push h
				push d
				push b
				lxi h, BUFF 
				sui '0'  ; convert from ascii 
				cpi 0h ;compare with 0 if zero we're in the right place
				jz store
		moveTo: 
				inx h ;increment hl 
				dcr a ;decrement a which keeps track of how many positions we moved through 
				jz store ;if negative we hit our position (accounting for zero) 
				jmp moveTo 
		store:  
				mov a,M ;now we increment counter in memory 
				inr a 
				mov M,a
				
				pop b 
				pop d 
				pop h 
				ret
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
		readMem:
				push h 
				push d 
				push b 
				mvi b, 10d 
				lxi h, BUFF  
				mvi c,charout 
				
		nextChar:
				mov a,M  
				adi '0' 
				mov e,a 
				call bdos 
				inx h 
				dcr b 
				jnz nextChar
				
				pop b 
				pop d
				pop h 
				ret 
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
			
	SPACE:		db	' ', 0dh, 0dh, 0ah, '$'
	loading: db ' ', 0ah,0dh,'Loading...', 0ah,0dh,' $'
	ready: db ' ', 0ah,0dh,'Ready! Enter some keystrokes: ', 0ah,0dh,' $'
	donemsg: db ' ', 0ah,0dh,'Thank you for using the keystroke machine ', 0ah,0dh,' $'
	Msg1: 	db  ' ', 0ah,0dh,'Welcome to the keystroke histogram machine!', 0ah,0dh,' $'
	SPACE:	db	' ', 0dh, 0dh, 0ah, '$'
	BUFF:	db 0d,0d,0d,0d,0d,0d,0d,0d,0d,0d
			ds	20 
	stkpt	equ	$
			end
				
