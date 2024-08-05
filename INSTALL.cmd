@ECHO OFF

SET TOOLS_INSTALL_DIR=%USERPROFILE%\.Tools
SET SAKURA_SETTINGS_DIR=%USERPROFILE%\AppData\Roaming\sakura
SET FILE_7Z_INSTALLER=7z1900-x64.exe
REM ======================================================================
REM
REM                                INSTALL
REM
REM ======================================================================
CALL :INSTALL_ENV
CALL :INSTALL_PYTHON
CALL :INSTALL_7Z
CALL :INSTALL_FFMPEG
CALL :INSTALL_YTDLP
CALL :INSTALL_NKF
CALL :INSTALL_SETTINGS
CALL :INSTALL_SAKURA_MACRO
CALL :BACKUP_SETTINGS
REM PAUSE
REM EXPLORER %TOOLS_INSTALL_DIR%
REM IF EXIST "%SAKURA_SETTINGS_DIR%" EXPLORER %SAKURA_SETTINGS_DIR%
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:INSTALL_ENV
	ECHO Create System Environment Variables on Windows
	IF NOT DEFINED NASDOMAIN (
		ECHO SETX NASDOMAIN sample-nas
		rundll32 sysdm.cpl,EditEnvironmentVariables
		PAUSE
	)
	IF NOT DEFINED JD2_DL (
		ECHO SETX JD2_DL %USERPROFILE%\Documents\JDownloader
		ECHO SETX JD2_DL D:\JDownloader
		rundll32 sysdm.cpl,EditEnvironmentVariables
		PAUSE
	)
	IF NOT DEFINED CONFIG_DIR (
		ECHO SETX CONFIG_DIR %USERPROFILE%\Documents\config
		rundll32 sysdm.cpl,EditEnvironmentVariables
		PAUSE
	)
	IF NOT DEFINED BOOKS_ZIP_DIR (
		ECHO SETX BOOKS_ZIP_DIR %USERPROFILE%\Downloads\Books-zip
		rundll32 sysdm.cpl,EditEnvironmentVariables
		PAUSE
	)
	
	EXIT /B
	
:INSTALL_PYTHON
	ECHO Python 3.11 (64-bit)
	EXIT /B

:INSTALL_7Z
	IF EXIST "C:\Program Files\7-Zip\7z.exe" EXIT /B
	IF EXIST "%FILE_7Z_INSTALLER%" (
		START %FILE_7Z_INSTALLER%
		PAUSE
	) ELSE (
		ECHO Please Install https://ja.osdn.net/dl/sevenzip/7z1900-x64.exe/
		PAUSE
	)
	EXIT /B

:INSTALL_FFMPEG
	IF EXIST %TOOLS_INSTALL_DIR%\bin\ffmpeg.exe EXIT /B
	IF EXIST ffmpeg.exe (
		COPY ffmpeg.exe %TOOLS_INSTALL_DIR%\bin\ffmpeg.exe
		COPY ffprobe.exe %TOOLS_INSTALL_DIR%\bin\ffprobe.exe
	) ELSE (
		ECHO Please Download https://www.ffmpeg.org/
		PAUSE
	)
	EXIT /B

:INSTALL_YTDLP
	IF EXIST %TOOLS_INSTALL_DIR%\bin\yt-dlp.exe EXIT /B
	IF EXIST yt-dlp.exe (
		COPY yt-dlp.exe %TOOLS_INSTALL_DIR%\bin\yt-dlp.exe
	) ELSE (
		ECHO Download URL https://github.com/yt-dlp/yt-dlp/releases
		PAUSE
	)
	EXIT /B

:INSTALL_NKF
	IF EXIST %TOOLS_INSTALL_DIR%\bin\nkf32.exe EXIT /B
	IF EXIST nkf32.exe (
		COPY nkf32.exe %TOOLS_INSTALL_DIR%\bin\nkf32.exe
	) ELSE (
		ECHO Please Download https://www.vector.co.jp/download/file/win95/util/fh526847.html
		PAUSE
	)
	EXIT /B

:INSTALL_SETTINGS
	MD %TOOLS_INSTALL_DIR%
	
	COPY /Y Setup\Settings.cmd %TOOLS_INSTALL_DIR%\Settings.cmd
	ECHO SET TOOLS_DIR=%~dp0>>%TOOLS_INSTALL_DIR%\Settings.cmd
	ECHO SET PATH=%~dp0Games;%%PATH%%>>%TOOLS_INSTALL_DIR%\Settings.cmd
	ECHO SET PATH=%~dp0Archive-Tools;%%PATH%%>>%TOOLS_INSTALL_DIR%\Settings.cmd
	ECHO SET PATH=%~dp0File-Tools;%%PATH%%>>%TOOLS_INSTALL_DIR%\Settings.cmd
	ECHO SET PATH=%TOOLS_INSTALL_DIR%\bin;%%PATH%%>>%TOOLS_INSTALL_DIR%\Settings.cmd
	
	IF EXIST "SettingsOptions.cmd" (
		NOTEPAD SettingsOptions.cmd
		COPY /Y SettingsOptions.cmd %TOOLS_INSTALL_DIR%\SettingsOptions.cmd
	)
	
	COPY /Y Setup\MoveFiles.cmd %TOOLS_INSTALL_DIR%\MoveFiles.cmd
	IF EXIST "MoveFiles-user.cmd" (
		NOTEPAD MoveFiles-user.cmd
		COPY /Y MoveFiles-user.cmd %TOOLS_INSTALL_DIR%\MoveFiles-user.cmd
	) ELSE (
		ECHO REM MoveFiles-user.cmd >MoveFiles-user.cmd
	)
	
	MD %TOOLS_INSTALL_DIR%\bin
	COPY /Y Archive-Tools\Archive-Tool.cmd %TOOLS_INSTALL_DIR%\bin
	COPY /Y Keepass-Tools\Archive-kdbx.cmd %TOOLS_INSTALL_DIR%\bin
	COPY /Y Archive-Tools\Archive-Extension.cmd %TOOLS_INSTALL_DIR%\bin
	
	COPY /Y Archive-Tools\Archive.cmd %USERPROFILE%\Desktop\Archive.cmd
	REM IF EXIST %USERPROFILE%\Desktop\Archive.cmd DEL %USERPROFILE%\Desktop\Archive.cmd
	REM MKLINK /H %USERPROFILE%\Desktop\Archive.cmd Archive-Tools\Archive.cmd
	REM COPY /Y File-Tools\Archive_Directory.cmd %USERPROFILE%\Desktop
	EXIT /B
	
:INSTALL_SAKURA_MACRO
	IF EXIST "C:\Program Files (x86)\sakura" (
		COPY /Y Sakura\ppa.dll "C:\Program Files (x86)\sakura"
	)
	IF EXIST "%SAKURA_SETTINGS_DIR%" (
		COPY /Y Osu!\*.ppa %SAKURA_SETTINGS_DIR%\
		COPY /Y Games\*.ppa %SAKURA_SETTINGS_DIR%\
		COPY /Y Sakura\*.ppa %SAKURA_SETTINGS_DIR%\
	)
	EXIT /B
	
:BACKUP_SETTINGS
	IF NOT EXIST %TOOLS_INSTALL_DIR%\Settings.cmd (EXIT /B)
	CALL %TOOLS_INSTALL_DIR%\Settings.cmd
	REM IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	DEL %TOOLS_INSTALL_DIR%\Tools-Settings@%USERDOMAIN%_%yyyy%%mm%%dd%.7z
	7z a -t7z  %ARCHIVE_OPT_PW% %TOOLS_INSTALL_DIR%\Tools-Settings@%USERDOMAIN%_%yyyy%%mm%%dd%.7z %TOOLS_INSTALL_DIR% -xr!*bin -xr!*.7z
	COPY /Y %TOOLS_INSTALL_DIR%\Tools-Settings@%USERDOMAIN%_%yyyy%%mm%%dd%.7z %DOWNLOADS_DIR%

	TYPE .gitignore
	CHOICE /C YN /T 3 /D N /M "7z Add .gitignore list?"
	IF %ERRORLEVEL% EQU 2 EXIT /B
	7z a -t7z  %ARCHIVE_OPT_PW% %TOOLS_INSTALL_DIR%\Tools-Settings@%USERDOMAIN%_%yyyy%%mm%%dd%.7z @.gitignore
	COPY /Y %TOOLS_INSTALL_DIR%\Tools-Settings@%USERDOMAIN%_%yyyy%%mm%%dd%.7z %DOWNLOADS_DIR%
	EXIT /B

	