@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Archive Directory(SettingsOptions.cmd) ----------
SET DRIVE_LETTER=%~d0
REM SET SDEL_FLG=0
REM SET ARCHIVE_OUTPUT_DIR=%DRIVE_LETTER%\rar
REM SET ARCHIVE_OUTPUT_DIR=%DESKTOP_DIR%\rar
REM SET Z_PASSWORD=NONE
REM SET Z_PASSWORD=%DOWNLOADS_PASSWORD%
REM x=[0 | 1 | 3 | 5 ] 
REM SET OPT_COMPRESSION_LEVEL=0
REM SET VOLUME_SIZE=0
REM SET VOLUME_SIZE=1g
REM SET VOLUME_SIZE=23864m
REM SET RECOVERY_VOLUME_NUMBER=1
REM SET WINRAR_LOG=winrar-%yyyy%%mm%%dd%%hh%%mn%%ss%.log

REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED OPT_COMPRESSION_LEVEL (SET /P OPT_COMPRESSION_LEVEL="SET OPT_COMPRESSION_LEVEL(0)=")
IF NOT DEFINED OPT_COMPRESSION_LEVEL (SET OPT_COMPRESSION_LEVEL=0)
IF NOT DEFINED Z_PASSWORD (SET /P Z_PASSWORD="SET Z_PASSWORD(NONE)=")
IF NOT DEFINED Z_PASSWORD (SET Z_PASSWORD=NONE)

IF NOT DEFINED ARCHIVE_OUTPUT_DIR (SET /P ARCHIVE_OUTPUT_DIR="SET ARCHIVE_OUTPUT_DIR(%DRIVE_LETTER%\rar)=")
IF NOT DEFINED ARCHIVE_OUTPUT_DIR (SET ARCHIVE_OUTPUT_DIR=%DRIVE_LETTER%\rar)
IF NOT DEFINED SDEL_FLG (SET /P SDEL_FLG="Enter SDEL_FLG 1/0(Not Delete): ")
IF "%SDEL_FLG%"=="1" (SET SDEL_OPT=-dr)
IF NOT DEFINED VOLUME_SIZE (SET VOLUME_SIZE=0)
IF NOT %VOLUME_SIZE%==0 SET OPT_VOLUME=-v%VOLUME_SIZE%
IF NOT DEFINED RECOVERY_VOLUME_NUMBER SET RECOVERY_VOLUME_NUMBER=1
IF NOT %RECOVERY_VOLUME_NUMBER%==0 SET RECOVERY_VOLUME_OPTIONS=-rv%RECOVERY_VOLUME_NUMBER%
REM IF NOT DEFINED WINRAR_LOG SET WINRAR_LOG=winrar-%yyyy%%mm%%dd%%hh%%mn%%ss%.log
IF DEFINED WINRAR_LOG SET WINRAR_LOG_OPTIONS=-ilog%WINRAR_LOG% 

IF NOT "%Z_PASSWORD%"=="NONE" SET ARCHIVE_OPT_PW=-hp%Z_PASSWORD%

MD %ARCHIVE_OUTPUT_DIR%
FOR %%i in (%*) DO (
	ECHO %%i
	winrar a %SDEL_OPT% %ARCHIVE_OPT_PW% -rr3p %RECOVERY_VOLUME_OPTIONS% %OPT_VOLUME% %WINRAR_LOG_OPTIONS% -m%OPT_COMPRESSION_LEVEL% "%ARCHIVE_OUTPUT_DIR%\%%~nxi.rar" "%%i"
)
PAUSE
EXIT

