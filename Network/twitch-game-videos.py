from twitchAPI.twitch import Twitch
from twitchAPI.helper import first
from twitchAPI.type import TimePeriod, VideoType, AuthScope, SortMethod
from twitchAPI.oauth import UserAuthenticator
import asyncio
from datetime import date
import datetime
import configparser
import os
import subprocess
import time

game_listfile=os.getenv('CONFIG_DIR')+'\\twitch-top-games.csv.txt'
proc = subprocess.Popen([r"c:\Windows\system32\notepad.exe", game_listfile])

config = configparser.ConfigParser()
config.read(os.getenv('CONFIG_DIR')+'\\Connection.ini', encoding='utf-8')
LOGIN_ID = config.get("connection", "LOGIN_ID")
APP_ID = config.get("connection", "APP_ID")
APP_SECRET = config.get("connection", "APP_SECRET")
CHANNEL_LIST=eval(config["channel"]["CHANNEL_LIST"])
config_period=eval(config["channel"]["PERIOD"])
config_videotype=eval(config["channel"]["VIDEOTYPE"])
config_gamename = []
config_gamename=eval(config["twitch"]["GAME"])
if len(config_gamename) == 0:
    gamename = input('GAME NAME(just chatting): ')
    if gamename == '':
        gamename='just chatting'
    config_gamename.append(gamename)
print(config_gamename[0])

config_lang_default=eval(config["twitch"]["LANG"])
print(config_lang_default)
config_lang = input('LANG(JA,None): ')
if config_lang == '':
    config_lang=config_lang_default
elif config_lang == 'None':
    config_lang=None

print(config_lang)

async def twitch_example():
    # initialize the twitch instance, this will by default also create a app authentication for you
    twitch = await Twitch(APP_ID, APP_SECRET)
    today=datetime.datetime.now()
    myuser = await first(twitch.get_users(logins=LOGIN_ID))

    async for game in twitch.get_games(names=config_gamename):
        fc = open(os.getenv('USERPROFILE')+'\\Downloads\\'+'twitch-'+game.name+'_'+today.strftime("%Y%m%d%H%M")+'.csv', 'w', encoding='utf-8-sig')
        fc.write('dl,game,user_name,published_at,title,duration,view_count,url\n')
        print(game.id)
        async for videoInf in twitch.get_videos(game_id=game.id, language=config_lang, period=config_period, video_type=config_videotype, sort=SortMethod.VIEWS):
            print('{game},{user_name},{title},{url}'.format(game=game.name, user_name=videoInf.user_name, viewable=videoInf.viewable, title=videoInf.title, url=videoInf.url, duration=videoInf.duration, published_at=videoInf.published_at))
            fc.write('0,{game},{user_name},{published_at},{title:.30},{duration},{view_count},{url}\n'.format(game=game.name, view_count=videoInf.view_count, type=videoInf.type, user_name=videoInf.user_name, viewable=videoInf.viewable, title=videoInf.title.replace(',',' ').replace('\n',' '), url=videoInf.url, duration=videoInf.duration, published_at=videoInf.published_at.strftime("%Y-%m-%d")))
        fc.close()

    await twitch.close()
    

# run this example
asyncio.run(twitch_example())