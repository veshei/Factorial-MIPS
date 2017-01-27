
.globl main
.data
prompt: 	.word	prompt_data
response1: 	.word	response1_data
response2:	.word	response2_data

prompt_data:	.asciiz	"Positive integer: "
response1_data:	.asciiz "The value of factorial("
response2_data:	.asciiz ") is "
.text

main: 
					# print the prompt, "Positive integer: "
	la 	$t0, prompt		# load address of the prompt into $t0
	lw	$a0, 0($t0)		# load the data from $t0 into $a0
	li	$v0, 4			# the syscall for print_string
	syscall				# run the call for print_string
	
					# scan the input: scanf("%d", &number);
	li	$v0, 5			# the syscall for read_int
	syscall				# run the call for read_int
	move	$t0, $v0		# store input in $t0
	
	move 	$a0, $t0		# move input from temporary register to argument register
	addi	$sp, $sp, -12		# a word is 4 bytes, moves the stack pointer up 3 words
	sw	$t0, 0($sp)		# stores the value in $t0 at the top of the stack
	sw	$ra, 8($sp)		# stores the counter in the return address at the bottom of the stack
	jal	factorial		# call factorial
	
					# store the value from the first factorial computation in 4($sp)
	lw	$s0, 4($sp)		# load the final value into $s0 or the saved values
	
					# print the next part: printf("The value of 'factorial(%d)' is:  %d\n", number, factorial(number))
	la	$t1, response1		# set the contents of response1 into $t1
	lw	$a0, 0($t1)		# set the contents of $t1 into $a0
	li	$v0, 4			# the syscall for print_string
	syscall				# print the value of response1 onto the console
	
	lw	$a0, 0($sp)		# load original value into $a0
	li	$v0, 1			# syscall for print_int
	syscall				# print the input onto the screen
	
	la	$t2, response2		# set the contents of response2 into $t2
	lw	$a0, 0($t2)		# set the contents of $t2 into $a0
	li	$v0, 4			# syscall for print_string
	syscall				# print the value of response2 onto the console
	
	move	$a0, $s0		# move final return value into $s0
	li	$v0, 1			# the syscall for print_int
	syscall				# print the final computed factorial value to the screen
	
	addi	$sp, $sp, 12 		# move the stackpointer back up to the original location
	
					# return 0, meaning sucess
	li	$v0, 10			# syscall for exit
	syscall				# exit	
	

.text
factorial: 
					# base case
					# if (x == 0), return 1
	lw 	$t0, 0($sp)		# load the input from the top of the stack into $t0, i.e load the x
					# if (x == 0)
	beq 	$t0, 0, returnOne	# if x equals 0, go to the branch returnOne which returns the value 1
					# else case
	addi 	$t0, $t0, -1		# subtract one from the input if x does not equal 0
	
					# recursive call for the factorial, goes through the stack
	addi 	$sp, $sp, -12		# a word is 4 bytes, moves the stack pointer up 3 words
	sw	$t0, 0($sp)		# stores the current input into the top of the stack
	sw	$ra, 8($sp)		# stores the counter in the return address at the bottom of the stack
	jal	factorial		#recursive call to the factorial function
	
					# load the return values for the intermediate computations
	lw 	$ra, 8($sp)		# load the return address stored at the bottom of the stack
	lw 	$t1, 4($sp)		# load the intermediate value into $t1
	lw	$t2, 12($sp)		# loads the start value into $t2
	
					# x * factorial(x - 1)
	mul	$t3, $t2, $t1		# multiply the input and the factorial of the input and store it in $t3
	sw	$t3, 16($sp)		# store the value of $t3 at the bottom of the stack	
	addi	$sp, $sp, 12		# move stack pointer back down for the parent call
	jr	$ra			# jump to parent call
	
.text

returnOne:
	li	$t0, 1			# load the value of 1 into the register #t0
	sw	$t0, 4($sp)		# store 1 into the stack
	jr	$ra			# jump to parent call
	
	
	
	
	
	
