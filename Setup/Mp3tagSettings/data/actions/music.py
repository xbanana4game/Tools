import mta

fr = open('genre.txt', 'r', encoding='UTF-8')

for data in fr:
    mta_filename='Music-'+data.rstrip('\n')+'.mta'
    print(mta_filename)
    mta_file=mta.mtafile(mta_filename)
    mta_file.format_value('GENRE',data)
    mta_file.format_value('_FILENAME','$if($strcmp($left(%_folderpath%,3),C:\\),C:\\Users\\$getenv(USERNAME)\\Downloads\\,$if($grtr($strstr(%_folderpath%,\\\\$getenv(NASDOMAIN)),0),\\\\$getenv(NASDOMAIN)\\Multimedia\\,$left(%_folderpath%,3)Multimedia\\))Music\\%genre%\\$if2(%AudioMD5%,%album%-%title%)')
    mta_file.close()

fr.close()