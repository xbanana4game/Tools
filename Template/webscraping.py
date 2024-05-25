import requestsfrom bs4 import BeautifulSoupimport reimport osimport datetimeimport timeimport configparserconfig = configparser.ConfigParser()config.read(os.getenv('CONFIG_DIR')+'\\webscraping.ini', encoding='utf-8')SITE_NAME = config.get("site", "SITE_NAME")MAX_PAGE_NUMBER = int(config.get("site", "MAX_PAGE_NUMBER"))URL_BASE = config.get("site", "URL_BASE")EPISODE_SEARCH = config.get("site", "EPISODE_SEARCH")today=datetime.datetime.now()fc = open('C:\\Users\\'+os.getenv('USERNAME')+'\\Downloads\\'+SITE_NAME+today.strftime("_%Y%m%d%H%M")+'.csv', 'w', encoding='utf-8-sig')fc.write('title,episode,url\n')for i in range(1,MAX_PAGE_NUMBER):    url = URL_BASE.format(number=i)    print(url)        response = requests.get(url)    # print(response.text)    soup = BeautifulSoup(response.text, "html.parser")    elems = soup.find_all("h2")    for elem in elems:        try:            #print(elem.contents[0])            #print(elem.contents[0].attrs['href'])            #print('--------------------------------------------------------------------------------------')            elem_url=elem.contents[0].attrs['href']            title_raw=elem.contents[0].text            #pattern = re.compile(title_raw, re.IGNORECASE)                        episode_search = re.search(EPISODE_SEARCH, title_raw)            if episode_search is None:                episode = 'None'            else:                episode = episode_search.group(0)                        title_short = re.sub('raw.*', '', title_raw, flags=re.IGNORECASE)            title_short = re.sub(EPISODE_SEARCH, '', title_short, flags=re.IGNORECASE)            title_short = re.sub('\[.*?\]','', title_short)            title_short = re.sub(' +$','', title_short)            title_short = re.sub('^ +','', title_short)            print(title_short)                        fc.write('{title_short},{episode},{url}\n'.format(title_short=title_short,episode=episode,url=elem_url))            #print('{title:.10},{url:.10}\n'.format(title=title_raw,url=elem.contents[0].attrs['href']))        except AttributeError as e:            print(e)        except KeyError as e:            print(e)    time.sleep(0.3)fc.close()