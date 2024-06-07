from apiclient.discovery import build
import json
import configparser
import os
import csv
from datetime import date
import datetime
import subprocess
import time

config = configparser.ConfigParser()
config_filename=os.getenv('CONFIG_DIR')+'\\youtube.ini'
proc = subprocess.Popen([r"c:\Windows\system32\notepad.exe", config_filename])
while True:
    return_code = proc.poll()
    if return_code is None:
        time.sleep(3)
    else:
        break
         
config.read(config_filename, encoding='utf-8')
YOUTUBE_API_KEY = config.get("youtube", "YOUTUBE_API_KEY")
PUBLISHED_AFTER = config.get("youtube", "PUBLISHED_AFTER")
MAXRESULTS = config.get("youtube", "MAXRESULTS")
VIDEODURATION = config.get("youtube", "VIDEODURATION")

today=datetime.datetime.now()
fc = open(os.getenv('USERPROFILE')+'\\Downloads\\'+'youtube-'+today.strftime("%Y%m%d%H%M")+'.csv', 'w', encoding='utf-8-sig', newline="")
writer = csv.writer(fc)
writer.writerow(['dl','channel','publishedAt','title','url'])

youtube = build('youtube', 'v3', developerKey=YOUTUBE_API_KEY)

channel_listfile=os.getenv('CONFIG_DIR')+'\\youtube_channel.csv'
proc = subprocess.Popen([r"c:\Windows\system32\notepad.exe", channel_listfile])
while True:
    return_code = proc.poll()
    if return_code is None:
        time.sleep(3)
    else:
        break

CHANNEL_ID_LIST=[]
CHANNEL={}
fr=open(channel_listfile, 'r', encoding='utf-8')
reader = csv.reader(fr)
fr.readline()
for row in reader:
    if len(row) == 3:
        print(row[2])
        CHANNEL_ID_LIST.append(row[0])
        CHANNEL[row[0]]=row[2]

fr.close()

for CHANNEL_ID in CHANNEL_ID_LIST:
    page = 1
    pageToken = None
    while page<=5:
        if page == 1:
            response = youtube.search().list(
                part = "snippet",
                channelId = CHANNEL_ID,
                publishedAfter = PUBLISHED_AFTER,
                maxResults = MAXRESULTS,
                videoDuration = VIDEODURATION,
                type="video",
                order = "date"
            ).execute()
        else:
            response = youtube.search().list(
                part = "snippet",
                channelId = CHANNEL_ID,
                publishedAfter = PUBLISHED_AFTER,
                maxResults = MAXRESULTS,
                pageToken = pageToken,
                videoDuration = VIDEODURATION,
                type="video",
                order = "date"
            ).execute()
        
        for item in response.get("items", []):
            if item["id"]["kind"] != "youtube#video":
                continue
            print('{publishedAt},{title},{url}'.format(
                url='https://www.youtube.com/watch?v={videoid}'.format(videoid=item['id']['videoId']),
                publishedAt=item['snippet']['publishedAt'],
                title=item['snippet']['title'])
            )
            writer.writerow(['0',CHANNEL[item['snippet']['channelId']],item['snippet']['publishedAt'],'{:.50}'.format(item['snippet']['title']),'https://www.youtube.com/watch?v={videoid}'.format(videoid=item['id']['videoId'])])
            # print('*' * 10)
            # print(json.dumps(item, indent=2, ensure_ascii=False))
            # print('*' * 10)
            
        page+=1
        if response.get('nextPageToken') is None:
            pageToken = None
            break
        else:
            pageToken = response['nextPageToken']
            print(response['pageInfo'])
            continue
        

    
fc.close()