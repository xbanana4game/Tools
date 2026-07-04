@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Template.cmd(SettingsOptions.cmd) ----------
SETLOCAL ENABLEDELAYEDEXPANSION
SET DRIVE_LETTER_FILE=%CD:~0,2%
SET DRIVE_LETTER_CMD=%~d0

REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SET CAPTURES_LIST_FILE=%TOOLS_DIR%\Games\captures.txt
TYPE %TOOLS_DIR%\Games\captures.txt
ECHO ======================================================================
FOR /F "skip=1 tokens=1,2,3 delims=:" %%C IN (%CAPTURES_LIST_FILE%) DO (
	ECHO %%C : %%D
)

ECHO;
DIR /B %DESKTOP_DIR%
ECHO;

FOR %%i IN (*.cmd) DO (
	ECHO %%~fi
	ECHO %%~ni
)

FOR %%i IN (A B C) DO (
	ECHO %%i
)

ECHO SEARCH SUB DIRECTORY
FOR /R %DESKTOP_DIR% %%i IN (*.txt *.csv) DO (
	ECHO %%~i
)
ECHO;

ECHO NOT SEARCH SUB DIRECTORY 
FOR %%i IN (%DESKTOP_DIR%/*.txt %DESKTOP_DIR%/*.csv) DO (
	ECHO %%~i
)
ECHO;
PAUSE

