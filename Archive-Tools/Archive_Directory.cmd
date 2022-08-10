@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd

REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED ARCHIVE_OUTPUT_DIR (SET /P ARCHIVE_OUTPUT_DIR="SET ARCHIVE_OUTPUT_DIR(%DOWNLOADS_DIR%)=")
IF NOT DEFINED ARCHIVE_OUTPUT_DIR (SET ARCHIVE_OUTPUT_DIR=%DOWNLOADS_DIR%)

IF NOT "%DOWNLOADS_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%DOWNLOADS_PASSWORD% -mhe

FOR %%i in (%*) DO (
	ECHO %%i
	REM VD_YYYYMMDD
	7z a -t7z -sdel %ARCHIVE_OPT_PW% "%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z" ""%%i"" -xr!.ts -mx=5 -v1g
	REM 7z a -t7z -sdel "%%~nxi.7z" ""%%i"" -mx=0
	IF EXIST "%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z.001" 7z l %ARCHIVE_OPT_PW% "%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z.001" >"%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z.txt"
	IF EXIST "%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z" 7z l %ARCHIVE_OPT_PW% "%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z" >"%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z.txt"
	TYPE "%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z.txt"
)
REM PAUSE
EXIT

