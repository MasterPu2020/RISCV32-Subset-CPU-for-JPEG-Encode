
# RISCV32 Subset for JPEG Encoding CPU Specification

## Compiler and Simulator使用方法

    python .\compiler\dust.py
    python .\compiler\compile.py initiate.s 
    python .\simulator\riscv32s.py initiate.bin +start=0 +pause

                                      RISC-V 32 Subset
    +---------------------------------------------------------------------------------+
    |31           25|24     20|19     15|14     12|11           7|6       0|   code   |
    +---------------------------------------------------------------------------------+
    |    0000000    |   rs2   |   rs1   |   000   |      rd      | 0110011 | [R] add  |
    |    0000000    |   rs2   |   rs1   |   111   |      rd      | 0110011 | [R] and  |
    |    0000000    |   rs2   |   rs1   |   110   |      rd      | 0110011 | [R] or   |
    |    0000000    |   rs2   |   rs1   |   001   |      rd      | 0110011 | [R] sll  |
    |    0100000    |   rs2   |   rs1   |   101   |      rd      | 0110011 | [R] sra  |
    |    0000001    |   rs2   |   rs1   |   000   |      rd      | 0110011 | [R] mul  |
    |    0000001    |   rs2   |   rs1   |   001   |      rd      | 0110011 | [R] mulh |
    +---------------------------------------------------------------------------------+
    |        imm[11:0]        |   rs1   |   000   |      rd      | 0010011 | [I] addi |
    |        imm[11:0]        |   rs1   |   110   |      rd      | 0010011 | [I] xori |
    |        imm[11:0]        |   rs1   |   010   |      rd      | 0000011 | [I] lw   |
    +---------------------------------------------------------------------------------+
    |    imm[11:5]  |   rs2   |   rs1   |   010   |   imm[4:0]   | 0100011 | [S] sw   |
    +---------------------------------------------------------------------------------+
    |  imm[12|10:5] |   rs2   |   rs1   |   000   |  imm[4:1|11] | 1100011 | [B] beq  |
    |  imm[12|10:5] |   rs2   |   rs1   |   001   |  imm[4:1|11] | 1100011 | [B] bne  |
    |  imm[12|10:5] |   rs2   |   rs1   |   100   |  imm[4:1|11] | 1100011 | [B] blt  |
    |  imm[12|10:5] |   rs2   |   rs1   |   101   |  imm[4:1|11] | 1100011 | [B] bge  |
    +---------------------------------------------------------------------------------+
    
## RISCV32-Subset CPU规格
- Pipeline：2级
- Data Forwarding: 不支持
- Branch Prediction：不支持
- Architecture：哈佛（可拓展多核设计）
- Bus：WB
- ROM Size：32x2^12bit = 16KB
- RAM Size:  8x2^32bit =  4GB
---

## 分支指令的等效替换

### 7 Types

if A, then():

    goto line1 if A is false
        ()
    line1:

while A, then():

    line1:
    goto line2 is A is false
        ()
    goto line1
    line2:

if A and B, then () : 

    goto line1 if A is false,
    goto line1 if B is false
        ()
    line1

if A or B, then () : 

    goto line1 if A is true,
    goto line1 if B is true
    goto line2
    line1:
        ()
    line2:

while A and B then () :

    line1:
    goto line2 if A is false
    goto line2 if B is false
        ()
    goto line1
    line2:

while A or B then () :

    line1:
    goto line2 if A is true
    goto line2 if B is true
    goto line3
    line2:
        ()
    goto line1
    line3:

break:

    (...
    goto line1
    ...)
    line1:

### Logic Judgement
- x1 == x2
- x1 != x2
- x1 < x2
- x1 >= x2

Replacements:
- not x1 == x2: x1 != x2
- not x1 != x2: x1 == x2
- not x1 < x2: x1 >= x2

### 使用的指令
**[ I type ]**
- addi   :  用于加载立即数和立即数的加法
- xori   :  与立即数-1异或，用于实现按位取反的非常重要的位操作
- lw     :  所有的运算均是32位整数运算，load word很重要

**[ S type ]**
- sw     :  store word，Huffman编码写回时压栈方法，也是保存32位整数数据的重要方法

**[ R type ]**
- add    :  用于常规加法
- and    :  按位与，非常重要的位截取操作
- or     :  按位或，非常重要的位拼接操作
- sll    :  logic shift left by reg
- sra    :  arithmetic shift right by reg
- mul    ： 乘法用量非常大，并且FPGA上配置了乘法器，可以使用
- mulh   ： 乘法用量非常大，并且FPGA上配置了乘法器，可以使用

**[ B type ]** 12位地址范围跳转，6.5k行汇编够用了
- blt    :  branch if less than
- bge    :  branch if greater than or equal
- beq    :  branch if equal
- bne    :  branch if not equal

---

## Note :
1. 立即数imm的长度均为12bit
2. 对于32位CPU，1word = 4byte
3. not = xori -1
4. 主动pipeline stall: addi x0 0
5. 涉及到小数或除法运算使用 * 2^16化为32bit整数，在结束需要化整时再>>16bit来还原
6. 所有立即数均有符号位扩展

---

*Author: Clark Pu*