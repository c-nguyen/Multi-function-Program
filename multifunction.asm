#  Data Area
.data

welcome:
	.asciiz " \n\n Main Menu:"

option1:
	.asciiz " \n 1 - Add 2 Numbers"
	
option2:
	.asciiz " \n 2 - Multiply 4 Numbers"
	
option3:
	.asciiz " \n 3 - String Manipulation"

option4:
	.asciiz " \n 4 - Print Fibonacci Sequence"
	
option5:
	.asciiz " \n 5 - Exit"
	
prompt: 
	.asciiz " \n\n Enter the task number you wish to perform: "
	
first:
	.asciiz " \n Enter the first number: "
	
second:
	.asciiz " \n Enter the second number: "
	
third:
	.asciiz " \n Enter the third number: "
	
fourth:
	.asciiz " \n Enter the fourth number: "
	
sum:
	.asciiz " \n The sum is: "
	
product:
	.asciiz " \n The product is: "
	
string:
	.asciiz " \n Enter a string (max. 30 chars.): "
	
stringlength:
	.asciiz " \n Your string length is: "
	
reversedstring:
	.asciiz " \n The string reversed is: "
	
fibint:
	.asciiz " \n Enter a number: "
	
fibint2:
	.asciiz " \n Fibonacci values up until entered integer: "
	
space:
	.asciiz "  "
	
exit:
	.asciiz " \n Exit Program"
	
frequency:
	.asciiz " \n Frequency of "

frequency2:
	.asciiz " is: "
	
errormsg:
	.asciiz " \n -----ERROR! Not a valid option-----"
	
input264:
	.asciiz " \n Input 264? "
	
password:
	.asciiz "Davarpanah"
	
allocatemsg:
	.asciiz " \n number of bytes to allocate? "
	
allocatemsg2:
	.asciiz " \n The memory was allocated at address "
	
myname:
	.asciiz "christinenguyen"

endheapmsg:
	.asciiz " \n Identity in HEAP"
	
user264:
	.space 11
	
userinput:
	.space 32
	

#Text Area (i.e. instructions)
.text

main:
	j MAINMENU
	
MAINMENU:
    addi	$v0, $0, 4			# System call code: print string
	la		$a0, welcome		# Label welcome is printed
	syscall
	la		$a0, option1		# Label option1 is loaded and printed
	syscall
	la		$a0, option2		# Label option2 is loaded and printed
	syscall
	la		$a0, option3		# Label option3 is loaded and printed
	syscall
	la		$a0, option4		# Label option4 is loaded and printed
	syscall
	la		$a0, option5		# Label option5 is loaded and printed
	syscall
	la		$a0, prompt			# Label prompt is loaded and printed
	syscall
	addi	$v0, $0, 5			# System call code: read integer
	syscall
	
	addi	$t0, $0, 1			# $t0 = 1
	addi	$t1, $0, 2			# $t1 = 2
	addi	$t2, $0, 3			# $t2 = 3
	addi	$t3, $0, 4			# $t3 = 4
	addi	$t4, $0, 5			# $t4 = 5
	addi	$t5, $0, 264		# $t5 = 264
	beq		$v0, $t5, SECRET	# if (user input == 264)
	beq     $v0, $t0, ADDNUM	# if (user input == 1)
	beq     $v0, $t1, MULT		# if (user input == 2)
	beq		$v0, $t2, STRING	# if (user input == 3)
	beq     $v0, $t3, FIBSTART	# if (user input == 4)
	beq     $v0, $t4, EXIT		# if (user input == 5)
	blt		$v0, $t1, PRINTERROR
	bgt		$v0, $t4, PRINTERROR
	
	jr		$ra

SECRET:
	li		$v0, 4				# System call code: print string
	la		$a0, input264		# Label input264 is loaded and printed
	syscall
	li		$v0, 8				# System call code: read string
	la		$a0, user264
	li		$a1, 11				# 11 bytes of input allowed
	syscall
	
	addi	$t0, $a0, 0			# $t0 = user input
	la		$t1, password		# $t1 = password

SECRETCHECK:
	lb		$t8, 0($t0)			# $t8 = user input character at $t0
	lb		$t9, 0($t1)			# $t9 = password character at $t1
	bne		$t8, $t9, PRINTERROR# if ($t8 != $t9) print error
	addi	$t0, $t0, 1			# $t8++
	addi	$t1, $t1, 1			# $t9++
	beqz	$t8, ALLOCATESTART	# if passwords match, start allocating memory
	j		SECRETCHECK			# recursively check characters
	
ALLOCATESTART:
	li		$v0, 4				# System call code: print string
	la		$a0, allocatemsg	# Label allocatemsg is loaded and printed
	syscall
	li		$v0, 5				# System call code: read integer
	syscall
	addi	$s1, $v0, 0			# $s1 = number of bytes to allocate
	addi	$a0, $v0, 0			# $a0 = number of bytes to allocate
	li		$v0, 9				# System call code: allocate memory
	syscall
	addi	$s0, $v0, 0			# $s0 = address of first allocated byte
	li		$v0, 4				# System call code: print string
	la		$a0, allocatemsg2	# Label allocatemsg2 is loaded and printed
	syscall
	addi	$a0, $s0, 0			# $a0 = address of allocated memory
	li		$v0, 1				# System call code: print integer
	syscall
	
	la		$t0, myname			# $t0 = address of label myname
	addi	$t1, $0, 0			# $t1 = 0 (counter)
	
FILLHEAP:
	bge		$t1, $s1, ENDHEAP	# if ($t1 >= $s1), branch
	sw		$t0, 0($s0)			# heap address = content at address $t0
	addi	$t1, $t1, 4			# $t1 + 4 because heap address increments by 4
	addi	$s0, $s0, 4			# $s0 + 4
	j		FILLHEAP			# Recursively fill heap
	
ENDHEAP:
	li		$v0, 4				# System call code: print string
	la		$a0, endheapmsg		# Label error is loaded and printed
	syscall
	j		EXIT				# Jump to EXIT
	
PRINTERROR:
	li		$v0, 4				# System call code: print string
	la		$a0, errormsg		# Label error is loaded and printed
	syscall
	j		MAINMENU			# Jump back to main menu
	
ADDNUM:
	addi	$v0, $0, 4			# System call code: print string
	la		$a0, option1		# Label option1 is loaded and printed
	syscall
	la		$a0, first			# Label first is loaded and printed
	syscall
	addi	$v0, $0, 5			# Read the first number
	syscall
	addi    $t0, $v0, 0			# $t0 = first integer
	addi	$v0, $0, 4
	la		$a0, second			# Label second is loaded and printed
	syscall
	addi	$v0, $0, 5			# Read the second number
	syscall
	addi    $t1, $v0, 0			# $t1 = second integer
	addi	$v0, $0, 4			# System call code: print string
	la		$a0, sum			# Label sum is loaded and printed
	syscall
	addi	$v0, $0, 1			# System call code: print integer
	add     $a0, $t0, $t1		# Print the sum
	syscall
	j MAINMENU
	
MULT:
	addi	$v0, $0, 4			# System call code: print string
	la		$a0, option2		# Label option2 is loaded and printed
	syscall
	la		$a0, first			# Label first is loaded and printed
	syscall
	addi	$v0, $0, 5			# Read the first number
	syscall
	addi    $t0, $v0, 0			# $t0 = first integer
	addi	$v0, $0, 4			# System call code: print string
	la		$a0, second			# Label second is loaded and printed
	syscall
	addi	$v0, $0, 5			# Read the second number
	syscall
	mul     $t0, $t0, $v0		# multiply first two numbers
	addi	$v0, $0, 4			# System call code: print string
	la		$a0, third			# Label third is loaded and printed
	syscall
	addi	$v0, $0, 5			# Read the third number
	syscall
	mul     $t0, $t0, $v0		# multiply first, second, and third numbers
	addi	$v0, $0, 4			# System call code: print string
	la		$a0, fourth			# Label fourth is loaded and printed
	syscall
	addi	$v0, $0, 5			# Read the fourth number
	syscall
	mul     $t0, $t0, $v0		# multiply all four numbers
	addi	$v0, $0, 4			# System call code: print string
	la		$a0, product		# Label product is loaded and printed
	syscall
	addi	$v0, $0, 1			# System call code: print integer
	addi	$a0, $t0, 0			# Product of four numbers is printed
	syscall
	j MAINMENU					# Jump back to the main menu
	
STRING:
	li		$v0, 4				# System call code: print string
	la		$a0, option3		# Label option3 is loaded and printed
	syscall
	la		$a0, string			# Label string is loaded and printed
	syscall
	li		$v0, 8				# System call code: read string
	la		$a0, userinput		# Label userinput is loaded
	li		$a1, 32				# userinput can have maximum of 30 characters
	syscall

STARTLENGTH:
	addi	$s0, $a0, 0			# $s0 = address of userinput
	addi	$t0, $0, -1			# $t0 = set for string length - 1
	addi	$t1, $s0, 0			# $t1 = counter for userinput.charAt
	
FINDLENGTH:
	lb		$t8, 0($t1)			# $t8 = userinput.charAt(offset)
	beqz	$t8, SETVALUESFREQ	# if ($t8 == null pointer), jump to SETVALUES
	addi	$t1, $t1, 1			# else $t1 + 1 = move to next character
	addi	$t0, $t0, 1			# $t0 = string length + 1
	j		FINDLENGTH			# Recursively find length of userinput
	
SETVALUESFREQ:
	addi	$t1, $0, 0			# $t1 = int i = 0
	addi	$s1, $s0, 0			# $s1 = address of user input string
	addi	$s2, $s0, 0			# $s2 = address of user input string

CALCFREQ1:
	bge		$t1, $t0, SETVALUESREV
	addi	$t2, $0, 0			# $t2 = int j = 0
	addi	$s2, $s0, 0			# $s2 = address of user input string
	addi	$t3, $0, 0			# $t3 = int counter = 0
	
CALCFREQ2:
	bge		$t2, $t0, FREQ1ELSE	# if (j >= string.length), branch
	lb		$t8, 0($s1)			# $t8 = string.charAt(i)
	lb		$t9, 0($s2)			# $t9 = string.charAt(j)
	bne		$t8, $t9, FREQ2ELSE	# if (string.charAt(i) != string.charAt(j)), branch
	addi	$t3, $t3, 1			# else $t3 = counter + 1
	
FREQ2ELSE:
	addi	$t2, $t2, 1			# $t2 = j + 1
	addi	$s2, $s2, 1			# $s2 = address of string + offset j
	j		CALCFREQ2

FREQ1ELSE:
	li		$v0, 4				# System call code: print string
	la		$a0, frequency		# Label frequency is loaded and printed
	syscall
	li		$v0, 11				# System call code: print character
	move	$a0, $t8			# Load character and print
	syscall
	li		$v0, 4				# System call code: print string
	la		$a0, frequency2		# Label frequency2 is loaded and printed
	syscall
	li		$v0, 1				# System call code: print integer
	move	$a0, $t3			# Load frequency number and print
	syscall
	addi	$t1, $t1, 1			# $t1 = i + 1
	addi	$s1, $s1, 1			# $s1 = address of string + offset i
	j		CALCFREQ1			# Jump back into loop
	
SETVALUESREV:
	addi	$s1, $s0, 0			# $s1 = address of string
	addi	$t1, $0, 0			# $t1 = int i = 0
	addi	$t2, $t0, 0			# $t2 = string.length
	li		$v0, 4				# System call code: print string
	la		$a0, reversedstring	# Label reversedstring is loaded and printed
	syscall
	li		$v0, 11				# System call code: print character

REVERSE:
	add		$s2, $s1, $t2		# $s2 = address of last character	
	lb		$t9, 0($s2)			# $t9 = last character in userinput
	addi	$a0, $t9, 0			# Character is loaded and printed
	syscall
	beqz	$t2, MAINMENU		# if (string.length == 0), go back to main menu
	addi 	$t2, $t2, -1		# else string.lenghth - 1
	j		REVERSE				# Recursively print characters backwards
	
FIBSTART:
	li		$v0, 4				# System call code: print string
	la		$a0, fibint			# Label fibint is loaded and printed
	syscall
	li		$v0, 5				# System call code: read integer
	syscall

	addi	$t0, $v0, 0			# $t0 = integer user entered
	
	li		$v0, 4				# System call code: print string
	la		$a0, fibint2		# Label fibint2 is loaded and printed
	syscall
	
	addi	$a0, $t0, 0			# $a0 = $t0 = integer user entered
	addi	$a1, $0, 0			# $a1 = 0
	j		FIBPRINT
	
FIBPRINT:
	addi	$s0, $a0, 0			# $s0 = integer user entered
	addi	$s1, $a1, 0			# $s1 = counter

	addi	$a0, $a1, 0			# $a0 = counter
	jal		FIBONACCI			# FIBONACCI(counter)

	addi	$t0, $v0, 0			# $t0 = FIBONACCI(counter)

	bgt		$t0, $s0, MAINMENU	# if (FIBONACCI(counter) > user entered integer), branch
	li		$v0, 4				# System call code: print string
	la		$a0, space			# Label space is loaded and printed
	syscall
	addi	$a0, $t0, 0			# $a0 = FIBONACCI(counter)
	li		$v0, 1				# System call code: print integer
	syscall
	li		$v0, 4				# System call code: print string
	la		$a0, space			# Label comma is loaded and printed
	syscall

	addi	$a0, $s0, 0			# $a0 = integer user entered
	addi	$a1, $s1, 1			# $a1 = counter + 1
	j		FIBPRINT
	
FIBONACCI:
	addi	$sp, $sp, -12		# Allocate memory in stack
	sw		$ra, 0($sp)
	sw		$s0, 4($sp)
	sw		$s1, 8($sp)

	addi	$s0, $a0, 0			# $s0 = n = counter
	addi	$t1, $0, 1			# $t1 = 1
	blez	$s0, BASECASE0		# if (n <= 0), branch
	beq		$s0, $t1, BASECASE1	# if (n == 1), branch
	addi	$a0, $s0, -1		# else $a0 = n - 1

	jal		FIBONACCI			# FIBONACCI(n - 1)

	addi	$s1, $v0, 0			# $s1 = FIBONACCI(n - 1)
	addi	$a0, $s0, -2		# $a0 = n - 2

	jal		FIBONACCI			# FIBONACCI(n - 2)

	add		$v0, $s1, $v0       # $v0 = FIBONACCI(n-1) + FIBONACCI(n-2)

EXITFIB:
	lw		$ra, 0($sp)
	lw		$s0, 4($sp)
	lw		$s1, 8($sp)
	addi	$sp, $sp, 12		# Deallocate memory
	jr		$ra
	
BASECASE0:
	li		$v0, 0				# $v0 = 0
	j		EXITFIB

BASECASE1:
	li		$v0, 1				# $v0 = 1
	j		EXITFIB

EXIT:
	addi	$v0, $0, 4			# System call code: print string
	la		$a0, exit			# Label exit is loaded and printed
	syscall
	addi	$v0, , $0, 10		# Exit
	syscall
