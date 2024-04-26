import os
import re


# test.py
# import listfile
# a = listfile.favorite('playlist.txt')
# print(a.getPlaylistURLs('https://www.twitch.tv/'))


class favorite:

    def __init__(self, filename):
        self.open(filename)
        self.exec_num = 0

    def __del__(self):
        self.f.close()
        return

    def open(self, filename):
        self.filename=filename
        is_file = os.path.isfile(filename)
        if not is_file:
            fw = open(filename, 'w')
            fw.close()
        self.f = open(filename, 'r', encoding='utf_8')
        return
        
    def getPlaylistURLs(self, remove):
        playlist = []
        for data in self.f:
            url=data.rstrip('\n')
            url = re.sub(remove, '', url)
            playlist.append(url)
        return playlist
        
    def close(self):
        self.f.close()
        return
