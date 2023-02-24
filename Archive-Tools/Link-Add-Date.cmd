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
IF NOT "%1"=="" (
	FOR %%i IN (%*) DO (
		ECHO REM ======================================================================>>a.cmd
		ECHO REM %%i>>a.cmd
		ECHO REM ======================================================================>>a.cmd
		echo SET F_DATE=%%~ti>>a.cmd
		echo SET F_YYYYMMDD=%%F_DATE:~0,4%%%%F_DATE:~5,2%%%%F_DATE:~8,2%%>>a.cmd
		echo RENAME "%%i" "_%%~ni@%%F_YYYYMMDD%%%%~xi">>a.cmd
		echo MKLINK /H "%%i" "%%~dpi_%%~ni@%%F_YYYYMMDD%%%%~xi">>a.cmd
	)
	IF EXIST a.cmd (
		CALL a.cmd
		TYPE a.cmd
		DEL a.cmd
	)
)
PAUSE
EXIT



