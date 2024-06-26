from apiclient.discovery import build
import json
import configparser
import os
import csv
from datetime import date
import datetime
import subprocess
import time
from zoneinfo import ZoneInfo


def conv_time(iso_str):
    dt = None
    try:
        #dt = datetime.datetime.fromisoformat(iso_str)
        dt = datetime.datetime.strptime(iso_str, '%Y-%m-%dT%H:%M:%SZ')
    except ValueError:
        dt = datetime.datetime.strptime('1970-01-01T00:00:00Z', '%Y-%m-%dT%H:%M:%SZ')
    return dt.strftime('%Y/%m/%d %H:%M:%S')



# SETTINGS
config_filename = os.getenv('CONFIG_DIR') + '\\youtube.ini'
proc = subprocess.Popen([r"c:\Windows\system32\notepad.exe", config_filename])
while True:
    return_code = proc.poll()
    if return_code is None:
        time.sleep(3)
    else:
        break

# READ CONFIG
config = configparser.ConfigParser()
config.read(config_filename, encoding='utf-8')
YOUTUBE_API_KEY = config.get("youtube", "YOUTUBE_API_KEY")
PUBLISHED_AFTER = config.get("search", "PUBLISHED_AFTER")
MAXRESULTS = config.get("search", "MAXRESULTS")
VIDEO_DURATION = config.get("search", "VIDEODURATION")
#
ORDER = config.get("search", "ORDER")

SEARCH_WORD=input("SEARCH WORD: ")

# OUTPUT CSV
today = datetime.datetime.now()
fc = open(
    os.getenv('USERPROFILE') + '\\Downloads\\' + 'youtube-' + SEARCH_WORD + today.strftime("_%Y%m%d%H%M") + '.csv', 'w',
    encoding='utf-8-sig', newline="")
writer = csv.writer(fc)
writer.writerow(['DL', 'channel', 'channelId', 'publishedAt', 'title', 'url'])


# YOUTUBE API
youtube = build('youtube', 'v3', developerKey=YOUTUBE_API_KEY)

page = 1
pageToken = None
while page <= 5:
    if page == 1:
        response = youtube.search().list(
            part="snippet",
            type="video",
            q=SEARCH_WORD,
            publishedAfter=PUBLISHED_AFTER,
            videoDuration=VIDEO_DURATION,
            maxResults=MAXRESULTS,
            order=ORDER  # 日付順にソート
        ).execute()
    else:
        response = youtube.search().list(
            part="snippet",
            type="video",
            q=SEARCH_WORD,
            publishedAfter=PUBLISHED_AFTER,
            videoDuration=VIDEO_DURATION,
            maxResults=MAXRESULTS,
            pageToken=pageToken,
            order=ORDER  # 日付順にソート
        ).execute()

    for item in response.get("items", []):
        if item["id"]["kind"] != "youtube#video":
            continue
        print('{publishedAt},{title},{url}'.format(
            url='https://www.youtube.com/watch?v={videoid}'.format(videoid=item['id']['videoId']),
            publishedAt=conv_time(item['snippet']['publishedAt']),
            title=item['snippet']['title'])
        )
        writer.writerow(
            ['0', item['snippet']['channelTitle'], item['snippet']['channelId'], conv_time(item['snippet']['publishedAt']),
             '{:.50}'.format(item['snippet']['title']),
             'https://www.youtube.com/watch?v={videoid}'.format(videoid=item['id']['videoId'])])
        # print('*' * 10)
        # print(json.dumps(item, indent=2, ensure_ascii=False))
        # print('*' * 10)

    page += 1
    if response.get('nextPageToken') is None:
        pageToken = None
        break
    else:
        pageToken = response['nextPageToken']
        print(response['pageInfo'])
        continue

fc.close()
exit(0)




