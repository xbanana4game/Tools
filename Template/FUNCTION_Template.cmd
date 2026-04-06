@ECHO OFF
REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SHIFT

GOTO :%~0%
GOTO :EOF



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:PARAM_TEST
	ECHO FUNCTION:%0
	ECHO PARAM1:%1
	ECHO PARAM2:%2
	ECHO PARAM3:%3
	EXIT /B 0


REM ======================================================================
REM
REM                                Sample
REM
REM ======================================================================
SET SCRIPTDIR=%~d0%~p0
SET SUBCMD=%SCRIPTDIR%\FUNCTION_Template.cmd
CALL %SUBCMD% PARAM_TEST P1 P2 P3



