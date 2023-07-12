define // save to the memory file

0 <- 199
1 <- 12312933
2 <- 780
3 <- 1222
4 <- 9999
5 <- 8888
6 <- 10000
7 <- 12312941

endefine

// a simple loop with if conditions

x2 = 50 + x0
x1 = 100 + x0
while x0 < x1,

    if x1 < x2,
        x1 = x1 + 7
    endif

    if x1 != x0,
        x1 = x1 + -20
    endif
endwhile

x20 = x1 + 0 // show the result

// put 999 into register31
x31 = x0 + 11   
x30 = x0 + 4    
x30 = x30 << x31
x31 = x0 + 1807 
x31 = x30 | x31
