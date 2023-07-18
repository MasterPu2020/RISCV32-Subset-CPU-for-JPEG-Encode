// program for tsetbench
start:
addi -9 x0 x1 // x1 = x0 + -9  // x1 = -9
addi 10 x1 x2 // x2 = x1 + 10  // x2 = 1
addi 3 x0 x3 // x3 = x0 + 3   // x3 = 3
add x2 x1 x4 // x4 = x1 + x2  // x4 = -8
sll x3 x2 x4 // x4 = x2 << x3 // x4 = 8
mul x3 x1 x4 // x4 = x1 *l x3 // x4 = -27
mulh x3 x1 x4 // x4 = x1 *h x3 // x4 = -1
and x2 x1 x4 // x4 = x1 & x2  // x4 = 1
or x2 x1 x4 // x4 = x1 | x2  // x4 = -9
xori -1 x2 x4 // x4 = x2 ^ -1  // x4 = -2
sra x2 x1 x4 // x4 = x1 >> x2 // x4 = -5
beq x0 x0 line1 // x0 == x0 goto line1 // branch
addi 999 x0 x31 //     x31 = 999 + x0
line1:
bne x0 x4 line2 // x4 != x0 goto line2
addi 888 x0 x30 //     x30 = 888 + x0
line2:
blt x0 x4 line3 // x4 < x0 goto line3
addi 777 x0 x29 //     x29 = 777 + x0
line3:
bge x4 x0 line4 // x0 >= x4 goto line4
addi 666 x0 x28 //     x28 = 666 + x0
line4:
addi 100 x0 x5 // x5 = x0 + 100    // x5 = 100
sw x5 x0 0 // mem[x0 + 0] = x5 // mem[0] = 100
lw 0 x0 x4 // x4 = mem[x0 + 0] // x4 = 100
addi 4 x0 x30 // x30 = x0 + 4 
addi 11 x0 x31 // x31 = x0 + 11 
sll x31 x30 x30 // x30 = x30 << x31
addi 1807 x0 x31 // x31 = x0 + 1807 
or x31 x30 x10 // x10 = x30 | x31
startwhilemark0_0:
beq x0 x10 endwhilemark0_0 // x10 == x0 goto endwhilemark0_0
addi -1 x10 x10 //     x10 = x10 + -1
sw x10 x10 0 //     mem[x10 + 0] = x10
beq x0 x0 startwhilemark0_0 // x0 == x0 goto startwhilemark0_0
endwhilemark0_0:
beq x0 x0 start // x0 == x0 goto start

