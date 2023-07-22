// program for tsetbench
x1 = 2
x3 = 31
while x2 < x3,
    x1 = x1 *l x1
    x4 = x1 *h x1
    x2 = x2 + 1
    mem[x2 + 0] = x1
    mem[x2 + 32] = x4
endwhile
x1 = 2
x5 = -2
x2 = 0
x3 = 31
while x2 < x3,
    x1 = x1 *l x5
    x4 = x1 *h x5
    x5 = x1 ^ -1 // x5 = - x1
    x5 = x5 + 1  // x5 = - x1
    x2 = x2 + 1
    mem[x2 + 64] = x1
    mem[x2 + 96] = x4
endwhile
