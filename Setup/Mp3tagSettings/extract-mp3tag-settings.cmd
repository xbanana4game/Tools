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
REM SET MODE=UPDATE
REM SET MODE=OVERWRITE

REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED SETTINGS_FILE SET SETTINGS_FILE=Mp3tagSettings.zip
IF NOT DEFINED MODE SET MODE=UPDATE

IF "%MODE%" EQU "UPDATE" (
	7z x %SETTINGS_FILE% -o%DESKTOP_DIR%\Mp3tag -aoa -bb
	ROBOCOPY %DESKTOP_DIR%\Mp3tag %USERPROFILE%\AppData\Roaming\Mp3tag /E /XL /v
	RMDIR %DESKTOP_DIR%\Mp3tag /S /Q
) ELSE IF "%MODE%" EQU "OVERWRITE" (
	7z x %SETTINGS_FILE% -o%USERPROFILE%\AppData\Roaming\Mp3tag -aoa -bb
)

EXPLORER %USERPROFILE%\AppData\Roaming\Mp3tag

EXIT