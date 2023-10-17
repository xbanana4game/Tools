fr = open('category.txt', 'r', encoding='UTF-8')

for data in fr:
    print(data)
    mta='Category-'+data.rstrip('\n')+'.mta'
    f = open(mta, 'w', encoding='utf_8_sig')
    f.write('[#0]\n')
    f.write('T=5\n')
    f.write('1='+data.rstrip('\n').encode('unicode-escape').decode('utf8')+'\n')
    f.write('F=ALBUM\n')
    f.write('\n')
    f.write('[#1]\n')
    f.write('T=9\n')
    f.write('F=ALBUMARTIST\n')
    f.write('\n')
    f.write('[#2]\n')
    f.write('T=5\n')
    f.write('1=$if($strcmp($left(%_folderpath%,3),C:\\\\),C:\\\\Users\\\\$getenv(USERNAME)\\\\Downloads\\\\youtube.com\\\\,)$if($isdigit(%_covers%),,no_cover\\\\)$if($strcmp(%albumartist%,youtube.com),$replace(_%genre%_,&,and)\\\\,$if2(%album%,_work)\\\\)\\\\$if($and(%year%,%comment%),%year% %comment%,%_FILENAME%)\n')
    f.write('F=_FILENAME\n')
    f.write('\n')
    f.close()

fr.close()