.globl main
.data
prompt: .word prompt_data
answer1: .word answer1_data
answer2: .word answer2_data

prompt_data: .asciiz "Positive integer: "
answer1_data: .asciiz "The value of factorial("
answer2_data: .asciiz ") is "
.text 

main:
	# printing the prompt, printf("Positive integer: ");
	la 	$t0, prompt	# load address of prompt into $t0
	lw 	$a0, 0($t0)	# load the data from the address in $t0 into $a0
	li	$v0, 4		# call code for print_string
	syscall			# run the print_string syscall
	
	# reading the input integer x
	# scanf("%d, &number);
	li	$v0, 5		# call code for read_int
	syscall			# run the read_int syscall
	move	$t0, $v0	# store input in $t0
	
	move 	$a0, $t0	# move input to argument register $a0
	addi 	$sp, $sp, -12	# move stackpointer up 3 words
	sw 	$t0, 0($sp)	# store input in top of stack
	sw	$ra, 8($sp)	# store counter at bottom of stack
	jal	factorial	# call factorial
	
	# the final return value is stored in 4($sp)
	
	lw	$s0, 4($sp)	# load final return value into $s0
	
	# printf("The value of 'factorial(%d)' is: %d\n",
	la	$t1, answer1	# load answer1 address into $t1
	lw	$a0, 0($t1)	# load answer1_data value into $a0
	li	$v0, 4		# system call for print_string
	syscall			# print value of answer1_data to screen
	
	lw 	$a0, 0($sp)	# load original value into $a0
	li	$v0, 1		# system call for print_int
	syscall			# print original value to screen
	
	la	$t2, answer2	# load answer2 address into $t1
	lw	$a0, 0($t2)	# load answer2_data value into $a0
	li	$v0, 4		# system call for print_string
	syscall			# print value of answer2_data to screen
	
	move 	$a0, $s0	# move final return value from $s0 to $a0 for return
	li	$v0, 1		# system call for print_int
	syscall			# print final return value to screen
	
	addi	$sp, $sp, 12	# move stack pointer back down where we started
	
	# return 0;
	li	$v0, 10		# system call for exit
	syscall			# exit!
	
	

	
	
.text
factorial:
	# base case
	lw	$t0, 0($sp)	# load input from top of stack into register $t0
	#if (x == 0)
	beq	$t0, 0, returnOne # if $t0 is equal to 0, branch to returnOne
	addi $t0, $t0, -1	# subtract 1 from $t0 if not equal to 0
	
	# recursive case - move to this call's stack segment
	addi $sp, $sp, -12	# move stack pointer up 3 words
	sw	$t0, 0($sp)	# store current working number into the top of the stack
	sw	$ra, 8($sp) 	# store counter at bottom of stack segment
	
	jal	factorial	# recursive call
	
	# the return value for the child branch in 4($sp)
	lw	$ra, 8($sp)	# load this call's $ra again
	lw	$t1, 4($sp)	# load child's return value into $t1
	
	lw	$t2, 12($sp)	# load parent's start value into $t2
	# return x * factorial(x-1)
	mul	$t3, $t1, $t2	# multiply child's return value by parent's working value, store in $t3
	
	sw	$t3, 16($sp)	# take result(in $t3), store in parent's return value 
	
	addi $sp, $sp, 12	# move stackpointer back down for parent call
	
	jr	$ra		# jump to parent call
.text
#return 1;
returnOne:
	li	$t0, 1		# load 1 into register $t0
	sw	$t0, 4($sp)	# store 1 into the parent's return value register
	jr	$ra		# jump to parent call
	
	

