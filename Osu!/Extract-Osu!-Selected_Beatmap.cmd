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
"%OSU_DIR%\Logs\Beatmap Pack.txt"


REM ----------------------------------------------------------------------
REM *%ARTIST%*-*%TITLE%*.osz
REM ----------------------------------------------------------------------
SET /P ARTIST="ARTIST --->"
SET /P TITLE="TITLE --->"
SET /P CMD_EXECUTE="Songsに追加(*%ARTIST%*-*%TITLE%*.osz)しますか? 1/0 -> "

IF 1 EQU %CMD_EXECUTE% (
  FOR /D %%i IN ("%BEATMAP_DIR%\*") DO (
    CD /D "%%i"
    FOR %%j IN ("*rar") DO (
      7z e "%%i\%%j" -o%OSU_SONGS_DIR% *%ARTIST%*-*%TITLE%*.osz
    )
    FOR %%j IN ("*7z") DO (
      7z e "%%i\%%j" -o%OSU_SONGS_DIR% *%ARTIST%*-*%TITLE%*.osz
    )
  )
  EXPLORER %OSU_SONGS_DIR%
)


