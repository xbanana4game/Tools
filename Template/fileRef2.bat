@echo off
set "File=C:\Temp\*.txt"
set "Filter=テキスト (*.txt)|*.txt|すべてのファイル (*.*)|*.*|"
set "Title=ファイルの選択"

set dialog="about:<object id=HtmlDlgHelper classid=CLSID:3050f4e1-98b5-11cf-bb82-00aa00bdce0b></object>
set dialog=%dialog%<script language=vbscript>resizeTo 0,0:Sub window_onload():
set dialog=%dialog%Set reg=CreateObject("VBScript.RegExp"):reg.Pattern="\0.*":
set dialog=%dialog%Set Env=CreateObject("WScript.Shell").Environment("Process"):
set dialog=%dialog%ret=HtmlDlgHelper.object.openfiledlg(Env("File"),,Env("Filter"),Env("Title")):
set dialog=%dialog%CreateObject("Scripting.FileSystemObject").GetStandardStream(1).Write reg.Replace(ret,""):
set dialog=%dialog%Close:End Sub</script><hta:application caption=no showintaskbar=no />"

set file=
for /f "delims=" %%p in ('MSHTA.EXE %dialog%') do set "file=%%p"
echo selected  file is : "%file%"
pause