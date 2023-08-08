
# -------------------------------------
# Using UTF-8
# Last Modified Date: 2023/8/8
# Dust Log to JPEG Image File
# Version 1.1
# Author: Clark Pu
# -------------------------------------

def gen(file_in:str, file_out:str, start_addr:int, end_addr:int):
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
    for i in huffmancode:
        print(i)
    # String process, only for simulation usage
    hex_huffman_string = ''
    for word in huffmancode:
        hex_huffman_string += '0' * (8 - len(hex(word)[2:])) + hex(word)[2:].upper()
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
    print('\n [Finished] Size:', int(len(hex_huffman_string) / 8), 'words.          \n')
    # Generate file
    mem1052_1115 = [1 << 16] * 64 # 1 << 32 (/1)
    mem1116_1179 = [1 << 16] * 64
    quantable = mem1052_1115 + mem1116_1179
    file_hex = 'FFD8FFE000104A46494600010100000100010000'
    file_hex += 'FFDB004300'
    for byte in quantable[0:64]:
        file_hex += '0' * (2 - len(hex(byte >> 16)[2:])) + hex(byte >> 16)[2:].upper()
    file_hex += 'FFDB004301'
    for byte in quantable[64:]:
        file_hex += '0' * (2 - len(hex(byte >> 16)[2:])) + hex(byte >> 16)[2:].upper()
    lines = '0' * (4 - len( hex(32)[2:])) + hex(32)[2:].upper()
    samples_per_line = '0' * (4 - len( hex(32)[2:])) + hex(32)[2:].upper()
    file_hex += 'FFC0001108' + lines + samples_per_line + '03012200021101031101'
    file_hex += 'FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FA'
    file_hex += 'FFDA000C03010002110311003F00'
    file_hex += hex_huffman_string
    file_hex += 'FFD9' 
    import base64
    file_code = base64.b16decode(file_hex)
    with open(file_out, 'wb') as output_file:
        output_file.write(file_code)

if __name__ == '__main__':
    gen('./fpga/hdl_sim.log', './fpga/hardware_output.jpg', 50000, 100000)
    # gen('./simulation/mem.log', './simulation/hardware-output.jpg', 206800, 411698)
