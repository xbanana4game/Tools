from twitchAPI.twitch import Twitch
from twitchAPI.helper import first
from twitchAPI.type import TimePeriod, VideoType, AuthScope
from twitchAPI.oauth import UserAuthenticator
import asyncio
from datetime import date
import datetime
import configparser
import os
import csv
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
    fc = open('C:\\Users\\'+os.getenv('USERNAME')+'\\Downloads\\'+'twitch-top-games-'+today.strftime("%Y%m%d%H%M")+'.csv', 'w', encoding='utf-8-sig', newline="")
    writer = csv.writer(fc)
    myuser = await first(twitch.get_users(logins=LOGIN_ID))

    writer.writerow(['name','id'])
    async for game in twitch.get_top_games():
        print('%s:%s'%(game.name,game.id))
        writer.writerow([game.name,game.id])
        #fc.write('%s,%s\n'%(game.name,game.id))
    fc.close()
    await twitch.close()
    

# run this example
asyncio.run(twitch_example())