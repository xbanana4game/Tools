import mta
import os

os.chdir(os.environ.get('CONFIG_DIR') + os.sep + 'mp3tag')
fr = open('set-album-from-tags.txt', 'r', encoding='UTF-8')
mta_filename='xxx(set-album-from-tags).mta'
mta_file=mta.mtafile(mta_filename)
mta_file.guess_field('%_filename%', '%dummy%[%tags%]')
mta_file.format_value('RATING', '$if($neql($strstr(%tags%,5star),0),5,)$if($neql($strstr(%tags%,4star),0),4,)$if($neql($strstr(%tags%,3star),0),3,)$if($neql($strstr(%tags%,2star),0),2,)$if($neql($strstr(%tags%,1star),0),1,)')

for data in fr:
    tag=data.rstrip('\n')
    mta_file.format_value('ALBUM','$if($eql(%album%,xxx),$if($grtr($strstr(%tags%,'+tag+'),0),'+tag+',%album%),%album%)')

fr.close()

mta_file.close()
