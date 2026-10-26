# your code goes here
# your code goes here

1. Write an assembly language program that can print a string.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter a string: $'
MSG2 DB 0DH,0AH,'You entered: $'
BUF DB 50,?,50 DUP(0)
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
LEA DX,BUF
MOV AH,0AH ; buffered string input
INT 21H
MOV BL,BUF+1 ; number of characters typed
MOV BH,0
MOV BUF[BX+2],'$' ; terminate string for printing
LEA DX,MSG2
CALL PRINT_STR
LEA DX,BUF+2
CALL PRINT_STR
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
END MAIN
2. Write an assembly language program that can add and subtract two number up to 3
digits.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter first number (max 3 digits): $'
MSG2 DB 0DH,0AH,'Enter second number (max 3 digits): $'
MSG3 DB 0DH,0AH,'Sum = $'
MSG4 DB 0DH,0AH,'Difference = $'
NUM1 DW ?
NUM2 DW ?
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
CALL READ_NUM
MOV NUM1,AX
LEA DX,MSG2
CALL PRINT_STR
CALL READ_NUM
MOV NUM2,AX
LEA DX,MSG3
CALL PRINT_STR
MOV AX,NUM1
ADD AX,NUM2
CALL PRINT_SIGNED
LEA DX,MSG4
CALL PRINT_STR
MOV AX,NUM1
SUB AX,NUM2
CALL PRINT_SIGNED
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
READ_NUM PROC ; reads a decimal number, result in AX
PUSH BX
PUSH CX
PUSH DX
XOR BX,BX
RN_LOOP:
MOV AH,1
INT 21H
CMP AL,13
JE RN_DONE
SUB AL,'0'
MOV AH,0
MOV CX,AX
MOV AX,BX
MOV DX,10
MUL DX
ADD AX,CX
MOV BX,AX
JMP RN_LOOP
RN_DONE:
MOV AX,BX
POP DX
POP CX
POP BX
RET
READ_NUM ENDP
PRINT_SIGNED PROC ; prints signed number in AX
PUSH AX
PUSH BX
PUSH CX
PUSH DX
TEST AX,8000H
JZ PS_POS
PUSH AX
MOV DL,'-'
MOV AH,2
INT 21H
POP AX
NEG AX
PS_POS:
XOR CX,CX
MOV BX,10
PS_DIV:
XOR DX,DX
DIV BX
PUSH DX
INC CX
CMP AX,0
JNE PS_DIV
PS_OUT:
POP DX
ADD DL,'0'
MOV AH,2
INT 21H
LOOP PS_OUT
POP DX
POP CX
POP BX
POP AX
RET
PRINT_SIGNED ENDP
END MAIN
3. Write an assembly language program that can convert an uppercase letter to a lowercase
/ a lowercase letter to a uppercase letter.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter a letter: $'
MSG2 DB 0DH,0AH,'Converted character: $'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
MOV AH,1
INT 21H
MOV BL,AL
CMP BL,'A'
JB SHOW
CMP BL,'Z'
JBE TO_LOWER
CMP BL,'a'
JB SHOW
CMP BL,'z'
JA SHOW
SUB BL,20H ; lowercase -> uppercase
JMP SHOW
TO_LOWER:
ADD BL,20H ; uppercase -> lowercase
SHOW:
LEA DX,MSG2
CALL PRINT_STR
MOV DL,BL
MOV AH,2
INT 21H
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
END MAIN
4. Write an assembly language program that can reverse a bit pattern.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter an 8-bit binary pattern: $'
MSG2 DB 0DH,0AH,'Reversed pattern: $'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
MOV CX,8
XOR BL,BL
READ_BITS:
MOV AH,1
INT 21H
SUB AL,'0'
SHL BL,1
OR BL,AL
LOOP READ_BITS
MOV CX,8
XOR BH,BH
REVERSE:
SHR BL,1 ; LSB goes to carry
RCL BH,1 ; carry enters BH from the right
LOOP REVERSE
LEA DX,MSG2
CALL PRINT_STR
MOV CX,8
SHOW_BITS:
SHL BH,1
MOV DL,'0'
ADC DL,0 ; DL = '0' + carry
MOV AH,2
INT 21H
LOOP SHOW_BITS
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
END MAIN
5. Write an assembly language program that can reverse the given input.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter text (press Enter to finish): $'
MSG2 DB 0DH,0AH,'Reversed text: $'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
XOR CX,CX
READ_LOOP:
MOV AH,1
INT 21H
CMP AL,13
JE DONE_READ
XOR AH,AH
PUSH AX
INC CX
JMP READ_LOOP
DONE_READ:
LEA DX,MSG2
CALL PRINT_STR
JCXZ EXIT
SHOW_LOOP:
POP DX
MOV AH,2
INT 21H
LOOP SHOW_LOOP
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
END MAIN
6. Push operation on stack / pop operation on stack.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter 5 characters to PUSH on the stack: $'
MSG2 DB 0DH,0AH,'POP order (last in, first out): $'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
MOV CX,5
PUSH_LOOP:
MOV AH,1
INT 21H
XOR AH,AH
PUSH AX ; push operation
LOOP PUSH_LOOP
LEA DX,MSG2
CALL PRINT_STR
MOV CX,5
POP_LOOP:
POP DX ; pop operation
MOV AH,2
INT 21H
LOOP POP_LOOP
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
END MAIN
7. Print the Fibonacci series.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'How many terms (max 23)? $'
MSG2 DB 0DH,0AH,'Fibonacci series: $'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
CALL READ_NUM
MOV CX,AX
JCXZ EXIT
LEA DX,MSG2
CALL PRINT_STR
XOR AX,AX ; first term = 0
MOV BX,1 ; second term = 1
FIB_LOOP:
CALL PRINT_NUM
PUSH AX
MOV DL,' '
MOV AH,2
INT 21H
POP AX
MOV DX,AX
ADD DX,BX ; next term
MOV AX,BX
MOV BX,DX
LOOP FIB_LOOP
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
READ_NUM PROC ; reads a decimal number, result in AX
PUSH BX
PUSH CX
PUSH DX
XOR BX,BX
RN_LOOP:
MOV AH,1
INT 21H
CMP AL,13
JE RN_DONE
SUB AL,'0'
MOV AH,0
MOV CX,AX
MOV AX,BX
MOV DX,10
MUL DX
ADD AX,CX
MOV BX,AX
JMP RN_LOOP
RN_DONE:
MOV AX,BX
POP DX
POP CX
POP BX
RET
READ_NUM ENDP
PRINT_NUM PROC ; prints unsigned number in AX
PUSH AX
PUSH BX
PUSH CX
PUSH DX
XOR CX,CX
MOV BX,10
PN_DIV:
XOR DX,DX
DIV BX
PUSH DX
INC CX
CMP AX,0
JNE PN_DIV
PN_OUT:
POP DX
ADD DL,'0'
MOV AH,2
INT 21H
LOOP PN_OUT
POP DX
POP CX
POP BX
POP AX
RET
PRINT_NUM ENDP
END MAIN
8. Find the given number is even or odd.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter a number: $'
MSG2 DB 0DH,0AH,'The number is EVEN$'
MSG3 DB 0DH,0AH,'The number is ODD$'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
CALL READ_NUM
TEST AX,1 ; check the lowest bit
JZ IS_EVEN
LEA DX,MSG3
CALL PRINT_STR
JMP EXIT
IS_EVEN:
LEA DX,MSG2
CALL PRINT_STR
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
READ_NUM PROC ; reads a decimal number, result in AX
PUSH BX
PUSH CX
PUSH DX
XOR BX,BX
RN_LOOP:
MOV AH,1
INT 21H
CMP AL,13
JE RN_DONE
SUB AL,'0'
MOV AH,0
MOV CX,AX
MOV AX,BX
MOV DX,10
MUL DX
ADD AX,CX
MOV BX,AX
JMP RN_LOOP
RN_DONE:
MOV AX,BX
POP DX
POP CX
POP BX
RET
READ_NUM ENDP
END MAIN
9. Multiplication / Division of two numbers up to 2 or 3 digits.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter first number (max 3 digits): $'
MSG2 DB 0DH,0AH,'Enter second number (max 3 digits): $'
MSG3 DB 0DH,0AH,'Product = $'
MSG4 DB 0DH,0AH,'Quotient = $'
MSG5 DB 0DH,0AH,'Remainder = $'
MSG6 DB 0DH,0AH,'Cannot divide by zero$'
NUM1 DW ?
NUM2 DW ?
QUO DW ?
REM DW ?
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
CALL READ_NUM
MOV NUM1,AX
LEA DX,MSG2
CALL PRINT_STR
CALL READ_NUM
MOV NUM2,AX
LEA DX,MSG3
CALL PRINT_STR
MOV AX,NUM1
MUL NUM2 ; DX:AX = NUM1 * NUM2
CALL PRINT32
CMP NUM2,0
JE DIV_ZERO
MOV AX,NUM1
XOR DX,DX
DIV NUM2 ; AX = quotient, DX = remainder
MOV QUO,AX
MOV REM,DX
LEA DX,MSG4
CALL PRINT_STR
MOV AX,QUO
XOR DX,DX
CALL PRINT32
LEA DX,MSG5
CALL PRINT_STR
MOV AX,REM
XOR DX,DX
CALL PRINT32
JMP EXIT
DIV_ZERO:
LEA DX,MSG6
CALL PRINT_STR
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
READ_NUM PROC ; reads a decimal number, result in AX
PUSH BX
PUSH CX
PUSH DX
XOR BX,BX
RN_LOOP:
MOV AH,1
INT 21H
CMP AL,13
JE RN_DONE
SUB AL,'0'
MOV AH,0
MOV CX,AX
MOV AX,BX
MOV DX,10
MUL DX
ADD AX,CX
MOV BX,AX
JMP RN_LOOP
RN_DONE:
MOV AX,BX
POP DX
POP CX
POP BX
RET
READ_NUM ENDP
PRINT32 PROC ; prints unsigned 32-bit number in DX:AX
PUSH AX
PUSH BX
PUSH CX
PUSH DX
PUSH SI
PUSH DI
MOV DI,10
XOR CX,CX
P32_LOOP:
MOV BX,AX
MOV AX,DX
XOR DX,DX
DIV DI
MOV SI,AX
MOV AX,BX
DIV DI
PUSH DX
INC CX
MOV DX,SI
MOV BX,AX
OR BX,DX
JNZ P32_LOOP
P32_OUT:
POP DX
ADD DL,'0'
MOV AH,2
INT 21H
LOOP P32_OUT
POP DI
POP SI
POP DX
POP CX
POP BX
POP AX
RET
PRINT32 ENDP
END MAIN
10. Grade calculation for take user input <=100. Where, Marks>=80 then A+; Marks>=70 then
A; Marks>=60 then B; Marks<60 then C.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter marks (0-100): $'
MSG2 DB 0DH,0AH,'Grade: A+$'
MSG3 DB 0DH,0AH,'Grade: A$'
MSG4 DB 0DH,0AH,'Grade: B$'
MSG5 DB 0DH,0AH,'Grade: C$'
MSG6 DB 0DH,0AH,'Invalid marks$'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
CALL READ_NUM
CMP AX,100
JA INVALID
CMP AX,80
JAE GRADE_AP
CMP AX,70
JAE GRADE_A
CMP AX,60
JAE GRADE_B
LEA DX,MSG5
JMP SHOW
GRADE_AP:
LEA DX,MSG2
JMP SHOW
GRADE_A:
LEA DX,MSG3
JMP SHOW
GRADE_B:
LEA DX,MSG4
JMP SHOW
INVALID:
LEA DX,MSG6
SHOW:
CALL PRINT_STR
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
READ_NUM PROC ; reads a decimal number, result in AX
PUSH BX
PUSH CX
PUSH DX
XOR BX,BX
RN_LOOP:
MOV AH,1
INT 21H
CMP AL,13
JE RN_DONE
SUB AL,'0'
MOV AH,0
MOV CX,AX
MOV AX,BX
MOV DX,10
MUL DX
ADD AX,CX
MOV BX,AX
JMP RN_LOOP
RN_DONE:
MOV AX,BX
POP DX
POP CX
POP BX
RET
READ_NUM ENDP
END MAIN
11. Write an assembly language program that can compute the sum of 4 natural numbers.
The first 4 natural numbers are 1,2,3,4 and the sum is 10.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'How many natural numbers to add (max 360)? $'
MSG2 DB 0DH,0AH,'Sum = $'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
CALL READ_NUM
MOV CX,AX
XOR BX,BX ; BX holds the sum
JCXZ SHOW
SUM_LOOP:
ADD BX,CX ; adds N, N-1, ... , 1
LOOP SUM_LOOP
SHOW:
LEA DX,MSG2
CALL PRINT_STR
MOV AX,BX
CALL PRINT_NUM
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
READ_NUM PROC ; reads a decimal number, result in AX
PUSH BX
PUSH CX
PUSH DX
XOR BX,BX
RN_LOOP:
MOV AH,1
INT 21H
CMP AL,13
JE RN_DONE
SUB AL,'0'
MOV AH,0
MOV CX,AX
MOV AX,BX
MOV DX,10
MUL DX
ADD AX,CX
MOV BX,AX
JMP RN_LOOP
RN_DONE:
MOV AX,BX
POP DX
POP CX
POP BX
RET
READ_NUM ENDP
PRINT_NUM PROC ; prints unsigned number in AX
PUSH AX
PUSH BX
PUSH CX
PUSH DX
XOR CX,CX
MOV BX,10
PN_DIV:
XOR DX,DX
DIV BX
PUSH DX
INC CX
CMP AX,0
JNE PN_DIV
PN_OUT:
POP DX
ADD DL,'0'
MOV AH,2
INT 21H
LOOP PN_OUT
POP DX
POP CX
POP BX
POP AX
RET
PRINT_NUM ENDP
END MAIN
12. IBM characters display.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter start ASCII code (0-255): $'
MSG2 DB 0DH,0AH,'Enter end ASCII code (0-255): $'
MSG3 DB 0DH,0AH,'$'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
CALL READ_NUM
MOV BX,AX ; BX = current code
LEA DX,MSG2
CALL PRINT_STR
CALL READ_NUM
MOV DI,AX ; DI = last code
CMP DI,255
JBE RANGE_OK
MOV DI,255
RANGE_OK:
LEA DX,MSG3
CALL PRINT_STR
XOR SI,SI ; characters on current line
SHOW_LOOP:
CMP BX,DI
JA EXIT
CMP BX,7 ; skip control codes that move the cursor
JE NEXT
CMP BX,8
JE NEXT
CMP BX,9
JE NEXT
CMP BX,10
JE NEXT
CMP BX,13
JE NEXT
MOV DX,BX
MOV AH,2
INT 21H ; display the IBM character
MOV DL,' '
INT 21H
INC SI
CMP SI,16
JNE NEXT
CALL NEWLINE
XOR SI,SI
NEXT:
INC BX
JMP SHOW_LOOP
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
READ_NUM PROC ; reads a decimal number, result in AX
PUSH BX
PUSH CX
PUSH DX
XOR BX,BX
RN_LOOP:
MOV AH,1
INT 21H
CMP AL,13
JE RN_DONE
SUB AL,'0'
MOV AH,0
MOV CX,AX
MOV AX,BX
MOV DX,10
MUL DX
ADD AX,CX
MOV BX,AX
JMP RN_LOOP
RN_DONE:
MOV AX,BX
POP DX
POP CX
POP BX
RET
READ_NUM ENDP
NEWLINE PROC
PUSH AX
PUSH DX
MOV AH,2
MOV DL,0DH
INT 21H
MOV DL,0AH
INT 21H
POP DX
POP AX
RET
NEWLINE ENDP
END MAIN
13. Print the largest number of two or three digits.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter first number (2 or 3 digits): $'
MSG2 DB 0DH,0AH,'Enter second number (2 or 3 digits): $'
MSG3 DB 0DH,0AH,'Enter third number (2 or 3 digits): $'
MSG4 DB 0DH,0AH,'Largest number = $'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
CALL READ_NUM
MOV BX,AX ; BX = largest so far
LEA DX,MSG2
CALL PRINT_STR
CALL READ_NUM
CMP AX,BX
JBE SKIP1
MOV BX,AX
SKIP1:
LEA DX,MSG3
CALL PRINT_STR
CALL READ_NUM
CMP AX,BX
JBE SKIP2
MOV BX,AX
SKIP2:
LEA DX,MSG4
CALL PRINT_STR
MOV AX,BX
CALL PRINT_NUM
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
READ_NUM PROC ; reads a decimal number, result in AX
PUSH BX
PUSH CX
PUSH DX
XOR BX,BX
RN_LOOP:
MOV AH,1
INT 21H
CMP AL,13
JE RN_DONE
SUB AL,'0'
MOV AH,0
MOV CX,AX
MOV AX,BX
MOV DX,10
MUL DX
ADD AX,CX
MOV BX,AX
JMP RN_LOOP
RN_DONE:
MOV AX,BX
POP DX
POP CX
POP BX
RET
READ_NUM ENDP
PRINT_NUM PROC ; prints unsigned number in AX
PUSH AX
PUSH BX
PUSH CX
PUSH DX
XOR CX,CX
MOV BX,10
PN_DIV:
XOR DX,DX
DIV BX
PUSH DX
INC CX
CMP AX,0
JNE PN_DIV
PN_OUT:
POP DX
ADD DL,'0'
MOV AH,2
INT 21H
LOOP PN_OUT
POP DX
POP CX
POP BX
POP AX
RET
PRINT_NUM ENDP
END MAIN
14. Write an assembly language code that displays the one that comes first in the character
sequence.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter first character: $'
MSG2 DB 0DH,0AH,'Enter second character: $'
MSG3 DB 0DH,0AH,'Character that comes first: $'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
MOV AH,1
INT 21H
MOV BL,AL
LEA DX,MSG2
CALL PRINT_STR
MOV AH,1
INT 21H
CMP BL,AL
JBE SHOW
MOV BL,AL
SHOW:
LEA DX,MSG3
CALL PRINT_STR
MOV DL,BL
MOV AH,2
INT 21H
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
END MAIN
15. Write some code to read characters until a blank is read.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Type characters (a blank space stops the input): $'
MSG2 DB 0DH,0AH,'Blank read. Characters before the blank: $'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
XOR BX,BX ; character counter
READ_LOOP:
MOV AH,1
INT 21H
CMP AL,' '
JE DONE
INC BX
JMP READ_LOOP
DONE:
LEA DX,MSG2
CALL PRINT_STR
MOV AX,BX
CALL PRINT_NUM
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
PRINT_NUM PROC ; prints unsigned number in AX
PUSH AX
PUSH BX
PUSH CX
PUSH DX
XOR CX,CX
MOV BX,10
PN_DIV:
XOR DX,DX
DIV BX
PUSH DX
INC CX
CMP AX,0
JNE PN_DIV
PN_OUT:
POP DX
ADD DL,'0'
MOV AH,2
INT 21H
LOOP PN_OUT
POP DX
POP CX
POP BX
POP AX
RET
PRINT_NUM ENDP
END MAIN
16. Write a count-controlled loop to display a row of 80 stars.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'How many stars to display (enter 80 for a full row)? $'
MSG2 DB 0DH,0AH,'$'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
CALL READ_NUM
MOV CX,AX ; loop counter
JCXZ EXIT
LEA DX,MSG2
CALL PRINT_STR
STAR_LOOP:
MOV DL,'*'
MOV AH,2
INT 21H
LOOP STAR_LOOP
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
READ_NUM PROC ; reads a decimal number, result in AX
PUSH BX
PUSH CX
PUSH DX
XOR BX,BX
RN_LOOP:
MOV AH,1
INT 21H
CMP AL,13
JE RN_DONE
SUB AL,'0'
MOV AH,0
MOV CX,AX
MOV AX,BX
MOV DX,10
MUL DX
ADD AX,CX
MOV BX,AX
JMP RN_LOOP
RN_DONE:
MOV AX,BX
POP DX
POP CX
POP BX
RET
READ_NUM ENDP
END MAIN
17. Write an assembly language program that will display a single '?' (question mark)
character on the screen.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Press any key to display the question mark: $'
MSG2 DB 0DH,0AH,'Output: $'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
MOV AH,1 ; wait for a key
INT 21H
LEA DX,MSG2
CALL PRINT_STR
MOV DL,'?'
MOV AH,2
INT 21H
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
END MAIN
18. Read two capital letters and display in alphabetical order.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter first capital letter: $'
MSG2 DB 0DH,0AH,'Enter second capital letter: $'
MSG3 DB 0DH,0AH,'In alphabetical order: $'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
MOV AH,1
INT 21H
MOV BL,AL
LEA DX,MSG2
CALL PRINT_STR
MOV AH,1
INT 21H
MOV BH,AL
CMP BL,BH
JBE ORDERED
XCHG BL,BH
ORDERED:
LEA DX,MSG3
CALL PRINT_STR
MOV AH,2
MOV DL,BL
INT 21H
MOV DL,' '
INT 21H
MOV DL,BH
INT 21H
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
END MAIN
19. Read a character. If it's "y" or "Y", display it; otherwise terminate the program.
.MODEL SMALL
.STACK 100H
.DATA
MSG1 DB 'Enter a character: $'
MSG2 DB 0DH,0AH,'You entered: $'
.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX
LEA DX,MSG1
CALL PRINT_STR
MOV AH,1
INT 21H
MOV BL,AL
CMP BL,'y'
JE SHOW
CMP BL,'Y'
JE SHOW
JMP EXIT ; any other character: terminate
SHOW:
LEA DX,MSG2
CALL PRINT_STR
MOV DL,BL
MOV AH,2
INT 21H
EXIT:
MOV AH,4CH
INT 21H
MAIN ENDP
PRINT_STR PROC
PUSH AX
MOV AH,9
INT 21H
POP AX
RET
PRINT_STR ENDP
END MAIN




20. calculator:
	

.model small
.stack 100h

.data
    num1 dw ?
    num2 dw ?
    opr  db ?

    msg1 db 'Enter first number (0-999): $'
    msg2 db 0Dh,0Ah,'Enter second number (0-999): $'
    msg3 db 0Dh,0Ah,'Enter operator (+,-,*,/): $'
    msg4 db 0Dh,0Ah,'Result: $'
    msg5 db 0Dh,0Ah,'Cannot divide by zero!$'
    msg6 db 0Dh,0Ah,'Invalid operator!$'

.code
main proc
    mov ax, @data
    mov ds, ax

    ; Read first number
    lea dx, msg1
    mov ah, 09h
    int 21h

    call read_num
    mov num1, ax

    ; Read second number
    lea dx, msg2
    mov ah, 09h
    int 21h

    call read_num
    mov num2, ax

    ; Read operator
    lea dx, msg3
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    mov opr, al

    ; New line
    mov dl, 0Dh
    mov ah, 02h
    int 21h
    mov dl, 0Ah
    mov ah, 02h
    int 21h

    ; Select operation
    mov ax, num1
    mov bx, num2

    cmp opr, '+'
    je addition

    cmp opr, '-'
    je subtraction

    cmp opr, '*'
    je multiplication

    cmp opr, '/'
    je division

    lea dx, msg6
    mov ah, 09h
    int 21h
    jmp exit

addition:
    add ax, bx
    xor dx, dx
    jmp display_result

subtraction:
    cmp ax, bx
    jae sub_positive

    ; Negative result
    sub bx, ax
    mov ax, bx

    lea dx, msg4
    mov ah, 09h
    int 21h

    mov dl, '-'
    mov ah, 02h
    int 21h

    xor dx, dx
    call print_num
    jmp exit

sub_positive:
    sub ax, bx
    xor dx, dx
    jmp display_result

multiplication:
    mul bx              ; DX:AX = AX * BX
    jmp display_result

division:
    cmp bx, 0
    je divide_error

    xor dx, dx
    div bx              ; AX = quotient, DX = remainder
    xor dx, dx           ; Display quotient only
    jmp display_result

divide_error:
    lea dx, msg5
    mov ah, 09h
    int 21h
    jmp exit

display_result:
    lea dx, msg4
    mov ah, 09h
    int 21h

    call print_num
    jmp exit

; Read a decimal number (0-999)
read_num proc
    xor bx, bx

read_loop:
    mov ah, 01h
    int 21h

    cmp al, 0Dh
    je read_done

    sub al, '0'
    xor ah, ah
    mov si, ax           ; Save digit

    mov ax, bx
    mov cx, 10
    mul cx
    add ax, si
    mov bx, ax

    jmp read_loop

read_done:
    mov ax, bx
    ret
read_num endp

; Print unsigned number in DX:AX
; Supports results up to 998001
print_num proc
    mov bx, 10
    xor cx, cx

    ; Handle zero
    mov si, ax
    mov di, dx
    or si, di
    jnz convert_loop

    mov dl, '0'
    mov ah, 02h
    int 21h
    ret

convert_loop:
    ; Divide the high word by 10
    mov si, ax
    mov ax, dx
    xor dx, dx
    div bx
    mov di, ax           ; New high word

    ; Divide remainder:low word by 10
    mov ax, si
    div bx

    push dx              ; Save decimal digit
    inc cx

    mov dx, di
    or dx, dx
    jnz convert_loop

    or ax, ax
    jnz convert_loop

print_loop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_loop

    ret
print_num endp

exit:
    mov ah, 4Ch
    int 21h

main endp
end main
