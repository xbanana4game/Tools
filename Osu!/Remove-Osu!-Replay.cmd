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
CALL :REMOVE_OSU_REPLAY
PAUSE
EXPLORER %OSU_DIR%
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
	7z a -t7z -sdel %OSU_DIR%\Osu!-Replay@%yyyy%%mm%.7z -spf2 %OSU_DIR%\Data\r
	EXIT /B

:ChangeDirectory
	IF EXIST %1 (
		CD /D %1
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0

