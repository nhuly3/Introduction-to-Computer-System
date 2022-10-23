.include "./cs47_macro.asm"
.data
msg1: .asciiz "Enter a number ? "
msg2: .asciiz "Factorial of the number is "
charCR: .asciiz "\n"
.text
.globl main
main: print_str(msg1)
      read_int($t0)

# Write body of the iterative
# factorial program here
# Store the factorial result into
# register $s0

li $s0,1 
li $t1,1 

loop:
bgt $t1,$t0,exit # if $t4 > $t0 exit the loop
mult $s0,$t1 
mflo $s0 # factorial=factorial*$t4
add $t1,$t1,1 #increement the counter
j loop

exit: print_str(msg2)
      print_reg_int($s0)
      print_str(charCR)

      exit
