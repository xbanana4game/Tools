@ECHO OFF
REM ======================================================================
REM
REM                                INSTALL
REM
REM ======================================================================
CALL :INSTALL_SETTINGS
CALL :INSTALL_SAKURA_MACRO
PAUSE
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
	EXPLORER %USERPROFILE%
	EXIT /B
	
:INSTALL_SAKURA_MACRO
	IF EXIST "C:\Program Files (x86)\sakura" (
		COPY Sakura\ppa.dll "C:\Program Files (x86)\sakura"
	)
	IF EXIST "%USERPROFILE%\AppData\Roaming\sakura" (
		COPY Osu!\*.mac %USERPROFILE%\AppData\Roaming\sakura\
		COPY Osu!\*.ppa %USERPROFILE%\AppData\Roaming\sakura\
		COPY Games\*.mac %USERPROFILE%\AppData\Roaming\sakura\
		EXPLORER %USERPROFILE%\AppData\Roaming\sakura\
	)
	EXIT /B
	
