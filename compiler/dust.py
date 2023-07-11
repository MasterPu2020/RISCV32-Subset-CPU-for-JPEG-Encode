# --------------------------------------------------------------------------
# Using UTF-8
# Title: Dust - an assembly code generator
# Last Modified Date: 2023/7/8
# Version: 1.0
# Author: Clark Pu
# --------------------------------------------------------------------------

import compile

# if it is a 12-bit signed integer
def is_int12(string:str):
    def is_int(string:str):
        try:
            int(string)
            return True
        except ValueError:
            pass
        return False
    if is_int(string):
        assert int(string) in range(-2**12, 2**12-1), 'ImmRangeError: '+string
        return True
    else:
        return False

# translation of simple arithmetic opertation macro:
def macro2assem(line:str, comment=False):
    opcode = [['add','and','or','sll','sra','mul','mulh'], ['addi','xori', 'lw'], [ 'sw'], ['beq','bne','blt','bge']]
    opsign = [[  '+',  '&', '|', '<<', '>>',  '*','*top'], [   '+',   '^','mem'], ['mem'], [ '==', '!=',  '<', '>=']]
    macro = line.replace(' ', '').replace('\n', '')
    while '//' in macro:
        macro = macro.split('//')[0]
    for op in opsign[0]:
        if op in macro and not ('mem' in macro):
            rd = macro.split('=')[0]
            rs1 = macro.split('=')[1].split(op)[0]
            rs2 = macro.split(op)[1]
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
                rs1 = macro.split('[')[1].split('+')[0]
                rs2 = macro.split('+')[1].split(']')[1]
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
            linemark = macro.split('goto')[1]
            rs1 = macro.split(op)[0]
            rs2 = macro.split(op)[1].split('goto')[0]
            op = opcode[3][opsign[3].index(op)]
            if comment:
                return op + ' ' + rs2 + ' ' + rs1 + ' ' + linemark + ' // ' + line.replace('\n', '') + '\n'
            else:
                return op + ' ' + rs2 + ' ' + rs1 + ' ' + linemark + '\n'
    return line

# translate the macros into assembly code:
def demacro(path, comment=False, newfilepath=None):
    if newfilepath == None:
        newfilepath = path
    newfile = ''
    with open(path, 'r') as file:
        file = file.readlines()
    for line in file:
        if line != '' or line != '\n':
            newfile += macro2assem(line, comment)
    with open(newfilepath, 'w') as file:
        file.write(newfile)
    return

def remove_empty(li:list):
    for i in li:
        if i == '\n':
            li.remove('\n')
        if i == '':
            li.remove('')
        if i == None:
            li.remove(None)
    return li

# if to macro:
def if2macro(path, newfilepath=None):
    if newfilepath == None:
        newfilepath = path
    with open(path, 'r') as file:
        file = file.readlines()
    file = remove_empty(file)
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
        return
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
    for line in file:
        if line.split()[0] == 'if':
            line = line.replace('if ', '', 1)
            if '<' in line:
                line = line.replace('<','>=', 1)
            elif '>=' in file[line]:
                line = line.replace('>=','<', 1)
            elif '==' in file[line]:
                line = line.replace('==','!=', 1)
            elif '!=' in file[line]:
                line = line.replace('!=','==', 1)
            line = line.replace(',', ' goto ' + ifmark[if_id], 1)
            if_id += 1
        if line.split()[0] == 'endif':
            line = line.replace('endif', endmark[end_id] + ':', 1)
            end_id += 1
        text += line
    with open(newfilepath, 'w') as newfile:
        newfile.write(text)

# while to macro:


# riscv core optimizing compiling
# don't use x20 - x31 for saving data, this range is for auto manage
class core():

    def __init__(self, memsize=2**12):
        # recorded reg file and mem file
        self.x = [0] * 32
        self.mem = [0] * memsize
        self.endaddr = [0]
        self.linemark = 0
        # generated assembly code
        self.assem = ''

    # show cpu status
    def show(self, reglen=5, memlen=5):
        print('\n[Register File: 32 x 32bit]')
        print('+','-'*77,'+')
        for i in range(0,4):
            text = '|'
            for j in range(0,8):
                text += ' ' * (2-len(str(j + i*8))) + 'x' + str(j + i*8) + ':' + ' ' * (reglen - len(str(self.x[j + i*8]))) + str(self.x[j + i*8]) + '|'
            print(text)
        print('+','-'*77,'+')
        print('\n[Memory File: 4k x 32bit]')
        print('+','-'*85,'+')
        j = 0
        text = '|'
        for i in range(0, len(self.mem)):
            if self.mem[i] == 0:
                continue
            else:
                text += ' ' * (4-len(hex(i)[2:])) + hex(i)[2:].upper() + ':' + ' ' * (memlen - len(str(self.mem[i]))) + str(self.mem[i]) + '|'
                j += 1
                if j == 8:
                    print(text)
                    text = '|'
                    j = 0
        if len(text) != 0:
            print(text+' '*(88-len(text))+'|')
        print('+','-'*85,'+')

    # search for a springboard in registers
    def sb(self, imm):
        for value in self.x:
            if imm + value in range(-2**11, 2**11-1):
                sreg = 'x' + str(self.x.index(value)) + ' '
                simm = str((imm + value)) + ' '
                return simm ,sreg
            elif imm - value in range(-2**11, 2**11-1):
                sreg = 'x' + str(self.x.index(value)) + ' '
                simm = str((imm - value)) + ' '
                return simm ,sreg
        return None
    
    # put a 32-bit integer to riscv core using subset
    def int32(self, imm32:int, reg0=30, reg1=31, reg2=None, comment=False):
        assert imm32 in range(-2**32, 2**32-1), 'Error: signed value given over than 32 bit.'
        
        # load imm to reg0, reg1 use for computing, reg2 is optional can used for optimize the pipline
        if reg2 == None:
            reg2 = reg0
        sreg0 = 'x' + str(reg0) + ' '

        # if reg0 already == im32
        if self.x[reg0] == imm32:
            return

        if comment:
            self.assem += '// load imm into ' + sreg0 + '\n'

        # use springboard to load the value to register
        if self.sb(imm32) != None:
            self.assem += 'addi ' + self.sb(imm32)[0] + self.sb(imm32)[1] + sreg0 + '\n' 
        # regularly load from the imm input
        # reg2: imm[31:23] reg1: imm[22:11] reg0: imm[10:0]
        else:
            sreg1 = 'x' + str(reg1) + ' '
            sreg2 = 'x' + str(reg2) + ' '
            if imm32 in range(-2**11, 2**11-1):
                simm0 = str(imm32) + ' '
                self.assem += 'addi ' + simm0 + 'x0 ' + sreg0 + '\n'
            elif imm32 in range(-2**22, 2**22-1):
                imm1 = imm32 >> 11
                imm0 = imm32 & (2**11-1)
                simm1 = str(imm1) + ' '
                simm0 = str(imm0) + ' '
                # int signed 22-11 bit
                simm1 = str(imm32 >> 11) + ' '
                simm0 = str(imm32 & (2**11-1)) + ' '
                # put signed 22-11 bit
                self.assem += 'addi ' + simm1 + 'x0 ' + sreg1 + '\n'
                self.assem += 'slli 11 ' + sreg1 + sreg1 + '\n'
                # put unsigned 11-0 bit and connect 
                self.assem += 'addi ' + simm0 + 'x0 ' + sreg0 + '\n'
                self.assem += 'or ' + sreg1 + sreg0 + sreg0 + '\n'
                # record operation result
                self.x[reg1] = imm1 << 11
            else:
                simm2 = str(imm32 >> 22) + ' '
                simm1 = str((imm32 >> 11) & (2**11-1)) + ' '
                simm0 = str(imm32 & (2**11-1)) + ' '
                # put signed 32-22 bit
                self.assem += 'addi ' + simm2 + 'x0 ' + sreg2 + '\n'
                self.assem += 'slli 22 ' + sreg2 + sreg2 + '\n'
                # put unsigned 21-11 bit and connect 
                self.assem += 'addi ' + simm1 + 'x0 ' + sreg1 + '\n'
                self.assem += 'slli 11 ' + sreg1 + sreg1 + '\n'
                self.assem += 'or ' + sreg2 + sreg1 + sreg1 + '\n'
                # put unsigned 11-0 bit and connect 
                self.assem += 'addi ' + simm0 + 'x0 ' + sreg0 + '\n'
                self.assem += 'or ' + sreg1 + sreg0 + sreg0 + '\n'
                # record operation result
                self.x[reg2] = (imm32 >> 22) << 22
                self.x[reg1] = (((imm32 >> 11) & (2**11-1)) << 11) | self.x[reg2]
        # record operation result
        self.x[reg0] = imm32

    # create a loop, developing
    def loop(self, rega=1, judge='<', regb=2, line=None, reg0=31):
        sreg0 = 'x' + str(reg0) + ' '
        srega = 'x' + str(rega) + ' '
        sregb = 'x' + str(regb) + ' '
        if line != None:
            self.linemark = line
        self.assem += '// while ' + srega + judge + ' ' + sregb + ':\n'
        if judge == '<':
            self.int32(1,reg0)
            self.assem += 'blt ' + sreg0 + 'x0 ' + 'linemark' + str(self.linemark+1) + '\n'
            self.assem += 'linemark' + str(self.linemark) + ':\n'
            self.linemark += 1
            self.assem += '    // loop \n'
            self.assem += 'linemark' + str(self.linemark) + ':\n'
            self.linemark += 1
            self.assem += 'blt ' + sregb + srega + 'linemark' + str(self.linemark-2) + '\n'

    # store a continuous address table in memory
    def store(self, table:list, offsetreg=29, startaddr=None, comment=False):
        if startaddr == None:
            startaddr = self.endaddr[-1]
        assert len(table) in range(0,2**12-1), 'Table too long to store, try spliting it.'
        endaddr = startaddr + len(table)
        self.endaddr.append(endaddr)
        
        # use offset address or not
        if not (startaddr in range(0,2**12-1) and endaddr in range(0,2**12-1)):
            if comment:
                self.assem += '// use offset, start address: ' + str(startaddr) + '\n'
            self.int32(startaddr, offsetreg)
            startaddr = 0
        else:
            offsetreg = 0
        soffsetreg = 'x' + str(offsetreg) + ' '

        if comment:
            self.assem += '// Table length: ' + str(len(table)) + ' RAM start address: ' + str(startaddr) + '\n'

        # storing the table
        # sw  rs2 rs1 imm // sw  mem(imm + rs1) <- rs2
        reg = 20
        addr = startaddr

        # detection: increasing, decreasing, steady
        def detect(table:list, i):
            counter = 1
            detection = 0
            lastdetection = 0
            start = i
            while i < len(table) - 1:
                if table[i] == table[i + 1] - 1:
                    detection = 1
                elif table[i] == table[i + 1] + 1:
                    detection = 2
                elif table[i] == table[i + 1]:
                    detection = 3
                else:
                    detection = 0
                if (detection != lastdetection and start != i) or detection == 0:
                    break
                else:
                    lastdetection = detection
                    counter += 1
                i += 1
            return counter, lastdetection
            
        while addr < len(table) + startaddr:

            # detection: increasing, decreasing, steady
            counter, rule = detect(table, addr-startaddr)
            if (counter > 5):
                if rule == 1:
                    print('Increasing!', counter, table[addr-startaddr:addr-startaddr+counter])
                elif rule == 2:
                    print('Decreasing!', counter, table[addr-startaddr:addr-startaddr+counter])
                elif rule == 3:
                    print('steady!', counter, table[addr-startaddr:addr-startaddr+counter])
                    

            # store with no optimization
            saddr = str(addr) + ' '
            if table[addr-startaddr] != 0:
                if table[addr-startaddr] in self.x:
                    regn = self.x.index(table[addr-startaddr])
                    sregn = 'x' + str(regn) + ' '
                    self.assem += 'sw ' + sregn + soffsetreg + saddr + '\n'
                else:
                    self.int32(table[addr-startaddr],reg)
                    sreg = 'x' + str(reg) + ' '
                    self.assem += 'sw ' + sreg + soffsetreg + saddr + '\n'
                    if reg == 31:
                        reg = 20
                    else:
                        reg += 1

            # record operation on riscv
            self.mem[addr+self.x[offsetreg]] = table[addr-startaddr]
            addr += 1


if2macro('initiate.s')
demacro('initiate.s', True)
compile.compile('initiate.s', debug=True)