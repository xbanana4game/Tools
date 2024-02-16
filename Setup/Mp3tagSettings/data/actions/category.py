import mta

fr = open('category.txt', 'r', encoding='UTF-8')

for data in fr:
    mta_filename='Category-'+data.rstrip('\n')+'.mta'
    print(mta_filename)
    album=data.rstrip('\n')
    mta_file=mta.mtafile(mta_filename)
    mta_file.format_value('ALBUM',album)
    mta_file.remove_field('ALBUMARTIST')
    mta_file.format_value('_FILENAME','$if($strcmp($left(%_folderpath%,3),C:\\),C:\\Users\\$getenv(USERNAME)\\Downloads\\,$left(%_folderpath%,3)Videos\\)$if($grtr($strstr(%_folderpath%,\\\\$getenv(NASDOMAIN)),0),\\\\$getenv(NASDOMAIN)\\Multimedia\\VD_2024\\,)youtube.com\\$if($isdigit(%_covers%),,no_cover\\)$if($strcmp(%albumartist%,youtube.com),$replace(_%genre%_,&,and)\\,$if2(%album%,_work)\\)\\$if($and(%year%,%comment%),%year% %comment%,%_FILENAME%)')
    mta_file.close()

fr.close()