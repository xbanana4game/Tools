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

FOR /F "tokens=1,2,3* delims=," %%i in (XCOPY_LIST.txt) DO CALL :LIST_XCOPY "%%i" "%%j" "%%k\%%i\"
CALL :Msg "Check copy-list.txt Execute. Press Enter..."
FOR /F "tokens=1,2,3* delims=," %%i in (XCOPY_LIST.txt) DO CALL :EXEC_XCOPY "%%i" "%%j" "%%k\%%i\"

CALL :Msg Finished
EXIT


:LIST_XCOPY
	SET COPY_PROFILE=%1
	SET COPY_FROM=%2
	SET COPY_TO=%3
	ECHO Profile: %COPY_PROFILE%
	ECHO From: %COPY_FROM%
	ECHO To: %COPY_TO%
	ECHO XCOPY %COPY_FROM% %COPY_TO%
	XCOPY %COPY_FROM% %COPY_TO% /Y /H /S /E /F /K /L >copy-list@%COPY_PROFILE%.txt
	START copy-list@%COPY_PROFILE%.txt
	EXIT /B

:EXEC_XCOPY
	SET COPY_PROFILE=%1
	SET COPY_FROM=%2
	SET COPY_TO=%3
	ECHO XCOPY %COPY_FROM% %COPY_TO%
	XCOPY %COPY_FROM% %COPY_TO% /Y /H /S /E /F /K
	EXIT /B

:Msg
	SET MSG=%1
	SET /P END=%MSG%
	EXIT /B


