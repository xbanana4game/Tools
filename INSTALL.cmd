@ECHO OFF

SET TOOLS_INSTALL_DIR=%USERPROFILE%\.Tools
SET SAKURA_SETTINGS_DIR=%USERPROFILE%\AppData\Roaming\sakura
SET FILE_7Z_INSTALLER=7z1805-x64.exe
REM ======================================================================
REM
REM                                INSTALL
REM
REM ======================================================================
CALL :INSTALL_7Z
CALL :INSTALL_SETTINGS
CALL :INSTALL_SAKURA_MACRO
CALL :BACKUP_SETTINGS
PAUSE
EXPLORER %TOOLS_INSTALL_DIR%
COPY /Y %TOOLS_INSTALL_DIR%\Tools-Settings@%USERDOMAIN%_%yyyy%%mm%%dd%.7z %DOWNLOADS_DIR%
REM IF EXIST "%SAKURA_SETTINGS_DIR%" EXPLORER %SAKURA_SETTINGS_DIR%
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:INSTALL_7Z
	IF EXIST "C:\Program Files\7-Zip\7z.exe" EXIT /B
	IF EXIST "%FILE_7Z_INSTALLER%" (
		START %FILE_7Z_INSTALLER%
		PAUSE
	)
	EXIT /B

:INSTALL_SETTINGS
	MD %TOOLS_INSTALL_DIR%
	COPY /Y Settings.cmd.txt %USERPROFILE%\Settings.cmd
	ECHO SET TOOLS_DIR=%~dp0>>%USERPROFILE%\Settings.cmd
	
	COPY /Y Settings.cmd.txt %TOOLS_INSTALL_DIR%\Settings.cmd
	ECHO SET TOOLS_DIR=%~dp0>>%TOOLS_INSTALL_DIR%\Settings.cmd
	ECHO SET PATH=%%PATH%%;%~dp0Games>>%TOOLS_INSTALL_DIR%\Settings.cmd
	ECHO SET PATH=%%PATH%%;%~dp0File-Tools>>%TOOLS_INSTALL_DIR%\Settings.cmd
	ECHO SET PATH=%%PATH%%;%TOOLS_INSTALL_DIR%\bin>>%TOOLS_INSTALL_DIR%\Settings.cmd
	
	IF EXIST "SettingsOptions.cmd" (
		NOTEPAD SettingsOptions.cmd
		COPY /Y SettingsOptions.cmd %TOOLS_INSTALL_DIR%\SettingsOptions.cmd
	)
	IF EXIST "MoveFiles.cmd" (
		NOTEPAD MoveFiles.cmd
		COPY /Y MoveFiles.cmd %TOOLS_INSTALL_DIR%\MoveFiles.cmd
	)
	
	MD %TOOLS_INSTALL_DIR%\bin
	COPY /Y Archive-Tools\Archive-Tool.cmd %TOOLS_INSTALL_DIR%\bin
	COPY /Y Keepass-Tools\Archive-kdbx.cmd %TOOLS_INSTALL_DIR%\bin
	COPY /Y File-Tools\Archive-Extension.cmd %TOOLS_INSTALL_DIR%\bin
	
	COPY /Y Archive-Tools\Archive.cmd %USERPROFILE%\Desktop
	EXIT /B
	
:INSTALL_SAKURA_MACRO
	IF EXIST "C:\Program Files (x86)\sakura" (
		COPY /Y Sakura\ppa.dll "C:\Program Files (x86)\sakura"
	)
	IF EXIST "%SAKURA_SETTINGS_DIR%" (
		COPY /Y Osu!\*.mac %SAKURA_SETTINGS_DIR%\
		COPY /Y Osu!\*.ppa %SAKURA_SETTINGS_DIR%\
		COPY /Y Games\*.mac %SAKURA_SETTINGS_DIR%\
	)
	EXIT /B
	
:BACKUP_SETTINGS
	IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT /B)
	CALL %USERPROFILE%\Settings.cmd
	REM IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t7z  %ARCHIVE_OPT_PW% %TOOLS_INSTALL_DIR%\Tools-Settings@%USERDOMAIN%_%yyyy%%mm%%dd%.7z %TOOLS_INSTALL_DIR% -xr!*bin -xr!*.7z
	EXIT /B

	