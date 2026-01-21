@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
SETLOCAL ENABLEDELAYEDEXPANSION
SET DRIVE_LETTER_FILE=%CD:~0,2%
SET DRIVE_LETTER_CMD=%~d0

REM ---------- Template.cmd ----------


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SET REPLACE_STR_TEST=ABC\DEF
ECHO %REPLACE_STR_TEST:\=_%
FOR %%i IN (ABC\DEF) DO (
	SET A=%%i
	ECHO !A:\=_!
)
PAUSE
TIMEOUT /T 5
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:SUCCESS
	EXIT /B
	
:ERROR
	EXIT /B 1


