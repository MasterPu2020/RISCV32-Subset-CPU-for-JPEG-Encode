
line0
x1 = x0 + 1
x2 = x1 + x1
x3 = x0 + 2
x3 == x2 goto line1
    x3 = x2 + 0
line1:
x3 < x0 goto line3
    x3 = x3 + -1
x0 == x0 goto line1
line3:
x31 = x0 + 999
x0 == x0 goto line0