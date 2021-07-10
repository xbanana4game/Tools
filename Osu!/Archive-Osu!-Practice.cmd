@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
SET PRACTICE_MAPS_DIR=%OSU_DIR%\Practice-Maps
MD %PRACTICE_MAPS_DIR%
CALL :ChangeDirectory %OSU_SONGS_DIR%
SET UPDATE_SWITCH_OPT=p0q0r2x0y2z0
7z u %PRACTICE_MAPS_DIR%\Osu!-Practice-Maps.7z -u- -u%UPDATE_SWITCH_OPT%!%PRACTICE_MAPS_DIR%\Osu!-Practice-Maps@Update%yyyy%%mm%%dd%.7z -ir!*MyPractice*.osu
7z l %PRACTICE_MAPS_DIR%\Osu!-Practice-Maps@Update%yyyy%%mm%%dd%.7z
7z a -t7z %PRACTICE_MAPS_DIR%\Osu!-Practice-Maps.7z -ir!*MyPractice*.osu

PAUSE
EXPLORER %PRACTICE_MAPS_DIR%
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:ChangeDirectory
	IF EXIST %1 (
	  CD /D %1
	) ELSE (
	  SET /P ERR=Directory %1 is not Exist.
	  EXIT
	)
	EXIT /B 0
	