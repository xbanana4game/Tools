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

REM ---------- _yt-dlp_merge.cmd(SettingsOptions.cmd) ----------


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
REM SET MERGED_BATCH_NAME=ytdlp_%yyyy%%mm%%dd%-%hh%%mn%%ss%
SET MERGED_BATCH_NAME=ytdlp-%hh%%mn%%ss%
IF NOT DEFINED YTDLP_CONF_DIR SET YTDLP_CONF_DIR=%CONFIG_DIR%\yt-dlp
SET OUTPUT_CMD=%DESKTOP_DIR%\%MERGED_BATCH_NAME%.cmd

ECHO REM TIMEOUT /T 1 >%OUTPUT_CMD%
ECHO SET MERGED_BATCH_NAME=%MERGED_BATCH_NAME%>>%OUTPUT_CMD%
FOR %%i IN (%YTDLP_CONF_DIR%\__ytdlp_*.cmd) DO (
	ECHO REM ============================= %%~ni =============================>>%OUTPUT_CMD%
	TITLE %MERGED_BATCH_NAME% - %%~ni>>%OUTPUT_CMD%
	TYPE %%i >>%OUTPUT_CMD%
)
ECHO DEL %OUTPUT_CMD%>>%OUTPUT_CMD%
CHOICE /C YN /T 3 /D N /M "Edit %OUTPUT_CMD%?"
IF %ERRORLEVEL% EQU 1 (
	NOTEPAD %OUTPUT_CMD%
)
CALL %OUTPUT_CMD%
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================

