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
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
CALL :REMOVE_OSU_REPLAY
PAUSE
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------		
:REMOVE_OSU_REPLAY
	CALL :ChangeDirectory %OSU_DIR%
	ECHO Start Remove Replay %OSU_DIR%
	PAUSE
	7z a -t7z -sdel %OSU_DIR%\Exports\Osu!-Replay@%yyyy%%mm%%dd%.7z -spf2 %OSU_DIR%\Data\r
	EXIT /B

:ChangeDirectory
	IF EXIST %1 (
		CD /D %1
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0

