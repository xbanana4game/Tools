import datetime


class Vtb():
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

    def __init__(self, id=-1, wid=-1, title='', date='', domain='', url='', encoder_settings=''):
        self.id = id
        self.wid = wid
        self.title = title
        self.date = date
        self.domain = domain
        self.url = url
        self.encoder_settings = encoder_settings
        return

    def set_date(self, date=None):
        if date is None:
            today = datetime.datetime.now()
            date = today.strftime("%Y-%m-%d")
        self.date = date

    def __str__(self):
        return "{id}:{title}:{url}".format(id=self.id, title=self.title, url=self.url)