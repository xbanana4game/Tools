@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Archive.cmd(SettingsOptions) ----------
REM SET DOWNLOAD_FILENAME=DL_%yyyy%%mm%%dd%_%USERDOMAIN%
REM SET DOWNLOAD_FILENAME=DL_%yyyy%-%mm%-%dd%T%hh%%mn%_%USERDOMAIN%
REM SET DOWNLOAD_FILENAME=DL_%yyyy%%mm%-%week%_%USERDOMAIN%
REM SET DOWNLOADS_PASSWORD=
REM SET SHUTDOWN_FLG=0
REM SET ARCHIVE_UPLOAD_FLG=0
REM SET DRIVE_LETTER=C
REM SET ARCHIVE_DIR=%DRIVE_LETTER%:\Archives
REM x=[0 | 1 | 3 | 5 | 7 | 9 ] 
REM SET ARCHIVE_OPT_X=0
REM SET BACKUPS_DIR=%DRIVE_LETTER%:\Backups
REM SET STORE_DIR=%DRIVE_LETTER%:\Store
REM SET MOVE_FILES_FLG=0
REM SET VOLUME_SIZE=1g
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
IF NOT DEFINED VOLUME_SIZE (SET VOLUME_SIZE=0)
IF NOT DEFINED DOWNLOADS_PASSWORD (SET /P DOWNLOADS_PASSWORD="SET DOWNLOADS_PASSWORD(%ARCHIVE_PASSWORD%)=")
IF NOT DEFINED DOWNLOADS_PASSWORD (SET DOWNLOADS_PASSWORD=%ARCHIVE_PASSWORD%)
IF NOT DEFINED XCOPY_ARCHIVES (SET XCOPY_ARCHIVES=0)
IF NOT DEFINED SHUTDOWN_FLG2 (SET SHUTDOWN_FLG2=0)
IF NOT DEFINED MOVE_FILES_FLG (SET MOVE_FILES_FLG=0)

IF EXIST D:\Downloads SET EXTRA_DOWNLOADS_DIR=D:\Downloads\*

IF NOT ""%1""=="""" (
	echo ""%1""
	FOR %%i in (%*) DO (
		ECHO "%%~fi"
		IF NOT "%DOWNLOADS_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%DOWNLOADS_PASSWORD% -mhe
		7z a -t%Z_TYPE% -sdel "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.%Z_TYPE%" ""%%i"" -mx=0
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
	CALL :moveFiles
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
	SET DL_DIR=%ARCHIVE_DIR%\%yyyy%%mm%
	CALL :isEmptyDir  %DOWNLOADS_DIR%
	IF %ERRORLEVEL% EQU 1 (
		ECHO Files not Exist. %DOWNLOADS_DIR%
		EXIT /B
	)
	IF NOT %VOLUME_SIZE%==0 SET OPT_VOLUME=-v%VOLUME_SIZE%
	IF NOT "%DOWNLOADS_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%DOWNLOADS_PASSWORD% -mhe
	7z a -t%Z_TYPE% -sdel %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.%Z_TYPE% %USERPROFILE%\Downloads\* %EXTRA_DOWNLOADS_DIR% -xr!desktop.ini -xr!*.part -xr!*.mega -xr!*.crdownload -xr!*.downloading -mx=%ARCHIVE_OPT_X% %OPT_VOLUME%
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

:moveFiles
	IF EXIST %TOOLS_INSTALL_DIR%\MoveFiles.cmd (CALL %TOOLS_INSTALL_DIR%\MoveFiles.cmd)
	EXIT /B

:COPY_FILE
	IF NOT DEFINED XCOPY_ARCHIVE_DIRECTORY (SET /P XCOPY_ARCHIVE_DIRECTORY="XCOPY_ARCHIVE_DIRECTORY(E:\%USERDOMAIN%)=")
	IF NOT DEFINED XCOPY_ARCHIVE_DIRECTORY (SET XCOPY_ARCHIVE_DIRECTORY=E:\%USERDOMAIN%)
	
	REM XCOPY %ARCHIVE_DIR%\%yyyy%%mm%\%DOWNLOAD_FILENAME%.* %XCOPY_ARCHIVE_DIRECTORY%\%yyyy%%mm%\ /Y /H /S /E /F /K
	ROBOCOPY %ARCHIVE_DIR%\%yyyy%%mm%\ %XCOPY_ARCHIVE_DIRECTORY%\%yyyy%%mm%\ %DOWNLOAD_FILENAME%.* /e /r:3 /w:10 /log:robocopy.log /v /fp /tee
	IF %ERRORLEVEL% EQU 8 (
		NOTEPAD robocopy.log
	) ELSE (
		EXPLORER %XCOPY_ARCHIVE_DIRECTORY%\%yyyy%%mm%\
	)
	DEL robocopy.log
	
	MD %STORE_DIR%\%yyyy%%mm%
	MOVE %ARCHIVE_DIR%\%yyyy%%mm%\*.7z %STORE_DIR%\%yyyy%%mm%\
	MOVE %ARCHIVE_DIR%\%yyyy%%mm%\*.7z.??? %STORE_DIR%\%yyyy%%mm%\
	RMDIR %ARCHIVE_DIR%\%yyyy%%mm%
	EXIT /B
	
	