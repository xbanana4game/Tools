@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SET LOGNAME=%OSU_SONGS_DIR%\log\ExtractBeatmap.log
IF NOT EXIST %OSU_SONGS_DIR%\log MD %OSU_SONGS_DIR%\log
IF NOT DEFINED BEATMAP_SRC_DIR SET /P BEATMAP_SRC_DIR="BEATMAP_SRC_DIR(default %BEATMAP_DIR%\Beatmap_Pack-%yyyy%) -> "
IF "%BEATMAP_SRC_DIR%"=="" SET BEATMAP_SRC_DIR=%BEATMAP_DIR%\Beatmap_Pack-%yyyy%

FOR %%i in (%*) DO (
	7z e %%i -o%OSU_SONGS_DIR% -aoa
	ECHO %yyyy%/%mm%/%dd%:%%~nxi>>%LOGNAME%
	7z l "%%i">>%OSU_SONGS_DIR%\log\%%~nxi.txt
)

CALL :CheckDirectory "%BEATMAP_SRC_DIR%"
IF %ERRORLEVEL% EQU 1 (
	ECHO Directory not Exist. %BEATMAP_SRC_DIR%
) ELSE (
	CALL :IMPORT_FROM_BEATMAPS_DIRECTORY
)

PAUSE
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:IMPORT_FROM_BEATMAPS_DIRECTORY
	FOR %%i in ("%BEATMAP_SRC_DIR%\*Beatmap Pack*.7z")  DO (
		IF EXIST %OSU_SONGS_DIR%\log\%%~nxi.txt (
			ECHO %%~nxi is already imported.
		) ELSE (
	 		7z e "%%i" -o%OSU_SONGS_DIR% -aoa
	 		ECHO %yyyy%/%mm%/%dd%:%%~nxi>>%LOGNAME%
			7z l "%%i">>%OSU_SONGS_DIR%\log\%%~nxi.txt
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
