from selenium.webdriver.common.by import By
import requests
from bs4 import BeautifulSoup
from selenium import webdriver
from time import sleep
import datetime
import os
import re
import csv
import configparser
from selenium.webdriver.chrome.options import Options
import operator

config = configparser.ConfigParser()
config.read(os.getenv('CONFIG_DIR') + '\\webscraping.ini', encoding='utf-8')
SITE_NAME = config.get("site", "SITE_NAME")
EPISODE_SEARCH = config.get("site", "EPISODE_SEARCH")
EPISODE_SEARCH_FILE = eval(config.get("site", "EPISODE_SEARCH_FILE"))

options = Options()
options.add_argument('--log-level=3')
options.add_experimental_option('excludeSwitches', ['enable-logging'])
driver = webdriver.Chrome(options=options)


# sort_rowで指定した列を並び替える関数
def sort_csv(csv_file, sort_row: int, desc: bool = False):
    '''
    第一引数：編集するCSVファイルをフルパスで指定
    第二引数：ソートする列を数字で指定(左から0,1,2・・・)
    第三引数：昇順(False)降順(True)を指定
    '''
    # 今回作成したuser_list_csvを開く
    csv_data = csv.reader(open(csv_file, encoding='utf-8-sig'), delimiter=',')
    # ヘッダー情報を取得
    header = next(csv_data)
    # ヘッダー以外の列を並び替える
    sort_result = sorted(csv_data, reverse=desc, key=operator.itemgetter(sort_row))

    # 新規ファイルとしてuser_list_csvを開く
    with open(csv_file, "w", encoding='utf-8-sig', newline="") as f:
        # ヘッダーと並び替え結果をファイルに書き込む
        data = csv.writer(f, delimiter=',')
        data.writerow(header)
        for r in sort_result:
            data.writerow(r)


while True:
    url = input('Enter URL : ')
    driver.get(url)

    # sleep(3)
    # captcha = input('Enter CAPTCHA... : ')
    # if captcha != '':
    # driver.find_element(By.NAME,"passster_captcha").send_keys(captcha)
    # driver.find_element(By.CLASS_NAME, "passster-submit-captcha").click()

    input('Waiting... Press Enter')
    element = driver.find_element(By.CLASS_NAME, "textcontent")
    site_list = element.find_elements(By.XPATH, 'blockquote/p')

    title_raw = driver.title
    title_short = title_raw
    title_short = re.sub(' - .*', '', title_short, flags=re.IGNORECASE)
    title_short = re.sub('raw.*', '', title_short, flags=re.IGNORECASE)
    title_short = re.sub(EPISODE_SEARCH, '', title_short, flags=re.IGNORECASE)
    title_short = re.sub('\[.*?\]', '', title_short)
    title_short = re.sub(' +$', '', title_short)
    title_short = re.sub('^ +', '', title_short)
    today = datetime.datetime.now()
    csv_file = os.getenv('USERPROFILE') + '\\Downloads\\' + SITE_NAME + '-' + title_short + today.strftime(
        "_%Y%m%d%H%M") + '.csv'
    fc = open(csv_file, 'w', encoding='utf-8-sig', newline="")
    fc.write('domain,name,ep,url\n')
    writer = csv.writer(fc, quotechar='"', quoting=csv.QUOTE_ALL)

    for link in site_list:
        file_list = link.find_elements(By.XPATH, 'a')
        for file in file_list:
            dl_text = file.text
            dl_link = file.get_property('href')
            dl_domain = re.search('(http|https)://(.*?)/.*', dl_link).group(2)

            dl_ep = ''
            for exp in EPISODE_SEARCH_FILE:
                ep_result = re.search(exp, dl_text, flags=re.IGNORECASE)
                if ep_result is not None:
                    dl_ep = '#' + ep_result.group(1)
                    break

            print('{domain},{text},{url}'.format(domain=dl_domain, text=dl_text, url=dl_link))
            # fc.write('{domain},{text},{ep},{url}\n'.format(domain=dl_domain,ep=dl_ep,text=dl_text,url=dl_link))
            writer.writerow([dl_domain, dl_text, dl_ep, dl_link])

    fc.close()
    sort_csv(csv_file, 2, False)
