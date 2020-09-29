@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd

IF NOT "%1"=="" (
	FOR %%i in (%*) DO CALL :Archive_Directory %%~ni.7z %%i
	CALL :Pause
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
		SET ARCHIVE_UPLOAD_FLG=0
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
REM make listfile
REM ----------------------------------------------------------------------
REM SET LIST_TXT=%ARCHIVE_DIR%\%yyyy%%mm%_%USERDOMAIN%.txt
REM IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD%
REM 7z l %ARCHIVE_OPT_PW% %DL_DIR%\*.7z >%LIST_TXT%
REM DEL %ARCHIVE_DIR%\%yyyy%%mm%_%USERDOMAIN%.txt.gpg
REM CALL :makeGpg %GPG_USER_ID% %ARCHIVE_DIR%\%yyyy%%mm%_%USERDOMAIN%.txt.gpg %ARCHIVE_DIR%\%yyyy%%mm%_%USERDOMAIN%.txt

REM ----------------------------------------------------------------------
REM SHUTDOWN
REM ----------------------------------------------------------------------
IF 1 EQU %SHUTDOWN_FLG2% (SHUTDOWN /S /T 30)
CALL :Msg Finished

EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM DOWNLOAD
REM ----------------------------------------------------------------------
:Archive_Downloads
	SET DL_DIR=%ARCHIVE_DIR%\%yyyy%%mm%
	CALL :isEmptyDir  %DOWNLOADS_DIR%
	IF %ERRORLEVEL% EQU 1 (
		ECHO Files not Exist. %DOWNLOADS_DIR%
		EXIT /B
	)
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t7z  -sdel %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.7z %USERPROFILE%\Downloads\* -xr!desktop.ini -xr!*.crdownload -xr!*.downloading -mx=%ARCHIVE_OPT_X%
	7z l %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.7z
	EXIT /B

REM ----------------------------------------------------------------------
REM UPLOAD
REM ----------------------------------------------------------------------
:Archive_Upload
	SET UL_DIR=%ARCHIVE_DIR%\%yyyy%%mm%
	SET UPLOAD_FILENAME=UL_%yyyy%%mm%_%USERDOMAIN%
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t7z  -sdel %ARCHIVE_OPT_PW% %UL_DIR%\%UPLOAD_FILENAME%.7z %UPLOADS_DIR%\* -mx=%ARCHIVE_OPT_X%
	7z l %ARCHIVE_OPT_PW% %UL_DIR%\%UPLOAD_FILENAME%.7z
	MD %UPLOADS_DIR%
	EXIT /B

:Archive_Directory
	SET OUT_NAME=%1
	SET IN=%2
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t7z  %ARCHIVE_OPT_PW% %USERPROFILE%\Desktop\%OUT_NAME% %IN% -mx=%ARCHIVE_OPT_X%
	7z l %ARCHIVE_OPT_PW% %USERPROFILE%\Desktop\%OUT_NAME%
	EXIT /B

:makeGpg
	SET USER_ID=%1
	SET OUT_FILE=%2
	SET IN_FILE=%3
	gpg -e -r %USER_ID% -a -o %OUT_FILE% %IN_FILE%
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

:Msg
	SET MSG=%1
	SET /P END=%MSG%
	EXIT /B
