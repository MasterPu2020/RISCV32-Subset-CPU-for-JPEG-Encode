// program for tsetbench
start:
x1 = x0 + -9  // x1 = -9
x2 = x1 + 10  // x2 = 1
x3 = x0 + 3   // x3 = 3
x4 = x1 + x2  // x4 = -8
x4 = x2 << x3 // x4 = 8
x4 = x1 *l x3 // x4 = -27
x4 = x1 *h x3 // x4 = -1
x4 = x1 & x2  // x4 = 1
x4 = x1 | x2  // x4 = -9
x4 = x2 ^ -1  // x4 = -2
x4 = x1 >> x2 // x4 = -5
x0 == x0 goto line1
    x31 = 999 + x0
line1:
x4 != x0 goto line2
    x30 = 888 + x0
line2:
x4 < x0 goto line3
    x29 = 777 + x0
line3:
x0 >= x4 goto line4
    x28 = 666 + x0
line4:
x5 = x0 + 100    // x5 = 100
mem[x0 + 0] = x5 // mem[0] = 100
x4 = mem[x0 + 0] // x4 = 100
x0 == x0 goto start
