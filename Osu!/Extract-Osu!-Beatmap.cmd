@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SET LOGNAME=%OSU_SONGS_DIR%\.log\ExtractBeatmap.log
IF NOT EXIST %OSU_SONGS_DIR%\.log MD %OSU_SONGS_DIR%\.log
IF NOT DEFINED BEATMAP_SRC_DIR SET /P BEATMAP_SRC_DIR="SET BEATMAP_SRC_DIR=(default:%DOWNLOADS_DIR%\Games\Osu!\Beatmap_Pack) ->"
IF "%BEATMAP_SRC_DIR%"=="" SET BEATMAP_SRC_DIR=%DOWNLOADS_DIR%\Games\Osu!\Beatmap_Pack

FOR %%i in (%*) DO (
	SET BEATMAP_SRC_DIR=%%i
)

CALL :CheckDirectory "%BEATMAP_SRC_DIR%"
IF %ERRORLEVEL% EQU 1 (
	ECHO Directory not Exist. %BEATMAP_SRC_DIR%
) ELSE (
	CALL :IMPORT_FROM_BEATMAPS_DIRECTORY 7z
	CALL :IMPORT_FROM_BEATMAPS_DIRECTORY zip
	CALL :IMPORT_FROM_BEATMAPS_DIRECTORY rar
	CALL :EXEC_UPDATE_OSU_DB
)
TIMEOUT /T 3
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:IMPORT_FROM_BEATMAPS_DIRECTORY
	SET BEATMAP_EXT=%1
	ECHO FIND *.%BEATMAP_EXT% IN %BEATMAP_SRC_DIR%
	FOR /R "%BEATMAP_SRC_DIR%" %%i in ("*.%BEATMAP_EXT%")  DO (
		IF EXIST %OSU_SONGS_DIR%\.log\%%~nxi.txt (
			ECHO %%~nxi is already imported.
		) ELSE (
	 		7z e "%%i" -o%OSU_SONGS_DIR% -aoa
	 		ECHO %yyyy%/%mm%/%dd%:%%~nxi>>%LOGNAME%
			7z l "%%i">>%OSU_SONGS_DIR%\.log\%%~nxi.txt
		)
	)
	EXIT /B

:CheckDirectory
	IF EXIST %1 (
		ECHO Directory %1 is Exist.
	) ELSE (
		ECHO Directory %1 is not Exist.
		EXIT /B 1
	)
	EXIT /B 0

:EXEC_UPDATE_OSU_DB
	WHERE update_osu_db.py
	IF %ERRORLEVEL% EQU 0 (
		IF EXIST %BEATMAP_SRC_DIR% update_osu_db.py %BEATMAP_SRC_DIR%
	)
	EXIT /B
