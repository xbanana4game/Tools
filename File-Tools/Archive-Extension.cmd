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
CALL :INPUT_SETTINGS

SET OUTPUT_FILENAME=%ARCHIVE_PREFIX%_%ARCHIVE_EXT%-files
IF "%ARCHIVE_PREFIX%"=="" SET OUTPUT_FILENAME=%ARCHIVE_EXT%-files

7z a -t7z -sdel %OUTPUT_FILENAME%.7z  %ARCHIVE_PREFIX%*.%ARCHIVE_EXT% -r -xr!Archive-Extension.cmd
7z l %OUTPUT_FILENAME%.7z >%OUTPUT_FILENAME%.txt
TYPE %OUTPUT_FILENAME%.txt

PAUSE
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:INPUT_SETTINGS
	IF NOT DEFINED ARCHIVE_PREFIX (SET /P ARCHIVE_PREFIX="Enter PREFIX: ")
	IF NOT DEFINED ARCHIVE_PREFIX (SET ARCHIVE_PREFIX=)
	IF NOT DEFINED ARCHIVE_EXT (SET /P ARCHIVE_EXT="Enter EXT: ")
	IF NOT DEFINED ARCHIVE_EXT (SET ARCHIVE_EXT=xxx)
	EXIT /B


