@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- nas_local-mirror.cmd(SettingsOptions.cmd) ----------
REM SET ROBOCOPY_LOG=%DESKTOP_DIR%\robocopy-%yyyy%%mm%%dd%%hh%%mn%%ss%.log
REM SET MIRROR_SRC=\\nas\Multimedia\Videos
REM SET MIRROR_TRG=%DESKTOP_DIR%\Videos
REM SET TARGET_FILES=*.*


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

ROBOCOPY %MIRROR_SRC% %MIRROR_TRG% %TARGET_FILES% /mir /z /e /r:3 /w:10 /log:"%ROBOCOPY_LOG%" /v /fp /np /tee
IF %ERRORLEVEL% EQU 1 (
	EXPLORER %MIRROR_TRG%
)
NOTEPAD %ROBOCOPY_LOG%
CHOICE /C YN /T 5 /D Y /M "Remove %ROBOCOPY_LOG%?"
IF %ERRORLEVEL% EQU 1 DEL %ROBOCOPY_LOG%

EXIT
