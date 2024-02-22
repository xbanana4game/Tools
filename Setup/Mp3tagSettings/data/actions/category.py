import mta
import os

mta_dir = 'mta'
try:
    os.makedirs(mta_dir)
except FileExistsError:
    pass

fr = open('category.txt', 'r', encoding='UTF-8')

for data in fr:
    mta_filename=mta_dir+'\Category-'+data.rstrip('\n')+'.mta'
    print(mta_filename)
    album=data.rstrip('\n')
    mta_file=mta.mtafile(mta_filename)
    mta_file.format_value('ALBUM',album)
    mta_file.remove_field('ALBUMARTIST')
    mta_file.format_value('_FILENAME','$if($grtr($strstr(%_folderpath%,\\\\$getenv(NASDOMAIN)),0),\\\\$getenv(NASDOMAIN)\\Multimedia\\Videos\\,$if($strcmp($left(%_folderpath%,3),C:\\),C:\\Users\\$getenv(USERNAME)\\Downloads\\,$left(%_folderpath%,3)Videos\\))youtube.com\\$if($isdigit(%_covers%),,no_cover\\)$if($strcmp(%albumartist%,youtube.com),$replace(_%genre%_,&,and)\\,$if2(%album%,_work)\\)\\$if($and(%year%,%comment%),%year% %comment%,%_FILENAME%)')
    mta_file.close()

fr.close()