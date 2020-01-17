@ECHO OFF
REM ----------------------------------------------------------------------
REM Ý’èƒtƒ@ƒCƒ‹“Ç‚Ýž‚Ý
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd

REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SET RECORD_TXT=%DOWNLOADS_DIR%\Osu!_Record-%yyyy%%mm%%dd%.txt
CALL :makeRecordTXT
NOTEPAD %RECORD_TXT%
EXIT

:makeRecordTXT
	ECHO %yyyy%/%mm%/%dd% %hh%:%mn%>>%RECORD_TXT%
	EXIT /B


