// this is a assmbly code example
// x0  - x16 variables
// x16 - x25 parameters
// x25 - x30 return flag
int block-y 1
// init
addi 64 x0 x25 // parameter x25 = 64
blt x25 x0 start // goto start, process begin
// function subcrat matrix by constant 128
subcrat-matrix:
    // while
    continue:
        lw block-y x1 x2 // load block[x1] to x2
        add x24 x2 x2 // x2 - 128
        sw x2 x1 block-y // save x2 to block[x1]
        addi 1 x1 x1 // increase x1
    blt x25 x1 continue // 64 > x1
    // return gates
    addi 0 x0 x1 // clear x1
    blt x30 x0 subcrat-matrix-return-gate1
    blt x25 x0 subcrat-matrix-return-gate0

start:
    addi 0 x0 x30 // x30: return gate = 0
    addi -128 x0 x24 // parameter x24 = -128
    blt x25 x0 subcrat-matrix
    subcrat-matrix-return-gate0:
    addi 1 x0 x30 // x30: return gate = 1
    addi 128 x0 x24 // parameter x24 = 128
    blt x25 x0 subcrat-matrix
    subcrat-matrix-return-gate1:

// return start forever
blt x25 x0 start
