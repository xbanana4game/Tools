@ECHO OFF
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM Beatmap �f�B���N�g���[�`�F�b�N
REM ----------------------------------------------------------------------
ECHO %BEATMAP_DIR%
IF EXIST "%BEATMAP_DIR%" (
  CD /D "%BEATMAP_DIR%"
) ELSE (
  SET /P ERROR=�t�H���_%BEATMAP_DIR%�����݂��܂���
  EXIT
)


REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
EXPLORER "%OSU_DIR%\Logs"
"%OSU_DIR%\Logs\listfile.txt"
SET /P CMD_EXECUTE="Songs�ɒǉ����܂���? 1/0 -> "

IF 1 EQU %CMD_EXECUTE% (
  FOR /D %%i IN ("%BEATMAP_DIR%\*") DO (
    CD /D "%%i"
    FOR %%j IN ("*rar") DO (
      7z e "%%i\%%j" -o%OSU_SONGS_DIR%  -i@"%OSU_DIR%\Logs\listfile.txt" -aoa
    )
    FOR %%j IN ("*7z") DO (
      7z e "%%i\%%j" -o%OSU_SONGS_DIR%  -i@"%OSU_DIR%\Logs\listfile.txt" -aoa
    )
  )
  EXPLORER %OSU_SONGS_DIR%
)


