with open('jpeg.log', 'r') as jpeg:
    jpeg = jpeg.readlines()
with open('mem.log', 'r') as log:
    log = log.readlines()

print('\n')
for i in range(0, len(log)):
    print('\r Checking line: '+str(i),end='')
    if log[i] != jpeg[i]:
        print('\n\nNot Match: log, jpeg')
        print(log[i])
        print(jpeg[i],'\n\n')

print('\n\n Check Finished\n')
