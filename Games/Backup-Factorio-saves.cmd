@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SET GAME_NAME=Factorio
SET FACTORIO_DIR=%USERPROFILE%\AppData\Roaming\Factorio
SET FACTORIO_SAVES_DIR=%FACTORIO_DIR%\saves

REM ----------------------------------------------------------------------
REM Archive
REM ----------------------------------------------------------------------
SET /P OPEN_SAVES="Open saves? 1/0 -> "
IF ""=="%OPEN_SAVES%" SET OPEN_SAVES=0
IF 1 EQU %OPEN_SAVES% EXPLORER %FACTORIO_SAVES_DIR%
SET /P A="Start Archiving saves"
7z a -t7z %DOWNLOADS_DIR%\%GAME_NAME%-saves-%yyyy%%mm%%dd%@%USERDOMAIN%.7z %FACTORIO_SAVES_DIR%\*.zip -xr!_*.zip -mx0
EXPLORER %DOWNLOADS_DIR%

EXIT
