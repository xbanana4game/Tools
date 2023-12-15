@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- ytdlp-test.cmd(SettingsOptions.cmd) ----------
REM SET YTDLP_UPDATE_OPT=-U


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
REM yt-dlp.exe --help >yt-dlp.txt
yt-dlp.exe --version
COPY yt-dlp.test.conf yt-dlp.conf
NOTEPAD yt-dlp.conf
NOTEPAD dlurl.txt
yt-dlp.exe %YTDLP_UPDATE_OPT%
pause

