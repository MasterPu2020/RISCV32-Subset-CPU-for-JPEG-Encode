
file = './soc/system.bin'
fileout = './soc/system.hex'
mem = True

with open(file, 'r') as binfile:
    binfile = binfile.readlines()
lineindex = 0
maxlineindex = len(binfile)
addresswidth = len(str(maxlineindex))
newfiletext = ''
for line in binfile:
    line = hex(int(line, 2))[2:]
    line = '0'*(8-len(line)) + line
    if mem:
        line = 'assign memory[' + ' ' * (addresswidth - len(str(lineindex))) + str(lineindex) + "] = 32'h" + line.upper() + ';'
    else:
        line = hex(lineindex << 2)[2:] + ' : ' + line
    newfiletext += line + '\n'
    lineindex += 1
    
print('\nMaximum address:', maxlineindex-1, '\n')

with open(fileout, 'w') as hexfile:
    hexfile.write(newfiletext)
