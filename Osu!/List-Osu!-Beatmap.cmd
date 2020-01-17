@ECHO OFF
REM ----------------------------------------------------------------------
REM �ݒ�t�@�C���ǂݍ���
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd



REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
CALL :CheckDirectory "%BEATMAP_DIR%"
SET BEATMAP_LIST_DIR=%OSU_DIR%\Logs\list
MD "%BEATMAP_LIST_DIR%"

FOR /D %%i IN ("%BEATMAP_DIR%\*") DO (
  CD /D "%%i"
  FOR %%j IN ("*rar") DO (
      ECHO "%%i\%%j"
      IF NOT EXIST "%BEATMAP_LIST_DIR%\%%j.txt" (
        7z l "%%i\%%j" >"%BEATMAP_LIST_DIR%\%%j.txt"
    )
  )
  FOR %%j IN ("*7z") DO (
      ECHO "%%i\%%j"
      IF NOT EXIST "%BEATMAP_LIST_DIR%\%%j.txt" (
        7z l "%%i\%%j" >"%BEATMAP_LIST_DIR%\%%j.txt"
    )
  )
)
TYPE "%BEATMAP_LIST_DIR%\*" >"%OSU_DIR%\Logs\Beatmap Pack.txt"

EXPLORER %OSU_DIR%\Logs
EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:CheckDirectory
	IF EXIST %1 (
	ECHO �t�H���_%1������
	) ELSE (
		SET /P ERR=�t�H���_%1�����݂��܂���
		EXIT
	)
	EXIT /B 0
