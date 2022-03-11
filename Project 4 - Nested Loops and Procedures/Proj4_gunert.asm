TITLE Proj4gunert

; Author: Timur Guner
; Last Modified: 2021-05-11
; OSU email address: gunert@oregonstate.edu
; Course number/section:   CS271 Section 4000
; Project Number: 4               Due Date: 2021-05-16
; Description: This program ask the use to input a number between 1 and 4000. It will then display the amount of prime numbers
;			   based on user input. Example, entering 10 would display the first 10 prime numbers.

INCLUDE Irvine32.inc

minval = 1
maxval = 4000

.data

welcome			BYTE	"Prime Numbers Program by Timur Guner",13,10,13,10,0
instruct		BYTE	"Enter the number of prime numbers you would like to see.",13,10,
						"I will accept orders for up to 40000 primes.",13,10,0
extracredit1	BYTE	"EC 1: Align the output columns.",13,10,0
extracredit2	BYTE	"EC 2: Range extended to 4000 with 20 rows displayed at aaa time.",13,10,13,10,0
askvalue		BYTE	"Enter the number of primes to display [1 ... 4000]: ",0
wrongval		BYTE	"No primes for you! Number out of range. Try again.",13,10,0
inputval		DWORD	?																					;stores the user input
spaces1digit	BYTE	"          ",0																		;string of 10 spaces used to align output of 1 digit numbers
spaces2digit	BYTE    "         ",0																		;string of 9 spaces used to align output of 2 digit numbers											
spaces3digit	BYTE	"        ",0																		;string of 8 spaces used to align output of 3 digit numbers
spaces4digit	BYTE	"       ",0																			;string of 7 spaces used to align output of 4 digit numbers
spaces5digit	BYTE	"      ",0																			;string of 6 spaces used to align output of 5 digit numbers
farewell		BYTE	"Results certified by Timur. Goodbye.",13,10,0
rowprint		BYTE	"Press any key to load the next 20 rows: ",0
currentval		DWORD	?																					;used to store the current integer in the sequence during prime number calculations
poscount		DWORD	?																					;used to count the number of columns in a row
rowcount		DWORD	?																					;used to count the number of rows

.code
main PROC

	CALL	introduction
	CALL	getUserData
	CALL	showPrimes
	CALL	farwell

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; -- Introduction --
; Procedure to introduce user to the program
; Preconditions: welcome, instruct, extracredit1, and extracredit2 are strings that are used to display the introduction
; Postconditions: EDX changed 
; Receives: none
; Returns: Nothing
introduction PROC


	MOV		EDX, OFFSET welcome
	CALL	WriteString
	MOV		EDX, OFFSET instruct
	CALL	WriteString
	MOV		EDX, OFFSET extracredit1	;used to display extra credit 1 criteria
	CALL	WriteString
	MOV		EDX, OFFSET extracredit2	;used to display extra credit 2 criteria
	CALL	WriteString

	RET
introduction ENDP

; -- getUserData --
; Procedure to get a user input between 1 and 4000 for user input and check if it is valid by calling subprocedure validate 
; Preconditions: askvalue and wrongvalue are strings used to get user input, inputval exists
; Postconditions: EAX, ECX, EDX changed 
; Receives: none
; Returns: user input for global variable inputval
getUserData PROC

_getval:
	MOV		EDX, OFFSET askvalue		;ask user for input
	CALL	WriteString
	CALL	ReadDec
	MOV		inputval, EAX				;move user input oto input
	MOV		ECX, 0						;assine 0 to ECX for comparion if entry is valid
	CALL	validate				
	CMP		ECX, 1
	JNE		_endgetval					;if entry value jump to _endgetval or ask user for new input
	MOV		EDX, OFFSET wrongval
	CALL	WriteString
	JMP		_getval

_endgetval:
	RET
getUserData ENDP

; -- validate --
; Subprocedure of getUserData to validate if user input is between 1-4000
; Preconditions: ECX is an int, inputval contains user input, minval and maxval are constants
; Postconditions: ECX changed if validation fails
; Receives: ECX is an int, inputval is a global variable, minval and maxval are constants
; Returns: ECX
validate PROC
	CMP		inputval, minval
	JAE		_checklessthan				;if inputput is above or equal to minval jump to checklessthan, else ecx is 1 and jump to leavevalid
	MOV		ECX, 1
	JMP		_leavevalid

_checklessthan:
	CMP		inputval, maxval			;if inputval is below or equal to maxval then jump to leavevalid, else assign 1 to ecx
	JBE		_leavevalid
	MOV		ECX, 1

_leavevalid:
	RET
validate ENDP

; -- validate --
; Procedure that is used to print the number of primes the user asked for
; Preconditions: 1 <= inputval <= 4000, spaces1digit is a string, and currentval, poscount, and rowcount exists
; Postconditions: EAX, ECX, EBX, EDX are changed
; Receives: inputval, space1digit, currentval, poscount, and rowcount are global variables
; Returns: None
showPrimes PROC
	CALL Crlf
	
	MOV		ECX, inputval				;assign inputval to ECX for LOOP counting in printprimeloop
	CMP		ECX, 1						;compare ECX to 1 and jump to printoneprimes if it is equal, else jump to printtowprimes
	JE		_printoneprime
	JMP		_printtwoprimes

; If the user enters 1, then only print 2 and jump to _leaveshowprimes
_printoneprime:
	MOV		EAX, 2				
	CALL	WriteDec
	JMP		_leaveshowprimes

; If the user enters 2, then only print 2 and 3 and jump to _leaveshowprimes
_printtwoprimes:
	CMP		ECX, 2
	JA		_startprimecounting			;if ECX is above 2, jump to startprimecounting
	MOV		EAX, 2
	CALL	WriteDec
	MOV		EDX, OFFSET spaces1digit	
	CALL	WriteString
	MOV		EAX, 3
	CALL	WriteDec
	JMP		_leaveshowprimes

; If the user enters more than 2, start by printing 2 and 3 and then continue to _printprimeloop
_startprimecounting:
	MOV		EAX, 2
	CALL	WriteDec
	MOV		EDX, OFFSET spaces1digit
	CALL	WriteString
	MOV		EAX, 3
	CALL	WriteDec
	MOV		EDX, OFFSET spaces1digit
	CALL	WriteString
	SUB		ECX, 2
	MOV		currentval, 4				;currentval is set to 4 because we already printed 2 and 3
	MOV		poscount, 2					;poscount is set to 2 which is used to keep count of each column in the row

; This is the ECX loop that is used for 
_printprimeloop:

_topofprimeloop:
	CALL	isPrime						;call isPrime to check if currentval is a prime number, which it is if EBX is 1
	CMP		EBX, 1						
	JNE		_topofprimeloop				;if not a prime number go back to topofprimeloop

	SUB		currentval, 1				;sub 1 from currentval to print the correct prime number because isPrime auto incrememnts
	MOV		EAX, currentval
	CALL	WriteDec

	CALL	printDigitSpaces			;call printDigitSpaces to align the primes based on number of digits
	INC		poscount
	CMP		poscount,10					;if poscount is 10 then it is time to start a new row in printnewline, else jump endprimeprint
	JE		_printnewline				
	JMP		_endprimeprint

; printnewline will start printing on a new row once there are 10 outputs already printed
_printnewline:
	CALL	CrLF
	INC		rowcount					;if new line is printed, we increment rowcount
	MOV		poscount, 0					;reset poscount to 0
	CMP		rowcount, 20				;if rowcount is 20, jump to loadnexttwenty, else jump to endprimeprint
	JE		_loadnexttwenty
	JMP		_endprimeprint

; loadnexttwenty is used to ask the user to press any key to load the next twenty rows of primes
_loadnexttwenty:
	CMP		ECX, 1						;if ECX is now down to 1 there is no need to ask the user, so jump to endprimeprint
	JE		_endprimeprint
	CALL	CrLf
	MOV		EDX, OFFSET rowprint		;ask user to enter any input for next twenty rows of output
	CALL	WriteString
	CALL	ReadInt
	MOV		rowcount, 0					;reset row count to 0					
	CALL	CrLf

_endprimeprint:
	LOOP	_printprimeloop

_leaveshowprimes:
	RET
showPrimes ENDP

; -- printDigitSpaces --
; Subprocedure of showPrimes to align the output based on the the number of digits
; Preconditions: EAX holds currentval, currentval is a global variable, and spaces1digit, spaces2digit, spaces3digit, spaces4digit, spaces5digit are strings
; Postconditions: EDX changed
; Receives: EAX is an int, and currentval, spaces1digit, spaces2digit, spaces3digit, spaces4digit, spaces5digit are global variables
; Returns: currentval a global variable
printDigitSpaces PROC

; If the prime is 1 digit, print space1digit and jump to endspaces
_printonedigit:
	CMP		EAX, 10
	JAE		_printtwodigits
	MOV		EDX, OFFSET spaces1digit
	CALL	WriteString
	ADD		currentval, 1				;need to increment currentval to get back to checking if the next value is a prime number
	JMP		_endpsaces

; If the prime is 2 digits, print space2digit and jump to endspaces, else jump to printthreedigits
_printtwodigits:
	CMP		EAX, 100
	JAE		_printthreedigits
	MOV		EDX, OFFSET spaces2digit
	CALL	WriteString
	ADD		currentval, 1
	JMP		_endpsaces

; If the prime is 3 digits, print space3digit and jump to endspaces, else jump to printfourdigts
_printthreedigits:
	CMP		EAX, 1000
	JAE		_printfourdigits
	MOV		EDX, OFFSET spaces3digit
	CALL	WriteString
	ADD		currentval, 1
	JMP		_endpsaces

; If the prime is 4 digits, print space4digit and jump to endspaces, else jump to printfivedigits
_printfourdigits:
	CMP		EAX, 10000
	JAE		_printfivedigits
	MOV		EDX, OFFSET spaces4digit
	CALL	WriteString
	ADD		currentval, 1
	JMP		_endpsaces

; If the prime is 5 digits, print space5digit
_printfivedigits:
	MOV		EDX, OFFSET spaces5digit
	CALL	WriteString
	ADD		currentval, 1

_endpsaces:
	RET
printDigitSpaces ENDP


; -- isPrime --
; Subprocedure of showPrimes to check if currentval is a prime number
; Preconditions: currentval is global variable with the nTH value to check if its prime
; Postconditions: EAX, EBX, EDX changed
; Receives: currentval a global valriable
; Returns: currentval a global variable, EBX a register with 1 or 0 to tell us if currentval is prime
isPrime PROC
	;begin by assigning 2 to EBX and currentval to EAX
	MOV		EBX, 2
	MOV		EAX, currentval

; ------------------------------
; This section determines if the currentval is prime number or not. EAX contains the currentval and is divided by EBX.
; If the EDX is 0, then currentval is not a prime number and the program jumps to primenotfound. In primenotfound, 
; EBX is assigned 0 to let us know that currentval is not a prime. IF EDX is not 0, then increment EBX (divisor) by 1 
; and reassign currentval to EAX and jump back to top of primeevaluation to try again with the new EBX. If EBX is equal
; to currentval, then we have a prime number because EDX never became 0 after the divisions. Once this happens, jump
; to primefound and assign 1 to EBX to let us know we have a prime number. Whether it is prime or not we increment
; currentval by 1.
; -------------------------------
_primeevaluation:
	CMP		EBX, currentval
	JE		_primefound
	MOV		EDX, 0
	DIV		EBX
	CMP		EDX, 0
	JE		_primenotfound
	INC		EBX
	MOV		EAX, currentval
	JMP		_primeevaluation

_primenotfound:
	MOV		EBX, 0
	JMP		_endisprime

_primefound:
	MOV		EBX, 1

_endisprime:
	ADD		currentval, 1

	RET
isPrime	ENDP

; -- farewell --
; Procedure to display a farewell message
; Preconditions: farewell is a string
; Postconditions: EDX changed
; Receives: farewell a global variable
; Returns: None
farwell	PROC
	CALL	CrLf
	CALL	CrLf
	MOV		EDX, OFFSET farewell			;assigns the farewell message to edx and prints it
	CALL	WriteString
	
	RET
farwell ENDP


END main
