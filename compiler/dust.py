# --------------------------------------------------------------------------
# Using UTF-8
# Title: Dust - an assembly code generate macro
# Last Modified Date: 2023/7/6
# Version: 1.0
# Author: Clark Pu
# --------------------------------------------------------------------------



# regular rules: continual, increasing, decreasing, steady

# regular rule: continual, increasing or decreasing 
# regular rule serves for 3 parts: 32-12bit and 12-0bit and both must be regular
# regular group members must over than 5
# use x31 to save imm 11-0bit, use x30 to save imm 23-12bit use x29 to save imm 31-24bit

# recorded reg file and mem file
x = [0] * 32
ram = [0] * (2**12)

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
    xreg0 = 'x' + str(reg0) + ' '
    xreg1 = 'x' + str(reg1) + ' '
    xreg2 = 'x' + str(reg2) + ' '
    if imm32 in range(-2**11, 2**11-1):
        immreg0 = str(imm32) + ' '
        assm = 'addi ' + immreg0 + 'x0 ' + xreg0 + '\n'
    elif imm32 in range(-2**22, 2**22-1):
        immreg1 = str(imm32 >> 11) + ' '
        immreg0 = str(imm32 & (2**11-1)) + ' '
        # put signed 22-11 bit
        assm  = 'addi ' + immreg1 + 'x0 ' + xreg1 + '\n'
        assm += 'slli 11 ' + xreg1 + xreg1 + '\n'
        # put unsigned 11-0 bit and connect 
        assm += 'addi ' + immreg0 + 'x0 ' + xreg0 + '\n'
        assm += 'or ' + xreg1 + xreg1 + xreg0 + '\n'
    else:
        immreg2 = str(imm32 >> 22) + ' '
        immreg1 = str((imm32 >> 11) & (2**11-1)) + ' '
        immreg0 = str(imm32 & (2**11-1)) + ' '
        # put signed 32-22 bit
        assm  = 'addi ' + immreg2 + 'x0 ' + xreg2 + '\n'
        assm += 'slli 22 ' + xreg2 + xreg2 + '\n'
        # put unsigned 21-11 bit and connect 
        assm  = 'addi ' + immreg1 + 'x0 ' + xreg1 + '\n'
        assm += 'slli 11 ' + xreg1 + xreg1 + '\n'
        assm += 'or ' + xreg2 + xreg1 + xreg1 + '\n'
        # put unsigned 11-0 bit and connect 
        assm += 'addi ' + immreg0 + 'x0 ' + xreg0 + '\n'
        assm += 'or ' + xreg1 + xreg1 + xreg0 + '\n'
    return assm
    
print(put(2**11))