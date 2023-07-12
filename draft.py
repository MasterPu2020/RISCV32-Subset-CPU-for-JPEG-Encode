a = ['   122', '111']


def remove_empty(li:list):
    for i in li:
        if i == '\n':
            li.remove('\n')
        if i == '':
            li.remove('')
        if i == None:
            li.remove(None)
    
    return li

a = '     1'
print(a.lstrip())
