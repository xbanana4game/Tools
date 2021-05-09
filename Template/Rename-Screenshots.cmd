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
CALL  :RENAME_ADD_DATE  %DESKTOP_DIR%\Screenshots
PAUSE
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:RENAME_ADD_DATE
	SET CMD_FILE=%USERPROFILE%\.Tools\%yyyy%%mm%%dd%%hh%%mn%.cmd
	SET TARGET_DIR_NAME=%1%
	ECHO SET NUMBER=1 >>%CMD_FILE%
	FOR %%i in (%TARGET_DIR_NAME%\*.png) DO (
		ECHO %%~nxi
		ECHO SET /A NUMBER=%%NUMBER%%+1 >>%CMD_FILE%
		ECHO IF %%NUMBER%% LSS 10000 SET F_NUMBER=%%NUMBER%% >>%CMD_FILE%
		ECHO IF %%NUMBER%% LSS 1000 SET F_NUMBER=0%%NUMBER%% >>%CMD_FILE%
		ECHO IF %%NUMBER%% LSS 100 SET F_NUMBER=00%%NUMBER%% >>%CMD_FILE%
		ECHO IF %%NUMBER%% LSS 10 SET F_NUMBER=000%%NUMBER%% >>%CMD_FILE%
		ECHO SET F_DATE=%%~ti>>%CMD_FILE%
		ECHO SET F_YYYYMMDD_HHMM=%%F_DATE:~0,4%%%%F_DATE:~5,2%%%%F_DATE:~8,2%%-%%F_DATE:~11,2%%%%F_DATE:~14,2%%>>%CMD_FILE%
		
		ECHO SET FILE_COUNT=0 >>%CMD_FILE%
		ECHO :"RENAME_%%~nsi" >>%CMD_FILE%
		ECHO SET /A FILE_COUNT=%%FILE_COUNT%%+1 >>%CMD_FILE%
		
		REM %%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi
		ECHO IF EXIST "%%~dpi%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" GOTO :"RENAME_%%~nsi" >>%CMD_FILE%
		ECHO ECHO RENAME "%%~fi" "%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" >>%CMD_FILE%
		ECHO RENAME "%%~fi" "%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" >>%CMD_FILE%
	)
	IF EXIST %CMD_FILE% (
		CALL %CMD_FILE%
		DEL %CMD_FILE%
	)
	EXIT /B 0
