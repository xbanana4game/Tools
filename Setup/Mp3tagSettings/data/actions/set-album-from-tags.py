import os
import mta

mta_dir = 'mta'
try:
    os.makedirs(mta_dir)
except FileExistsError:
    pass

fr = open('set-album-from-tags.txt', 'r', encoding='UTF-8')
mta_filename=mta_dir+'\set-album-from-tags.mta'
mta_file=mta.mtafile(mta_filename)

for data in fr:
    print(mta_filename)
    tag=data.rstrip('\n')
    mta_file.format_value('ALBUM','$if($eql(%album%,xxx),$if($grtr($strstr(%tags%,'+tag+'),0),'+tag+',%album%),%album%)')

fr.close()

mta_file.close()
