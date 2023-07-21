
# import json
# import dust
# class setting():
#     def __init__(self) -> None:
#         self.core = 'riscv32s'
#         self.speed = 50e6
#         self.mem = 500000

# # with open('./compiler/config.json','r') as js:
# #     jsobject = json.load(js)
# # print(jsobject)
# with open('./compiler/config0.json','w') as jsp:
#     s = setting()
#     json.dump(s.__dict__, jsp)
# with open('./compiler/config0.json','r') as jsp:
#     jso = json.load(jsp)

# print(jso['core'])

a = './11.1/22.2/33.3/text.nom'
b= a.split('/')
p = ''
f = b[-1].split('.')[0]
for i in range(0,len(b)-1):
    p += b[i] + '/'
print(p, f)