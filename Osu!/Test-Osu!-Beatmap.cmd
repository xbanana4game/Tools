@ECHO OFF
REM ----------------------------------------------------------------------
REM Import Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd


REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
CALL :CheckDirectory "%BEATMAP_DIR%"
SET BEATMAP_LIST_DIR=%OSU_DIR%\test\list
MD "%OSU_DIR%\test"
MD "%BEATMAP_LIST_DIR%"

FOR /D %%i IN ("%BEATMAP_DIR%\*") DO (
  CD /D "%%i"
  FOR %%j IN ("*rar") DO (
      ECHO "%%i\%%j"
      IF NOT EXIST "%BEATMAP_LIST_DIR%\%%j.txt" (
        7z t "%%i\%%j" >"%BEATMAP_LIST_DIR%\%%j.txt"
    )
  )
  FOR %%j IN ("*7z") DO (
      ECHO "%%i\%%j"
      IF NOT EXIST "%BEATMAP_LIST_DIR%\%%j.txt" (
        7z t "%%i\%%j" >"%BEATMAP_LIST_DIR%\%%j.txt"
    )
  )
)
TYPE "%BEATMAP_LIST_DIR%\*" >"%OSU_DIR%\test\Beatmap Pack.txt"

EXPLORER %OSU_DIR%\test
EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:CheckDirectory
	IF EXIST %1 (
		ECHO Directory %1 is Exist.
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0

