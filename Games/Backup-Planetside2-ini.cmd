@ECHO OFF
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM Archive
REM ----------------------------------------------------------------------
SET GAME_NAME=Planetside2
7z a -tzip %DOWNLOADS_DIR%\%GAME_NAME%-ini-%yyyy%%mm%%dd%@%USERNAME%.zip "%PLANETSIDE2_DIR%\InputProfile_User.xml" "%PLANETSIDE2_DIR%\UserOptions.ini"
EXPLORER %DOWNLOADS_DIR%

