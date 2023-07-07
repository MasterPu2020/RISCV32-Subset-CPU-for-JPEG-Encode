
mem = [1] * 63
print('[Memory File: 4k x 32bit]')
print('+','-'*85,'+')
j = 0
text = '|'
for i in range(0, len(mem)):
    if mem[i] == 0:
        continue
    else:
        text += ' ' * (4-len(hex(i)[2:])) + hex(i)[2:].upper() + ':' + ' ' * (5 - len(str(mem[i]))) + str(mem[i]) + '|'
        j += 1
        if j == 8:
            print(text)
            text = '|'
            j = 0
if len(text) != 0:
    print(text+' '*(88-len(text))+'|')
print('+','-'*85,'+')