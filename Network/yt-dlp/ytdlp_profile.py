import os
import sys

# FOR /f "usebackq" %%A IN (`ytdlp_profile.py`) DO SET YTDLP_DOMAIN=%%A
# profile = sys.argv[1]
profile = os.environ.get('YTDLP_PROFILE')
if profile is None:
    profile = input('YTDLP_PROFILE: ')
domain = ''
v_quality = ''
a_quality = ''
try:
    domain = profile.split('_')[0]
    v_quality = profile.split('_')[1]
    a_quality = profile.split('_')[2]
except IndexError:
    pass
# print('domain:{domain}, v_quality:{v_quality}, a_quality:{a_quality}'.format(domain=domain, v_quality=v_quality, a_quality=a_quality))
print(domain)
