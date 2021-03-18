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
SET EXTRACT_EXT=*

IF "%1"=="" (
	FOR %%i IN ("%ARCHIVE_DIR%\%YYYYMM%\*.7z") DO CALL :Extract7z %%i %EXTRACT_EXT%
) ELSE (
	FOR %%i in (%*) DO (CALL :Extract7z %%i %EXTRACT_EXT%)
)
EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:Extract7z
	SET EXTRACT_FILE=%1
	SET EXTRACT_EXT=%2
	SET OUTPUT_DIR=%USERPROFILE%\Desktop
	7z x -p%DOWNLOADS_PASSWORD% %EXTRACT_FILE% -o%OUTPUT_DIR%\* %EXTRACT_EXT% -r
	EXIT /B


