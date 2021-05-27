@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED DOWNLOADS_PASSWORD (SET /P DOWNLOADS_PASSWORD="SET DOWNLOADS_PASSWORD(%ARCHIVE_PASSWORD%)=")
IF NOT DEFINED DOWNLOADS_PASSWORD (SET DOWNLOADS_PASSWORD=%ARCHIVE_PASSWORD%)

IF NOT "%1"=="" (
	FOR %%i in (%*) DO (CALL :Extract7z %%i)
	EXIT
)

DIR /B %ARCHIVE_DIR%
SET /P EXTRACT_YYYY="Enter Extract YYYY or YYYYMM. (Default:%yyyy%%mm%) -> "
IF "%EXTRACT_YYYY%"=="" SET EXTRACT_YYYY=%yyyy%%mm%
CALL :MAKE_LIST_FILE
CALL :EXTRACT_YYYYMM
PAUSE
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:MAKE_LIST_FILE
	FOR /D %%i IN ("%ARCHIVE_DIR%\%EXTRACT_YYYY%*") DO (
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\DL_*.7z") DO (
			7z l -p%DOWNLOADS_PASSWORD% %%j
		)
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\UL_*.7z") DO (
			7z l -p%DOWNLOADS_PASSWORD% %%j
		)
	)
	EXIT /B

:EXTRACT_YYYYMM
	IF NOT DEFINED EXTRACT_EXT SET /P EXTRACT_EXT="SET EXTRACT_EXT (Default:*) -> "
	IF "%EXTRACT_EXT%"=="" SET EXTRACT_EXT=*
	IF NOT DEFINED EXTRACT_TARGET_DIR SET /P EXTRACT_TARGET_DIR="SET EXTRACT_TARGET_DIR (Default:%DESKTOP_DIR%) -> "
	IF "%EXTRACT_TARGET_DIR%"=="" SET EXTRACT_TARGET_DIR=%DESKTOP_DIR%
	FOR /D %%i IN ("%ARCHIVE_DIR%\%EXTRACT_YYYY%*") DO (
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\DL_*.7z") DO (
			7z x -p%DOWNLOADS_PASSWORD% %%j -o%EXTRACT_TARGET_DIR%\%%~ni -aot %EXTRACT_EXT% -r
		)
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\UL_*.7z") DO (
			7z x -p%DOWNLOADS_PASSWORD% %%j -o%EXTRACT_TARGET_DIR%\%%~ni -aot %EXTRACT_EXT% -r
		)
	)
	EXIT /B
	
:Extract7z
	SET EXTRACT_FILE=%1
	SET EXTRACT_EXT=*
	SET OUTPUT_DIR=%USERPROFILE%\Desktop
	7z x -p%DOWNLOADS_PASSWORD% %EXTRACT_FILE% -o%OUTPUT_DIR%\* %EXTRACT_EXT% -r
	EXIT /B

