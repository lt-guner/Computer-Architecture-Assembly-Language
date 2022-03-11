TITLE Program Template     (template.asm)

; Author: Timur Guner
; Last Modified: 2021-04-25
; OSU email address: gunert@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: Project 3            Due Date: 2021-05-02
; Description: This project takes in numbers from user input between [-200,-100] or [-50,-1].
;			   If the number is not range let the user know. Continue getting input from the user
;			   until the user enters a positive number. Display the number of valid entries, 
;			   max value, min value, and rounded average. If the user exists before entering a 
;			   valid number, display a special message.

INCLUDE Irvine32.inc
; (insert macro definitions here)

;Constants for the ranges of allowable user inputs
MIN_VALUE_LOW = -200
MAX_VALUE_LOW = -100
MIN_VALUE_HIGH = -50
MAX_VALUE_HIGH = -1

.data
;Data variables and names should be self explanatory
greeting	BYTE	"Welcome to the Interger Accumulator by Timur Guner.",13,10,0
extc_1		BYTE	"EC 1: The input lines are numbered.",13,10,0
extc_2		BYTE	"EC 2: Rounded decimal average to 100th.",13,10,0
ask_name	BYTE	"What is your name? ",0
user_name	BYTE	33 DUP(0)														
display_n	BYTE	"Hello there, ",0
instruct_1	BYTE	"Please enter numbers in range of [-200, -100] or [-50, -1].",13,10,0
instruct_2	BYTE	"Enter a non-negative number when you are finished to see results.",13,10,0
enter_num	BYTE	") Enter Number: ",0
user_num	SDWORD	?		
invalid		BYTE	"INVALID ENTER!",13,10,0
count		DWORD	0		;count of valid entries
sum			SDWORD	0		;sum of user input
max_enter	SDWORD	0		;stores the max valid entry
min_enter	SDWORD	0		;stores the min valid entry
avg_round	DWORD	0		;average rounded to nearest whole number
line_count	DWORD	0		;used to display the numbered input lines
quotient	SDWORD	0		;quotient from normal idiv
quotient_n	DWORD	0		;negated quotient for rounding calculation
quotient_d	DWORD	0		;quotient used for decimal rounding to nearest 100th
decimal_1	DWORD	0		;decimal point 1
decimal_2	DWORD	0		;decimal point 2
decimal_3	DWORD	0		;decimal point 3
dec_round	DWORD	0		;the whole number average of the decimal point used later
dec_point	BYTE	".",0
special		BYTE	"You existed the program without entering any numbers in range, so no calculations were made.",0
output_1	BYTE	"The number of valid entries you entered are ",0
output_2	BYTE	"The minimum valid number is ",0
output_3	BYTE	"The maximum valid number is ",0
output_4	BYTE	"The sum of your valid entries is ",0
output_5	BYTE	"The whole number rounded average of valid entries is ",0
output_6	BYTE	"The average rounded to nearest 100th is ",0
farewell	BYTE	"Farwell, "

.code

main PROC

;Inroduction with greeting
	MOV		EDX, OFFSET greeting
	CALL	WriteString
	MOV		EDX, OFFSET extc_1
	CALL	WriteString
	MOV		EDX, OFFSET extc_2
	CALL	WriteString
	CALL	CrLf

;Get username and greet username
	MOV		EDX, OFFSET ask_name
	CALL	WriteString
	MOV		EDX, OFFSET user_name
	MOV		ECX, 33
	CALL	ReadString
	MOV		EDX, OFFSET display_n
	CALL	WriteString
	MOV		EDX, OFFSET user_name
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf

;Display instructions
	MOV		EDX, OFFSET instruct_1
	CALL	WriteString
	MOV		EDX, OFFSET instruct_2
	CALL	WriteString
	CALL	CrLf

;Ask user for number and display the entry number
_enterNumber:
	MOV		EAX, line_count
	ADD		EAX, 1
	CALL	WriteDec
	MOV		line_count, EAX
	MOV		EDX, OFFSET enter_num
	CALL	WriteString
	CALL	ReadInt

;Begin by checking if the number is postive and exist program if it is. If not compare to the lowest allowable input -200. If its greater than or equal to -200 then jump to _compareMaxValueLow, otherwise go to invalidInput.
_compareMinValueLow:
	MOV		user_num, EAX
	JNS		_calculateResults
	CMP		EAX, MIN_VALUE_LOW
	JGE		_compareMaxValueLow
	JMP		_invalidInput

;If the number is less than or equal to -100 move forward to countEntries because its in range [-200, -100], otherwise continue on to begin comparing -50 and -1 
_compareMaxValueLow:
	CMP		EAX, MAX_VALUE_LOW
	JLE		_countEntries

;Compare the entered number to see if greater than or equal to -50. If so move on to compareMaxValueHigh, otherwise jump to invalidInput
_compareMinValueHigh:
	CMP		EAX, MIN_VALUE_HIGH
	JGE		_compareMaxValueHigh
	JMP		_invalidInput

;Compare the the entered number to see if its less than or equal to -1, If yes go to countEntries otherwise continue to invalidInput
_compareMaxValueHigh:
	CMP		EAX, MAX_VALUE_HIGH
	JLE		_countEntries

;Tell the user that the input integer is not in range and jump to enterNumber
_invalidInput:
	MOV		EDX, OFFSET invalid
	CALL	WriteString
	JMP		_enterNumber

;counts each valid entry and if its the first valid entry, jump to firstEntry
_countEntries:
	MOV		EAX, count
	ADD		EAX, 1
	MOV		count, EAX
	MOV		EAX, 1
	CMP		EAX, count
	JE		_firstEntry

;adds the entered number to sum, and assigns the new entered number to either min or max if the new number entered passes that comparison. Then jump to enterNumber to grab a new number
_storeNumbers:
	MOV		EAX, sum
	MOV		EBX, user_num
	ADD		EAX, EBX
	MOV		sum, EAX
	MOV		EAX, user_num
	CMP		EAX, max_enter
	JG		_addMax
	CMP		EAX, min_enter
	JL		_addMin
	JMP		_enterNumber

;Assign the first entry to min and max variables jump back to storeNumbers
_firstEntry:
	MOV		EAX, user_num
	MOV		max_enter, EAX
	MOV		EAX, user_num
	MOV		min_enter, EAX
	JMP		_storeNumbers

;Change max enter to the new number if there is a new highest value entered
_addMax:
	MOV		max_enter, EAX
	JMP		_enterNumber

;Change min enter to the new number if there is a new lowest value entered
_addMin:
	MOV		min_enter, EAX
	JMP		_enterNumber

;calculate and display results
_calculateResults:

	;if the user existed without entering a valid number display a special message
	MOV		EAX, count
	CMP		EAX, 0
	JE		_specialCasePrint

	;Display results of # entries, min, max, and total
	CALL	CrLf
	MOV		EDX, OFFSET output_1
	CALL	WriteString
	MOV		EAX, count
	CALL	WriteDec
	CALL	CrLf
	MOV		EDX, OFFSET output_2
	CALL	WriteString
	MOV		EAX, min_enter
	CALL	WriteInt
	CALL	CrLf
	MOV		EDX, OFFSET output_3
	CALL	WriteString
	MOV		EAX, max_enter
	CALL	WriteInt
	CALL	CrLf
	MOV		EDX, OFFSET output_4
	CALL	WriteString
	MOV		EAX, sum
	CALL	WriteInt
	CALL	CrLf

	;take the sum and divide by the count of entries and then store the quotient and negated quotients in there respectable data variables
	MOV		EAX, sum
	CDQ
	IDIV	count
	MOV		avg_round, EAX
	MOV		dec_round, EAX
	MOV		quotient, EDX
	NEG		EDX
	MOV		quotient_n, EDX
	MOV		quotient_d, EDX

_beginAverageRound:
	;use the negated quotient * 2 to see if it greater than the count (divisor), if not go to roundUp and if yes continue to to decrease the average_round by 1
	MOV		EAX, quotient_n
	MOV		EBX, 2
	MUL		EBX
	MOV		quotient_n, EAX
	MOV		EAX, quotient_n
	MOV		EBX, count
	CMP		EAX, EBX
	JLE		_roundUp

;if the new qoutient_n is greater than the divisor round down avg_round by 1. Display the calculation and jump to endProgram
_roundDown:
	MOV		EDX, OFFSET output_5
	CALL	WriteString
	MOV		EAX, avg_round
	SUB		EAX, 1
	MOV		avg_round, EAX
	MOV		EAX, avg_round
	CALL	WriteInt
	CALL	CrLf
	JMP		_roundDecimals

;if the new qoutient_n is less than or equal the divisor leave avg_round alone. Display the calculation and jump to endProgram
_roundUp:
	MOV		EDX, OFFSET output_5
	CALL	WriteString
	MOV		EAX, avg_round 
	CALL	WriteInt
	CALL	CrLf

;Begin the rounding to the nearest 100th
_roundDecimals:

	;get decimal point 1
	MOV		EAX, quotient_d
	MOV		EBX, 10
	MUL		EBX
	MOV		decimal_1, EAX
	MOV		EAX, decimal_1
	MOV		EDX, 0
	MOV		EBX, count
	DIV		EBX
	MOV		decimal_1, EAX
	MOV		quotient_d, EDX

	;get decimal point 2
	MOV		EAX, quotient_d
	MOV		EBX, 10
	MUL		EBX
	MOV		decimal_2, EAX
	MOV		EAX, decimal_2
	MOV		EDX, 0
	MOV		EBX, count
	DIV		EBX
	MOV		decimal_2, EAX
	MOV		quotient_d, EDX

	;get decimal point 3
	MOV		EAX, quotient_d
	MOV		EBX, 10
	MUL		EBX
	MOV		decimal_3, EAX
	MOV		EAX, decimal_3
	MOV		EDX, 0
	MOV		EBX, count
	DIV		EBX
	MOV		decimal_3, EAX
	MOV		quotient_d, EDX

	;check if decimal point 3 needs to round decimal 2 and if so go to firstRounded, else print the current decimal points.
	MOV		EAX, decimal_3
	CMP		EAX, 5
	JG		_firstRounded
	MOV		EDX, OFFSET output_6
	CALL	WriteString
	MOV		EAX, dec_round
	CALL	WriteInt
	MOV		EDX, OFFSET dec_point
	CALL	WriteString
	MOV		EAX, decimal_1
	CALL	WriteDec
	MOV		EAX, decimal_2
	CALL	WriteDec
	CALL	CrLf
	JMP		_endProgram

;add one to the second decimal point and print if it does not need to be rounded, else jump to to secondRounded
_firstRounded:
	MOV		EAX, decimal_2
	ADD		EAX, 1
	MOV		decimal_2, EAX
	MOV		EAX, decimal_2
	CMP		EAX, 10
	JE		_secondRounded
	MOV		EDX, OFFSET output_6
	CALL	WriteString
	MOV		EAX, dec_round
	CALL	WriteInt
	MOV		EDX, OFFSET dec_point
	CALL	WriteString
	MOV		EAX, decimal_1
	CALL	WriteDec
	MOV		EAX, decimal_2
	CALL	WriteDec
	CALL	CrLf
	JMP		_endProgram
	
;add one to the first decimal point and make second decimal point 0 and print if it does not need to be rounded, else jump to to thirdRounded
_secondRounded:
	MOV		EAX, 0
	MOV		decimal_2, EAX
	MOV		EAX, decimal_1
	ADD		EAX, 1
	MOV		decimal_1, EAX
	MOV		EAX, decimal_1
	CMP		EAX, 10
	JE		_thirdRounded
	MOV		EDX, OFFSET output_6
	CALL	WriteString
	MOV		EAX, dec_round
	CALL	WriteInt
	MOV		EDX, OFFSET dec_point
	CALL	WriteString
	MOV		EAX, decimal_1
	CALL	WriteDec
	MOV		EAX, decimal_2
	CALL	WriteDec
	CALL	CrLf
	JMP		_endProgram

;If first decimal point also rounds and goes to 0 round down the negative number by 1
_thirdRounded:
	MOV		EAX, 0
	MOV		decimal_1, EAX
	MOV		EAX, dec_round
	SUB		EAX, 1
	MOV		dec_round, EAX
	MOV		EDX, OFFSET output_6
	CALL	WriteString
	MOV		EAX, dec_round
	CALL	WriteInt
	MOV		EDX, OFFSET dec_point
	CALL	WriteString
	MOV		EAX, decimal_1
	CALL	WriteDec
	MOV		EAX, decimal_2
	CALL	WriteDec
	CALL	CrLf
	JMP _endProgram

; If the user entered a positive number before entering any negative numbers in range, display this special message
_specialCasePrint:
	CALL	CrLf
	MOV		EDX, OFFSET special
	CALL	WriteString
	CALL	CrLf

;departing message and exit
_endProgram:
	CALL	CrLf
	MOV		EDX, OFFSET farewell
	CALL	WriteString
	MOV		EDX, OFFSET user_name
	CALL	WriteString
	CALL	CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
