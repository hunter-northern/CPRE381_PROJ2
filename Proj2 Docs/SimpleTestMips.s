# test of arithmetic and logical instructions (modified from project 1 base test)

# add and sub instructions
addiu $t0, $0, -24       # put -24 in $t0
addi $t1, $0, 43      # put 43 in $t1
nop
nop
nop
add $t2, $t0, $t1       # put -24 + 43 = 19 into $t2
addu $t3, $t0, $t1      # put -24 + 43 = 19 into $t3
nop
nop
nop
sub $t1, $t3, $t2       # put 19 - 19 = 0 into $t1
nop
nop
nop
subu $t0, $t1, $t3      # put 0 - 19 = -19 into $t0


# boolean logic instructions
nop
nop
andi $t0, $t0, 0        # clear value from $t0
and $t1, $t1, $0        # clear value from $t1
ori $t0, $0, 7         # put 7 into $t0
or $t1, $0, $t2        # put 19 into $t1
xor $t4, $t3, $t2       # 0x00000013 xor 0x00000043, $t4 set to 0x00000000
nop
nop
nop
xori $t5, $t4, 80       # 0x00000000 xor 0x00000050, $t5 set to 0x00000050
nop
nop
nop
nor $t6, $t5, $t3       # 0x00000050 nor 0x00000013, $t6 set to 0xFFFFFFAC


# shifting instructions
nop
nop
nop
sll $t7, $t6, 16        # $t7 becomes 0xFFAC0000
nop
nop
nop
sra $t8, $t7, 4         # $t8 becomes 0xFFFAC000
nop
nop
nop
srl $t9, $t8, 8         # $t9 becomes 0x00FFFAC0

# load and store instructions
lui $s0, 4096
nop
nop
nop
nop
sw $t0, 0($s0)           # store value of $t0 into 0($s0)
sw $t1, 4($s0)           # store value of $t1 into 4($s0)
sw $t2, 8($s0)           # store value of $t2 into 8($s0)
sw $t3, 12($s0)           # store value of $t3 into 12($s0)
sw $t4, 16($s0)           # store value of $t4 into 16($s0)
sw $t5, 20($s0)           # store value of $t5 into 20($s0)
sw $t6, 24($s0)           # store value of $t6 into 24($s0)
sw $t7, 28($s0)           # store value of $t7 into 28($s0)

lui $t0, 15              # set $t0 to 0x000F0000
lui $t1, 255             # set $t1 to 0x00FF0000
lw $t2, 4($s0)           # set $t2 to 19
lw $t3, 24($s0)           # set $t3 to 0xFFFFFFAC


# set less than
nop
nop
slt $t6, $t4, $t5       # set $t6 to 1 since 0x02020202 < 0x04040404
slt $t7, $t5, $t2       # set $t7 to 0 since 0x04040404 > 19
nop
nop
slti $t8, $t6, 1        # set $t8 to 0 since 1 = 1
nop
nop
nop
slti $t9, $t8, 1        # set $t9 to 1 since 0 < 1


halt
