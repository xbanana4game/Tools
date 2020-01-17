@ECHO OFF
REM ----------------------------------------------------------------------
REM ê›íËÉtÉ@ÉCÉãì«Ç›çûÇ›
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
for %%i in (%*) do (
	CALL :makeGpg %GPG_USER_ID% %USERPROFILE%\Desktop\%%~nxi.gpg %%i
)
EXPLORER %USERPROFILE%\Desktop
EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:makeGpg
	SET USER_ID=%1
	SET OUT_FILE=%2
	SET IN_FILE=%3
	gpg -e -r %USER_ID% -a -o %OUT_FILE% %IN_FILE%
	EXIT /B

