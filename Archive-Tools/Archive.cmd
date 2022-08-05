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
	
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF NOT DEFINED DOWNLOADS_PASSWORD (SET /P DOWNLOADS_PASSWORD="SET DOWNLOADS_PASSWORD(%ARCHIVE_PASSWORD%)=")
IF NOT DEFINED DOWNLOADS_PASSWORD (SET DOWNLOADS_PASSWORD=%ARCHIVE_PASSWORD%)

IF NOT ""%1""=="""" (
	echo ""%1""
	FOR %%i in (%*) DO (
		ECHO "%%~fi"
		7z a -t7z -sdel "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.7z" ""%%i"" -v25g
		IF EXIST "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.7z.001" (
			7z l "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.7z.001">"%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.7z.txt"
			TYPE "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.7z.txt"
		) ELSE (
			7z l "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.7z">"%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.7z.txt"
			TYPE "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%_%USERDOMAIN%.7z.txt"
		)
	)
	PAUSE
	EXIT
)

IF NOT DEFINED MOVEFILES_ONLY (SET /P MOVEFILES_ONLY="SET MOVEFILES_ONLY(1)=")
IF ""=="%MOVEFILES_ONLY%" SET MOVEFILES_ONLY=1
IF 1 EQU %MOVEFILES_ONLY% (
	CALL :moveFiles
	EXIT
)

REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF 1 EQU %SHUTDOWN_FLG% SET /P SHUTDOWN_FLG2="Shutdown? 1:YES 0:NO -> "
IF ""=="%SHUTDOWN_FLG2%" SET SHUTDOWN_FLG2=0

REM ----------------------------------------------------------------------
REM DOWNLOAD
REM ----------------------------------------------------------------------
IF 1 EQU %MOVE_FILES_FLG% (
	SET ARCHIVE_FLG=1
	CALL :moveFiles
)
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
	IF NOT "%DOWNLOADS_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%DOWNLOADS_PASSWORD% -mhe -v1g
	7z a -t7z -sdel %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.7z %USERPROFILE%\Downloads\* -xr!desktop.ini -xr!*.part -xr!*.mega -xr!*.crdownload -xr!*.downloading -mx=%ARCHIVE_OPT_X%
	IF EXIST "%DL_DIR%\%DOWNLOAD_FILENAME%.7z.001" (
		7z l %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.7z.001
	) ELSE (
		7z l %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.7z
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

