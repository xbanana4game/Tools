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

REM ---------- Template.cmd(SettingsOptions.cmd) ----------


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SET LAUNCHER_NAME=Epic Games
7z x "%CLOUD_DRIVE%\Cloud-Tools\Games\%LAUNCHER_NAME% - X.zip"
IF NOT EXIST "%LAUNCHER_NAME% - X.vhdx" EXIT
SET /P GAME_NAME="GAME NAME:"
IF EXIST "%LAUNCHER_NAME% - %GAME_NAME%.vhdx" EXIT
ECHO %LAUNCHER_NAME% - %GAME_NAME%
MOVE "Epic Games - X.vhdx" "%LAUNCHER_NAME% - %GAME_NAME%.vhdx"
SET GAME_INSTALL_DIR="C:\Games\Epic Games\%GAME_NAME%"
REM MOUNTVOL %GAME_INSTALL_DIR% /D
MD %GAME_INSTALL_DIR%
ECHO DRIVE: %LAUNCHER_NAME% - %GAME_NAME%
ECHO MOUNT: %GAME_INSTALL_DIR%
REM MOUNTVOL /L
PAUSE
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


