
# RISCV32 Subset for JPEG Encoding CPU Specification

## Compiler and Simulator Usage

    python .\compiler\dust.py
    mem size 411700

## RISC-V 32 Subset

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
    
## RISCV32-Subset CPU Information
- Pipeline stage：2
- Data Forwarding: not yet support
- Branch Prediction：not yet support
- Architecture：Haverd
- Bus：Write back
- ROM Size Support：32x2^32bit
- RAM Size Support: 32x2^32bit
---

## Basic while and if replacements

### 8 Types of statements include in JEPG encoding algorithm

if A, then():

    A is false goto line1 
        ()
    line1:

if A, (1); else if B, (2); else, (3):

    A is false goto line1 
        (1)
        goto end-else
    line1:
    B is false goto line2
        (2)
        goto end-else
    line2:
        (3)
    end-else:

while A, then():

    line1:
    A is false goto line2 
        ()
    goto line1
    line2:

if A and B, then () : 

    A is false goto line1 
    B is false goto line1 
        ()
    line1

if A or B, then () : 

    A is true goto line1 
    B is true goto line1 
    goto line2
    line1:
        ()
    line2:

while A and B then () :

    line1:
    A is false goto line2 
    B is false goto line2 
        ()
    goto line1
    line2:

while A or B then () :

    line1:
    A is true goto line2 
    B is true goto line2 
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

### Instruction usage statements
**[ I type ]**
- addi   :  mainly used for load a 12-bit imm
- xori   :  to achieve not operation, xor with imm -1
- lw     :  load word.

**[ S type ]**
- sw     :  store word.

**[ R type ]**
- add    :  regular addition
- and    :  regular and, used for data trancation
- or     :  regular or, used for data joint
- sll    :  logic shift left by reg
- sra    :  arithmetic shift right by reg
- mul    ： multiplication usage is massive, that is why there need a mul
- mulh   ： multiplication usage is massive, that is why there need a mulh

**[ B type ]**
- blt    :  branch if less than
- bge    :  branch if greater than or equal
- beq    :  branch if equal
- bne    :  branch if not equal

---

## Note :
1. imm length are all 12-bit, and need to be extended to save in the register file
2. for 32-bit CPU, 1word = 4byte
3. not = xori -1
4. program pipeline stall: addi x0 0
5. any calculation involving deciaml number 'n', use n * 2^16 and n >> 16 to proccess it as an integer

---

*Author: Clark Pu*