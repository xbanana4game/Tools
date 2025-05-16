import re


class SiteParse:
    def __init__(self, domain):
        self.domain = domain

    def get_wid(self, url):
        return None

    def get_id(self, url):
        return self.get_wid(url)

    def get_url_simple(self, url):
        return url


class YoutubeParse(SiteParse):
    def __init__(self):
        super().__init__('www.youtube.com')

    def get_url_simple(self, url):
        url_fix = re.sub(r'&pp=.*', '', url)
        url_fix = re.sub(r'&t=.*s', '', url_fix)
        return url_fix

    def get_wid(self, url):
        vid = None
        url_fix = re.sub(r'&pp=.*', '', url)
        url_fix = re.sub(r'&t=.*s', '', url_fix)
        pattern = re.search(r'v=(.{11})', url_fix)
        if pattern is not None:
            vid = pattern.group(1)
        pattern = re.search(r'shorts/(.{11})', url_fix)
        if pattern is not None:
            vid = pattern.group(1)
        return vid


class TwitchParse(SiteParse):
    def __init__(self):
        super().__init__('www.twitch.tv')

    def get_wid(self, url):
        vid = None
        pattern = re.search(r'videos/(.{10})', url)
        if pattern is not None:
            vid = 'v' + pattern.group(1)
        pattern = re.search(r'clip/(.*)', url)
        if pattern is not None:
            vid = 'v' + pattern.group(1)
        return vid

    def get_id(self, url):
        vid = None
        pattern = re.search(r'videos/(.{10})', url)
        if pattern is not None:
            vid = pattern.group(1)
        pattern = re.search(r'clip/(.*)', url)
        if pattern is not None:
            vid = pattern.group(1)
        return vid


class TwitchclipParse(SiteParse):
    def __init__(self):
        super().__init__('clips.twitch.tv')

    def get_wid(self, url):
        vid = None
        pattern = re.search(r'clips.twitch.tv/(.*)', url)
        if pattern is not None:
            vid = 'v' + pattern.group(1)
        return vid


class XvideosParse(SiteParse):
    def __init__(self):
        super().__init__('www.xvideos.com')

    def get_wid(self, url):
        vid = None
        pattern = re.search(r'/video\.(.*)/', url)
        if pattern is not None:
            vid = pattern.group(1)
        return vid


class PornhubParse(SiteParse):
    def __init__(self):
        super().__init__('jp.pornhub.com')

    def get_wid(self, url):
        vid = None
        result = re.search(r'viewkey=(.*)', url)
        if result is not None:
            vid = result.group(1)
        return vid


class UrlParser:
    def __init__(self):
        self.url_parser_class = dict()
        self._add_parse_class(YoutubeParse())
        self._add_parse_class(TwitchParse())
        self._add_parse_class(XvideosParse())
        self._add_parse_class(PornhubParse())
        self._add_parse_class(TwitchclipParse())

    def get_domain(self, url):
        pattern = re.search(r'http[s]://(.*?)/.*', url)
        if pattern is not None:
            domain = pattern.group(1)
            return domain

    def get_wid(self, url):
        domain = self.get_domain(url)
        get_vid_class: SiteParse = self.url_parser_class.get(domain)
        if get_vid_class is not None:
            return get_vid_class.get_wid(url)
        return None

    def get_id(self, url):
        domain = self.get_domain(url)
        get_vid_class: SiteParse = self.url_parser_class.get(domain)
        if get_vid_class is not None:
            return get_vid_class.get_id(url)
        return None

    def get_url_simple(self, url):
        domain = self.get_domain(url)
        get_vid_class: SiteParse = self.url_parser_class.get(domain)
        if get_vid_class is not None:
            return get_vid_class.get_url_simple(url)
        return None

    def _add_parse_class(self, parser: SiteParse):
        self.url_parser_class[parser.domain] = parser


if __name__ == '__main__':
    url_parser = UrlParser()
    url_test = r'https://www.youtube.com/shorts/12345678901'
    print(url_parser.get_url_simple(url_test))
    url_test = r'https://www.youtube.com/watch?v=12345678901&pp=12345678901'
    print(url_parser.get_wid(url_test))
    url_test = r'https://www.youtube.com/videos/INVALID'
    print(url_parser.get_wid(url_test))
    url_test = r'https://www.twitch.tv/videos/1234567890'
    print(url_parser.get_wid(url_test))
    url_test = 'https://www.xvideos.com/video.12345678901/ABD'
    print(url_parser.get_wid(url_test))
    url_test = 'https://notexist.domain/ABC'
    print(url_parser.get_wid(url_test))
    url_test = 'https://www.twitch.tv/k4sen/clip/asdfghjklqwertyuiop'
    print(url_parser.get_wid(url_test))
    url_test = 'https://jp.pornhub.com/view_video.php?viewkey=1234567890123'
    print(url_parser.get_wid(url_test))
    url_test = 'https://clips.twitch.tv/OriginalProudTeaKevinTurtle-by59pF4ZqHZ2X2yb'
    print(url_parser.get_wid(url_test))
