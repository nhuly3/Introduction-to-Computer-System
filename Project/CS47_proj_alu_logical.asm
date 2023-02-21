.include "./cs47_proj_macro.asm"
.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################

au_logical:
	addi	$sp, $sp, -24
	sw	$fp, 24($sp)
	sw	$ra, 20($sp)
	sw	$a0, 16($sp)
	sw	$a1, 12($sp)
	sw	$a2, 8($sp)
	addi	$fp, $sp, 24
	
	li	$t0, '+'
	li	$t1, '-'
	li	$t2, '*'
	li	$t3, '/'
	
	beq	$a2, $t0, add_logical
	beq	$a2, $t1, sub_logical
	beq	$a2, $t2, multi_signed
	beq	$a2, $t3, divide_signed

end_au_logical:
	# restore frame
	lw	$fp, 24($sp)
	lw	$ra, 20($sp)
	lw	$a0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a2, 8($sp)
	addi	$sp, $sp, 24
	jr	$ra

add_logical:
	addi	$sp, $sp, -24
	sw	$fp, 24($sp)
	sw	$ra, 20($sp)
	sw	$a0, 16($sp)
	sw	$a1, 12($sp)
	sw	$a2, 8($sp)
	addi	$fp, $sp, 24
	
	li	$a2, 0x00000000		# a2 as 0x00000000 (add)
	jal	add_sub_logical		# jump and link to add_sub_logical
	
	lw	$fp, 24($sp)
	lw	$ra, 20($sp)
	lw	$a0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a2, 8($sp)
	addi	$sp, $sp, 24
	jr	$ra
	

sub_logical:
	addi	$sp, $sp, -24
	sw	$fp, 24($sp)
	sw	$ra, 20($sp)
	sw	$a0, 16($sp)
	sw	$a1, 12($sp)
	sw	$a2, 8($sp)
	addi	$fp, $sp, 24
	
	li	$a2, 0xFFFFFFFF		# a2 as 0xFFFFFFFF (subtract)
	jal	add_sub_logical		# jump and link to add_sub_logical
	
	lw	$fp, 24($sp)
	lw	$ra, 20($sp)
	lw	$a0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a2, 8($sp)
	addi	$sp, $sp, 24
	jr 	$ra

add_sub_logical:
	addi	$sp, $sp, -28
	sw	$fp, 28($sp)
	sw	$ra, 24($sp)
	sw	$a0, 20($sp)
	sw	$a1, 16($sp)
	sw	$a2, 12($sp)
	sw	$s0, 8($sp)
	addi	$fp, $sp, 28
	
	add	$t0, $zero, $zero			# I = index (0->31)
	extract_nth_bit($t1, $a2, $zero)		
	add	$t2, $zero, $zero			# Result(S)
	beq	$a2, 0xFFFFFFFF, subtract_mode	        # check if a2 is add or subtract mode
	j	loop
	
subtract_mode:
	not	$a1, $a1				# invert second number if subtract mode
	j	loop				
loop:
	beq	$t0, 0x20, end_add_sub_logical		
	extract_nth_bit($t3, $a0, $t0)			# A = a0 
	extract_nth_bit($t4, $a1, $t0)			# B = a1

	xor	$t5, $t3, $t4				# XOR A, B
	xor	$t6, $t5, $t1				# XOR t5, C
	and	$t7, $t3, $t4				# AND A, B
	and	$t1, $t1, $t5				# AND C,t5
	or	$t1, $t1, $t7				# OR C,t7
	insert_to_nth_bit($t2, $t0, $t6, $t8)	
	addi	$t0, $t0, 0x1				# I = I + 1
	j	loop
	
end_add_sub_logical:
	move	$v0, $t2				#S
	move	$v1, $t1				
	lw	$fp, 28($sp)
	lw	$ra, 24($sp)
	lw	$a0, 20($sp)
	lw	$a1, 16($sp)
	lw	$a2, 12($sp)
	lw	$s0, 8($sp)
	addi	$sp, $sp, 28
	jr	$ra


twos_complement:
	addi	$sp, $sp, -28
	sw	$fp, 28($sp)
	sw	$ra, 24($sp)
	sw	$a0, 20($sp)
	sw	$a1, 16($sp)
	sw	$a2, 12($sp)
	sw	$s0, 8($sp)
	addi	$fp, $sp, 28
	
	not	$a0, $a0		# invert a0 to~a0
	li	$a1, 0x1		# a1 = 1
	jal	add_logical		# ~a0 + 1 

	lw	$fp, 28($sp)
	lw	$ra, 24($sp)
	lw	$a0, 20($sp)
	lw	$a1, 16($sp)
	lw	$a2, 12($sp)
	lw	$s0, 8($sp)
	addi	$sp, $sp, 28
	jr	$ra

twos_complement_neg:
	addi	$sp, $sp, -28
	sw	$fp, 28($sp)
	sw	$ra, 24($sp)
	sw	$a0, 20($sp)
	sw	$a1, 16($sp)
	sw	$a2, 12($sp)
	sw	$s0, 8($sp)
	addi	$fp, $sp, 28
	
	move	$v0, $a0				# v0 = a0
	bgt	$a0, $zero, end_twos_complement_neg	# a0 > 0,no 2's complement
	jal	twos_complement				# 2's complement of a0

end_twos_complement_neg:
	lw	$fp, 28($sp)
	lw	$ra, 24($sp)
	lw	$a0, 20($sp)
	lw	$a1, 16($sp)
	lw	$a2, 12($sp)
	lw	$s0, 8($sp)
	addi	$sp, $sp, 28
	jr	$ra

twos_complement_64bit:
	addi	$sp, $sp, -36
	sw	$fp, 36($sp)
	sw	$ra, 32($sp)
	sw	$a0, 28($sp)
	sw	$a1, 24($sp)
	sw	$a2, 20($sp)
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	addi	$fp, $sp, 36
	
	not	$a0, $a0		# invert a0 
	not	$a1, $a1		# invert a1 
	move	$s0, $a1		# s0 = a1
	add	$a1, $zero, 0x1		
	jal	add_logical		# 2's compliment of lo
	move	$s1, $v0		# 2's compliment of lo
	move	$s2, $v1		# s2 = carry out
	move	$a0, $s0		
	move	$a1, $s2	
	jal	add_logical		
	move	$v1, $v0		# 2's complement of hi
	move	$v0, $s1		# 2's complement of lo

	lw	$fp, 36($sp)
	lw	$ra, 32($sp)
	lw	$a0, 28($sp)
	lw	$a1, 24($sp)
	lw	$a2, 20($sp)
	lw	$s0, 16($sp)
	lw	$s1, 12($sp)
	lw	$s2, 8($sp)
	addi	$sp, $sp, 36
	jr	$ra

	
bit_replicator:
	addi	$sp, $sp, -28
	sw	$fp, 28($sp)
	sw	$ra, 24($sp)
	sw	$a0, 20($sp)
	sw	$a1, 16($sp)
	sw	$a2, 12($sp)
	sw	$s0, 8($sp)
	addi	$fp, $sp, 28
	
	beq	$a0, $zero, zero_replicate	# a0 = 0, 0x00000000
	beq	$a0, 0x1, one_replicate		# a0 = 1, 0xFFFFFFFF
	
zero_replicate:
	li	$v0, 0x00000000			#0x00000000
	j	end_bit_replicator
	
one_replicate:
	li	$v0, 0xFFFFFFFF			#0xFFFFFFFF
	j	end_bit_replicator
	
end_bit_replicator:
	lw	$fp, 28($sp)
	lw	$ra, 24($sp)
	lw	$a0, 20($sp)
	lw	$a1, 16($sp)
	lw	$a2, 12($sp)
	lw	$s0, 8($sp)
	addi	$sp, $sp, 28
	jr	$ra
	
multi_unsigned:
	addi	$sp, $sp, -60
	sw	$fp, 60($sp)
	sw	$ra, 56($sp)
	sw	$a0, 52($sp)
	sw	$a1, 48($sp)
	sw	$a2, 44($sp)
	sw	$a3, 40($sp)
	sw	$s0, 36($sp)
	sw	$s1, 32($sp)
	sw	$s2, 28($sp)
	sw	$s3, 24($sp)
	sw	$s4, 20($sp)
	sw	$s5, 16($sp)
	sw	$s6, 12($sp)
	sw	$s7, 8($sp)
	addi	$fp, $sp, 60
	
	add	$s1, $zero, $zero		# I = 0
	add	$s2, $zero, $zero		# H = 0
	move	$s3, $a1			# MLPR(L)
	move	$s4, $a0			# MCND(M)
	
multi_unsigned_loop:
	beq	$s1, 0x20, end_multi_unsigned
	extract_nth_bit($a0, $s3, $zero)	
	jal	bit_replicator			
	move	$s5, $v0			
	and	$s6, $s4, $s5			# X = M & R
	move	$a0, $s2			# a0 = H 
	move	$a1, $s6			# a1 = X 
	jal	add_logical			# v0 = H + X
	move	$s2, $v0			# H = H + X
	srl	$s3, $s3, 0x1			# L >> 1
	extract_nth_bit($s7, $s2, $zero)	# H[0]
	add	$t0, $zero, 31			# t0 = 31
	insert_to_nth_bit($s3, $t0, $s7, $t1)	# L[31] = H[0]
	srl	$s2, $s2, 0x1			# H >> 1
	addi	$s1, $s1, 0x1			# I = I + 1
	j	multi_unsigned_loop
	
end_multi_unsigned:
	move	$v0, $s3			# lo
	move	$v1, $s2			# hi

	lw	$fp, 60($sp)
	lw	$ra, 56($sp)
	lw	$a0, 52($sp)
	lw	$a1, 48($sp)
	lw	$a2, 44($sp)
	lw	$a3, 40($sp)
	lw	$s0, 36($sp)
	lw	$s1, 32($sp)
	lw	$s2, 28($sp)
	lw	$s3, 24($sp)
	lw	$s4, 20($sp)
	lw	$s5, 16($sp)
	lw	$s6, 12($sp)
	lw	$s7, 8($sp)
	addi	$sp, $sp, 60
	jr	$ra

multi_signed: 
	addi	$sp, $sp, -60
	sw	$fp, 60($sp)
	sw	$ra, 56($sp)
	sw	$a0, 52($sp)
	sw	$a1, 48($sp)
	sw	$a2, 44($sp)
	sw	$a3, 40($sp)
	sw	$s0, 36($sp)
	sw	$s1, 32($sp)
	sw	$s2, 28($sp)
	sw	$s3, 24($sp)
	sw	$s4, 20($sp)
	sw	$s5, 16($sp)
	sw	$s6, 12($sp)
	sw	$s7, 8($sp)
	addi	$fp, $sp, 60
	
	move	$s3, $a0			# s3 = n1
	move	$a2, $a0		
	move	$s4, $a1			# s4 = n2
	move	$a3, $a1			
	jal	twos_complement_neg		
	move	$s3, $v0			# n1 = v0
	move	$a0, $s4			# a0 = s4
	jal	twos_complement_neg	
	move	$s4, $v0			# n2 = v0
	move	$a0, $s3			# a0 = n1
	move	$a1, $s4			# a1 = n2
	jal	multi_unsigned			# n1 * n2
	move	$s3, $v0			# Rlo
	move	$s4, $v1			# Rhi
	add	$t0, $zero, 0x1F		# t0 = 31
	extract_nth_bit($t1, $a2, $t0)		# a0[31]
	extract_nth_bit($t2, $a3, $t0)		# a1[31]
	xor	$t3, $t1, $t2			# XOR a0,a1
	beq	$t3, 0x1, twos_complement_64
	j	end_multi_unsigned

twos_complement_64:
	move	$a0, $s3			# Rlo
	move	$a1, $s4			# Rhi
	jal	twos_complement_64bit
	move	$s3, $v0			# 2's complement of lo
	move	$s4, $v1			# 2's complement of hi
	
end_multi_signed:
	move	$v0, $s3			# lo
	move	$v1, $s4			#hi

	lw	$fp, 60($sp)
	lw	$ra, 56($sp)
	lw	$a0, 52($sp)
	lw	$a1, 48($sp)
	lw	$a2, 44($sp)
	lw	$a3, 40($sp)
	lw	$s0, 36($sp)
	lw	$s1, 32($sp)
	lw	$s2, 28($sp)
	lw	$s3, 24($sp)
	lw	$s4, 20($sp)
	lw	$s5, 16($sp)
	lw	$s6, 12($sp)
	lw	$s7, 8($sp)
	addi	$sp, $sp, 60
	jr	$ra


divide_unsigned:
	addi	$sp, $sp, -60
	sw	$fp, 60($sp)
	sw	$ra, 56($sp)
	sw	$a0, 52($sp)
	sw	$a1, 48($sp)
	sw	$a2, 44($sp)
	sw	$a3, 40($sp)
	sw	$s0, 36($sp)
	sw	$s1, 32($sp)
	sw	$s2, 28($sp)
	sw	$s3, 24($sp)
	sw	$s4, 20($sp)
	sw	$s5, 16($sp)
	sw	$s6, 12($sp)
	sw	$s7, 8($sp)
	addi	$fp, $sp, 60

	add	$s1, $zero, $zero		# I = 0
	move	$s2, $a0			# DVND(Q)
	move	$s3, $a1			# DVSR(D)
	add	$s4, $zero, $zero		# R = 0
	
divide_unsigned_loop:
	beq	$s1, 0x20, end_divide_unsigned
	sll	$s4, $s4, 0x1			# R = R << 1
	addi	$s5, $zero, 0x1F		# s5 = 31
	extract_nth_bit($s6, $s2, $s5)		# Q[31]
	add	$t9, $zero, $zero		# t1 = 0
	insert_to_nth_bit($s4, $zero, $s6, $t9) # R[0] = Q[31]
	sll	$s2, $s2, 0x1			# Q = Q << 1
	move	$a0, $s4			# R
	move	$a1, $s3			# D
	jal	sub_logical			# S = R - D
	move	$s7, $v0			# S
	bltz	$s7, end_divide_unsigned_loop	
	move	$s4, $s7			# R = S
	add	$t4, $zero, $zero		
	addi	$t3, $zero, 0x1			
	insert_to_nth_bit($s2, $zero, $t3, $t4)	# Q[0] = 1
	
end_divide_unsigned_loop:
	addi	$s1, $s1, 0x1			# I = I + 1
	jal	divide_unsigned_loop
	
end_divide_unsigned:
	move	$v0, $s2			# Q
	move	$v1, $s4			# R
	# restore frame
	lw	$fp, 60($sp)
	lw	$ra, 56($sp)
	lw	$a0, 52($sp)
	lw	$a1, 48($sp)
	lw	$a2, 44($sp)
	lw	$a3, 40($sp)
	lw	$s0, 36($sp)
	lw	$s1, 32($sp)
	lw	$s2, 28($sp)
	lw	$s3, 24($sp)
	lw	$s4, 20($sp)
	lw	$s5, 16($sp)
	lw	$s6, 12($sp)
	lw	$s7, 8($sp)
	addi	$sp, $sp, 60
	jr	$ra


divide_signed:
	addi	$sp, $sp, -36
	sw	$s0, 36($sp)
	sw	$s1, 32($sp)
	sw	$s2, 28($sp)
	sw	$s3, 24($sp)
	sw	$s4, 20($sp)
	sw	$s5, 16($sp)
	sw	$s6, 12($sp)
	sw	$s7, 8($sp)
	addi	$fp, $sp, 36
	
	move	$s3, $a0			# n1
	move	$s4, $a1			# n2
	jal	twos_complement_neg
	move	$s1, $v0			# 2's complement of n1
	move	$a0, $a1			# a0 = n2 
	jal	twos_complement_neg		
	move	$s2, $v0			# 2's complement of n2
	move	$a0, $s1			# n1
	move	$a1, $s2			# n2
	jal	divide_unsigned			# unsigned divde of n1,n2
	move	$s1, $v0			# Q
	move	$s2, $v1			# R
	addi	$t0, $zero, 0x1F		
	extract_nth_bit($s5, $s3, $t0)		# a0[31]
	extract_nth_bit($s6, $s4, $t0)		# a1[31]
	xor	$s7, $s5, $s6			# XOR s5,s6
	beq	$s7, 0x1, twos_complement_q		# S = 1, 2's complement of Q
	bne	$s7, 0x1, twos_complement_r		# S =/= 1, 2's complement of R
	
twos_complement_q:
	move	$a0, $s1			# a0 = Q
	jal	twos_complement
	move	$s1, $v0			# s1 = 2's complement of Q
	j	twos_complement_r

twos_complement_r:
	move	$s7, $s5			#a0[31]
	bne	$s7, 0x1, end_divide_signed	
	move	$a0, $s2			# R
	jal	twos_complement
	move	$s2, $v0			# 2's complement of R
	j	end_divide_signed
	
end_divide_signed:
	move	$v0, $s1			# Q
	move	$v1, $s2			#R
	lw	$fp, 60($sp)
	lw	$ra, 56($sp)
	lw	$a0, 52($sp)
	lw	$a1, 48($sp)
	lw	$a2, 44($sp)
	lw	$a3, 40($sp)		
	lw	$s0, 36($sp)
	lw	$s1, 32($sp)
	lw	$s2, 28($sp)
	lw	$s3, 24($sp)
	lw	$s4, 20($sp)
	lw	$s5, 16($sp)
	lw	$s6, 12($sp)
	lw	$s7, 8($sp)
	addi	$sp, $sp, 60
	jr	$ra