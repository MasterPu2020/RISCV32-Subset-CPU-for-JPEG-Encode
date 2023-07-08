# --------------------------------------------------------------------------
# Using UTF-8
# Title: Dust - an assembly code generator
# Last Modified Date: 2023/7/8
# Version: 1.0
# Author: Clark Pu
# --------------------------------------------------------------------------

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
            if (counter > 3):
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
        

riscv = core()
dc_y_EHUFCO = [0, 2, 3, 4, 5, 6, 14, 30, 62, 126, 254, 510]
dc_y_EHUFSI = [2, 3, 3, 3, 3, 3, 4, 5, 6, 7, 8, 9]
ac_y_EHUFCO = [
  10,     0,     1,     4,    11,    26,   120,   248,  1014, 65410, 65411, 0, 0, 0, 0, 0,
   0,    12,    27,   121,   502,  2038, 65412, 65413, 65414, 65415, 65416, 0, 0, 0, 0, 0,
   0,    28,   249,  1015,  4084, 65417, 65418, 65419, 65420, 65421, 65422, 0, 0, 0, 0, 0,
   0,    58,   503,  4085, 65423, 65424, 65425, 65426, 65427, 65428, 65429, 0, 0, 0, 0, 0,
   0,    59,  1016, 65430, 65431, 65432, 65433, 65434, 65435, 65436, 65437, 0, 0, 0, 0, 0,
   0,   122,  2039, 65438, 65439, 65440, 65441, 65442, 65443, 65444, 65445, 0, 0, 0, 0, 0,
   0,   123,  4086, 65446, 65447, 65448, 65449, 65450, 65451, 65452, 65453, 0, 0, 0, 0, 0,
   0,   250,  4087, 65454, 65455, 65456, 65457, 65458, 65459, 65460, 65461, 0, 0, 0, 0, 0,
   0,   504, 32704, 65462, 65463, 65464, 65465, 65466, 65467, 65468, 65469, 0, 0, 0, 0, 0,
   0,   505, 65470, 65471, 65472, 65473, 65474, 65475, 65476, 65477, 65478, 0, 0, 0, 0, 0,
   0,   506, 65479, 65480, 65481, 65482, 65483, 65484, 65485, 65486, 65487, 0, 0, 0, 0, 0,
   0,  1017, 65488, 65489, 65490, 65491, 65492, 65493, 65494, 65495, 65496, 0, 0, 0, 0, 0,
   0,  1018, 65497, 65498, 65499, 65500, 65501, 65502, 65503, 65504, 65505, 0, 0, 0, 0, 0,
   0,  2040, 65506, 65507, 65508, 65509, 65510, 65511, 65512, 65513, 65514, 0, 0, 0, 0, 0,
   0, 65515, 65516, 65517, 65518, 65519, 65520, 65521, 65522, 65523, 65524, 0, 0, 0, 0, 0,
2041, 65525, 65526, 65527, 65528, 65529, 65530, 65531, 65532, 65533, 65534]
ac_y_EHUFSI = [
 4,  2,  2,  3,  4,  5,  7,  8, 10, 16, 16,  0,  0,  0,  0,  0,
 0,  4,  5,  7,  9, 11, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  5,  8, 10, 12, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  6,  9, 12, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  6, 10, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  7, 11, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  7, 12, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  8, 12, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  9, 15, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  9, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  9, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0, 10, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0, 10, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0, 11, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
11, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16]
dc_c_EHUFCO = [0, 1, 2, 6, 14, 30, 62, 126, 254, 510, 1022, 2046]
dc_c_EHUFSI = [2, 2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
ac_c_EHUFCO = [
   0,     1,     4,    10,    24,    25,    56,   120,   500,  1014,  4084, 0, 0, 0, 0, 0,
   0,    11,    57,   246,   501,  2038,  4085, 65416, 65417, 65418, 65419, 0, 0, 0, 0, 0,
   0,    26,   247,  1015,  4086, 32706, 65420, 65421, 65422, 65423, 65424, 0, 0, 0, 0, 0,
   0,    27,   248,  1016,  4087, 65425, 65426, 65427, 65428, 65429, 65430, 0, 0, 0, 0, 0,
   0,    58,   502, 65431, 65432, 65433, 65434, 65435, 65436, 65437, 65438, 0, 0, 0, 0, 0,
   0,    59,  1017, 65439, 65440, 65441, 65442, 65443, 65444, 65445, 65446, 0, 0, 0, 0, 0,
   0,   121,  2039, 65447, 65448, 65449, 65450, 65451, 65452, 65453, 65454, 0, 0, 0, 0, 0,
   0,   122,  2040, 65455, 65456, 65457, 65458, 65459, 65460, 65461, 65462, 0, 0, 0, 0, 0,
   0,   249, 65463, 65464, 65465, 65466, 65467, 65468, 65469, 65470, 65471, 0, 0, 0, 0, 0,
   0,   503, 65472, 65473, 65474, 65475, 65476, 65477, 65478, 65479, 65480, 0, 0, 0, 0, 0,
   0,   504, 65481, 65482, 65483, 65484, 65485, 65486, 65487, 65488, 65489, 0, 0, 0, 0, 0,
   0,   505, 65490, 65491, 65492, 65493, 65494, 65495, 65496, 65497, 65498, 0, 0, 0, 0, 0,
   0,   506, 65499, 65500, 65501, 65502, 65503, 65504, 65505, 65506, 65507, 0, 0, 0, 0, 0,
   0,  2041, 65508, 65509, 65510, 65511, 65512, 65513, 65514, 65515, 65516, 0, 0, 0, 0, 0,
   0, 16352, 65517, 65518, 65519, 65520, 65521, 65522, 65523, 65524, 65525, 0, 0, 0, 0, 0,
1018, 32707, 65526, 65527, 65528, 65529, 65530, 65531, 65532, 65533, 65534]
ac_c_EHUFSI = [
 2,  2,  3,  4,  5,  5,  6,  7,  9, 10, 12,  0,  0,  0,  0,  0,
 0,  4,  6,  8,  9, 11, 12, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  5,  8, 10, 12, 15, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  5,  8, 10, 12, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  6,  9, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  6, 10, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  7, 11, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  7, 11, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  8, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  9, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  9, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  9, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  9, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0, 11, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0, 14, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
10, 15, 16, 16, 16, 16, 16, 16, 16, 16, 16]
# riscv.assem += '// Huffman code table: Luminace DC\n'
# riscv.store(dc_y_EHUFCO, comment=True)
# riscv.assem += '// Huffman size table: Luminace DC\n'
# riscv.store(dc_y_EHUFSI, comment=True)
# riscv.assem += '// Huffman code table: Luminace AC\n'
# riscv.store(ac_y_EHUFCO, comment=True)
# riscv.assem += '// Huffman size table: Luminace AC\n'
# riscv.store(ac_y_EHUFSI, comment=True)
# riscv.assem += '// Huffman code table: Chrominance DC\n'
# riscv.store(dc_c_EHUFCO, comment=True)
# riscv.assem += '// Huffman size table: Chrominance DC\n'
# riscv.store(dc_c_EHUFSI, comment=True)
# riscv.assem += '// Huffman code table: Chrominance AC\n'
# riscv.store(ac_c_EHUFCO, comment=True)
riscv.assem += '// Huffman size table: Chrominance AC\n'
riscv.store(ac_c_EHUFSI, comment=True)
riscv.show()
print(riscv.endaddr)
with open('./assembly/initiate.s', 'w') as file:
    file.write(riscv.assem)
