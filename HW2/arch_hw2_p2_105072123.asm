.data
str1:		.asciiz "The Bomb has been activated!!!"
str2:		.asciiz "Please enter your lucky number[0-9]: "
str3:		.asciiz "You have only "
str4:		.asciiz " times to inactivate it!!!"
str5:		.asciiz "HA!HA!HA! Wrong Guess!"
str6:		.asciiz "You should choose a bigger number!"
str7:		.asciiz "You should choose a smaller number!"
str8:		.asciiz "Bye Bye!!!Boom!!!"
str9:		.asciiz "Wow! You are very lucky! The boom has been inactive!"
newline: 	.asciiz "\n"
.text


#########DONOT MODIFY HERE###########
#Setup random
addi $a1, $zero, 10
addi $v0, $zero, 42  
syscall
#li   $v0, 1           	
#syscall
move $t0, $a0 #Hint: Donot overwrite $t0, it stores the random number
##########################################   


#Setup counter
addi $t1, $zero, 3

la $a0, str1	# load address of string to print
li $v0, 4	# ready to print string
syscall		# print
jal PrintNewline 
   	
#Game loop start!      	
_Start:
	#printf something	
	la $a0, str3	 # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	li $v0, 1        # ready to print int
	move $a0, $t1    # load int value to $a0
	syscall	         # print	
	la $a0, str4	# load address of string to print
	li $v0, 4	# ready to print string
	syscall		# print
	jal PrintNewline	
	la $a0, str2	# load address of string to print
	li $v0, 4	# ready to print string
	syscall		# print
	jal PrintNewline
		
	#scanf
	li $v0, 5	# readt to scan int
	syscall		# scan
	add $t2, $zero, $v0	
	
  	#compare lucky number with random number
  	#if equal, go _Win
  	beq $t0, $t2, _Win  
  		
  	#if not, continute from here
	#check the counter, if counter is 1 go _Lose
	addi $t3, $zero, 1
	beq $t1, $t3, _Lose
  	
  	#if counter is not equal to 1, check who is bigger(jump to _Bigger)
  	slt $t3, $t0, $t2
  	beq $t3, $zero, _Bigger
  	
  	#otherwise (jump to _Smaller)
  	j _Smaller  	 	
  	 	 	 	
#win event 	
_Win:
	la $a0, str9	# load address of string to print
	li $v0, 4	# ready to print string
	syscall		# print
	jal PrintNewline
	j _Exit
		
#lose event	
_Lose:
	la $a0, str5	# load address of string to print
	li $v0, 4	# ready to print string
	syscall		# print
	jal PrintNewline
	la $a0, str8	# load address of string to print
	li $v0, 4	# ready to print string
	syscall		# print
	jal PrintNewline
	j _Exit

#compare case
_Bigger:
	#printf something
	la $a0, str6	# load address of string to print
	li $v0, 4	# ready to print string
	syscall		# print
	jal PrintNewline	
	#counter
	addi $t1, $t1, -1	
	#return game loop
	j _Start	

#compare case 	
_Smaller:
	#printf something
	la $a0, str7	# load address of string to print
	li $v0, 4	# ready to print string
	syscall		# print
	jal PrintNewline	
	#counter
	addi $t1, $t1, -1	
	#return game loop
	j _Start	

#terminated	
_Exit:
	li   $v0, 10
  	syscall
	
PrintNewline:
	la $a0, newline # load address of string to print
	li $v0, 4	 # ready to print string
	syscall	         # print
	jr $ra           # return