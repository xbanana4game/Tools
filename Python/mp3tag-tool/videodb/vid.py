import datetime
import logging
import os
import re
import sqlite3
import sys
from sqlite3 import IntegrityError, OperationalError

from mutagen.mp4 import MP4, MP4FreeForm

import videodb


class videoDB:
    VIDEOS_DBNAME = os.getenv('CONFIG_DIR') + os.sep + 'videos.sqlite3'
    CREATE_TABLE = '''
    CREATE TABLE "vid" (
    	"id" INTEGER PRIMARY KEY AUTOINCREMENT,
    	"wid" TEXT NULL,
    	"title" TEXT NULL,
    	"date" TEXT NULL,
    	"domain" TEXT NULL,
    	"url" TEXT NULL,
    	"encoder_settings" TEXT NULL
    )
    '''
    CREATE_TABLE2 = '''
    CREATE UNIQUE INDEX "url" ON "vid" ("url");
    '''
    INSERT_VID = '''
    INSERT INTO "vid" ("date", "wid", "title", "domain", "url", "encoder_settings") VALUES ('{date}', '{wid}', '{title}', '{domain}', '{url}', '{encoder_settings}');
    '''
    DB_VERSION = 1

    def crate_db_file(self):
        self.cur.execute(self.CREATE_TABLE)
        self.cur.execute(self.CREATE_TABLE2)
        self.cur.execute('CREATE TABLE "vtb" (	"ver" INTEGER NOT NULL)')
        self.cur.execute('INSERT INTO "vtb" ("ver") VALUES ({VERSION})'.format(VERSION=self.DB_VERSION))
        self.conn.commit()
        return True

    def add_vid(self, url, title, date=None, encoder_settings='', wid=''):
        if date is None:
            today = datetime.datetime.now()
            date = today.strftime("%Y-%m-%d")
        try:
            domain = re.search(r'http[s]://(.*?)/.*', url).group(1)
        except AttributeError:
            domain = 'Error'
        title = str(title).replace("'", "''")
        encoder_settings_sql = str(encoder_settings).replace("'", "''")
        url_fix = self.trim_url(url)
        sql_cmd = self.INSERT_VID.format(title=title, date=date, domain=domain, url=url_fix, encoder_settings=encoder_settings_sql, wid=wid)
        self.logger.debug(sql_cmd.strip())
        try:
            self.cur.execute(sql_cmd)
        except IntegrityError as e:
            self.logger.info(e)
            self.logger.info('add_vid():SKIP INSERT url={url}'.format(url=url_fix))
            self.update_vid(url_fix, encoder_settings=encoder_settings)
        except OperationalError as e:
            print(e, file=sys.stderr)
            self.logger.error(sql_cmd)
            self.logger.error(e)
        self.conn.commit()
        return sql_cmd

    def __init__(self, dbname=VIDEOS_DBNAME):
        self.logger = logging.getLogger(__name__)
        # log_directory = os.environ.get('USERPROFILE') + '\\Desktop\\' + 'log'
        # log_directory = 'log'
        # FORMAT = '%(asctime)s %(message)s'
        # os.makedirs(log_directory, exist_ok=True)
        # logging.basicConfig(filename=log_directory + '\\vid.log', format=FORMAT, level=logging.DEBUG)
        self.dbname = dbname
        self.conn = sqlite3.connect(self.dbname)
        self.cur = self.conn.cursor()
        if self.check_version() == 0:
            self.crate_db_file()

    def __del__(self):
        self.cur.close()
        self.conn.close()

    def add_mp4_file(self, path):
        mp4 = MP4(path)
        try:
            title = mp4.tags["\xa9nam"][0]
        except:
            title = ''
        try:
            date = mp4.tags["\xa9day"][0]
        except:
            today = datetime.datetime.now()
            date = today.strftime("%Y-%m-%d")
        try:
            encoder_settings_raw: MP4FreeForm = mp4.tags['----:com.apple.iTunes:encodersettings'][0]
            encoder_settings = encoder_settings_raw.decode()
            # encoder_settings = self.conv_encoder_settings(encoder_settings)
        except:
            encoder_settings = ''
        # wid = mp4.tags["tven"][0]
        wid = mp4.tags["\xa9cmt"][0]
        # if len(wid) != 11:
        #     wid = 'NOT WID:{wid}'.format(wid=wid)
        try:
            url_raw: MP4FreeForm = mp4.tags['----:com.apple.iTunes:URL'][0]
            url = url_raw.decode()
            url = self.trim_url(url)
        except:
            self.logger.info('URL is not exist. skip:{path}'.format(path=path))
            return
        self.logger.debug('title={title}:wid={wid}'.format(wid=wid, title=title))
        # print(url)
        self.add_vid(url, title=title, date=date, encoder_settings=encoder_settings, wid=wid)
        return

    def check_version(self):
        try:
            self.cur.execute("SELECT ver FROM vtb")
            version = self.cur.fetchone()[0]
        except sqlite3.OperationalError as e:
            version = 0
        return version

    def update_vid(self, url, title=None, date=None, encoder_settings=None, wid=None):
        vid = self.get_id(url)
        if encoder_settings is not None:
            old = self.get_vid(vid)
            format = videodb.EncorderFormat(encoder_settings)
            encoder_settings = format.compare_encoder_settings(old.get('encoder_settings'))
            encoder_settings = str(encoder_settings).replace("'", "''")

        sql_cmd = "UPDATE vid SET encoder_settings='{encoder_settings}' WHERE id={id}".format(id=vid, encoder_settings=encoder_settings)
        self.conn.execute(sql_cmd)
        self.conn.commit()

    def get_vid(self, vid):
        sql_cmd = 'SELECT "id", "wid", "title", "date", "domain", "url", "encoder_settings" FROM "vid" WHERE  "id"={id}'.format(id=vid)
        self.logger.debug('get_vid():sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd))
        self.cur.execute(sql_cmd)
        data = self.cur.fetchone()
        result = dict()
        result['encoder_settings'] = data[6]
        return result

    def get_id(self, url):
        url_fix = self.trim_url(url)
        sql_cmd = "SELECT id FROM vid WHERE url='{url}'".format(url=url_fix)
        self.cur.execute(sql_cmd)
        row = self.cur.fetchone()
        id = -1
        if row is not None:
            id = row[0]
        self.logger.debug('get_id():return {id},sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd, id=id))
        return int(id)

    def exist_url(self, url):
        url_fix = self.trim_url(url)
        sql_cmd = "SELECT id, encoder_settings FROM vid WHERE url='{url}'".format(url=url_fix)
        print(sql_cmd)
        self.cur.execute(sql_cmd)
        row = self.cur.fetchone()
        if row is not None:
            return True
        return False

    def trim_url(self, url):
        url_fix = url.rstrip()
        url_fix = re.sub('&pp=.*', '', url_fix)
        url_fix = re.sub('&t=.*s', '', url_fix)
        url_fix = re.sub('\?filter=.*', '', url_fix)
        return url_fix

    def is_downloaded(self, url, quality=None):
        vid = self.get_id(url)
        if vid == -1:
            return False
        data = self.get_vid(vid)
        encoder_settings = videodb.EncorderFormat(data['encoder_settings'])
        if quality is not None:
            target_resolution = videodb.conv_encoder_settings_digit(quality)
            self.logger.debug("is_downloaded():target_resolution={target_resolution}, downloaded_resolution={downloaded_resolution}"
                              .format(target_resolution=target_resolution, downloaded_resolution=encoder_settings.height))
            if target_resolution > encoder_settings.height:
                return False
            else:
                return True
        else:
            return True

    def get_vid_info(self, url):
        url_fix = self.trim_url(url)
        sql_cmd = 'SELECT id, wid, title, date, domain, url, encoder_settings FROM vid WHERE  url=\'{url}\''.format(url=url_fix)
        self.logger.debug('get_vid():sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd))
        self.cur.execute(sql_cmd)
        data = self.cur.fetchone()
        result = dict()
        result['id'] = data[0]
        result['wid'] = data[1]
        result['title'] = data[2]
        result['date'] = data[3]
        result['domain'] = data[4]
        result['url'] = data[5]
        result['encoder_settings'] = data[6]
        return result



