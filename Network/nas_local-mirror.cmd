@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- nas_local-mirror.cmd(SettingsOptions.cmd) ----------
REM SET MIRROR_SRC=\\nas\Multimedia\Videos
REM SET MIRROR_TRG=%DESKTOP_DIR%\Videos
REM SET TARGET_FILES=*.*
REM SET ROBOCOPY_EXTRA_OPTIONS=


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED ROBOCOPY_LOG SET ROBOCOPY_LOG=%DESKTOP_DIR%\robocopy-%yyyy%%mm%%dd%%hh%%mn%%ss%.log
IF NOT DEFINED MIRROR_SRC (SET /P MIRROR_SRC="SET MIRROR_SRC=")
IF NOT DEFINED MIRROR_SRC (EXIT)
IF NOT DEFINED MIRROR_TRG (SET /P MIRROR_TRG="SET MIRROR_TRG(%DESKTOP_DIR%\Videos)=")
IF NOT DEFINED MIRROR_TRG (SET MIRROR_TRG=%DESKTOP_DIR%\Videos)

SET ROBOCOPY_COPY_OPTIONS=/mir /z /e /r:3 /w:10
SET ROBOCOPY_LOG_OPTIONS=/log+:"%ROBOCOPY_LOG%" /v /fp /np /tee
echo ROBOCOPY %COPY_FROM% %COPY_TO% %TARGET_FILES% %ROBOCOPY_EXTRA_OPTIONS% %ROBOCOPY_COPY_OPTIONS% %ROBOCOPY_LOG_OPTIONS%
IF %ERRORLEVEL% EQU 1 (
	EXPLORER %MIRROR_TRG%
)
NOTEPAD %ROBOCOPY_LOG%
CHOICE /C YN /T 5 /D Y /M "Remove %ROBOCOPY_LOG%?"
IF %ERRORLEVEL% EQU 1 DEL %ROBOCOPY_LOG%

EXIT
