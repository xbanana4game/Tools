import mta
import os

os.chdir(os.environ.get('CONFIG_DIR') + os.sep + 'mp3tag')
catergory_filename = os.environ.get('CONFIG_DIR') + os.sep + 'mp3tag\\category.txt'
fc = open(catergory_filename, 'r', encoding='UTF-8')
mta_file=mta.mtafile('youtube-album.mta')

# Artist->Album
for data in fc:
    profile=data.rstrip('\n')
    is_file = os.path.isfile('youtube-album('+profile+').txt')
    if not is_file:
        continue
    fr = open('youtube-album('+profile+').txt', 'r', encoding='UTF-8')

    for data in fr:
        artist=data.rstrip('\n')
        mta_file.format_value('ALBUM','$if($grtr($strstr(%artist%,'+artist+'),0),'+profile+',%album%)')

    fr.close()

# Rename
mta_file.format_value('_FILENAME','$if($grtr($strstr(%_folderpath%,\\\\$getenv(NASDOMAIN)),0),\\\\$getenv(NASDOMAIN)\\Multimedia\\Videos\\,$if($strcmp($left(%_folderpath%,3),C:\\),C:\\Users\\$getenv(USERNAME)\\Downloads\\,$left(%_folderpath%,3)Videos\\))youtube.com\\$if($isdigit(%_covers%),,no_cover\\)$if($strcmp(%albumartist%,youtube.com),$replace(_%genre%_,&,and)\\,$if2(%album%,_work)\\)\\$if($and(%year%,%comment%),%year% %comment%,%_FILENAME%)')

# yt-dlp log
mta_file.output_file('videos-url-txt', os.environ.get('CONFIG_DIR') + '\\yt-dlp\\%_workingdir%-add_$regexp(%_date%,(\\d{4})(.\\d{2})(.\\d{2}),$1-$2-$3).log','1','0')

mta_file.close()
fc.close()
