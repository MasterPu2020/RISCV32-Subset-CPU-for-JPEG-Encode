# --------------------------------------------------------------------------
# Using UTF-8
# Title: Dust - an assembly code generator
# Last Modified Date: 2023/7/8
# Version: 1.0
# Author: Clark Pu
# --------------------------------------------------------------------------



# regular rules: continual, increasing, decreasing, steady

# regular rule: continual, increasing or decreasing 
# regular rule serves for 3 parts: 32-12bit and 12-0bit and both must be regular
# regular group members must over than 5
# use x31 to save imm 11-0bit, use x30 to save imm 23-12bit use x29 to save imm 31-24bit


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

# get binary string's integer value
def getint(string):
    if string[0] == '1':
        value = int(string.replace('0','x').replace('1','0').replace('x','1'), 2) + 1
        return - value
    else:
        value = int(string, 2)
        return value

# generate assembly code to put a 32-bit imm value into registers
def put(imm32:int, reg0=30,reg1=31,reg2=None):
    # reg2: imm[31:23] reg1: imm[22:11] reg0: imm[10:0]
    if reg2 == None:
        reg2 = reg0
    sreg0 = 'x' + str(reg0) + ' '
    sreg1 = 'x' + str(reg1) + ' '
    sreg2 = 'x' + str(reg2) + ' '
    if imm32 in range(-2**11, 2**11-1):
        simm0 = str(imm32) + ' '
        assem = 'addi ' + simm0 + 'x0 ' + sreg0 + '\n'
    elif imm32 in range(-2**22, 2**22-1):
        simm1 = str(imm32 >> 11) + ' '
        simm0 = str(imm32 & (2**11-1)) + ' '
        # put signed 22-11 bit
        assem  = 'addi ' + simm1 + 'x0 ' + sreg1 + '\n'
        assem += 'slli 11 ' + sreg1 + sreg1 + '\n'
        # put unsigned 11-0 bit and connect 
        assem += 'addi ' + simm0 + 'x0 ' + sreg0 + '\n'
        assem += 'or ' + sreg1 + sreg0 + sreg0 + '\n'
    elif imm32 in range(-2**32, 2**32-1):
        simm2 = str(imm32 >> 22) + ' '
        simm1 = str((imm32 >> 11) & (2**11-1)) + ' '
        simm0 = str(imm32 & (2**11-1)) + ' '
        # put signed 32-22 bit
        assem  = 'addi ' + simm2 + 'x0 ' + sreg2 + '\n'
        assem += 'slli 22 ' + sreg2 + sreg2 + '\n'
        # put unsigned 21-11 bit and connect 
        assem += 'addi ' + simm1 + 'x0 ' + sreg1 + '\n'
        assem += 'slli 11 ' + sreg1 + sreg1 + '\n'
        assem += 'or ' + sreg2 + sreg1 + sreg1 + '\n'
        # put unsigned 11-0 bit and connect 
        assem += 'addi ' + simm0 + 'x0 ' + sreg0 + '\n'
        assem += 'or ' + sreg1 + sreg0 + sreg0 + '\n'
    else:
        raise 'Error: signed value given over than 32 bit.'
    return assem

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
            if imm + value in range(-2**12, 2**12-1):
                sreg = 'x' + str(self.x.index(value)) + ' '
                simm = str((imm + value)) + ' '
                return simm ,sreg
            elif imm - value in range(-2**12, 2**12-1):
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

    # store a continuous address table in memory
    def store(self, table:list, offsetreg=29, startaddr=None, comment=False):
        if startaddr == None:
            startaddr = self.endaddr[-1]
        assert len(table) in range(0,2**12-1), 'Table too long to store, try spliting it.'
        endaddr = startaddr + len(table) + 1
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
            self.assem += '// Table length: ' + str(len(table)) + '\n'

        # storing the table
        # sw  rs2 rs1 imm // sw  mem(imm + rs1) <- rs2
        reg = 20
        addr = startaddr
        while addr < len(table) + startaddr:

            # store depend on the regular: increasing, decreasing, steady
            
            # store with no optimization
            saddr = str(addr) + ' '
            if table[addr] in self.x:
                regn = self.x.index(table[addr])
                sregn = 'x' + str(regn) + ' '
                self.assem += 'sw ' + sregn + soffsetreg + saddr + '\n'
            else:
                self.int32(table[addr],reg)
                sreg = 'x' + str(reg) + ' '
                self.assem += 'sw ' + sreg + soffsetreg + saddr + '\n'
                if reg == 31:
                    reg = 20
                else:
                    reg += 1

            # record operation on riscv
            self.mem[addr+self.x[offsetreg]] = table[addr]
            addr += 1
        

a=[10, 10, 10, 10, 10]

riscv = core(2**15)
riscv.endaddr.append(2**13)
riscv.store(a,comment=True)
riscv.show()
print(riscv.assem)