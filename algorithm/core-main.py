
# -------------------------------------
# Using UTF-8
# Last Modified Date: 2023/7/9
# Python Image JPEG mini encode
# Core Instruction Version
# Version 7.2
# Author: Clark Pu
# -------------------------------------

import base64

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
global x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31
x0 = 0

# This is just a simulation for the real UART interface. // reg [0:31] ram [0:N]
def get_row(file_path:str):
    with open(file_path, 'rb+') as image:
        img_row = []
        byte_file = image.read()
        double_word = ''
        index = 1
        for byte in byte_file:
            text = str(hex(int(byte))[2:].upper())
            if len(text) < 2:
                text = '0' + text
            double_word += text
            if index % 4 == 0:
                img_row.append(int(double_word, 16))
                double_word = ''
            index += 1
    return img_row 


# JPEG file encode: Real RISCV simulation
file_path = './algorithm/test'
print('\n')

# Image read
img_row = [] # YCbCr image in real RAM, it is an 8-bit stack
img_row_in_uart = get_row(file_path+'.row')

# ------------------------------------------------------------------
# RegFile Work Aera 1: Re-order Minimum coded unit(MCU)
# ------------------------------------------------------------------
x28 = img_row_in_uart[0]
x29 = img_row_in_uart[1]
hight = x28
width = x29
# Pre-define variables
x28 = x28 >> 4
x27 = x29 >> 4
mcu_rows = x28
mcu_cals = x27

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
                        # YCbCr convertion
                        # RGB
                        x19 = 255
                        x16 = img_row_in_uart[x15]
                        x16 = x16 >> 16
                        x16 = x16 & x19
                        x17 = img_row_in_uart[x15]
                        x17 = x17 >> 8
                        x17 = x17 & x19
                        x18 = img_row_in_uart[x15]
                        x18 = x18 & x19
                        # Y
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
                        # Cb
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
                        # Cr
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
global stack_space
huffman_bit_stack = [0]
stack_space = 32

# ------------------------------------------------------------------
# Super function: block endcode
# ------------------------------------------------------------------
global mem2048_2111, mem2112_2175, this_dc_value, last_dc_value, mode 

def linemark1():
    global x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31
    global mem2048_2111, mem2112_2175, this_dc_value, last_dc_value, mode, stack_space
    
    # 8x8 matrix subtraction
    # ------------------------------------------------------------------
    p = 0
    while p != 64:
        temp = mem2048_2111[p]
        temp = temp - 128
        mem2048_2111[p] = temp
        p += 1
    
    # Discrete Cosine Transform
    # ------------------------------------------------------------------
    # CORDIC local cosine function
    global target, x1 # partly local

    mem2112_2175 = mem2048_2111
    def linemark2(): # target been << 16
        global target, x1 # partly local
        inverse = False
        while target > 205887:
            target = target - 411775
        if target > 102944:
            inverse = True
            target = target - 205887
        elif target < -102944:
            inverse = True
            target = target + 205887
        theta = 0 # Initial angle: 0 degree
        direction = [0, 0, 0, 0, 0, 0, 0] # clockwise is 1, anticlockwise is -1
        p = 0 # iteration of the routation direction
        while p != 7:
            if theta > target:
                theta -= mem1180_1186[p] # clockwise
                direction[p] = 1
            else:
                theta += mem1180_1186[p] # anticlockwise
                direction[p] = - 1
            p += 1
        x1 = 39797
        x2 = 0
        p = 6
        while p != -1:
            if direction[p] == 1:
                x1 = x1 - (x2 >> p)
                x2 = (x1 >> p) + x2
            else:
                x1 = x1 + (x2 >> p)
                x2 = - (x1 >> p) + x2
            p = p - 1
        if inverse:
            x1 = ~ x1 + 1 # integer been << 16 bit
        return
    
    mem2048_2111 = [0] * 64 # python bug exist here

    for u in range(0,8):
        if u == 0:
            Cu = 46341 # 1/root(2) << 16
        else:
            Cu = 65536 # 1 << 16
        for v in range(0,8):
            if v == 0:
                Cv = 46341
            else:
                Cv = 65536
            unit = 0
            for x in range(0,8):
                for y in range(0,8):
                    temp = mem2112_2175[y + x * 8]
                    target = (2*x + 1) * u * 12868
                    linemark2()
                    temp = (temp * x1) >> 8
                    target = (2*y + 1) * v * 12868
                    linemark2()
                    temp = (temp * x1) >> 8
                    unit += temp
            temp = (Cu * Cv) >> 16
            temp = (temp * unit) >> 32
            temp = temp >> 2 # divide 4
            if temp < 0:
                temp += 1
            mem2048_2111[v + u * 8] = temp

    # Quantization
    # ------------------------------------------------------------------
    p = 0
    quantable_offset = 0
    if mode != 0:
        quantable_offset = 64
    while p != 64:
        mem2048_2111[p] = (mem2048_2111[p] * quantable[p + quantable_offset]) >> 32 # take top 32-bit of the mul result
        p += 1

    # Zigzag Scan
    # ------------------------------------------------------------------
    z = mem2048_2111
    x = 0
    y = 0
    p = 0
    mem2048_2111 = [0] * 64
    direction = 1
    is_edge = 0
    mem2048_2111[0] = z[0]
    while True:
        # meet edge
        if x == 0 or x == 7:
            y += 1
            is_edge = 1
        elif y == 0 or y == 7:
            x += 1
            is_edge = 1
        # If is edge
        if is_edge == 1:
            is_edge = 0
            direction = - direction
            p += 1
            mem2048_2111[p] = z[y * 8 + x]
        # if is end
        if x == 7 and y == 7:
            break
        # normally forwarding
        p += 1
        x -= direction
        y += direction
        mem2048_2111[p] = z[y * 8 + x]

    # Differential DC Value
    # ------------------------------------------------------------------
    this_dc_value = mem2048_2111[0] 
    mem2048_2111[0] = this_dc_value - last_dc_value 

    # Huffman Encode
    # ------------------------------------------------------------------
    # 0 for Luminace
    if mode == 0:
        DC_CODE = 0
        DC_SIZE = 12
        AC_CODE = 24
        AC_SIZE = 275
    else:
        DC_CODE = 526
        DC_SIZE = 538
        AC_CODE = 550
        AC_SIZE = 801

    global temp_data, data, data_size # partly local

    def linemark3():
        global temp_data, data, data_size
        temp_data_size = 0
        less = 0
        if temp_data < 0:
            temp_data = ~ temp_data + 1
            less = 1
        data = temp_data
        while temp_data != 0:
            temp_data = temp_data >> 1
            temp_data_size += 1
        data_size = temp_data_size
        if less == 1:
            trim = 0
            while temp_data_size != 0:
                trim = (trim << 1) + 1
                temp_data_size -= 1
            data = (~ data) & trim
        return

    # push_size must less than 32-bit
    # start with: huffman_bit_stack = [0], stack_space = 32.
    global push_bin, push_size # partly local
    def linemark4():
        global stack_space, push_bin, push_size
        last_dword = huffman_bit_stack[-1]
        if push_size <= stack_space:
            last_dword = last_dword + (push_bin << (stack_space - push_size))
            huffman_bit_stack[-1] = last_dword
            stack_space = stack_space - push_size
        else:
            # fill last double word
            last_dword = last_dword | (push_bin >> (push_size - stack_space))
            huffman_bit_stack[-1] = last_dword 
            # fill new double word
            push_size = push_size - stack_space
            bit = push_size
            trim = 0
            while bit != 0:
                trim = (trim << 1) + 1
                bit -= 1
            trim = trim & push_bin
            stack_space = 32 - push_size
            this_word = trim << stack_space
            huffman_bit_stack.append(this_word)
        return
    
    # DC code
    temp_data = mem2048_2111[0]
    linemark3()
    code = hufftable[DC_CODE + data_size]
    code_size = hufftable[DC_SIZE + data_size]
    push_bin = (code << data_size) + data # less than 32-bit: max code size=16, max data size=10
    push_size = data_size + code_size
    linemark4()

    # AC code
    zero_counter = 0
    for index in range(1,64):
        if mem2048_2111[index] == 0:
            zero_counter += 1
        else:
            while zero_counter > 15: # zeros over than 15
                zero_counter -= 16
                push_bin = hufftable[AC_CODE + 240] # AC [F/0]
                push_size = hufftable[AC_SIZE + 240]
                linemark4()
            # Assembly
            temp_data = mem2048_2111[index]
            linemark3()
            ac_index = (zero_counter << 4) + data_size
            code = hufftable[AC_CODE + ac_index]
            code_size = hufftable[AC_SIZE + ac_index]
            push_bin = (code << data_size) + data # less than 32-bit: max code size=16, max data size=10
            push_size = data_size + code_size
            linemark4()
            zero_counter = 0
    
    # EOB
    if zero_counter != 0:
        push_bin = hufftable[AC_CODE + 0] # AC [0/0]
        push_size = hufftable[AC_SIZE + 0]
        linemark4()

    return this_dc_value 

# ------------------------------------------------------------------
# End of super function
# ------------------------------------------------------------------

# Y Cb Cr subsampling and encode
mem2176_2239 = [0] * 64 # Y image blocks
mem2240_2303 = [0] * 64 # U image blocks
mem2304_2367 = [0] * 64 # V image blocks
index = 0
counter = 0
block_counter = 0
last_dc_value_y = 0
last_dc_value_cb = 0
last_dc_value_cr = 0

t1 = 768 + x0
t2 = mcu_rows
t1 = t1 * t2
t2 = mcu_cals
t1 = t1 * t2
while index != t1:
    # Sampling
    mem2176_2239[counter]  = img_row[index]
    mem2240_2303[counter] += img_row[index + 1]
    mem2304_2367[counter] += img_row[index + 2]
    # Block encode and subsampling
    if counter == 63:
        # Y Block encode
        mem2048_2111 = mem2176_2239
        last_dc_value = last_dc_value_y
        mode = 0
        linemark1()
        last_dc_value_y = this_dc_value
        # Cb Cr subsampling
        if block_counter == 3:
            i = 0
            while i < 64:
                mem2240_2303[i] = mem2240_2303[i] >> 2 # divide 4
                mem2304_2367[i] = mem2304_2367[i] >> 2 # divide 4
                i += 1
            # Cb Block encode
            mem2048_2111 = mem2240_2303
            last_dc_value = last_dc_value_cb
            mode = 1
            linemark1()
            last_dc_value_cb = this_dc_value
            # Cr Block encode
            mem2048_2111 = mem2304_2367
            last_dc_value = last_dc_value_cr
            mode = 2
            linemark1()
            last_dc_value_cr = this_dc_value
            # Clear for re-sampling
            i = 0
            while i < 64:
                mem2240_2303[i] = 0
                mem2304_2367[i] = 0
                i += 1
            block_counter = 0
        else:
            block_counter += 1
        counter = 0
    else:
        counter += 1
    index += 3
    print('\r [Process]: (', index, '/', mcu_rows * mcu_cals * 16 * 16 * 3, ')', end='')

# Post process: read in byte and insert '00' for 'FF', and fill the last byte
temp = 0
while stack_space != 0:
    temp = temp << 1
    temp = temp + 1
    stack_space = stack_space + (-1)
huffman_bit_stack[-1] += temp

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

print('\r [Finished] Size:', int(len(hex_huffman_string) / 2), 'bytes.          \n')

# Generate file
file_hex = 'FFD8FFE000104A46494600010100000100010000'
file_hex += 'FFDB004300'

for byte in quantable[0:64]:
    file_hex += '0' * (2 - len(hex(byte >> 32)[2:])) + hex(byte >> 32)[2:].upper()

file_hex += 'FFDB004301'
for byte in quantable[64:]:
    file_hex += '0' * (2 - len(hex(byte >> 32)[2:])) + hex(byte >> 32)[2:].upper()

lines = '0' * (4 - len( hex(hight)[2:])) + hex(hight)[2:].upper()
samples_per_line = '0' * (4 - len( hex(width)[2:])) + hex(width)[2:].upper()
file_hex += 'FFC0001108' + lines + samples_per_line + '03012200021101031101'

file_hex += 'FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FA'
file_hex += 'FFDA000C03010002110311003F00'
file_hex += hex_huffman_string
file_hex += 'FFD9' 
file_code = base64.b16decode(file_hex)
with open(file_path+'.jpg', 'wb') as output_file:
    output_file.write(file_code)
