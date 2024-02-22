import mta
import os

mta_dir = 'mta'
try:
    os.makedirs(mta_dir)
except FileExistsError:
    pass

fc = open('category.txt', 'r', encoding='UTF-8')
for data in fc:
    profile=data.rstrip('\n')
    is_file = os.path.isfile('youtube-album('+profile+').txt')
    if not is_file:
        continue
    fr = open('youtube-album('+profile+').txt', 'r', encoding='UTF-8')
    mta_filename=mta_dir+'\youtube-album('+profile+').mta'
    mta_file=mta.mtafile(mta_filename)

    for data in fr:
        artist=data.rstrip('\n')
        mta_file.format_value('ALBUM','$if($grtr($strstr(%artist%,'+artist+'),0),'+profile+',%album%)')

    fr.close()

    mta_file.close()

fc.close()
