from twitchAPI.twitch import Twitch
from twitchAPI.helper import first
from twitchAPI.type import TimePeriod, VideoType, AuthScope
from twitchAPI.oauth import UserAuthenticator
import asyncio
from datetime import date
import datetime
import configparser

config = configparser.ConfigParser()
config.read('Connection.ini', encoding='utf-8')
LOGIN_ID = config.get("connection", "LOGIN_ID")
APP_ID = config.get("connection", "APP_ID")
APP_SECRET = config.get("connection", "APP_SECRET")

async def twitch_example():
    # initialize the twitch instance, this will by default also create a app authentication for you
    twitch = await Twitch(APP_ID, APP_SECRET)
    today=datetime.datetime.now()
    fc = open('twitch-'+today.strftime("%Y%m%d%H%M")+'.csv', 'w', encoding='utf-8-sig')
    myuser = await first(twitch.get_users(logins=LOGIN_ID))


    # Get My Channel List
    USER_SCOPE = [AuthScope.USER_READ_FOLLOWS]
    auth = UserAuthenticator(twitch, USER_SCOPE, force_verify=False)
    # this will open your default browser and prompt you with the twitch verification website
    token, refresh_token = await auth.authenticate()
    # add User authentication
    await twitch.set_user_authentication(token, USER_SCOPE, refresh_token)

    channel = await twitch.get_followed_channels(user_id=myuser.id)
    CHANNEL_LIST=[]
    async for ch in channel:
        print('{},{},{}'.format(ch.broadcaster_id, ch.broadcaster_login, ch.broadcaster_name))
        CHANNEL_LIST.append(ch.broadcaster_login)
    print(CHANNEL_LIST)
    
    async for user in twitch.get_users(logins=CHANNEL_LIST):
        count = 0
        # video_type=VideoType.ALL|VideoType.ARCHIVE, period=TimePeriod.DAY|TimePeriod.WEEK|TimePeriod.ALL
	async for videoInf in twitch.get_videos(user_id=user.id, video_type=VideoType.ARCHIVE, period=TimePeriod.WEEK):
            count+=1
            # print('--------------------------------------------------------')
            # print(videoInf.title)
            # print(videoInf.description)
            # print(videoInf.viewable)
            # print(videoInf.url)
            # print(videoInf.type)
            # print(videoInf.duration)
            # print(videoInf.view_count)
            fc.write('{user_name},{type},{viewable},{published_at},{title},{duration},{url}\n'.format(type=videoInf.type, user_name=videoInf.user_name, viewable=videoInf.viewable, title=videoInf.title.replace(',',' '), url=videoInf.url, duration=videoInf.duration, published_at=videoInf.published_at))
            # print('video_id={},stream_id={},user_id={},user_login={},user_name={}'.format(videoInf.id, videoInf.stream_id, videoInf.user_id, videoInf.user_login, videoInf.user_name))
            print('{user_name},{title},{url}'.format(user_name=videoInf.user_name, viewable=videoInf.viewable, title=videoInf.title, url=videoInf.url, duration=videoInf.duration, published_at=videoInf.published_at))
            if count >= 100:
                break
        # print the ID of your user or do whatever else you want with it
        #print(user.id)
    fc.close()
    await twitch.close()
    

# run this example
asyncio.run(twitch_example())