@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- ytdlp-dl.cmd(SettingsOptions.cmd) ----------
REM SET YTDLP_UPDATE_OPT=-v -F
REM SET DLURL_HISTORY=%VIDEOS_DIR%\dlurl.log


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED YTDLP_PROFILE (SET YTDLP_PROFILE=default)
IF NOT DEFINED VIDEO_OUTPUT_DIR SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp
IF NOT DEFINED DLURL_HISTORY SET DLURL_HISTORY=%VIDEOS_DIR%\dlurl.log

:COPY_CONF
IF NOT "%1"=="" (
	SET YTDLP_PROFILE_FILE=%~1
	COPY %~1 %VIDEOS_DIR%\yt-dlp.conf
	NOTEPAD %VIDEOS_DIR%\yt-dlp.conf
) ELSE (
	SET YTDLP_PROFILE_FILE=yt-dlp.%YTDLP_PROFILE%.dlp
)
IF NOT EXIST %VIDEOS_DIR%\yt-dlp.conf (COPY %YTDLP_PROFILE_FILE% %VIDEOS_DIR%\yt-dlp.conf)
TYPE %VIDEOS_DIR%\yt-dlp.conf

:DL_START
CD %VIDEOS_DIR%
SET /P DOWNLOAD_URL="URL: "
FINDSTR /C:"%DOWNLOAD_URL%" %DLURL_HISTORY%
IF ERRORLEVEL 1 (
	ECHO Start DL
	ECHO %DOWNLOAD_URL%>>%DLURL_HISTORY%
	ECHO;>>%DLURL_HISTORY%
) ElSE (
	ECHO Skip DL
	ECHO Skip:%DOWNLOAD_URL%>>%DLURL_HISTORY%
	GOTO :DL_START
)

yt-dlp.exe %YTDLP_UPDATE_OPT% %DOWNLOAD_URL%
EXPLORER %VIDEO_OUTPUT_DIR%
GOTO :DL_START

EXIT
