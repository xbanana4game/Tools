@echo off

rem VBScriptファイルのパス
set vbsFile=C:\Users\tomas\Desktop\msgbox.vbs

rem 既にVBScriptファイルが存在したら削除
if exist "%vbsFile%" (
	del /f "%vbsFile%"
)

REM VBScriptファイル作成
echo Dim result >> %vbsFile%
echo result = msgbox("処理を実行しますか？" ,vbOKCancel + vbInformation, "メッセージ") >> "%vbsFile%"
echo WScript.Quit(result) >> "%vbsFile%"

rem VBScriptファイル実行
"%vbsFile%"

rem メッセージボックスでクリックされたボタンを確認
if %errorlevel% == 1 (
    echo 処理を実行しました。
) else if %errorlevel% == 2 (
    echo 処理をキャンセルしました。
)

rem VBScriptファイル削除
del /f "%vbsFile%"

echo.
pause
exit

