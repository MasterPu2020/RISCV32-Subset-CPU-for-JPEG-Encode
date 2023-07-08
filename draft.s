    addi 516 x0 x1 // int x1
    addi 524 x0 x2 // while x1 < x2
        sw x27 x1 0
        addi 1 x1 x1 // i++
    blt x2 x1 -2 // end while