@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- ytdlp-format.cmd(SettingsOptions.cmd) ----------


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================

:CHECK_FORMAT
REM SET YTDLP_OPT=-v -F --list-subs
SET YTDLP_OPT=-v -F
SET /P DOWNLOAD_URL="URL: "
REM SET /P FORMAT_OPTION="FORMAT_OPTION: "
yt-dlp.exe %YTDLP_OPT% %FORMAT_OPTION% %DOWNLOAD_URL%
GOTO :CHECK_FORMAT


EXIT
