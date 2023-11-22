@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Steam-Screenshots.cmd(SettingsOptions.cmd) ----------
REM SET STEAM_DIR=C:\Progra~2\Steam
REM SET STEAM_LIBRARY=%STEAM_DIR%\steamapps\common
REM SET STEAM_LIBRARY_Z=D
REM x=[0 | 1 | 3 | 5 | 7 | 9 ] 
REM SET GAMES_OPT_X=5
REM SET GAME_NAME=
REM SET OUTPUT_FILE_NAME=%GAME_NAME%-settings-%yyyy%%mm%%dd%_%hh%%mn%@%USERDOMAIN%.zip
REM SET OUTPUT_DIR=%DOWNLOADS_DIR%


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
DIR /B G_*_settings.txt.cmd

REM IF NOT DEFINED STEAM_DRIVE_LETTER (SET /P STEAM_DRIVE_LETTER="SET STEAM_DRIVE_LETTER(%CD:~0,1%)=")
IF DEFINED STEAM_LIBRARY DIR /B %STEAM_LIBRARY%
IF DEFINED STEAM_LIBRARY_Z DIR /B %STEAM_LIBRARY_Z%

IF NOT DEFINED STEAM_DRIVE_LETTER (SET STEAM_DRIVE_LETTER=%CD:~0,1%)
IF NOT %STEAM_DRIVE_LETTER% EQU C (SET STEAM_LIBRARY_Z=%STEAM_DRIVE_LETTER%:\SteamLibrary\steamapps\common)

IF NOT DEFINED GAMES_OPT_X (SET GAMES_OPT_X=3)

IF NOT DEFINED GAME_NAME (SET /P GAME_NAME="Set Game name: ")
IF NOT DEFINED OUTPUT_FILE_NAME (SET OUTPUT_FILE_NAME=%GAME_NAME%-settings-%yyyy%%mm%%dd%_%hh%%mn%@%USERDOMAIN%.zip)
IF NOT DEFINED OUTPUT_DIR (SET OUTPUT_DIR=%DOWNLOADS_DIR%)

IF DEFINED STEAM_LIBRARY (
	SET GAME_ROOT_DIR=%STEAM_LIBRARY%\%GAME_NAME%
	CALL :ARCHIVE_GAME_SETTINGS
)
IF DEFINED STEAM_LIBRARY_Z (
	SET GAME_ROOT_DIR=%STEAM_LIBRARY_Z%\%GAME_NAME%
	CALL :ARCHIVE_GAME_SETTINGS
)

SET GAME_ROOT_DIR=%DOCUMENTS_DIR%\My Games
CALL :ARCHIVE_GAME_SETTINGS

PAUSE
EXPLORER %OUTPUT_DIR%
EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:ChangeDirectory
	IF EXIST %1 (
		CD /D %1
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0
	
:CheckDirectory
	IF EXIST %1 (
		ECHO Directory %1 is Exist.
	) ELSE (
		ECHO Directory %1 is not Exist.
		EXIT /B 1
	)
	EXIT /B 0

:ARCHIVE_GAME_SETTINGS
	IF NOT DEFINED GAME_NAME EXIT /B
	IF NOT DEFINED GAME_ROOT_DIR GAME_NAME EXIT /B
	CALL :CheckDirectory "%GAME_ROOT_DIR%"
	IF %ERRORLEVEL% EQU 1 (
		ECHO Directory not Exist. "%GAME_ROOT_DIR%"
		EXIT /B
	)
	CALL :ChangeDirectory "%GAME_ROOT_DIR%"
	IF EXIST "%TOOLS_DIR%\Games\G_%GAME_NAME%_settings.txt.cmd" (
		CALL "%TOOLS_DIR%\Games\G_%GAME_NAME%_settings.txt.cmd">"%TOOLS_DIR%\Games\G_%GAME_NAME%_settings.txt"
	) ELSE (
		ECHO ECHO "%%USERPROFILE%%\Documents\My Games\%GAME_NAME%">"%TOOLS_DIR%\Games\G_%GAME_NAME%_settings.txt.cmd"
		ECHO ECHO "%%GAME_ROOT_DIR%%\config">>"%TOOLS_DIR%\Games\G_%GAME_NAME%_settings.txt.cmd"
		NOTEPAD "%TOOLS_DIR%\Games\G_%GAME_NAME%_settings.txt.cmd"
		CALL "%TOOLS_DIR%\Games\G_%GAME_NAME%_settings.txt.cmd">"%TOOLS_DIR%\Games\G_%GAME_NAME%_settings.txt"
	)
	IF NOT EXIST "%TOOLS_DIR%\Games\G_%GAME_NAME%_settings.txt" (
		EXPLORER "%GAME_ROOT_DIR%"
		REM FORFILES /s /m *.txt /c "cmd /c ECHO @path >>\"%TOOLS_DIR%\Games\G_%GAME_NAME%_settings.txt\""
		NOTEPAD "%TOOLS_DIR%\Games\G_%GAME_NAME%_settings.txt."
	)
	7z a -tzip "%OUTPUT_DIR%\%OUTPUT_FILE_NAME%" -spf2 @"%TOOLS_DIR%\Games\G_%GAME_NAME%_settings.txt" -mx=%GAMES_OPT_X%
	7z l "%OUTPUT_DIR%\%OUTPUT_FILE_NAME%"
	DEL "%TOOLS_DIR%\Games\G_%GAME_NAME%_settings.txt"
	EXIT /B