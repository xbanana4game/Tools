@ECHO OFF
REM ======================================================================
REM
REM                                Tools-202503
REM
REM ======================================================================
IF DEFINED _SETTING_OPTIONS EXIT /B
SET _SETTING_OPTIONS=1
REM ----------------------------------------------------------------------
REM DATE
REM ----------------------------------------------------------------------
SET yyyy=%date:~0,4%
SET mm=%date:~5,2%
SET dd=%date:~8,2%
SET time2=%time: =0%
SET hh=%time2:~0,2%
SET mn=%time2:~3,2%
SET ss=%time2:~6,2%
IF %dd% GTR  0 SET week=1
IF %dd% GTR 10 SET week=2
IF %dd% GTR 20 SET week=3

REM ----------------------------------------------------------------------
REM INSTALL
REM ----------------------------------------------------------------------
IF NOT DEFINED NASDOMAIN SET NASDOMAIN=%USERPROFILE%\NAS
IF NOT DEFINED JD2_DL SET JD2_DL=%USERPROFILE%\Documents\JDownloader 

REM ----------------------------------------------------------------------
REM Common
REM ----------------------------------------------------------------------
SET TOOLS_INSTALL_DIR=%USERPROFILE%\.Tools
SET DOWNLOADS_DIR=%USERPROFILE%\Downloads
SET DESKTOP_DIR=%USERPROFILE%\Desktop
SET PICTURES_DIR=%USERPROFILE%\Pictures
SET DOCUMENTS_DIR=%USERPROFILE%\Documents
SET VIDEOS_DIR=%USERPROFILE%\Videos
SET MUSIC_DIR=%USERPROFILE%\Music
SET ARCHIVE_DIR=%USERPROFILE%\Archives
SET UPLOADS_DIR=%ARCHIVE_DIR%\Uploads
SET STORE_DIR=%USERPROFILE%\Store
SET PATH=%PATH%;C:\Program Files\7-Zip
SET PATH=%PATH%;C:\Program Files\WinRAR
SET PATH=%PATH%;C:\Program Files\Mp3tag
SET PATH=%PATH%;C:\App\renamer-7.3
SET PATH=%PATH%;C:\Program Files (x86)\foobar2000
SET PATH=%PATH%;C:\Program Files (x86)\GnuWin32\bin
SET NOTEPAD="C:\Program Files\Notepad++\notepad++.exe"
REM SET NOTEPAD=NOTEPAD
SET SAKURA="C:\Program Files (x86)\sakura\sakura.exe"
SET PATH=%PATH%;%USERPROFILE%\PycharmProjects\mp3tag-tool
SET PATH=%PATH%;%USERPROFILE%\PycharmProjects\webscraping
SET PATH=%PATH%;%USERPROFILE%\PycharmProjects\webscraping\yt-dlp


REM ----------------------------------------------------------------------
REM SettingsOptions
REM ----------------------------------------------------------------------
IF EXIST %USERPROFILE%\.Tools\SettingsOptions.cmd (CALL %USERPROFILE%\.Tools\SettingsOptions.cmd)
IF EXIST %USERPROFILE%\Desktop\SettingsOptions.cmd (
	%NOTEPAD% %USERPROFILE%\Desktop\SettingsOptions.cmd
	CALL %USERPROFILE%\Desktop\SettingsOptions.cmd
)

REM SET TOOLS_DIR=
REM SETX NASDOMAIN sample-nas
REM SETX JD2_DL D:\JDownloader
REM SETX CONFIG_DIR %USERPROFILE%\Documents\config
REM SETX BOOKS_ZIP_DIR %USERPROFILE%\Downloads\Books-zip

