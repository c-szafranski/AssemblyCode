	;This program will test backspacing when a user enters incorrect 
	;char, it will also collect chars entered and print them out
	;swag

	;Author: Chris Szafranski
	;Version: November 12, 2015
	
	
	bdos	equ	5	;all CP/M related variables 
	boot	equ	0
	strout	equ 9
	charin	equ	1
	charout	equ	2
			org 100h
			lxi sp,stkpt 
			lxi h, Buff1 ;welcome message 
			lxi d, msg1
			mvi c,strout 
			call bdos 
	again:
			mvi c, charin
			call bdos 
			cpi 0dh
			jz done
			cpi 30h
			jm fix
			cpi 40h ;so that we can accept 9 as input
			jp fix
			mov M,a 
			inx h
			jmp again 
	fix:;This is where the user input will be corrected 
			mvi c,charout
			mvi e, 8h ;backspace char
			call bdos
			mvi e, 20h ;space                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
			call bdos
			mvi e, 8h ;backspace again 
			call bdos
			jmp again
	done:
			inx h
			mvi a, '$'
			mov M,a 
			mvi c, strout
			lxi d,SPACE
			call bdos
			lxi d, Buff1
			call bdos 
			lxi d,donemsg
			call bdos 
			jmp boot
	SPACE:		db	' ', 0dh, 0dh, 0ah, '$'
	donemsg: db ' ', 0ah,0dh,'Done :) ', 0ah,0dh,' $'
	Msg1: 	db  ' ', 0ah,0dh,'Welcome ', 0ah,0dh,' $'
	SPACE:	db	' ', 0dh, 0dh, 0ah, '$'
	BUFF1:	ds	100
			ds	10 
	stkpt	equ	$
			end
				
