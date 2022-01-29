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
IF NOT DEFINED SAVE_STEAM_SS_FLG SET /P SAVE_STEAM_SS_FLG="SAVE_STEAM_SS_FLG [1|0] -> "
IF "%SAVE_STEAM_SS_FLG%"=="" SET SAVE_STEAM_SS_FLG=0
CALL :CheckDirectory %STEAM_DIR%\userdata

FOR /F "tokens=1,2* delims=," %%i IN (%TOOLS_DIR%\Games\steam_screenshots.txt) DO CALL :ArchiveGameScreenshots %%i %%j
IF %SAVE_STEAM_SS_FLG% EQU 1 CALL :ArchiveSteamScreenshots 

REM If not called MoveFiles.cmd pause.
IF NOT DEFINED ARCHIVE_FLG PAUSE
EXIT /B


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:CheckDirectory
	IF EXIST %1 (
		ECHO Directory %1 is Exist.
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0

:ArchiveGameScreenshots
	SET GAME_NAME=%1%
	SET SS_DIR=%2%
	SET OUT="%DOWNLOADS_DIR%\%GAME_NAME%-Screenshots-%yyyy%%mm%%dd%_%hh%%mn%@%USERDOMAIN%.zip"
	IF EXIST %SS_DIR% (
		CD /D %SS_DIR%
		7z a -tzip -sdel %OUT%  -ir!%yyyy%*  -mx=0
		7z d %OUT% thumbnails -r
		7z l %OUT%
	)
	EXIT /B

:ArchiveSteamScreenshots
	SET OUT="%DOWNLOADS_DIR%\Steam-Screenshots-%yyyy%%mm%%dd%_%hh%%mn%@%USERDOMAIN%.zip"
	CALL :CheckDirectory %STEAM_DIR%\userdata
	CD /D %STEAM_DIR%
	7z a -tzip %OUT% -ir!*\screenshots\%yyyy%*.jpg  -xr!thumbnails  -mx=0
	7z l %OUT%
	EXIT /B

