# 编写一个简易的汇编转机器码的脚本
**脚本基本功能需支持：**
1. 汇编指令转机器码
2. 简单的语法报错，如重复的宏定义，错误的指令使用等
3. 可以预处理定义的宏变量
4. 可以预处理注释
5. 可以预解释跳转目的地
6. 可以解释连续值
7. 简单的数据溢出报错，imm不能超过规定范围值

**脚本高级功能拓展：**
1. 可以用于仿真RISCV程序
2. 仿真结果汇报，如分支预测失败次数，执行周期，执行次数统计等
3. 可以检测 data hazard 并注释
4. RAM定义重载报错，不同的变量若使用了相同的RAM区间将报错

---

**基本语法**

- 数据进制支持 0x 作为16进制定义，数据无前缀为十进制
- 宏定义字符可使用任何字符
- // 注释形式
- x0 : x接0~31的字符串作为寄存器地址，定义变量时x接0~31为非法
- pc: 定义ROM地址值，其值为下一行代码的pc地址，':' 是标记符，除了注释不能跟别的东西。类型为ROM地址
- int imm 126：定义默认范围为12bit整数，作为立即数使用
- a[10] : 解释值 = a + 10

**高级语法**

- addr ram-address 0xfff : 定义RAM地址值，类型为RAM地址，允许重载
- addr ram-area 0x00f 0x01f : 定义RAM区间，类型为RAM地址，不允许同为区间的值重载
- addr ram-area.dc 0x010: 定义RAM区间下的某个地址，允许重载，定义范围不能在区间外
- (imm * 8 + 1) ：imm计算，写代码时在imm的位置使用括号括起来以允许简单的计算
- int imm 77 len 20：定义范围为自定义比特的整数，作为立即数使用

**其余指令使用语法**

    add  rs2 rs1 rd  // add  rs2 + rs1 -> rd
    or   rs2 rs1 rd  // or   rs2 | rs1 -> rd
    mul  rs2 rs1 rd  // mul  (rs2 * rs1)[31: 0] -> rd 
    mulh rs2 rs1 rd  // mulh (rs2 * rs1)[63:32] -> rd 
    addi imm rs1 rd  // addi imm + rs1 -> rd
    slli imm rs1 rd  // slli r1 << imm[4:0] -> rd
    srli imm rs1 rd  // srli r1 >> imm[4:0] -> rd
    xori imm rs1 rd  // xori imm ^ rs1 -> rd
    lw   imm rs1 rd  // lw   mem(imm + rs1) -> rd
    sw   rs2 rs1 imm // sw   mem(imm + rs1) <- rs2
    blt  rs2 rs1 pc_imm  // blt  pc <- ({pc_imm,0} + pc) if (rs1 < rs2)

---

**RISCV32指令对照表**

    // -----------------------------------------------------------------------------------
    //                                   RISC-V 32 Subset
    // +---------------------------------------------------------------------------------+
    // |31           25|24     20|19      5|14     12|11           7|6       0|   code   |
    // +---------------------------------------------------------------------------------+
    // |    0000000    |   rs2   |   rs1   |   000   |      rd      | 0110011 | [R] add  |
    // |    0000000    |   rs2   |   rs1   |   110   |      rd      | 0110011 | [R] or   |
    // |    0000001    |   rs2   |   rs1   |   000   |      rd      | 0110011 | [R] mul  |
    // |    0000001    |   rs2   |   rs1   |   001   |      rd      | 0110011 | [R] mulh |
    // +---------------------------------------------------------------------------------+
    // |        imm[11:0]        |   rs1   |   000   |      rd      | 0010011 | [I] addi |
    // |        imm[11:0]        |   rs1   |   001   |      rd      | 0010011 | [I] slli |
    // |        imm[11:0]        |   rs1   |   101   |      rd      | 0010011 | [I] srli |
    // |        imm[11:0]        |   rs1   |   110   |      rd      | 0010011 | [I] xori |
    // |        imm[11:0]        |   rs1   |   010   |      rd      | 0000011 | [I] lw   |
    // +---------------------------------------------------------------------------------+
    // |    imm[11:5]  |   rs2   |   rs1   |   010   |   imm[4:0]   | 0100011 | [S] sw   |
    // +---------------------------------------------------------------------------------+
    // |  imm[12|10:5] |   rs2   |   rs1   |   100   |  imm[4:1|11] | 1100011 | [B] blt  |
    // +---------------------------------------------------------------------------------+
    // |                    imm[31:12]               |      rd      | 0110111 | [U] lui? |
    // +---------------------------------------------------------------------------------+