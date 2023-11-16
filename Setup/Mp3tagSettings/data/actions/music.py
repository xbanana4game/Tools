fr = open('genre.txt', 'r', encoding='UTF-8')

for data in fr:
    print(data)
    mta='Music-'+data.rstrip('\n')+'.mta'
    f = open(mta, 'w', encoding='utf_8_sig')
    f.write('[#0]\n')
    f.write('T=5\n')
    f.write('1='+data.rstrip('\n').encode('unicode-escape').decode('utf8')+'\n')
    f.write('F=GENRE\n')
    f.write('\n')
    
    f.write('[#1]\n')
    f.write('T=5\n')
    f.write('1=')
    f.write('$if($strcmp($left(%_folderpath%,3),C:\\\\),C:\\\\Users\\\\$getenv(USERNAME)\\\\Downloads\\\\,$if($grtr($strstr(%_folderpath%,\\\\\\\\$getenv(NASDOMAIN)),0),\\\\\\\\$getenv(NASDOMAIN)\\\\Multimedia\\\\,$left(%_folderpath%,3)Multimedia\\\\))')
    f.write('Music\\\\%genre%\\\\$if2(%AudioMD5%,%album%-%title%)')
    f.write('\n')
    f.write('F=_FILENAME\n')
    
    f.write('\n')
    f.close()

fr.close()