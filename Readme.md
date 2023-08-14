
# RISCV32 Subset for JPEG Encoding CPU Specification

## Project Files Instruction

### Software Python Code

In folder [algorithm](./algorithm), run **'image2row.py'** will output a ROW format image file. Run **'jpeg.py'** can encode the ROW image file into a JPEG file. And it can be opened in a regular personal computer. **'main.py'** do the same job as **'jpeg.py'**, but in the code, variables are been replaced by register names and memory locations. In this way, the **'main.py'** python code can be easily interpret to the assembly code.

### Software Assembly Code

In folder [assembly](./assembly), **'main.s'** is the macro style assembly code. This code can be compiled by the *[DUST Compiler](./compiler/dust.py)* into RISCV32-Subset binary machine code. Note that **'main.s'** is interpreted by hand from **'main.py'**.

### DUST compiler and simulator

In folder [compiler](./compiler), **'dust.s'** is the main function entry of the *DUST Compiler and Simulator*. It has a simple user interface, and can do multiple jobs during software and hardware design and verification. It can comile the macro assembly codes into system verilog memory code, binary machine code, hex machine code and basic assembly code. Meanwhile, it also can simulate the binary machine code, and generate a memory log, which can be compared with the memory log generated during hardware simulation. This is very helpful when applying UVM at simulation stage. This compiler is completely written by me, and try start it to find out how useful it is !

### RISCV32-Subset Core

In folder [riscv](./riscv), **'core.sv'** is the top module of riscv core componets. **'riscv32s.sv'** is a Harvard architecture MCU which will execute the program written in **'test.s'**. **'stim.sv'** is the stimulus file for **'riscv32s.sv'** during simulation.

### JPEG encoding SoC

In folder [soc](./soc),  **'soc.sv'** is the top level of the hierarchy. This system on chip has an UART interface which can receive the ROW file from personl computer UART port, and send the encoded huffman code back. But still need to do a post process to the received data by the python code by **['jpeg_gen.py'](./simulation/jpeg_gen.py)** to generate the '.jpg' file.

At simulation stage, testbench **'tb_soc.sv'** will help to achieve the hardware simulation and able to produce a **'mem.log'** file for UVM. Note that all the different memory log can be compared by the *DUST Compiler and Simulator*.

### Results

The orginal image file is a Windows '.bmp' file [test.bmp](./algorithm/test.bmp).

Output Image Encoded by software algorithm written in Python: [main.jpg](./algorithm/main.jpg)

![Test-software](./algorithm/main.jpg) 

Output Image Encoded by hardware (Post process by software) written in System Verilog: [hardware-output.jpg](./simulation/hardware-output.jpg)

![Test-hardware](./soc/hardware-output.jpg)

---

## Dust Compiler and Simulator Usage

    python .\compiler\dust.py
    # or python3 .\compiler\dust.py
    # when enter the dust, try 'help' to learn how to use it.
    # Try 'Bashme.sh' script in an Unix environment, a lot easier to start a simulation.

---

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
- Pipeline stage: 2
- Data Forwarding: no need to support
- Branch Prediction: no need to support
- Architecture: Harvard
- Bus: Write back
- ROM Size Support: 32x2^32bit
- RAM Size Support: 32x2^32bit

---

## Basic while and if replacements

### 8 Types of statements include in JEPG encoding algorithm

    if A, then(expressions):

    A is false goto line1 
        (expressions)
    line1:

    if A, (expressions1); else if B, (expressions2); else, (expressions3):

    A is false goto line1 
        (expressions1)
        goto end-else
    line1:
    B is false goto line2
        (expressions2)
        goto end-else
    line2:
        (expressions3)
    end-else:

    while A, then(expressions):

    line1:
    A is false goto line2 
        (expressions)
    goto line1
    line2:

    if A and B, then (expressions) : 

    A is false goto line1 
    B is false goto line1 
        (expressions)
    line1

    if A or B, then (expressions) : 

    A is true goto line1 
    B is true goto line1 
    goto line2
    line1:
        (expressions)
    line2:

    while A and B then (expressions) :

    line1:
    A is false goto line2 
    B is false goto line2 
        (expressions)
    goto line1
    line2:

    while A or B then (expressions) :

    line1:
    A is true goto line2 
    B is true goto line2 
    goto line3
    line2:
        (expressions)
    goto line1
    line3:

    break:

    (expressions)
    goto line1
    (expressions)
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
- mul    :  multiplication usage is massive, that is why there need a mul
- mulh   :  multiplication usage is massive, that is why there need a mulh

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