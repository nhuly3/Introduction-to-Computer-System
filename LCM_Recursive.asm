.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter a +ve number : "
msg2: .asciiz "Enter another +ve number : "
msg3: .asciiz "LCM of "
s_is: .asciiz "is"
s_and: .asciiz "and"
s_space: .asciiz " "
s_cr: .asciiz "\n"

.text
.globl main
main:
	print_str(msg1)
	read_int($s0)
	print_str(msg2)
	read_int($s1)
	
	move $v0, $zero
	move $a0, $s0
	move $a1, $s1
	move $a2, $s0
	move $a3, $s1
	jal  lcm_recursive
	move $s3, $v0
	
	print_str(msg3)
	print_reg_int($s0)
	print_str(s_space)
	print_str(s_and)
	print_str(s_space)
	print_reg_int($s1)
	print_str(s_space)
	print_str(s_is)
	print_str(s_space)
	print_reg_int($s3)
	print_str(s_cr)
	exit

#------------------------------------------------------------------------------
# Function: lcm_recursive 
# Argument:
#	$a0 : +ve integer number m
#       $a1 : +ve integer number n
#       $a2 : temporary LCM by increamenting m, initial is m
#       $a3 : temporary LCM by increamenting n, initial is n
# Returns
#	$v0 : lcm of m,n 
#
# Purpose: Implementing LCM function using recursive call.
# 
#------------------------------------------------------------------------------
lcm_recursive:
	# Store frame
	addi $sp, $sp, -20
	sw $fp, 20($sp)
	sw $ra, 16($sp)
	sw $a2, 12($sp)
	sw $a3, 8($sp)
	addi $fp, $sp, 20
	
	# Body
	beq $a2, $a3, lcm_recursive_end
	slt $t0, $a3, $a2
	beq $t0, 0, L1
	add $a3, $a3, $a1
	b L2
L1:     add $a2, $a2, $a0
L2:     jal lcm_recursive

	# Restore frame
	lcm_recursive_ret:
	lw $fp, 20($sp)
	lw $ra, 16($sp)
	lw $a2, 12($sp)
	lw $a3, 8($sp)
	addi $sp, $sp, 20

	jr $ra
	lcm_recursive_end:
	move $v0, $a2
	b lcm_recursive_ret
	
