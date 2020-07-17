@ECHO OFF
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM Archive
REM ----------------------------------------------------------------------
SET OSU_LISTFILE=osu!.list
ECHO %OSU_DIR%\osu!.*.cfg>%OSU_LISTFILE%
ECHO %OSU_DIR%\Settings>>%OSU_LISTFILE%
ECHO %OSU_DIR%\Skins>>%OSU_LISTFILE%
7z a -tzip %DOWNLOADS_DIR%\Osu!-Config-%yyyy%%mm%%dd%@%USERDOMAIN%.zip @%OSU_LISTFILE%
DEL %OSU_LISTFILE%
EXPLORER %DOWNLOADS_DIR%

