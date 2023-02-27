###########################################################################
#  Name: Isabella Maffeo
#  Assignment: MIPS #5
#  Description:  Using a recursive algorithm determine the max value (price)
#				 for cutting a rod in sections, wherein the growth of the 
#				 price is non-linear.
#				 Print results in proper format.

#  CS 218, MIPS Assignment #5
###########################################################################
#  data segment

.data

# -----
#  Constants

TRUE = 1
FALSE = 0

# -----
#  Variables for main

hdr:		.ascii	"\nMIPS Assignment #5\n"
		.asciiz	"Titanium Rod Cut Maximum Value Program\n\n"

prices1:	.word	1, 5, 8, 9, 10, 17, 17, 20
maxLen1:	.word	8

prices2:	.word	3, 5, 8, 9, 10, 17, 17, 20, 24, 30
maxLen2:	.word	10

userPrompt:	.asciiz	"Enter another length (y/n)? "

endMsg:		.ascii	"\nYou have reached recursive nirvana.\n"
		.asciiz	"Program Terminated.\n"

# -----
#  Local variables for prtNewline function.

newLine:	.asciiz	"\n"

# -----
#  Local variables for displayResults() function.

msgMax:		.asciiz	"Maximum obtainable value is: "

# -----
#  Local variables for showPrices() function.

stars:		.ascii	"\n****************************************"
		.asciiz	"******************\n"
pricesMsg:	.asciiz	"Prices (max): "
dashs:		.asciiz	" ----"
xtra:		.asciiz	"-"
spc:		.asciiz " "
bar:		.asciiz	" | "
offset0:	.asciiz	"   "
offset1:	.asciiz	"  "
lengthsStr:  .asciiz "Lengths"
pricesStr:  .asciiz "Prices"


# -----
#  Local variables for readLength() function.

strtMsg1:	.asciiz	"Enter rod length (1-"
strtMsg2:	.asciiz	"): "

errValue:	.ascii	"\nError, invalid length. "
		.asciiz	"Please re-enter.\n"

# -----
#  Local variables for askPrompt() function.

ansErr:		.asciiz	"Error, must answer with (y/n).\n"
ans:		.space	3


###########################################################################
#  text/code segment

.text
.globl main
.ent main
main:

# -----
#  Display program header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----
#  First price list.

	la	$a0, prices1
	lw	$a1, maxLen1
	jal	showPrices

tryAgain1:
	lw	$a0, maxLen1
	jal	readLength

	la	$a0, prices1
	move	$a1, $v0
	jal	cutRod

	la	$a0, prices1
	move	$a1, $v0
	jal	displayResults

	la	$a0, userPrompt
	jal	askPrompt

	beq	$v0, TRUE, tryAgain1

# -----
#  Second price list.

	la	$a0, prices2
	lw	$a1, maxLen2
	jal	showPrices

tryAgain2:
	lw	$a0, maxLen2
	jal	readLength

	la	$a0, prices2
	move	$a1, $v0
	jal	cutRod

	la	$a0, prices2
	move	$a1, $v0
	jal	displayResults

	la	$a0, userPrompt
	jal	askPrompt

	beq	$v0, TRUE, tryAgain2

# -----
#  Done, show message and terminate program.

gameOver:
	li	$v0, 4
	la	$a0, endMsg
	syscall

	li	$v0, 10
	syscall					# all done...
.end main

# =========================================================================
#  Very simple function to print a new line.
#	Note, this routine is optional.

.globl	prtNewline
.ent	prtNewline
prtNewline:
	la	$a0, newLine
	li	$v0, 4
	syscall

	jr	$ra
.end	prtNewline

# =========================================================================
#  Function to recursivly determine the maximum value
#  for cutting the titanium rod.

# -----
#  Arguments:
#	$a0 - prices array, address
#	$a1 - length, value

#  Returns:
#	$v0 - maximum price


.globl	cutRod
.ent	cutRod
cutRod:
	# push
	subu $sp, $sp, 40					
	sw $s0, 0($sp)						
	sw $s1, 4($sp)						
	sw $s2, 8($sp)						
	sw $s3, 12($sp)						
	sw $s4, 16($sp)						
	sw $s5, 20($sp)						
	sw $s6, 24($sp)						
	sw $s7, 28($sp)						
	sw $fp, 32($sp)						
	sw $ra, 36($sp)						
	addu $fp, $sp, 40	
#----------------------------------------#
	move $s0, $a0				# preserve array
	move $s1, $a1				# preserve length
	li $s6, 0					# maxTemp = 0
	li $s7, 0					# i = 0

#---BASE CASE----------------------------#
	li $v0, 0					# if length is = 0, we must set $v0 = 0 because this function does return a value
	beq $s1, $v0, rodDone		# end function


	forLoop:	
		bge $s7, $s1, forDone	# if i > length, done with loop

		mul $t0, $s7, 4			# i * 4 (word-size)
		add $t9, $s0, $t0		# price[i] (next item in array)
		lw $s4, ($t9)			# grab value @ price[i]

		sub $s3, $s1, $s7		# len - i
		sub $s3, $s3, 1			# len - i - 1

		move $a0, $s0			# set array for recursive call
		move $a1, $s3			# set len for recursive call
		jal cutRod				# recursive call

		add $s5, $v0, $s4		# tmp = maxTmp + price[i]

		ble $s5, $s6, skipMax	# if tmp < max, continue
		move $s6, $s5			# else, set new max

		skipMax:
		add $s7, $s7, 1
		b forLoop

	forDone:
		move $v0, $s6			# return new max

#----------------------------------------#
rodDone:
	# pop
	lw $s0, 0($sp)				
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $fp, 32($sp)
	lw $ra, 36($sp)
	addu $sp, $sp, 40
	
	jr $ra

.end	cutRod
# =========================================================================
#  Function to display formatted final result.

# -----
#    Arguments:
#	$a0 - prices array, address
#	$a1 - max value

#    Returns:
#	n/a

.globl	displayResults
.ent	displayResults
displayResults:
	subu	$sp, $sp, 12			#  Save registers
	sw	$s0, 0($sp)
	sw	$s1, 4($sp)
	sw	$ra, 8($sp)

	# save arguments
	move	$s0, $a0
	move	$s1, $a1

	# display message
	la	$a0, msgMax
	li	$v0, 4
	syscall

	# display value
	move	$a0, $s1
	li	$v0, 1
	syscall

	# do new line for formatting
	jal	prtNewline

# -----
#  Restore registers and return.

	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$ra, 8($sp)
	add	$sp, $sp, 16
	jr	$ra
.end	displayResults

# =========================================================================
#  Function to display formatted price list
#  See example for formatting (must match)

# -----
#    Arguments:
#	$a0 - prices array, address
#	$a1 - length, value

#    Returns:
#	n/a

.globl	showPrices
.ent	showPrices
showPrices:
	
	move $s0, $a0		# preserve array
	move $s1, $a1		# preserve length
	
#---Print Header--------# 
	la	$a0, stars		# print line of stars
	li	$v0, 4			
	syscall

	la	$a0, pricesMsg	# print "Prices (max): "
	li	$v0, 4			
	syscall

	move $a0, $s1		# print value
	li $v0, 1
	syscall

	la	$a0, newLine	# print new line
	li	$v0, 4			
	syscall

	la	$a0, offset0	# print "   "
	li	$v0, 4			
	syscall

	#----------------------------#
	la	$a0, offset0	# print "   "
	li	$v0, 4			
	syscall

	la $a0, offset1		# print "  "
	li	$v0, 4			
	syscall

	li $s2, 0			# counter
	dashLoop1:
		
		la	$a0, dashs	# print " ----"
		li	$v0, 4			
		syscall

		addu $s2, $s2, 1	#counter++
	blt $s2, $s1, dashLoop1
	#----------------------------#

	la	$a0, newLine	# print new line
	li	$v0, 4			
	syscall

	la	$a0, lengthsStr	# print "Lengths"
	li	$v0, 4			
	syscall

	#----------------------------#
	li $s2, 1			# counter
	lengthsPrint:
		la	$a0, bar	# print " | "
		li	$v0, 4			
		syscall

		bgt $s2, 9, wideN	# if the number is above count 9, num is wider, skip format space
			
		la	$a0, spc		# print " ", for formatting
		li	$v0, 4			
		syscall

		wideN:

		move $a0, $s2		# print number
		li $v0, 1
		syscall 

		addu $s2, $s2, 1
	ble $s2, $s1, lengthsPrint
	#----------------------------#

	la	$a0, bar			# print " | "
	li	$v0, 4			
	syscall

	la	$a0, newLine		# print new line
	li	$v0, 4			
	syscall

	la	$a0, offset0		# print "   "
	li	$v0, 4			
	syscall

	#----------------------------#
	la	$a0, offset0		# print "   "
	li	$v0, 4			
	syscall

	la $a0, offset1			# print "  "
	li	$v0, 4			
	syscall

	li $s2, 0			# counter
	dashLoop2:
		
		la	$a0, dashs	# print " ----"
		li	$v0, 4			
		syscall

		addu $s2, $s2, 1	# counter++
	blt $s2, $s1, dashLoop2
	#----------------------------#
		
	la	$a0, newLine	# print new line
	li	$v0, 4			
	syscall

	la	$a0, spc		# print " "
	li	$v0, 4			
	syscall

	la	$a0, pricesStr	# print "Prices"
	li	$v0, 4			
	syscall
	#----------------------------#
	li $s2, 0			# counter
	pricesPrint:
		la	$a0, bar	# print " | "
		li	$v0, 4			
		syscall

		bgt $s2, 3, wideNums	# if the number is above count 3, num is wider, skip format space

		la	$a0, spc	# print " "
		li	$v0, 4			
		syscall

		wideNums:
		lw $s3, ($s0)	# grab value in array 

		move $a0, $s3	# print array value
		li $v0, 1
		syscall
			
		addu $s0, $s0, 4		# increment array
		addu $s2, $s2, 1		# counter++
	blt $s2, $s1, pricesPrint

	#----------------------------#

	la	$a0, bar		# print " | "
	li	$v0, 4			
	syscall

	la	$a0, newLine	# print new line
	li	$v0, 4			
	syscall

	la	$a0, offset0	# print "   "
	li	$v0, 4			
	syscall

	#----------------------------#
	la	$a0, offset0	# print "   "
	li	$v0, 4			
	syscall

	la $a0, offset1		# print "  "
	li	$v0, 4			
	syscall

	li $s2, 0			# counter
	dashLoop3:
		
		la	$a0, dashs	# print " ----"
		li	$v0, 4			
		syscall

		addu $s2, $s2, 1	# counter++
	blt $s2, $s1, dashLoop3
	#----------------------------#

	la	$a0, newLine	# print new line
	li	$v0, 4			
	syscall

	la	$a0, newLine	# print new line
	li	$v0, 4			
	syscall

	jr $ra

.end	showPrices

# =========================================================================
#  Function to prompt for, read, and check starting position.
#	must be > 0 and <= length

# -----
#    Arguments:
#	$a0 - max length, value

#    Returns:
#	$v0, length

.globl	readLength
.ent	readLength
readLength:

	move $s0, $a0
	loopPrompt:
	#---Prompt for rod length---#
		la	$a0, strtMsg1
		li	$v0, 4
		syscall

	  # between this given range
		move $a0, $s0
		li	$v0, 1
		syscall

		la $a0, strtMsg2		# display "): "
		li $v0, 4
		syscall

	#---Prompt for rod length---#
		li $v0, 5				# call code for read integer
		syscall					# system call (result in $v0)

	#---Check for good input----# (1-[length])
		move $s1, $v0
		bgt $s1, 0, checkInput	# if user input is > 0, go to checkInput

		# else, user gave bad input, try again
		la	$a0, errValue
		li	$v0, 4
		syscall

		j loopPrompt

		checkInput:
		ble $s1, $s0, endPrompt	# if user input is <= length, input is good

		# else, user gave bad input, try again
		la	$a0, errValue
		li	$v0, 4
		syscall

		j loopPrompt

	endPrompt:
	move $v0, $s1
	jr $ra

.end	readLength
# =========================================================================
#  Function to ask user if they want to do another start position.

#  Basic flow:
#	prompt user
#	read user answer (as character)
#		if y/Y -> return TRUE
#		if n/N -> return FALSE
#	otherwise, display error and re-prompt
#  Note, uses read string syscall.

# -----
#  Arguments:
#	$a0 - prompt string
#  Returns:
#	$v0 - TRUE/FALSE

.globl	askPrompt
.ent	askPrompt
askPrompt:
	subu	$sp, $sp, 4
	sw	$s0, 0($sp)

	move	$s0, $a0

	li	$v0, 4
	la	$a0, newLine
	syscall

re_pmt_ans:
	move	$a0, $s0
	li	$v0, 4
	syscall

	li	$v0, 8
	la	$a0, ans
	li	$a1, 3
	syscall

	lb	$t1, ans
	beq	$t1, 89, ans_yes
	beq	$t1, 121, ans_yes
	beq	$t1, 78, ans_no
	beq	$t1, 110, ans_no

	li	$v0, 4
	la	$a0, ansErr
	syscall

	b	re_pmt_ans

ans_no:
	li	$v0, 4
	la	$a0, newLine
	syscall

	li	$v0, FALSE
	b	continue_done

ans_yes:
	li	$v0, 4
	la	$a0, newLine
	syscall

	li	$v0, TRUE

continue_done:
	lw	$s0, 0($sp)
	add	$sp, $sp, 4
	jr	$ra
.end	askPrompt

#####################################################################

