import re
import sys

args = sys.argv
input_filename=args[1]
output_filename=args[2]

with open(input_filename,'r') as list, open(output_filename,'w') as out: 
    for a in list:
        out.write(re.sub('.:\\\\','',a))
