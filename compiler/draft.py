
import dust

with open('./soc/system.s', 'r') as file:
    file = file.read()
print(dust.allocate(file, 809))