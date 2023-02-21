.include "./cs47_proj_macro.asm"
.text
.globl au_normal
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_normal
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################

au_normal:
	addi	$sp, $sp, -24
	sw	$fp, 24($sp)
	sw	$ra, 20($sp)
	sw	$a0, 16($sp)
	sw	$a1, 12($sp)
	sw	$a2, 8($sp)
	addi	$fp, $sp, 24
	
	# Operations
	li	$t0, '+'
	li	$t1, '-'
	li	$t2, '*'
	li	$t3, '/'
	
	# check the code of operations
	beq	$a2, $t0, add
	beq	$a2, $t1, subtract
	beq	$a2, $t2, multiple
	beq	$a2, $t3, divide
	
	j	end_au_normal
	
add:
	add	$v0, $a0, $a1	#a0 + a1
	j	end_au_normal
	
subtract:
	sub	$v0, $a0, $a1	#a0 - a1
	j	end_au_normal
	
multiple:
	mult	$a0, $a1	# a0 * a1
	mflo	$v0		# lo
	mfhi	$v1		# hi
	j	end_au_normal
	
divide:
	div	$a0, $a1	# a0/a1
	mflo	$v0		# lo
	mfhi	$v1		# hi
	j	end_au_normal
	
end_au_normal:
	lw	$fp, 24($sp)
	lw	$ra, 20($sp)
	lw	$a0, 16($sp)
	lw	$a1, 12($sp)
	lw	$a2, 8($sp)
	addi	$sp, $sp, 24
	jr	$ra