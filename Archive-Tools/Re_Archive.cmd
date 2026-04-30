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
REM ---------- Re_Archive.cmd ----------
REM SET TARGET_DIR=%DOWNLOADS_DIR%
REM SET TARGET_FILE=_log
SET TARGET_FILE=%1
REM CALL Re_Archive.cmd added


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED RA_OUTPUT_DIR SET RA_OUTPUT_DIR=%DESKTOP_DIR%
IF NOT DEFINED TARGET_DIR SET TARGET_DIR=%DOWNLOADS_DIR%
IF NOT DEFINED TARGET_FILE SET /P TARGET_FILE="TARGET_FILE: "
IF NOT DEFINED TARGET_FILE EXIT
IF NOT DEFINED TARGET_FILE_EXP SET TARGET_FILE_EXP=%TARGET_FILE%*
IF NOT DEFINED RA_WORKING_DIR SET RA_WORKING_DIR=%DESKTOP_DIR%\temp
IF NOT DEFINED RA_STORE_DIR SET RA_STORE_DIR=%TARGET_DIR%\store
SET TARGET_FILES=%TARGET_DIR%\%TARGET_FILE_EXP%.zip %TARGET_DIR%\%TARGET_FILE_EXP%.7z
SET OUTPUT_ZIP=%RA_OUTPUT_DIR%\_%TARGET_FILE%.zip

ECHO TARGET_FILES: %TARGET_FILES%
ECHO ========================= INPUT =========================
DIR /B %TARGET_FILES%
ECHO =========================================================
ECHO;
ECHO OUTPUT: %OUTPUT_ZIP%
ECHO STORE: %RA_STORE_DIR%
ECHO;
PAUSE

IF DEFINED RA_STORE_DIR MD %RA_STORE_DIR% 2>nul
MD %RA_WORKING_DIR% 2>nul
CD /D %TARGET_DIR%
FOR /R %%j IN ("%TARGET_FILE_EXP%.zip" "%TARGET_FILE_EXP%.7z") DO (
	ECHO %%j
	7z x %%j -o"%RA_WORKING_DIR%\%TARGET_FILE%" -aou
	IF DEFINED RA_STORE_DIR MOVE %%j %RA_STORE_DIR%
)
RMDIR %RA_WORKING_DIR%\%TARGET_FILE% 2>nul

IF EXIST %RA_WORKING_DIR%\%TARGET_FILE% (
	7z -tzip -sdel a "%OUTPUT_ZIP%" %RA_WORKING_DIR%\%TARGET_FILE%\* -mx=0
	7z l "%OUTPUT_ZIP%">"%OUTPUT_ZIP%.txt"
)
RMDIR %RA_WORKING_DIR%\%TARGET_FILE% 2>nul
RMDIR %RA_WORKING_DIR% 2>nul

PAUSE
EXIT /B


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:SUCCESS
	EXIT /B
	
:ERROR
	EXIT /B 1


