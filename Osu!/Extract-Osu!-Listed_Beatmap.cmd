@ECHO OFF
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM Beatmap ディレクトリーチェック
REM ----------------------------------------------------------------------
ECHO %BEATMAP_DIR%
IF EXIST "%BEATMAP_DIR%" (
  CD /D "%BEATMAP_DIR%"
) ELSE (
  SET /P ERROR=フォルダ%BEATMAP_DIR%が存在しません
  EXIT
)


REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
EXPLORER "%OSU_DIR%\Logs"
"%OSU_DIR%\Logs\listfile.txt"
SET /P CMD_EXECUTE="Songsに追加しますか? 1/0 -> "

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


