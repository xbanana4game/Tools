@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
SET DRIVE_LETTER_FILE=%CD:~0,2%
SET DRIVE_LETTER_CMD=%~d0

REM ---------- nas_local-COPY.cmd(SettingsOptions.cmd) ----------
REM SET ROBOCOPY_LOG=
REM SET ROBOCOPY_LOG=%DESKTOP_DIR%\robocopy-%yyyy%%mm%%dd%%hh%%mn%%ss%.log
REM SET ROBOCOPY_LOG_OPTIONS=/log+:"%ROBOCOPY_LOG%" /v /fp /tee
REM SET COPY_FROM=%VIDEOS_DIR%
REM SET COPY_TO=%DRIVE_LETTER_CMD%\Store\Videos
REM SET COPY_TO=\\%NASDOMAIN%\Backups\Backups\%USERDOMAIN%
REM SET ROBOCOPY_COPY_OPTIONS=/e /r:3 /w:10
REM SET ROBOCOPY_COPY_OPTIONS=/z /e /r:3 /w:10
REM SET ROBOCOPY_COPY_OPTIONS=/mir /e /r:3 /w:10
REM SET ROBOCOPY_COPY_OPTIONS=/MOVE /e
REM SET TARGET_FILES=*.*
REM SET ROBOCOPY_EXTRA_OPTIONS=/L
REM SET ROBOCOPY_EXTRA_OPTIONS=/A+:R
REM SET ROBOCOPY_EXTRA_OPTIONS=/MAXAGE:1
REM SET ROBOCOPY_EXTRA_OPTIONS=/XD $RECYCLE.BIN "System Volume Information"


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
:SETTINGS
IF DEFINED ROBOCOPY_LOG SET ROBOCOPY_LOG_OPTIONS=/log+:"%ROBOCOPY_LOG%" /v /fp /tee
IF NOT DEFINED COPY_FROM (SET /P COPY_FROM="SET COPY_FROM=")
IF NOT DEFINED COPY_FROM (EXIT)
IF NOT DEFINED COPY_TO (SET /P COPY_TO="SET COPY_TO=")
IF NOT DEFINED COPY_TO (EXIT)
IF NOT DEFINED TARGET_FILES (SET TARGET_FILES=*.*)
IF NOT DEFINED ROBOCOPY_COPY_OPTIONS (SET ROBOCOPY_COPY_OPTIONS=/e /r:3 /w:10)
IF NOT EXIST %COPY_FROM% EXIT

:TEST
ECHO ==================================================================================
ROBOCOPY "%COPY_FROM%" "%COPY_TO%" %TARGET_FILES% /L %ROBOCOPY_EXTRA_OPTIONS% %ROBOCOPY_COPY_OPTIONS%
ECHO ==================================================================================
ECHO COPY_FROM: %COPY_FROM%
ECHO COPY_TO  : %COPY_TO%
ECHO OPTIONS  : %ROBOCOPY_COPY_OPTIONS%
ECHO EXTRA    : %ROBOCOPY_EXTRA_OPTIONS%
ECHO Press Enter...
PAUSE

:START
ROBOCOPY "%COPY_FROM%" "%COPY_TO%" %TARGET_FILES% %ROBOCOPY_EXTRA_OPTIONS% %ROBOCOPY_COPY_OPTIONS% %ROBOCOPY_LOG_OPTIONS%
IF %ERRORLEVEL% EQU 8 (
	NOTEPAD %ROBOCOPY_LOG%
)

:END
CHOICE /C YN /T 3 /D Y /M "Remove %ROBOCOPY_LOG%?"
IF %ERRORLEVEL% EQU 1 DEL %ROBOCOPY_LOG%
EXPLORER %COPY_TO%

EXIT
