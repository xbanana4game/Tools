import re
import sys
import time

import pyperclip


def add_txt(input_url):
    if re.search(r'youtube.com', input_url) is not None:
        # print(filename)
        # result = re.search('(.*)&pp=.*', filename)
        url = re.sub('&pp=.*', '', input_url)
        print(url)
        result = re.search('v=(.{11})', url)
        if result is not None:
            vid = result.group(1)
        # print(vid)
        output_txt = 'url.txt'
        with open(output_txt, 'a') as f:
            f.write(url + '\n')


def check_clipboard_loop():
    # while True:
        input_url = pyperclip.waitForNewPaste()
        add_txt(input_url)
        # time.sleep(1)


if __name__ == '__main__':
    if len(sys.argv) > 1:
        input_url = sys.argv[1]
        if re.search(r'youtube.com', input_url) is not None:
            add_txt(input_url)
    else:
        check_clipboard_loop()



