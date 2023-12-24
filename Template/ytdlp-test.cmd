@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- ytdlp-dl.cmd(SettingsOptions.cmd) ----------
REM SET YTDLP_UPDATE_OPT=-U
REM SET YTDLP_PROFILE=test


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED YTDLP_PROFILE (SET YTDLP_PROFILE=test)
REM yt-dlp.exe --help >yt-dlp.txt
REM yt-dlp.exe --version
IF NOT "%1"=="" (
	SET YTDLP_PROFILE_FILE=%~1
) ELSE (
	SET YTDLP_PROFILE_FILE=yt-dlp.%YTDLP_PROFILE%.conf
)
COPY %YTDLP_PROFILE_FILE% %VIDEOS_DIR%\yt-dlp.conf

REM IF NOT EXIST "%VIDEOS_DIR%\yt-dlp.conf" (COPY yt-dlp.%YTDLP_PROFILE%.conf %VIDEOS_DIR%\yt-dlp.conf)
REM NOTEPAD yt-dlp.conf
NOTEPAD %VIDEOS_DIR%\dlurl.txt
CD %VIDEOS_DIR%
yt-dlp.exe %YTDLP_UPDATE_OPT%
MOVE %VIDEOS_DIR%\dlurl.txt "%VIDEOS_DIR%\dlurl-%yyyy%%mm%%dd%_%hh%%mn%.txt"
REM pause

EXPLORER %VIDEOS_DIR%\yt-dlp

EXIT
