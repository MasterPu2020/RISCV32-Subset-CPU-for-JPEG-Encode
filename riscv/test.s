<<<<<<< HEAD
// program for testbench
// arithematic shift edge test
x1 = 1
x2 = 31
x1 = x1 << x2 // x1 = - 2^31
mem[x0 + 0] = x1 // mem[0] = -2,147,483,648
x1 = x1 >> x2 // x1 = -1
mem[x0 + 1] = x1 // mem[1] = -1
x1 = x1 << x2 // x1 =  -2,147,483,648
mem[x0 + 2] = x1 // mem[2] = -2,147,483,648
// multipiler edge test
x3 = 2
x4 = x3 *h x1
mem[x0 + 3] = x4 // mem[3] = -2
x3 = 666
x4 = x3 *h x1
mem[x0 + 4] = x4 // mem[4] = -666
// addition test
x4 = x4 + 777
mem[x0 + 5] = x4 // mem[4] = 111
=======
// program for tsetbench
x1 = 2
x5 = 2
x2 = 0
x3 = 31
while x2 < x3,
    x1 = x1 *l x5
    x4 = x1 *h x5
    mem[x2 +  0] = x1
    mem[x2 + 32] = x4
    x2 = x2 + 1
endwhile
// x1 = 2
// x5 = -2
// x2 = 0
// x3 = 31
// while x2 < x3,
//     x1 = x1 *l x5
//     x4 = x1 *h x5
//     x2 = x2 + 1
//     mem[x2 + 64] = x1
//     mem[x2 + 96] = x4
// endwhile
>>>>>>> b9e8f45e3fb55d04516e8baea8737c5709f435ec
