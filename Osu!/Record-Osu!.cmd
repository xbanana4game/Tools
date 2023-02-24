@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SET RECORD_TXT=%DOCUMENTS_DIR%\Osu!-Record-%yyyy%%mm%.txt
CALL :makeRecordTXT
START NOTEPAD %RECORD_TXT%
EXIT

:makeRecordTXT
	ECHO %yyyy%/%mm%/%dd% %hh%:%mn%>>%RECORD_TXT%
	ECHO .>>%RECORD_TXT%
	EXIT /B


