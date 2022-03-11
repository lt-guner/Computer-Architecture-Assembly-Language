TITLE Proj1_gunert     (Proj1_gunert.asm)

; Author: Timur Guner
; Last Modified: 2021-04-10
; OSU email address: gunert@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: Project 1                Due Date: 2021-04-18
; Description: This project asks the user to enter 3 positive integers in descending order. If the user does not enter the 3 positive integers in descending order, It will display an error message.
;			   Once all three numbers are entered, the program shows arithmetic between the three numbers for addition, subtraction, negative subtraction, and quotient and remainders. Once the
;			   calculations are complete, the user will be assked if they would like to do the arithmetic program again.

INCLUDE Irvine32.inc

.data
		intro_1			BYTE		"Simple Arithmetic by Timur Guner", 0																					;A string used to show the program name
		instruct_1		BYTE		"You will be prompted to entered three positive integers. Please enter them in descending order (A > B > C).", 0		;A string used to show the user intrustion for the inputs
		prompt_1		BYTE		"Enter the first number? ", 0																							;Asks user for the first input																		
		var_a			DWORD		?																														;Variable used to store the first input
		prompt_2		BYTE		"Enter the second number? ", 0																							;Asks user for the second input
		var_b			DWORD		?																														;Variable used to store the second input
		prompt_3		BYTE		"Enter the third number? ", 0																							;Ask user for the third input
		var_c			DWORD		?																														;Variable used to store second outpur
		add_symbol		BYTE		" + ",0																													;Used when printing the equations
		dif_symbol		BYTE		" - ",0																													;Used when printing the equations
		equal_sign		BYTE		" = ",0																													;Used when printing the equations
		div_symbol		BYTE		" / ",0																													;Used when printing the equations
		q_symbol		BYTE		"Q ",0																													;Used to symbolize quotient
		r_symbol		BYTE		" R ",0																													;Used to symbolize remainser
		a_plus_b		DWORD		?																														;Variable to store a + b
		a_minus_b		DWORD		?																														;Variable to store a - b
		a_plus_c		DWORD		?																														;Variable to store a + c
		a_minus_c		DWORD		?																														;Variable to store a - c
		b_plus_c		DWORD		?																														;Variable to store b + c
		b_minus_c		DWORD		?																														;Variable to store b - c
		a_plus_bc		DWORD		?																														;Variable to store a + b + c
		outp_1			BYTE		"Here are the solutions for the additions, subtractions, and division/mod of the three variables", 0					;A string to the user to let them know they are about to see the solutions
		outp_add		BYTE		"Addition Solutions",0																									;A string to state that we are showing the addition solutions
		outp_sub		BYTE		"Subtraction Solutions",0																								;A string to state that we are showing the substraction solutions
		outp_neg		BYTE		"Subtraction Solutiuons with Negative Answers (B-A, C-A, C-B, and C-B-A for extra credit)",0							;A string to state that we are showing the negative solutions from subtractions
		outp_div		BYTE		"Division Solutions to Show the Quotient(Q) and Remainder(R) (A/B, A/C, B/C for extra credit)",0						;A string to state that we are showing the quotient and remainder
		outro_1			BYTE		"Thank you for using Simple Arithmetic, goodbye!",0																		;A goodbye string
		b_minus_a		SDWORD		?																														;Variable to store b-a
		c_minus_a		SDWORD		?																														;Variable to store c-a
		c_minus_b		SDWORD		?																														;Variable to store c-b
		c_minus_ba		SDWORD		?																														;Variable to store c-b-a
		a_div_b			DWORD		?																														;Variable to store a / b quotient
		a_rem_b			DWORD		?																														;Variable to store a / b remainder
		a_div_c			DWORD		?																														;Variable to store a / b quotient
		a_rem_c			DWORD		?																														;Variable to store a / b remainder
		b_div_c			DWORD		?																														;Variable to store a / b quotient
		b_rem_c			DWORD		?																														;Variable to store a / b remainder
		repeat_p		BYTE		"Please enter 1 if you would like to do this again (extra credit loop to continue)? ",0									;Ask user if they want to do another caluation
		y_n				DWORD		?																														;Answer for repeating the loop 1 to continue
		error_p			byte		"You did not enter the nummbers in descending order (extra credit checks for descending order inputs)",0				;Display to user that they did not enter the variables in descending order

.code
main PROC
;Introduce program and instructions
		MOV		edx, OFFSET intro_1
		CALL	WriteString
		CALL	CrLf
		CALL	CrLf
		MOV		edx, OFFSET instruct_1
		CALL	WriteString
		CALL	CrLf
		CALL	CrLf

_Repeat_User_Arithemtic:
;Gather the user inputs
		MOV		edx, OFFSET prompt_1
		CALL	WriteString
		CALL	ReadDec
		MOV		var_a, eax
		MOV		edx, OFFSET prompt_2
		CALL	WriteString
		CALL	ReadDec
		MOV		var_b, eax
		MOV		eax, var_a
		MOV		ebx, var_b
		CMP		eax, ebx
		JLE		_User_Error
		MOV		edx, OFFSET prompt_3
		CALL	WriteString
		CALL	ReadDec
		MOV		var_c, eax
		MOV		eax, var_b
		MOV		ebx, var_c
		CMP		eax, ebx
		JLE		_User_Error
		CALL	CrLf

;Do the calculations for sums, differences, and div / mod of the three variables

		;A + B calculation
		MOV		eax, var_a
		MOV		ebx, var_b
		ADD		eax, ebx
		MOV		a_plus_b, eax

		;A - B calculation
		MOV		eax, var_a
		MOV		ebx, var_b
		SUB		eax, ebx
		MOV		a_minus_b, eax

		;A + C calculation
		MOV		eax, var_a
		MOV		ebx, var_c
		ADD		eax, ebx
		MOV		a_plus_c, eax

		;A - C calculation
		MOV		eax, var_a
		MOV		ebx, var_c
		SUB		eax, ebx
		MOV		a_minus_c, eax

		;B + C calculation
		MOV		eax, var_b
		MOV		ebx, var_c
		ADD		eax, ebx
		MOV		b_plus_c, eax

		;B - C calculation
		MOV		eax, var_b
		MOV		ebx, var_c
		SUB		eax, ebx
		MOV		b_minus_c, eax

		;A + B + C calculation
		MOV		eax, var_a
		MOV		ebx, var_b
		ADD		eax, ebx
		MOV		a_plus_bc, eax
		MOV		eax, a_plus_bc
		MOV		ebx, var_c
		ADD		eax, ebx
		MOV		a_plus_bc, eax

		;B - A calculation
		MOV		eax, var_b
		MOV		ebx, var_a
		SUB		eax, ebx
		MOV		b_minus_a, eax

		;C - A Calculation
		MOV		eax, var_c
		MOV		ebx, var_a
		SUB		eax, ebx
		MOV		c_minus_a, eax

		;C - B Calculation
		MOV		eax, var_c
		MOV		ebx, var_b
		SUB		eax, ebx
		MOV		c_minus_b, eax

		;C - B - A calculation
		MOV		eax, var_c
		MOV		ebx, var_b
		SUB		eax, ebx
		MOV		c_minus_ba, eax
		MOV		eax, c_minus_ba
		MOV		ebx, var_a
		sub		eax, ebx
		MOV		c_minus_ba, eax

		;A / B to get quotient and remainder
		MOV		eax, var_a
		MOV		edx, 0
		MOV		ebx, var_b
		DIV		ebx
		MOV		a_div_b, eax
		MOV		a_rem_b, edx

		;A / C to get quotient and remainder
		MOV		eax, var_a
		MOV		edx, 0
		MOV		ebx, var_c
		DIV		ebx
		MOV		a_div_c, eax
		MOV		a_rem_c, edx

		;B / C to get quotient and remainder
		MOV		eax, var_b
		MOV		edx, 0
		MOV		ebx, var_c
		DIV		ebx
		MOV		b_div_c, eax
		MOV		b_rem_c, edx

;Shows the solutions for the three variables
	
		;Display a sentence to let the use know the solutions are going to be printed
		MOV		edx, OFFSET outp_1
		CALL	WriteString
		CALL	CrLf
		CALL	CrLf

		;The following section is to displays the addition solutions
		;display the addtion solutions title
		MOV		edx, OFFSET outp_add
		CALL	WriteString
		CALL	CrLf
	
		;A + B Output
		MOV		eax, var_a
		CALL	WriteDec
		MOV		edx, OFFSET add_symbol
		CALL	WriteString
		MOV		eax, var_b
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		eax, a_plus_b
		CALL	WriteDec
		CALL	CrLf
	
		;A + C Output
		MOV		eax, var_a
		CALL	WriteDec
		MOV		edx, OFFSET add_symbol
		CALL	WriteString
		MOV		eax, var_c
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		eax, a_plus_c
		CALL	WriteDec
		CALL	CrLf
	
		;B + C Output
		MOV		eax, var_b
		CALL	WriteDec
		MOV		edx, OFFSET add_symbol
		CALL	WriteString
		MOV		eax, var_c
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		eax, b_plus_c
		CALL	WriteDec
		CALL	CrLf
	
		;A + B + C Output
		MOV		eax, var_a
		CALL	WriteDec
		MOV		edx, OFFSET add_symbol
		CALL	WriteString
		MOV		eax, var_b
		CALL	WriteDec
		MOV		edx, OFFSET add_symbol
		CALL	WriteString
		MOV		eax, var_c
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		eax, a_plus_bc
		CALL	WriteDec
		CALL	CrLf
		CALL	CrLf

		;The following section is to displays the subtraction solutions
		;Show the title of the selection for subtraction solutions
		MOV		edx, OFFSET outp_sub
		CALL	WriteString
		CALL	CrLf

		;A - B Output
		MOV		eax, var_a
		CALL	WriteDec
		MOV		edx, OFFSET dif_symbol
		CALL	WriteString
		MOV		eax, var_b
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		eax, a_minus_b
		CALL	WriteDec
		CALL	CrLf

		;A - C Output
		MOV		eax, var_a
		CALL	WriteDec
		MOV		edx, OFFSET dif_symbol
		CALL	WriteString
		MOV		eax, var_c
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		eax, a_minus_c
		CALL	WriteDec
		CALL	CrLf

		;B - C Output
		MOV		eax, var_b
		CALL	WriteDec
		MOV		edx, OFFSET dif_symbol
		CALL	WriteString
		MOV		eax, var_c
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		eax, b_minus_c
		CALL	WriteDec
		CALL	CrLf
		CALL	CrLf

		;The following section is to displays the negative subtraction solutions for extra credit
		;Show the title of the selection for negative subtraction solutions
		MOV edx, OFFSET outp_neg
		CALL WriteString
		CALL CrLf

		;B - A Output
		MOV		eax, var_b
		CALL	WriteDec
		MOV		edx, OFFSET dif_symbol
		CALL	WriteString
		MOV		eax, var_a
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		eax, b_minus_a
		CALL	WriteInt
		CALL	CrLf

		;C - A Output
		MOV		eax, var_c
		CALL	WriteDec
		MOV		edx, OFFSET dif_symbol
		CALL	WriteString
		MOV		eax, var_a
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		eax, c_minus_a
		CALL	WriteInt
		CALL	CrLf

		;C - A Output
		MOV		eax, var_c
		CALL	WriteDec
		MOV		edx, OFFSET dif_symbol
		CALL	WriteString
		MOV		eax, var_b
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		eax, c_minus_b
		CALL	WriteInt
		CALL	CrLf
	
		;C - B - A Output
		MOV		eax, var_c
		CALL	WriteDec
		MOV		edx, OFFSET dif_symbol
		CALL	WriteString
		MOV		eax, var_b
		CALL	WriteDec
		MOV		edx, OFFSET dif_symbol
		CALL	WriteString
		MOV		eax, var_a
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		eax, c_minus_ba
		CALL	WriteInt
		CALL	CrLf
		CALL	CrLf 

		;The following section is to display the quotient and remainder for extra credit 
		;Show the title of the selection for quotient and remainders
		MOV		edx, OFFSET outp_div
		CALL	WriteString
		CALL	CrLf

		;A / B Output
		MOV		eax, var_a
		CALL	WriteDec
		MOV		edx, OFFSET div_symbol
		CALL	WriteString
		MOV		eax, var_b
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		edx, OFFSET q_symbol
		CALL	WriteString
		MOV		eax, a_div_b
		CALL	WriteDec
		MOV		edx, OFFSET r_symbol
		CALL	WriteString
		MOV		eax, a_rem_b
		CALL	WriteDec
		CALL	CrLf
	
		;A / C Output
		MOV		eax, var_a
		CALL	WriteDec
		MOV		edx, OFFSET div_symbol
		CALL	WriteString
		MOV		eax, var_c
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		edx, OFFSET q_symbol
		CALL	WriteString
		MOV		eax, a_div_c
		CALL	WriteDec
		MOV		edx, OFFSET r_symbol
		CALL	WriteString
		MOV		eax, a_rem_c
		CALL	WriteDec
		CALL	CrLf

		;B / C Output1
		MOV		eax, var_b
		CALL	WriteDec
		MOV		edx, OFFSET div_symbol
		CALL	WriteString
		MOV		eax, var_c
		CALL	WriteDec
		MOV		edx, OFFSET equal_sign
		CALL	WriteString
		MOV		edx, OFFSET q_symbol
		CALL	WriteString
		MOV		eax, b_div_c
		CALL	WriteDec
		MOV		edx, OFFSET r_symbol
		CALL	WriteString
		MOV		eax, b_rem_c
		CALL	WriteDec
		CALL	CrLf
		CALL	CrLf

;ask user if the they want to do another round of calculations
_Repeat_From_User_Error:
		MOV		edx, OFFSET repeat_p
		CALL	WriteString
		CALL	ReadDec
		CALL	CrLf
		MOV		y_n, eax
		MOV		eax, y_n
		CMP		eax, 1
		JE		_Repeat_User_Arithemtic

; Say Goobye
		MOV		edx, OFFSET outro_1
		CALL	WriteString
		CALL	CRLF

		Invoke	ExitProcess,0	; exit to operating system

_User_Error:
		CALL	CrLf
		MOV		edx, OFFSET error_p
		CALL	WriteString
		CALL	CrLf
		CALL	CrLf
		JMP		_Repeat_From_User_Error

main ENDP

END main