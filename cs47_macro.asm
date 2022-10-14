#<------------------ MACRO DEFINITIONS ---------------------->#
        # Macro : print_str
        # Usage: print_str(<address of the string>)
        .macro print_str($arg)
	li	$v0, 4     # System call code for print_str  
	la	$a0, $arg  # Address of the string to print
	syscall            # Print the string        
	.end_macro
	
	#Macro: print_reg_int
	#Usage: print_reg_int(<reg>)
	.macro print_reg_int($arg)
	li $v0,1
	move $a0,$arg
	syscall
	.end_macro
	
	#Macro: read_int
	#Usage: read_int(<reg>)
	.macro read_int($arg)
	li $v0,5
	syscall
	move $arg,$v0
	.end_macro
	
	#Macro: exit
	#Usage: exit
	.macro exit
	li $v0,10
	syscall
	.end_macro
	
	#Macro: swap_hi_lo
	#Usage: swap_hi_lo
	.macro swap_hi_lo($temp1, $temp2)
	mfhi $temp1
	mflo $temp2
	mthi $temp2
	mtlo $temp1
	syscall
	.end_macro
	
	#Macro: print_hi_lo
	#Usage: print_hi_lo
	.macro print_hi_lo(($strHi, $strEqual, $strComma, $strLo)
	mfhi $t1
	mflo $t2
	print_str($strHi)
	print_str($strEqual)
	print_reg_int($t1)
	print_str($strComma)
	print_str($strLo)
	print_str($strEqual)
	print_reg_int($t2)
	syscall
	.end_macro

	#Macro: pop($reg)
	#Usage: pop
	.macro pop($reg)
	addi $sp, $sp, 4
	lw $reg, 0x0($sp)
	.end_macro
	
	#Macro: push($reg)
	#Usage: push
	.macro push($reg)
	sw $reg, 0x0($sp)
	addi $sp, $sp, -4
	.end_macro
	
	#Macro: lwi
	#Uage: load
	.macro lwi($reg, $ui, $li)
	lui $reg, $ui
	ori $reg, $li
	.end_macro
	
	
