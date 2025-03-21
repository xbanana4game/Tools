import datetime
import logging
import os
import re
import sqlite3
import sys
from sqlite3 import IntegrityError, OperationalError

from mutagen.mp4 import MP4, MP4FreeForm

import videodb


def trim_url(url):
    url_fix = url.rstrip()
    url_fix = re.sub(r'&pp=.*', '', url_fix)
    url_fix = re.sub(r'&t=.*s', '', url_fix)
    url_fix = re.sub(r'\?filter=.*', '', url_fix)
    return url_fix


class videoDB:
    VIDEOS_DBNAME = os.getenv('CONFIG_DIR') + os.sep + 'videos.sqlite3'
    DB_VERSION = 2

    def __init__(self, dbname=VIDEOS_DBNAME):
        self.logger = logging.getLogger(__name__)
        self.logger.debug("__init__():dbname={dbname}".format(dbname=dbname))
        self.dbname = dbname
        self.conn = sqlite3.connect(self.dbname)
        self.cur = self.conn.cursor()
        if self.check_version() == 0:
            self.crate_db_file()

    def __del__(self):
        self.cur.close()
        self.conn.close()

    def crate_db_file(self):
        self.cur.execute(videodb.CREATE_TABLE_VID1)
        self.cur.execute(videodb.CREATE_TABLE_VID2)
        self.cur.execute('CREATE TABLE "vtb" (	"ver" INTEGER NOT NULL)')
        self.cur.execute('INSERT INTO "vtb" ("ver") VALUES ({VERSION})'.format(VERSION=self.DB_VERSION))
        self.conn.commit()
        return True

    def add_vid(self, url, title, date=None, encoder_settings='', wid='', resolution='', comment='', status: int = 0):
        self.logger.debug("add_vid():url={url}, status={status}".format(url=url, status=status))
        if date is None:
            today = datetime.datetime.now()
            date = today.strftime("%Y-%m-%d")
        try:
            domain = re.search(r'http[s]://(.*?)/.*', url).group(1)
        except AttributeError:
            domain = 'Error'
        title_sql = str(title).replace("'", "''")
        encoder_settings_sql = str(encoder_settings).replace("'", "''")
        url_fix = trim_url(url)
        sql_cmd = (videodb.INSERT_VID
                   .format(title=title_sql, date=date, domain=domain, url=url_fix, encoder_settings=encoder_settings_sql, wid=wid,
                           resolution=resolution, comment=comment, status=status))
        self.logger.debug("add_vid():sql_cmd='{sql_cmd}'".format(sql_cmd=sql_cmd.strip()))
        try:
            self.cur.execute(sql_cmd)
            self.logger.info('add_vid():INSERT sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd.strip()))
            print("INSERT {url}".format(url=url_fix))
        except IntegrityError as e:
            old = self.get_vtb(url_fix)
            self.logger.debug('add_vid(): old={old} status({status})'.format(old=old, status=old.status))
            video_format = videodb.EncorderFormat(old.encoder_settings)
            encoder_settings_new = video_format.compare_encoder_settings(encoder_settings)
            if encoder_settings_new != old.encoder_settings:
                self.logger.info("add_vid(): UPDATE encoder_settings before=\"{before}\", after=\"{after}\""
                                 .format(before=old.encoder_settings, after=encoder_settings_new))
                self.update_vid(url_fix, encoder_settings=encoder_settings, comment=comment, status=status)
                print("UPDATE encoder_settings {url}".format(url=url_fix))
            if old.status != status:
                print("UPDATE status {url}".format(url=url_fix))
                self.logger.info("add_vid(): UPDATE status {url}".format(url=url_fix))
                self.update_vid(url_fix, status=status)
        except OperationalError as e:
            print("SKIP {url}".format(url=url_fix))
            self.logger.error('add_vid():SKIP INSERT url={url} {error}'.format(url=url_fix, error=e))
            self.logger.error(sql_cmd)
        self.conn.commit()
        return sql_cmd

    def check_version(self):
        try:
            self.cur.execute("SELECT ver FROM vtb")
            version = self.cur.fetchone()[0]
        except sqlite3.OperationalError as e:
            version = 0
        return version

    def update_vid(self, url, title=None, date=None, encoder_settings=None, comment=None, status=None):
        vid = self.get_id(url)
        if vid == -1:
            return False
        if encoder_settings is not None:
            encoder_settings_sql = str(encoder_settings).replace("'", "''")
            sql_cmd = "UPDATE vid SET encoder_settings='{encoder_settings}' WHERE id={id}".format(id=vid, encoder_settings=encoder_settings_sql)
            self.logger.debug('update_vid():sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd))
            self.conn.execute(sql_cmd)
        if comment is not None:
            comment_sql = str(comment).replace("'", "''")
            sql_cmd = "UPDATE vid SET comment='{comment}' WHERE id={id}".format(id=vid, comment=comment_sql)
            self.logger.debug('update_vid():sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd))
            self.conn.execute(sql_cmd)
        if status is not None:
            sql_cmd = "UPDATE vid SET status={status} WHERE id={id}".format(id=vid, status=status)
            self.logger.debug('update_vid():sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd))
            self.conn.execute(sql_cmd)
        if title is not None:
            title_sql = str(title).replace("'", "''")
            sql_cmd = "UPDATE vid SET title='{title}' WHERE id={id}".format(id=vid, title=title_sql)
            self.logger.debug('update_vid():sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd))
            self.conn.execute(sql_cmd)
        if date is not None:
            sql_cmd = "UPDATE vid SET date='{date}' WHERE id={id}".format(id=vid, date=date)
            self.logger.debug('update_vid():sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd))
            self.conn.execute(sql_cmd)
        self.conn.commit()
        return True

    def get_vid(self, vid):
        sql_cmd = 'SELECT "id", "wid", "title", "date", "domain", "url", "encoder_settings" FROM "vid" WHERE  "id"={id}'.format(id=vid)
        self.logger.debug('get_vid():sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd))
        self.cur.execute(sql_cmd)
        data = self.cur.fetchone()
        result = dict()
        result['encoder_settings'] = data[6]
        return result

    def get_id(self, url):
        url_fix = trim_url(url)
        sql_cmd = "SELECT id FROM vid WHERE url='{url}'".format(url=url_fix)
        self.cur.execute(sql_cmd)
        row = self.cur.fetchone()
        id = -1
        if row is not None:
            id = row[0]
        self.logger.debug('get_id():return {id},sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd, id=id))
        return int(id)

    def exist_url(self, url):
        url_fix = trim_url(url)
        sql_cmd = "SELECT id, encoder_settings FROM vid WHERE url='{url}'".format(url=url_fix)
        print(sql_cmd)
        self.cur.execute(sql_cmd)
        row = self.cur.fetchone()
        if row is not None:
            return True
        return False

    def is_downloaded(self, url, quality=None):
        vid = self.get_id(url)
        if vid == -1:
            self.logger.info("is_downloaded():return False:url is not exist in db.")
            return False
        data = self.get_vid(vid)
        encoder_settings = videodb.EncorderFormat(data['encoder_settings'])
        if quality is not None:
            target_resolution = videodb.conv_encoder_settings_digit(quality)
            if target_resolution > encoder_settings.formats_max:
                target_resolution = encoder_settings.formats_max
            self.logger.debug("is_downloaded():target_resolution={target_resolution}, downloaded_resolution={downloaded_resolution}"
                              .format(target_resolution=target_resolution, downloaded_resolution=encoder_settings.height))
            if target_resolution > encoder_settings.height:
                self.logger.info("is_downloaded():return False:url is exist in db. but format is not good. download better quality.")
                return False
            else:
                self.logger.info("is_downloaded():return True:url is exist in db. but format is better. need not download.")
                return True
        else:
            self.logger.info("is_downloaded():return True:url is already exist in db.")
            return True

    def get_vtb(self, url):
        url_fix = trim_url(url)
        sql_cmd = 'SELECT id, wid, title, date, domain, url, encoder_settings, comment, status FROM vid WHERE  url=\'{url}\''.format(url=url_fix)
        self.logger.debug('get_vtb():sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd))
        self.cur.execute(sql_cmd)
        data = self.cur.fetchone()
        if data is not None:
            result = videodb.Vtb()
            result.id = data[0]
            result.wid = data[1]
            result.title = data[2]
            result.date = data[3]
            result.domain = data[4]
            result.url = data[5]
            result.encoder_settings = data[6]
            result.comment = data[7]
            result.status = data[8] or 0
            return result
        return None

    def get_vtb_all(self):
        sql_cmd = 'SELECT id, wid, title, date, domain, url, encoder_settings, comment, status FROM vid'
        self.logger.debug('get_vtb_all():sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd))
        self.cur.execute(sql_cmd)
        vtb_list = self.cur.fetchall()
        result = []
        for data in vtb_list:
            vtb = videodb.Vtb()
            vtb.id = data[0]
            vtb.wid = data[1]
            vtb.title = data[2]
            vtb.date = data[3]
            vtb.domain = data[4]
            vtb.url = data[5]
            vtb.encoder_settings = data[6]
            vtb.comment = data[7]
            vtb.status = data[8] or 0
            result.append(vtb)
        return result

    def delete(self, url):
        sql_cmd = "DELETE FROM vid WHERE url='{url}'".format(url=url)
        self.logger.debug('delete():sql_cmd={sql_cmd}'.format(sql_cmd=sql_cmd))
        self.conn.execute(sql_cmd)
        self.conn.commit()
        return


if __name__ == '__main__':
    FORMAT = '%(levelname)-9s  %(asctime)s  [%(name)s] %(message)s'
    logging.basicConfig(stream=sys.stdout, format=FORMAT, level=logging.DEBUG)
    db = videoDB()
    print("%s (ver.%d)" % (db.VIDEOS_DBNAME, db.check_version()))
