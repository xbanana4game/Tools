@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
SETLOCAL ENABLEDELAYEDEXPANSION



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
) ELSE (
	GOTO :%FUNCTION%
)
GOTO :EOF



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:PARAM_TEST
	SETLOCAL 
	ECHO FUNCTION:%0
	ECHO PARAM1:%1
	ECHO PARAM2:%2
	ECHO PARAM3:%3
	PAUSE
	ENDLOCAL
	EXIT /B 0


