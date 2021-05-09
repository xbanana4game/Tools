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
IF DEFINED STEAM_LIBRARY DIR /B %STEAM_LIBRARY%
IF DEFINED STEAM_LIBRARY_2 DIR /B %STEAM_LIBRARY_2%
IF DEFINED STEAM_LIBRARY_3 DIR /B %STEAM_LIBRARY_3%

SET /P GAME_NAME="Set Game name: "

IF DEFINED STEAM_LIBRARY (
	SET GAME_ROOT_DIR="%STEAM_LIBRARY%\%GAME_NAME%"
	CALL :ARCHIVE_GAME_SETTINGS
)

IF DEFINED STEAM_LIBRARY_2 (
	SET GAME_ROOT_DIR="%STEAM_LIBRARY_2%\%GAME_NAME%"
	CALL :ARCHIVE_GAME_SETTINGS
)

IF DEFINED STEAM_LIBRARY_3 (
	SET GAME_ROOT_DIR="%STEAM_LIBRARY_3%\%GAME_NAME%"
	CALL :ARCHIVE_GAME_SETTINGS
)

PAUSE
EXPLORER %DOWNLOADS_DIR%
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
		SET /P ERR=Directory %1 is not Exist.
		EXIT /B 1
	)
	EXIT /B 0

:ARCHIVE_GAME_SETTINGS
	IF NOT DEFINED GAME_NAME EXIT /B
	IF NOT DEFINED GAME_ROOT_DIR GAME_NAME EXIT /B
	CALL :CheckDirectory %GAME_ROOT_DIR%
	IF %ERRORLEVEL% EQU 1 (
		ECHO Directory not Exist. %GAME_ROOT_DIR%
		EXIT /B
	)
	CALL :ChangeDirectory %GAME_ROOT_DIR%
	IF EXIST "%~dp0\%GAME_NAME%_settings.txt.cmd" (
		CALL "%~dp0\%GAME_NAME%_settings.txt.cmd"
	)
	IF NOT EXIST "%~dp0\%GAME_NAME%_settings.txt" (
		EXPLORER %GAME_ROOT_DIR%
		REM FORFILES /s /m *.txt /c "cmd /c ECHO @path >>\"%~dp0\%GAME_NAME%_settings.txt\""
		NOTEPAD "%~dp0\%GAME_NAME%_settings.txt"
	)
	7z a -tzip "%DOWNLOADS_DIR%\%GAME_NAME%-settings-%yyyy%%mm%%dd%@%USERDOMAIN%.zip" -spf2 @"%~dp0\%GAME_NAME%_settings.txt"
	7z l "%DOWNLOADS_DIR%\%GAME_NAME%-settings-%yyyy%%mm%%dd%@%USERDOMAIN%.zip"
	EXIT /B