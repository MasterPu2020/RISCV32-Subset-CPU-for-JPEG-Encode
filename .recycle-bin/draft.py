
import json
# import dust
# class setting():
#     def __init__(self) -> None:
#         self.core = 'riscv32s'
#         self.speed = 50e6
#         self.mem = 500000

with open('./config.json','r') as js:
    jsobject = json.load(js)
for i in jsobject:
    print(i)
# with open('./compiler/config0.json','w') as jsp:
#     s = setting()
#     json.dump(s.__dict__, jsp)
# with open('./compiler/config0.json','r') as jsp:
#     jso = json.load(jsp)

# print(jso['core'])
