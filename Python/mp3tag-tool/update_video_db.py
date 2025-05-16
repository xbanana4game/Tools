import datetime
import glob
import logging
import os
import re
import sys
import time

from mutagen.mp4 import MP4FreeForm, MP4

import videodb
from videodb import videoDB


def add_mp4_file(path):
    logger.info('========== {path} =========='.format(path=path))
    mp4 = MP4(path)
    logger.debug(mp4.keys())
    try:
        title = mp4.tags["\xa9nam"][0]
    except KeyError:
        title = ''
    try:
        date = mp4.tags["\xa9day"][0]
    except KeyError:
        logger.warning('date is not exist.')
        date = datetime.datetime.now().strftime("%Y-%m-%d")
    try:

        if list(mp4.keys()).count('----:com.apple.iTunes:encodersettings') != 0:
            encoder_settings_raw: MP4FreeForm = mp4.tags['----:com.apple.iTunes:encodersettings'][0]
        else:
            encoder_settings_raw: MP4FreeForm = mp4.tags['----:com.apple.iTunes:ENCODERSETTINGS'][0]
        encoder_settings = encoder_settings_raw.decode()
    except KeyError:
        logger.warning('----:com.apple.iTunes:encodersettings is not exist.')
        encoder_settings = ''
    try:
        resolution_raw: MP4FreeForm = mp4.tags['----:com.apple.iTunes:RESOLUTION'][0]
        resolution = resolution_raw.decode()
    except KeyError:
        logger.warning('----:com.apple.iTunes:RESOLUTION is not exist.')
        resolution = ''
    try:
        if list(mp4.keys()).count('----:com.apple.iTunes:RATING') != 0:
            status_raw: MP4FreeForm = mp4.tags['----:com.apple.iTunes:RATING'][0]
        else:
            status_raw: MP4FreeForm = mp4.tags['----:com.apple.iTunes:rating'][0]
        status = int(status_raw.decode())
    except KeyError:
        logger.warning('----:com.apple.iTunes:RATING is not exist.')
        status = 0
    # wid = mp4.tags["tven"][0]
    try:
        wid = mp4.tags["\xa9cmt"][0]
        # if len(wid) != 11:
        #     wid = 'NOT WID:{wid}'.format(wid=wid)
    except KeyError:
        logger.warning('comment is not exist. skip:{path}'.format(path=path))
        return False
    try:
        url_raw: MP4FreeForm = mp4.tags['----:com.apple.iTunes:URL'][0]
        url = url_raw.decode()
        url = videodb.trim_url(url)
    except KeyError:
        logger.warning('----:com.apple.iTunes:URL is not exist. skip:{path}'.format(path=path))
        return False
    logger.debug('title={title}:wid={wid}'.format(wid=wid, title=title))
    db.add_vid(url, title=title, date=date, encoder_settings=encoder_settings, wid=wid, resolution=resolution, comment=resolution, status=status)
    return True


def update_video_db(directory):
    logger.info('========== Start update_video_db {directory} =========='.format(directory=directory))
    filelist = glob.glob(directory + '/**/*.mp4', recursive=True)
    for file in filelist:
        print(file)
        add_mp4_file(file)
    filelist = glob.glob(directory + '/**/*.m4a', recursive=True)
    for file in filelist:
        print(file)
        add_mp4_file(file)
    logger.info('========== END update_video_db =========='.format(directory=directory))
    time.sleep(5)


logger = logging.getLogger(__name__)
videodb.set_logger(re.sub(r'\..*', '', os.path.split(__file__)[1]))
db = videoDB()
if __name__ == '__main__':
    DIRECTORY_DEFAULT = os.environ.get('USERPROFILE') + '\\Downloads'
    directory_list = []
    if len(sys.argv) > 1:
        directory_list = sys.argv[1:]
    else:
        print('DEFAULT:' + DIRECTORY_DEFAULT)
        directory_list.append(input('DIR:') or DIRECTORY_DEFAULT)
    logger.info('directory_list:%s' % directory_list)
    for target in directory_list:
        print(target)
        update_video_db(target)
    time.sleep(5)
