@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
SETLOCAL ENABLEDELAYEDEXPANSION
SET DRIVE_LETTER_FILE=%CD:~0,2%
SET DRIVE_LETTER_CMD=%~d0

REM ---------- Template.cmd(SettingsOptions.cmd) ----------


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SET PATH=%PATH%;C:\Program Files (x86)\GnuWin32\bin
SET RESOLUTIONS=144 240 360 480 720 1080
SET INPUT_FILE=youtube_RESOLUTION_low.dlp
SET OUTPUT_DIR=dlp
IF NOT EXIST %OUTPUT_DIR% MD %OUTPUT_DIR%
FOR %%i IN (%RESOLUTIONS%) DO (
	sed s/RESOLUTION/%%i/g %INPUT_FILE%>%OUTPUT_DIR%\youtube_%%ip_low.dlp
	sed s/RESOLUTION/%%i/g %INPUT_FILE%>%OUTPUT_DIR%\youtube_%%ip_low.csv.dlp
)
TIMEOUT /T 1
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================



