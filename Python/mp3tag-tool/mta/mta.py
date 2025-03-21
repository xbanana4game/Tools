import os

MP3TAG_PROFILE = os.getenv('USERNAME') + '\\AppData\\Roaming\\Mp3tag\\'

DIRECTORY_BASE = ('$if($grtr($strstr(%_folderpath%,\\\\$getenv(NASDOMAIN)),0),\\\\$getenv(NASDOMAIN)\\Multimedia\\,'
                  '$if($strcmp($left(%_folderpath%,3),C:\\),C:\\Users\\$getenv(USERNAME)\\Downloads\\,'
                  '$left(%_folderpath%,3)))')

YOUTUBE_FILENAME = ('$if($grtr($strstr(%_folderpath%,\\\\$getenv(NASDOMAIN)),0),\\\\$getenv(NASDOMAIN)\\Multimedia\\Videos\\,'
                    '$if($strcmp($left(%_folderpath%,3),C:\\),C:\\Users\\$getenv(USERNAME)\\Downloads\\,'
                    '$left(%_folderpath%,3)Videos\\))'
                    'youtube.com$if($strcmp(%albumartist%,channel),-チャンネル,)\\'
                    '$if(%album%,,__Youtube_Album_Missing\\)'
                    '$if($isdigit(%_covers%),,__Cover_Missing\\)'
                    '$if($strcmp(%albumartist%,youtube.com),_カテゴリ\\,)'
                    '$validate($replace(%album%\\,&,and),_)'
                    # '$regexp($regexp(%artist%,^\W*,),\\W*(.*),)\\'
                    '$if($and(%year%,%comment%),%year% %comment%,%_FILENAME%)')

TWITCH_FILENAME = ('$if($grtr($strstr(%_folderpath%,\\\\$getenv(NASDOMAIN)),0),\\\\$getenv(NASDOMAIN)\\Multimedia\\Videos\\,'
                   '$if($strcmp($left(%_folderpath%,3),C:\\),C:\\Users\\$getenv(USERNAME)\\Downloads\\,'
                   '$left(%_folderpath%,3)Videos\\))'
                   'twitch.tv$if($strcmp(%genre%,twitch.tv clip),-clip,)\\'
                   '$validate(%artist%,_)\\'
                   '%year% $if2(%TVEPISODEID%,%title%)')

CAPTURES_FILENAME = ('$if($grtr($strstr(%_folderpath%,\\\\$getenv(NASDOMAIN)),0),\\\\$getenv(NASDOMAIN)\\Multimedia\\Videos\\,'
                     '$if($strcmp($left(%_folderpath%,3),C:\\),C:\\Users\\$getenv(USERNAME)\\Downloads\\,'
                     '$left(%_folderpath%,3)Videos\\))'
                     'Captures\\'
                     '$replace(%album%\, ,_)\\videos\\'
                     '%title%$if(%tags%,\'[\'%tags%\']\',)')

XXX_FILENAME = (DIRECTORY_BASE +
                'xxx\\$if($grtr(%rating%,3),xxx-high-star,xxx-low-star)\\'
                '$repeat(★,$if2(%rating%,0))$repeat(☆,$sub(5,$if2(%rating%,0)))\\'
                '%album%\\'
                '$if2(%comment%,%_FILENAME%)')

XXX_SIMPLE_FILENAME = (DIRECTORY_BASE +
                       'xxx\\%genre%\\'
                       '$if2(%comment%,%_FILENAME%)$if(%tags%,\'[\'%tags%\']\',)')

ANIME_FILENAME = (DIRECTORY_BASE +
                  'Anime\\%genre%\\'
                  '$regexp(%album%,[ ]\\(.*\\d\\),)$if2( \'(\'%year%\')\',)\\'
                  '$validate(%title%,_)\'[\'%source%\']\'$if2(\'(\'%fid%\')\',\'(\'%crc%\')\')')

MUSIC_FILENAME = (DIRECTORY_BASE +
                  '$if(%AudioMD5%,Music\\,_AudioMD5_Missing\\)'
                  '%genre%\\'
                  '$if2(%album%\\,)'
                  '$if2(%AudioMD5%,$validate(%album%-%title%,_))')


class mtafile:

    def __init__(self, filename):
        self.open(filename)
        self.exec_num = 0

    def __del__(self):
        self.f.close()
        return

    def open(self, filename):
        self.filename = filename
        mta_path = 'C:\\Users\\' + os.getenv('USERNAME') + '\\AppData\\Roaming\\Mp3tag\\data\\actions'
        self.f = open(mta_path + '\\' + filename, 'w', encoding='utf_8_sig')
        return

    def close(self):
        self.f.close()
        return

    def set_start_number(self, value):
        self.exec_num = value
        return

    def format_value(self, field, value):
        out = '[#' + str(self.exec_num) + ']\n'
        out += 'T=5\n'
        out += '1=' + value.rstrip('\n').encode('unicode-escape').decode('utf8') + '\n'
        out += 'F=' + field + '\n'
        out += '\n'
        self.exec_num += 1
        self.f.write(out)
        return

    # 値の規則性を推測し他のフィールドの値とする
    def guess_field(self, field_ori, field_trg):
        out = '[#' + str(self.exec_num) + ']\n'
        out += 'T=7\n'
        out += 'F=' + field_ori + '\n'
        out += '1=' + field_trg + '\n'
        out += '\n'
        self.exec_num += 1
        self.f.write(out)
        return

    def remove_field(self, field):
        out = '[#' + str(self.exec_num) + ']\n'
        out += 'T=9\n'
        out += 'F=' + field + '\n'
        out += '\n'
        self.exec_num += 1
        self.f.write(out)
        return

    def output_file(self, field, output_name, overwrite='0', value3='0'):
        out = '[#' + str(self.exec_num) + ']\n'
        out += 'T=15\n'
        out += 'F=' + field + '\n'
        out += '1=' + output_name.replace('\\', '\\\\') + '\n'
        out += '2=' + overwrite + '\n'
        out += '3=' + value3 + '\n'
        out += '\n'
        self.exec_num += 1
        self.f.write(out)
        return

    def decode(self, string):
        return string.rstrip('\n').encode('unicode-escape').decode('utf8')
