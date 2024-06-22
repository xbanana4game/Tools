@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- ytdlp-dl.cmd(SettingsOptions.cmd) ----------
REM SET YTDLP_OPT=-v -F
REM SET FORMAT_OPTION=--write-info-json
REM SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED YTDLP_PROFILE (SET YTDLP_PROFILE=default)
IF NOT DEFINED VIDEO_OUTPUT_DIR SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp
IF NOT DEFINED YTDLP_OPT SET YTDLP_OPT=-v -F --list-subs

IF NOT "%1"=="" (
	SET YTDLP_PROFILE_FILE=%~1
	COPY %~1 %VIDEOS_DIR%\yt-dlp.conf
) ELSE (
	SET YTDLP_PROFILE_FILE=yt-dlp.%YTDLP_PROFILE%.conf
)
IF NOT EXIST %VIDEOS_DIR%\yt-dlp.conf (COPY %YTDLP_PROFILE_FILE% %VIDEOS_DIR%\yt-dlp.conf)
CD %VIDEOS_DIR%
NOTEPAD yt-dlp.conf
TYPE yt-dlp.conf

:DL_START
SET /P DOWNLOAD_URL="URL: "
REM SET /P FORMAT_OPTION="FORMAT_OPTION: "
yt-dlp.exe %YTDLP_OPT% %FORMAT_OPTION% %DOWNLOAD_URL%
GOTO :DL_START

EXIT
