@ECHO OFF
REM ----------------------------------------------------------------------
REM 設定ファイル読み込み
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd

IF NOT "%1"=="" (
	FOR %%i in (%*) DO (CALL :Archive_Directory %%~ni.7z %%i)
	EXPLORER %USERPROFILE%\Desktop
	EXIT
)
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF 1 EQU %SHUTDOWN_FLG% SET /P SHUTDOWN_FLG2="Shutdown? 1:YES 0:NO -> "
IF ""=="%SHUTDOWN_FLG2%" SET SHUTDOWN_FLG2=0

REM ----------------------------------------------------------------------
REM ARCHIVE_UPLOAD
REM ----------------------------------------------------------------------
CALL :isEmptyDir  %UPLOADS_DIR%
IF %ERRORLEVEL% EQU 1 (
	ECHO Files not Exist.
	MD %UPLOADS_DIR%
	SET ARCHIVE_UPLOAD_FLG=0
)
IF 1 EQU %ARCHIVE_UPLOAD_FLG% SET /P ARCHIVE_UPLOAD_FLG2="Archive Upload Dir? 1:YES 0:NO -> "
IF ""=="%ARCHIVE_UPLOAD_FLG2%" SET ARCHIVE_UPLOAD_FLG2=0

IF 1 EQU %ARCHIVE_UPLOAD_FLG2% (CALL :Archive_Upload)

REM ----------------------------------------------------------------------
REM ダウンロード
REM ----------------------------------------------------------------------
IF 1 EQU %MOVE_FILES_FLG% CALL :moveFiles
CALL :Archive_Downloads

REM ----------------------------------------------------------------------
REM リスト作成
REM ----------------------------------------------------------------------
REM SET LIST_TXT=%ARCHIVE_DIR%\%yyyy%%mm%_%USERDOMAIN%.txt
REM IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD%
REM 7z l %ARCHIVE_OPT_PW% %DL_DIR%\*.7z >%LIST_TXT%
REM DEL %ARCHIVE_DIR%\%yyyy%%mm%_%USERDOMAIN%.txt.gpg
REM CALL :makeGpg %GPG_USER_ID% %ARCHIVE_DIR%\%yyyy%%mm%_%USERDOMAIN%.txt.gpg %ARCHIVE_DIR%\%yyyy%%mm%_%USERDOMAIN%.txt

REM ----------------------------------------------------------------------
REM シャットダウン処理
REM ----------------------------------------------------------------------
IF 1 EQU %SHUTDOWN_FLG2% (SHUTDOWN /S /T 30)
EXPLORER %ARCHIVE_DIR%

EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM ダウンロード
REM ----------------------------------------------------------------------
:Archive_Downloads
	SET DOWNLOAD_FILENAME=DL_%yyyy%%mm%%dd%_%USERDOMAIN%
	SET DL_DIR=%ARCHIVE_DIR%\%yyyy%%mm%
	CALL :isEmptyDir  %DOWNLOADS_DIR%
	IF %ERRORLEVEL% EQU 1 (
		ECHO Files not Exist.
		EXIT /B
	)
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t7z  -sdel %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.7z %USERPROFILE%\Downloads\* -xr!desktop.ini -xr!*.crdownload -mx=%ARCHIVE_OPT_X%
	EXIT /B

REM ----------------------------------------------------------------------
REM アップロード処理関数
REM ----------------------------------------------------------------------
:Archive_Upload
	SET UL_DIR=%ARCHIVE_DIR%\%yyyy%%mm%
	MD %UL_DIR%
	SET UPLOAD_FILENAME=UL_%yyyy%%mm%_%USERDOMAIN%
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t7z  -sdel %ARCHIVE_OPT_PW% %UL_DIR%\%UPLOAD_FILENAME%.7z %UPLOADS_DIR%\* -mx=%ARCHIVE_OPT_X%
	MD %UPLOADS_DIR%
	EXIT /B

:Archive_Directory
	SET OUT_NAME=%1
	SET IN=%2
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t7z  %ARCHIVE_OPT_PW% %USERPROFILE%\Desktop\%OUT_NAME% %IN% -mx=%ARCHIVE_OPT_X%
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
	IF EXIST %USERPROFILE%\MoveFiles@%USERDOMAIN%.cmd (CALL %USERPROFILE%\MoveFiles@%USERDOMAIN%.cmd)
	EXIT /B
