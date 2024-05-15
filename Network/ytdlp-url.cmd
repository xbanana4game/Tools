@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- ytdlp-dl.cmd(SettingsOptions.cmd) ----------
REM SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp
REM SET YTDLP_CONFIG_FILE=%VIDEOS_DIR%\yt-dlp.conf
REM SET YTDLP_CONFIG_FILE=%CLOUD_DRIVE%\Cloud-Tools\yt-dlp\yt-dlp.conf
REM SET DLURL_HISTORY_DIR=%VIDEOS_DIR%
REM SET DLURL_HISTORY_DIR=%CLOUD_DRIVE%\Cloud-Tools\yt-dlp


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF DEFINED YTDLP_CONFIG_FILE (SET YTDLP_CONF_OPT=--config-location %YTDLP_CONFIG_FILE%)

IF NOT DEFINED YTDLP_CONFIG_FILE SET YTDLP_CONFIG_FILE=%VIDEOS_DIR%\yt-dlp.conf
IF NOT DEFINED YTDLP_PROFILE (SET YTDLP_PROFILE=default)
IF NOT DEFINED VIDEO_OUTPUT_DIR SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp
IF NOT DEFINED DLURL_HISTORY_DIR SET DLURL_HISTORY_DIR=%VIDEOS_DIR%

:COPY_CONF
IF NOT "%1"=="" (
	SET YTDLP_PROFILE_FILE=%~1
	COPY %~1 %YTDLP_CONFIG_FILE%
	NOTEPAD %YTDLP_CONFIG_FILE%
) ELSE (
	SET YTDLP_PROFILE_FILE=yt-dlp.%YTDLP_PROFILE%.dlp
)
IF NOT EXIST %YTDLP_CONFIG_FILE% (COPY %YTDLP_PROFILE_FILE% %YTDLP_CONFIG_FILE%)
TYPE %YTDLP_CONFIG_FILE%

:DL_START
CD %VIDEOS_DIR%
SET /P DOWNLOAD_URL="URL: "
FINDSTR /C:"%DOWNLOAD_URL%" %DLURL_HISTORY_DIR%\*.log
IF ERRORLEVEL 1 (
	ECHO Start DL
	ECHO %DOWNLOAD_URL%>>%DLURL_HISTORY_DIR%\history.log
) ElSE (
	ECHO Skip DL
	ECHO Skip:%DOWNLOAD_URL%>>%DLURL_HISTORY_DIR%\history.log
	GOTO :DL_START
)

yt-dlp.exe %YTDLP_UPDATE_OPT% %YTDLP_CONF_OPT% %DOWNLOAD_URL%
EXPLORER %VIDEO_OUTPUT_DIR%
GOTO :DL_START

EXIT
