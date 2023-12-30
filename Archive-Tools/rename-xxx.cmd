@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Template.cmd(SettingsOptions.cmd) ----------
REM SET RENAMER_MODE=rename
SET RENAMER_MODE=preset
SET RENAMER_PROFILE=xxx


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
ReNamer.exe /%RENAMER_MODE% "%RENAMER_PROFILE%" "%JD2_DL%\%RENAMER_PROFILE%"
REM START C:\PROGRA~2\foobar2000\foobar2000.exe
EXPLORER %VIDEOS_DIR%\%RENAMER_PROFILE%
"C:\Program Files (x86)\foobar2000\foobar2000.exe" %VIDEOS_DIR%\%RENAMER_PROFILE%
Mp3tag.exe /fp:"%VIDEOS_DIR%\%RENAMER_PROFILE%"
%TOOLS_DIR%\Archive-Tools\vlc-thumbsnail.cmd
EXIT /B

