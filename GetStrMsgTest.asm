		;This program will test the GetStrMsg subroutine which will 
		;recieve a string from the user. This program will count the number 
		; of words entered and the number of spaces entered which will prove 
		; important for another program
		
		;Author: Chris Szafranski 
		;Version: November 1, 2015 
		
		
			
	bdos	equ	5
	boot	equ	0
	strout	equ 9
	charin	equ	1
	charout	equ	2
			org 100h
			lxi sp,stkpt
			mvi	c,strout
			lxi	d,Msg1
			call	bdos
			call	GetMsg
			mov		b,d ;b holds num of words
			mov     a,e ;a holds num of chars
			mvi		c,strout
			lxi		d,SPACE 
			call	bdos
			call	bdos
			call	bdos 
			lxi		d,BUFF1 
			call	bdos
			lxi		d,SPACE 
			call	bdos
			adi		'0'
			mov		e,a ;num of chars
			mvi		c,charout
			call	bdos 
			mov		a,b
			adi		'0'
			mov		e,a
			call	bdos 
			jmp		boot
			
			
			
			
	GetMsg:	;this subroutine will collect a string in buff1
			; will output num of words in str to <D> and chars entered to <E>
			; <de> pair are destoryed. 
			push psw
			push h
			push b 
			lxi	h,BUFF1
			lxi	d,0				;counter in <de> pair for number of words and chars
			mvi	c,charin
	again:
			call	bdos
			cpi		'.'
			jz		endgetmsg
			cpi		'?'
			jz		endgetmsg
			cpi		20h				;20h is ascii for a space
			jz		countspace
			inx		h
			inr		e
			mov		M,a
			jmp		again
	countspace:
			inx		h
			mov		M,a
			inr	d 
			inr	e 
			jmp	again
	endgetmsg: 
			inx	h
			mov	M,a
			
			mvi	a,'$'				;this block will add $ to end of Buff1 
			inx h
			mov	M,a
			
			inr	b 
			mov	a,b 
			pop	b 
			pop	h
			pop	psw 
			ret
	
			
			
			
			
	Msg1: 	db 'Welcome to the program', 0ah,0dh,' $'
	SPACE:	db	' ', 0dh, 0dh, 0ah, '$'
	BUFF1:	ds	40
			ds	10 
	stkpt	equ	$
			end
