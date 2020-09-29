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
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
SET /P ARCHIVE_PREFIX="Enter PREFIX: "
SET /P ARCHIVE_EXT="Enter EXT: "
IF "%ARCHIVE_EXT%"=="" SET ARCHIVE_EXT=xxx

SET OUTPUT_FILENAME=%ARCHIVE_PREFIX%_%ARCHIVE_EXT%-files
IF "%ARCHIVE_PREFIX%"=="" SET OUTPUT_FILENAME=%ARCHIVE_EXT%-files

7z a -t7z -sdel %OUTPUT_FILENAME%.7z  %ARCHIVE_PREFIX%*.%ARCHIVE_EXT% -r -xr!Archive-Extension.cmd
7z l %OUTPUT_FILENAME%.7z >%OUTPUT_FILENAME%.txt
TYPE %OUTPUT_FILENAME%.txt

PAUSE
EXIT

