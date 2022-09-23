.data
str1:		.asciiz "input a: "
str2:		.asciiz "input b: "
str3:		.asciiz "ans: "
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

add $a0, $zero, $s0	# a0 = s0
jal _recursive		# jump to _recursive
add $s2, $zero, $v0	# move result in v0 to s2

la $a0, str3	# load address of string to print
li $v0, 4	# ready to print string
syscall		# print
li $v0, 1        # ready to print int
move $a0, $s2    # load int value to $a0
syscall	         # print

add $a0, $zero, $s1	# a0 = s1
add $a1, $zero, $s2	# a1 = s2
jal _function		# jump to _function
add $s3, $zero, $v0	# move result in v0 to s3

la $a0, str3	# load address of string to print
li $v0, 4	# ready to print string
syscall		# print
li $v0, 1        # ready to print int
move $a0, $s3    # load int value to $a0
syscall	         # print

j _exit		# jump to _exit

##### recursive #####
_recursive:
	addi $sp, $sp, -12	# adjust stack for 3 items
	sw $ra, 8($sp)		# save return adddress
	sw $s0, 4($sp)		# save s0
	sw $s1, 0($sp)		# save s1
	add $s0, $zero, $a0	# s0 = a0
	addi $v0, $zero, 1	# v0 = 1
	slti $t0, $a0, 0xF	# test for a0 < 0xF
	bne $t0, $zero, r_exit	# if a0 < 0xF, jump to r_exit
	slti $t0, $a0, 0xFF	# test for a0 < 0xFF
	beq $t0, $zero, R1	# if a0 >= 0xFF, jump to R1
	addi $a0, $s0, -1	# a0 = s0 - 1
	jal _recursive		# recursive call
	addi $v0, $v0, 1	# v0 = v0 + 1
	j r_exit		# jump to r_exit		
R1:
	addi $a0, $s0, -3	# a0 = s0 - 3
	jal _recursive		# recursive call
	add $s1, $zero, $v0	# s1 = recursive(x-3)
	addi $a0, $s0, -2	# a0 = s0 - 2
	jal _recursive		# recursive call
	add $v0, $s1, $v0	# v0 = recursive(x-3) + recursive(x-2)		
r_exit:		
       	lw      $ra, 8($sp)	# restore original return address
       	lw      $s0, 4($sp)	# restore original s0
       	lw      $s1, 0($sp)	# restore original s1
       	addi    $sp, $sp, 12	# pop 3 items from stack
       	jr      $ra		# return address

##### fucntion ##### 	 	 	 	
_function:
	addi $sp, $sp, -16	# adjust stack for 4 items
	sw $ra, 12($sp)		# save return adddress
	sw $s0, 8($sp)		# save s0
	sw $s1, 4($sp)		# save s1
	sw $s2, 0($sp)		# save s2
	add $s0, $zero, $a0	# s0 = a0
	add $s1, $zero, $a1	# s1 = a1
	addi $v0, $zero, 1	# v0 = 1
	slt $t0, $zero, $a0	# test for 0 < a0
	beq $t0, $zero, f_exit	# if  a0 <= 0, jump to r_exit
	slt $t0, $zero, $a1	# test for 0 < a1
	beq $t0, $zero, f_exit	# if  a1 <= 0, jump to r_exit
	addi $a0, $s0, -1	# a0 = s0 - 1
	add $a1, $zero, $s1	# a1 = s1
	jal _function		# recursive call
	add $s2, $zero, $v0	# s2 = function(x-1, y)
	add $a0, $zero, $s0	# a0 = s0
	addi $a1, $s1, -1	# a1 = s1 - 1
	jal _function		# recursive call
	add $v0, $s2, $v0	# v0 = function(x-1, y) + function(x, y-1)		
f_exit:		
       	lw      $ra, 12($sp)	# restore original return address
       	lw      $s0, 8($sp)	# restore original s0
       	lw      $s1, 4($sp)	# restore original s1
       	lw      $s2, 0($sp)	# restore original s2
       	addi    $sp, $sp, 16	# pop 4 items from stack
       	jr      $ra		# return address

#terminated	
_exit:
	li   $v0, 10
  	syscall