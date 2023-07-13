with open('jpeg.log', 'r') as jpeg:
    jpeg = jpeg.readlines()
with open('mem.log', 'r') as log:
    log = log.readlines()

error = 0

print('\n')
for i in range(0, len(log)-1):
    print('\r Checking line: '+str(i),end='')
    if log[i] != jpeg[i]:
        print('\n\nNot Match: log, jpeg')
        print(log[i])
        print(jpeg[i],'\n\n')
        error += 1

if error == 0:
    print('\n\n Congratulations! They are the same!')

print('\n Check Finished\n')
