@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- ytdlp-dl.cmd(SettingsOptions.cmd) ----------
SET YTDLP_UPDATE_OPT=-v -F


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED YTDLP_PROFILE (SET YTDLP_PROFILE=default)

IF NOT "%1"=="" (
	SET YTDLP_PROFILE_FILE=%~1
	COPY %~1 %VIDEOS_DIR%\yt-dlp.conf
) ELSE (
	SET YTDLP_PROFILE_FILE=yt-dlp.%YTDLP_PROFILE%.conf
)
IF NOT EXIST %VIDEOS_DIR%\yt-dlp.conf (COPY %YTDLP_PROFILE_FILE% %VIDEOS_DIR%\yt-dlp.conf)
CD %VIDEOS_DIR%

:DL_START
SET /P DOWNLOAD_URL="URL: "
yt-dlp.exe %YTDLP_UPDATE_OPT% %DOWNLOAD_URL%
GOTO :DL_START

EXIT
