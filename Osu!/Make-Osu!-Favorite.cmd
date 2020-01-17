@ECHO OFF
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM BEATMAP_FAVORITEディレクトリーチェック
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
REM CALL :CheckDirectory [ディレクトリー]
REM ----------------------------------------------------------------------
:CheckDirectory
IF EXIST %1 (
  ECHO フォルダ%1が存在
) ELSE (
  SET /P ERR=フォルダ%1が存在しません
  EXIT
)
EXIT /B 0

