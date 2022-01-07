@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SET MP4_IMG_DIR=%PICTURES_DIR%\mp4img
IF NOT DEFINED FFMPGE_OPT_SS (SET /P FFMPGE_OPT_SS="SET FFMPGE_OPT_SS(3)=")
IF NOT DEFINED FFMPGE_OPT_SS (SET FFMPGE_OPT_SS=3)
IF NOT EXIST %MP4_IMG_DIR% MD %MP4_IMG_DIR%
IF NOT EXIST %MP4_IMG_DIR%_%FFMPGE_OPT_SS% MD %MP4_IMG_DIR%_%FFMPGE_OPT_SS%
IF ""%1""=="""" (
	IF NOT DEFINED MP4_FILES_DIR (SET /P MP4_FILES_DIR="SET MP4_FILES_DIR(%DOWNLOADS_DIR%)=")
	IF NOT DEFINED MP4_FILES_DIR (SET MP4_FILES_DIR=%DOWNLOADS_DIR%)
) ELSE (
	SET MP4_FILES_DIR=%1
)

echo %MP4_FILES_DIR%
CALL :ChangeDirectory %MP4_FILES_DIR%
FORFILES /s /m *.m?? /c ^
"cmd /c IF NOT EXIST %MP4_IMG_DIR%\\@file.jpg ffmpeg -y -i @path -ss %FFMPGE_OPT_SS% -vframes 1 -f image2 -vf scale=640:-1 %MP4_IMG_DIR%_%FFMPGE_OPT_SS%\\@file.jpg"
REM "cmd /c IF NOT EXIST @path.jpg ffmpeg -y -i @path -ss %FFMPGE_OPT_SS% -vframes 1 -f image2 -vf scale=640:-1 @path.jpg"

ECHO mp3tag Action Import Cover %MP4_IMG_DIR%\%%_filename_ext%%.jpg
PAUSE
EXPLORER %MP4_IMG_DIR%_%FFMPGE_OPT_SS%
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:ChangeDirectory
	IF EXIST %1 (
		CD /D %1
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0
	
