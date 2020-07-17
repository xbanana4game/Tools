@ECHO OFF
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM Archive
REM ----------------------------------------------------------------------
SET GAME_NAME=Osu!
%FLEXIBLE_RENAMER%
SET /P SCREENSHOT_YYYYMM="YYYYMM default:%yyyy%%mm%->"
IF "%SCREENSHOT_YYYYMM%"=="" SET SCREENSHOT_YYYYMM=%yyyy%%mm%
SET SCREENSHOTS_ARCHIVE_NAME=%GAME_NAME%-Screenshots-%SCREENSHOT_YYYYMM%

7z a -tzip -sdel %OSU_DIR%\%SCREENSHOTS_ARCHIVE_NAME%.zip %OSU_DIR%\Screenshots\%SCREENSHOT_YYYYMM%*
EXPLORER %OSU_DIR%

