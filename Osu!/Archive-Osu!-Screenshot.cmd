@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd


REM ----------------------------------------------------------------------
REM Archive
REM ----------------------------------------------------------------------
%FLEXIBLE_RENAMER%

SET /P SCREENSHOT_YYYYMM="YYYYMM default:%yyyy%%mm%->"
IF "%SCREENSHOT_YYYYMM%"=="" SET SCREENSHOT_YYYYMM=%yyyy%%mm%

SET SCREENSHOTS_ARCHIVE_NAME=Osu!-Screenshots-%SCREENSHOT_YYYYMM%
7z a -tzip -sdel %DOCUMENTS_DIR%\%SCREENSHOTS_ARCHIVE_NAME%.zip %OSU_DIR%\Screenshots\%SCREENSHOT_YYYYMM%*

EXPLORER %DOCUMENTS_DIR%

