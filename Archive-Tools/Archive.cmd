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
IF NOT DEFINED DOWNLOADS_PASSWORD (SET /P DOWNLOADS_PASSWORD="SET DOWNLOADS_PASSWORD(%ARCHIVE_PASSWORD%)=")
IF NOT DEFINED DOWNLOADS_PASSWORD (SET DOWNLOADS_PASSWORD=%ARCHIVE_PASSWORD%)

IF NOT ""%1""=="""" (
echo ""%1""
	FOR %%i in (%*) DO (
		ECHO "%%fi"
		7z a -t7z  "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%.7z" ""%%i""
		7z l "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%.7z"
	)
	PAUSE
	EXIT
)

REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF 1 EQU %SHUTDOWN_FLG% SET /P SHUTDOWN_FLG2="Shutdown? 1:YES 0:NO -> "
IF ""=="%SHUTDOWN_FLG2%" SET SHUTDOWN_FLG2=0

IF 1 EQU %ARCHIVE_UPLOAD_FLG% (
	CALL :isEmptyDir  %UPLOADS_DIR%
	IF %ERRORLEVEL% EQU 1 (
		ECHO Files not Exist. %UPLOADS_DIR%
		MD %UPLOADS_DIR%
	)
	SET /P ARCHIVE_UPLOAD_FLG2="Archive Upload Dir? 1:YES 0:NO -> "
	IF ""=="%ARCHIVE_UPLOAD_FLG2%" SET ARCHIVE_UPLOAD_FLG2=0
) ELSE (
	SET ARCHIVE_UPLOAD_FLG2=0
)

REM ----------------------------------------------------------------------
REM UPLOAD
REM ----------------------------------------------------------------------
IF 1 EQU %ARCHIVE_UPLOAD_FLG2% CALL :Archive_Upload

REM ----------------------------------------------------------------------
REM DOWNLOAD
REM ----------------------------------------------------------------------
IF 1 EQU %MOVE_FILES_FLG% CALL :moveFiles
CALL :Archive_Downloads

REM ----------------------------------------------------------------------
REM SHUTDOWN
REM ----------------------------------------------------------------------
IF 1 EQU %SHUTDOWN_FLG2% (SHUTDOWN /S /T 3)

PAUSE
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
	IF NOT "%DOWNLOADS_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%DOWNLOADS_PASSWORD% -mhe
	7z a -t7z  -sdel %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.7z %USERPROFILE%\Downloads\* -xr!desktop.ini -xr!*.crdownload -xr!*.downloading -mx=%ARCHIVE_OPT_X%
	7z l %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.7z
	EXIT /B

:Archive_Upload
	SET UL_DIR=%ARCHIVE_DIR%\%yyyy%%mm%
	SET UPLOAD_FILENAME=UL_%yyyy%%mm%_%USERDOMAIN%
	IF NOT "%DOWNLOADS_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%DOWNLOADS_PASSWORD% -mhe
	7z a -t7z  -sdel %ARCHIVE_OPT_PW% %UL_DIR%\%UPLOAD_FILENAME%.7z %UPLOADS_DIR%\* -mx=%ARCHIVE_OPT_X%
	7z l %ARCHIVE_OPT_PW% %UL_DIR%\%UPLOAD_FILENAME%.7z
	MD %UPLOADS_DIR%
	EXIT /B

:Archive_Directory
	SET OUT_NAME=%1
	SET IN=%2
	IF NOT "%DOWNLOADS_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%DOWNLOADS_PASSWORD% -mhe
	7z a -t7z  %ARCHIVE_OPT_PW% %ARCHIVE_DIR%\%OUT_NAME% %IN% -mx=%ARCHIVE_OPT_X%
	7z l %ARCHIVE_OPT_PW% %ARCHIVE_DIR%\%OUT_NAME%
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

