# --------------------------------------------------------------------------
# Using UTF-8
# Title: RISCV32 Subset Develop Kit: Dust
# Last Modified Date: 2023/7/20
# Version: 1.0
# Author: Clark Pu
# --------------------------------------------------------------------------

import interface
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
        if type == 'm':
            m = compile.bin2mem(b, True)
            return 0, m
        assert 1==0, 'test'
        return 1, 'Type Error: no such file type, try: d, a, b, h, m.'
    except AssertionError as Argument:
        return 1, Argument
    # except BaseException as Argument:
    #     return 2, Argument


# 