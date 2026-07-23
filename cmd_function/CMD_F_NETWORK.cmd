@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
REM DO NOT SET. SETLOCAL ENABLEDELAYEDEXPANSION



REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SHIFT
SET FUNCTION=%~0%
IF "%FUNCTION%" EQU "" (
	SET /P FUNCTION="CALL FUNCTION:"
	CALL :!FUNCTION!
	ECHO RETURN:!ERRORLEVEL!
	PAUSE
) ELSE (
	GOTO :%FUNCTION%
)
GOTO :EOF



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:SETTINGS
	REM SETLOCAL 
	IF DEFINED ROBOCOPY_LOG SET ROBOCOPY_LOG_OPTIONS=/log+:"%ROBOCOPY_LOG%" /v /fp /tee
	IF NOT DEFINED COPY_FROM (SET /P COPY_FROM="SET COPY_FROM=")
	IF NOT DEFINED COPY_FROM (EXIT)
	IF NOT DEFINED COPY_TO (SET /P COPY_TO="SET COPY_TO=")
	IF NOT DEFINED COPY_TO (EXIT)
	IF NOT DEFINED TARGET_FILES (SET TARGET_FILES=*.*)
	IF NOT DEFINED ROBOCOPY_COPY_OPTIONS (SET ROBOCOPY_COPY_OPTIONS=/e /r:3 /w:10)
	IF NOT EXIST %COPY_FROM% EXIT
	SET ROBOCOPY_CMD=ROBOCOPY "%COPY_FROM%" "%COPY_TO%" %TARGET_FILES% %ROBOCOPY_EXTRA_OPTIONS% %ROBOCOPY_COPY_OPTIONS%
	ECHO ==================================================================================
	CD
	ECHO COPY_FROM   : %COPY_FROM%
	ECHO COPY_TO     : %COPY_TO%
	ECHO OPTIONS     : %ROBOCOPY_COPY_OPTIONS%
	ECHO EXTRA       : %ROBOCOPY_EXTRA_OPTIONS%
	ECHO ROBOCOPY_CMD: %ROBOCOPY_CMD%
	ECHO ==================================================================================
	ECHO;
	REM ENDLOCAL
	EXIT /B
	
:TEST_ROBOCOPY
	SETLOCAL 
	IF NOT DEFINED ROBOCOPY_CMD EXIT /B
	ECHO %ROBOCOPY_CMD% /L
	%ROBOCOPY_CMD% /L
	ECHO Test end. Start copy. Press Enter...
	PAUSE
	ENDLOCAL
	EXIT /B

:START_ROBOCOPY
	SETLOCAL 
	IF NOT DEFINED ROBOCOPY_CMD EXIT /B
	%ROBOCOPY_CMD%
	IF ERRORLEVEL 8 (
		ECHO ROBOCPY FAILED.
		IF DEFINED ROBOCOPY_LOG NOTEPAD %ROBOCOPY_LOG%
		PAUSE
	)
	ENDLOCAL
	EXIT /B

:REMOVE_LOG
	SETLOCAL 
	IF NOT DEFINED ROBOCOPY_LOG EXIT /B
	CHOICE /C YN /T 10 /D Y /M "Remove %ROBOCOPY_LOG%?"
	IF %ERRORLEVEL% EQU 1 DEL %ROBOCOPY_LOG%
	ENDLOCAL
	EXIT /B

:END
	SETLOCAL 
	EXPLORER "%COPY_TO%"
	ENDLOCAL
	EXIT /B

:PARAM_TEST
	SETLOCAL 
	ECHO FUNCTION:%0
	ECHO PARAM1:%1
	ECHO PARAM2:%2
	ECHO PARAM3:%3
	ENDLOCAL
	EXIT /B 0

:SUCCESS
	EXIT /B
	
:ERROR
	EXIT /B 1
