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
:CHANGE_DIRECTORY
	IF EXIST %1 (
		CD /D %1
	) ELSE (
		ECHO Directory %1 is not Exist. Fail Change Directory.
		TIMEOUT /T 3
		EXIT /B 1
	)
	EXIT /B 0
	
:REMOVE_EMPTY_DIR
	SET TARGET_DIR=%~1
	CALL :CHANGE_DIRECTORY "%TARGET_DIR%"
	FOR /F "delims=" %%I IN ('DIR /A:D/B/S ^| SORT /R') DO ( 
		ECHO RMDIR "%%~I" 
		RMDIR "%%~I" 2>nul
	)
	CD ..
	RMDIR "%TARGET_DIR%" 2>nul
	EXIT /B


