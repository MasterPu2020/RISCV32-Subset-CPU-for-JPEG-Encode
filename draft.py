with open('mem1.log', 'r') as log1:
    log1 = log1.readlines()
with open('mem.log', 'r') as log:
    log = log.readlines()

for i in range(0, len(log)):
    if log[i] != log1[i]:
        print('\nNot Match: log, log1')
        print(log[i])
        print(log1[i])

print('\n Check Finished\n')