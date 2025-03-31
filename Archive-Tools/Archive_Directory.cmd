@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM SETLOCAL ENABLEDELAYEDEXPANSION
SET DRIVE_LETTER_FILE=%CD:~0,2%
SET DRIVE_LETTER_CMD=%~d0
REM ---------- Archive Directory(SettingsOptions.cmd) ----------
REM SET SDEL_FLG=0
REM SET ARCHIVE_OUTPUT_DIR=%DOWNLOADS_DIR%
REM SET Z_PASSWORD=NONE
REM SET Z_PASSWORD=%DOWNLOADS_PASSWORD%
REM x=[0 | 1 | 3 | 5 | 7 | 9 ] 
REM SET OPT_COMPRESSION_LEVEL=0
REM SET VOLUME_SIZE=0
REM SET VOLUME_SIZE=1g
REM CALL :CheckDirectory %ARCHIVE_OUTPUT_DIR%


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED OPT_COMPRESSION_LEVEL (
	ECHO x=0 , 1 , 3 , 5 , 7 , 9  
	SET /P OPT_COMPRESSION_LEVEL="SET OPT_COMPRESSION_LEVEL(0)="
)
IF NOT DEFINED OPT_COMPRESSION_LEVEL (SET OPT_COMPRESSION_LEVEL=0)
IF NOT DEFINED Z_PASSWORD (SET /P Z_PASSWORD="SET Z_PASSWORD(NONE)=")
IF NOT DEFINED Z_PASSWORD (SET Z_PASSWORD=NONE)
IF NOT DEFINED ARCHIVE_OUTPUT_DIR (SET /P ARCHIVE_OUTPUT_DIR="SET ARCHIVE_OUTPUT_DIR(%DOWNLOADS_DIR%)=")
IF NOT DEFINED ARCHIVE_OUTPUT_DIR (SET ARCHIVE_OUTPUT_DIR=%DOWNLOADS_DIR%)
IF NOT DEFINED SDEL_FLG (SET /P SDEL_FLG="Enter SDEL_FLG 1/0(default:0): ")
IF "%SDEL_FLG%"=="1" (SET SDEL_OPT=-sdel)
IF NOT DEFINED VOLUME_SIZE (SET VOLUME_SIZE=0)
IF NOT %VOLUME_SIZE%==0 SET OPT_VOLUME=-v%VOLUME_SIZE%
IF NOT "%Z_PASSWORD%"=="NONE" SET ARCHIVE_OPT_PW=-p%Z_PASSWORD% -mhe

FOR %%i in (%*) DO (
	ECHO %%i
	REM VD_YYYYMMDD
	REM SET OUTPUT_FILENAME=%%~nxi@%yyyy%%mm%%dd%%hh%%mn%%ss%.7z
	REM 7z a -t7z %SDEL_OPT% %ARCHIVE_OPT_PW% "%ARCHIVE_OUTPUT_DIR%\!OUTPUT_FILENAME!.7z" "%%~i" -mx=%OPT_COMPRESSION_LEVEL% %OPT_VOLUME%
	7z a -t7z %SDEL_OPT% %ARCHIVE_OPT_PW% "%ARCHIVE_OUTPUT_DIR%\%%~nxi@%yyyy%%mm%%dd%%hh%%mn%%ss%.7z" "%%~i" -xr!.ts -mx=%OPT_COMPRESSION_LEVEL% %OPT_VOLUME%
	REM 7z a -t7z %SDEL_OPT% "%%~nxi.7z" ""%%i"" -mx=0
	IF EXIST "%ARCHIVE_OUTPUT_DIR%\%%~nxi@%yyyy%%mm%%dd%%hh%%mn%%ss%.7z.001" 7z l %ARCHIVE_OPT_PW% "%ARCHIVE_OUTPUT_DIR%\%%~nxi@%yyyy%%mm%%dd%%hh%%mn%%ss%.7z.001" >"%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%%hh%%mn%%ss%.7z.txt"
	IF EXIST "%ARCHIVE_OUTPUT_DIR%\%%~nxi@%yyyy%%mm%%dd%%hh%%mn%%ss%.7z" 7z l %ARCHIVE_OPT_PW% "%ARCHIVE_OUTPUT_DIR%\%%~nxi@%yyyy%%mm%%dd%%hh%%mn%%ss%.7z" >"%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%%hh%%mn%%ss%.7z.txt"
	TYPE "%DOWNLOADS_DIR%\%%~nxi@%yyyy%%mm%%dd%%hh%%mn%%ss%.7z.txt"
)
TIMEOUT 3
EXIT

