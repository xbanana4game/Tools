@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
SET /P SCREENSHOT_YYYYMM="YYYY-MM default:%yyyy%-%mm% ->"
IF "%SCREENSHOT_YYYYMM%"=="" SET SCREENSHOT_YYYYMM=%yyyy%-%mm%

7z a -tzip -sdel "%DOCUMENTS_DIR%\Osu!-Stream Speed Benchmark %SCREENSHOT_YYYYMM%.zip" "%DESKTOP_DIR%\%SCREENSHOT_YYYYMM%*streaming v2.png"
EXPLORER %DOCUMENTS_DIR%
