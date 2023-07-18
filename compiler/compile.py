# --------------------------------------------------------------------------
# Using UTF-8
# Title: RISCV32 Instrcutions Compile Script
# Last Modified Date: 2023/7/6
# Version: 1.0
# Author: Clark Pu
# --------------------------------------------------------------------------

#                                   RISC-V 32 Subset
# +---------------------------------------------------------------------------------+
# |31           25|24     20|19     15|14     12|11           7|6       0|   code   |
# +---------------------------------------------------------------------------------+
# |    0000000    |   rs2   |   rs1   |   000   |      rd      | 0110011 | [R] add  |
# |    0000000    |   rs2   |   rs1   |   111   |      rd      | 0110011 | [R] and  |
# |    0000000    |   rs2   |   rs1   |   110   |      rd      | 0110011 | [R] or   |
# |    0000000    |   rs2   |   rs1   |   001   |      rd      | 0110011 | [R] sll  |
# |    0100000    |   rs2   |   rs1   |   101   |      rd      | 0110011 | [R] sra  |
# |    0000001    |   rs2   |   rs1   |   000   |      rd      | 0110011 | [R] mul  |
# |    0000001    |   rs2   |   rs1   |   001   |      rd      | 0110011 | [R] mulh |
# +---------------------------------------------------------------------------------+
# |        imm[11:0]        |   rs1   |   000   |      rd      | 0010011 | [I] addi |
# |        imm[11:0]        |   rs1   |   110   |      rd      | 0010011 | [I] xori |
# |        imm[11:0]        |   rs1   |   010   |      rd      | 0000011 | [I] lw   |
# +---------------------------------------------------------------------------------+
# |    imm[11:5]  |   rs2   |   rs1   |   010   |   imm[4:0]   | 0100011 | [S] sw   |
# +---------------------------------------------------------------------------------+
# |  imm[12|10:5] |   rs2   |   rs1   |   000   |  imm[4:1|11] | 1100011 | [B] beq  |
# |  imm[12|10:5] |   rs2   |   rs1   |   001   |  imm[4:1|11] | 1100011 | [B] bne  |
# |  imm[12|10:5] |   rs2   |   rs1   |   100   |  imm[4:1|11] | 1100011 | [B] blt  |
# |  imm[12|10:5] |   rs2   |   rs1   |   101   |  imm[4:1|11] | 1100011 | [B] bge  |
# +---------------------------------------------------------------------------------+

#   R  rs2 rs1 rd     
#   I  imm rs1 rd     
#   S  rs2 rs1 imm
#   B  rs2 rs1 pc_imm 

# parameters:
opcode = [    'add',     'and',      'or',     'sll',     'sra',     'mul',    'mulh',    'addi',    'xori',      'lw',      'sw',     'beq',     'bne',     'blt',     'bge']
opbin  = ['0110011', '0110011', '0110011', '0110011', '0110011', '0110011', '0110011', '0010011', '0010011', '0000011', '0100011', '1100011', '1100011', '1100011', '1100011']
funct7 = ['0000000', '0000000', '0000000', '0000000', '0100000', '0000001', '0000001',        '',        '',        '',        '',        '',        '',        '',        '']
funct3 = [    '000',     '111',     '110',     '001',     '101',     '000',     '001',     '000',     '110',     '010',     '010',     '000',     '001',     '100',     '101']

global bin_file_line, assem_file_line, debug
bin_file_line = 0
assem_file_line = 0
debug = False

# functions:
def reg(string):
    assert string[0] == 'x', 'At line '+str(assem_file_line)+' : Register name illegal.'
    id = int(string[1:])
    assert id in range(0,32), 'At line '+str(assem_file_line)+' : Register ID out of range.'
    return '0'*(5-len(bin(id)[2:])) + bin(id)[2:]

# get integer's binary string
def getbin(value, size:int=12):
    value = int(value)
    sizelow = -(2 ** int(size))
    sizehigh = 2 ** (int(size)-1)
    assert value in range(sizelow, sizehigh), 'At line '+str(assem_file_line)+' : Imm Value Overflow: Value not match given size.'
    if value < 0:
        value_bin = bin(value+1)[3:].replace('0','x').replace('1','0').replace('x','1')
        value_bin = '1'*(size-len(value_bin)) + value_bin
    else:
        value_bin = bin(value)[2:]
        value_bin = '0'*(size-len(value_bin)) + value_bin
    return value_bin

# if it is a integer
def is_int(string:str):
    try:
        int(string)
        return True
    except ValueError:
        pass
    return False

# Verilog style trancation
def tranc(string:str, top:int, buttom:int=-1): 
    assert len(string.replace('1','').replace('0','')) == 0, 'Compiler error: tranc string is not binary.'
    assert top < len(string), 'Compiler error: top bit large than string size.'
    assert buttom < top and buttom >= -1, 'Compiler error: top bit less than buttom bit.'
    if buttom == -1:
        return string[-top-1]
    elif buttom != 0:
        return string[-top-1:-buttom]
    else:
        return string[-top-1:]

# variable type
class var():
    def __init__(self,size:int) -> None:
        self.name_list = []
        self.value_list = []
        self.sizelow = -(2 ** int(size))
        self.sizehigh = 2 ** (int(size)-1)
        self.size = int(size)
    def new(self, name:str, value:int):
        if name[0] == 'x':
            if is_int(name[1:]):
                assert not (int(name[1:]) in range(0,31)), 'At line '+str(assem_file_line)+' : Variable name illegal.'
        self.name_list.append(name)
        self.value_list.append(int(value))
    def bin(self, value:int):
        return getbin(value, self.size)
    def search(self, name:str):
        assert name in self.name_list, 'At line '+str(assem_file_line)+' : Variable name not defined.'
        return self.value_list[self.name_list.index(name)]

# integer type
class integer(var):
    type = 'int'
    def get(self, string:str, debug=False): # get binary imm value. if it has offset, find offset value
        if len(string.split('[')) == 1:
            return self.bin(self.search(string))
        else:
            assert string.count('[') == 1 and string.count(']') == 1, 'At line '+str(assem_file_line)+' : Imm Variable statement error'
            name = string.split('[')[0]
            base = self.search(name)
            offset = int(string.split('[')[1].split(']')[0])
            if debug:
                print('offset:', offset, 'name:', name, 'base:', base, 'this line:', bin_file_line) # Debug
            return self.bin(base + offset)

# address type
class address(var):
    type = 'addr'
    def get(self, name:str, debug=False): # get imm for address offset for branch less than
        addr = self.search(name)
        value = (addr - bin_file_line) << 1
        if debug:
            print('offset:', value, 'name:', name, 'address:', addr, 'this line:', bin_file_line) # Debug
        return self.bin(value)

# compile the assembly code
def compile(file:str, output_file=None, debug=False):
    global bin_file_line, assem_file_line
    if output_file == None:
        output_file = file
    
    # from string get imm value
    def get_imm(string:str):
        if is_int(string):
            return getbin(string)
        elif string[:2] == '0b':
            immstring = string[:2]
            return '0' * (12 - len(immstring)) + immstring
        elif string[:2] == '0x':
            immstring = bin(int(string[2:], 16))[2:]
            return '0' * (12 - len(immstring)) + immstring
        else:
            return int12.get(string, debug)

    # initiate
    int12 = integer(12)
    addr12 = address(12)
    machine_code = ''
    assem_file_line = 0
    bin_file_line = 0

    # read file
    with open(file, 'r') as assembly_file:
        assembly_code = assembly_file.readlines()
        # explain macros
        for lines in assembly_code:
            line = lines.split()
            assem_file_line += 1
            if len(line) != 0:
                if line[0] in opcode:
                    assert len(line) > 3, 'At line '+str(assem_file_line)+' : Expect 4 statement.'
                    bin_file_line += 1

                # is int macro
                elif line[0] == 'int':
                    assert is_int(line[2]), 'At line '+str(assem_file_line)+' : Not an integer'
                    assert int(line[2]) in range(-2048, 2047), 'At line '+str(assem_file_line)+' : Out of imm range.'
                    int12.new(line[1],line[2])

                # is 'goto' macro
                elif line[0][-1] == ':':
                    assert line[0][:-1] != '', 'At line '+str(assem_file_line)+' : address name empty.'
                    addr12.new(line[0][:-1],(bin_file_line))

        # compile file
        assem_file_line = 0
        bin_file_line = 0
        for lines in assembly_code:
            line = lines.split()
            assem_file_line += 1
            if len(line) != 0:
                # is opcode
                if line[0] in opcode:
                    # r type
                    if line[0] in opcode[0:7]:
                        if debug:
                            print('\n--------------------------------------')
                        op_id = opcode.index(line[0])
                        line_bin = funct7[op_id] + reg(line[1]) + reg(line[2]) + funct3[op_id] + reg(line[3]) + opbin[op_id]
                        machine_code += line_bin + '\n'
                        if debug:
                            print(line, '\nCode:', line_bin) # Debug
                    # i type
                    elif line[0] in opcode[7:10]:
                        if debug:
                            print('\n--------------------------------------')
                        op_id = opcode.index(line[0])
                        imm = get_imm(line[1])
                        line_bin = imm + reg(line[2]) + funct3[op_id] + reg(line[3]) + opbin[op_id]
                        machine_code += line_bin + '\n'
                        if debug:
                            print(line, '\nimm:', imm, '\nCode:', line_bin) # Debug
                    # s type
                    elif line[0] == opcode[10]:
                        if debug:
                            print('\n--------------------------------------')
                        op_id = opcode.index(line[0])
                        imm = get_imm(line[3])
                        line_bin = tranc(imm,11,5) + reg(line[1]) + reg(line[2]) + funct3[op_id] + tranc(imm,4,0) + opbin[op_id]
                        machine_code += line_bin + '\n'
                        if debug:
                            print(line, '\nimm:', imm, '\nIMM:', tranc(imm,11,5), tranc(imm,4,0), '\nCode:', line_bin) # Debug
                    # b type
                    elif line[0] in opcode[11:]:
                        if debug:
                            print('\n--------------------------------------')
                        op_id = opcode.index(line[0])
                        if is_int(line[3]):
                            imm = getbin(line[3]) + '0'
                        else:
                            imm = addr12.get(line[3], debug) + '0'
                        line_bin = tranc(imm,12) + tranc(imm,10,5) + reg(line[1]) + reg(line[2]) + funct3[op_id] + tranc(imm,4,1) + tranc(imm,11) + opbin[op_id]
                        machine_code += line_bin + '\n'
                        if debug:
                            print(line, '\nimm:', imm, '\nIMM:', tranc(imm,12), tranc(imm,10,5), tranc(imm,4,1), tranc(imm,11), '\nCode:', line_bin) # Debug
                    
                    bin_file_line += 1
    
    if debug:
        print('\n--------------------------------------')
        print('\nDefined  Int12:\n',int12.name_list, '\n', int12.value_list)
        print('\nDefined Addr12:\n', addr12.name_list, '\n', addr12.value_list)
    
    with open(output_file, 'w') as binfile:
        binfile.write(machine_code)
    print('\n[           Total Instructions:]', bin_file_line)
    print('[Binary Machine Code Generated:]', output_file, '\n')
