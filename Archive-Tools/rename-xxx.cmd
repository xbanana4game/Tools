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
Mp3tag.exe /fp:"%DOWNLOADS_DIR%\%RENAMER_PROFILE%"

EXIT /B

