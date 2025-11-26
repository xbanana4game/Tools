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
CALL :ERROR
IF %ERRORLEVEL% EQU 1 (
	ECHO ERROR
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


