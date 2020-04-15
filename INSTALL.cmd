@ECHO OFF
IF NOT EXIST "%USERPROFILE%\Settings.cmd" (
	CALL :INSTALL_A
	EXIT
)
ECHO INSTALL
ECHO   1:settings.cmd
ECHO   2:Sakura
ECHO   3:Make-Dir.cmd
ECHO   4:GPG
SET /P A="> "
IF 1 EQU %A% (CALL :INSTALL_A)
IF 2 EQU %A% (CALL :INSTALL_B)
IF 3 EQU %A% (CALL :INSTALL_C)
IF 4 EQU %A% (CALL :INSTALL_D)
EXIT


:INSTALL_A
	COPY Settings.cmd.txt %USERPROFILE%\Settings.cmd
	NOTEPAD %USERPROFILE%\Settings.cmd
	NOTEPAD %USERPROFILE%\SettingsOptions@%USERDOMAIN%.cmd
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
	SET /P INSTALL_DRIVE="DRIVE(a..z)-> "
	SET /P INSTALL_PROFILE="PROFILE-> "
	SET /P A="%INSTALL_DRIVE%:\%INSTALL_PROFILE%.dirçÏê¨ÇµÇ‹Ç∑"
	COPY profile.dir %INSTALL_DRIVE%:\%INSTALL_PROFILE%.dir
	NOTEPAD %INSTALL_DRIVE%:\%INSTALL_PROFILE%.dir
	COPY Make-Dir.cmd %INSTALL_DRIVE%:\Make-Dir.cmd
	EXIT /B
	
:INSTALL_D
	gpg --import GPG\TVAIO.asc
	EXIT /B

