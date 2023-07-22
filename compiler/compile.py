# --------------------------------------------------------------------------
# Using UTF-8
# Title: RISCV32 Instrcutions Compile Script
# Last Modified Date: 2023/7/22
# Version: 2.0
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


from collections import Counter

# parameters:
rtype = range(0,7)
itype = range(7,10)
stype = range(10,11)
btype = range(11,15)
opcode = [    'add',     'and',      'or',     'sll',     'sra',     'mul',    'mulh',    'addi',    'xori',      'lw',      'sw',     'beq',     'bne',     'blt',     'bge']
opbin  = ['0110011', '0110011', '0110011', '0110011', '0110011', '0110011', '0110011', '0010011', '0010011', '0000011', '0100011', '1100011', '1100011', '1100011', '1100011']
funct7 = ['0000000', '0000000', '0000000', '0000000', '0100000', '0000001', '0000001',        '',        '',        '',        '',        '',        '',        '',        '']
funct3 = [    '000',     '111',     '110',     '001',     '101',     '000',     '001',     '000',     '110',     '010',     '010',     '000',     '001',     '100',     '101']

# get integer's binary string
def getbin(value, line, size:int=12):
    value = int(value)
    sizelow = -(2 ** int(size))
    sizehigh = 2 ** (int(size)-1)
    assert value in range(sizelow, sizehigh), 'At line '+str(line)+' : Imm Value Overflow: Value not match given size.'
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

# if it is a 12-bit signed integer
def is_int12(string:str):
    if is_int(string):
        assert int(string) in range(-2**12, 2**12), 'ImmRangeError: '+string
        return True
    else:
        return False

# Verilog style trancation
def tranc(string:str, top:int, buttom:int=-1): 
    assert len(string.replace('1','').replace('0','')) == 0, 'Trancation error: tranc string is not binary.'
    assert top < len(string), 'Trancation error: top bit large than string size.'
    assert buttom < top and buttom >= -1, 'Trancation error: top bit less than buttom bit.'
    if buttom == -1:
        return string[-top-1]
    elif buttom != 0:
        return string[-top-1:-buttom]
    else:
        return string[-top-1:]

# address type
class address():
    bin_file_line = 0
    assem_file_line = 0
    def __init__(self,size:int) -> None:
        self.name_list = []
        self.value_list = []
        self.sizelow = -(2 ** int(size))
        self.sizehigh = 2 ** (int(size)-1)
        self.size = int(size)
    def new(self, name:str, value:int):
        if name[0] == 'x':
            if is_int(name[1:]):
                assert not (int(name[1:]) in range(0,31)), 'At line '+str(self.assem_file_line)+' : Variable name illegal.'
        self.name_list.append(name)
        self.value_list.append(int(value))
    def bin(self, value:int):
        return getbin(value, self.assem_file_line, self.size)
    def search(self, name:str):
        assert name in self.name_list, 'At line '+str(self.assem_file_line)+' : Variable name not defined.'
        return self.value_list[self.name_list.index(name)]
    def get(self, name:str, debug=False): # get imm for address offset for branch less than
        addr = self.search(name)
        value = (addr - self.bin_file_line) << 1
        if debug:
            print('offset:', value, 'name:', name, 'address:', addr, 'this line:', self.bin_file_line) # Debug
        return self.bin(value)

# Compile the assembly code. Important base function
def compile(file:str, debug=False):

    # from string get imm value
    def get_imm(string:str):
        if is_int(string):
            return getbin(string, assem_file_line)
        elif string[:2] == '0b':
            immstring = string[:2]
            return '0' * (12 - len(immstring)) + immstring
        elif string[:2] == '0x':
            immstring = bin(int(string[2:], 16))[2:]
            return '0' * (12 - len(immstring)) + immstring
        
    def reg(string):
        assert string[0] == 'x', 'At line '+str(assem_file_line)+' : Register name illegal: ' + string
        assert is_int(string[1:]), 'At line '+str(assem_file_line)+' : Register name illegal: ' + string
        id = int(string[1:])
        assert id in range(0,32), 'At line '+str(assem_file_line)+' : Register ID out of range: ' + string
        return '0'*(5-len(bin(id)[2:])) + bin(id)[2:]

    addr12 = address(12)
    machine_code = ''
    assem_file_line = 0
    bin_file_line = 0

    assembly_code = file.split('\n')
    # explain address macros
    for lines in assembly_code:
        if lines == '':
            assem_file_line += 1
            continue
        line = lines.split()
        assem_file_line += 1
        addr12.assem_file_line = assem_file_line
        if len(line) != 0:
            if line[0] in opcode:
                assert len(line) > 3, 'At line '+str(assem_file_line)+' : Expect 4 statement.'
                bin_file_line += 1
                addr12.bin_file_line = bin_file_line
            # is 'goto' address macro
            elif line[0][-1] == ':':
                assert line[0][:-1] != '', 'At line '+str(assem_file_line)+' : address name empty.'
                addr12.new(line[0][:-1],(bin_file_line))
    
    # compile file
    assem_file_line = 0
    bin_file_line = 0
    for lines in assembly_code:
        while '//' in lines:
            lines = lines.split('//')[0]
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
                addr12.bin_file_line = bin_file_line
                addr12.assem_file_line = assem_file_line

    if debug:
        print('\n--------------------------------------')
        print('\nDefined Addr12:\n', addr12.name_list, '\n', addr12.value_list)
    
    return machine_code

# register file
class regfile():

    def __init__(self, size:int=32):
        self.data = [0] * 32
        self.busy = [False] * 32
        self.access = [0] * 32
        self.release = [''] * 32
        self.history = [[0] * 10] * 32
        self.size = [size] * 32
        self.readonly = [False] * 32
    
    def reset(self):
        self.data = [0] * 32
        self.busy = [False] * 32
        self.access = [0] * 32
        self.release = [''] * 32
        self.history = [[0 for i in range(10)] for j in range(32)]

    def use(self, id, releasemark:str):
        assert self.readonly[id] == False, '\n Access Denied: Register Read Only.'
        self.busy[id] = True
        self.release[id] = releasemark
    
    def free(self, id, releasemark:str, force=False):
        assert self.readonly[id] == False, '\n Access Denied: Register Read Only.'
        if self.release[id] == releasemark:
            self.busy[id] = False
        elif force == True:
            self.busy[id] = False
    
    def write(self, id, data:int):
        assert data in range(-2**(self.size[id]-1), 2**(self.size[id]-1)), '\n Data Invaild: Data of range.'
        assert self.readonly[id] == False, '\n Access Denied: Register Read Only.'
        self.data[id] = data
        self.history[id].pop(0)
        self.history[id].append(data)
        self.access[id] += 1
    
    def read(self, id):
        return self.data[id]

# riscv core
class core():

    def __init__(self, size:int=32, clock:int=1e9):
        self.x = regfile(size)
        self.clock = clock
        self.opcode = [    'add',     'and',      'or',     'sll',     'sra',     'mul',    'mulh',    'addi',    'xori',      'lw',      'sw',     'beq',     'bne',     'blt',     'bge']
        self.opbin  = ['0110011', '0110011', '0110011', '0110011', '0110011', '0110011', '0110011', '0010011', '0010011', '0000011', '0100011', '1100011', '1100011', '1100011', '1100011']
        self.funct7 = ['0000000', '0000000', '0000000', '0000000', '0100000', '0000001', '0000001',        '',        '',        '',        '',        '',        '',        '',        '']
        self.funct3 = [    '000',     '111',     '110',     '001',     '101',     '000',     '001',     '000',     '110',     '010',     '010',     '000',     '001',     '100',     '101']
        self.x.readonly[0] = True

    def request(self, releasemark:str):
        id = 31
        best = 31
        minaccess = None
        while id != 1:
            if self.x.busy[id] == False:
                best = id
                minaccess = self.x.access[id]
                break
            id -= 1
        if minaccess == None:
            return None
        id = 31
        while id != 1:
            if (not self.x.busy[id]) and (minaccess > self.x.access[id]):
                best = id
                minaccess = self.x.access[id]
            id -= 1
        self.x.use(best, releasemark)
        return best

    def free(self, releasemark, force=False):
        id = 31
        while id != 1:
            self.x.free(id, releasemark, force)
            id -= 1
        return
    
    def frequse(self, withcount=False):
        # max length: 
        pastvalue = []
        for id in range(0,32):
            for pastid in range(0,10):
                value = self.x.history[id][pastid]
                if value != 0:
                    pastvalue.append(value)
        pastvalue = Counter(pastvalue)
        pastvalue = sorted(pastvalue.items(), key=lambda x: x[1], reverse=True)
        if withcount:
            return pastvalue
        past = []
        for value in pastvalue:
            past.append(value[0])
        return past
        
# Simulated riscv core for code optimization
riscv = core(32, 50e6)

# translation of simple arithmetic opertation macro:
def macro2assem(line:str):
    opcode = [['add','and','or','sll','sra','mul','mulh'], ['addi','xori', 'lw'], [ 'sw'], ['beq','bne','blt','bge']]
    opsign = [[  '+',  '&', '|', '<<', '>>',  '*l','*h'], [   '+',   '^','mem'], ['mem'], [ '==', '!=',  '<', '>=']]
    comment = ''
    if len(line.split('//')) > 1:
        comment = '//' + line.split('//')[1]
    macro = line.replace(' ', '')
    while '//' in macro:
        macro = macro.split('//')[0]
    for op in opsign[0]:
        if op in macro and not ('mem' in macro):
            rd = macro.split('=')[0]
            rs2 = macro.split(op)[1]
            rs1 = macro.split('=')[1].split(op)[0]
            if is_int12(rs1) or is_int12(rs2):
                break
            op = opcode[0][opsign[0].index(op)]
            return op + ' ' + rs2 + ' ' + rs1 + ' ' + rd + comment + '\n'
    for op in opsign[1]:
        if op in macro:
            rd = macro.split('=')[0]
            if 'mem' in macro:
                if macro.split('mem')[0] == '':
                    break
                op = 'mem'
                rs1 = macro.split('[')[1].split('+')[0]
                rs2 = macro.split('+')[1].split(']')[0]
            else:
                rs1 = macro.split('=')[1].split(op)[0]
                rs2 = macro.split(op)[1]
            if is_int12(rs1):
                imm = rs1
                rs1 = rs2
            else:
                imm = rs2
            op = opcode[1][opsign[1].index(op)]
            return op + ' ' + imm + ' ' + rs1 + ' ' + rd + comment + '\n'
    for op in opsign[2]:
        if op in macro:
            # memory style: mem[x1 + 90] = x1 
            rs2 = macro.split('=')[1]
            rs11 = macro.split('[')[1].split('+')[0]
            rs12 = macro.split('+')[1].split(']')[0]
            if is_int12(rs11):
                imm = rs11
                rs1 = rs12
            else:
                imm = rs12
                rs1 = rs11
            op = opcode[2][opsign[2].index(op)]
            return op + ' ' + rs2 + ' ' + rs1 + ' ' + imm + comment + '\n'
    for op in opsign[3]:
        if op in macro:
            # branch style: rs1 < rs2 goto linemark
            linemark = macro.split('goto')[1]
            rs1 = macro.split(op)[0]
            rs2 = macro.split(op)[1].split('goto')[0]
            op = opcode[3][opsign[3].index(op)]
            return op + ' ' + rs2 + ' ' + rs1 + ' ' + linemark + comment + '\n'
    return line.lstrip() + '\n'

# translate the macros into assembly code:
def demacro(file:str):
    newfile = ''
    file = file.split('\n')
    for line in file:
        # line.strip()
        if line == '':
            newfile += '\n'
            continue
        newfile += macro2assem(line)
    return newfile

# if to macro:
def if2macro(text:str):
    file = text.split('\n')
    # if style: if x1 > x2,  ...  endif
    iftotal = 0
    endiftotal = 0
    iflevel = []
    endlevel = []
    for line in file:
        if line == '':
            continue
        if line.split()[0] == 'if':
            iflevel.append(iftotal - endiftotal)
            iftotal += 1
        if line.split()[0] == 'endif':
            endiftotal += 1
            endlevel.append(iftotal - endiftotal)
    assert endiftotal == iftotal
    if iftotal == 0:
        return text
    ifcounter = [0] * (max(iflevel) + 1)
    endcounter = [0] * (max(endlevel) + 1)
    ifmark = []
    endmark = []
    for i in iflevel:
        ifmark.append('endifmark' + str(i) + '_' + str(ifcounter[i]))
        ifcounter[i] += 1
    for i in endlevel:
        endmark.append('endifmark' + str(i) + '_' + str(endcounter[i]))
        endcounter[i] += 1
    text = ''
    if_id = 0
    end_id = 0
    line_id = 0
    for line in file:
        if line == '':
            text += '\n'
            continue
        if line.split()[0] == 'if':
            line = line.replace('if ', '', 1)
            if '<' in line:
                line = line.replace('<','>=', 1)
            elif '>=' in line:
                line = line.replace('>=','<', 1)
            elif '==' in line:
                line = line.replace('==','!=', 1)
            elif '!=' in line:
                line = line.replace('!=','==', 1)
            else:
                raise [AssertionError ['if statement error: line ' + str(line_id)]]
            line = line.replace(',', ' goto ' + ifmark[if_id], 1)
            assert 'goto' in line, 'if statement error: line ' + str(line_id) + '. need ,'
            if_id += 1
        if line.split()[0] == 'endif':
            line = line.replace('endif', endmark[end_id] + ':', 1)
            end_id += 1
        text += line + '\n'
        line_id += 1
    return text

# while to macro:
def while2macro(text:str):
    file = text.split('\n')
    headtotal = 0
    endtotal = 0
    headlevel = []
    endlevel = []
    for line in file:
        if line == '':
            continue
        if line.split()[0] == 'while':
            headlevel.append(headtotal - endtotal)
            headtotal += 1
        if line.split()[0] == 'endwhile':
            endtotal += 1
            endlevel.append(headtotal - endtotal)
    assert endtotal == headtotal
    if headtotal == 0:
        return text
    headcounter = [0] * (max(headlevel) + 1)
    endcounter = [0] * (max(endlevel) + 1)
    headmark = []
    endmark = []
    for i in headlevel:
        headmark.append('whilemark' + str(i) + '_' + str(headcounter[i]))
        headcounter[i] += 1
    for i in endlevel:
        endmark.append('whilemark' + str(i) + '_' + str(endcounter[i]))
        endcounter[i] += 1
    text = ''
    head_id = 0
    end_id = 0
    line_id = 0
    for line in file:
        if line == '':
            text += '\n'
            continue
        if line.split()[0] == 'while':
            line = line.replace('while ', '', 1)
            if '<' in line:
                line = line.replace('<','>=', 1)
            elif '>=' in line:
                line = line.replace('>=','<', 1)
            elif '==' in line:
                line = line.replace('==','!=', 1)
            elif '!=' in line:
                line = line.replace('!=','==', 1)
            else:
                raise [AssertionError ['while statement error: line ' + str(line_id)]]
            line = line.replace(',', ' goto end' + headmark[head_id], 1)
            line = 'start' + headmark[head_id] + ':\n' + line
            assert 'goto' in line, 'while statement error: line ' + str(line_id) + '. need ,'
            head_id += 1
        if line.split()[0] == 'endwhile':
            line = line.replace('endwhile', 'end' + endmark[end_id] + ':', 1)
            line = 'x0 == x0 goto start' + endmark[end_id] + '\n' + line
            end_id += 1
        text += line + '\n'
        line_id += 1
    return text

# long int to macro (less than 32 bit, over than 12 bit signed int)
def int2macro(line:str, dontremove=False):
    
    # search for a springboard in registers
    def springboard(sregd, imm):
        id = 0
        while id != 32:
            value = riscv.x.data[id]
            if imm + value in range(-2**11, 2**11):
                sreg = 'x' + str(id)
                simm = str(imm + value)
                return sregd + ' = ' + sreg + ' + ' + simm + '\n'
            elif imm - value in range(-2**11, 2**11):
                sreg = 'x' + str(id)
                simm = str(imm - value)
                return sregd + ' = ' + sreg + ' + ' + simm + '\n'
            id += 1
        return None
    
    # search for a register not in use:
    def xidle():
        id = riscv.request('int2macro')
        assert id != None, 'registers are all in the use'
        return 'x' + str(id)

    # macro input style: x1 = 9999
    statement = line.split('//')[0].split()
    if len(statement) == 3:
        if statement[0][0] == 'x' and statement[1] == '=' and is_int(statement[2]):
            sregd = statement[0]
            imm = int(statement[2])
            assert imm in range(-2**31, 2**31), 'Error: signed value given over than 32 bit.'
            if imm == riscv.x.data[int(sregd[1:])] and not dontremove:
                return '// removed\n'
            text = springboard(sregd, imm)
            if text != None:
                riscv.x.write(int(sregd[1:]), imm)
                return text
            else:
                text = ''
                if imm in range(-2**22, 2**22):
                    sreg0 = xidle()
                    sreg1 = xidle()
                    # int signed 22-11 bit
                    simm0 = str(imm & (2**11-1)) + ' '
                    simm1 = str(imm >> 11) + ' '
                    # put signed 22-11 bit
                    if springboard(sreg1, (imm & (-1 ^ (2**11-1)))) != None:
                        text += springboard(sreg1, (imm & (-1 ^ (2**11-1))))
                    else:
                        text += sreg1 + ' = x0 + ' + simm1 + '\n'
                        text += sreg0 + ' = x0 + 11 \n'
                        text += sreg1 + ' = ' + sreg1 + ' << ' + sreg0 + '\n'
                    # put unsigned 11-0 bit and connect 
                    text += sreg0 + ' = x0 + ' + simm0 + '\n'
                    text += sregd + ' = ' + sreg1 + ' | ' + sreg0 + '\n'
                else:
                    sreg0 = xidle()
                    sreg1 = xidle()
                    sreg2 = xidle()
                    simm0 = str(imm & (2**11-1)) + ' '
                    simm1 = str((imm >> 11) & (2**11-1)) + ' '
                    simm2 = str(imm >> 22) + ' '
                    # put signed 32-22 bit
                    if springboard(sreg2, (imm & (-1 ^ (2**22-1)))) != None:
                        text += springboard(sreg2, (imm & (-1 ^ (2**22-1))))
                    else:
                        text += sreg0 + ' = x0 + 22 \n'
                        text += sreg2 + ' = x0 + ' + simm2 + '\n'
                        text += sreg2 + ' = ' + sreg2 + ' << ' + sreg0 + '\n'
                    # put unsigned 21-11 bit and connect 
                    if springboard(sreg1, (imm & (-1 ^ (2**11-1)))) != None:
                        text += springboard(sreg1, (imm & (-1 ^ (2**11-1))))
                    else:
                        text += sreg0 + ' = x0 + 11 \n'
                        text += sreg1 + ' = x0 + ' + simm1 + '\n'
                        text += sreg1 + ' = ' + sreg1 + ' << ' + sreg0 + '\n'
                    text += sreg2 + ' = ' + sreg1 + ' | ' + sreg2 + '\n'
                    # put unsigned 11-0 bit and connect 
                    text += sreg0 + ' = x0 + ' + simm0 + '\n'
                    text += sregd + ' = ' + sreg0 + ' | ' + sreg2 + '\n'
                riscv.free('int2macro')
                riscv.x.write(int(sregd[1:]), imm)
                return text

    return line

# beta function: generate memory, this only works with define area
# before enter the define area, free all the registers
def genmem2macro(file:str, comment=False):
    
    def storeworthy(value:int, id:int):
        if value in riscv.frequse()[:16]:
            return True
        i = 31
        while i != 0:
            if i != id:
                data = riscv.x.data[i]
                if (value - data) in range(-2**11, 2**11) or (value + data) in range(-2**11, 2**11):
                    return False
            i -= 1
        return True
    
    def sortbyvalue(defines:list):
        id = 1
        text = ''
        defines = sorted(defines)
        for i in range(0, len(defines)):
            data, addr = defines[i]
            if comment:
                com = ' // mem[' +str(addr)+ '] = ' + str(data)
            else:
                com = ''
            if data in riscv.x.data:
                text += 'mem[x0 + ' + str(addr) + '] = x' + str(riscv.x.data.index(data)) + com + '\n'
            else:
                infor = 'x' + str(id) + ' = ' + str(data)
                text += int2macro(infor)
                text += 'mem[x0 + ' + str(addr) + '] = x' + str(id) + com +'\n'
                if storeworthy(data, id):
                    if id < 29:
                        id += 1
                    else:
                        id = 1
        return text

    # define area style: define ... endefine
    # in define area: address <- data
    linefile = file.split('\n')
    entered = False
    newfile = ''
    defines = []
    for line in linefile:
        if line == '':
            newfile += '\n'
            continue
        if line.split()[0] == 'define' or line.split()[0] == 'endefine':
            if entered == True:
                newfile += sortbyvalue(defines)
                defines = []
            entered = not entered
            continue
        if entered:
            line = line.split()
            addr = int(line[0])
            data = int(line[2])
            assert line[1] == '<-'
            defines.append((data,addr))
        else:
            newfile += line + '\n'
    return newfile

# beta function: save a long int into register:
# DANGER: it occupies x29~x31
def long2macro(file:str):
    linefile = file.split('\n')
    text = ''
    for line in linefile:
        if line == '':
            text += '\n'
            continue
        riscv.x.reset()
        text += int2macro(line + '\n', True)
    return text

# binary file to verilog memory code
def bin2mem(binfile:str, mem=True):
    binfile = binfile.split('\n')
    lineindex = 0
    maxlineindex = len(binfile)
    addresswidth = len(str(maxlineindex))
    newfiletext = ''
    for line in binfile:
        if line == '':
            continue
        line = hex(int(line, 2))[2:]
        line = '0'*(8-len(line)) + line
        if mem:
            line = 'assign memory[' + ' ' * (addresswidth - len(str(lineindex))) + str(lineindex) + "] = 32'h" + line.upper() + ';'
        else:
            line = ' ' * (4-len(hex(lineindex << 2)[2:])) + hex(lineindex << 2)[2:].upper() + ' : ' + line.upper()
        newfiletext += line + '\n'
        lineindex += 1
        
    return newfiletext

# locate the file code with pc
def locate_file(defile:str, pc:int):
    defile = defile.split('\n')
    defile.pop()
    fileline = 0
    truecode = 0
    for i in range(0,len(defile)):
        if defile[i] == '':
            fileline += 1
            continue
        else:
            line = defile[i].split()
            if '//' in line[0]:
                fileline += 1
                continue
            elif line[0][-1] == ':':
                fileline += 1
                continue
            else:
                fileline += 1
                truecode += 1
                if truecode >= pc:
                    if pc == 0:
                        fileline -= 1
                    break
    return fileline

# locate the pc with file code
def locate_pc(defile:str, codeline:int):
    defile = defile.split('\n')
    defile.pop()
    fileline = 0
    pc = 0
    for i in range(0,len(defile)):
        if defile[i] == '':
            fileline += 1
        else:
            line = defile[i].split()
            if '//' in line[0]:
                fileline += 1
            elif line[0][-1] == ':':
                fileline += 1
            else:
                fileline += 1
                pc += 1
        if fileline >= codeline:
            break
    return pc
