@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- nas_local-COPY.cmd(SettingsOptions.cmd) ----------
REM SET COPY_FROM=%DOCUMENTS_DIR%
REM SET COPY_TO=\\nas\Backups\Backups\%USERDOMAIN%
REM SET TARGET_FILES=*.*
REM SET ROBOCOPY_EXTRA_OPTIONS=/A+:R


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED ROBOCOPY_LOG SET ROBOCOPY_LOG=%DESKTOP_DIR%\robocopy-%yyyy%%mm%%dd%%hh%%mn%%ss%.log
IF NOT DEFINED COPY_FROM (SET /P COPY_FROM="SET COPY_FROM=")
IF NOT DEFINED COPY_FROM (EXIT)
IF NOT DEFINED COPY_TO (SET /P COPY_TO="SET COPY_TO(%DESKTOP_DIR%\Videos)=")
IF NOT DEFINED COPY_TO (SET COPY_TO=%DESKTOP_DIR%\Videos)
IF NOT DEFINED TARGET_FILES (SET TARGET_FILES=*.*)

REM SET ROBOCOPY_COPY_OPTIONS=/z /e /r:3 /w:10
SET ROBOCOPY_COPY_OPTIONS=/e /r:3 /w:10
SET ROBOCOPY_LOG_OPTIONS=/log+:"%ROBOCOPY_LOG%" /v /fp /np /tee
ROBOCOPY %COPY_FROM% %COPY_TO% %TARGET_FILES% %ROBOCOPY_EXTRA_OPTIONS% %ROBOCOPY_COPY_OPTIONS% %ROBOCOPY_LOG_OPTIONS%
IF %ERRORLEVEL% EQU 1 (
	EXPLORER %COPY_TO%
)
NOTEPAD %ROBOCOPY_LOG%
CHOICE /C YN /T 5 /D Y /M "Remove %ROBOCOPY_LOG%?"
IF %ERRORLEVEL% EQU 1 DEL %ROBOCOPY_LOG%

EXIT
