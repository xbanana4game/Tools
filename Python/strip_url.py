import csv
import datetime
import glob
import logging
import os
import re
import sys
import time
import yt_dlp
import pyperclip

import videodb
from videodb import videoDB


def add_txt(input_urls, output_txt='url.txt'):
    global db
    global config_skip_quality
    global config_skip_flg
    with open(output_txt, 'a') as f_txt:
        for input_url in input_urls:
            url = input_url.rstrip()
            vid = input_url.rstrip()
            if config_skip_flg == '1' and db.is_downloaded(url, quality=config_skip_quality) is True:
                data = db.get_vtb(url)
                logger.info('SKP {url}: {title}: {format}'.format(url=url, title=data.title, format=data.encoder_settings))
                print('SKP {url}: {title}'.format(url=url, title=data.title, format=data.encoder_settings))
                continue
            logger.info('ADD {url}'.format(url=videodb.trim_url(url)))
            print('ADD {url}'.format(url=videodb.trim_url(url)))
            if re.search(r'youtube.com', input_url) is not None:
                # print(output_txt)
                # result = re.search('(.*)&pp=.*', filename)
                url = re.sub('&pp=.*', '', url)
                url = re.sub('&t=.*s', '', url)
                # print(url)
                result = re.search('v=(.{11})', url)
                if result is not None:
                    vid = result.group(1)
                result = re.search('shorts/(.{11})', url)
                if result is not None:
                    vid = result.group(1)
                # print(vid)

                # if check_dup_vid(vid) is False:
                #     print('skip: '+vid)
                #     continue
            elif re.search(r'twitch.com', input_url) is not None:
                pass
            f_txt.write(url + ',' + vid + '\n')
            # print(url + ' vid:' + vid)
    return


def check_clipboard_loop():
    while True:
        check_clipboard()
        time.sleep(0.1)


def check_clipboard():
    print('wait for clipboard...')
    input_url = pyperclip.waitForNewPaste()
    add_txt([input_url])


def get_quality(text):
    QUALITY_STR = dict()
    QUALITY_STR['low'] = 'mp4-low'
    QUALITY_STR['high'] = 'mp4-high'
    QUALITY_STR['audio'] = '0'
    QUALITY_STR['preview'] = '0'
    quality = re.match(r'(.*)_(.*)_(.*)', text)
    if quality is not None:
        return QUALITY_STR.get(quality.group(2)) or quality.group(2)
    quality = re.match(r'(.*)_(.*)', text)
    if quality is not None:
        return QUALITY_STR.get(quality.group(2)) or quality.group(2)

    return None


logger = logging.getLogger(__name__)
today = datetime.datetime.now().strftime("%Y%m%d")
FORMAT = '%(levelname)-9s  %(asctime)s  [%(name)s] %(message)s'
log_directory = os.environ.get('USERPROFILE') + '\\Downloads\\' + 'yt-dlp-log'
# log_directory = 'log'
os.makedirs(log_directory, exist_ok=True)
logging.basicConfig(filename=log_directory + '\\strip_url_{today}.log'.format(today=today), format=FORMAT, level=logging.INFO)
# logging.basicConfig(stream=sys.stdout, format=FORMAT, level=logging.DEBUG)

if __name__ == '__main__':
    logger.info("=================================== START ===================================")
    db = videoDB()
    config_skip_flg = os.environ.get('SKIP_FLG')
    config_skip_quality = os.environ.get('SKIP_QUALITY')
    if config_skip_quality is not None:
        config_skip_quality = get_quality(config_skip_quality)
    logger.info('config_skip_flg={config_skip_flg}'.format(config_skip_flg=config_skip_flg))
    logger.info('config_skip_quality={config_skip_quality}'.format(config_skip_quality=config_skip_quality))
    if len(sys.argv) > 1:
        input_url = sys.argv[1]
        logger.info('input_url={input_url}'.format(input_url=input_url))
        urls = []
        if re.match('.*.csv.txt', input_url) is not None:
            input_csv = sys.argv[1]
            with open(input_csv, 'r', encoding='utf-8-sig') as f:
                reader_csv = csv.reader(f)
                for row_csv in reader_csv:
                    if len(row_csv) == 2:
                        urls.append(row_csv[1])
            add_txt(urls)
        elif re.match('.*.txt', input_url) is not None:
            input_txt = sys.argv[1]
            if os.path.exists(input_txt) == False:
                logger.error('%s not found.' % input_txt)
                print('%s not found.' % input_txt)
                exit(1)
            with open(input_txt, 'r') as f:
                for url in f.readlines():
                    urls.append(url.rstrip())
            urls = list(set(urls))
            urls.sort()
            add_txt(urls)
        else:
            add_txt([input_url])
    else:
        check_clipboard()
