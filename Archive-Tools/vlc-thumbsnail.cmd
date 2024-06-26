@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM VLC Output Screenshot Filename
REM $d.jpg-_-$T_-_


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
REM SET DEBUG=1
SET CMD_FILE=%USERPROFILE%\.Tools\%yyyy%%mm%%dd%%hh%%mn%%ss%.cmd
SET MP4_IMG_DIR=%PICTURES_DIR%\mp4img
MD %MP4_IMG_DIR%

REM RENAME MD5.jpg-_-date.jpg -> MD5.jpg
FOR %%i IN ("%PICTURES_DIR%\*.jpg-_-*.jpg") DO (
	ECHO SET FILENAME=%%~nxi >>%CMD_FILE%
	REM MD5
	ECHO SET FILENAME=%%FILENAME:~0,12%% >>%CMD_FILE%
	REM AUDIOMD5
	REM ECHO SET FILENAME=%%FILENAME:~0,32%% >>%CMD_FILE%
	ECHO ECHO MOVE "%%i" "%MP4_IMG_DIR%\%%FILENAME%%" >>%CMD_FILE%
	ECHO MOVE "%%i" "%MP4_IMG_DIR%\%%FILENAME%%" >>%CMD_FILE%
)
IF EXIST %CMD_FILE% (
	IF DEFINED DEBUG NOTEPAD %CMD_FILE%
	CALL %CMD_FILE%
	DEL %CMD_FILE%
)
REM IF EXIST "%DESKTOP_DIR%\xxx.m3u8" (
	REM Mp3tag.exe /fn:"%DESKTOP_DIR%\xxx.m3u8"
REM ) ELSE (
	Mp3tag.exe /fp:"%DOWNLOADS_DIR%\xxx"
REM )

EXIT
