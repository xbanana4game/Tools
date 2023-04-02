@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Archive Directory(SettingsOptions.cmd) ----------
REM SET SDEL_FLG=0
REM SET ARCHIVE_OUTPUT_DIR=
REM SET Z_PASSWORD=NONE
REM SET Z_PASSWORD=%DOWNLOADS_PASSWORD%
REM x=[0 | 1 | 3 | 5 ] 
REM SET OPT_COMPRESSION_LEVEL=0
REM SET VOLUME_SIZE=0
REM SET VOLUME_SIZE=1g
REM SET VOLUME_SIZE=23864m
REM CALL :CheckDirectory %ARCHIVE_OUTPUT_DIR%


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED OPT_COMPRESSION_LEVEL (SET /P OPT_COMPRESSION_LEVEL="SET OPT_COMPRESSION_LEVEL(0)=")
IF NOT DEFINED OPT_COMPRESSION_LEVEL (SET OPT_COMPRESSION_LEVEL=0)
IF NOT DEFINED Z_PASSWORD (SET /P Z_PASSWORD="SET Z_PASSWORD(NONE)=")
IF NOT DEFINED Z_PASSWORD (SET Z_PASSWORD=NONE)

IF NOT DEFINED ARCHIVE_OUTPUT_DIR (SET /P ARCHIVE_OUTPUT_DIR="SET ARCHIVE_OUTPUT_DIR(%DOWNLOADS_DIR%)=")
IF NOT DEFINED ARCHIVE_OUTPUT_DIR (SET ARCHIVE_OUTPUT_DIR=%DOWNLOADS_DIR%)
IF NOT DEFINED SDEL_FLG (SET /P SDEL_FLG="Enter SDEL_FLG 1/0(default:0): ")
IF "%SDEL_FLG%"=="1" (SET SDEL_OPT=-dr)
IF NOT DEFINED VOLUME_SIZE (SET VOLUME_SIZE=0)
IF NOT %VOLUME_SIZE%==0 SET OPT_VOLUME=-v%VOLUME_SIZE%

IF NOT "%Z_PASSWORD%"=="NONE" SET ARCHIVE_OPT_PW=-hp%Z_PASSWORD% -mhe

FOR %%i in (%*) DO (
	ECHO %%i
	REM VD_YYYYMMDD
	winrar a %SDEL_OPT% %ARCHIVE_OPT_PW% -rr3p -rv1 %OPT_VOLUME% -m%OPT_COMPRESSION_LEVEL% "%ARCHIVE_OUTPUT_DIR%\%%~nxi.rar" "%%i"
	REM -ilogwinrar-%yyyy%%mm%%dd%%hh%%mn%%ss%.log 
)
PAUSE
EXIT

