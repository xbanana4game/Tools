from twitchAPI.twitch import Twitch
from twitchAPI.helper import first
from twitchAPI.type import TimePeriod, VideoType, AuthScope
from twitchAPI.oauth import UserAuthenticator
import asyncio
from datetime import date
import datetime
import configparser
import os
#python -m pip install twitchAPI

config = configparser.ConfigParser()
config.read('Connection.ini', encoding='utf-8')
LOGIN_ID = config.get("connection", "LOGIN_ID")
APP_ID = config.get("connection", "APP_ID")
APP_SECRET = config.get("connection", "APP_SECRET")
CHANNEL_LIST=eval(config["channel"]["CHANNEL_LIST"])
config_period=eval(config["channel"]["PERIOD"])
config_videotype=eval(config["channel"]["VIDEOTYPE"])


async def twitch_example():
    # initialize the twitch instance, this will by default also create a app authentication for you
    twitch = await Twitch(APP_ID, APP_SECRET)
    today=datetime.datetime.now()
    fc = open('C:\\Users\\'+os.getenv('USERNAME')+'\\Downloads\\'+'twitch-channel_'+today.strftime("%Y%m%d%H%M")+'.csv', 'w', encoding='utf-8-sig')
    myuser = await first(twitch.get_users(logins=LOGIN_ID))


    # Get My Channel List
    USER_SCOPE = [AuthScope.USER_READ_FOLLOWS]
    auth = UserAuthenticator(twitch, USER_SCOPE, force_verify=False)
    # this will open your default browser and prompt you with the twitch verification website
    token, refresh_token = await auth.authenticate()
    # add User authentication
    await twitch.set_user_authentication(token, USER_SCOPE, refresh_token)

    channel = await twitch.get_followed_channels(user_id=myuser.id)
    if len(CHANNEL_LIST)==0:
        async for ch in channel:
            print('{},{},{}'.format(ch.broadcaster_id, ch.broadcaster_login, ch.broadcaster_name))
            CHANNEL_LIST.append(ch.broadcaster_login)
    print(CHANNEL_LIST)
    
    #fc.write('user_name,type,viewable,published_at,title,duration,view_count,url\n')
    fc.write('dl,user_name,published_at,title,duration,view_count,url\n')
    async for user in twitch.get_users(logins=CHANNEL_LIST):
        async for videoInf in twitch.get_videos(user_id=user.id, period=config_period, video_type=config_videotype):
            #fc.write('{user_name},{type},{viewable},{published_at},{title},{duration},{view_count},{url}\n'.format(view_count=videoInf.view_count, type=videoInf.type, user_name=videoInf.user_name, viewable=videoInf.viewable, title=videoInf.title.replace(',',' ').replace('\n',' '), url=videoInf.url, duration=videoInf.duration, published_at=videoInf.published_at.strftime("%Y-%m-%d %H:%M:%S")))
            fc.write('0,{user_name},{published_at},{title:.30},{duration},{view_count},{url}\n'.format(view_count=videoInf.view_count, type=videoInf.type, user_name=videoInf.user_name, viewable=videoInf.viewable, title=videoInf.title.replace(',',' ').replace('\n',' '), url=videoInf.url, duration=videoInf.duration, published_at=videoInf.published_at.strftime("%Y-%m-%d")))
            print('{user_name},{title},{url}'.format(user_name=videoInf.user_name, viewable=videoInf.viewable, title=videoInf.title, url=videoInf.url, duration=videoInf.duration, published_at=videoInf.published_at))

    fc.close()
    await twitch.close()
    

# run this example
asyncio.run(twitch_example())