# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#

# extract_nth_bit
# regD: contains 0x0 or 0x1 
# regS: source bit pattern
# regT: index/bit position n

.macro extract_nth_bit($regD, $regS, $regT)
	move	$s0, $regS		# s0 = regS
	srlv	$s0, $s0, $regT		# shift right regS in regT
	andi	$regD, $s0, 0x1	
.end_macro

# insert_to_nth_bit
# regD: bit pattern where 1 or 0 to be inserted at position n
# regS: value n
# regT: contains 0x1 or 0x0 
# maskedReg: rhold temporary mask

.macro insert_to_nth_bit($regD, $regS, $regT, $maskedReg)
	addi	$maskedReg, $maskedReg, 0x1	
	sllv	$maskedReg, $maskedReg, $regS	# shifts 1 by value in regS
	not	$maskedReg, $maskedReg		# invert maskReg
	and	$regD, $regD, $maskedReg
	sllv	$regT, $regT, $regS	
	or	$regD, $regD, $regT		
.end_macro

