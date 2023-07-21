# --------------------------------------------------------------------------
# Using UTF-8
# Title: RISCV32 Subset Develop Kit: Dust
# Last Modified Date: 2023/7/20
# Version: 1.0
# Author: Clark Pu
# --------------------------------------------------------------------------

import interface as ui
import json
import compile
import os

# parameters:
from compile import rtype
from compile import itype
from compile import stype
from compile import btype
from compile import opcode
from compile import opbin
from compile import funct7
from compile import funct3

# Verilog style trancation
from compile import tranc

# riscv32s core
class core():

    def __init__(self, size:int=32, memsize:int=2048, frequncy=50e6):
        self.size = size
        self.x = [0] * 32 # registers
        self.pc = 0
        self.mem = [0] * memsize # RAM
        self.freq = frequncy
        self.bitmax = 2**(size) - 1
        self.orneg = - 2**(size - 1)
        self.poserange = range(0, 2**(size-1) - 1)
        self.negrange = range(2**(size-1), 2**(size) - 1)
        self.period = 1 / self.freq
        self.inst = ''
        self.op = 0
        self.infor = 'Core init'
        # execute times
        self.add_ = 0
        self.and_ = 0
        self.or_ = 0
        self.sll_ = 0
        self.sra_ = 0
        self.mul_ = 0
        self.mulh_ = 0
        self.addi_ = 0
        self.xori_ = 0
        self.lw_ = 0
        self.sw_ = 0
        self.beq_ture = 0
        self.beq_false = 0
        self.bne_ture = 0
        self.bne_false = 0
        self.blt_ture = 0
        self.blt_false = 0
        self.bge_ture = 0
        self.bge_false = 0
        self.time = 0

    # trancate to core size
    def intcore(self, value:int):
        value = value & self.bitmax
        if value in self.poserange:
            return value
        else:
            return value | self.orneg
    
    def decode(self):
        inst_opcode = tranc(self.inst,6,0)
        inst_funct7 = tranc(self.inst,31,25)
        inst_funct3 = tranc(self.inst,14,12)
        for op_id in range(0,len(opcode)):
            if inst_opcode == opbin[0]: # r type
                if inst_funct7 == funct7[op_id] and inst_funct3 == funct3[op_id]:
                    self.op = op_id
                    return 0
            elif inst_opcode == opbin[op_id] and inst_funct3 == funct3[op_id]: # other type
                self.op = op_id
                return 0
        self.op = 0
        return 1
    
    # extend signed 12bit
    def int12(self, string:str):
        if string[0] == '1':
            string = '1' * (self.size-12) + string
            return self.intcore(int(string, 2))
        else:
            return int(string, 2)
    
    def imm(self):
        if self.op in itype:
            return self.int12(tranc(self.inst,31,20))
        elif self.op in stype:
            return self.int12(tranc(self.inst,31,25)+tranc(self.inst,11,7))
        elif self.op in btype:
            return self.int12(tranc(self.inst,31)+tranc(self.inst,7)+tranc(self.inst,30,25)+tranc(self.inst,11,8)) >> 1

    def reset(self):
        self.x = [0] * 32 # registers
        self.pc = 0
        self.mem = [0] * len(self.mem) # RAM
        self.add_ = 0
        self.and_ = 0
        self.or_ = 0
        self.sll_ = 0
        self.sra_ = 0
        self.mul_ = 0
        self.mulh_ = 0
        self.addi_ = 0
        self.xori_ = 0
        self.lw_ = 0
        self.sw_ = 0
        self.beq_ture = 0
        self.beq_false = 0
        self.bne_ture = 0
        self.bne_false = 0
        self.blt_ture = 0
        self.blt_false = 0
        self.bge_ture = 0
        self.bge_false = 0
        self.time = 0
        self.infor = 'Core reset'

    def execute(self, inst):
        self.inst = inst
        msg = self.decode()
        if msg == 1:
            self.infor = 'Instruction Decode Failed'
            return 1
        op = opcode[self.op]
        rd = int(tranc(self.inst,11, 7), 2)
        rs1 = int(tranc(self.inst,19,15), 2)
        rs2 = int(tranc(self.inst,24,20), 2)
        srd = ' x' + str(rd) + ' ='
        srs1 = ' x' + str(rs1)
        srs2 = ' x' + str(rs2)
        # r type
        if op == 'add':
            self.x[rd] = self.intcore(self.x[rs1] + self.x[rs2])
            self.infor = srd + srs1 + ' +' + srs2 + '\n'
            self.infor +=  'Rd data replaced by ' + str(self.x[rd]) + '\n'
            self.add_ += 1
            self.pc += 1
        elif op == 'and':
            self.x[rd] = self.intcore(self.x[rs1] & self.x[rs2])
            self.infor = srd + srs1 + ' &' + srs2 + '\n'
            self.infor +=  'Rd data replaced by ' + str(self.x[rd]) + '\n'
            self.and_ += 1
            self.pc += 1
        elif op == 'or':
            self.x[rd] = self.intcore(self.x[rs1] | self.x[rs2])
            self.infor = srd + srs1 + ' |' + srs2 + '\n'
            self.infor +=  'Rd data replaced by ' + str(self.x[rd]) + '\n'
            self.or_ += 1
            self.pc += 1
        elif op == 'sll':
            if self.x[rs2] < 0:
                return 1
            self.x[rd] = self.intcore(self.x[rs1] << self.x[rs2])
            self.infor = srd + srs1 + ' <<' + srs2 + '\n'
            self.infor +=  'Rd data replaced by ' + str(self.x[rd]) + '\n'
            self.sll_ += 1
            self.pc += 1
        elif op == 'sra':
            if self.x[rs2] < 0: # progress protection
                return 1
            self.x[rd] = self.intcore(self.x[rs1] >> self.x[rs2])
            self.infor = srd + srs1 + ' >>' + srs2 + '\n'
            self.infor +=  'Rd data replaced by ' + str(self.x[rd]) + '\n'
            self.sra_ += 1
            self.pc += 1
        elif op == 'mul': # signed multiplication
            if self.x[rs1] * self.x[rs2] < 0:
                self.x[rd] = (self.x[rs1] * self.x[rs2]) | (-2**31)
            else:
                self.x[rd] = (self.x[rs1] * self.x[rs2]) & (2**31-1)
            self.infor = srd + srs1 + ' mul' + srs2 + '\n'
            self.infor +=  'Rd data replaced by ' + str(self.x[rd]) + '\n'
            self.mul_ += 1
            self.pc += 1
        elif op == 'mulh':
            self.x[rd] = self.intcore((self.x[rs1] * self.x[rs2]) >> 31)
            self.infor = srd + srs1 + ' mulh' + srs2 + '\n'
            self.infor +=  'Rd data replaced by ' + str(self.x[rd]) + '\n'
            self.mulh_ += 1
            self.pc += 1
        # i type
        elif op == 'addi':
            self.x[rd] = self.intcore(self.x[rs1] + self.imm())
            self.infor = srd + srs1 + ' + ' + str(self.imm()) + '\n'
            self.infor +=  'Rd data replaced by ' + str(self.x[rd]) + '\n'
            self.addi_ += 1
            self.pc += 1
        elif op == 'xori':
            self.x[rd] = self.intcore(self.x[rs1] ^ self.imm())
            self.infor = srd + srs1 + ' ^ ' + str(self.imm()) + '\n'
            self.infor +=  'Rd data replaced by ' + str(self.x[rd]) + '\n'
            self.xori_ += 1
            self.pc += 1
        elif op == 'lw':
            self.x[rd] = self.mem[self.intcore(self.x[rs1] + self.imm())]
            self.infor = srd + 'mem[' + srs1 + ' + ' + str(self.imm()) + ' ]\n'
            self.infor +=  'Rd data replaced by ' + str(self.x[rd]) + '\n'
            self.lw_ += 1
            self.pc += 1
        # s type
        elif op == 'sw':
            self.mem[self.intcore(self.x[rs1] + self.imm())] = self.x[rs2]
            self.infor = 'mem[' + srs1 + ' + ' + str(self.imm()) + ' ] = ' + srs2 + '\n'
            self.infor += 'mem[' + str(self.x[rs1] + self.imm()) + ' ] = ' + str(self.x[rs2]) + '\n'
            self.sw_ += 1
            self.pc += 1
        # b type, pc is unsigned
        elif op == 'beq':
            self.infor = srs1 + ' ==' + srs2 + ' ? pc + ' + str(self.imm()) + '\n'
            if self.x[rs1] == self.x[rs2]:
                self.pc = self.pc + self.imm()
                self.beq_ture += 1
                self.infor += 'pc jump to ' + str(self.pc) + ' because ' + str(self.x[rs1]) + ' == ' + str(self.x[rs2]) + '\n'
            else:
                self.infor += 'pc increased because ' + str(self.x[rs1]) + ' != ' + str(self.x[rs2]) + '\n'
                self.pc += 1
                self.beq_false += 1
        elif op == 'bne':
            self.infor = srs1 + ' !=' + srs2 + ' ? pc + ' + str(self.imm()) + '\n'
            if self.x[rs1] != self.x[rs2]:
                self.pc = self.pc + self.imm()
                self.bne_ture += 1
                self.infor += 'pc jump to ' + str(self.pc) + ' because ' + str(self.x[rs1]) + ' != ' + str(self.x[rs2]) + '\n'
            else:
                self.infor += 'pc increased because ' + str(self.x[rs1]) + ' == ' + str(self.x[rs2]) + '\n'
                self.pc += 1
                self.bne_false += 1
        elif op == 'blt':
            self.infor = srs1 + ' <' + srs2 + ' ? pc + ' + str(self.imm()) + '\n'
            if self.x[rs1] < self.x[rs2]:
                self.pc = self.pc + self.imm()
                self.blt_ture += 1
                self.infor += 'pc jump to ' + str(self.pc) + ' because ' + str(self.x[rs1]) + ' < ' + str(self.x[rs2]) + '\n'
            else:
                self.infor += 'pc increased because ' + str(self.x[rs1]) + ' >= ' + str(self.x[rs2]) + '\n'
                self.pc += 1
                self.blt_false += 1
        elif op == 'bge':
            self.infor = srs1 + ' >=' + srs2 + ' ? pc + ' + str(self.imm()) + '\n'
            if self.x[rs1] >= self.x[rs2]:
                self.pc = self.pc + self.imm()
                self.bge_ture += 1
                self.infor += 'pc jump to ' + str(self.pc) + ' because ' + str(self.x[rs1]) + ' >= ' + str(self.x[rs2]) + '\n'
            else:
                self.infor += 'pc increased because ' + str(self.x[rs1]) + ' < ' + str(self.x[rs2]) + '\n'
                self.pc += 1
                self.bge_false += 1
        else:
            self.infor = 'Execution Failed'
            return 1
        self.time += 1
        return 0

# compile assembly code
def compile2(fp:str, type='b'):
    try:
        assert os.path.exists(fp), 'File not exsist.'
        with open(fp, 'r') as f:
            f = f.read()
        f = compile.genmem2macro(f)
        f = compile.long2macro(f)
        f = compile.while2macro(f)
        d = compile.if2macro(f)
        if type == 'd':
            return 0, d
        a = compile.demacro(d)
        if type == 'a':
            return 0, a
        b = compile.compile(a)
        if type == 'b':
            return 0, b
        if type == 'h':
            h = compile.bin2mem(b, False)
            return 0, h
        if type == 'v':
            v = compile.bin2mem(b, True)
            return 0, v
        return 1, 'Type Error: no such file type, try: d, a, b, h, v.'
    except AssertionError as Argument:
        return 1, Argument
    except BaseException as Argument:
        return 2, Argument

# Dust UI keywords
class dustkey():

    def __init__(self):
        self.scan = ''
        self.len = 0
        self.words = ['None']
        self.result = ''
        # keywords
        self.syslog = ['log', 'l', '-l', '+l', '-log', '+log']
        self.sysfile = ['file', 'f', '-f', '+f', '-file', '+file']
        self.syscompile = ['compile', '-compile', '+compile', 'com', '-com', '+com']
        self.sysim = ['simulate', '-simulate', '+simulate', 'sim', '-sim', '+sim']
        self.sysclear = ['clear', 'clean', 'empty']
        self.sysmem = ['mem1', 'mem2', 'mem3', 'mem4', 'mem', 'memory']
        self.memhideaddr = [False, False, False, False]
        self.memshow = 0
        self.memradix = [10, 10, 10, 10]
        self.sysquit = ['q', 'quit', 'exit']
        self.syshelp = ['help', 'h', '-h', '-help', 'help:']
        self.syskeywords = ['sys', 'system']
        self.systemhelp = ('system:\n' 
                           '    quit: exit the process.\n'
                           '    help: get helpful information\n'
                           '    clear: clear the console\n')
        self.memoryhelp = ('mem(1~4): is the RAM data window, use follow comman to adjust them:\n'
                            '   + height + number: adjust the window vertical size\n'
                            '   + width + number:  adjust the window horizontal size\n'
                            '   + add: open a new memory window\n'
                            '   + close: close last memory window\n'
                            '   + radix + number:: adjust the radix of address\n'
                            '   + offset + number: adjust the offset of address\n'
                            '   + hide: hide the address\n'
                            '   + show: show the address\n')
        self.loghelp = ('log: This help you save the whole RAM data into a log file:\n'
                            "   + filepath + 'filepath': file path to save the log.\n"
                            '   + save: save the log file.\n'
                            '   + saveq: save the log when simulation finished.\n')
        self.filehelp = ('file: This help you record the code file:\n'
                            "   + filepath + 'filepath': file path to read or save the code file.\n"
                            '   + type: see the recorded file type.\n'
                            '   + read: read the file.\n'
                            '   + save: save the recorded file.\n'
                            '   + saveq: save the file when simulation finished.\n')
        self.compilehelp = ('compile: Compile the recorded file, you should load the file first:\n'
                            "   + d: to demacro file, under level can locate PC.\n"
                            '   + a: to assembly file.\n'
                            '   + b: to binary file.\n'
                            '   + h: to hex file.\n'
                            '   + v: to verilog memory code.\n')
        self.simulatehelp = ('simulate: Start simulation, when simulation is going, following command will be enabled:\n'
                            "   'empty': run a single execution.\n"
                            '   simtime + second: keep running until core reach the simulated time.\n'
                            '   run + number: keep running until core executed the number of the instructions.\n'
                            "[Note: you won't be able to stop running, when it's been started.]\n")


    def analysis(self):
        if len(self.scan.split()) == 0:
            self.words = ['None']
            self.len = 0
            self.result = 'default'
        else:
            self.words = self.scan.lower().split()
            self.len = len(self.words)
            if self.words[0] in self.sysquit:
                self.result = 'quit'
            elif self.words[0] in self.syshelp:
                self.result = 'help'
            elif self.words[0] in self.sysclear:
                self.result = 'clear'
            elif self.words[0] in self.syslog:
                self.result = 'log'
            elif self.words[0] in self.sysmem:
                self.result = 'mem'
            else:
                self.result = 'unknow'

# user setting
class setting():
    def __init__(self):
        self.core = 'riscv32s'
        self.size = 32
        self.memsize = 2048 # RAM
        self.freq = 25e6
        self.memwidth = [8, 8, 8, 8]
        self.memhight = [8, 8, 8, 8]
        self.memoffset = [0, 0, 0, 0]
        self.memhideaddr = [False, False, False, False]

# save mem as log
def savemem(fp:str, mem:list):
    keyword = 'y'
    if fp == '':
        return 1, 'Log file path not added, saving give up.'
    if os.path.exists(fp):
        screen.put('\nWarning Message\n')
        screen.note('Log file already exist, do you want to over write? [y]')
        keyword = screen.display()
    if keyword == 'y':
        text = '[RAM DATA LOG]: created by Dust compiler and simulator.\n'
        for i in range(0, len(mem)):
            text += '[' + str(i) + ']' + ':' + str(mem[i]) + '\n'
        try:
            with open(fp, 'r+') as logp:
                logp.write(text)
        except AssertionError as Argument:
            return 1, Argument
        except BaseException as Argument:
            return 2, Argument
        else:
            return 0, 'Log file saved at ' + fp
    return 0, 'Log file saving give up.'

# save code file
def savecode(fp:str, text:str, type='n'):
    if fp == '':
        return 1, 'Please add a file path first. File saving give up.'
    if file == '':
        return 1, 'File Empty no need to save.'
    keyword = 'y'
    fps= fp.split('/')
    path = ''
    filename = fps[-1].split('.')[0]
    for i in range(0,len(fps)-1):
        path += fps[i] + '/'
    if type == 'n':
        return 1, "Original file, no need to save."
    elif type == 'b':
        newfp = path + filename + '.bin'
    elif type == 'a':
        newfp = path + filename + '.txt'
    elif type == 'h':
        newfp = path + filename + '.hex'
    elif type == 'v':
        newfp = path + filename + '.v'
    elif type == 'd':
        newfp = path + filename + '.dust'
    else:
        return 1, 'Please read a file first.'
    if os.path.exists(newfp):
        screen.put('\nWarning Message\n')
        screen.note('Code file already exist, do you want to over write? [y]')
        keyword = screen.display()
    if keyword == 'y':
        with open(newfp, 'w+') as code:
            code.write(text)
        return 0, 'File saved.'
    else:
        return 0, 'File saving give up.'


# user interface
if __name__ == '__main__':
    # ui setting
    config = setting()
    screen = ui.screens()
    screen.topline = ' D U S T   C O M P I L E R   A N D   S I M U L A T O R '
    screen.note('Welcome using the Dust compiler and simulator. This software is writen by Clark alone!')
    screen.bottomline = '[Input Command]:'
    regbox = ui.boxs(8,4,style='block')
    regbox.insert('[ Register File 32x32-bit ]', 0)
    membox1 = ui.boxs(config.memwidth[0], config.memhight[0],config.memoffset[0], config.memhideaddr[0], style='outline')
    membox1.insert('[ Memory File Block 1 ]', 0)
    membox2 = ui.boxs(config.memwidth[1], config.memhight[1],config.memoffset[1], config.memhideaddr[1], style='outline')
    membox2.insert('[ Memory File Block 2 ]', 0)
    membox3 = ui.boxs(config.memwidth[2], config.memhight[2],config.memoffset[2], config.memhideaddr[2], style='outline')
    membox3.insert('[ Memory File Block 3 ]', 0)
    membox4 = ui.boxs(config.memwidth[3], config.memhight[3],config.memoffset[3], config.memhideaddr[3], style='outline')
    membox4.insert('[ Memory File Block 4 ]', 0)
    screen.put()
    screen.put('Information area: use help to see command usage')
    screen.put()
    # read code file
    file = ''
    filetype = '-'
    filepath = ''
    savefile = False
    wlog = ''
    wlogpath = ''
    rlog = ['']
    rlogpath = ['']
    logmem = []
    savelog = False
    # simulation riscv core
    riscv = core(32,2048,25e6)
    # system status
    simulating = 'stopped'
    # program start
    key = dustkey()
    while True:

        key.scan = screen.display()
        # -------------------------------------
        key.analysis()
        # -------------------------------------
        if key.result == 'quit':
            screen.clear()
            if savelog:
                code, arg = savemem(riscv.mem)
                if code == 0:
                    print('[ memory log saved ]')
                else:
                    print('[ memory log saving failed: ]',arg)
            if savefile:
                code, arg = savecode(filepath, file, filetype)
                if code == 0:
                    print('[ file saved ]')
                else:
                    print('[ file saving failed: ]',arg)
            exit('\n [ Process Finished ] \n')
        elif key.result == 'help':
            if key.len == 1:
                screen.note('use help + system, memory, log, simulate, compile, file, to see in detail.')
            elif key.words[1] in key.syskeywords:
                screen.note(key.systemhelp)
            elif key.words[1] in key.sysmem:
                screen.note(key.memoryhelp)
            elif key.words[1] in key.syslog:
                screen.note(key.loghelp)
            elif key.words[1] in key.sysfile:
                screen.note(key.filehelp)
            elif key.words[1] in key.syscompile:
                screen.note(key.compilehelp)
            elif key.words[1] in key.sysim:
                screen.note(key.simulatehelp)
            else:
                screen.note('Unknown help command: use help + system, memory, log, simulate, compile, file')
        elif key.result == 'log':
            if key.len != 2 or key.len != 3:
                screen.note(key.loghelp)
            elif key.words[1] == 'filepath':
                if key.len != 3:
                    screen.note("use log filepath '/filepath/' : load the file path to save the log.")
                else:
                    logpath = key.words[2]
            elif key.words == 'save':
                code, arg = savemem(logpath)
                screen.note(arg)
            elif key.words == 'saveq':
                savelog = True
                screen.note("Log file will be saved after simulation or program quit.")
            else:
                screen.note(key.loghelp)
        elif key.result == 'mem':
            if compile.is_int(key.words[0][3:]):
                memindex = int(key.words[0][3:])
                if memindex > 4:
                    screen.note('Memory window cannot open more than 4. use mem(1~4)')
            else:
                memindex = 0
            if key.len == 3 and compile.is_int(key.words[2]) and memindex != 0:
                if key.words[1] == 'height':
                    if memindex == 1:
                        membox1.height = int(key.words[2])
                    elif memindex == 2:
                        membox2.height = int(key.words[2])
                    elif memindex == 3:
                        membox2.height = int(key.words[2])
                    elif memindex == 4:
                        membox4.height = int(key.words[2])
                    screen.note('Memory window '+str(memindex)+' height adjust to ' + key.words[2])
                elif key.words[1] == 'width':
                    if memindex == 1:
                        membox1.width = int(key.words[2])
                    elif memindex == 2:
                        membox2.width = int(key.words[2])
                    elif memindex == 3:
                        membox2.width = int(key.words[2])
                    elif memindex == 4:
                        membox4.width = int(key.words[2])
                    screen.note('Memory window '+str(memindex)+' width adjust to ' + key.words[2])
                elif key.words[1] == 'offset':
                    if memindex == 1:
                        membox1.indexoffset = int(key.words[2])
                    elif memindex == 2:
                        membox2.indexoffset = int(key.words[2])
                    elif memindex == 3:
                        membox2.indexoffset = int(key.words[2])
                    elif memindex == 4:
                        membox4.indexoffset = int(key.words[2])
                    screen.note('Memory window '+str(memindex)+' offset adjust to ' + key.words[2])
                elif key.words[1] == 'radix':
                    if memindex == 1:
                        membox1.indexformat = int(key.words[2])
                    elif memindex == 2:
                        membox2.indexformat = int(key.words[2])
                    elif memindex == 3:
                        membox2.indexformat = int(key.words[2])
                    elif memindex == 4:
                        membox4.indexformat = int(key.words[2])
                    screen.note('Memory window '+str(memindex)+' address radix adjust to ' + key.words[2])
                else:
                    screen.note(key.memoryhelp)
            elif key.len == 2:
                if key.words[1] == 'add':
                    if  key.memshow < 4:
                        key.memshow += 1
                        screen.note('Memory window add to '+str(key.memshow)+'.')
                    else:
                        screen.note('Memory window cannot open more than 4.')
                elif key.words[1] == 'close':
                    if  key.memshow != 0:
                        key.memshow -= 1
                        screen.note('Memory window closed to '+str(key.memshow)+'.')
                    else:
                        screen.note('All the memory window aleady been closed.')
                elif key.words[1] == 'hide' and memindex != 0:
                    if memindex == 1:
                        membox1.hideindex = True
                    elif memindex == 2:
                        membox2.hideindex = True
                    elif memindex == 3:
                        membox2.hideindex = True
                    elif memindex == 4:
                        membox4.hideindex = True
                    screen.note('Memory window '+str(memindex)+' address hidden.')
                elif key.words[1] == 'show' and memindex != 0:
                    if memindex == 1:
                        membox1.hideindex = False
                    elif memindex == 2:
                        membox2.hideindex = False
                    elif memindex == 3:
                        membox2.hideindex = False
                    elif memindex == 4:
                        membox4.hideindex = False
                    screen.note('Memory window '+str(memindex)+' address show.')
                else:
                    screen.note(key.memoryhelp)
            else:
                screen.note(key.memoryhelp)
        elif key.result == 'clear':
            screen.note('Welcome using the Dust compiler and simulator. This software is writen by Clark alone!')
        elif key.result == 'file':
            if key.len != 2 or key.len != 3:
                screen.note(key.filehelp)
            elif key.words[1] == 'filepath':
                if key.len != 3:
                    screen.note("use file filepath '/filepath/' : load the file path to open the code file.")
                else:
                    if os.path.exists(key.words[2]) and '/' in key.words[2]:
                        filepath = key.words[2]
                        filetype = 'n'
                        screen.note('File path added')
                        if logpath == '':
                            lps = key.words[2].split('/')
                            lname = lps[-1].split('.')[0]
                            for i in range(0,len(lps)-1):
                                logpath += lps[i] + '/'
                            logpath += lname + '.log'
                            screen.note('Log path auto-updated: ' + logpath, False)
                    else:
                        screen.note('File path not exist, try add ./')
            elif key.words == 'type':
                if filetype == 'n':
                    screen.note('New file, analysis required.')
                elif filetype == 'a':
                    screen.note('Assembly code.')
                elif filetype == 'b':
                    screen.note('Binary machine code.')
                elif filetype == 'h':
                    screen.note('Hexdecimal machine code with address.')
                elif filetype == 'v':
                    screen.note('Verilog memory code.')
                elif filetype == 'd':
                    screen.note('Macro level assembly code.')
                else:
                    screen.note('No file added. Please read a file first')
            elif key.words == 'save':
                code, arg = savecode(filepath, file, filetype)
                screen.note(arg)
            elif key.words == 'saveq':
                savefile = True
                screen.note("Code file will be saved after program quit.")
            else:
                screen.note(key.filehelp)

        # -------------------------------------
        # command execute
        # -------------------------------------
        screen.put()
        if simulating == 'running':
            screen.put(regbox.show(riscv.x))
            screen.put()

        if key.memshow == 1:
            if simulating == 'stopped' and len(logmem) >= 1:
                screen.put(membox1.show(logmem[0]))
            else:
                screen.put(membox1.show(riscv.mem))
        elif key.memshow == 2:
            if simulating == 'stopped' and len(logmem) >= 2:
                screen.put(membox1.show(logmem[0]))
                screen.put(membox2.show(logmem[1]))
            elif simulating == 'stopped' and len(logmem) >= 1:
                screen.put(membox1.show(logmem[0]))
                screen.put(membox2.show(riscv.mem))
            else:
                screen.put(membox1.show(riscv.mem))
                screen.put(membox2.show(riscv.mem))
        elif key.memshow == 3:
            if simulating == 'stopped' and len(logmem) >= 3:
                screen.put(membox1.show(logmem[0]))
                screen.put(membox2.show(logmem[1]), True)
                screen.put(membox3.show(logmem[2]))
            if simulating == 'stopped' and len(logmem) >= 2:
                screen.put(membox1.show(logmem[0]))
                screen.put(membox2.show(logmem[1]), True)
                screen.put(membox3.show(riscv.mem))
            elif simulating == 'stopped' and len(logmem) >= 1:
                screen.put(membox1.show(logmem[0]))
                screen.put(membox2.show(riscv.mem), True)
                screen.put(membox3.show(riscv.mem))
            else:
                screen.put(membox1.show(riscv.mem))
                screen.put(membox2.show(riscv.mem), True)
                screen.put(membox3.show(riscv.mem))
        elif key.memshow == 4:
            if simulating == 'stopped' and len(logmem) >= 4:
                screen.put(membox1.show(logmem[0]))
                screen.put(membox2.show(logmem[1]), True)
                screen.put(membox3.show(logmem[2]))
                screen.put(membox4.show(logmem[3]), True)
            if simulating == 'stopped' and len(logmem) >= 3:
                screen.put(membox1.show(logmem[0]))
                screen.put(membox2.show(logmem[1]), True)
                screen.put(membox3.show(logmem[2]))
                screen.put(membox4.show(riscv.mem), True)
            if simulating == 'stopped' and len(logmem) >= 2:
                screen.put(membox1.show(logmem[0]))
                screen.put(membox2.show(logmem[1]), True)
                screen.put(membox3.show(riscv.mem))
                screen.put(membox4.show(riscv.mem), True)
            elif simulating == 'stopped' and len(logmem) >= 1:
                screen.put(membox1.show(logmem[0]))
                screen.put(membox2.show(riscv.mem), True)
                screen.put(membox3.show(riscv.mem))
                screen.put(membox4.show(riscv.mem), True)
            else:
                screen.put(membox1.show(riscv.mem))
                screen.put(membox2.show(riscv.mem), True)
                screen.put(membox3.show(riscv.mem))
                screen.put(membox4.show(riscv.mem), True)
        screen.put()
        # if simulating == 'running':
