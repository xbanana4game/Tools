@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Template.cmd(SettingsOptions.cmd) ----------


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
ECHO %VIDEO_OUTPUT_DIR%\youtube.com
Mp3tag.exe /fp:"%VIDEO_OUTPUT_DIR%\youtube.com"
ECHO %VIDEO_OUTPUT_DIR%\twitch.tv
Mp3tag.exe /fp:"%VIDEO_OUTPUT_DIR%\twitch.tv"
ECHO %JD2_DL%\Videos
Mp3tag.exe /fp:"%JD2_DL%\Videos"

