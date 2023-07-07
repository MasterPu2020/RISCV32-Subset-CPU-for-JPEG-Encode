a = -3
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
# print(getbin(a),len(getbin(a)))
# imm[-11:-5] + reg(line[1]) + reg(line[2]) + funct3[op_id] + imm[-4:]
b = '011100001110'
def tranc(string:str, top:int, buttom:int=-1): # Verilog style trancation
    if buttom == -1:
        return string[-top-1]
    elif buttom != 0:
        return string[-top-1:-buttom]
    else:
        return string[-top-1:]
print(tranc(b,11))