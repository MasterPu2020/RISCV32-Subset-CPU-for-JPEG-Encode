// this is a assmbly code
// x0  - x16 variables
// x16 - x25 parameters
// x25 - x30 return flag
int block-y 1
// function subcrat matrix by constant 128
subcrat-matrix:
    // init
    addi 64 x0 x25 // parameter x25 = 64
    addi 0b111111111111 x0 x24 
    slli 12 x24 x24 
    addi 0b111111111111 x24 x24 
    slli 12 x24 x24 
    addi -128 x0 x24 // parameter x24 = -128
    addi 0 x0 x1
    // while
    continue:
        lw block-y x1 x2 // load block[x1] to x2
        add x24 x2 x2 // x2 - 128
        sw x2 x1 block-y // save x2 to block[x1]
        addi 1 x1 x1 // increase x1
    blt x1 x25 continue // x1 < 64
    // return
    blt x0 x30 subcrat-matrix-return-gate1
    blt x0 x0 subcrat-matrix-return-gate0

start:
    addi 0 x0 x30 // x30: return gate = 0
    blt x0 x0 subcrat-matrix
    subcrat-matrix-return-gate0:
    addi 1 x0 x30 // x30: return gate = 1
    blt x0 x0 subcrat-matrix
    subcrat-matrix-return-gate1:

// return start forever
blt x0 x0 start
