// program for testbench
// arithmetic shift edge test
x1 = 1
x2 = 31
x1 = x1 << x2 // x1 = - 2^31
mem[x0 + 0] = x1 // mem[0] = -2,147,483,648
x1 = x1 >> x2 // x1 = -1
mem[x0 + 1] = x1 // mem[1] = -1
x1 = x1 << x2 // x1 =  -2,147,483,648
mem[x0 + 2] = x1 // mem[2] = -2,147,483,648
// multiplier edge test
x3 = 2
x4 = x3 *h x1
mem[x0 + 3] = x4 // mem[3] = -2
x3 = 666
x4 = x3 *h x1
mem[x0 + 4] = x4 // mem[4] = -666
// addition test
x4 = x4 + 777
mem[x0 + 5] = x4 // mem[4] = 111
