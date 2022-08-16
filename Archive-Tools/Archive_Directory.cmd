@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Archive Directory(SettingsOptions) ----------
REM SET SDEL_FLG=0
REM SET ARCHIVE_OUTPUT_DIR=
REM SET Z_PASSWORD=%DOWNLOADS_PASSWORD%
REM CALL :CheckDirectory %OUTPUT_DIR%

REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED Z_PASSWORD (SET /P Z_PASSWORD="SET Z_PASSWORD(%DOWNLOADS_PASSWORD%)=")
IF NOT DEFINED Z_PASSWORD (SET Z_PASSWORD=%DOWNLOADS_PASSWORD%)

IF NOT DEFINED ARCHIVE_OUTPUT_DIR (SET /P ARCHIVE_OUTPUT_DIR="SET ARCHIVE_OUTPUT_DIR(%DOWNLOADS_DIR%)=")
IF NOT DEFINED ARCHIVE_OUTPUT_DIR (SET ARCHIVE_OUTPUT_DIR=%DOWNLOADS_DIR%)
IF NOT DEFINED SDEL_FLG (SET /P SDEL_FLG="Enter SDEL_FLG 1/0(default:0): ")
IF "%SDEL_FLG%"=="1" (SET SDEL_OPT=-sdel)

IF NOT "%Z_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%Z_PASSWORD% -mhe

FOR %%i in (%*) DO (
	ECHO %%i
	REM VD_YYYYMMDD
	7z a -t7z %SDEL_OPT% %ARCHIVE_OPT_PW% "%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z" ""%%i"" -xr!.ts -mx=5 -v1g
	REM 7z a -t7z %SDEL_OPT% "%%~nxi.7z" ""%%i"" -mx=0
	IF EXIST "%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z.001" 7z l %ARCHIVE_OPT_PW% "%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z.001" >"%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z.txt"
	IF EXIST "%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z" 7z l %ARCHIVE_OPT_PW% "%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z" >"%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z.txt"
	TYPE "%ARCHIVE_OUTPUT_DIR%\%%~nxi.7z.txt"
)
REM PAUSE
EXIT

