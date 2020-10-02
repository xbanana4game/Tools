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
CALL  :RENAME_ADD_DATE  %DESKTOP_DIR%\Screenshots
PAUSE
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:RENAME_ADD_DATE
	SET TARGET_DIR_NAME=%1%
	ECHO SET NUMBER=1 >>a.cmd
	FOR %%i in (%TARGET_DIR_NAME%\*.png) DO (
		ECHO %%~nxi
		ECHO SET /A NUMBER=%%NUMBER%%+1 >>a.cmd
		ECHO IF %%NUMBER%% LSS 10000 SET F_NUMBER=%%NUMBER%% >>a.cmd
		ECHO IF %%NUMBER%% LSS 1000 SET F_NUMBER=0%%NUMBER%% >>a.cmd
		ECHO IF %%NUMBER%% LSS 100 SET F_NUMBER=00%%NUMBER%% >>a.cmd
		ECHO IF %%NUMBER%% LSS 10 SET F_NUMBER=000%%NUMBER%% >>a.cmd
		ECHO SET F_DATE=%%~ti>>a.cmd
		ECHO SET F_YYYYMMDD_HHMM=%%F_DATE:~0,4%%%%F_DATE:~5,2%%%%F_DATE:~8,2%%-%%F_DATE:~11,2%%%%F_DATE:~14,2%%>>a.cmd
		
		ECHO SET FILE_COUNT=0 >>a.cmd
		ECHO :"RENAME_%%~nsi" >>a.cmd
		ECHO SET /A FILE_COUNT=%%FILE_COUNT%%+1 >>a.cmd
		
		REM %%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi
		ECHO IF EXIST "%%~dpi%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" GOTO :"RENAME_%%~nsi" >>a.cmd
		ECHO ECHO RENAME "%%~fi" "%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" >>a.cmd
		ECHO RENAME "%%~fi" "%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" >>a.cmd
	)
	IF EXIST a.cmd (
		CALL a.cmd
		DEL a.cmd
	)
	EXIT /B 0
