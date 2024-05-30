@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- ytdlp-dl.cmd(SettingsOptions.cmd) ----------
SET YTDLP_OPT=-v -F
REM SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED YTDLP_PROFILE (SET YTDLP_PROFILE=default)
IF NOT DEFINED VIDEO_OUTPUT_DIR SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp

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
REM FINDSTR "%DOWNLOAD_URL%" %VIDEOS_DIR%\dlurl.log
REM if %ERRORLEVEL% EQU 0 (
	REM ECHO Already downloaded.
	REM GOTO :DL_START
REM )
yt-dlp.exe %YTDLP_OPT% %FORMAT_OPTION% %DOWNLOAD_URL%
ECHO %DOWNLOAD_URL%>>%VIDEOS_DIR%\dlurl.log
GOTO :DL_START

EXIT
