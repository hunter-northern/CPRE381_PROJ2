	.data

Arr:	.word	1,3,2,5,4,0,7,6

	.text

	.globl main
	
# NOP: ori $0, $0, 0 # NOP

main:
	li $t1, 8		# get size of array

mainloop:
	subi $a1, $t1, 1	# count for current pass
	ori $0, $0, 0 # NOP
	ori $0, $0, 0 # NOP
	blez $a1, mainend	# check if complete
	ori $0, $0, 0 # NOP
	ori $0, $0, 0 # NOP
	ori $0, $0, 0 # NOP

	la $a0, Arr		# get array address
	li $t2, 0		# clear swap flag

	jal passloop		# single sort pass
	ori $0, $0, 0 # NOP

	beqz $t2, mainend	# if no swaps occur, sort is done
	ori $0, $0, 0 # NOP
	ori $0, $0, 0 # NOP
	ori $0, $0, 0 # NOP

	subi $t1, $t1, 1	# decrement remaining pass count
	j mainloop
	ori $0, $0, 0 # NOP

mainend:
	j end			# program complete
	ori $0, $0, 0 # NOP

passloop:
	lw $s1, 0($a0)		# load first element in $s1
	lw $s2, 4($a0)		# load second element in $s2
	ori $0, $0, 0 # NOP
	ori $0, $0, 0 # NOP
	bgt $s1, $s2, passswap	# if $s1 > $s2 swap elements
	ori $0, $0, 0 # NOP
	ori $0, $0, 0 # NOP
	ori $0, $0, 0 # NOP

passnext:
	addiu $a0, $a0, 4	# move to next element
	subiu $a1, $a1, 1	# decrement number of loops remaining
	ori $0, $0, 0 # NOP
	ori $0, $0, 0 # NOP
	bgtz $a1, passloop	# swap pass done? if no, loop
	ori $0, $0, 0 # NOP
	ori $0, $0, 0 # NOP
	ori $0, $0, 0 # NOP
	jr $ra			# yes, return
	ori $0, $0, 0 # NOP

passswap:
	sw $s1, 4($a0)		# put value of [i+1] in s1
	sw $s2, 0($a0)		# put value of [i] in s2
	li $t2, 1		# tell main loop that we did a swap
	j passnext
	ori $0, $0, 0 # NOP

end:
	li $v0, 10
	syscall
