@ECHO OFF
IF NOT EXIST "%USERPROFILE%\Settings.cmd" (
	CALL :INSTALL_A
	EXIT
)
ECHO INSTALL
ECHO   1:settings
ECHO   2:Sakura
ECHO   3:Archive-Tool
ECHO   4:GPG
SET /P A="> "
IF 1 EQU %A% (CALL :INSTALL_A)
IF 2 EQU %A% (CALL :INSTALL_B)
IF 3 EQU %A% (CALL :INSTALL_C)
IF 4 EQU %A% (CALL :INSTALL_D)
EXIT


:INSTALL_A
	COPY Settings.cmd.txt %USERPROFILE%\Settings.cmd
	IF EXIST "SettingsOptions.cmd.txt" (COPY SettingsOptions.cmd.txt %USERPROFILE%\SettingsOptions@%USERDOMAIN%.cmd)
	NOTEPAD %USERPROFILE%\SettingsOptions@%USERDOMAIN%.cmd
	IF EXIST "MoveFiles.cmd.txt" (COPY MoveFiles.cmd.txt %USERPROFILE%\MoveFiles@%USERDOMAIN%.cmd)
	NOTEPAD %USERPROFILE%\MoveFiles@%USERDOMAIN%.cmd
	EXPLORER %USERPROFILE%
	EXIT /B

:INSTALL_B
	IF EXIST "%USERPROFILE%\AppData\Roaming\sakura" (
		COPY Osu!\*.mac %USERPROFILE%\AppData\Roaming\sakura\
		COPY Osu!\*.ppa %USERPROFILE%\AppData\Roaming\sakura\
		COPY Games\*.mac %USERPROFILE%\AppData\Roaming\sakura\
		EXPLORER %USERPROFILE%\AppData\Roaming\sakura\
	)
	EXIT /B

:INSTALL_C
	SET /P INSTALL_DRIVE="DRIVE(A:, C:\disk1)-> "
	SET /P INSTALL_PROFILE="PROFILE-> "
	SET /P A="%INSTALL_DRIVE%:\%INSTALL_PROFILE%.dirçÏê¨ÇµÇ‹Ç∑"
	COPY profile.dir %INSTALL_DRIVE%\%INSTALL_PROFILE%.dir
	NOTEPAD %INSTALL_DRIVE%\%INSTALL_PROFILE%.dir
	COPY Archive-Tool.cmd %INSTALL_DRIVE%\Archive-Tool.cmd
	EXIT /B
	
:INSTALL_D
	gpg --import GPG\TVAIO.asc
	EXIT /B

