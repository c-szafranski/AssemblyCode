; Program will insert a word into a user entered string 
; in a specified location
; 
; this program handles '?' chars but not inserting at front of string 
;Author:  Chris Szafranski 
;Version: Oct 31, 2015 


	bdos	equ	5 ;setting variables 
	boot	equ	0
	strout	equ 9
	charin	equ	1
	charout	equ	2
			org 100h
			lxi sp,stkpt
			mvi	c,strout
			lxi	d,Msg1
			call	bdos
			lxi	d,Msg2
			call	bdos
			call	GetMsg ;<d> is holding the word count <e> hold char count
			push	d		;<de> pushed to stack
			lxi	d,Msg3
			call bdos
			call getWord
			mvi	c,strout
			lxi d,Msg4
			call bdos
			pop		d
			mov	a,d 
			push d 
			call getNum	;<a> is holding insert location
			mvi	c,strout
			lxi	d,Msg5
			call bdos
			pop d
			mov	b,e ;b holds char count
			call	BuildString
			lxi	d,Msg6
			mvi		c,strout
			call	bdos 
			jmp boot 
BuildString: ;input from <a> and <b> register 
				;<b> holds char count 
				;<a> holds the location into which we will insert 
			push	psw
			push b 
			push d 
			push h
			lxi h,Buff1			;moving buff1 mem location to <hl>
			mov	d,a ;d now holds insert location
			;cpi		0
			;jz   inAtFront ;not implemented due to bugs 
			
	Sagain: 
			mvi c,charout 
			mov a,M 
			mov e,a
			inx h 
			call bdos  ;checking if sentence is complete 
			cpi '.'
			jz done	
			cpi '?'
			jz done 	
			cpi ' '
			jz decCount
			jmp Sagain  
	DecCount: 
			dcr	d 
			jz insert
			jmp Sagain
	
	insert:	push d		;removed pop b 
			push	h
			mvi	e,' ' ;extra space 
			mvi	c,charout
			call bdos 
			lxi d,Buff2
			mvi 	c,strout 
			call bdos 
			pop h 
			pop d 
			jmp Sagain 
	
	sdone:
			pop h
			pop d 
			pop b 
			pop psw 
			ret 
			
			


GetWord:	;this subroutine will get one word from user and store 
				;it in Buff2
				; subroutine will stop getting input if space char is 
				;entered or if <CR> is pressed
				;no resgisters destroyed
			push psw
			push h
			push d
			push b 
			lxi	h,BUFF2
			mvi	c,charin
	Wagain:
			call	bdos
			cpi		0dh 
			jz		endgetword
			cpi		' '
			jz 		endgetword
			inx		h
			mov		M,a
			jmp		Wagain
	endgetword: 
			inx	h
			mov	M,a
			
			mvi	a,'$'				;this block will add $ to end of Buff1 
			inx h ;deleted incrementation
			mov	M,a
			
			pop psw
			pop	b 
			pop d 
			pop	h
			ret
	
GetNum:	;input from <a> output to <a> no registers destroyed besides <a> and flags 
			push h
			push d
			push b 
			mov	b,a					;move the word count to <b>
			mvi	c,charin
	Nagain:
			call	bdos			;get a number
			cpi		0dh 			;is it <CR>
			jz		endgetnum
			cpi		' '				;no spaces in numbers
			jz 		endgetnum
			; something wil go herer
			;jmp		again 		;not working with this because we dont store the first value somewhere
	endgetnum: 
			sui	'0'					;make it a digit
			cmp	b 					;greater than word count?
			jm	ndone				;if not jmp done
			mov	a,b 
	ndone:		
			pop	b 
			pop d 
			pop	h
			ret
			
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
	Msg2: 	db ' ', 0ah,0dh,'Enter a sentence (ends in period or question mark): ', 0ah,0dh,' $'
	Msg3: 	db ' ', 0ah,0dh,'Enter a word to insert: ', 0ah,0dh,' $'
	Msg4: 	db ' ', 0ah,0dh,'Enter an insert location: ', 0ah,0dh,' $'
	Msg5: 	db ' ', 0ah,0dh,'New sentence:  ', 0ah,0dh,' $'
	Msg6: 	db  ' ', 0ah,0dh,'Done  ', 0ah,0dh,' $'
	SPACE:	db	' ', 0dh, 0dh, 0ah, '$'
	BUFF1:	ds	40
	BUFF2:	ds	20 
			ds	10 
	stkpt	equ	$
			end
