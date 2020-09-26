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
SET EXTRACT_TARGET_DIR=
REM SET ARCHIVE_DIR=%BACKUPS_DIR%\Downloads
DIR /B %ARCHIVE_DIR%
SET /P EXTRACT_YYYY="Enter Extract YYYY or YYYYMM. (Default:%yyyy%) -> "
IF "%EXTRACT_YYYY%"=="" SET EXTRACT_YYYY=%yyyy%
CALL :MAKE_LIST_FILE
CALL :EXTRACT_YYYYMM_ALL
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:MAKE_LIST_FILE
	FOR /D %%i IN ("%ARCHIVE_DIR%\%EXTRACT_YYYY%*") DO (
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\DL_*.7z") DO (
			7z l -p%ARCHIVE_PASSWORD% %%j
		)
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\UL_*.7z") DO (
			7z l -p%ARCHIVE_PASSWORD% %%j
		)
	)
	EXIT /B

:EXTRACT_YYYYMM_ALL
	SET /P EXTRACT_EXT="Enter Extract Target. (Default:*) -> "
	IF NOT DEFINED EXTRACT_TARGET_DIR SET /P EXTRACT_TARGET_DIR="Enter Extract Target Directory. (A:\Downloads) -> "
	IF "%EXTRACT_EXT%"=="" SET EXTRACT_EXT=*
	FOR /D %%i IN ("%ARCHIVE_DIR%\%EXTRACT_YYYY%*") DO (
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\DL_*.7z") DO (
			7z x -p%ARCHIVE_PASSWORD% %%j -o%EXTRACT_TARGET_DIR%\%%~ni -aot %EXTRACT_EXT% -r
		)
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\UL_*.7z") DO (
			7z x -p%ARCHIVE_PASSWORD% %%j -o%EXTRACT_TARGET_DIR%\%%~ni -aot %EXTRACT_EXT% -r
		)
	)
	EXIT /B
	
