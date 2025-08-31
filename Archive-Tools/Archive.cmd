@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
SET DRIVE_LETTER_FILE=%CD:~0,2%
SET DRIVE_LETTER_CMD=%~d0

REM ---------- Archive.cmd(SettingsOptions) ----------
REM SET DOWNLOAD_FILENAME=DL_%yyyy%%mm%%dd%_%USERDOMAIN%
REM SET DOWNLOAD_FILENAME=DL_%yyyy%-%mm%-%dd%T%hh%%mn%_%USERDOMAIN%
REM SET DOWNLOAD_FILENAME=DL_%yyyy%%mm%-%week%_%USERDOMAIN%
REM SET ROBOCOPY_LOG=
REM SET ROBOCOPY_LOG=%DESKTOP_DIR%\robocopy-%yyyy%%mm%%dd%%hh%%mn%%ss%.log
REM SET ROBOCOPY_LOG_OPTIONS=/log+:"%ROBOCOPY_LOG%" /v /fp /tee
REM SET DOWNLOADS_PASSWORD=
REM SET SHUTDOWN_FLG=0
REM SET ARCHIVE_UPLOAD_FLG=0
REM SET SDEL_FLG=1
REM SET EXTRA_DOWNLOADS_DIR=D:\Downloads
REM SET DRIVE_LETTER=C
REM SET ARCHIVE_DIR=%DRIVE_LETTER%:\Archives
REM SET DL_NAME=DL_%yyyy%%mm%
REM SET DL_DIR=%ARCHIVE_DIR%\%DL_NAME%
REM x=[0 | 1 | 3 | 5 | 7 | 9 ] 
REM SET ARCHIVE_OPT_X=0
REM SET BACKUPS_DIR=%DRIVE_LETTER%:\Backups
REM SET STORE_DIR=%DRIVE_LETTER%:\Store
REM SET MOVE_FILES_FLG=0
REM SET ARCHIVE_VOLUME_SIZE=1g
REM SET XCOPY_ARCHIVES=0
REM SET XCOPY_ARCHIVE_DIRECTORY=\\%NASDOMAIN%\Download\%USERDOMAIN%


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
	
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF NOT DEFINED DOWNLOAD_FILENAME (SET DOWNLOAD_FILENAME=DL_%yyyy%%mm%%dd%_%USERDOMAIN%)
IF NOT DEFINED SHUTDOWN_FLG (SET SHUTDOWN_FLG=0)
IF NOT DEFINED Z_TYPE (SET Z_TYPE=7z)
IF NOT DEFINED DL_NAME SET DL_NAME=DL_%yyyy%%mm%
IF NOT DEFINED DL_DIR SET DL_DIR=%ARCHIVE_DIR%\%DL_NAME%
IF NOT DEFINED ARCHIVE_VOLUME_SIZE (SET ARCHIVE_VOLUME_SIZE=0)
IF NOT DEFINED DOWNLOADS_PASSWORD (SET /P DOWNLOADS_PASSWORD="SET DOWNLOADS_PASSWORD(%ARCHIVE_PASSWORD%)=")
IF NOT DEFINED DOWNLOADS_PASSWORD (SET DOWNLOADS_PASSWORD=%ARCHIVE_PASSWORD%)
REM SET ROBOCOPY_LOG=%DESKTOP_DIR%\robocopy-%yyyy%%mm%%dd%%hh%%mn%%ss%.log
IF DEFINED ROBOCOPY_LOG SET ROBOCOPY_LOG_OPTIONS=/log+:"%ROBOCOPY_LOG%" /v /fp /tee
SET ROBOCOPY_COPY_OPTIONS=/e /r:3 /w:10
SET EXCLUDE_7z_OPT=-xr!desktop.ini -xr!*.part -xr!*.mega -xr!*.crdownload -xr!*.downloading -x!youtube.com -x!twitch.tv
IF EXIST %CONFIG_DIR%\7z_exclude.txt SET EXCLUDE_7z_OPT=-xr@%CONFIG_DIR%\7z_exclude.txt
IF NOT DEFINED XCOPY_ARCHIVES (SET XCOPY_ARCHIVES=0)
IF NOT DEFINED XCOPY_ARCHIVE_DIRECTORY (SET XCOPY_ARCHIVE_DIRECTORY=\\%NASDOMAIN%\Download\%USERDOMAIN%)
IF NOT DEFINED SHUTDOWN_FLG2 (SET SHUTDOWN_FLG2=0)
IF NOT DEFINED MOVE_FILES_FLG (SET MOVE_FILES_FLG=0)
IF NOT DEFINED SDEL_FLG SET SDEL_FLG=1
IF "%SDEL_FLG%"=="1" (SET SDEL_OPT=-sdel)
IF DEFINED EXTRA_DOWNLOADS_DIR SET EXTRA_DOWNLOADS_DIR=%EXTRA_DOWNLOADS_DIR%\*

IF NOT ""%1""=="""" (
	echo ""%1""
	FOR %%i in (%*) DO (
		ECHO "%%~fi"
		IF NOT "%DOWNLOADS_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%DOWNLOADS_PASSWORD% -mhe
		7z a -t%Z_TYPE% %SDEL_OPT% "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.%Z_TYPE%" ""%%i"" -mx=0
		REM 7z a -t7z -sdel %ARCHIVE_OPT_PW% "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.%Z_TYPE%" ""%%i"" -v1g
		IF EXIST "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.%Z_TYPE%.001" (
			7z l "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.%Z_TYPE%.001">"%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.%Z_TYPE%.txt"
			TYPE "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.%Z_TYPE%.txt"
		) ELSE (
			7z l "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.%Z_TYPE%">"%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.%Z_TYPE%.txt"
			TYPE "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.%Z_TYPE%.txt"
		)
	)
	TIMEOUT /T 3
	EXIT
)

REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF 1 EQU %SHUTDOWN_FLG% SET /P SHUTDOWN_FLG2="Shutdown? 1:YES 0:NO -> "
IF 1 EQU %MOVE_FILES_FLG% (
	SET ARCHIVE_FLG=1
	IF EXIST %TOOLS_INSTALL_DIR%\MoveFiles.cmd (CALL %TOOLS_INSTALL_DIR%\MoveFiles.cmd)
)
CALL :Archive_Downloads
IF "%XCOPY_ARCHIVES%"=="1" CALL :COPY_FILE
IF 1 EQU %SHUTDOWN_FLG2% (SHUTDOWN /S /T 3)

ECHO ^G
TIMEOUT /T 3
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:Archive_Downloads
	CALL :isEmptyDir %DOWNLOADS_DIR%
	IF %ERRORLEVEL% EQU 1 (
		ECHO Files not Exist. %DOWNLOADS_DIR%
		EXIT /B
	)
	IF NOT %ARCHIVE_VOLUME_SIZE%==0 SET OPT_VOLUME=-v%ARCHIVE_VOLUME_SIZE%
	IF NOT "%DOWNLOADS_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%DOWNLOADS_PASSWORD% -mhe
	7z a -t%Z_TYPE% -sdel %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.%Z_TYPE% %USERPROFILE%\Downloads\* %EXTRA_DOWNLOADS_DIR% %EXCLUDE_7z_OPT% -mx=%ARCHIVE_OPT_X% %OPT_VOLUME%
	IF EXIST "%DL_DIR%\%DOWNLOAD_FILENAME%.%Z_TYPE%.001" (
		7z l %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.%Z_TYPE%.001
	) ELSE (
		7z l %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.%Z_TYPE%
	)
	EXIT /B

:isEmptyDir
	DIR %1 /A:A-S /S /B
	IF %ERRORLEVEL% EQU 0 (
		ECHO Files Exist.
		EXIT /B 0
	)
	EXIT /B 1

:COPY_FILE
	ROBOCOPY %DL_DIR%\ %XCOPY_ARCHIVE_DIRECTORY%\%DL_NAME%\ %DOWNLOAD_FILENAME%.* %ROBOCOPY_COPY_OPTIONS% %ROBOCOPY_LOG_OPTIONS%
	IF ERRORLEVEL 8 (
		IF EXIST %ROBOCOPY_LOG% NOTEPAD %ROBOCOPY_LOG%
		EXIT /B
	) ELSE (
		EXPLORER %XCOPY_ARCHIVE_DIRECTORY%\%DL_NAME%\
		IF EXIST %ROBOCOPY_LOG% DEL %ROBOCOPY_LOG%
	)
	SET ARCHIVE_STORE_DIR=%STORE_DIR%\%DL_NAME%
	MD %ARCHIVE_STORE_DIR%
	MOVE %DL_DIR%\%DOWNLOAD_FILENAME%*.7z %ARCHIVE_STORE_DIR%\
	MOVE %DL_DIR%\%DOWNLOAD_FILENAME%*.7z.??? %ARCHIVE_STORE_DIR%\
	RMDIR %ARCHIVE_STORE_DIR%
	RMDIR %DL_DIR%
	EXIT /B
	
	