
# -------------------------------------
# Using UTF-8
# Last Modified Date: 2023/8/8
# Dust Log to JPEG Huffman data
# Infor: This is used for FPGA segment output verification
# Version 1.0
# Author: Clark Pu
# -------------------------------------

def get_string(size:int, data:int):
        hexdata = hex(data)[2:].upper()
        if len(hexdata) < size:
            hexdata = '0'*(size- len(hexdata)) + hexdata
        return hexdata

def gen(file_in:str, start_addr:int, end_addr:int):
    with open(file_in, 'r') as memlog:
        memlog = memlog.readlines()
    huffmancode = []
    for line in memlog:
        line = line.split()
        if len(line) == 3:
            try:
                address = int(line[0].replace(']', '').replace('[', ''))
                if address >= start_addr and address < end_addr:
                    if int(line[2]) != 0:
                        data = int(line[2])
                        if data < 0:
                            data = data & (2**32-1)
                        huffmancode.append(data)
            except ValueError:
                pass
    
    led = '\n'
    for i in range(0, len(huffmancode)):
        text = 'Address: ' + get_string(2, i) + ' : '
        text += '(upper)' + get_string(8, huffmancode[i])[0:4] + ' '
        text += '(lower)' + get_string(8, huffmancode[i])[4:8]
        led += get_string(2, i) + ' ' + get_string(8, huffmancode[i])[4:8] + '\n' \
            +  get_string(2, i) + ' ' + get_string(8, huffmancode[i])[0:4] + '\n'
        print(text)

    return led

if __name__ == '__main__':
    print('\nLED output as follows:\n(Address) (Half Word)')
    led = gen('./fpga/hdl_sim.log', 50000, 100000)
    print('\nLED check by hand:')
    led = led.split('\n')
    led.pop()
    for i in led:
        print(i)
        input('')