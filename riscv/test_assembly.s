// program for tsetbench
start:
addi -9 x0 x1
addi 10 x1 x2
addi 3 x0 x3
add x2 x1 x4
sll x3 x2 x4
mul x3 x1 x4
mulh x3 x1 x4
and x2 x1 x4
or x2 x1 x4
xori -1 x2 x4
sra x2 x1 x4
beq x0 x0 line1
addi 999 x0 x31
line1:
bne x0 x4 line2
addi 888 x0 x30
line2:
blt x0 x4 line3
addi 777 x0 x29
line3:
bge x4 x0 line4
addi 666 x0 x28
line4:
addi 100 x0 x5
sw x5 x0 0
lw 0 x0 x4
beq x0 x0 start

