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
SET BATCH_PREFIX=__ytdlp
IF NOT DEFINED YTDLP_CONF_DIR SET YTDLP_CONF_DIR=%CONFIG_DIR%\yt-dlp
SET OUTPUT_CMD=%DESKTOP_DIR%\%MERGED_BATCH_NAME%.cmd

ECHO REM TIMEOUT /T 1 >%OUTPUT_CMD%

DIR /B %YTDLP_CONF_DIR%\*.cmd
ECHO %BATCH_PREFIX%_????????_[DOMAIN].cmd
CHOICE /C YN /T 3 /D N /M "INPUT DOMAIN? Y/N"
IF %ERRORLEVEL% EQU 1 (
	SET /P DOMAIN="DOMAIN: "
)
IF NOT DEFINED DOMAIN (
	SET SEARCH_BATCH_FILE_EXP=%BATCH_PREFIX%_*.cmd
) ELSE (
	SET SEARCH_BATCH_FILE_EXP=%BATCH_PREFIX%_????????_%DOMAIN%*.cmd
)

ECHO SET MERGED_BATCH_NAME=%MERGED_BATCH_NAME%_%DOMAIN%>>%OUTPUT_CMD%
ECHO REM SET YTDLP_BATCH_OPT=--verbose>>%OUTPUT_CMD%
ECHO;>>%OUTPUT_CMD%
DIR /B %YTDLP_CONF_DIR%\%SEARCH_BATCH_FILE_EXP%
FOR %%i IN (%YTDLP_CONF_DIR%\%SEARCH_BATCH_FILE_EXP%) DO (
	ECHO REM ============================= %%~ni =============================>>%OUTPUT_CMD%
	ECHO TITLE %MERGED_BATCH_NAME% - %%~ni>>%OUTPUT_CMD%
	TYPE %%i >>%OUTPUT_CMD%
)
ECHO DEL %OUTPUT_CMD%>>%OUTPUT_CMD%
CHOICE /C YN /T 3 /D N /M "Edit %OUTPUT_CMD%?"
IF %ERRORLEVEL% EQU 1 (
	NOTEPAD %OUTPUT_CMD%
)
CALL :UPDATE_YTDLP
CALL %OUTPUT_CMD%
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:UPDATE_YTDLP
	IF EXIST %DESKTOP_DIR%\*.lock EXIT /B
	yt-dlp.exe -U
	IF ERRORLEVEL 1 (
		ECHO Update Failed.
		PAUSE
	)
	EXIT /B

