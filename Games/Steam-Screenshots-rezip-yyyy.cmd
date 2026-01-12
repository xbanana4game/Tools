@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Steam-Screenshots-rezip-yyyy.cmd(SettingsOptions.cmd) ----------
SET yyyy=2023
REM IF NOT DEFINED DRIVE_LETTER (SET DRIVE_LETTER=%CD:~0,1%)
REM SET SS_BASE_DIR=%DRIVE_LETTER%:\ARCHIVE%yyyy%\Downloads\%yyyy%
SET SS_OUTPUT_DIR=%DESKTOP_DIR%\Screenshots
REM SET SS_OUTPUT_DIR=%DRIVE_LETTER%:\ARCHIVE%yyyy%\Downloads\Screenshots
SET SS_WORK_DIR=%DESKTOP_DIR%\Steam-SS-Work
SET SS_STORE_DIR=%DRIVE_LETTER%:\ARCHIVE%yyyy%\Downloads\Screenshots-Store


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF NOT DEFINED SS_BASE_DIR (SET /P SS_BASE_DIR="SET SS_BASE_DIR(E:\ARCHIVE%yyyy%\Downloads\%yyyy%)=")
IF NOT DEFINED SS_BASE_DIR (SET SS_BASE_DIR=E:\ARCHIVE%yyyy%\Downloads\%yyyy%)
CD /D %SS_BASE_DIR%
MD %SS_WORK_DIR% 2>nul
IF NOT EXIST %SS_OUTPUT_DIR% MD %SS_OUTPUT_DIR%

ECHO SS_BASE_DIR:%SS_BASE_DIR%
ECHO SS_WORK_DIR:%SS_WORK_DIR%
ECHO SS_OUTPUT_DIR:%SS_OUTPUT_DIR%
DIR /B %SS_BASE_DIR%\*-Screenshots-%yyyy%*.zip
EXPLORER %SS_BASE_DIR%
PAUSE

FOR /F "tokens=1,2* delims=," %%i IN (%TOOLS_DIR%\Games\steam_screenshots.txt) DO (
	ECHO SEARCH %SS_BASE_DIR%\%%i-Screenshots-%yyyy%*.zip
	MD %SS_WORK_DIR%\%%i 2>nul
	IF DEFINED SS_STORE_DIR MD %SS_STORE_DIR% 2>nul
	FOR /R %%j IN ("%%i-Screenshots-%yyyy%*.zip") DO (
		7z x %%j -o"%SS_WORK_DIR%\%%i" -xr!thumbnails
		IF DEFINED SS_STORE_DIR MOVE %%j %SS_STORE_DIR%
	)
	RMDIR %SS_WORK_DIR%\%%i
	IF EXIST %SS_WORK_DIR%\%%i (
		MD %SS_OUTPUT_DIR%\%%i\screenshots 2>nul
		7z -tzip -sdel a "%SS_OUTPUT_DIR%\%%i\screenshots\%%i-Screenshots-%yyyy%.zip" %SS_WORK_DIR%\%%i\* -mx=0
	)
	RMDIR %SS_WORK_DIR%\%%i
)
RMDIR %SS_WORK_DIR%

PAUSE


