import os

class mtafile:

    def __init__(self, filename):
        self.open(filename)
        self.exec_num = 0

    def __del__(self):
        self.f.close()
        return

    def open(self, filename):
        self.filename=filename
        mta_path='C:\\Users\\'+os.getenv('USERNAME')+'\\AppData\\Roaming\\Mp3tag\\data\\actions'
        self.f = open(mta_path+'\\'+filename, 'w', encoding='utf_8_sig')
        return
        
    def close(self):
        self.f.close()
        return
        
    def set_start_number(self, value):
        self.exec_num = value
        return

    def format_value(self, field, value):
        out='[#'+str(self.exec_num)+']\n'
        out+='T=5\n'
        out+='1='+value.rstrip('\n').encode('unicode-escape').decode('utf8')+'\n'
        out+='F='+field+'\n'
        out+='\n'
        self.exec_num+=1
        self.f.write(out)
        return

    def remove_field(self, field):
        out='[#'+str(self.exec_num)+']\n'
        out+='T=9\n'
        out+='F='+field+'\n'
        out+='\n'
        self.exec_num+=1
        self.f.write(out)
        return
  
    def decode(self, string):
        return string.rstrip('\n').encode('unicode-escape').decode('utf8')