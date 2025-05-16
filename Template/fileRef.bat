@echo off
set dialog="about:<input type=file id=FILE><script language=vbscript>FILE.Click:
set dialog=%dialog%CreateObject("Scripting.FileSystemObject").GetStandardStream(1).WriteLine(FILE.value):
set dialog=%dialog%Close:resizeTo 0,0</script>"

set file=
for /f "tokens=* delims=" %%p in ('mshta.exe %dialog%') do set "file=%%p"
echo selected  file is : "%file%"
pause