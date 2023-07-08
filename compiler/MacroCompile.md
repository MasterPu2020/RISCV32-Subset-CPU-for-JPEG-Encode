# 简化汇编编写难度的办法: 使用宏指令来解释高级语言



### while 指令

    while (x1 < x2)
        // loop
    endwhile

编译生成：

    addi 1 x0 x31
    blt x31 x0 enter_while
    line:
        // loop
    enter_while:
        blt x2 x1 line

---

### goto 指令

    line:

    goto line
    
编译生成：

    line:

    addi 1 x0 x31
    blt x31 x0 line

---

### if with goto 用法

    if (x1 >= x2) 
        goto line1
    endif
        // skip
    line1:

编译生成：

    blt x2 x1 endif
        addi 1 x0 x31
        blt x31 x0 goto
    endif:
        // skip
    goto:

### if goto 组成函数

    goto endfunc
    func:
        // function
    // return:
        if (x1 >= x2) 
            goto return_gate0
        endif
            // skip
        line1:
    endfunc:

    

添加指令需求：
1. branch x != imm 用于if，while
2. 改blt为 x < x 用于符号数比较
3. 判断相等 增加 == 理由如下

    if x1 == 1:

    if x1 != 1:
        x2 = 1
    else
        x2 = 0
    if x2 != 1: <=> if x1 == 1

    bqne 1 x1 notqual
        x2 = 0
        bqne 1 x0 endif
    notqual:
        x2 = 1
        bqne 1 x0 endif
    endif:
    bqne 1 x2 ifequal
        // if not equal
        bqne 1 x0 endif2
    ifequal:
        // if equal
        bqne 1 x0 endif
    endif2:
