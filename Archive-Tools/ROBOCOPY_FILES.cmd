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
IF NOT DEFINED ROBOCOPY_COPY_OPTIONS (SET ROBOCOPY_COPY_OPTIONS=/e /r:3 /w:10)
IF NOT DEFINED ROBOCOPY_LOG SET ROBOCOPY_LOG=%DESKTOP_DIR%\robocopy-%yyyy%%mm%%dd%%hh%%mn%%ss%.log
SET ROBOCOPY_LOG_OPTIONS=/log+:"%ROBOCOPY_LOG%" /v /fp /tee

COPY XCOPY_LIST.txt XCOPY_LIST@%yyyy%%mm%%dd%%hh%%mn%%ss%.txt

FOR /F "skip=1 tokens=1,2,3* delims=," %%i in (XCOPY_LIST.txt) DO CALL :LIST_ROBOCOPY %%i "%%j" "%%k\%%i"
CALL :Msg "Check copy-list.txt Execute. Press Enter..."
FOR /F "skip=1 tokens=1,2,3* delims=," %%i in (XCOPY_LIST.txt) DO CALL :EXEC_ROBOCOPY %%i "%%j" "%%k\%%i"

CALL :Msg Finished
EXIT


:LIST_ROBOCOPY
	SET COPY_PROFILE=%1
	SET COPY_FROM=%2
	SET COPY_TO=%3
	ECHO Profile: %COPY_PROFILE%
	ECHO From: %COPY_FROM%
	ECHO To: %COPY_TO%
	ECHO ROBOCOPY %COPY_FROM% %COPY_TO%
	ROBOCOPY %COPY_FROM% %COPY_TO% %ROBOCOPY_COPY_OPTIONS% /log:copy-list@%COPY_PROFILE%.txt /l /fp
	IF %ERRORLEVEL% EQU 1 (
		ECHO OK
	)
	START copy-list@%COPY_PROFILE%.txt
	EXIT /B

:EXEC_ROBOCOPY
	SET COPY_PROFILE=%1
	SET COPY_FROM=%2
	SET COPY_TO=%3
	ECHO ROBOCOPY %COPY_FROM% %COPY_TO%
	ROBOCOPY %COPY_FROM% %COPY_TO% %ROBOCOPY_COPY_OPTIONS% /log:ROBOCOPY_%COPY_PROFILE%@%yyyy%%mm%%dd%%hh%%mn%%ss%.log /v /fp /np /tee
	NOTEPAD ROBOCOPY_%COPY_PROFILE%@%yyyy%%mm%%dd%%hh%%mn%%ss%.log
	REM EXPLORER %COPY_TO%
	EXIT /B

:Msg
	SET MSG=%1
	SET /P END=%MSG%
	EXIT /B


