@ECHO OFF
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM Archive
REM ----------------------------------------------------------------------
SET INI_DIR=E:\SteamLibrary\steamapps\common\insurgency2\insurgency\cfg\
7z a -tzip %DOWNLOADS_DIR%\Insurgency-ini-%yyyy%%mm%%dd%@%USERNAME%.zip %INI_DIR%\config.cfg %INI_DIR%\video.txt
EXPLORER %DOWNLOADS_DIR%
EXIT

