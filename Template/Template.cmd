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
SET SCRIPTDIR=%TOOLS_DIR%\cmd_function
SET FUNCTION_TEST=%SCRIPTDIR%\CMD_F_TEMPLATE.cmd
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
CALL :ERROR_2
IF ERRORLEVEL 2 (
	ECHO ERROR
)
CALL CMD_F_TEMPLATE.cmd PARAM_TEST P1 P2 P3
CALL %FUNCTION_TEST% PARAM_TEST P1 P2 P3
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

:ERROR_2
	EXIT /B 2
