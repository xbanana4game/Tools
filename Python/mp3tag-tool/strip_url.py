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
from videodb import videoDB, UrlParser


def output_url_txt(output_txt, output_url_list):
    url_parser = UrlParser()
    with open(output_txt, 'a') as f_txt:
        for output_url in output_url_list:
            url = output_url.rstrip()
            wid = url_parser.get_id(url)
            if wid is None:
                wid = url
            logger.info('ADD {url}'.format(url=url_parser.get_url_simple(url)))
            print('ADD {url}'.format(url=url_parser.get_url_simple(url)))
            f_txt.write(url_parser.get_url_simple(url) + ',' + wid + '\n')
            logger.debug(url + ' vid:' + wid)


def add_url(input_urls, output_txt):
    global db
    global config_skip_quality
    global config_skip_flg
    output_url_list = []
    for input_url in input_urls:
        url = input_url.rstrip()
        if config_skip_flg == '1' and db.is_downloaded(url, quality=config_skip_quality) is True:
            data = db.get_vtb(url, check_wid=True)
            logger.info('SKP {url}: {title}: {format}'.format(url=url, title=data.title, format=data.encoder_settings))
            print('SKP {url}: {title}'.format(url=url, title=data.title, format=data.encoder_settings))
            continue
        output_url_list.append(url)
    output_url_txt(output_txt, output_url_list)
    return


def check_clipboard():
    print('wait for clipboard...')
    input_url = pyperclip.waitForNewPaste()
    add_url([input_url], OUTPUT_FILE_DEFAULT)


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


def strip_url_main(input_file, output_file):
    urls = []
    if re.match('.*.csv.txt', input_file) is not None:
        input_csv = input_file
        with open(input_csv, 'r', encoding='utf-8-sig') as f:
            reader_csv = csv.reader(f)
            for row_csv in reader_csv:
                if len(row_csv) == 2:
                    urls.append(row_csv[1])
        add_url(urls, output_file)
    elif re.match(r'.*\.(txt|log)', input_file) is not None:
        input_txt = input_file
        if os.path.exists(input_txt) == False:
            logger.error('%s not found.' % input_txt)
            print('%s not found.' % input_txt)
            exit(1)
        with open(input_txt, 'r') as f:
            for url in f.readlines():
                urls.append(url.rstrip())
        urls = list(set(urls))
        urls.sort()
        add_url(urls, output_file)
    else:
        add_url([input_file], output_file)


logger = logging.getLogger(__name__)
videodb.set_logger(re.sub(r'\..*', '', os.path.split(__file__)[1]))
OUTPUT_FILE_DEFAULT = 'url.txt'
if __name__ == '__main__':
    logger.info("=================================== START ===================================")
    config_skip_flg = os.environ.get('SKIP_FLG')
    config_skip_quality = os.environ.get('SKIP_QUALITY')
    if config_skip_flg is None:
        logger.info('SKIP_FLG is not defined. [1|0]')
        config_skip_flg = '1'
    if config_skip_quality is not None:
        config_skip_quality = get_quality(config_skip_quality)
    else:
        logger.info('SKIP_QUALITY is not defined. [domain]_[video_quality]_[audio]. like youtube_720p youtube_360p_low, youtube_preview')
    logger.info('config_skip_flg={config_skip_flg}, config_skip_quality={config_skip_quality}'.format(config_skip_flg=config_skip_flg, config_skip_quality=config_skip_quality))
    if len(sys.argv) == 2:
        input_file = sys.argv[1]
        output_file = OUTPUT_FILE_DEFAULT
    elif len(sys.argv) == 3:
        input_file = sys.argv[1]
        output_file = sys.argv[2]
    elif len(sys.argv) == 1:
        # input_file = 'clipboard'
        input_file = input('FILE: ')
        output_file = OUTPUT_FILE_DEFAULT
        # check_clipboard()
    else:
        print('param error strip_url.py [input] [output]')
        exit(1)
    logger.info('input_url={input_url}, output_file={output_file}'.format(input_url=input_file, output_file=output_file))

    directory = os.getenv('CONFIG_DIR') + os.sep + 'videos*.sqlite3'
    dblist = glob.glob(directory, recursive=True)
    for db_file in dblist:
        logger.info(db_file)
        db = videoDB(dbname=db_file)
        strip_url_main(input_file, output_file)
