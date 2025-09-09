@ECHO OFF
REM ======================================================================
REM
REM                                MoveFiles-user.cmd
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
IF NOT DEFINED _SETTING_OPTIONS CALL %USERPROFILE%\.Tools\Settings.cmd
REM DONT USE SETLOCAL ENABLEDELAYEDEXPANSION
SET DRIVE_LETTER_FILE=%CD:~0,2%
SET DRIVE_LETTER_CMD=%~d0


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF %USERDOMAIN%==TVAIO-NOTE (
	IF EXIST %DOWNLOADED_VIDEOS_DIR%\xxx MOVE %DOWNLOADED_VIDEOS_DIR%\xxx %XXX_VIDEOS_DIR%
	SET VIDEO_DB_FILE=%CONFIG_DIR%\videos_%USERDOMAIN%.sqlite3
)
IF %USERDOMAIN%==BABEL-DESKTOP (
	IF EXIST %DOWNLOADED_VIDEOS_DIR%\xxx MOVE %DOWNLOADED_VIDEOS_DIR%\xxx %XXX_VIDEOS_DIR%
)
EXIT /B



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================


