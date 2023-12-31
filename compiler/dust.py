# --------------------------------------------------------------------------
# Using UTF-8
# Title: RISCV32 Subset Develop Kit: Dust
# Last Modified Date: 2023/7/20
# Version: 2.0
# Author: Clark Pu
# --------------------------------------------------------------------------

import interface as ui
import json
import compile
import os
import time

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
        self.mem = [0] * (memsize + 1) # RAM
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
            self.infor = srd + 'mem[' + srs1 + ' + ' + str(self.imm()) + ']\n'
            self.infor +=  'Rd data replaced by ' + str(self.x[rd]) + '\n'
            self.lw_ += 1
            self.pc += 1
        # s type
        elif op == 'sw':
            self.mem[self.intcore(self.x[rs1] + self.imm())] = self.x[rs2]
            self.infor = 'mem[' + srs1 + ' + ' + str(self.imm()) + '] = ' + srs2 + '\n'
            self.infor += 'mem[' + str(self.x[rs1] + self.imm()) + '] = ' + str(self.x[rs2]) + '\n'
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
            self.infor = 'Opcode type not find'
            return 1
        self.time += 1
        return 0

    def runtime(self):
        return round(self.time * self.period, 4)

    def status(self):
        text  = ' +----------------------------------+\n'
        text += '  [Core status]: ' + str(self.infor) + '\n'
        text += '  [Program counter]: ' + str(self.pc) + '\n'
        text += '    Add: ' + str(self.add_ )
        text += '    And: ' + str(self.and_ )
        text += '    Or : ' + str(self.or_ ) 
        text += '    Sll: ' + str(self.sll_ ) + '\n'
        text += '    Sra: ' + str(self.sra_ ) 
        text += '    Mul: ' + str(self.mul_ )
        text += '   Mulh: ' + str(self.mulh_) 
        text += '   AddI: ' + str(self.addi_) + '\n'
        text += '   XorI: ' + str(self.xori_)
        text += '     Lw: ' + str(self.lw_ )
        text += '     Sw: ' + str(self.sw_ ) + '\n'
        text += '   Beq True:  ' + str(self.beq_ture ) + '\n'
        text += '       False: ' + str(self.beq_false) + '\n'
        text += '   Bne True:  ' + str(self.bne_ture ) + '\n'
        text += '       False: ' + str(self.bne_false) + '\n'
        text += '   Blt True:  ' + str(self.blt_ture ) + '\n'
        text += '       False: ' + str(self.blt_false) + '\n'
        text += '   Bge True:  ' + str(self.bge_ture ) + '\n'
        text += '       False: ' + str(self.bge_false) + '\n'
        text += ' +----------------------------------+\n'
        text += '  [Total Executions]: ' + str(self.time) + '\n'
        text += '  [Simulation time]:  ' + str(self.runtime()) + '\n'
        text += ' +----------------------------------+\n'
        return text

# compile assembly code
def compile2(f:str, type='b'):
    try:
        assert f != '', 'Empty file.'
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
        return 1, str(Argument)
    except BaseException as Argument:
        return 2, str(Argument)

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
        self.syscompile = ['compile', '-compile', '+compile', 'com', '-com', '+com', 'c']
        self.sysim = ['simulate', '-simulate', '+simulate', 'sim', '-sim', '+sim']
        self.sysclear = ['clear', 'clean', 'empty']
        self.sysmem = ['mem1', 'mem2', 'mem3', 'mem4', 'mem', 'memory']
        self.syscore = ['core', 'riscv', 'riscv32s', 'cpu']
        self.sysreadlog = ['read', 'r', 'rlog', 'readlog', 'rl']
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
                            '   + radix + number: adjust the radix of address\n'
                            '   + offset + number: adjust the offset of address\n'
                            '   + hide: hide the address\n'
                            '   + show: show the address\n'
                            '   + size: set the core memory size\n')
        self.loghelp = ('log: This help you save the whole RAM data into a log file:\n'
                            "   + filepath + 'filepath': file path to save the log.\n"
                            '   + save: save the log file.\n'
                            '   + saveq: save the log when simulation finished.\n')
        self.filehelp = ('file: This help you record the code file:\n'
                            "   + filepath + 'filepath': file path to read or save the code file.\n"
                            '   + type: see the recorded file type.\n'
                            '   + read: read the file.\n'
                            '   + save: save the recorded file.\n'
                            '   + locatepc: locate the PC position represented in demacro code file\n'
                            '   + locatefile: locate the file code position represented machine code\n'
                            '   + save: save the recorded file.\n'
                            '   + saveq: save the file when simulation finished.\n')
        self.compilehelp = ('compile: Compile the recorded file, you should load the file first:\n'
                            "   + d: to demacro file, under level can locate PC.\n"
                            '   + a: to assembly file.\n'
                            '   + b: to binary file.\n'
                            '   + h: to hex file.\n'
                            '   + v: to verilog memory code.\n')
        self.corehelp = ('core: see or set the CPU core status:\n'
                            "   + reset: reset the core\n"
                            '   + status: show CPU status.\n')
        self.readloghelp = ('readlog: This help you load your past RAM log and look at it in memory window:\n'
                            "   + 'filepath' : read the logged memory.\n"
                            '   + clear : clear all the read memory log.\n'
                            '   + load log-index start-address end-address to start-address end-address: load the logged memory fragments into riscv memory.\n'
                            '   + compare + log-index1 + log-index2: find the different memory data between logs. number = 0 as this riscv memory\n')
        self.simulatehelp = ('simulate: Start simulation, when simulation is going, following command will be enabled:\n'
                            "   'empty': run a single execution.\n"
                            '   status: show CPU status.\n'
                            '   stop: stop CPU process and reset CPU.\n'
                            '   set: set stop when PC reach the value.\n'
                            '   simtime + second: keep running until core reach the simulated time.\n'
                            '   run + number: keep running until core executed the number of the instructions.\n'
                            "[Note: you won't be able to interrupt the running, try not to set simtime too long]\n")

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
            elif self.words[0] in self.sysfile:
                self.result = 'file'
            elif self.words[0] in self.syscompile:
                self.result = 'compile'
            elif self.words[0] in self.sysim:
                self.result = 'sim'
            elif self.words[0] in self.syscore:
                self.result = 'core'
            elif self.words[0] in self.sysreadlog:
                self.result = 'readlog'
            else:
                self.result = 'unknown'

# user setting
class setting():

    def __init__(self):
        self.configpath = './config.json'
        self.core = 'riscv32s'
        self.size = 32
        self.memsize = 2048 # RAM
        self.freq = 25e6
        self.memwidth = [8, 8, 8, 8]
        self.memheight = [8, 8, 8, 8]
        self.memoffset = [0, 0, 0, 0]
        self.memhideaddr = [False, False, False, False]
        self.filepath = ''
        self.instructions = []
        self.instlen = 0
        self.wlogpath = ''
        self.logmem = []
        self.memshow = 0
        self.readlogload = [0,0,0,0,0]
        self.memhideaddr = [False, False, False, False]
        self.memradix = [10, 10, 10, 10]
        self.show_core_status = False
        self.defile = ''

    def preset(self):
        if os.path.isfile(self.configpath):
            try:
                with open(self.configpath, 'r') as configf:
                    c = json.load(configf)
                self.core = c.get('core')
                self.size = c.get('size')
                self.memsize = c.get('memsize') # RAM
                self.freq = c.get('freq')
                self.memwidth = c.get('memwidth')
                self.memheight = c.get('memheight')
                self.memoffset = c.get('memoffset')
                self.memhideaddr =  c.get('memhideaddr')
                self.filepath = c.get('filepath')
                self.wlogpath = c.get('wlogpath')
                self.logmem = c.get('logmem')
                self.instructions = c.get('instructions')
                self.readlogload = c.get('readlogload')
                self.instlen = c.get('instlen')
                self.memshow = c.get('memshow')
                self.show_core_status = c.get('show_core_status')
                self.memhideaddr = c.get('memhideaddr')
                self.memradix = c.get('memradix')
                self.defile = c.get('defile')
                for i in self.__dict__:
                    assert c.get(i) != None, 'Load setting failed: configuration items lackage.'
                return "\nLoad last configuration finished. \n(In case if you don't like it, just delete the config.json file)\n\n"
            except BaseException as Argument:
                self.reset()
                self.save()
                return '\nLoad setting failed:\n ' + str(Argument) + '\n\n'
        else :
            self.reset()
            self.save()
            return '\nLoad setting failed: config.json not exist\n\n'

    def reset(self):
        self.core = 'riscv32s'
        self.size = 32
        self.memsize = 2048 # RAM
        self.freq = 25e6
        self.memwidth = [8, 8, 8, 8]
        self.memheight = [8, 8, 8, 8]
        self.memoffset = [0, 0, 0, 0]
        self.memhideaddr = [False, False, False, False]
        self.filepath = ''
        self.wlogpath = ''
        self.logmem = []
        self.readlogload = [0,0,0,0,0]
        self.instructions = []
        self.instlen = 0
        self.memshow = 0
        self.memhideaddr = [False, False, False, False]
        self.memradix = [10, 10, 10, 10]
        self.show_core_status = False
        self.defile = ''

    def save(self):
        newconfig = self.__dict__
        with open(self.configpath, 'w') as configf:
            json.dump(newconfig, configf)
        return

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
        text = '[RAM DATA LOG]: Created by Dust compiler and simulator.\n'
        for i in range(0, len(mem)):
            text += '[' + str(i) + ']' + ' : ' + str(mem[i]) + '\n'
        try:
            with open(fp, 'w+') as logp:
                logp.write(text)
        except AssertionError as Argument:
            return 1, str(Argument)
        except BaseException as Argument:
            return 2, str(Argument)
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

# read the logged memory
def readmem(fp:str):
    if os.path.isfile(fp):
        with open(fp, 'r+') as logp:
            texts = logp.readlines()
        newmem = []
        for line in texts:
            try:
                data = line.split(':')[-1].replace(' ', '').replace('\n', '')
                if compile.is_int(data):
                    newmem.append(int(data))
                elif data == 'x':
                    newmem.append(0)
            except BaseException as Argument:
                return 1, 'Failed: '+str(Argument)
        if len(newmem) != 0:
            return 0, newmem
        else:
            return 1, 'File does not have memory information.'
    else:
        return 1, 'File not exist.'

# show location
def showlocation(defile, line:int, is_pc=True):
    if defile == '':
        return 0, 'Error: no demacro file, try compile first.'
    if is_pc:
        codeline = compile.locate_file(defile, line)
    else:
        codeline = line - 1
        pc = compile.locate_pc(defile, line)
    texts = defile.split('\n')
    texts.pop()
    if codeline - 10 < 0:
        startline = 0
    else:
        startline = codeline - 10
    if len(texts) < codeline + 10:
        endline = len(texts)
    else:
        endline = codeline + 10
    text = ''
    for i in range(startline, endline):
        if i != codeline:
            text += str(i+1) + ':    ' + texts[i] + '\n'
        else:
            text += str(i+1) + ': -> ' + texts[i] + ' <-\n'
    if not is_pc:
        codeline = pc
    return codeline, text

# user interface
if __name__ == '__main__':
    # ui setting
    config = setting()
    screen = ui.screens()
    arg = config.preset()
    screen.put('\n\nDust initiation infor:\n')
    screen.put(arg)
    for text in config.__dict__:
        screen.put(' > '+text+' : '+str(config.__dict__.get(text)))
    screen.topline = ' D U S T   C O M P I L E R   A N D   S I M U L A T O R '
    screen.note('Welcome using the Dust compiler and simulator. This software is writen by Clark alone!')
    screen.bottomline = '[Input Command]:'
    regbox = ui.boxs(8,4,style='block')
    regbox.insert('[ Register File 32x32-bit ]', 0)
    membox1 = ui.boxs(config.memwidth[0], config.memheight[0],config.memoffset[0], config.memhideaddr[0], style='outline')
    membox1.insert('[ Memory File Block 1 ]', 0)
    membox2 = ui.boxs(config.memwidth[1], config.memheight[1],config.memoffset[1], config.memhideaddr[1], style='outline')
    membox2.insert('[ Memory File Block 2 ]', 0)
    membox3 = ui.boxs(config.memwidth[2], config.memheight[2],config.memoffset[2], config.memhideaddr[2], style='outline')
    membox3.insert('[ Memory File Block 3 ]', 0)
    membox4 = ui.boxs(config.memwidth[3], config.memheight[3],config.memoffset[3], config.memhideaddr[3], style='outline')
    membox4.insert('[ Memory File Block 4 ]', 0)
    membox1.indexformat = config.memradix[0]
    membox1.hideindex   = config.memhideaddr[0]
    membox2.indexformat = config.memradix[1]
    membox2.hideindex   = config.memhideaddr[1]
    membox3.indexformat = config.memradix[2]
    membox3.hideindex   = config.memhideaddr[2]
    membox4.indexformat = config.memradix[3]
    membox4.hideindex   = config.memhideaddr[3]
    memshow = config.memshow
    screen.put('\nInformation area: use help to see command usage')
    screen.infor_edge = '+2'
    # read code file
    file = ''
    defile = config.defile
    instructions = config.instructions
    instlen = config.instlen
    filetype = '-'
    filepath = config.filepath
    savefile = False
    wlog = ''
    wlogpath = config.wlogpath
    logmem = config.logmem
    savelog = False
    # simulation riscv core
    riscv = core(config.size,config.memsize,config.freq)
    # system status
    simulating = 'stopped'
    systime = 0
    goto_excutime = 0
    excucounter = 0
    show_core_status = config.show_core_status
    setpc = None
    key = dustkey()
    # display membox
    def putmem():
        if memshow == 1:
            if simulating == 'stopped' and len(logmem) >= 1:
                screen.put(membox1.show(logmem[0]),center=True)
            else:
                screen.put(membox1.show(riscv.mem),center=True)
        elif memshow == 2:
            if simulating == 'stopped' and len(logmem) >= 2:
                screen.put(membox1.show(logmem[1]),center=True)
                screen.put(membox2.show(logmem[0]),center=True)
            elif simulating == 'stopped' and len(logmem) >= 1:
                screen.put(membox1.show(riscv.mem),center=True)
                screen.put(membox2.show(logmem[0]),center=True)
            else:
                screen.put(membox1.show(riscv.mem),center=True)
                screen.put(membox2.show(riscv.mem),center=True)
        elif memshow == 3:
            if simulating == 'stopped' and len(logmem) >= 3:
                screen.put(membox1.show(logmem[2]))
                screen.put(membox2.show(logmem[1]), True)
                screen.put(membox3.show(logmem[0]))
            if simulating == 'stopped' and len(logmem) >= 2:
                screen.put(membox1.show(riscv.mem))
                screen.put(membox2.show(logmem[1]), True)
                screen.put(membox3.show(logmem[0]))
            elif simulating == 'stopped' and len(logmem) >= 1:
                screen.put(membox1.show(riscv.mem))
                screen.put(membox2.show(riscv.mem), True)
                screen.put(membox3.show(logmem[0]))
            else:
                screen.put(membox1.show(riscv.mem))
                screen.put(membox2.show(riscv.mem), True)
                screen.put(membox3.show(riscv.mem))
        elif memshow == 4:
            if simulating == 'stopped' and len(logmem) >= 4:
                screen.put(membox1.show(logmem[3]))
                screen.put(membox2.show(logmem[2]), True)
                screen.put(membox3.show(logmem[1]))
                screen.put(membox4.show(logmem[0]), True)
            if simulating == 'stopped' and len(logmem) >= 3:
                screen.put(membox1.show(riscv.mem))
                screen.put(membox2.show(logmem[2]), True)
                screen.put(membox3.show(logmem[1]))
                screen.put(membox4.show(logmem[0]), True)
            if simulating == 'stopped' and len(logmem) >= 2:
                screen.put(membox1.show(riscv.mem))
                screen.put(membox2.show(riscv.mem), True)
                screen.put(membox3.show(logmem[1]))
                screen.put(membox4.show(logmem[0]), True)
            elif simulating == 'stopped' and len(logmem) >= 1:
                screen.put(membox1.show(riscv.mem))
                screen.put(membox2.show(riscv.mem), True)
                screen.put(membox3.show(riscv.mem))
                screen.put(membox4.show(logmem[0]), True)
            else:
                screen.put(membox1.show(riscv.mem))
                screen.put(membox2.show(riscv.mem), True)
                screen.put(membox3.show(riscv.mem))
                screen.put(membox4.show(riscv.mem), True)
    
    #-------------------------------------
    # program start
    #-------------------------------------

    while True:

        # -------------------------------------
        # Pause and input
        # -------------------------------------

        if simulating != 'running':
            key.scan = screen.display()
            key.analysis()
            screen.note('')
            if key.result == 'quit':
                screen.clear()
                print()
                if savelog:
                    code, arg = savemem(wlogpath, riscv.mem)
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
                try:
                    config.memwidth = [membox1.width,membox2.width,membox3.width,membox4.width]
                    config.memheight = [membox1.height,membox2.height,membox3.height,membox4.height]
                    config.memoffset = [membox1.indexoffset,membox2.indexoffset,membox3.indexoffset,membox4.indexoffset]
                    config.memhideaddr = [membox1.hideindex,membox2.hideindex,membox3.hideindex,membox4.hideindex]
                    config.memshow = memshow
                    config.filepath = filepath
                    config.wlogpath = wlogpath
                    config.logmem = logmem
                    config.instructions = instructions
                    config.instlen = instlen
                    config.memradix[0] = membox1.indexformat 
                    config.memhideaddr[0] = membox1.hideindex  
                    config.memradix[1] = membox2.indexformat 
                    config.memhideaddr[1] = membox2.hideindex 
                    config.memradix[2] = membox3.indexformat 
                    config.memhideaddr[2] = membox3.hideindex 
                    config.memradix[3] = membox4.indexformat
                    config.memhideaddr[3] = membox4.hideindex
                    config.show_core_status = show_core_status
                    config.defile = defile
                    config.save()
                except BaseException as arg:
                    print('[ Configuration failed ]: '+str(arg))
                else:
                    print('[ Configuration saved ]')
                exit('[ Process Finished ] \n')
            elif key.result == 'help':
                if key.len == 1:
                    screen.note('use help + system, memory, log, simulate, compile, file, core, readlog, to see in detail.')
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
                elif key.words[1] in key.syscore:
                    screen.note(key.corehelp)
                elif key.words[1] in key.sysreadlog:
                    screen.note(key.readloghelp)
                else:
                    screen.note('Unknown help command: use help + system, memory, log, simulate, compile, file, core, readlog')
            elif key.result == 'log':
                if key.len == 2 or key.len == 3:
                    if key.words[1] == 'filepath' or key.words[1] == 'fp':
                        if key.len != 3:
                            screen.note("use log filepath '/filepath/' : load the file path to save the log.")
                        else:
                            wlogpath = key.words[2]
                            screen.note("Log filepath added.")
                    elif key.words[1] == 'save':
                        code, arg = savemem(wlogpath, riscv.mem)
                        screen.note(arg)
                    elif key.words[1] == 'saveq':
                        savelog = True
                        screen.note("Log file will be saved after simulation or program quit.")
                else:
                    screen.note('Log command unknown')
                    screen.note(key.loghelp, False)
            elif key.result == 'mem':
                if compile.is_int(key.words[0][3:]):
                    memindex = int(key.words[0][3:])
                    if memindex > 4:
                        screen.note('Memory window cannot open more than 4. use mem(1~4)')
                else:
                    memindex = 0
                if key.len == 3 and compile.is_int(key.words[2]) and memindex != 0:
                    if key.words[1] == 'height' or key.words[1] == 'h':
                        if memindex == 1:
                            membox1.height = int(key.words[2])
                        elif memindex == 2:
                            membox2.height = int(key.words[2])
                        elif memindex == 3:
                            membox3.height = int(key.words[2])
                        elif memindex == 4:
                            membox4.height = int(key.words[2])
                        screen.note('Memory window '+str(memindex)+' height adjust to ' + key.words[2])
                    elif key.words[1] == 'width' or key.words[1] == 'w':
                        if memindex == 1:
                            membox1.width = int(key.words[2])
                        elif memindex == 2:
                            membox2.width = int(key.words[2])
                        elif memindex == 3:
                            membox3.width = int(key.words[2])
                        elif memindex == 4:
                            membox4.width = int(key.words[2])
                        screen.note('Memory window '+str(memindex)+' width adjust to ' + key.words[2])
                    elif key.words[1] == 'offset' or key.words[1] == 'off':
                        if memindex == 1:
                            membox1.indexoffset = int(key.words[2])
                        elif memindex == 2:
                            membox2.indexoffset = int(key.words[2])
                        elif memindex == 3:
                            membox3.indexoffset = int(key.words[2])
                        elif memindex == 4:
                            membox4.indexoffset = int(key.words[2])
                        screen.note('Memory window '+str(memindex)+' offset adjust to ' + key.words[2])
                    elif key.words[1] == 'radix':
                        if memindex == 1:
                            membox1.indexformat = int(key.words[2])
                        elif memindex == 2:
                            membox2.indexformat = int(key.words[2])
                        elif memindex == 3:
                            membox3.indexformat = int(key.words[2])
                        elif memindex == 4:
                            membox4.indexformat = int(key.words[2])
                        screen.note('Memory window '+str(memindex)+' address radix adjust to ' + key.words[2])
                    else:
                        screen.note(key.memoryhelp)
                elif key.len == 3 and key.words[1] == 'size' and compile.is_int(key.words[2]):
                    config.memsize = int(key.words[2])
                    screen.note('RAM size set to '+key.words[2]+'. Restart Dust to apply setting.')
                elif key.len == 2:
                    if key.words[1] == 'add':
                        if  memshow < 4:
                            memshow += 1
                            screen.note('Memory window add to '+str(memshow)+'.')
                        else:
                            screen.note('Memory window cannot open more than 4.')
                    elif key.words[1] == 'close':
                        if  memshow != 0:
                            memshow -= 1
                            screen.note('Memory window closed to '+str(memshow)+'.')
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
                screen.put('')
                screen.note('clear screen')
            elif key.result == 'file':
                if key.len == 2 or key.len == 3:
                    if key.words[1] == 'filepath' or key.words[1] == 'fp':
                        if key.len != 3:
                            screen.note("use file filepath '/filepath/' : load the file path to open the code file.")
                        else:
                            if os.path.isfile(key.words[2]) and '/' in key.words[2]:
                                filepath = key.words[2]
                                screen.note('File path added')
                                if wlogpath == '':
                                    lps = key.words[2].split('/')
                                    lname = lps[-1].split('.')[0]
                                    for i in range(0,len(lps)-1):
                                        wlogpath += lps[i] + '/'
                                    wlogpath += lname + '.log'
                                    screen.note('Log path auto-updated: ' + wlogpath, False)
                                with open(filepath, 'r') as fcode:
                                    file = fcode.read()
                                screen.put('\n [ R e a d   f i l e ] \n\n')
                                screen.put(file)
                                screen.note('File read.', False)
                                mark = filepath.split('.')[-1]
                                if mark == 'bin':
                                    filetype = 'b'
                                elif mark == 'v' or mark == 'sv':
                                    filetype = 'v'
                                elif mark == 'hex':
                                    filetype = 'h'
                                else:
                                    filetype = 'n'
                                screen.note('File type: '+filetype, False)
                            else:
                                screen.note('File path not exist. (try add ./ )')
                    elif key.words[1] == 'type':
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
                    elif key.words[1] == 'save':
                        code, arg = savecode(filepath, file, filetype)
                        screen.note(arg)
                    elif key.words[1] == 'saveq':
                        savefile = True
                        screen.note("Code file will be saved after program quit.")
                    elif key.words[1] == 'read' or key.words[1] == 'r':
                        if os.path.isfile(filepath):
                            with open(filepath, 'r') as fcode:
                                file = fcode.read()
                            screen.put('\n [ R e a d   f i l e ] \n\n')
                            screen.put(file)
                            screen.note('File read.')
                            mark = filepath.split('.')[-1]
                            if mark == 'bin':
                                filetype = 'b'
                            elif mark == 'v' or mark == 'sv':
                                filetype = 'v'
                            elif mark == 'hex':
                                filetype = 'h'
                            else:
                                filetype = 'n'
                            screen.note('File type: '+filetype, False)
                        else:
                            screen.note('File path not exist. Try adding a new file path.')
                    elif key.words[1] == 'locatepc' or key.words[1] == 'locate' or key.words[1] == 'lpc':
                        if key.len == 3 and compile.is_int(key.words[2]):
                            line, text = showlocation(defile, int(key.words[2]))
                            screen.put(text)
                            screen.note('At code line: '+str(line))
                        else:
                            line, text = showlocation(defile, riscv.pc)
                            screen.put(text)
                            screen.note('At code line: '+str(line))
                    elif key.len == 3 and (key.words[1] == 'locatefile' or key.words[1] == 'lf' or key.words[1] == 'locatef'):
                        if compile.is_int(key.words[2]):
                            line, text = showlocation(defile, int(key.words[2]), False)
                            screen.put(text)
                            screen.note('PC is: '+str(line))
                        else:
                            screen.note('Locate file need an integer value.')
                    else:
                        screen.note('File command unknown')
                        screen.note(key.filehelp, False)
                else:
                    screen.note('File command unknown')
                    screen.note(key.filehelp, False)
            elif key.result == 'compile':
                if key.len == 2: 
                    if key.words[1] in ['d','a','b','h','v']:
                        if file != '':
                            code, arg = compile2(file, key.words[1])
                            if code != 0:
                                screen.put(file)
                                screen.note('Compilation Failed: \n')
                                screen.note('Compile File type: '+filetype+' to '+key.words[1]+'\n', False)
                                screen.note(arg, False)
                            else:
                                screen.put('\n[ C O M P I L E   F I N I S H E D ]\n\n',center=True)
                                screen.put(file)
                                screen.put(arg, True)
                                code, defile = compile2(file, 'd')
                                file = arg
                                filetype = key.words[1]
                                screen.note('Compilation finished.\n')
                                screen.note('File type now is: '+filetype+'\n', False)
                        else:
                            screen.note('Compilation Exit: \n File should not be empty')
                    else:
                        screen.note('Compilation Exit: \n Unknow Compilation type\n'+key.compilehelp)
                else:
                    screen.note(key.compilehelp)
            elif key.result == 'sim' and simulating == 'stopped' and key.len == 1:
                if filetype == 'b':
                    simulating = 'pause'
                    instructions = file.split()
                    instlen = len(instructions)
                    systime = time.mktime(time.localtime())
                    screen.note('[Simulation Start]')
                elif instlen != 0:
                    simulating = 'pause'
                    systime = time.mktime(time.localtime())
                    screen.note('[Simulation Restart]')
                else:
                    screen.note('Code file should be binary type, compile it first.')
            elif key.result == 'core':
                if key.len == 2:
                    if key.words[1] == 'reset':
                        riscv.reset()
                        screen.put(riscv.status())
                        screen.note('Core reseted.')
                    elif key.words[1] == 'status':
                        screen.put(riscv.status())
                        screen.note('Show core status.')
                    else:
                        screen.note(key.corehelp)
                else:
                    screen.note(key.corehelp)
            elif key.result == 'readlog':
                if key.len == 2:
                    if key.words[1] == 'clear':
                        logmem = []
                        screen.note('All read log information cleared.')
                    elif key.words[1] == 'load' and config.readlogload != [0,0,0,0,0]:
                        m11 = config.readlogload[0]
                        m12 = config.readlogload[1]
                        m21 = config.readlogload[2]
                        m22 = config.readlogload[3]
                        index1 = config.readlogload[4]
                        text = 'Load: core mem[' + str(m21) + ' : ' +  str(m22) + '] <- log mem[' + str(m11) + ' : ' + str(m12) + ']'
                        riscv.mem[m21:m22] = logmem[index1][m11:m12]
                        screen.note(text)
                        for i in range(0,m22-m21):
                            text = 'core mem[' + str(m21+i) + '] = ' +str(riscv.mem[m21+i]) + ' <- log mem[' + str(m11+i) + '] = ' + str(logmem[index1][m11+i])
                            if i > 25:
                                screen.put('...')
                                break
                            screen.put(text)
                    else:
                        code, arg = readmem(key.words[1])
                        if code != 0:
                            screen.note('Read log failed:' + arg)
                        else:
                            for i in range(0, len(arg)):
                                if i > 25:
                                    screen.put('...')
                                    break
                                text = 'Address: ' + str(i) + ' Data: ' + str(arg[i])
                                screen.put(text)
                            logmem.append(arg)
                            screen.note('Read log finished')
                elif key.len == 4:
                    if key.words[1] == 'compare':
                        try:
                            index1 = int(key.words[2])
                            index2 = int(key.words[3])
                            if index1 != 0:
                                comp1 = logmem[index1-1]
                            else:
                                comp1 = riscv.mem
                            if index2 != 0:
                                comp2 = logmem[index2-1]
                            else:
                                comp2 = riscv.mem
                            complen = len(comp1)
                            if len(comp1) != len(comp2):
                                screen.note('Memory size not match: '+str(len(comp1) )+' != '+ str(len(comp2)))
                                if len(comp1) > len(comp2):
                                    complen = len(comp2)
                        except BaseException as arg:
                            screen.note('Read log command error:\n  '+str(arg))
                        else:
                            notmatch = False
                            screen.note('Memroy compare max address: '+str(complen))
                            for i in range(0, complen):
                                if comp1[i] != comp2[i]:
                                    screen.put('Not Match: Address='+str(i)+', data1='+str(comp1[i])+', data2='+str(comp2[i]))
                                    notmatch = True
                            if notmatch:
                                screen.note('Log Not Match. Result showing above.',False)
                            else:
                                screen.put('\n\nR e u s l t s   M a t c h i n g !\n\nC o n g r a t u l a t i o n s !\n\n\n\n\n\n',center=True)
                                screen.note('Matching. Congratulations!',False)
                    else:
                        screen.note(key.readloghelp)
                elif key.len == 8:
                    if key.words[1] == 'load' and key.words[5] == 'to':
                        try:
                            index1 = int(key.words[2]) - 1
                            assert index1 + 1 <= len(logmem), 'log memory list length is '+str(len(logmem)) + ', index out of range: ' + key.words[2]
                            m21 = int(key.words[6])
                            if key.words[7] == 'end':
                                m22 = len(riscv.mem)
                            else:
                                m22 = int(key.words[7])
                            m11 = int(key.words[3])
                            if key.words[4] == 'end':
                                m12 = len(logmem[index1])
                            else:
                                m12 = int(key.words[4])
                            assert m22 >= m21, 'Core mem end address should be no greater than start address: ' + str(m22) + ' < ' + str(m21)
                            assert m12 >= m11, 'Log file end address should be no greater than start address: ' + str(m12) + ' < ' + str(m11)
                            if m12 - m11 > m22 - m21:
                                m12 = m11 + m22 - m21
                            else:
                                m22 = m21 + m12 - m11
                            text = 'Load: core mem[' + str(m21) + ' : ' +  str(m22) + '] <- log mem[' + str(m11) + ' : ' + str(m12) + ']'
                            riscv.mem[m21:m22] = logmem[index1][m11:m12]
                            screen.note(text)
                        except BaseException as arg:
                            screen.note('Error use of load statment: '+ str(arg))
                        else:
                            config.readlogload[0] = m11
                            config.readlogload[1] = m12
                            config.readlogload[2] = m21
                            config.readlogload[3] = m22
                            config.readlogload[4] = index1
                            for i in range(0,m22-m21):
                                text = 'core mem[' + str(m21+i) + '] = ' +str(riscv.mem[m21+i]) + ' <- log mem[' + str(m11+i) + '] = ' + str(logmem[index1][m11+i])
                                if i > 25:
                                    screen.put('...')
                                    break
                                screen.put(text)
                else:
                    screen.note('Error use of read log statement.\n'+key.readloghelp)
            elif simulating == 'pause':
                cmdinfor = ''
                if key.words[0] == 'status':
                    show_core_status = not show_core_status
                elif key.words[0] == 'simtime' or key.words[0] == '+' or key.words[0] == 'sim':
                    unit = 1
                    if key.len == 3:
                        if key.words[2] == 's':
                            unit = 1
                        elif key.words[2] == 'ms':
                            unit = 1e-3
                        elif key.words[2] == 'us':
                            unit = 1e-6
                        elif key.words[2] == 'ns':
                            unit = 1e-9
                        elif key.words[2] == 'ps':
                            unit = 1e-12
                    try:
                        goto_excutime = riscv.time + int(float(key.words[1]) * riscv.freq * unit)
                        assert goto_excutime != riscv.time, 'Time too short, target executions not increased.'
                        assert goto_excutime > riscv.time, 'Target executions should not less than present executions'
                    except IndexError:
                        screen.note(key.simulatehelp)
                    except BaseException as Argument:
                        goto_excutime = riscv.time
                        screen.note('Simtime error: ' + str(Argument))
                elif key.words[0] == 'run':
                    try:
                        goto_excutime = riscv.time + int(key.words[1])
                    except IndexError:
                        screen.note(key.simulatehelp)
                    except BaseException as Argument:
                        goto_excutime = riscv.time
                        screen.note('Runtime error: ' + str(Argument))
                elif key.words[0] == 'set':
                    try:
                        setpc = int(key.words[1])
                    except IndexError:
                        screen.note(key.simulatehelp)
                    except BaseException as Argument:
                        screen.note('Set PC error: ' + str(Argument))
                    else:
                        screen.note('Set stop when PC is ' + key.words[1])
                elif key.words[0] == 'stop':
                    if savelog:
                        code, arg = savemem(wlogpath, riscv.mem)
                        if code == 0:
                            screen.put('[ memory log saved ]')
                        else:
                            screen.put('[ memory log saving failed: ]',arg)
                    simulating = 'stopped'
                    screen.put('\n[ S I M U L A T I O N   F I N I S H E D ]\n\n',center=True)
                    screen.put('Total instructions: '+str(instlen),center=True)
                    text = screen.add(riscv.status(), regbox.show(riscv.x), 0, True, '+1')
                    code, arg = showlocation(defile, riscv.pc)
                    text = screen.add(arg, text, 0, True, '+1')
                    screen.put(text,center=True)
                    screen.note('\n[Simulation Stopped by User]\n\n')
                elif key.words[0] == 'None':
                    goto_excutime = riscv.time + 1
                    screen.note('Execute one instruction')
                else:
                    screen.note(key.simulatehelp)
            elif key.result == 'default':
                screen.note('Welcome using the Dust compiler and simulator. This software is writen by Clark alone!')
            else:
                screen.note('command unknown, try use help')

        #-------------------------------------
        # Running simulation
        #-------------------------------------

        if simulating != 'stopped':
            if riscv.pc >= instlen:
                siminfor = ' Simulation finished.'
                simulating = 'stopped'
                screen.put('\n[ S I M U L A T I O N   F I N I S H E D ]\n\n',center=True)
                screen.put('Total instructions: '+str(instlen),center=True)
                text = screen.add(riscv.status(), regbox.show(riscv.x), 0, True, '+1')
                code, arg = showlocation(defile, riscv.pc)
                text = screen.add(arg, text, 0, True, '+1')
                screen.put(text,center=True)
                excucounter = 0
                if savelog:
                    code, arg = savemem(wlogpath, riscv.mem)
                    if code == 0:
                        screen.put('[ memory log saved ]')
                        savelog = False
                    else:
                        screen.put('[ memory log saving failed: ]',arg)
            else:
                if setpc == riscv.pc:
                    siminfor = '[Set PC pause]'
                    simulating = 'pause'
                    excucounter = 0
                    goto_excutime = riscv.time
                    setpc = None
                elif riscv.time < goto_excutime:
                    try:
                        simulating = 'running'
                        if excucounter > 100000:
                            excucounter = 0
                        else:
                            excucounter += 1
                        code = riscv.execute(instructions[riscv.pc])
                        assert code == 0, 'Core report error: ' + riscv.infor
                        siminfor = 'Simulation running'
                    except IndexError as Argument:
                        riscv.infor = 'Execution failed due to memory size: ' + str(Argument)
                        simulating == 'pause'
                        excucounter = 0
                        goto_excutime = riscv.time
                    except BaseException as Argument:
                        riscv.infor = 'Execution failed due to environment: ' + str(Argument)
                        simulating == 'pause'
                        excucounter = 0
                        goto_excutime = riscv.time
                else:
                    siminfor = 'Simulation pause'
                    simulating = 'pause'
                    excucounter = 0

        # -------------------------------------
        # screen put information
        # -------------------------------------
        
        if excucounter == 0:

            # display sim information
            if simulating == 'running':
                screen.put('[ S I M U L A T I O N   R U N N I N G ]',center=True)
                screen.put('Total instructions: '+str(instlen),center=True)
                if show_core_status:
                    text = screen.add(riscv.status(), regbox.show(riscv.x), 0, True, '+1')
                    code, arg = showlocation(defile, riscv.pc)
                    text = screen.add(arg, text, 0, True, '+1')
                    screen.put(text,center=True)
                else:
                    screen.put(regbox.show(riscv.x),center=True)
                screen.note(siminfor, False)
                screen.note('[Core Infor]: '+riscv.infor, False)
                screen.note('[PC]: '+str(riscv.pc), False)
                text = str(round(time.mktime(time.localtime()) - systime,4)) + 's'
                screen.put('Simulation time since start: '+text,center=True)
                text = str(riscv.runtime()) + 's'
                screen.put('Core simulation run time used: '+text,center=True)
                text = str(round(riscv.period * goto_excutime,4)) + 's'
                if setpc != None:
                    text += ' or when PC is: ' + str(setpc)
                screen.put('Going to pause at:             '+text,center=True)
                screen.put()
                putmem()
                screen.display(True)
                screen.note('')
            elif simulating == 'pause':
                screen.put('[ S I M U L A T I O N   P A U S E ]',center=True)
                screen.put('Total instructions: '+str(instlen),center=True)
                if show_core_status:
                    text = screen.add(riscv.status(), regbox.show(riscv.x), 0, True, '+1')
                    code, arg = showlocation(defile, riscv.pc)
                    text = screen.add(arg, text, 0, True, '+1')
                    screen.put(text,center=True)
                else:
                    screen.put(regbox.show(riscv.x),center=True)
                screen.note(siminfor, False)
                screen.note('[Core Infor]: '+riscv.infor, False)
                screen.note('[PC]: '+str(riscv.pc), False)
                text = str(round(time.mktime(time.localtime()) - systime,4)) + 's'
                screen.put('Simulation time since start: '+text,center=True)
                text = str(riscv.runtime()) + 's'
                screen.put('Core simulation run time used: '+text,center=True)
                screen.put()
                putmem()
            else:
                screen.put()
                putmem()
