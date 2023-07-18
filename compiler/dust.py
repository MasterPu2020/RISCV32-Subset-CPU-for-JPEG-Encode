# --------------------------------------------------------------------------
# Using UTF-8
# Title: Dust - an assembly code generator
# Last Modified Date: 2023/7/8
# Version: 1.0
# Author: Clark Pu
# --------------------------------------------------------------------------

import compile
import sys
import os
from collections import Counter

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

# if it is a 12-bit signed integer
def is_int12(string:str):
    if compile.is_int(string):
        assert int(string) in range(-2**12, 2**12), 'ImmRangeError: '+string
        return True
    else:
        return False

# translation of simple arithmetic opertation macro:
def macro2assem(line:str, comment=False):
    opcode = [['add','and','or','sll','sra','mul','mulh'], ['addi','xori', 'lw'], [ 'sw'], ['beq','bne','blt','bge']]
    opsign = [[  '+',  '&', '|', '<<', '>>',  '*l','*h'], [   '+',   '^','mem'], ['mem'], [ '==', '!=',  '<', '>=']]
    macro = line.replace(' ', '').replace('\n', '')
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
            if comment:
                return op + ' ' + rs2 + ' ' + rs1 + ' ' + rd + ' // ' + line.replace('\n', '') + '\n'
            else:
                return op + ' ' + rs2 + ' ' + rs1 + ' ' + rd + '\n'
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
            if comment:
                return op + ' ' + imm + ' ' + rs1 + ' ' + rd + ' // ' + line.replace('\n', '') + '\n'
            else:
                return op + ' ' + imm + ' ' + rs1 + ' ' + rd + '\n'
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
            if comment:
                return op + ' ' + rs2 + ' ' + rs1 + ' ' + imm + ' // ' + line.replace('\n', '') + '\n'
            else:
                return op + ' ' + rs2 + ' ' + rs1 + ' ' + imm + '\n'
    for op in opsign[3]:
        if op in macro:
            # branch style: rs1 < rs2 goto linemark
            assert 'goto' in macro, '\n Epression missing:' + macro
            linemark = macro.split('goto')[1]
            rs1 = macro.split(op)[0]
            rs2 = macro.split(op)[1].split('goto')[0]
            op = opcode[3][opsign[3].index(op)]
            if comment:
                return op + ' ' + rs2 + ' ' + rs1 + ' ' + linemark + ' // ' + line.replace('\n', '') + '\n'
            else:
                return op + ' ' + rs2 + ' ' + rs1 + ' ' + linemark + '\n'
    return line + '\n'

# remove empty lines, spaces
def remove_empty(file:str):
    file = file.split('\n')
    m = ''
    for i in file:
        if len(i.split()) == 0:
            continue
        m += i + '\n'
    m = m[:-1]
    return m

# translate the macros into assembly code:
def demacro(file:str, comment=False):
    newfile = ''
    file = file.split('\n')
    for line in file:
        line.strip()
        newfile += macro2assem(line, comment)
    return newfile

# if to macro:
def if2macro(oldfile:str):
    file = remove_empty(oldfile).split('\n')
    # if style: if x1 > x2,  ...  endif
    iftotal = 0
    endiftotal = 0
    iflevel = []
    endlevel = []
    for line in file:
        if line.split()[0] == 'if':
            iflevel.append(iftotal - endiftotal)
            iftotal += 1
        if line.split()[0] == 'endif':
            endiftotal += 1
            endlevel.append(iftotal - endiftotal)
    assert endiftotal == iftotal
    if iftotal == 0:
        return oldfile
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
                raise 'if statement error: line ' + str(line_id)
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
def while2macro(oldfile:str):
    file = remove_empty(oldfile).split('\n')
    headtotal = 0
    endtotal = 0
    headlevel = []
    endlevel = []
    for line in file:
        if line.split()[0] == 'while':
            headlevel.append(headtotal - endtotal)
            headtotal += 1
        if line.split()[0] == 'endwhile':
            endtotal += 1
            endlevel.append(headtotal - endtotal)
    assert endtotal == headtotal
    if headtotal == 0:
        return oldfile
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
                raise 'while statement error: line ' + str(line_id)
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
        if statement[0][0] == 'x' and statement[1] == '=' and compile.is_int(statement[2]):
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
    linefile = remove_empty(file).split('\n')
    entered = False
    newfile = ''
    defines = []
    for line in linefile:
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
# DANGER: it does not know what register has been used
def long2macro(file:str):
    linefile = remove_empty(file).split('\n')
    text = ''
    for line in linefile:
        riscv.x.reset()
        text += int2macro(line + '\n', True)
    return text

# beta function: allocation of pc in assembly code file
def allocate(file:str, pc:int):
    file = genmem2macro(file)
    file = long2macro(file)
    file = if2macro(file)
    file = while2macro(file)
    file = demacro(file)
    assemindex = 0
    pcindex = -1
    file = file.split('\n')
    for line in file:
        if line.split()[0] != '//' and line.split()[0][-1] != ':':
            pcindex += 1
        assemindex += 1
        if pcindex == pc:
            return assemindex

# Main:
if __name__ == '__main__':

    confirm = 'y'
    if len(sys.argv) <= 1: 
        print('\n [Usage]: python  dust.py  filepath  (newfilepath)  +debug  +comment')
        confirm = 'n'
    else:
        filepath = sys.argv[1]
        if not os.path.exists(filepath):
            print('\n Input file not exists. \n')
            confirm = 'n'

        newfilepath = None
        try:
            newfilepath = sys.argv[2]
        except:
            ValueError
            pass
        if newfilepath == None or newfilepath[0] == '+':
            newfilepath = filepath.split('.s')[0] + '.bin'
        if os.path.exists(newfilepath) and confirm == 'y':
            confirm = input('\n Output file already exists. Overwirte? [y/n]:\n Enter: ')

    debug = False
    comment = False
    for option in sys.argv:
        if option == '+debug':
            debug = True
        if option == '+comment':
            comment = True

    # start here
    if confirm == 'y':
        with open(filepath, 'r') as thisfile:
            thisfile = thisfile.read()
        print('\n converting denfine to macro ...', end='')
        thisfile = genmem2macro(thisfile, comment)

        if debug:
            print(thisfile + '\n\n')
            with open(newfilepath, 'w') as thisnewfile:
                thisnewfile.write(thisfile)
        print('\r converting long int to macro ...', end='')
        thisfile = long2macro(thisfile)

        if debug:
            print(thisfile + '\n\n')
            with open(newfilepath, 'w') as thisnewfile:
                thisnewfile.write(thisfile)
        print('\r converting if statement to macro ...', end='')
        thisfile = if2macro(thisfile)

        if debug:
            print(thisfile + '\n\n')
            with open(newfilepath, 'w') as thisnewfile:
                thisnewfile.write(thisfile)
        print('\r converting while statement to macro ...', end='')
        thisfile = while2macro(thisfile)

        if debug:
            with open(newfilepath, 'w') as thisnewfile:
                thisnewfile.write(thisfile)
            input('\r Pause Enter to Continue               ')
        print('\r converting macro into assembly code ...  ', end='')
        thisfile = demacro(thisfile, comment)
        with open(newfilepath, 'w') as thisnewfile:
            thisnewfile.write(thisfile)
        if debug:
            debugfilepath = filepath.split('.s')[0] + '_assembly.s'
            with open(debugfilepath, 'w') as thisnewfile:
                thisnewfile.write(thisfile)

        print('\r                                               ', end='')
        compile.compile(newfilepath, newfilepath, debug)
        
    else:
        print('\n Giving up...\n')

