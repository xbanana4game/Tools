import os
import sys

#profile = sys.argv[1]
prifile = os.environ.get('YTDLP_PROFILE')
domain = prifile.split('_')[0]
quality = prifile.split('_')[1]
print(domain)



