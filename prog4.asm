;This program is a simple calulator that accepts 16 bit inputs and 
;can add or subract them 
;negative numbers are not supported, but negative solutions are 

	
	;Author; Chris Szafranski 
	;Version: 11/29/2015 
	
	
	bdos	equ	5
	boot	equ	0
	strout	equ 9
	charin	equ	1
	charout	equ	2
					org 100h
			lxi sp,stkpt 
			
			lxi h,0h 
			lxi d, msg1
			mvi c,strout 
			call bdos 
			
	anotherone:	
			
			call get1In ;hl should hold 16 bit number ;<a> holds operator 
			push d
			mov b,a ;b will hold operator 
			push h ;first input held in stack 
			call get2In
			pop d ;d is holding first number 
			cpi '-'
			jz callSub
			cpi '+'
			jz callAdd ;saves appropriete operations in hl pair 
			jmp out0
		callSub:
			call subtraction 
			jmp out0
		callAdd: 
			call addition
			jmp out0
		out0:
			call printNum
			;---------------
			mvi e, 0dh 
			mvi c, charout 
			call bdos 
			mvi e, 0ah 
			call bdos 
			pop d 
			pop d 
			pop d 
			lxi h,0h ;clearing all registers before getting next input 
			lxi d, 0h 
			lxi b,0h 
			mvi a,0h 
			jmp anotherone 
			

	fin:		
			mvi c, strout 
			lxi d,donemsg
			call bdos 
			jmp boot

;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------			
			;Subroutine for fixing user input 
fix:
			push d 
			push b 
			push d
		
			mvi c,charout
			mvi e, 8h ;backspace char
			call bdos
			mvi e, 20h ;space                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
			call bdos
			mvi e, 8h ;backspace again 
			call bdos
			
			pop b 
			pop d 
			
			ret
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
;GetInput will get user inputed characters and build them into a decimal value 
; to be stored in <HL> pair 
;also the operator value is stored in <a> 

	get1In:
		
		push b
		push d 
		
		lxi h, 0h 		;clearing registers 
		lxi d, 0h		;clearing 
		
	next:
		
		mvi c, charin 
		call bdos 
		cpi 0dh 
		jz fin
		cpi '+' ;check operator is entered 
		jz exit
		cpi '-' ;check if '-' opeerator is entered 
		jz exit 
		cpi 30h
		jm callfix
		cpi 40h ;so that we can accept 9 as input
		jp callfix
		jmp skipfix
	callfix:
		call fix 
		jmp next
	skipfix:	
		sui 30h 
		call multiTen ;multiply hl by ten 
		mov e,a 		;mov a into e 
		dad d			;add previous entry 
		
		jmp next 
	
	exit:
		
		pop d 
		pop b  
		ret 
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
;Get2In will get user inputed characters and build them into a decimal value 
; to be stored in <HL> pair 


	get2In:
		push psw 
		push b
		push d 
		
		lxi h, 0h 		;clearing registers 
		lxi d, 0h		;clearing 
		
	next2:
		
		mvi c, charin 
		call bdos 
		cpi '=' ;check operator is entered 
		jz exit2
		sui 30h 
		jm call2fix
		cpi 40h ;so that we can accept 9 as input
		jp callfix
		jmp skip2fix
	call2fix:
		call fix 
		jmp next2
	skip2fix:
		
		call multiTen ;multiply hl by ten 
		mov e,a 		;mov a into e 
		dad d			;add previous entry 
		
		jmp next2 
	
	exit2:
		
		pop d 
		pop b 
		pop	psw 
		ret 
		
		
		
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------				
	multiTen:
		;this subroutine will multiply what is in <hl> by ten 
		push psw 
		push b
		push d 
		lxi d, 0h 
		 
		dad h ; times two
		
		push h 
		pop d 
		
		dad h ;time four 
		
		dad h ;time eight
		
		dad d ;add two more we get times ten 
		
		pop d 
		pop b 
		pop psw 
		ret 
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
	printNum:
		;this subroutine will print the number in <hl> pair
		;for now it will print just the binary decimal numbers 
		push psw
		push b
		push d 
		push h 
		mov a,b 
		cpi 1h 
		jz printNeg
		jmp callprintDig 
	printNeg:
		mvi e, '-'
		mvi c, charout
		call bdos 
		jmp callprintDig
	callprintDig: 
		
		lxi b, 10000d ;this number denotes the value of the digit printed 
		call printDig
		lxi b, 1000d ;now print thousands digit 
		call printDig
		lxi b, 100d ; hundreds digit 
		call printDig 
		lxi b, 10d
		call printDig
		lxi b, 1d
		call printDig
		
		
		pop h 
		pop d 
		pop b 
		pop psw 
		ret
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
; subroutine print1: to print the most significant digit
; One can repeatedly call the subrotine with different values in BC to print all the digits
; input: H-L= value, B_C= weight of the position (say, 1000)
; output: prints the most significant digit, H-L= the rest of value
; registers destroyed: none (except H-L)
printDig:	push psw	; Save A/Flags
			push b 
			push d 
			
		
		mvi e, '0'	; Move char 0 into E
rdo:	
		call S16B	; Do 16 bit subtraction
	
		mov a, h	;
		cpi 80h		;
		jnc skp		;
		
		inr E		; E = E + 1
		
		jmp rdo		;
skp:	dad B		; HL + BC into HL

		mov a, e	;
		cpi '0'		;
		jz chkD		;
		mvi d, 10	;
		mvi C, 2	;
		call bdos	;
		jmp dne		;
chkD:	mov a, d	;
		cpi 1d		;
		jz dne		;
		mvi c, 2	; Print E
		call bdos	;

dne:	
		pop d
		pop b 
		pop psw		;
		
		ret			; Done printing, return to main
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
		
	S16B: ;subtracts ,bc> from <hl>
		push psw 
		push b 
		push d 
		mov a, l 
		sub c
		mov l,a 
		mov a,h
		sbb b 
		mov h, a
		pop d 
		pop b 
		pop psw 
		ret 
		
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
		addition: 
		push psw 
		push b 
		
		dad d ;adds first number to second 
	
		pop b 
		pop psw 
		ret
;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
;subroutine subtracts two 16 bit numbers but will
; alway return a poitive number because the two numbers are
;switched so that the lesser number is subtracted 
;from the gretaer 
;<de> is holding first number , <hl> holds second number 
	subtraction: 

		push psw 
		push d 
		
		lxi b,0h 	; setting booleans to zero 
		mov a,d 
		cmp h 
		jm switch 	; if flag set, second number is bigger than first 
		jnz subIt
		
		mov a,e 
		cmp l 
		jm switch 
		jmp subIt
	subIt:	
		mov a, e 
		sub l 
		mov l,a 
		mov a,d 
		sbb h 
		mov h, a
		jmp subdone 		
	switch:
		mvi b,1h ;setting boolean to true to indicate a negative value should be printed 
			push h 
			push d 
			pop h 
			pop d 
			jmp subIt
			
subdone:	
		pop d 
		
		pop psw 
		ret

;----------------------------------------------------------------------------------
;----------------------------------------------------------------------------------
			
	SPACE:		db	' ', 0dh, 0dh, 0ah, '$'
	donemsg: db ' ', 0ah,0dh,'Thank you ', 0ah,0dh,' $'
	Msg1: 	db  ' ', 0ah,0dh,'Welcome to the tiny calculator!', 0ah,0dh,' $'
	Msg2: 	db  ' ', 0ah,0dh,'', 0ah,0dh,' $'
	debugmsg: db ' ', 0ah,0dh,'Fixing... ', 0ah,0dh,' $'
	SPACE:	db	' ', 0dh, 0dh, 0ah, '$'

			ds	40 
	stkpt	equ	$
			end
				
