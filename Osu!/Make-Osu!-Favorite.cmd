@ECHO OFF
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM BEATMAP_FAVORITE�f�B���N�g���[�`�F�b�N
REM ----------------------------------------------------------------------
CALL :CheckDirectory "%BEATMAP_FAVORITE%"
CALL :CheckDirectory "%BEATMAP_DIR%"

REM ----------------------------------------------------------------------
REM Archive
REM ----------------------------------------------------------------------
FOR /D %%i IN ("%BEATMAP_FAVORITE%\*") DO (
  7z a -t7z -sdel "%BEATMAP_DIR%\%%~ni.7z" "%%i\*.osz" -mx0
)
EXPLORER "%BEATMAP_DIR%"

EXIT

REM ----------------------------------------------------------------------
REM CALL :CheckDirectory [�f�B���N�g���[]
REM ----------------------------------------------------------------------
:CheckDirectory
IF EXIST %1 (
  ECHO �t�H���_%1������
) ELSE (
  SET /P ERR=�t�H���_%1�����݂��܂���
  EXIT
)
EXIT /B 0

