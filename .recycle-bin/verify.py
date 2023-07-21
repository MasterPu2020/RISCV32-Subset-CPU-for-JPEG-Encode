with open('jpeg.log', 'r') as jpeg:
    jpeg = jpeg.readlines()
with open('mem.log', 'r') as log:
    log = log.readlines()

error = 0

def getbin(value, size:int=32):
    value = int(value)
    sizelow = -(2 ** int(size))
    sizehigh = 2 ** (int(size)-1)
    assert value in range(sizelow, sizehigh)
    if value < 0:
        value_bin = bin(value+1)[3:].replace('0','x').replace('1','0').replace('x','1')
        value_bin = '1'*(size-len(value_bin)) + value_bin
    else:
        value_bin = bin(value)[2:]
        value_bin = '0'*(size-len(value_bin)) + value_bin
    return value_bin


print('\n')
for i in range(1, len(log)-1):
    linelog = log[i].replace(' ', '')
    linejpeg = jpeg[i].replace(' ', '')
    linelog = linelog.split('|')
    linejpeg = linejpeg.split('|')
    for j in range(0,len(linelog)): # 206800
        if len(linelog[j].split()) == 0:
            continue
        addrlog = int(linelog[j].split(':')[0], 16)
        datalog = linelog[j].split(':')[1]
        addrjpeg = int(linejpeg[j].split(':')[0], 16)
        datajpeg = linejpeg[j].split(':')[1]
        if linelog[j] != linejpeg[j]:
            print('\nNot Match:')
            print('log :', addrlog, ':', datalog, 'BIN: ', getbin(datalog))
            print('jpeg:', addrjpeg, ':', datajpeg, 'BIN: ', getbin(datajpeg))
            error += 1
        elif addrlog in range(206800,206850):
            print('\nlog :', addrlog, ':', datalog, 'BIN: ', getbin(datalog))
            print('jpeg:', addrjpeg, ':', datajpeg, 'BIN: ', getbin(datajpeg))

if error == 0:
    print('\n Congratulations! They are the same!')

print('\n Check Finished\n')

