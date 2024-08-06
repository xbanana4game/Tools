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


def add_txt(input_urls, output_txt='url.txt'):
    for input_url in input_urls:
        if re.search(r'youtube.com', input_url) is not None:
            # print(output_txt)
            # result = re.search('(.*)&pp=.*', filename)
            url = re.sub('&pp=.*', '', input_url)
            # print(url)
            result = re.search('v=(.{11})', url)
            if result is not None:
                vid = result.group(1)
            # print(vid)

            with open(output_txt, 'a') as f_txt:
                f_txt.write(url + '\n')
                print(url)


def check_clipboard_loop():
    while True:
        check_clipboard()
        time.sleep(0.1)


def check_clipboard():
    input_url = pyperclip.waitForNewPaste()
    add_txt([input_url])
    # URLS = []
    # URLS.append(input_url)
    # with yt_dlp.YoutubeDL(ydl_opts) as ydl:
    #     ydl.download(URLS)


if __name__ == '__main__':
    if len(sys.argv) > 1:
        input_url = sys.argv[1]
        if re.match('.*.txt', input_url) is not None:
            input_txt = sys.argv[1]
            # print(input_txt)
            urls = []
            with open(input_txt, 'r') as f:
                for url in f.readlines():
                    urls.append(url.rstrip())
            urls = list(set(urls))
            add_txt(urls)
        elif re.search(r'youtube.com', input_url) is not None:
            add_txt([input_url])
    else:
        check_clipboard()


