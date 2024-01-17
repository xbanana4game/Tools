@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- extract-mp3tag-settings.cmd(SettingsOptions.cmd) ----------
REM SET SETTINGS_FILE=%USERPROFILE%\Documents\Mp3tagSettings.zip


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED SETTINGS_FILE SET SETTINGS_FILE=Mp3tagSettings.zip

7z x %SETTINGS_FILE% -o%USERPROFILE%\AppData\Roaming\Mp3tag -aoa -bb
EXPLORER %USERPROFILE%\AppData\Roaming\Mp3tag

EXIT