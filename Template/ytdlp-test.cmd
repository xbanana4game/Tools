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
REM yt-dlp.exe --version
COPY yt-dlp.test.conf %VIDEOS_DIR%\yt-dlp.conf
REM NOTEPAD yt-dlp.conf
NOTEPAD %VIDEOS_DIR%\dlurl.txt
CD %VIDEOS_DIR%
yt-dlp.exe %YTDLP_UPDATE_OPT%
MOVE %VIDEOS_DIR%\dlurl.txt "%VIDEOS_DIR%\dlurl-%yyyy%%mm%%dd%_%hh%%mn%.txt"
REM pause

