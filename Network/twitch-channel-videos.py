from twitchAPI.twitch import Twitch
from twitchAPI.helper import first
from twitchAPI.type import TimePeriod, VideoType, AuthScope
from twitchAPI.oauth import UserAuthenticator
import asyncio
from datetime import date
import datetime
import configparser
import os
import subprocess
import time
#python -m pip install twitchAPI

config = configparser.ConfigParser()
config.read(os.getenv('CONFIG_DIR') + '\\Connection.ini', encoding='utf-8')
LOGIN_ID = config.get("connection", "LOGIN_ID")
APP_ID = config.get("connection", "APP_ID")
APP_SECRET = config.get("connection", "APP_SECRET")
config_period = eval(config["channel"]["PERIOD"])
config_videotype = eval(config["channel"]["VIDEOTYPE"])

channel_listfile = os.getenv('CONFIG_DIR') + '\\twitch_channel.csv.txt'
proc = subprocess.Popen([r"c:\Windows\system32\notepad.exe", channel_listfile])

CHANNEL_LIST = []
CHANNEL_NAME = input('CHANNEL_NAME: ')
if CHANNEL_NAME == '':
    CHANNEL_LIST = eval(config["channel"]["CHANNEL_LIST"])
else:
    CHANNEL_LIST.append(CHANNEL_NAME)


async def twitch_example():
    # initialize the twitch instance, this will by default also create a app authentication for you
    twitch = await Twitch(APP_ID, APP_SECRET)
    today=datetime.datetime.now()
    myuser = await first(twitch.get_users(logins=LOGIN_ID))


    # Get My Channel List
    USER_SCOPE = [AuthScope.USER_READ_FOLLOWS]
    auth = UserAuthenticator(twitch, USER_SCOPE, force_verify=False)
    # this will open your default browser and prompt you with the twitch verification website
    token, refresh_token = await auth.authenticate()
    # add User authentication
    await twitch.set_user_authentication(token, USER_SCOPE, refresh_token)

    channel = await twitch.get_followed_channels(user_id=myuser.id)
    if len(CHANNEL_LIST) == 0:
        f_channel = open(
            os.getenv('USERPROFILE') + '\\Desktop\\' + 'twitch-channel' + today.strftime("_%Y%m%d%H%M") + '.csv', 'w',
            encoding='utf-8-sig')
        async for ch in channel:
            print('{id},{login},{name}'.format(id=ch.broadcaster_id, login=ch.broadcaster_login,
                                               name=ch.broadcaster_name))
            f_channel.write('{name},{login},{id}\n'.format(id=ch.broadcaster_id, login=ch.broadcaster_login,
                                                           name=ch.broadcaster_name))
            CHANNEL_LIST.append(ch.broadcaster_login)
        f_channel.close()
    print(CHANNEL_LIST)

    async for user in twitch.get_users(logins=CHANNEL_LIST):
        fc = open(os.getenv('USERPROFILE') + '\\Downloads\\' + 'twitch-' + user.display_name + today.strftime(
            "_%Y%m%d%H%M") + '.csv',
                  'w', encoding='utf-8-sig')
        # fc.write('user_name,type,viewable,published_at,title,duration,view_count,url\n')
        fc.write('dl,user_name,published_at,title,duration,view_count,url\n')
        async for videoInf in twitch.get_videos(user_id=user.id, period=config_period, video_type=config_videotype):
            # fc.write('{user_name},{type},{viewable},{published_at},{title},{duration},{view_count},{url}\n'.format(view_count=videoInf.view_count, type=videoInf.type, user_name=videoInf.user_name, viewable=videoInf.viewable, title=videoInf.title.replace(',',' ').replace('\n',' '), url=videoInf.url, duration=videoInf.duration, published_at=videoInf.published_at.strftime("%Y-%m-%d %H:%M:%S")))
            fc.write('0,{user_name},{published_at},{title:.30},{duration},{view_count},{url}\n'.format(
                view_count=videoInf.view_count, type=videoInf.type, user_name=videoInf.user_name,
                viewable=videoInf.viewable, title=videoInf.title.replace(',', ' ').replace('\n', ' '), url=videoInf.url,
                duration=videoInf.duration, published_at=videoInf.published_at.strftime("%Y-%m-%d")))
            print('{user_name},{title},{url}'.format(user_name=videoInf.user_name, viewable=videoInf.viewable,
                                                     title=videoInf.title, url=videoInf.url, duration=videoInf.duration,
                                                     published_at=videoInf.published_at))
        fc.close()

    await twitch.close()
    

# run this example
asyncio.run(twitch_example())