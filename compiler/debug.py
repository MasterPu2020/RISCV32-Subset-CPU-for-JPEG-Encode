import dust

pc = 1110 # 1229
file = 'test.s'
with open(file, 'r') as readfile:
    readfile = readfile.read()
codeline = dust.allocate(readfile, pc)
print()
print('                PC:', pc)
print('Assembly code line:', codeline)
