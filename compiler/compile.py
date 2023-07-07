# --------------------------------------------------------------------------
# Using UTF-8
# Title: RISCV32 Instrcutions Compile Script
# Last Modified Date: 2023/7/6
# Version: 1.0
# Author: Clark Pu
# --------------------------------------------------------------------------
#   add  rs2 rs1 rd        // add  rs2 + rs1 -> rd
#   and  rs2 rs1 rd        // add  rs2 & rs1 -> rd
#   or   rs2 rs1 rd        // or   rs2 | rs1 -> rd
#   mul  rs2 rs1 rd        // mul  (rs2 * rs1)[31: 0] -> rd 
#   mulh rs2 rs1 rd        // mulh (rs2 * rs1)[63:32] -> rd 
#   addi imm rs1 rd        // addi imm + rs1 -> rd
#   slli imm rs1 rd        // slli r1 << imm[4:0] -> rd
#   srli imm rs1 rd        // srli r1 >> imm[4:0] -> rd
#   xori imm rs1 rd        // xori imm ^ rs1 -> rd
#   lw   imm rs1 rd        // lw   mem(imm + rs1) -> rd
#   sw   rs2 rs1 imm       // sw   mem(imm + rs1) <- rs2
#   blt  rs2 rs1 pc_imm    // blt  pc <- ({pc_imm,0} + pc) if (rs1 < rs2)
# --------------------------------------------------------------------------


import sys


# global parameters:
opcode = [    'add',     'and',      'or',     'mul',    'mulh',    'addi',    'slli',    'srli',    'xori',      'lw',      'sw',     'blt']
opbin  = ['0110011', '0110011', '0110011', '0110011', '0110011', '0010011', '0010011', '0010011', '0010011', '0000011', '0100011', '1100011']
funct7 = ['0000000', '0000000', '0000000', '0000001', '0000001',        '',        '',        '',        '',        '',        '',        '']
funct3 = [    '000',     '111',     '110',     '000',     '001',     '000',     '001',     '101',     '110',     '010',     '010',     '100']
bin_file_line = 0
assem_file_line = 0
debug = False


# functions:
def reg(string):
    assert string[0] == 'x', 'At line '+str(assem_file_line)+' : Register name illegal.'
    id = int(string[1:])
    assert id in range(0,31), 'At line '+str(assem_file_line)+' : Register ID out of range.'
    return '0'*(5-len(bin(id)[2:])) + bin(id)[2:]

# get integer's binary string
def getbin(value, size:int=12):
    value = int(value)
    sizelow = -(2 ** int(size))
    sizehigh = 2 ** (int(size)-1)
    assert value in range(sizelow, sizehigh), 'Value not match given size.'
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
    def get(self, string:str): # get binary imm value. if it has offset, find offset value
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
    def get(self, name:str): # get imm for address offset for branch less than
        addr = self.search(name)
        value = addr - bin_file_line
        if debug:
            print('offset:', value, 'name:', name, 'address:', addr, 'this line:', bin_file_line) # Debug
        return self.bin(value)

# from string get imm value
def get_imm(string:str):
    if is_int(string):
        return getbin(string)
    elif string[:2] == '0b':
        return string[2:]
    else:
        return int12.get(string)

# Main:
if __name__ == '__main__':

    # Develop debug default file
    if len(sys.argv) < 2:
        file = './compiler/code.s'
        output_file = './compiler/code.bin'
        debug = True
    else:
        assert len(sys.argv) > 2, '[Usage]: Python ./compiler ./file \n[Options]: +debug +output:./file'
        file = sys.argv[1]
        output_file = './'+file.split('/')[-1].split('.')[0]+'.bin'
        for option in sys.argv[1:]:
            if option == '+debug':
                debug = True
            if option[:8] == '+output:':
                output_file = option[8:]
            
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
                    addr12.new(line[0][:-1],bin_file_line)

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
                    if line[0] in opcode[0:5]:
                        if debug:
                            print('\n--------------------------------------')
                        op_id = opcode.index(line[0])
                        line_bin = funct7[op_id] + reg(line[1]) + reg(line[2]) + funct3[op_id] + reg(line[3]) + opbin[op_id]
                        machine_code += line_bin + '\n'
                        if debug:
                            print(line, '\nCode:', line_bin) # Debug
                    # i type
                    elif line[0] in opcode[5:10]:
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
                        iimm = get_imm(line[3])
                        line_bin = tranc(imm,11,5) + reg(line[1]) + reg(line[2]) + funct3[op_id] + tranc(imm,4,0) + opbin[op_id]
                        machine_code += line_bin + '\n'
                        if debug:
                            print(line, '\nimm:', imm, '\nIMM:', tranc(imm,11,5), tranc(imm,4,0), '\nCode:', line_bin) # Debug
                    # b type
                    elif line[0] == opcode[11]:
                        if debug:
                            print('\n--------------------------------------')
                        op_id = opcode.index(line[0])
                        if is_int(line[3]):
                            imm = getbin(line[3]) + '0'
                        else:
                            imm = addr12.get(line[3]) + '0'
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
