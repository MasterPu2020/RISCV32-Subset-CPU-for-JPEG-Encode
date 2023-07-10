
# -------------------------------------
# Using UTF-8
# Last Modified Date: 2023/7/9
# Python Image JPEG mini encode
# Core Instruction Version
# Version 7.2
# Author: Clark Pu
# -------------------------------------

# if x0 != x1, then () <=> skip () if x0 == x1 # this go downwards
# if x0 == x1, then () <=> skip () if x0 != x1 # this go downwards
# while x0 != x1, then () <=> loop () until x0 != x1 # this go upwards
# while x0 == x1, then () <=> loop () until x0 == x1 # this go upwards
# break <=> x1 = 1, goto () if x0 != x1 # this go anywhere

import base64

#memory in word size, in real assembly code, always shift left 1 bit before use
mem0_11 = [0, 2, 3, 4, 5, 6, 14, 30, 62, 126, 254, 510]
mem12_23 = [2, 3, 3, 3, 3, 3, 4, 5, 6, 7, 8, 9]
mem24_274 = [
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
mem275_525 = [
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
mem526_537 = [0, 1, 2, 6, 14, 30, 62, 126, 254, 510, 1022, 2046]
mem538_549 = [2, 2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
mem550_800 = [
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
mem801_1051 = [
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
hufftable = mem0_11 + mem12_23 + mem24_274 + mem275_525 + mem526_537 + mem538_549 + mem550_800 + mem801_1051
mem1052_1115 = [4294967296] * 64 # 1 << 32 (/1)
mem1116_1179 = [4294967296] * 64
quantable = mem1052_1115 + mem1116_1179
mem1180_1186 = [51471 , 30385 , 16054 , 8149 , 4090 , 2047 , 1023]

global mem
global x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31

def reset():
    global mem
    mem = [0] * 4096
    global x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31
    x0 = 0
    x1 = 0
    x2 = 0
    x3 = 0
    x4 = 0
    x5 = 0
    x6 = 0
    x7 = 0
    x8 = 0
    x9 = 0
    x10 = 0
    x11 = 0
    x12 = 0
    x13 = 0
    x14 = 0
    x15 = 0
    x16 = 0
    x17 = 0
    x18 = 0
    x19 = 0
    x20 = 0
    x21 = 0
    x22 = 0
    x23 = 0
    x24 = 0
    x25 = 0
    x26 = 0
    x27 = 0
    x28 = 0
    x29 = 0
    x30 = 0
    x31 = 0

# sw mem(imm + rs1) <- rs2
def sw(xoffset, data32, immoffset):
    global mem
    assert immoffset in range(-2**12, 2**12-1), '\nSave word, imm out of range.'
    mem[immoffset + xoffset] = data32

# mem(imm + rs1) -> rd
def lw(xoffset, immoffset):
    global mem
    assert immoffset in range(-2**12, 2**12-1), '\nLoad word, imm out of range.'
    data32 = mem[immoffset + xoffset]
    return data32

# exam software sanity
def exam():
    global x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31
    assert  x0 == 0, 'Error: x0 != 0'
    assert  x1 in range(-2**32, 2**32-1), 'Error:  x1 out of range:' + str(len(bin( x1)[2:])) + ' bit.'
    assert  x2 in range(-2**32, 2**32-1), 'Error:  x2 out of range:' + str(len(bin( x2)[2:])) + ' bit.'
    assert  x3 in range(-2**32, 2**32-1), 'Error:  x3 out of range:' + str(len(bin( x3)[2:])) + ' bit.'
    assert  x4 in range(-2**32, 2**32-1), 'Error:  x4 out of range:' + str(len(bin( x4)[2:])) + ' bit.'
    assert  x5 in range(-2**32, 2**32-1), 'Error:  x5 out of range:' + str(len(bin( x5)[2:])) + ' bit.'
    assert  x6 in range(-2**32, 2**32-1), 'Error:  x6 out of range:' + str(len(bin( x6)[2:])) + ' bit.'
    assert  x7 in range(-2**32, 2**32-1), 'Error:  x7 out of range:' + str(len(bin( x7)[2:])) + ' bit.'
    assert  x8 in range(-2**32, 2**32-1), 'Error:  x8 out of range:' + str(len(bin( x8)[2:])) + ' bit.'
    assert  x9 in range(-2**32, 2**32-1), 'Error:  x9 out of range:' + str(len(bin( x9)[2:])) + ' bit.'
    assert x10 in range(-2**32, 2**32-1), 'Error: x10 out of range:' + str(len(bin(x10)[2:])) + ' bit.'
    assert x11 in range(-2**32, 2**32-1), 'Error: x11 out of range:' + str(len(bin(x11)[2:])) + ' bit.'
    assert x12 in range(-2**32, 2**32-1), 'Error: x12 out of range:' + str(len(bin(x12)[2:])) + ' bit.'
    assert x13 in range(-2**32, 2**32-1), 'Error: x13 out of range:' + str(len(bin(x13)[2:])) + ' bit.'
    assert x14 in range(-2**32, 2**32-1), 'Error: x14 out of range:' + str(len(bin(x14)[2:])) + ' bit.'
    assert x15 in range(-2**32, 2**32-1), 'Error: x15 out of range:' + str(len(bin(x15)[2:])) + ' bit.'
    assert x16 in range(-2**32, 2**32-1), 'Error: x16 out of range:' + str(len(bin(x16)[2:])) + ' bit.'
    assert x17 in range(-2**32, 2**32-1), 'Error: x17 out of range:' + str(len(bin(x17)[2:])) + ' bit.'
    assert x18 in range(-2**32, 2**32-1), 'Error: x18 out of range:' + str(len(bin(x18)[2:])) + ' bit.'
    assert x19 in range(-2**32, 2**32-1), 'Error: x19 out of range:' + str(len(bin(x19)[2:])) + ' bit.'
    assert x20 in range(-2**32, 2**32-1), 'Error: x20 out of range:' + str(len(bin(x20)[2:])) + ' bit.'
    assert x21 in range(-2**32, 2**32-1), 'Error: x21 out of range:' + str(len(bin(x21)[2:])) + ' bit.'
    assert x22 in range(-2**32, 2**32-1), 'Error: x22 out of range:' + str(len(bin(x22)[2:])) + ' bit.'
    assert x23 in range(-2**32, 2**32-1), 'Error: x23 out of range:' + str(len(bin(x23)[2:])) + ' bit.'
    assert x24 in range(-2**32, 2**32-1), 'Error: x24 out of range:' + str(len(bin(x24)[2:])) + ' bit.'
    assert x25 in range(-2**32, 2**32-1), 'Error: x25 out of range:' + str(len(bin(x25)[2:])) + ' bit.'
    assert x26 in range(-2**32, 2**32-1), 'Error: x26 out of range:' + str(len(bin(x26)[2:])) + ' bit.'
    assert x27 in range(-2**32, 2**32-1), 'Error: x27 out of range:' + str(len(bin(x27)[2:])) + ' bit.'
    assert x28 in range(-2**32, 2**32-1), 'Error: x28 out of range:' + str(len(bin(x28)[2:])) + ' bit.'
    assert x29 in range(-2**32, 2**32-1), 'Error: x29 out of range:' + str(len(bin(x29)[2:])) + ' bit.'
    assert x30 in range(-2**32, 2**32-1), 'Error: x30 out of range:' + str(len(bin(x30)[2:])) + ' bit.'
    assert x31 in range(-2**32, 2**32-1), 'Error: x31 out of range:' + str(len(bin(x31)[2:])) + ' bit.'

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


# JPEG file encode: Real RISCV simulation
file_path = './algorithm/test'
print('\n')

# Image read
reset()
img_row = [] # YCbCr image in real RAM, it is an 8-x15 stack
img_row_in_uart = get_row(file_path+'.row')

# initiate memory
mem[0:1186] = hufftable + quantable + mem1180_1186

# ------------------------------------------------------------------
# RegFile Work Aera 1: Re-order Minimum coded x14(MCU)
# Avialiable register remaind: x20 ~ x23
# ------------------------------------------------------------------

x28 = img_row_in_uart[0]
x29 = img_row_in_uart[1]
sw(x0, x28, 1187)
sw(x0, x28, 1188)
x28 = x28 >> 4
x27 = x29 >> 4
sw(x0, x28, 1189)
sw(x0, x27, 1190)

x1 = 0
x2 = 0
x3 = 0
x4 = 0
x5 = 0
x6 = 0
x26 = 16
x25 = 8
x24 = 2

while x2 != x28:
    x10 = x26 * x29
    x10 = x10 * x2
    x10 = x10 + 2
    while x1 != x27:
        x11 = x26 * x1
        x11 = x11 + x10
        while x4 != x24:
            x12 = x25 * x29
            x12 = x12 * x4 
            x12 = x12 + x11
            while x3 != x24:
                x13 = x25 * x3
                x13 = x13 + x12
                while x5 != x25:
                    x14 = x5 + x13
                    while x6 != x25:
                        x15 = x29 * x6
                        x15 = x15 + x14
                        x19 = 255
                        x16 = img_row_in_uart[x15]
                        x16 = x16 >> 16
                        x16 = x16 & x19
                        x17 = img_row_in_uart[x15]
                        x17 = x17 >> 8
                        x17 = x17 & x19
                        x18 = img_row_in_uart[x15]
                        x18 = x18 & x19
                        x19 = 1103806595
                        x19 = (x19 * x16) >> 32
                        x30 = 2422361555
                        x30 = (x30 * x17) >> 32
                        x19 = x19 + x30
                        x30 = 420906795
                        x30 = (x30 * x18) >> 32
                        x19 = x19 + x30
                        x19 = x19 + 16
                        img_row.append(x19)
                        x19 = -635655160
                        x19 = (x19 * x16) >> 32 
                        x30 = -1249835483
                        x30 = (x30 * x17) >> 32
                        x19 = x19 + x30
                        x30 = 1885490643
                        x30 = (x30 * x18) >> 32 
                        x19 = x19 + x30
                        x19 = x19 + 128
                        img_row.append(x19)
                        x19 = -1580547965
                        x19 = (x19 * x17) >> 32 
                        x30 = 1885490643
                        x30 = (x30 * x16) >> 32 
                        x19 = x19 + x30
                        x30 = -304942678
                        x30 = (x30 * x18) >> 32
                        x19 = x19 + x30
                        x19 = x19 + 128
                        img_row.append(x19)
                        x6 = x6 + 1
                    x6 = 0 + x0
                    x5 = x5 + 1
                x5 = 0 + x0
                x3 = x3 + 1
            x3 = 0 + x0
            x4 = x4 + 1
        x4 = 0 + x0
        x1 = x1 + 1
    x1 = 0 + x0
    x2 = x2 + 1

# ------------------------------------------------------------------
# RegFile Work Aera 2: Huffman endcode
# ------------------------------------------------------------------

global huffman_bit_stack
huffman_bit_stack = [0]
x26 = 32

x23 = 46341
sw(x0, x23, 1198)
x23 = 65536
sw(x0, x23, 1199)
x23 = 12868
sw(x0, x23, 1200)

def linemark1():
    global x29, x28, x27, x26, x30, x31
    global x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25

    # 8x8 matrix subtraction: Sub Area 1
    # ------------------------------------------------------------------
    x2 = 2047 + x0
    x1 = 0 + x2
    x2 = 64 + x2
    while x1 != x2:
        x3 = lw(x1, 1)
        x3 = x3 - 128
        sw(x1, x3, 1)
        x1 += 1
    
    # Discrete Cosine Transform: Sub Area 2
    # ------------------------------------------------------------------
    x1 = 2047 + x0
    x2 = 64 + x1
    while x1 != x2:
        x3 = lw(x1, 1)
        sw(x1, x3, 65)
        sw(x1, x0, 1)
        x1 = x1 + 1

    def linemark2(): 
        global x0, x1, x2, x7, x8, x9, x10, x20, x21, x22, x23
        x8 = 0
        x20 = 205887 # dust will help
        x21 = - 411775 # dust will help
        x22 = 102944 # dust will help
        while x9 > x20: # extra instruction
            x9 = x9 + x21
        if x9 > x22:
            x8 = 1
            x20 = ~ x20 + 1
            x9 = x9 + x20
        else:
            x22 = ~ x22 + 1
            if x9 < x22:
                x8 = 1
                x9 = x9 + x20
        x10 = 0 
        sw(x0, x0, 1191)
        sw(x0, x0, 1192)
        sw(x0, x0, 1193)
        sw(x0, x0, 1194)
        sw(x0, x0, 1195)
        sw(x0, x0, 1196)
        sw(x0, x0, 1197)
        # mem[1191:1198] = [0, 0, 0, 0, 0, 0, 0] 
        x7 = 0 
        while x7 != 7:
            if x10 > x9: 
                x20 = lw(x7, 1180)
                x20 = ~ x20 + 1
                x10 = x10 + x20
                x21 = 1
                mem[1191 + x7] = x21
            else:
                x20 = lw(x7, 1180)
                x10 = x10 + x20
                mem[1191 + x7] = x0
            x7 = x7 + 1
        x1 = 39797 # dust will help
        x2 = 0
        x7 = 6
        x21 = 1
        x23 = -1
        # extra instruction
        while x7 != x23:
            x20 = mem[1191 + x7]
            x22 = x2 >> x7
            if x20 == x21:
                x22 = ~ x22 + 1
                x1 = x1 + x22
                x22 = x1 >> x7
            else:
                x1 = x1 + x22
                x22 = x1 >> x7
                x22 = ~ x22 + 1
            x2 = x22 + x2
            x7 = x7 - 1
        if x8 == x21:
            x1 = ~ x1 + 1
        return
    
    x15 = 8
    x17 = 2
    x3 = 0
    x4 = 0
    x5 = 0
    x6 = 0
    while x3 != x15:
        if x3 == 0:
            x11 = lw(x0, 1198)
        else:
            x11 = lw(x0, 1199)
        while x4 != x15:
            if x4 == 0:
                x12 = lw(x0, 1198)
            else:
                x12 = lw(x0, 1199)
            x14 = 0
            while x5 != x15:
                while x6 != x15:
                    x16 = x5 * x15
                    x16 = x16 + x6
                    x16 = 2047 + x16
                    x13 = lw(x16, 65)
                    x9 = x17 * x5
                    x9 = x9 + 1
                    x9 = x9 * x3
                    x23 = lw(x0, 1200)
                    x9 = x9 * x23
                    linemark2()
                    x13 = x13 * x1
                    x13 = x13 >> 8
                    x9 = x17 * x6
                    x9 = x9 + 1
                    x9 = x9 * x4
                    x23 = lw(x0, 1200)
                    x9 = x9 * x23
                    linemark2()
                    x13 = x13 * x1
                    x13 = x13 >> 8
                    x14 = x14 + x13
                    x6 = x6 + 1
                x6 = 0
                x5 = x5 + 1
            x13 = x11 * x12
            # exam()
            x13 = x13 >> 16
            x13 = (x13 * x14) >> 32
            x13 = x13 >> 2
            if x13 != 0:
                x13 = x13 + 1
            x16 = x3 * x15
            x16 = x4 + x16
            x16 = x16 + 2047
            sw(x16, x13, 1)
            x5 = 0
            x4 = x4 + 1
        x4 = 0
        x3 = x3 + 1

    # Quantization: Sub Area 3
    # ------------------------------------------------------------------
    x2 = 1052 + x0
    if x28 == 0:
        x2 = 1116 + x0
    x1 = 0 + x0
    x5 = 64 + x0 
    while x1 != x5:
        x6 = x1 + x2
        x7 = x1 + 2047
        x3 = lw(x6, 0)
        x4 = lw(x7, 1)
        x3 = (x3 * x4) >> 32
        sw(x7, x0, 1)
        sw(x7, x3, 65)
        x1 = x1 + 1

    # Zigzag Scan: Sub Area 4
    # ------------------------------------------------------------------
    x1 = 0
    x2 = 0
    x5 = 0
    x3 = 1
    x4 = 0
    x6 = 7
    x7 = 8
    x9 = 1
    # Differential DC Value:
    x10 = 2047 + x0
    x27 = lw(x10, 65)
    x11 = x27 - x29
    sw(x10, x11, 1)
    while True:
        if x1 == x0 or x1 == x6:
            x2 += 1
            x4 = 1
        elif x2 == x0 or x2 == x6:
            x1 += 1
            x4 = 1
        if x4 == 1:
            x4 = 0
            x3 = - x3
            x5 += 1
            x12 = x2 * x7
            x12 = x12 + x1
            x12 = x12 + x10
            x11 = lw(x12, 65)
            x13 = x10 + x5
            sw(x13, x11, 1)
        if x1 == x6 and x2 == x6:
            break
        x5 += 1
        x1 -= x3
        x2 += x3
        x12 = x2 * x7
        x12 = x12 + x1
        x12 = x12 + x10
        x11 = lw(x12, 65)
        x13 = x10 + x5
        sw(x13, x11, 1)

    # Huffman Encode: Sub Area 6
    # ------------------------------------------------------------------
    # 0 for Luminace
    if x28 == 0:
        x10 = 0
        x11 = 12
        x12 = 24
        x13 = 275
    else:
        x10 = 526
        x11 = 538
        x12 = 550
        x13 = 801

    def linemark3():
        global x1, x2, x3, x14, x15, x16, x17
        x14 = 0
        x15 = 0
        x17 = 1
        if x1 < x0:
            x1 = ~ x1 + 1
            x15 = 1
        x2 = x1
        while x1 != x0:
            x1 = x1 >> 1
            x14 = x14 + 1
        x3 = x14
        if x15 == x17:
            x16 = 0
            while x14 != x0:
                x16 = x16 << 1
                x16 = x16 + 1
                x14 = x14 - 1
            x2 = ~ x2
            x2 = x2 & x16
        return

    def linemark4():
        global x26, x4, x5, x14, x15, x16, x17, x18
        x14 = huffman_bit_stack[-1]
        if x5 <= x26:
            x18 = x26 - x5
            x18 = x4 << x18
            x14 = x14 + x18
            huffman_bit_stack[-1] = x14
            x26 = x26 - x5
        else:
            x18 = x5 - x26
            x18 = x4 >> x18
            x14 = x14 | x18
            huffman_bit_stack[-1] = x14 
            x5 = x5 - x26
            x15 = x5
            x16 = 0
            while x15 != 0:
                x16 = x16 << 1
                x16 = x16 + 1
                x15 = x15 - 1
            x16 = x16 & x4
            x26 = 32 - x5
            x17 = x16 << x26
            huffman_bit_stack.append(x17)
        return
    
    # DC
    x14 = 2047
    x1 = lw(x14, 1)
    linemark3()
    x14 = x10 + x3
    x6 = lw(x14, 0)
    x14 = x11 + x3
    x7 = lw(x14, 0)
    x4 = (x6 << x3) + x2
    x5 = x3 + x7
    linemark4()

    # AC
    x9 = 0
    x20 = 1
    x21 = 64
    x22 = 15
    while x20 != x21:
        x14 = 2047
        x14 = x20 + x14
        x15 = lw(x14, 1)
        if x15 == x0:
            x9 = x9 + 1
        else:
            while x9 > x22: # zeros over than 15
                x9 = x9 - 16
                x4 = lw(x12, 240)
                x5 = lw(x13, 240)
                linemark4()
            # Assembly
            x14 = 2047
            x14 = x20 + x14
            x1 = lw(x14, 1)
            linemark3()
            x8 = x9 << 4
            x8 = x8 + x3
            x14 = x12 + x8
            x6 = lw(x14, 0)
            x14 = x13 + x8
            x7 = lw(x14, 0)
            x4 = x6 << x3
            x4 = x4 + x2
            x5 = x3 + x7
            linemark4()
            x9 = 0
        x20 = x20 + 1

    # EOB
    if x9 != 0:
        x4 = lw(x12, 0)
        x5 = lw(x13, 0)
        linemark4()

# ------------------------------------------------------------------
# RegFile Work Aera 3: Sampling
# ------------------------------------------------------------------

sw(x0, x0, 1201)
sw(x0, x0, 1202)
sw(x0, x0, 1203)
sw(x0, x0, 1204)
sw(x0, x0, 1205)
sw(x0, x0, 1206)
x1 = 768 + x0
x2 = lw(x0, 1189)
x1 = x1 * x2
x2 = lw(x0, 1190)
x4 = x1 * x2
sw(x0, x4, 1207) # block start here
x1 = 0 + x0
x2 = 0 + x0
x3 = 0 + x0

while x1 != x4:
    x5 = 2047 + x0
    x5 = x5 + x2
    x6 = img_row[x1 + 0]
    sw(x5, x6, 129)
    x6 = img_row[x1 + 1]
    x7 = lw(x5, 193)
    x6 = x6 + x7
    sw(x5, x6, 193)
    x6 = img_row[x1 + 2]
    x7 = lw(x5, 257)
    x6 = x6 + x7
    sw(x5, x6, 257)
    x6 = 63 + x0
    if x2 == x6:
        sw(x0, x1, 1201)
        sw(x0, x3, 1203)
        x5 = 2047 + x0
        x6 = 64 + x0
        x7 = 0 + x0
        while x7 != x6:
            x8 = x7 + x5
            x9 = lw(x8, 129)
            sw(x8, x9, 1)
            x7 = x7 + 1
        x29 = lw(x0, 1204)
        x28 = 0 
        linemark1() 
        sw(x0, x27, 1204)
        x3 = lw(x0, 1203)
        if x3 == 3:
            x5 = 2047 + x0
            x6 = 64 + x0
            x7 = 0 + x0
            while x7 != x6:
                x8 = x7 + x5
                x9 = lw(x8, 193)
                x9 = x9 >> 2 
                sw(x8, x9, 1)
                x7 = x7 + 1
            x29 = lw(x0, 1205)
            x28 = 1 
            linemark1() 
            sw(x0, x27, 1205)
            x5 = 2047 + x0
            x6 = 64 + x0
            x7 = 0 + x0
            while x7 != x6:
                x8 = x7 + x5
                x9 = lw(x8, 257)
                x9 = x9 >> 2
                sw(x8, x9, 1)
                x7 = x7 + 1
            x29 = lw(x0, 1206)
            x28 = 2
            linemark1()
            sw(x0, x27, 1206)
            x6 = 2047 + x0
            x6 = 64 + x6
            x7 = 2047 + x0
            while x7 != x6:
                sw(x7, x0, 193)
                sw(x7, x0, 257)
                x7 = x7 + 1
            x3 = 0 + x0
        else:
            x3 = x3 + 1
        x2 = 0 + x0
        x1 = lw(x0, 1201)
        x4 = lw(x0, 1207)
    else:
        x2 += 1
    x1 += 3
    print('\r [Process]: (', x1, '/', mem[1189] * mem[1190] * 768, ')', end='')

# ------------------------------------------------------------------
# RegFile Work Aera 4: Post Process
# ------------------------------------------------------------------

# Post process: read in byte and insert '00' for 'FF', and fill the last byte
x13 = 0
while x26 != 0:
    x13 = x13 << 1
    x13 = x13 + 1
    x26 = x26 + (-1)
huffman_bit_stack[-1] += x13

# String process, only for simulation usage
hex_huffman_string = ''
for double_word in huffman_bit_stack:
    hex_huffman_string += '0' * (8 - len(hex(double_word)[2:])) + hex(double_word)[2:].upper()
# Remove the redundent FF
while hex_huffman_string[-2:] == 'FF':
    if (len(hex_huffman_string) % 2 != 0):
        hex_huffman_string = hex_huffman_string[:-1]
    else:
        hex_huffman_string = hex_huffman_string[:-2]
# 'FF' follows the '00'
i = 0
new_huffstring = ''
while i < len(hex_huffman_string) / 2:
    byte = hex_huffman_string[i*2:i*2+2]
    new_huffstring += byte
    if byte == 'FF':
        new_huffstring += '00'
    i += 1
hex_huffman_string = new_huffstring

print('\r [Finished] Size:', int(len(hex_huffman_string) / 8), 'words.          \n')

# Generate file
file_hex = 'FFD8FFE000104A46494600010100000100010000'
file_hex += 'FFDB004300'

for byte in quantable[0:64]:
    file_hex += '0' * (2 - len(hex(byte >> 32)[2:])) + hex(byte >> 32)[2:].upper()

file_hex += 'FFDB004301'
for byte in quantable[64:]:
    file_hex += '0' * (2 - len(hex(byte >> 32)[2:])) + hex(byte >> 32)[2:].upper()

lines = '0' * (4 - len( hex(mem[1187])[2:])) + hex(mem[1187])[2:].upper()
samples_per_line = '0' * (4 - len( hex(mem[1188])[2:])) + hex(mem[1188])[2:].upper()
file_hex += 'FFC0001108' + lines + samples_per_line + '03012200021101031101'

file_hex += 'FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FA'
file_hex += 'FFDA000C03010002110311003F00'
file_hex += hex_huffman_string
file_hex += 'FFD9' 
file_code = base64.b16decode(file_hex)
with open(file_path+'.jpg', 'wb') as output_file:
    output_file.write(file_code)
