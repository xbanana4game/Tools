@ECHO OFF
REM ----------------------------------------------------------------------
REM
REM ----------------------------------------------------------------------
IF NOT EXIST "%USERPROFILE%\Settings.cmd" (
	CALL :INSTALL_SETTINGS
	EXIT
)


REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd


REM ======================================================================
REM
REM                                INSTALL
REM
REM ======================================================================
ECHO INSTALL
ECHO   1:settings
ECHO   2:Sakura
ECHO   3:Archive-Tool
SET /P A="> "
IF 1 EQU %A% (CALL :INSTALL_SETTINGS)
IF 2 EQU %A% (CALL :INSTALL_SAKURA_MACRO)
IF 3 EQU %A% (CALL :INSTALL_ARCHIVE_TOOLS)
CALL :Msg Finished
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:INSTALL_SETTINGS
	COPY Settings.cmd.txt %USERPROFILE%\Settings.cmd
	IF EXIST "SettingsOptions.cmd.txt" (COPY SettingsOptions.cmd.txt %USERPROFILE%\SettingsOptions@%USERDOMAIN%.cmd)
	NOTEPAD %USERPROFILE%\SettingsOptions@%USERDOMAIN%.cmd
	IF EXIST "MoveFiles.cmd.txt" (COPY MoveFiles.cmd.txt %USERPROFILE%\MoveFiles@%USERDOMAIN%.cmd)
	NOTEPAD %USERPROFILE%\MoveFiles@%USERDOMAIN%.cmd
	EXPLORER %USERPROFILE%
	EXIT /B
	
:INSTALL_SAKURA_MACRO
	COPY Sakura\ppa.dll "C:\Program Files (x86)\sakura"
	IF EXIST "%USERPROFILE%\AppData\Roaming\sakura" (
		COPY Osu!\*.mac %USERPROFILE%\AppData\Roaming\sakura\
		COPY Osu!\*.ppa %USERPROFILE%\AppData\Roaming\sakura\
		COPY Games\*.mac %USERPROFILE%\AppData\Roaming\sakura\
		EXPLORER %USERPROFILE%\AppData\Roaming\sakura\
	)
	EXIT /B
	
:INSTALL_ARCHIVE_TOOLS
	SET /P INSTALL_DRIVE="DRIVE(A:, C:\disk1)-> "
	SET /P INSTALL_PROFILE="PROFILE-> "
	ECHO "%INSTALL_DRIVE%\%INSTALL_PROFILE%.archiveçÏê¨ÇµÇ‹Ç∑"
	
	IF NOT EXIST "%INSTALL_DRIVE%\%INSTALL_PROFILE%.archive" (COPY Archive-Tools\profile.archive %INSTALL_DRIVE%\%INSTALL_PROFILE%.archive)
	NOTEPAD %INSTALL_DRIVE%\%INSTALL_PROFILE%.archive

	IF NOT EXIST "%INSTALL_DRIVE%\SettingsOptions@%INSTALL_PROFILE%.cmd" (COPY Archive-Tools\SettingsOptions.cmd.txt %INSTALL_DRIVE%\SettingsOptions@%INSTALL_PROFILE%.cmd)
	NOTEPAD %INSTALL_DRIVE%\SettingsOptions@%INSTALL_PROFILE%.cmd
	
	REM COPY Archive-Tools\Archive-Tool.cmd %INSTALL_DRIVE%\Archive-Tool.cmd
	
	EXIT /B
	
:Msg
	SET MSG=%1
	SET /P END=%MSG%
	EXIT /B

