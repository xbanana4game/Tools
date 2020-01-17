@ECHO OFF
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM Archive
REM ----------------------------------------------------------------------
SET GAME_NAME=KillingFloor
SET INI_DIR=%KILLINGFLOOR_DIR%\System
CALL :CheckDirectory "%INI_DIR%"
7z a -tzip %DOWNLOADS_DIR%\%GAME_NAME%-ini-%yyyy%%mm%%dd%@%USERNAME%.zip %INI_DIR%\KillingFloor.ini %INI_DIR%\User.ini %INI_DIR%\ServerPerksClient.ini
EXPLORER %DOWNLOADS_DIR%
EXIT


:CheckDirectory
	IF EXIST %1 (
	ECHO �t�H���_%1������
	) ELSE (
		SET /P ERR=�t�H���_%1�����݂��܂���
		EXIT
	)
	EXIT /B 0


