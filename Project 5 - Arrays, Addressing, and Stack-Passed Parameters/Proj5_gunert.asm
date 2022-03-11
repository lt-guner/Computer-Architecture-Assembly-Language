TITLE Project Five     (Proj5_gunert.asm)

; Author: Timur Guner
; Last Modified: 2021-05-18
; OSU email address: gunertD@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 5               Due Date: 2021-05-23
; Description: This program generates a random array (randArray) of ARRAYSIZE and populates it randomly
;			   with numbers ranging from LO to HI. It then prints out the unsorted array. Next the program
;			   sorts randArray and displays the sorted array. Lastly, the program counts the instances of 
;			   each number in randArray and stores it in count, then count is printed.

INCLUDE Irvine32.inc

LO = 10
HI = 29
ARRAYSIZE = 200
COUNTSIZE = HI - LO + 1

.data
randArray		DWORD	ARRAYSIZE DUP(?)						;an array that stores values between LO and HI and to the length of ARRAYSIZE
counts			BYTE	(HI - LO + 1) DUP(0)					;an array that stores count of each element in randArray
dataBuffer		DWORD	ARRAYSIZE DUP(?)						;an array used as a buffer to load into a file
fileName		BYTE	"arrayFile.txt",0						;the file to read and right from
fileHandle		DWORD	?										;used to store the file handle
bytesWritten	DWORD	?										;used to store the bytes written	
bytesRead		DWORD	?										;used to stote the bytes read 
greetings		BYTE	"Generating, Sorting, and Counting Random integers! Programmed by Timur",13,10,13,10,0
intro1			BYTE	"This program generates 200 random numbers in the range [10 ... 29], displays the",13,10,0
intro2			BYTE	"original list, sorts the list, displays the median value of the list, displays the",13,10,0
intro3			BYTE	"list sorted in ascending order, then displays the number of instances of each",13,10,0
intro4			BYTE	"generated value, starting with the number of 10s.",13,10,0
extracredit1	BYTE	"EC 1: Display the numbers ordered by column instead of by row. (1pt)",13,10,0
extracredit2	BYTE	"EC 2: Numbers generated to data file, then read into array from file (3pt)",13,10,13,10,0
goodbye			BYTE	"Goodbye, and thanks for using this program!",13,10,0
mediantitle		BYTE	"The median value of the array: ",0	
unsortedtitle	BYTE	"Your unsorted random numbers:",13,10,0
sortedtitle		BYTE	"Your sorted random numbers:",13,10,0
countedtitle	BYTE	"Your list of instances of each generated number, starting with the number of 10s:",13,10,0
spaces			BYTE	" ",0

.code
main PROC

	;call randomize to get new random numbers based on synced clock
	CALL	Randomize

	;push introduction parameters and procedure called
	PUSH	OFFSET extracredit2
	PUSH	OFFSET intro4
	PUSH	OFFSET intro3
	PUSH	OFFSET intro2
	PUSH	OFFSET intro1
	PUSH	OFFSET greetings
	CALL	introduction				;{parameters: intro4 (reference, input), intro3 (reference, input), intro2 (reference, input), intro1 (reference, input), greeting (reference, input))

	;fillArray parameters pushes and procedure called
	PUSH	bytesRead
	PUSH	bytesWritten
	PUSH	fileHandle
	PUSH	SIZEOF randArray
	PUSH	OFFSET fileName
	PUSH	OFFSET randArray
	PUSH	OFFSET dataBuffer
	PUSH	LO
	PUSH	HI
	PUSH	ARRAYSIZE
	CALL	fillArray					;{parameters: randArray (reference, output), LO (value, input), HI (value, input), ARRAYSIZE (value, input), dataBuffer (reference, output), fileName (reference,output), SIZEOF randArray (value,input), fileHandle (value,input), bytesWritten (value,intput), bytesRead(value,input)}	

	;displayList for unsorted parameters pushed and procedure called
	PUSH	OFFSET unsortedtitle
	PUSH	OFFSET randArray
	PUSH	OFFSET ARRAYSIZE
	PUSH	1
	PUSH	OFFSET spaces
	CALL	displayList					;{parameters: unsortedtitle (reference, input), randArray (reference, input), ARRAYSIZE (value, input), 1 (value,input), spaces (reference, input)}	

	;sortList parameters pushed and procedure called
	PUSH	OFFSET randArray
	PUSH	ARRAYSIZE
	CALL	sortList					;{parameters: randArray (reference, input/output), ARRAYSIZE (value, input)}

	;displayMedian parameters and procedure called
	PUSH	OFFSET mediantitle
	PUSH	OFFSET randArray
	PUSH	ARRAYSIZE
	CALL	displayMedian				;{parameters: mediantitle (reference, input), randArray (reference, input), ARRAYSIZE (value, input)}

	;displayList for sorted parameters pushed and procedure called
	PUSH	OFFSET sortedtitle
	PUSH	OFFSET randArray
	PUSH	OFFSET ARRAYSIZE
	PUSH	2
	PUSH	OFFSET spaces
	CALL	displayList					;{{parameters: sortedtitle (reference, input), randArray (reference, input), ARRAYSIZE (value, input), 2 (value,input), spaces (reference, input)}	

	;countList parameters and procedure called
	PUSH	OFFSET randArray
	PUSH	ARRAYSIZE
	PUSH	OFFSET counts
	PUSH	LO
	PUSH	HI
	CALL	countList					;{parameters: randArray (reference, input), ARRAYSIZE (value, input), counts (reference, output), LO (value, input), HI (value, input)}
	
	;displayList for counts parameters pushed and procedure called
	PUSH	OFFSET countedtitle
	PUSH	OFFSET counts
	PUSH	OFFSET COUNTSIZE
	PUSH	3
	PUSH	OFFSET spaces
	CALL	displayList					;{{parameters: countedtitle (reference, input), counts (reference, input), COUNTSIZE (value, input), 3 (value,input), spaces (reference, input)}	

	;farwell parameters pushed and procedure called
	PUSH	OFFSET goodbye
	CALL	farewell					;{{parameters: goodbye (reference, input)}

	Invoke ExitProcess,0				; exit to operating system
main ENDP



; --------------------------------------------------
; Name:	introduction
; 
; Decriptions: Procedure to introduce user to the program
; 
; Preconditions: greetings, intro1, intro2, intro3, and intro4 are strings that are used to display the introduction
; 
; Postconditions: EDX changed 
;
; Receives: 
;	[EBP+8] = greetings address
;	[EBP+12] = intro1 address
;	[EBP+16] = intro2 address
;	[EBP+20] = intro3 address
;	[EBP+24] = intro4 address
;	[EBP+28] = extracredit1 address
;
; Returns: Nothing
; --------------------------------------------------
introduction PROC
	
	PUSH	EBP
	MOV		EBP, ESP

	;print greetings and instructions strings
	MOV		EDX, [EBP+8]
	CALL	WriteString
	MOV		EDX, [EBP+12]
	CALL	WriteString
	MOV		EDX, [EBP+16]
	CALL	WriteString
	MOV		EDX, [EBP+20]
	CALL	WriteString
	MOV		EDX, [EBP+24]
	CALL	WriteString
	MOV		EDX, [EBP+28]
	CALL	WriteString

	POP		EBP

	RET		24							;ret 20 to move stack to the point of passed parameters
introduction ENDP



; --------------------------------------------------
; Name:	fillArray
; 
; Decriptions: Procedure that fills a buffer array (dataBuffer) of size ARRAYSIZE, with random values between LO and HI.
;              Next the arrayFile.txt is created and dataBuffer is written to it and file is closed. Lastly, the file
;			   is opened in read mode and the data is stored in randArray, then file is closed. 
;
; Preconditions: 
;	ARRAYSIZE, HI, and LO are constants
;	randArray is an array of size ARRAYSIZE with ? filled in and is type DWORD
;	dataBuffer is an array of size ARRAYSIZE with ? filled in and is type DWORD
; 
; Postconditions: EBP, ECX, ESI, EAX are changed
;
; Receives: 
;	[EBP+8] = ARRARYSIZE
;	[EBP+12] = LO
;	[EBP+16] = HI
;	[EBP+20] = address of dataBuffer
;	[EBP+24] = address of randArray
;	[EBP+28] = address of fileName
;	[EBP+32] = bytes of randArray (same as dataBuffer)
;	[EBP+36] = fileHandle
;	[EBP+40] = bytesWritten
;	[EBP+44] = bytesRead
;
; Returns: randArray and dataBuffer of size ARRAYSIZE are filled with random numbers between LO and HI 
; --------------------------------------------------
fillArray PROC
	
	PUSH	EBP							;push EBP to the stack, and assign it ESP
	MOV		EBP, ESP
	MOV		ECX, [EBP+ 8]				;ARRAYSIZE
	MOV		ESI, [EBP + 20]				;address of dataBuffer


;loop to fill array with random numbers between LO and HI
_arrayfillloop:
	MOV		EAX, [EBP+12]				;mov [EBP+12] (HI) in to EAX
	INC		EAX
	CALL	RandomRange					;generate a random number 0 - HI
	CMP		EAX, [EBP+16]		
	JB		_arrayfillloop				;compare to [EBX+16] (LO) and jump to top if the number is below LO
	MOV		[ESI], EAX
	ADD		ESI, 4
	LOOP	_arrayfillloop

	;Create output using fileName [EB+28] and storing the value in EAX to fileHand [EBP+44]
	MOV		EDX, [EBP+28]
	CALL	CreateOutputFile
	MOV		[EBP+36], EAX
	
	;Move fileHandle to EAX, address of dataBuffer to EDX, and bytes of randArray [EBP+32] to ECX, then call WriteFile
	MOV		EAX, [EBP+36]
	MOV		EDX, [EBP+20]
	MOV		ECX, [EBP+32]
	CALL	WriteToFile
	MOV		[EBP+40], EAX				;store EAX in bytesWritten [EBP+40]

	;clost the file using fileName
	MOV		EAX, [EBP+36]
	CALL	CloseFile
	
	;open fileName for reading
	MOV		EDX, [EBP+28]
	CALL	OpenInputFile
	MOV		[EBP+36], EAX

	;Move fileHandle to EAX, address of randArray [EBP+24] to EDX, and bytes of randArray [EBP+32] to ECX, then call ReadFromFile
	MOV		EAX, [EBP+36]
    MOV		EDX, [EBP + 24]
    MOV		ECX, [EBP + 32]
    CALL	ReadFromFile
	MOV		[EBP+44], EAX				;store EAX in bytesRead [EBP+40]

	MOV		EAX, [EBP+36]
	CALL	CloseFile

	POP		EBP

	RET		40							;ret 40 to move stack to the point of passed parameters

fillArray ENDP



; --------------------------------------------------
; Name: sortlist
; 
; Decriptions: Procedure sorts randArray in asccending order
; 
; Preconditions: 
;	randArray is an array of size ARRAYSIZE with random numbers between LO and HI filled in and is type DWORD
; 
; Postconditions: EBP, ECX, ESI, EAX, EDX, EBX are changed
;
; Receives: 
;	[EBP+8] = ARRARYSIZE
;	[EBP+12] = address of randArray
;
; Returns: randArray of size ARRAYSIZE is sorted in ascending order
; --------------------------------------------------
sortList PROC
	
	PUSH	EBP							;push EBP and assign ESP to EBP
	MOV		EBP, ESP
	MOV		ESI, [EBP+12]				;address of randArray
	MOV		ECX, [EBP+8]				;ARRAYSIZE
	SUB		ECX, 1						;ECX is the ARRAYSIZE - 1 used for bubble sort
	MOV		EAX, 4		
	MUL		ECX
	MOV		EDX, EAX					;EDX is the total number of bytes of ARRAYSIZE - 4 used in the bubble sort

;arraysizeloop will loop ECX as the outer loop in the bubble sort
_arraysizeloop:
	PUSH	ESI
	PUSH	EDX

;bubblesortloop will use EDX as a counter for the inner loop in a bubble sort
_bubblesortloop:
	MOV		EAX, [ESI]
	MOV		EBX, [ESI+4]
	CMP		EAX, EBX					;compate is element in first position is bigger than second position
	JBE		_bubblesortend				;if not jump to bubblesortend
	PUSH	[ESI]
	PUSH	[ESI+4]
	CALL	exchangeElements			;push randArray[x] and and randArray[x+4] to the stack then call exchangeElements
_bubblesortend:
	SUB		EDX, 4						;decrement EDX by one slot because we moved up one position
	ADD		ESI, 4						;increment to move up one slot
	CMP		EDX, 0
	JA		_bubblesortloop				;continue loop until EDX is 0
	
	POP		EDX
	POP		ESI
	SUB		EDX, 4						;after popping EDX, decrement by 1 because we know the last slot in the array is the largest
	LOOP	_arraysizeloop

	POP		EBP
	RET		8							;ret 8 to move stack to point of passed parameters

sortlist ENDP



; --------------------------------------------------
; Name: exchangeElements
; 
; Decriptions: Procedure is subprocedure of swap elements in randArray
; 
; Preconditions: 
;	randArray is an array of size ARRAYSIZE with random numbers between LO and HI filled in and is type DWORD
; 
; Postconditions: EBP, EAX, EBX changed
;
; Receives: 
;	[EBP+8] = randArray[x]
;	[EBP+12] = randArray[X+4]
;
; Returns: swappened elements in the randArray
exchangeElements PROC
	
	PUSH	EBP
	MOV		EBP, ESP					;push EBP and assign ESP to EBP
	
	MOV		EAX, [EBP+8]
	MOV		EBX, [EBP+12]				;EAX gets value of randArray[x+4] and EBX gets randArray[x] 
	MOV		[ESI], EAX
	MOV		[ESI+4], EBX				;[ESI] and [ESI+4] are are swapped values using EAX and EBX
	
	POP		EBP
	RET		8

exchangeElements ENDP



; --------------------------------------------------
; Name: countlist
; 
; Decriptions: Procedure counts instance of the same number in randArray and stores it in counts
; 
; Preconditions: 
;	ARRAYSIZE, HI, and LO are constants
;	randArray is an array of size ARRAYSIZE with random numbers between LO and HI filled in and is type DWORD
;	counts is an array of size (HI - LO + 1) filled with 0s and is type BYTE
; 
; Postconditions: EBP, ECX, ESI, EAX, EDX, EBX,EDI are changed
;
; Receives: 
;	[EBP+8] = HI
;	[EBP+12] = LO
;	[EBP+16] = counts address
;	[EBP+20] = ARRAYSIZE
;	[EBP+24] = randArray address
;
; Returns: counts is populated with the number of instances of each number in randArray
; --------------------------------------------------
countList PROC
	
	PUSH	EBP							;push EBP and assign ESP to EBP
	MOV		EBP, ESP
	MOV		ECX, [EBP+20]				;pop ARRAYSIZE into ECX
	MOV		ESI, [EBP+24]				;pop randArray address into ESI
	MOV		EDI, [EBP+16]				;pop counts address into EDI
	MOV		EDX, [EBP+8]				;pop HI into EDX
	SUB		EDX, [EBP+12]				;EDX - LO
	ADD		EDX, 1						;EDX now contains the amount of slots of counts
	MOV		EBX, [EBP+12]				;EBX is starting position for comparisons
	
_countarrayloop:

	;push registers that could be changed in the inner loop
	PUSH	ESI
	PUSH	EDI
	PUSH	ECX
	PUSH	EDX

;this loop will add one to the current slot of EDI if [ESI] equals EBX
_countmappingloop:			
	CMP		[ESI], EBX					;compare [ESI] to EBX and If the max, add 1 to [EDI]
	JNE		_overaddition
	ADD		BYTE PTR [EDI], 1
_overaddition:
	ADD		ESI, 4						;inc ESI to next position of randArray
	LOOP	_countmappingloop
	
	;pop registers afer inner loop
	POP		EDX
	POP		ECX
	POP		EDI
	POP		ESI

	DEC		EDX							;dec EDX by because one more slot in EDI is filled up
	INC		EDI							;inc EDI to next slot in aray
	INC		EBX							;inc EBX by one for next comparison
	CMP		EDX, 0						;EDX reachs 0, all slots in EDI (counts) are now filled

	JA		_countarrayloop

	POP		EBP
	RET		20							;ret 20 to move stack to point of passed parameters
countList ENDP



; --------------------------------------------------
; Name: displayMedian
; 
; Decriptions: procedure displays the median of randArray
;
; Preconditions: 
;	randArray is an array of size ARRAYSIZE with random numbers between LO and HI filled in, is type DWORD, and is sorted
; 
; Postconditions: EBP, ESI, EAX, EDX, EBX, are changed
;
; Receives: 
;	[EBP+8] = ARRAYSIZE
;	[EBP+12] = randArray address
;
; Returns: nothing
; --------------------------------------------------
displayMedian PROC

	PUSH	EBP							;push EBP and assign ESP to EBP
	MOV		EBP, ESP
	MOV		ESI, [EBP+12]				;assign randArray address to ESI
	
	;DIV by 2 to find middle number
	MOV		EAX, [EBP+8]				;mov arraysize to EAX
	MOV		EDX, 0
	MOV		EBX, 2
	DIV		EBX
	
	CMP		EDX, 0						;if the remainder is 0 then we have two middle numbers so we continue on to _evenNumberFinder
	JNE		_exactMedian				;if remainder exists we know we have one middle number
	MOV		EBX, EAX
	MOV		EDX, 1

;the evenNumberFinder loop will loop through continuously until it finds indexing in array of [x] or position x+1
_evenNumberFinder:
	CMP		EDX, EBX
	JE		_assignEvenNumbers			;when the index [x] is found jump to _assignEvenNumbers
	INC		EDX
	ADD		ESI, 4
	JMP		_evenNumberFinder

;this adds [ESI] + [ESI+4] together in EAX for pritning
_assignEvenNumbers:
	MOV		EAX, [ESI]			
	ADD		EAX, [ESI+4]				;add slots [x] and [x+4]
	MOV		EDX, 0
	MOV		EBX, 2
	DIV		EBX
	CMP		EDX, 0						;if the remainder when dividing ([index] + [index+4])/2 is 0 then print results
	JE		_printMedian				;else round up because the remainder is 1 which is .5
	INC		EAX
	JMP		_printMedian

;if there is one middle number then the procedure finds it in _exactMedian
_exactMedian:
	MOV		EDX, 0
	MOV		EBX, EAX					;start out are position in EDX and assign EAX to EBX
	_exactMedianLoop:
	CMP		EDX, EBX				
	JE		_assignExactMedian			;compare EDX to EBX to determine if the correct position was found and jump to _assignExactMedian
	INC		EDX
	ADD		ESI, 4		
	JMP		_exactMedianLoop			;inc EDX if not equal to EAX and inc ESI to not slot in array, then jump to _exactMedianLoop

;once the correct ESI position is found, move [ESI] to EAX
_assignExactMedian:
	MOV		EAX, [ESI]

;print the median
_printMedian:
	MOV		EDX, [EBP+16]				;assign mediantitle address to EDX
	CALL	WriteString
	CALL	WriteDec
	CALL	CrLf
	CALL	CrLf

	POP		EBP
	RET		12							;ret 12 to move stack to point of passed parameters
displayMedian ENDP



; --------------------------------------------------
; Name: displayList
; 
; Decriptions: procedure displays the unsorted randArray, sorted randArray, and counts depending on which integer was pushed to the stack (1,2,3)
;
; Preconditions: 
;	Possible three preconditions depending on what this procedure is printing
;	- randArray is an array of size ARRAYSIZE with random numbers between LO and HI filled in and is type DWORD
;	- randArray is an array of size ARRAYSIZE with random numbers between LO and HI filled in and is type DWORD and is sorted
;	- counts is an array of size (HI - LO + 1), populated with count each number in randArray, and is of type BYTE
; 
; Postconditions: EBP, ESI, EAX, EDX, EBX, ECX are changed
;
; Receives: 
;	[EBP+8] = address of spaces
;	[EBP+12] = 1, 2, or 3
;	[EBP+16] = either ARRAYSIZE or COUNTSIZE
;	[EBP+20] = Either address of randArray or counts
;	[EBP+24] = Either address of mediantitle, sortedtitle, or unsortedtitle
;
; Returns: nothing
; --------------------------------------------------
displayList PROC

	PUSH	EBP							;push EBP and assign ESP to EBP
	MOV		EBP, ESP
	MOV		EAX, [EBP+12]				;move pushed integer into EAX
	MOV		ESI, [EBP+20]				;move array address that is passed into ESI
	MOV		ECX, [EBP+16]				;move array size into ECX 

;------------------------------------------------------------
;unsortedPrint is the first part of the displayList procedure
;that prints the randArray when it is unsorted. It does this
;by seeing if 1 was pushed and is in [EBP+12]
;------------------------------------------------------------
_unsortedPrint:
	CMP		EAX, 1
	JNE		_sortedPrint				;if 1 was passed, continue printing the unsorted array else jump to _sortedPrint
	MOV		EDX, [EBP+24]
	CALL	WriteString					;let user know we are displaying the unsorted array
	MOV		EBX, 0

;The unsortedPrintLoop loops through the array to print out each element, 20 per row
_unsortedPrintLoop:
	MOV		EAX, [ESI]
	CALL	WriteDec					;write [ESI] which is the current value of ESI pointer
	MOV		EDX, [EBP+8]			
	CALL	WriteString					;implement space in print
	INC		EBX
	ADD		ESI, 4
	CMP		EBX, 20											
	JE		_unsortedReturnPrint		;when EBX is 20 jump to _unsortedReturnPrint to print new line, set EBX back to 0, and jump back in at _returnFromUnsorted
_returnFromUnsorted:
	LOOP	_unsortedPrintLoop
	JMP		_endPrints					;jump to endPrints when array is done printing
_unsortedReturnPrint:
	CALL	CrLf
	MOV		EBX,0
	JMP		_returnFromUnsorted

;------------------------------------------------------------
;sortedPrint is the second part of the displayList procedure
;that prints the randArray when it is sorted. It does this
;by seeing if 2 was pushed and is in [EBP+12]
;------------------------------------------------------------
_sortedPrint:
	CMP		EAX, 2
	JNE		_countsPrint				;if 2 was passed, continue printing the sorted array else jump to _countsPrint
	MOV		EDX, [EBP+24]
	CALL	WriteString					;let user know we are displaying the unsorted array
	MOV		EBX, 0

;The sortedPrintLoop loops through the array to print out each element, 20 per row
_sortedPrintLoop:
	MOV		EAX, [ESI]
	CALL	WriteDec					;write [ESI] which is the current value of ESI pointer
	MOV		EDX, [EBP+8]			
	CALL	WriteString					;implement space in print
	INC		EBX
	ADD		ESI, 4
	CMP		EBX, 20											
	JE		_sortedReturnPrint			;when EBX is 20 jump to _sortedReturnPrint to print new line, set EBX back to 0, and jump back in at _returnFromSorted
_returnFromSorted:
	LOOP	_sortedPrintLoop
	JMP		_endPrints					;jump to endPrints when array is done printing
_sortedReturnPrint:
	CALL	CrLf
	MOV		EBX,0
	JMP		_returnFromSorted

;------------------------------------------------------------
;countsPrint is the third part of the displayList procedure
;that prints count when it is sorted. It does this
;by seeing if 3 was pushed and is in [EBP+12]
;------------------------------------------------------------
_countsPrint:
	CMP		EAX, 3
	JNE		_endPrints					;if 2 was passed, continue printing the sorted array else jump to _endPrints
	MOV		EDX, [EBP+24]
	CALL	WriteString					;let user know we are displaying the unsorted array
	MOV		EBX, 0

;The countPrintLoop loops through the array to print out each element, 20 per row
_countPrintLoop:
	MOV		EAX, 0
	MOV		AL, [ESI]
	CALL	WriteDec					;write [ESI] which is the current value of ESI pointer
	MOV		EDX, [EBP+8]			
	CALL	WriteString					;implement space in print
	INC		EBX
	INC		ESI
	CMP		EBX, 20											
	JE		_countReturnPrint			;when EBX is 20 jump to _countReturnPrint to print new line, set EBX back to 0, and jump back in at _returnFromCount
_returnFromCount:
	LOOP	_countPrintLoop
	JMP		_endPrints					;jump to endPrints when array is done printing
_countReturnPrint:
	CALL	CrLf
	MOV		EBX,0
	JMP		_returnFromCount

;the last two labels determine whether to print one or two returns based on if the last row is complete or not
_endPrints:	
	CMP		EBX, 0
	JE		_oneReturn
	CALL	CrLf

_oneReturn:
	CALL	CrLf

	POP		EBP
	RET		20
displayList	ENDP



; --------------------------------------------------
; Name: farewell
; 
; Decriptions: procedure displays a farewell message
;
; Preconditions: goodbye is a string that is used to display the farewell message
; 
; Postconditions: EBP, EDX are changes
;
; Receives: 
;	[EBP+8] = address of goodbye
;
; Returns: nothing
; --------------------------------------------------
farewell PROC
	PUSH	EBP
	MOV		EBP, ESP
	MOV		EDX, [EBP+8]
	CALL	WriteString

	POP		EBP
	RET		4
farewell ENDP

END main
