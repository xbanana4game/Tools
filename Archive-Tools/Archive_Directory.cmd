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
IF NOT DEFINED OUTPUT_DIR (SET /P OUTPUT_DIR="SET OUTPUT_DIR(%DOWNLOADS_DIR%)=")
IF NOT DEFINED OUTPUT_DIR (SET OUTPUT_DIR=%DOWNLOADS_DIR%)

IF NOT "%DOWNLOADS_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%DOWNLOADS_PASSWORD% -mhe

FOR %%i in (%*) DO (
	ECHO %%i
	REM VD_YYYYMMDD
	7z a -t7z -sdel %ARCHIVE_OPT_PW% "%OUTPUT_DIR%\%%~nxi.7z" ""%%i"" -xr!.ts -mx=5 -v1g
	REM 7z a -t7z -sdel "%%~nxi.7z" ""%%i"" -mx=0
	IF EXIST "%OUTPUT_DIR%\%%~nxi.7z.001" 7z l %ARCHIVE_OPT_PW% "%OUTPUT_DIR%\%%~nxi.7z.001" >"%OUTPUT_DIR%\%%~nxi.7z.txt"
	IF EXIST "%OUTPUT_DIR%\%%~nxi.7z" 7z l %ARCHIVE_OPT_PW% "%OUTPUT_DIR%\%%~nxi.7z" >"%OUTPUT_DIR%\%%~nxi.7z.txt"
	TYPE "%OUTPUT_DIR%\%%~nxi.7z.txt"
)
PAUSE
EXIT

