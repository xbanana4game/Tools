@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Archive.cmd(SettingsOptions) ----------
REM SET MP4_FILES_DIR=%CAPTURES_DIR%
REM SET MP4_IMG_DIR=%PICTURES_DIR%\mp4img
REM SET IMG_OUTPUT_DIR=%PICTURES_DIR%\mp4img
REM SET FFMPGE_OPT_SS=1
REM SET END_FLG=1

REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED MP4_IMG_DIR SET MP4_IMG_DIR=%PICTURES_DIR%\mp4img
IF NOT DEFINED IMG_OUTPUT_DIR SET IMG_OUTPUT_DIR=%MP4_IMG_DIR%_%FFMPGE_OPT_SS%
IF ""%1""=="""" (
	IF NOT DEFINED MP4_FILES_DIR (SET /P MP4_FILES_DIR="SET MP4_FILES_DIR(%VIDEOS_DIR%)=")
	IF NOT DEFINED MP4_FILES_DIR (SET MP4_FILES_DIR=%VIDEOS_DIR%)
	REM IF NOT DEFINED MP4_FILES_DIR (SET /P MP4_FILES_DIR="SET MP4_FILES_DIR(%DOWNLOADS_DIR%)=")
	REM IF NOT DEFINED MP4_FILES_DIR (SET MP4_FILES_DIR=%DOWNLOADS_DIR%)
) ELSE (
	SET MP4_FILES_DIR=%1
)
REM IF NOT DEFINED FFMPGE_OPT_SS (SET /P FFMPGE_OPT_SS="SET FFMPGE_OPT_SS(3)=")
IF NOT DEFINED FFMPGE_OPT_SS (SET FFMPGE_OPT_SS=3)

ECHO %MP4_FILES_DIR%

:MAKE_THUMBS
IF NOT EXIST %MP4_IMG_DIR% MD %MP4_IMG_DIR%
IF NOT EXIST %IMG_OUTPUT_DIR% MD %IMG_OUTPUT_DIR%

CALL :ChangeDirectory %MP4_FILES_DIR%
REM FOR %%i IN (avi wmv flv mp4 mpeg mpg) DO (
FOR %%i IN (mp4) DO (
	FORFILES /s /m *.%%i /c ^
	"cmd /c IF NOT EXIST %MP4_IMG_DIR%\\@file.jpg ffmpeg -y -i @path -ss %FFMPGE_OPT_SS% -vframes 1 -f image2 -vf scale=640:-1 %IMG_OUTPUT_DIR%\\@file.jpg"
	REM Mp3Tag
	REM "cmd /c IF NOT EXIST %MP4_IMG_DIR%\\@file.jpg ffmpeg -y -i @path -ss %FFMPGE_OPT_SS% -vframes 1 -f image2 -vf scale=640:-1 %IMG_OUTPUT_DIR%\\@file.jpg"
	REM TagSpace
	REM "cmd /c IF NOT EXIST .ts\\@file.jpg ffmpeg -y -i @path -ss %FFMPGE_OPT_SS% -vframes 1 -f image2 -vf scale=640:-1 .ts\\@file.jpg"
	REM Twonky
	REM "cmd /c IF NOT EXIST @fname.jpg ffmpeg -y -i @path -ss %FFMPGE_OPT_SS% -vframes 1 -f image2 -vf scale=640:-1 @fname.jpg"
)
ECHO mp3tag Action Import Cover %MP4_IMG_DIR%\%%_filename_ext%%.jpg

IF DEFINED END_FLG EXIT /B
SET /P FFMPGE_OPT_SS="SET FFMPGE_OPT_SS[sec]="
SET IMG_OUTPUT_DIR=%MP4_IMG_DIR%_%FFMPGE_OPT_SS%
CALL :MAKE_THUMBS

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
	
