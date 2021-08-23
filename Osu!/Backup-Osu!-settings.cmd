@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED BACKUPS_DIR (SET /P BACKUPS_DIR="SET BACKUPS_DIR(C:\Backups)=")
IF NOT DEFINED BACKUPS_DIR (SET BACKUPS_DIR=C:\Backups)

SET OSU_LISTFILE=%USERPROFILE%\.Tools\osu!.list
ECHO %OSU_DIR%\osu!.*.cfg>%OSU_LISTFILE%
ECHO %OSU_DIR%\Settings>>%OSU_LISTFILE%
ECHO %OSU_DIR%\Skins>>%OSU_LISTFILE%
ECHO %OSU_DIR%\*.db>>%OSU_LISTFILE%
ECHO %OSU_DIR%\Exports>>%OSU_LISTFILE%

IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
CALL :FIND_BACKUPS
IF DEFINED BASE_ARCHIVE_FILE (
		CALL :UPDATE_7Z_FILE
	) ELSE (
		7z a -t7z %ARCHIVE_OPT_PW% %BACKUPS_DIR%\7z\Osu!-Config-%yyyy%%mm%%dd%@%USERDOMAIN%.7z @%OSU_LISTFILE%
		REM 7z a -tzip %BACKUPS_DIR%\7z\Osu!-Config-%yyyy%%mm%%dd%@%USERDOMAIN%.zip @%OSU_LISTFILE%
	)
DEL %OSU_LISTFILE%

PAUSE
EXPLORER %BACKUPS_DIR%\7z
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:FIND_BACKUPS
	SET CMD_FILE=%USERPROFILE%\.Tools\a.cmd
	FOR %%i IN ("%BACKUPS_DIR%\7z\Osu!-Config-*@%USERDOMAIN%.7z") DO (
		ECHO SET BASE_ARCHIVE_FILE=%%~ni>%CMD_FILE%
		ECHO SET BASE_ARCHIVE_PATH=%%~fi>>%CMD_FILE%
	)
	IF EXIST %CMD_FILE% (
		CALL %CMD_FILE%
		DEL %CMD_FILE%
	)
	EXIT /B
	
:UPDATE_7Z_FILE
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	IF NOT DEFINED BASE_ARCHIVE_FILE SET /P BASE_ARCHIVE_FILE="Base Archive File: "
	SET UPDATE_7Z_FILE=%BACKUPS_DIR%\7z\%BASE_ARCHIVE_FILE%_-_Update-%yyyy%%mm%%dd%.7z
	7z u %ARCHIVE_OPT_PW% %BASE_ARCHIVE_PATH% -u- -up0q3x2z0!%UPDATE_7Z_FILE% @%OSU_LISTFILE%
	7z l %ARCHIVE_OPT_PW% %UPDATE_7Z_FILE%
	EXIT /B
	