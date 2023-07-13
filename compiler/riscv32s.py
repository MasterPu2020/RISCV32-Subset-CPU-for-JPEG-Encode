# --------------------------------------------------------------------------
# Using UTF-8
# Title: RISCV32 Subset Instrcutions Simulate Script
# Last Modified Date: 2023/7/7
# Version: 1.0
# Author: Clark Pu
# --------------------------------------------------------------------------


import sys
import time


# parameters:
opcode = [    'add',     'and',      'or',     'sll',     'sra',     'mul',    'mulh',    'addi',    'xori',      'lw',      'sw',     'beq',     'bne',     'blt',     'bge']
opbin  = ['0110011', '0110011', '0110011', '0110011', '0110011', '0110011', '0110011', '0010011', '0010011', '0000011', '0100011', '1100011', '1100011', '1100011', '1100011']
funct7 = ['0000000', '0000000', '0000000', '0000000', '0100000', '0000001', '0000001',        '',        '',        '',        '',        '',        '',        '',        '']
funct3 = [    '000',     '111',     '110',     '001',     '101',     '000',     '001',     '101',     '110',     '010',     '010',     '000',     '001',     '100',     '101']

x = [0] * 32 # registers
pc = 0
mem = [0] * 1000000 # RAM

# Verilog style trancation
def tranc(string:str, top:int, buttom:int=-1): 
    assert len(string.replace('1','').replace('0','')) == 0, 'Simulator error: tranc string is not binary.'
    assert top < len(string), 'Simulator error: top bit large than string size.'
    assert buttom < top and buttom >= -1, 'Simulator error: top bit less than buttom bit.'
    if buttom == -1:
        return string[-top-1]
    elif buttom != 0:
        return string[-top-1:-buttom]
    else:
        return string[-top-1:]

# signed 32bit operation
def op32(value:int):
    value = int(value) & (2**32-1)
    value_bin = '0' * (32 - len(bin(value)[2:])) + bin(value)[2:]
    if value_bin[0] == '1':
        value = int(value_bin.replace('0','x').replace('1','0').replace('x','1'), 2) + 1
        return - value
    else:
        return value

# signed 12bit imm extend
def imm32(string:str):
    if string[0] == '1':
        string = '1' * 20 + string
        return op32(int(string, 2))
    else:
        return int(string, 2)

# execute the instruction
def execute(inst, pc):
    branch = False
    rd  = int(tranc(inst,11, 7), 2)
    rs1 = int(tranc(inst,19,15), 2)
    rs2 = int(tranc(inst,24,20), 2)
    immi = imm32(tranc(inst,31,20))
    imms = imm32(tranc(inst,31,25)+tranc(inst,11,7))
    immb = imm32(tranc(inst,31)+tranc(inst,7)+tranc(inst,30,25)+tranc(inst,11,8))
    inst_opbin  = tranc(inst,6,0)
    inst_funct7 = tranc(inst,31,25)
    inst_funct3 = tranc(inst,14,12)
    inst_op = ''
    for op_id in range(0,len(opcode)):
        # search opcode
        if inst_opbin == opbin[0]: # r type
            if inst_funct7 == funct7[op_id] and inst_funct3 == funct3[op_id]:
                inst_op = opcode[op_id]
                break
        elif inst_opbin == opbin[op_id] and inst_funct3 == funct3[op_id]:
            inst_op = opcode[op_id]
            break
    # r type
    if inst_op == 'add':
        x[rd] = op32(x[rs2] + x[rs1])
    elif inst_op == 'and':
        x[rd] = op32(x[rs2] & x[rs1])
    elif inst_op == 'or':
        x[rd] = op32(x[rs2] | x[rs1])
    elif inst_op == 'sll':
        x[rd] = op32(x[rs2] << x[rs1])
    elif inst_op == 'sra':
        x[rd] = op32(x[rs2] >> x[rs1])
    elif inst_op == 'mul':
        x[rd] = op32(x[rs2] * x[rs1])
    elif inst_op == 'mulh':
        x[rd] = op32((x[rs2] * x[rs1]) >> 31)
    # i type
    elif inst_op == 'addi':
        x[rd] = op32(x[rs1] + immi)
    elif inst_op == 'xori':
        x[rd] = op32(x[rs1] ^ immi)
    elif inst_op == 'lw':
        x[rd] = mem[op32(x[rs1] + immi)]
    # s type
    elif inst_op == 'sw':
        mem[op32(x[rs1] + imms)] = x[rs2]
    # b type, pc is unsigned
    elif inst_op == 'beq':
        if x[rs1] == x[rs2]:
            pc = (pc + immb) & (2**32-1)
            branch = True
    elif inst_op == 'bne':
        if x[rs1] != x[rs2]:
            pc = (pc + immb) & (2**32-1)
            branch = True
    elif inst_op == 'blt':
        if x[rs1] < x[rs2]:
            pc = (pc + immb) & (2**32-1)
            branch = True
    elif inst_op == 'bge':
        if x[rs1] >= x[rs2]:
            pc = (pc + immb) & (2**32-1)
            branch = True
    else:
        exit('\n Error: Opcode not find: opcode is ' + inst_opbin)
    return inst_op, rd, rs1, rs2, immi, imms, immb, pc, branch

# display reg file and mem file
def show(save=False, reglen=7, memlen=7):
    print('\n[Register File: 32 x 32bit]')
    print('+','-'*77,'+')
    for i in range(0,4):
        text = '|'
        for j in range(0,8):
            text += ' ' * (2-len(str(j + i*8))) + 'x' + str(j + i*8) + ':' + ' ' * (reglen - len(str(x[j + i*8]))) + str(x[j + i*8]) + '|'
        print(text)
    print('+','-'*77,'+')
    print('\n[Memory File]')
    print('+','-'*85,'+')
    j = 0
    text = '|'
    line = 0
    for i in range(0, len(mem)):
        if mem[i] == 0:
            continue
        else:
            text += ' ' * (5-len(hex(i)[2:])) + hex(i)[2:].upper() + ':' + ' ' * (memlen - len(str(mem[i]))) + str(mem[i]) + '|'
            j += 1
            if j == 8:
                print(text)
                line += 1
                text = '|'
                j = 0
        if line > 10:
            text = "| Use 'savelog' command to save the whole Memory File into mem.log... "
            break
    if len(text) != 0:
        print(text+' '*(88-len(text))+'|')
    print('+','-'*85,'+')
    if save:
        k = 0
        logtext = '[Memory File]:\n|'
        for i in range(0, len(mem)):
            logtext += ' ' * (4-len(hex(i)[2:])) + hex(i)[2:].upper() + ':' + ' ' * (memlen - len(str(mem[i]))) + str(mem[i]) + '|'
            k += 1
            if k == 16:
                k = 0
                logtext += '\n|'
        with open('mem.log', 'w') as memlog:
            memlog.write(logtext)
    return

# special function load image:
def loadimg():
    # This is just a simulation for the real UART interface. // reg [0:31] ram [0:N]
    def get_row(file_path:str):
        with open(file_path, 'rb+') as image:
            img_row = []
            byte_file = image.read()
            double_word = ''
            x1 = 1
            for byte in byte_file:
                text = str(hex(int(byte))[2:].upper())
                if len(text) < 2:
                    text = '0' + text
                double_word += text
                if x1 % 4 == 0:
                    img_row.append(int(double_word, 16))
                    double_word = ''
                x1 += 1
        return img_row
    rowmem = get_row('./algorithm/test.row')
    mem[1500:1500+len(rowmem)] = rowmem


# Main:
# python .\simulator\riscv32s.py .\compiler\code.bin +start=0 +pause
if __name__ == '__main__':
    
    # python .\simulator\riscv32s.py .\compiler\code.bin +start=0 +pause
    assert len(sys.argv) > 2, '\n[Usage]: Python ./riscv32s ./file \n[Options]: +start= +pause +time= +dontclear +savelog'
    file = sys.argv[1]
    goto_runtime = 0
    dontclear = False
    branchcount = 0
    pause = False
    wait = 0
    finalsave = False
    for option in sys.argv[1:]:
        if option == '+pause':
            pause = True
        if option[:6] == '+time=':
            wait = float(option[6:])
        if option[:7] == '+start=':
            goto_runtime = float(option[7:])
        if option == '+dontclear':
            dontclear = True
        if option == '+savelog':
            finalsave = True

    # Load Instructions
    with open(file, 'r') as bin_file:
        bin_code = bin_file.read().split()
    
    # load prepared memory
    loadimg()

    runtime = 0
    last_op = ''
    savelog = False
    hide = False
    # Start programm
    while pc < len(bin_code):

        if bin_code[pc] == '':
            pc += 1
            continue

        # Execute
        inst_op, rd, rs1, rs2, immi, imms, immb, pc, branch = execute(bin_code[pc], pc)
        if inst_op in opcode[11:]:
            branchcount += 1
        if pc >= len(bin_code):
            exit('\n Error: PC: ' + str(pc) + ' > ProgramLength: ' + str(bin_code))
        runtime += 1
        x[0] = 0

        if not hide:
            # Display CPU state
            if not dontclear:
                print('\033c',end='') # clear screen
            show(savelog)
            print('\n [CPU Instruction Information]')
            print(' Program Counter (>>1):', pc)
            print(' Instruction:', bin_code[pc])
            print(' Operation:', inst_op)
            print(' Rd:       ', rd)
            print(' Rs1:      ', rs1)
            print(' Rs2:      ', rs2)
            print(' Imm[I]:   ', immi)
            print(' Imm[S]:   ', imms)
            print(' Imm[B]:   ', immb)
            print(' Run Time: ', runtime)
            print(' Branch Counter: ', branchcount)
            print(' Last Operation: ', last_op)
            last_op = inst_op
        else:
            print('\r Process: (', runtime, '/', goto_runtime, ')', end='')

        if runtime >= goto_runtime:
            if pause:
                key = input('\nPress Enter to continue or debug...\n')
                goto_runtime = runtime
                if key.lower() == 'q' or key.lower() == 'quit' or key.lower() == 'exit':
                    break
                if key.lower()[:1] == '+':
                    goto_runtime = runtime + int(key[1:].split()[0])
                    if 'hide' in key.lower():
                        hide = True
                    else:
                        hide = False
                if key.lower() == 'savelog':
                    savelog = True
                else:
                    savelog = False
            elif wait > 0:
                time.sleep(wait)
        
        if not branch:
            pc += 1

    # Exit programm
    print('\n[Simulation Finished]\n')

    if finalsave:
        k = 0
        logtext = '[Memory File]:\n|'
        for i in range(0, len(mem)):
            logtext += ' ' * (5-len(hex(i)[2:])) + hex(i)[2:].upper() + ':' + ' ' * (7 - len(str(mem[i]))) + str(mem[i]) + '|'
            k += 1
            if k == 16:
                k = 0
                logtext += '\n|'
        with open('mem.log', 'w') as memlog:
            memlog.write(logtext)
        print('[mem.log saved]\n')