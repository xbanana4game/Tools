@ECHO OFF
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
SET GAME_NAME=Factorio
SET FACTORIO_SAVES_DIR=%FACTORIO_DIR%\saves

REM ----------------------------------------------------------------------
REM Archive
REM ----------------------------------------------------------------------
SET /P OPEN_SAVES="Open saves? 1/0 -> "
IF ""=="%OPEN_SAVES%" SET OPEN_SAVES=0
IF 1 EQU %OPEN_SAVES% EXPLORER %FACTORIO_SAVES_DIR%
SET /P A="Start Archiving saves"
7z a -t7z %DOWNLOADS_DIR%\%GAME_NAME%-saves-%yyyy%%mm%%dd%@%USERNAME%.7z %FACTORIO_SAVES_DIR%\*.zip -xr!_*.zip -mx0
EXPLORER %DOWNLOADS_DIR%

