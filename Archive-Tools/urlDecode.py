# coding: utf-8
import os
import sys 
import urllib.parse

args = sys.argv[1:]
for f in args:    
    f_renamed = (urllib.parse.unquote(f,encoding='utf-8'))
    print(f+' -> '+f_renamed)
    os.rename(f, f_renamed)