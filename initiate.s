addi 1 x0 x1
add x1 x1 x2
sw x2 x0 64
lw 64 x0 x3
addi 1 x0 x4
beq x1 x4 line1
    addi 999 x0 x4
line1:
addi -999 x0 x4
bne x1 x4 line2
    add x1 x4 x5
line2:
    addi 199 x4 x5
mul x2 x5 x7
mulh x2 x5 x6
bge x0 x6 line3
xori -1 x6 x6
line3:
bge x0 x7 line5
    addi 10 x7 x7
beq x0 x0 line3
line5:
addi 1000 x0 x31
