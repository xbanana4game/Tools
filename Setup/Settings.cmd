REM ======================================================================
REM
REM                                Tools-3.8.0
REM
REM ======================================================================
@ECHO OFF
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
REM SET PATH=%PATH%;C:\App\renamer-7.3
REM SET NOTEPAD="C:\Program Files\Notepad++\notepad++.exe"
SET NOTEPAD=NOTEPAD
SET SAKURA="C:\Program Files (x86)\sakura\sakura.exe"

REM ----------------------------------------------------------------------
REM Archive-Tools
REM ----------------------------------------------------------------------
SET DOWNLOAD_FILENAME=DL_%yyyy%%mm%%dd%_%USERDOMAIN%
REM SET DOWNLOAD_FILENAME=DL_%yyyy%%mm%%dd%_%hh%%mn%_%USERDOMAIN%
REM SET DOWNLOAD_FILENAME=DL_%yyyy%%mm%-%week%_%USERDOMAIN%
SET ARCHIVE_UPLOAD_FLG=0
SET MOVE_FILES_FLG=1
REM x=[0 | 1 | 3 | 5 | 7 | 9 ] 
SET ARCHIVE_OPT_X=3

REM ----------------------------------------------------------------------
REM Games Settings
REM ----------------------------------------------------------------------
SET STEAM_DIR=C:\Progra~2\Steam
SET STEAM_LIBRARY=%STEAM_DIR%\steamapps\common

REM ----------------------------------------------------------------------
REM Options
REM ----------------------------------------------------------------------
IF EXIST %USERPROFILE%\.Tools\SettingsOptions.cmd (CALL %USERPROFILE%\.Tools\SettingsOptions.cmd)
IF EXIST %USERPROFILE%\Desktop\SettingsOptions.cmd (
	REM ECHO %USERPROFILE%\Desktop\SettingsOptions.cmd
	REM TYPE %USERPROFILE%\Desktop\SettingsOptions.cmd
	%NOTEPAD% %USERPROFILE%\Desktop\SettingsOptions.cmd
	CALL %USERPROFILE%\Desktop\SettingsOptions.cmd
)

