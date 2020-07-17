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
CALL :ChangeDirectory %OSU_SONGS_DIR%
7z a -t7z %DESKTOP_DIR%\Osu!-Practice-Maps@%yyyy%%mm%%dd%.7z -ir!*MyPractice*.osu


:ChangeDirectory
	IF EXIST %1 (
	  CD /D %1
	) ELSE (
	  SET /P ERR=Directory %1 is not Exist.
	  EXIT
	)
	EXIT /B 0
	