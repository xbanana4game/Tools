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
CALL :ChangeDirectory %OSU_SONGS_DIR%
SET UPDATE_SWITCH_OPT=p0q0r2x0y2z0
7z u ..\Osu!-Practice-Maps.7z -u- -u%UPDATE_SWITCH_OPT%!%OSU_DIR%\Exports\Osu!-Practice-Maps@Update%yyyy%%mm%%dd%.7z -ir!*MyPractice*.osu
7z l %OSU_DIR%\Exports\Osu!-Practice-Maps@Update%yyyy%%mm%%dd%.7z
7z a -t7z ..\Osu!-Practice-Maps.7z -ir!*MyPractice*.osu

PAUSE
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
	