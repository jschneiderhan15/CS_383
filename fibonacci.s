/*
 * fibonacci.s
 *
 *  Created on: Nov 2, 2020
 *	Author: Jack Schneiderhan
 *  "I pledge my honor that I have abided by the Stevens Honor System"
 */

 .text
 .global main
 .extern printf
 .data
 .equ input, 4 		//changing the number after input changes the #th fib number you get

fib:
	SUB SP, SP, #16
	STR X30, [SP, #0]	//store return address
	CMP X10, X0			//if the input is 1
	B.EQ L1				//jump to the L1
	MOV X12, X9			//x12 is a temp holder for the previous number
	MOV X9, X1			//set previous number to be the current number
	ADD X1, X1, X12 	//X1 is now the next fib number (current + previous)
	SUB x0, x0, #1		//subtract input by 1, signifying the number changing
	BL fib				//loop back up to the start of fib
	LDR X30, [SP, #0]	//restore return address
	ADD SP, SP, #16 	//pop from stack
	BR X30				//return to caller

main:
 	MOV x0, #input		//x0 holds the input (the xth fib #)
	CMP x0, #1			//checks for input < 1
	BLT print_err		//jumps to the error print
 	MOV x9, #0			//x9 holds 0, used to check later
 	MOV x10, #1 		//x10 holds previous number, default is 1
 	MOV x1, #1 			//x1 holds the current number, default is 1
 	BL fib
L1:	LDR X0, =string
	BL printf
	ADD SP, SP, #16		//clear the stack frames
	BR X30				//return to caller

print_err:
	LDR X3, =eString
	BL printf
	BR X30

eString:
	.ascii "Error: Value given must be greater than 0. \n\0"

string:
	.ascii "Fibonacci Number is %d \n\0" //formatting for the output string

