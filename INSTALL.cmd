@ECHO OFF

SET TOOLS_INSTALL_DIR=%USERPROFILE%\.Tools
SET SAKURA_SETTINGS_DIR=%USERPROFILE%\AppData\Roaming\sakura
REM ======================================================================
REM
REM                                INSTALL
REM
REM ======================================================================
CALL :INSTALL_SETTINGS
CALL :INSTALL_SAKURA_MACRO
CALL :BACKUP_SETTINGS
PAUSE
EXPLORER %TOOLS_INSTALL_DIR%
REM IF EXIST "%SAKURA_SETTINGS_DIR%" EXPLORER %SAKURA_SETTINGS_DIR%
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:INSTALL_SETTINGS
	MD %TOOLS_INSTALL_DIR%
	COPY Settings.cmd.txt %USERPROFILE%\Settings.cmd
	COPY Settings.cmd.txt %TOOLS_INSTALL_DIR%\Settings.cmd
	IF EXIST "SettingsOptions.cmd.txt" (
		NOTEPAD SettingsOptions.cmd.txt
		COPY SettingsOptions.cmd.txt %TOOLS_INSTALL_DIR%\SettingsOptions.cmd
		ECHO SET PATH=%%PATH%%;%~dp0Games;%~dp0File-Tools;%TOOLS_INSTALL_DIR%>>%TOOLS_INSTALL_DIR%\SettingsOptions.cmd
	)
	IF EXIST "MoveFiles.cmd.txt" (
		NOTEPAD MoveFiles.cmd.txt
		COPY MoveFiles.cmd.txt %TOOLS_INSTALL_DIR%\MoveFiles.cmd
	)
	MD %TOOLS_INSTALL_DIR%\bin
	COPY Archive-Tools\Archive-Tool.cmd %TOOLS_INSTALL_DIR%\bin
	COPY Keepass-Tools\Archive-kdbx.cmd %TOOLS_INSTALL_DIR%\bin
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
	7z a -t7z  %ARCHIVE_OPT_PW% %TOOLS_INSTALL_DIR%\Tools-Settings@%USERDOMAIN%_%yyyy%%mm%%dd%.7z %TOOLS_INSTALL_DIR% -xr!*bin -xr!*.7z
	EXIT /B

	