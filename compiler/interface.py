# --------------------------------------------------------------------------
# Using UTF-8
# Title: General User Interface
# Last Modified Date: 2023/7/20
# Version: 1.0
# Author: Clark Pu
# --------------------------------------------------------------------------

import os

# print a list in a box style
class boxs():

    def __init__(self, width:int, height:int, offset:int=0, hideindex=False, indexformat:int=10, dataformat:int=0, style:str='clean'):
        assert indexformat != 0, 'Error: index format cannot be zero.'
        assert width >= 0, 'Error: width cannot less than 1.'
        assert height >= 0, 'Error: height cannot less than 1.'
        self.indexformat = indexformat
        self.dataformat = dataformat
        self.width = width
        self.height = height
        self.indexoffset = offset
        self.hideindex = hideindex
        # format: 0 for original string. 10 for decimal, 16 for hexdecimal
        # list item string space
        self.indexspace = 0
        # division mark: seperate list items
        self.item2item = ''
        self.index2data = ':'
        # box side mark
        self.topbuttom = ''
        self.right = ''
        self.left = ''
        self.rightcorner = ''
        self.leftcorner = ''
        # display privilege
        self.privilege = 0
        # location
        self.vertical = 0 # vertical output order
        self.horizontal = 0 # space to left edge, or string of location

        # insert line
        self.insertline = []
        self.insertlineindex = []
        if style == 'clean':
            self.item2item = ' | '
            self.index2data = ' : '
            self.topbuttom = ' '
            self.right = ' '
            self.left = ' '
            self.rightcorner = ' '
            self.leftcorner = ' '
        elif style == 'outline':
            self.item2item = '|'
            self.index2data = ' : '
            self.topbuttom = '-'
            self.right = ' |'
            self.left = '| '
            self.rightcorner = '-+'
            self.leftcorner = '+-'
        elif style == 'star':
            self.item2item = ' * '
            self.index2data = ' : '
            self.topbuttom = '*'
            self.right = ' *'
            self.left = '* '
            self.rightcorner = '**'
            self.leftcorner = '**'
        elif style == 'block':
            self.item2item = '|'
            self.index2data = '  '
            self.topbuttom = '='
            self.right = ' ]'
            self.left = '[ '
            self.rightcorner = '=='
            self.leftcorner = '=='

    def auto_indexspace(self, block):
        maxindex = self.indexoffset + self.width * self.height
        if maxindex > len(block):
            maxindex = len(block)
        if self.indexformat == 16:
            maxlen = len(hex(maxindex)[2:])
            self.indexspace = maxlen
        else:
            maxlen = len(str(maxindex))
            self.indexspace = maxlen

    def auto_dataspace(self, block:list, cal:int):
        if self.indexformat == 16:
            maxindex = self.indexoffset + self.height * self.width
            if maxindex > len(block):
                maxindex = len(block)
            maxlen = 0
            i = self.indexoffset + cal
            while i < maxindex:
                if maxlen < len(hex(block[i]).replace('0x','')):
                    maxlen = len(hex(block[i]).replace('0x',''))
                i += self.width
            return maxlen
        else:
            maxindex = self.indexoffset + self.height * self.width
            if maxindex > len(block):
                maxindex = len(block)
            maxlen = 0
            i = self.indexoffset + cal
            while i < maxindex:
                if maxlen < len(str(block[i])):
                    maxlen = len(str(block[i]))
                i += self.width
            return maxlen

    def get(self, block):
        lines = []
        assert len(self.left) == len(self.right), 'Error: left right edge should be same size: ' + self.left + ' ' + self.right
        assert len(self.topbuttom) == 1, 'Error: top and bottom size must be 1: ' + self.topbuttom
        assert len(self.rightcorner) == len(self.right), 'Error: cornor must be the same size with left right edge: ' + self.rightcorner + ' ' + self.right
        assert len(self.rightcorner) == len(self.leftcorner), 'Error: left right rightcorner should be same size: ' + self.rightcorner + ' ' + self.leftcorner
        boxwidth = 0
        boxwidth += len(self.right) * 2
        boxwidth += len(self.item2item) * (self.width - 1)
        boxwidth += len(self.index2data) * self.width
        self.auto_indexspace(block)
        boxwidth += self.indexspace * self.width
        for i in range(0, self.width):
            boxwidth += self.auto_dataspace(block, i)
        if (self.topbuttom != ''):
            top_bottom_line = self.leftcorner + self.topbuttom * (boxwidth - len(self.rightcorner) * 2) + self.rightcorner
            lines.append(top_bottom_line)
        for y in range(0, self.height):
            line = self.left
            for x in range(0, self.width):
                index = self.indexoffset + x + y * self.width
                if not self.hideindex:
                    if self.indexformat == 16:
                        strindex = hex(index).replace('0x','')
                    else:
                        strindex = str(index)
                    line += ' ' * (self.indexspace - len(strindex)) + strindex
                    line += self.index2data
                data = block[index]
                if self.dataformat == 16:
                    strdata = hex(data).replace('0x','')
                else:
                    strdata = str(data)
                dataspace = self.auto_dataspace(block, x)
                line += ' ' * (dataspace - len(strdata)) + strdata
                if x != self.width - 1:
                    line += self.item2item
            line += self.right
            lines.append(line)
        if (self.topbuttom != ''):
            lines.append(top_bottom_line)
        insertwidth = boxwidth - len(self.rightcorner) * 2
        if len(self.insertline) != 0:
            i = 0
            for infor in self.insertline:
                assert type(infor) == type('str'), 'Error: inserted information must be string: ' + str(infor)
                assert len(infor) < insertwidth, 'Error: inserted information to long: ' + infor
                leftspace = int((insertwidth - len(infor))/2)
                rightspace = insertwidth - len(infor) - leftspace
                if infor == '---':
                    line = top_bottom_line
                else:
                    line = self.left + leftspace * ' ' + infor + rightspace * ' ' + self.right
                lines.insert(self.insertlineindex[i]+1+i, line)
                i += 1
        return lines
    
    def show(self, block:list, display=False):
        lines = self.get(block)
        text = ''
        for line in lines:
            text += line + '\n'
        if display:
            print(text)
        return text

    def insert(self, infor:str, index:int):
        assert type(infor) == type('str'), 'Error: inserted information must be string type: ' + str(infor)
        assert type(index) == type(1), 'Error: inserted information index must be int type: ' + str(index)
        assert index in range(-self.height, self.height), 'Error: inserted information index must in height range: ' + str(index)
        if index < 0:
            index = self.height + index + 1
        insertindex = len(self.insertlineindex)
        for i in range(0,len(self.insertlineindex)):
            if self.insertlineindex[i] > index:
                insertindex = i
                break
        self.insertlineindex.insert(insertindex, index)
        self.insertline.insert(insertindex, infor)
        assert len(self.insertline) == len(self.insertlineindex), 'Error: number of inserted information not match its indexs'

# screen ui
class screens():

    def __init__(self, enable_clear = True, cover = False, y_in_screen = False, x_in_screen = True):
        # screen options
        self.enable_clear = enable_clear
        self.cover = cover
        self.y_in_screen = y_in_screen
        self.x_in_screen = x_in_screen
        # area division mark
        self.divmark = '-' 
        self.topline = ''
        self.topline_edge = 'middle'
        self.bottomline = ''
        self.bottomline_edge = '+2'
        self.inputinfor = ' > ' # at input line, text before input area
        # general information area text, refresh after display
        self.infor = []
        self.infor_gap = 0
        self.infor_edge = 'middle'
        # console information area text
        self.console = ''
        self.console_edge = '+2'

    def clear(self):
        if self.enable_clear:
            print('\033c',end='') # clear screen
    
    def add(self, string:str, text:str, vertical=0, vlock=False, location:str='middle', cover=False):
        width = os.get_terminal_size().columns
        height = os.get_terminal_size().lines - 1

        strings = string.split('\n')
        strings.pop()
        texts = text.split('\n')
        texts.pop()
       
        # calculate the top space
        if vertical < 0:
            vertical = height - len(strings) - len(texts) + vertical 
        if vlock:
            topspace = vertical
        else:
            topspace = len(texts) + vertical
        if topspace + len(strings) > len(texts):
            for i in range(len(texts), topspace + len(strings)):
                texts.append('')
        if height > len(texts):
            for i in range(len(texts), height):
                texts.append('')
        # calculate the left space
        leftspace = 0
        maxlen = 0
        for line in strings:
            if maxlen < len(line):
                maxlen = len(line)
        maxlentext = 0
        for line in texts:
            if maxlentext < len(line):
                maxlentext = len(line)
        if location == 'middle':
            leftspace = int((width - maxlen) / 2)
        elif location[0] == '+':
            leftspace = int(location[1:])
        elif location[0] == '-':
            leftspace = width - int(location[1:]) - maxlen - maxlentext
        if leftspace < 0:
            leftspace = 0
        if not cover:
            maxlen = 0
            for line in texts[topspace:(topspace + len(strings))]:
                if maxlen < len(line):
                    maxlen = len(line)
            leftspace += maxlen
        # insert
        newtext = ''
        for i in range(0, topspace + len(strings)):
            if topspace <= i:
                line = (texts[i])[0:leftspace] + ' ' * (leftspace - len(texts[i]))
                line += strings[i - topspace]
            else:
                line = texts[i]
            if self.x_in_screen:
                newtext += line[0:width] + '\n'
            else:
                newtext += line + '\n'
            if self.y_in_screen and i >= (height - 1):
                break
        if vlock and len(texts) > topspace + len(strings):
            for i in range(topspace + len(strings), len(texts)):
                if self.y_in_screen and i >= (height - 1):
                    break
                if texts[i] != '':
                    newtext += texts[i] + '\n'
        return newtext
  
    def display(self, skip_input=False):
        self.clear()
        width = os.get_terminal_size().columns
        text = ''
        # top line
        if self.topline != '':
            text = self.add(self.topline+'\n', text, 0, False, self.topline_edge)
        # division
        if self.divmark != '':
            text = self.add((self.divmark)*width+'\n', text)
        # add infors
        for i in self.infor:
            text = self.add(i, text, self.infor_gap, False, self.infor_edge)
        if self.enable_clear:
            for i in range(0,width-5):
                text = self.add('\n', text, self.infor_gap, False, self.infor_edge)
        # add console, always cover infor
        text = self.add(self.console, text, -3, False, self.console_edge, True)
        # division
        if self.divmark != '':
            text = self.add((self.divmark)*width+'\n', text)
        # bottom line
        if self.bottomline != '':
            text = self.add(self.bottomline+'\n', text, 0, False, self.bottomline_edge)
        # display
        print(text)
        self.infor = []
        if not skip_input:
            command = input(self.inputinfor)
            return command

    # put text into infor
    def put(self, string:str='', appending:bool=False, append_offset:str='-1', center=False):
        if len(string) == 0:
            string += '\n'
        elif string[-1] != '\n':
            string += '\n'
        if appending and len(self.infor) != 0:
            self.infor[-1] = self.add(string, self.infor[-1], 0, True, append_offset, self.cover)
        else:
            if center:
                self.infor.append(self.add(string, ''))
            else:
                self.infor.append(string)

    # put text in console
    def note(self, string:str, clear=True):
        width = os.get_terminal_size().columns
        strings = string.split('\n')
        if (strings[-1] == ''):
            strings.pop()
        text = ''
        for line in strings:
            while len(line) > width:
                text += line[0:width] + '\n'
                line = line[width:]
            text += line + '\n'
        # division
        if clear:
            if self.divmark != '':
                self.console = (self.divmark)*width +'\n'
            else:
                self.console = ''
        self.console += text


# input key words handling
class keys():

    scan = ''
    keywords = ['None']
    result = ''

    sysquit = ['q', 'quit', 'exit']

    def __init__(self):
        self.scan = ''

    def analysis(self):
        if len(self.scan.split()) == 0:
            self.keywords = ['None']
            self.result = 'default'
        else:
            self.keywords = self.scan.split()
            if self.keywords[0] in self.sysquit:
                self.result = 'quit'
            else:
                self.result = 'unknow keywords'
        
    def execute(self):
        if self.result == 'quit':
            exit('\n[Finished]\n')
        elif self.result == 'default':
            return

# A general run template
if __name__ == '__main__':
    # UI create
    screen = screens()
    box1 = boxs(4,4,0,style='outline')
    box2 = boxs(8,8,64,style='block')
    key = keys()
    # UI preference
    screen.topline = 'U S E R    I N T E R F A C E'
    screen.bottomline = 'I N P U T   A R E A'
    # process data
    k = 0
    b = [0] * 256
    # program loop
    while True:
        for i in range(0,256):
            b[i] = i + k
        k += 10
        screen.put()
        screen.put(box1.show(b))
        screen.put(box2.show(b),True)
        screen.put()
        screen.put(box1.show(b[128:]))
        screen.put(box2.show(b[128:]),True)
        screen.put()
        screen.note(' C O N S O L E   I N F O R M A T I O N : \n'+key.result)
        key.scan = screen.display()
        key.analysis()
        key.execute()
