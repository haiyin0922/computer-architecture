.data
str1:		.asciiz "input a: "
str2:		.asciiz "input b: "
str3:		.asciiz "input c: "
str4:		.asciiz "result = "
.text

##### main #####
add $s0, $zero, $zero	#Setup variables
add $s1, $zero, $zero
add $s2, $zero, $zero
add $s3, $zero, $zero

la $a0, str1	# load address of string to print
li $v0, 4	# ready to print string
syscall		# print
li $v0, 5	# readt to scan int
syscall		# scan
add $s0, $zero, $v0	# A = v0

la $a0, str2	# load address of string to print
li $v0, 4	# ready to print string
syscall		# print
li $v0, 5	# readt to scan int
syscall		# scan
add $s1, $zero, $v0	# B = v0

la $a0, str3	# load address of string to print
li $v0, 4	# ready to print string
syscall		# print
li $v0, 5	# readt to scan int
syscall		# scan
add $s2, $zero, $v0	# C = v0

add $a0, $zero, $s0	# a0 = s0
add $a1, $zero, $s1	# a1 = s1
jal _add		# jump to _add
add $t0, $zero, $v0	# move result in v0 to t0

add $a0, $zero, $t0	# a0 = t0
add $a1, $zero, $s2	# a1 = s2	
jal _msub		# jump to msub
add $s3, $zero, $v0	# move result in v0 to s3

la $a0, str4	# load address of string to print
li $v0, 4	# ready to print string
syscall		# print
li $v0, 1       # ready to print int
move $a0, $s3   # load int value to $a0
syscall	        # print
j _exit		# jump to exit

##### add #####
_add:
	add $v0, $a0, $a1	# v0 = a0 + a1
	jr $ra			# return address

##### musb #####  	 	 	 	
_msub:
	addi $sp, $sp, -8	# adjust stack for 2 items
	sw $s0, 0($sp)		# save s0 on stack
	sw $s1, 4($sp)		# save s1 on stack
	slt $t0, $a0, $a1	# test for x < y
	beq $t0, $zero, _large	# x >= y, jump to _large
	add $s0, $zero, $a1	# x < y, s0 = a1
	j _line2		# jump to _line2
_large:
	add $s0, $zero, $a0	# s0 = a0
_line2:
	slt $t0, $a1, $a0	# test for y < x
	beq $t0, $zero, _small	# x <= y, jump to _small
	add $s1, $zero, $a1	# x > y, s1 = a1
	j _while		# jump to _while
_small:
	add $s1, $zero, $a0	# s1 = a0
_while:
	sub $s0, $s0, $s1	# s0 = s0 - s1
	slt $t0, $s0, $s1	# test for s0 < s1
	beq $t0, $zero, _while	# s0 >= s1, jump to _while
	add $v0, $zero, $s0	# v0 = s0
	lw $s0, 0($sp)		# restore s0
	lw $s1, 4($sp)		# restore s1
	addi $sp, $sp, 8	# pop 2 items form stack
	jr $ra			# return address

#terminated	
_exit:
	li   $v0, 10
  	syscall
