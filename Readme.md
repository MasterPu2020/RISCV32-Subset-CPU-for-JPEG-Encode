
# RISCV32 Subset for JPEG Encoding CPU Specification

## RISCV32-Subset CPU规格
- Pipeline：2级
- Data Forwarding: 不支持
- Branch Prediction：不支持
- Architecture：哈佛（可拓展多核设计）
- Bus：WB
- ROM Size：32x2^12bit = 16KB
- RAM Size:  8x2^32bit =  4GB
---

## 必须使用的指令
**[ I type ]**
- addi   :  用于加载立即数和立即数的加法
- slli   :  shift left logic imm, huffman编码按1比特堆栈时候会用到
- srli   :  shift right logic imm, 整数化回小数的运算会使用
- xori   :  与立即数异或，用于实现按位取反的非常重要的位操作
- lw     :  所有的运算均是32位整数运算，load word很重要

**[ S type ]**
- sw     :  store word，Huffman编码写回时压栈方法，也是保存32位整数数据的重要方法

**[ R type ]**
- add    :  用于常规加法
- and    :  按位与，非常重要的位截取操作
- or     :  按位或，非常重要的位拼接操作
- mul    ： 乘法用量非常大，并且FPGA上配置了乘法器，可以使用

**[ B type ]** 12位地址范围跳转，6.5k行汇编够用了
- blt    :  jump if less than，CORDIC会使用到大小判断，所以必须要用判断signed-int32大小的电路

---

## 可能会增加的指令
- lb       : 涉及到对uart RAM中数据快速读取，优化效果应该还是有的，只不过不大，看情况使用
- lui [U]  : 用于加载立即数高20位的常用指令, 也可以用addi与srli组合实现
- sb       : write byte，可以优化uart交互速度，但貌似目前没有必要
- beq      : jump if equal，也许会用于霍夫曼数据堆栈中的后处理
- jal [UJ] : jump and link 2位强制跳转，按需增加

---

## 有用但不会使用的指令
- sub ：- a == + (~ a + 1) 自由减法涉及的不多，只在Huffman编码的地方用到
- div : 小数 << 32 并与整数相乘取整就行，真正涉及到自由除法的地方只有量化

---

## Note :
1. 立即数imm的长度均为12bit
2. 对于32位CPU，1word = 4byte
3. not = xori -1
4. 主动pipeline stall: addi x0 0
5. 涉及到小数或除法运算使用 * 2^16化为32bit整数，在结束需要化整时再>>16bit来还原

---

*Author: Clark Pu*