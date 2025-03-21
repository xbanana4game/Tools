import datetime

CREATE_TABLE_VID1 = '''
CREATE TABLE "vid" (
	"id" INTEGER PRIMARY KEY AUTOINCREMENT,
	"wid" TEXT NULL,
	"title" TEXT NULL,
	"date" TEXT NULL,
	"domain" TEXT NULL,
	"url" TEXT NULL,
	"encoder_settings" TEXT NULL,
	status INTEGER NULL DEFAULT 0,
	comment TEXT NULL
)
'''
CREATE_TABLE_VID2 = '''
CREATE UNIQUE INDEX "url" ON "vid" ("url");
'''
INSERT_VID = '''
INSERT INTO "vid" ("date", "wid", "title", "domain", "url", "encoder_settings", comment, status) VALUES ('{date}', '{wid}', '{title}', '{domain}', '{url}', '{encoder_settings}', '{comment}', {status});
'''


class Vtb:

    def __init__(self, id=-1, wid=-1, title='', date='', domain='', url='', encoder_settings='', status=0, comment=''):
        self.id = id
        self.wid = wid
        self.title = title
        self.date = date
        self.domain = domain
        self.url = url
        self.encoder_settings = encoder_settings
        self.resolution = ''
        self.status = status
        self.comment = comment
        return

    def set_date(self, date=None):
        if date is None:
            today = datetime.datetime.now()
            date = today.strftime("%Y-%m-%d")
        self.date = date

    def __str__(self):
        return "{id}:{title}:{url}".format(id=self.id, title=self.title, url=self.url)
