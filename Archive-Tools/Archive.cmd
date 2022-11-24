@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Archive.cmd(SettingsOptions) ----------
REM SET VOLUME_SIZE=1g

REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
	
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF NOT DEFINED Z_TYPE (SET Z_TYPE=7z)
IF NOT DEFINED VOLUME_SIZE (SET VOLUME_SIZE=0)
IF NOT DEFINED DOWNLOADS_PASSWORD (SET /P DOWNLOADS_PASSWORD="SET DOWNLOADS_PASSWORD(%ARCHIVE_PASSWORD%)=")
IF NOT DEFINED DOWNLOADS_PASSWORD (SET DOWNLOADS_PASSWORD=%ARCHIVE_PASSWORD%)

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
	IF NOT %VOLUME_SIZE%==0 SET OPT_VOLUME=-v%VOLUME_SIZE%
	IF NOT "%DOWNLOADS_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%DOWNLOADS_PASSWORD% -mhe
	7z a -t%Z_TYPE% -sdel %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.%Z_TYPE% %USERPROFILE%\Downloads\* -xr!desktop.ini -xr!.ts -xr!*.part -xr!*.mega -xr!*.crdownload -xr!*.downloading -mx=%ARCHIVE_OPT_X% %OPT_VOLUME%
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

