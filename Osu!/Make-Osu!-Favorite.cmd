@ECHO OFF
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM BEATMAP_FAVORITEディレクトリーチェック
REM ----------------------------------------------------------------------
CALL :CheckDirectory "%BEATMAP_FAVORITE%"

REM ----------------------------------------------------------------------
REM Archive
REM ----------------------------------------------------------------------
FOR /D %%i IN ("%BEATMAP_FAVORITE%\*") DO (
  7z a -t7z -sdel "%BEATMAP_FAVORITE%\%%~ni.7z" "%%i\*.osz" -mx0
)
EXPLORER "%BEATMAP_FAVORITE%"

EXIT

REM ----------------------------------------------------------------------
REM CALL :CheckDirectory [ディレクトリー]
REM ----------------------------------------------------------------------
:CheckDirectory
	IF EXIST %1 (
		ECHO Directory %1 is Exist.
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0

