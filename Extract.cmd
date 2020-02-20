@ECHO OFF
REM ----------------------------------------------------------------------
REM 設定ファイル読み込み
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF "%1"=="" (
	SET /P YYYYMM="YYYYMMを指定してください default:%yyyy%%mm%->"
)
IF "%YYYYMM%"=="" SET YYYYMM=%yyyy%%mm%

REM ----------------------------------------------------------------------
REM リスト作成
REM ----------------------------------------------------------------------
SET LIST_TXT=%ARCHIVE_DIR%\%YYYYMM%_%USERDOMAIN%.txt
DEL %LIST_TXT%
IF "%1"=="" (
	FOR %%i IN ("%ARCHIVE_DIR%\%YYYYMM%\*.7z") DO 7z l -p%ARCHIVE_PASSWORD% %%i >>%LIST_TXT%
) ELSE (
	FOR %%i in (%*) DO 7z l -p%ARCHIVE_PASSWORD% %%i >>%LIST_TXT%
)
NOTEPAD %LIST_TXT%
TYPE %LIST_TXT%
DEL %LIST_TXT%

REM ----------------------------------------------------------------------
REM 展開
REM ----------------------------------------------------------------------
SET /P EXTRACT_EXT="展開する対象を指定してください(Default:*) -> "
IF "%EXTRACT_EXT%"=="" SET EXTRACT_EXT=*

IF "%1"=="" (
	FOR %%i IN ("%ARCHIVE_DIR%\%YYYYMM%\*.7z") DO CALL :Extract7z %%i %EXTRACT_EXT%
) ELSE (
	FOR %%i in (%*) DO (CALL :Extract7z %%i %EXTRACT_EXT%)
)
EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM 展開 CALL :Extract7z [TARGET] [EXT]
REM ----------------------------------------------------------------------
:Extract7z
	SET EXTRACT_FILE=%1
	SET EXTRACT_EXT=%2
	SET OUTPUT_DIR=%USERPROFILE%\Desktop
	7z x -p%ARCHIVE_PASSWORD% %EXTRACT_FILE% -o%OUTPUT_DIR%\* %EXTRACT_EXT% -r
	EXIT /B


