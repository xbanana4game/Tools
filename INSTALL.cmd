@ECHO OFF

REM ======================================================================
REM
REM                                INSTALL
REM
REM ======================================================================
SET SAKURA_SETTINGS_DIR=%USERPROFILE%\AppData\Roaming\sakura
CALL :INSTALL_SETTINGS
ECHO SET PATH=%%PATH%%;%~dp0Games;%~dp0File-Tools>>%USERPROFILE%\SettingsOptions@%USERDOMAIN%.cmd
CALL :INSTALL_SAKURA_MACRO
CALL :BACKUP_SETTINGS
PAUSE
EXPLORER %USERPROFILE%
IF EXIST "%SAKURA_SETTINGS_DIR%" EXPLORER %SAKURA_SETTINGS_DIR%
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:INSTALL_SETTINGS
	COPY Settings.cmd.txt %USERPROFILE%\Settings.cmd
	IF EXIST "SettingsOptions.cmd.txt" (
		NOTEPAD SettingsOptions.cmd.txt
		COPY SettingsOptions.cmd.txt %USERPROFILE%\SettingsOptions@%USERDOMAIN%.cmd
	)
	IF EXIST "MoveFiles.cmd.txt" (
		NOTEPAD MoveFiles.cmd.txt
		COPY MoveFiles.cmd.txt %USERPROFILE%\MoveFiles@%USERDOMAIN%.cmd
	)
	EXIT /B
	
:INSTALL_SAKURA_MACRO
	IF EXIST "C:\Program Files (x86)\sakura" (
		COPY Sakura\ppa.dll "C:\Program Files (x86)\sakura"
	)
	IF EXIST "%SAKURA_SETTINGS_DIR%" (
		COPY Osu!\*.mac %SAKURA_SETTINGS_DIR%\
		COPY Osu!\*.ppa %SAKURA_SETTINGS_DIR%\
		COPY Games\*.mac %SAKURA_SETTINGS_DIR%\
	)
	EXIT /B
	
:BACKUP_SETTINGS
	IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT /B)
	CALL %USERPROFILE%\Settings.cmd
	REM IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t7z  %ARCHIVE_OPT_PW% %USERPROFILE%\Tools-Settings@%USERDOMAIN%_%yyyy%%mm%%dd%.7z MoveFiles.cmd.txt SettingsOptions.cmd.txt Settings.cmd.txt
	EXIT /B

	