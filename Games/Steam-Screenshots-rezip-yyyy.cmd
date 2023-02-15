@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
SET yyyy=2022
SET SS_BASE_DIR=D:\Games-Screenshots
SET SS_OUTPUT_DIR=%DESKTOP_DIR%
SET SS_WORK_DIR=%DESKTOP_DIR%\Steam-SS-Work

CD /D %SS_BASE_DIR%
MD %SS_WORK_DIR%
FOR /F "tokens=1,2* delims=," %%i IN (%TOOLS_DIR%\Games\steam_screenshots.txt) DO (
	MD %SS_WORK_DIR%\%%i
	FOR /R %%j IN ("%%i-Screenshots-%yyyy%*.zip") DO (
		7z x %%j -o"%SS_WORK_DIR%\%%i"
	)
	RMDIR %SS_WORK_DIR%\%%i
	IF EXIST %SS_WORK_DIR%\%%i 7z -tzip -sdel a "%SS_OUTPUT_DIR%\%%i-Screenshots-%yyyy%.zip" %SS_WORK_DIR%\%%i\* -mx=0
	RMDIR %SS_WORK_DIR%\%%i
)
RMDIR %SS_WORK_DIR%

PAUSE


