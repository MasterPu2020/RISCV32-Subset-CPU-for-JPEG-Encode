# import basicmath as bm

# all = bm.dc_y_EHUFCO + bm.dc_y_EHUFSI + bm.ac_y_EHUFCO + bm.ac_y_EHUFSI + bm.dc_c_EHUFCO + bm.dc_c_EHUFSI+ bm.ac_c_EHUFCO + bm.ac_c_EHUFSI
# j = 0
# text = '\n[Memory File: 4k x 32bit]\n|'
# for i in range(0, len(all)):
#     text += ' ' * (6 - len(str(all[i]))) + str(all[i]) + '|'
#     j += 1
#     if j == 16:
#         text += '\n|'
#         j = 0

# print(text)

a = [
 4,  2,  2,  3,  4,  5,  7,  8, 10, 16, 16,  0,  0,  0,  0,  0,
 0,  4,  5,  7,  9, 11, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  5,  8, 10, 12, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  6,  9, 12, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  6, 10, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  7, 11, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  7, 12, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  8, 12, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  9, 15, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  9, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0,  9, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0, 10, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0, 10, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0, 11, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
 0, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16,  0,  0,  0,  0,  0,
11, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16]

def detect(table:list, i):
    counter = 0
    detection = 0
    lastdetection = 0
    start = i
    while i < len(table) - 1:
        if table[i] == table[i + 1] - 1:
            detection = 1
        elif table[i] == table[i + 1] + 1:
            detection = 2
        elif table[i] == table[i + 1]:
            detection = 3
        else:
            detection = 0
        if detection != lastdetection and detection != 0 and start != i:
            break
        else:
            lastdetection = detection
            counter += 1
        i += 1
    return counter, lastdetection

for i in range(0,len(a)):
    counter, rule = detect(a,i)
    if (counter > 3):
        if rule == 1:
            print('Increasing!', counter)
        elif rule == 2:
            print('Decreasing!', counter)
        elif rule == 3:
            print('steady!', counter)
