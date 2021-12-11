	.data

Arr:	.word	1,3,2,5,4,0,7,6

	.text

	.globl main

main:
	li $t1, 8		# get size of array
	nop
	nop
	nop
mainloop:
	ori $t2, $0, 1
	nop	
	nop
	nop
	sub $a1, $t1, $t2	# count for current pass
	nop
	nop
	nop
	
	beq $a1, $0, mainend	# check if complete
	nop
	nop
	nop

	lui $a0, 4097		# get array address
	li $t2, 0		# clear swap flag
	nop
	jal passloop		# single sort pass
	nop

	beq $t2, $0, mainend	# if no swaps occur, sort is done
	nop
	nop
	nop

	subi $t1, $t1, 1	# decrement remaining pass count
	j mainloop
	nop

mainend:
	j end			# program complete
	nop

passloop:
	lw $s1, 0($a0)		# load first element in $s1
	lw $s2, 4($a0)		# load second element in $s2
	nop
	nop
	nop
	slt $t6, $s2, $s1 
	nop
	nop
	nop
	bne $t6, $0, passswap	# if $s1 > $s2 swap elements
	nop
	nop
	nop

passnext:
	addiu $a0, $a0, 4	# move to next element

	ori $t6, $0, 1
	nop 
	nop
	nop
	sub $a1, $a1, $t6	# decrement number of loops remaining
	nop
	nop
	nop
	slt $t7, $a1, $0
	nop
	nop
	nop
	beq $a1, $0, passloop	# swap pass done? if no, loop
	jr $ra			# yes, return
	nop

passswap:
	sw $s1, 4($a0)		# put value of [i+1] in s1
	sw $s2, 0($a0)		# put value of [i] in s2
	li $t2, 1		# tell main loop that we did a swap
	j passnext
	nop

end:
	li $v0, 10
	syscall
halt
