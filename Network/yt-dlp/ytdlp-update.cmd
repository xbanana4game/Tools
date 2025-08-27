@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
where yt-dlp.exe
yt-dlp.exe -vU
REM yt-dlp.exe --update-to master
PAUSE

EXIT

