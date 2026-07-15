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
	REM FOR DEBUG
	SETLOCAL ENABLEDELAYEDEXPANSION
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
