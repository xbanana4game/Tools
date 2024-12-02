import csv
import glob
import os
import re
import sys
import time
import yt_dlp
import pyperclip

# yt-dlp.youtube.com-low
# Combining these with the CLI defaults gives:
ydl_opts = \
    {'extract_flat': 'discard_in_playlist',
     'format': 'bestvideo+bestaudio',
     'format_sort': ['res:144', '+vbr', '+abr'],
     'fragment_retries': 10,
     'ignoreerrors': 'only_download',
     'merge_output_format': 'mp4',
     'outtmpl': {'default': '%(upload_date>%Y-%m-%d)s %(id)s(%(format)s).%(ext)s',
                 'pl_thumbnail': ''},
     'paths': {'home': '%USERPROFILE%\\Desktop\\youtube.com-low'},
     'postprocessors': [{'actions': [(yt_dlp.postprocessor.metadataparser.MetadataParserPP.interpretter,
                                      '%(id)s',
                                      '%(meta_episode_id)s'),
                                     (yt_dlp.postprocessor.metadataparser.MetadataParserPP.interpretter,
                                      '%(uploader)s',
                                      '%(meta_artist)s'),
                                     (yt_dlp.postprocessor.metadataparser.MetadataParserPP.interpretter,
                                      '%(categories.0)s',
                                      '%(meta_genre)s'),
                                     (yt_dlp.postprocessor.metadataparser.MetadataParserPP.interpretter,
                                      '%(webpage_url)s',
                                      '%(meta_show)s'),
                                     (yt_dlp.postprocessor.metadataparser.MetadataParserPP.interpretter,
                                      '%(display_id)s',
                                      '%(meta_comment)s'),
                                     (yt_dlp.postprocessor.metadataparser.MetadataParserPP.interpretter,
                                      '%(upload_date>%Y-%m-%d)s',
                                      '%(meta_date)s'),
                                     (yt_dlp.postprocessor.metadataparser.MetadataParserPP.interpretter,
                                      '%(channel_id)s,%(channel_url)s,%(channel)s',
                                      '%(meta_composer)s')],
                         'key': 'MetadataParser',
                         'when': 'pre_process'},
                        {'add_chapters': True,
                         'add_infojson': 'if_exists',
                         'add_metadata': True,
                         'key': 'FFmpegMetadata'},
                        {'already_have_thumbnail': False, 'key': 'EmbedThumbnail'},
                        {'key': 'FFmpegConcat',
                         'only_multi_video': True,
                         'when': 'playlist'}],
     'retries': 10,
     'subtitleslangs': ['ja'],
     'writesubtitles': True,
     'writethumbnail': True}

history_vid = []


def read_history_files(directory):
    files = glob.glob(directory + r"/*.log")
    for file in files:
        read_history_file(file)
    files = glob.glob(directory + r"/*.txt")
    for file in files:
        read_history_file(file)
    return


def read_history_file(filename):
    global history_vid
    with open(filename, 'r') as f_log:
        for url_file in f_log.readlines():
            url = url_file.rstrip()
            vid = ''
            result = re.search('v=(.{11})', url)
            if result is not None:
                vid = result.group(1)
            result = re.search('shorts/(.{11})', url)
            if result is not None:
                vid = result.group(1)
            if vid != '':
                history_vid.append(vid)
        # print(history_url)

def check_dup_vid(vid):
    return vid in history_vid


def add_txt(input_urls, output_txt='url.txt'):
    for input_url in input_urls:
        url = input_url.rstrip()
        vid = input_url.rstrip()
        if re.search(r'youtube.com', input_url) is not None:
            # print(output_txt)
            # result = re.search('(.*)&pp=.*', filename)
            url = re.sub('&pp=.*', '', input_url)
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
        with open(output_txt, 'a') as f_txt:
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
    # URLS = []
    # URLS.append(input_url)
    # with yt_dlp.YoutubeDL(ydl_opts) as ydl:
    #     ydl.download(URLS)


if __name__ == '__main__':
    # read_history_files(os.getenv('CONFIG_DIR') + r"/yt-dlp/")
    if len(sys.argv) > 1:
        input_url = sys.argv[1]
        urls = []
        if re.match('.*.csv.txt', input_url) is not None:
            input_csv = sys.argv[1]
            with open(input_csv, 'r', encoding='utf-8-sig') as f:
                reader_csv = csv.reader(f)
                for row_csv in reader_csv:
                    if len(row_csv) == 2:
                        urls.append(row_csv[1])
            #urls = list(set(urls))
            #urls.sort()
            add_txt(urls)
        elif re.match('.*.txt', input_url) is not None:
            input_txt = sys.argv[1]
            # print(input_txt)
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
