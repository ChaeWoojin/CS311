# PROGRAM: Hello, World!

	.data		# Data declaration section

	out_string: .asciiz "\nHello, World!\n"
	list: 
		.word 1

	.text

main:	# Start of code section
	
	li $v0, 4
	la $a0, out_string
	syscall		

	li $a0, 3
	li $a1, 4		
	move $s0, $ra	
	jal functions


	move $ra, $s0
	jr $ra


functions: 
	li $t5, 2
	li $t2, 0
	
	la $t3, list

	sw $t5, 8($t3)




loop:	add $t1, $t2, $t3
	add $t2, $t2, 4
	lw $t4, 0($t1)
	sub $t5, $t2, 40
	beqz $t5, finish		
	b loop
finish:
	jr $ra


# BLANK LINE AT THE END TO KEEP SPIM HAPPY!
