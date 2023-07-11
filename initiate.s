x1 = 50 + x0
x2 = -10 + x0
x2 >= x1 goto endifmark0_0
    x2 = x2 + 5
    x2 >= x1 goto endifmark1_0
        x2 = x2 + 10
        x2 >= x1 goto endifmark2_0
            x2 = x2 * x2
            x3 = x0 + 2
            x2 = x2 * x3
        endifmark2_0:
    endifmark1_0:
endifmark0_0:
x31 = x0 + 999
