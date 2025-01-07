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

REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
CHOICE /C YN /T 10 /D N /M "test"
IF %ERRORLEVEL% EQU 1 (
	ECHO YES
) ELSE (
	ECHO NO
)

CHOICE /C 01 /M "FLG:"
IF %ERRORLEVEL% EQU 1 (
	ECHO FLG is 0
) ElSE IF %ERRORLEVEL% EQU 2 (
	ECHO FLG is 1
)

CHOICE /C 12345 /M "SELECT:"
IF %ERRORLEVEL% EQU 1 (
	ECHO FLG is 1
) ElSE IF %ERRORLEVEL% EQU 2 (
	ECHO FLG is 2
) ElSE IF %ERRORLEVEL% EQU 3 (
	ECHO FLG is 3
) ElSE IF %ERRORLEVEL% EQU 4 (
	ECHO FLG is 4
) ElSE IF %ERRORLEVEL% EQU 5 (
	ECHO FLG is 5
)

IF NOT DEFINED FLG (
	CHOICE /C 01 /M "FLG:"
	IF !ERRORLEVEL! EQU 1 (
		SET FLG=0
	) ElSE IF !ERRORLEVEL! EQU 2 (
		SET FLG=1
	)
)
PAUSE
EXIT

