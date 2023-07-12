
x28 = 32 + x0
x29 = 32 + x0
mem[x0 + 1187] = x28
mem[x0 + 1188] = x29
x1 = 4 + x0
x28 = x28 >> x1
x27 = x29 >> x1

x1 = 1 + x0
mem[x0 + 1198] = x1
x2 = 2 + x0
mem[x0 + 1199] = x2
x3 = 3 + x0
mem[x0 + 1200] = x3
x1 = 4 + x0
mem[x0 + 1208] = x1
x2 = 5 + x0
mem[x0 + 1209] = x2
x1 = 6 + x0
mem[x0 + 1210] = x1
x2 = -7 + x0
mem[x0 + 1211] = x2
x1 = -8 + x0
mem[x0 + 1212] = x1
x2 = 9 + x0
mem[x0 + 1213] = x2
x1 = -10 + x0
mem[x0 + 1214] = x1
x1 = -11 + x0
mem[x0 + 1215] = x1

x1 = 0 + x0
x2 = 0 + x0
x3 = 0 + x0
x4 = 0 + x0
x5 = 0 + x0
x6 = 0 + x0
x26 = 16 + x0
x25 = 8  + x0
x24 = 2  + x0
x21 = 0 + x0 // mem start

while x2 != x28,
    x10 = x26 *l x29
    x10 = x10 *l x2
    x10 = x10 + 2
    while x1 != x27,
        x11 = x26 *l x1
        x11 = x11 + x10
        while x4 != x24,
            x12 = x25 *l x29
            x12 = x12 *l x4 
            x12 = x12 + x11
            while x3 != x24,
                x13 = x25 *l x3
                x13 = x13 + x12
                while x5 != x25,
                    x14 = x5 + x13
                    while x6 != x25,
                        x15 = x29 *l x6
                        x15 = x15 + x14
                        x19 = 255
                        x16 = 2047
                        x16 = x16 >> x26
                        x16 = x16 & x19
                        x17 = 2047
                        x17 = x17 >> x25
                        x17 = x17 & x19
                        x18 = 2047
                        x18 = x18 & x19
                        x19 = mem[x0 + 1208]
                        x19 = x19 *h x16
                        x30 = mem[x0 + 1209]
                        x30 = x30 *h x17
                        x19 = x19 + x30
                        x30 = mem[x0 + 1210]
                        x30 = x30 *h x18
                        x19 = x19 + x30
                        x19 = x19 + 16

                        mem[x21 + 0] = x19
                        x21 = x21 + 1

                        x19 = mem[x0 + 1211]
                        x19 = x19 *h x16
                        x30 = mem[x0 + 1212]
                        x30 = x30 *h x17
                        x19 = x19 + x30
                        x30 = mem[x0 + 1213]
                        x30 = x30 *h x18
                        x19 = x19 + x30
                        x19 = x19 + 128

                        mem[x21 + 0] = x19
                        x21 = x21 + 1

                        x19 = mem[x0 + 1214]
                        x19 = x19 *h x17
                        x30 = mem[x0 + 1213]
                        x30 = x30 *h x16 
                        x19 = x19 + x30
                        x30 = mem[x0 + 1215]
                        x30 = x30 *h x18
                        x19 = x19 + x30
                        x19 = x19 + 128

                        mem[x21 + 0] = x19
                        x21 = x21 + 1
                        
                        x6 = x6 + 1
                    endwhile
                    x6 = 0 + x0
                    x5 = x5 + 1
                endwhile
                x5 = 0 + x0
                x3 = x3 + 1
            endwhile
            x3 = 0 + x0
            x4 = x4 + 1
        endwhile
        x4 = 0 + x0
        x1 = x1 + 1
    endwhile
    x1 = 0 + x0
    x2 = x2 + 1
endwhile
x31 = x0 + 999