/*
 *	taylor.s
 *  Created on: Dec 10, 2020
 *	Author: Jack Schneiderhan
 *  "I pledge my honor that I have abided by the Stevens Honor System"
 */

 .text
 .global main
 .extern printf
 .data

  x: .long 5			//"accuracy" of the estimation. higher = more accurate
 input: .double 2		//the power you're raising to e

//main method
 main:
 	STR X30, [SP]		//storing x30 to the stack
 	MOV X0, #1			//setting x0 to 1
 	SCVTF D0, X0		//setting a double d0 to 1.0
 	LDR X2, =input		//setting x2 to the input variable (set from above)
  	LDR D1, [X2]		//loading d1 into x2 from the stack
  	SCVTF D2, X0		//setting a double d2 to 1.0
 	LDR X3, =x			//loading x3 into long set at the start
 	LDR X6, [X3]		//loading x6 into x3 on the stack
 	SCVTF D3, X0		//storing D3 for use in factorial
 	SCVTF D5, X0		//storing D5 for us in taylorexp
 	MOV X4, #0			//setting x4 to 0 (use in taylorexp)
 	BL taylorexp		//branch to taylorexp
 	BL end			//branch to finish

//main taylor expansion method
taylorexp:
	CMP X6, X4			//comparing x6 and x4
	BEQ taylorend		//if equal, branch to taylorend
	SUB SP, SP, #16		//subtract 16 bits from the stack pointer
	STR X30, [SP , #0] 	//storing X30 onto the stackpointer as 0
	ADD X4, X4, #1		//increment x4 by 1

//factorial method
fact:
	SCVTF D4, X4		//store D4 as the double version of X4
	FMUL D3, D3, D4		//multiply D3 by D4, simulating factorial

//exponent method
exponent:
	FDIV D4, D2, D3		//divide D3 by D2 and store into D4
	FMUL D5, D5, D1		//multiply D5 and D1
	FMUL D4, D4, D5		//multiply D4 and D5 and store back into D4
	FADD D0, D4, D0		//add D0 and D4 and store into D0 to keep a running sum
	BL taylorexp		//branch back to taylorexp to continue
	BR X30				//branch out to x30

//"break out" part of the taylor expansion method
taylorend:
	LDR X0, =prt_str 	//load x0 into the printed message
	BL printf			//print the printed message
	LDR X30, [SP, #0]	//load x30 as 0 onto the stack pointer, since printf alters
	BR X30				//branch to x30

//printing the string
prt_str:
    .ascii "The approximation is %f\n\0"	//the printed message
	.end
