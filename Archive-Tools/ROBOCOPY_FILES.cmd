@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- ROBOCOPY_FILES.cmd(SettingsOptions.cmd) ----------
REM SET ROBOCOPY_LOG=%DESKTOP_DIR%\robocopy-%yyyy%%mm%%dd%%hh%%mn%%ss%.log
REM SET ROBOCOPY_LOG_OPTIONS=/log+:"%ROBOCOPY_LOG%" /v /fp /tee
REM SET TARGET_FILES=*.*
REM SET ROBOCOPY_COPY_OPTIONS=/e /r:3 /w:10


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
IF NOT DEFINED ROBOCOPY_LOG_OPTIONS SET ROBOCOPY_LOG_OPTIONS=/log+:"%ROBOCOPY_LOG%" /v /fp /tee

NOTEPAD COPY_LIST.txt
COPY COPY_LIST.txt COPY_LIST@%yyyy%%mm%%dd%%hh%%mn%%ss%.txt

FOR /F "skip=1 tokens=1,2,3* delims=," %%i in (COPY_LIST.txt) DO CALL :LIST_ROBOCOPY %%i "%%j" "%%k\%%i"
CALL :Msg "Check copy-list.txt Execute. Press Enter..."
FOR /F "skip=1 tokens=1,2,3* delims=," %%i in (COPY_LIST.txt) DO CALL :EXEC_ROBOCOPY %%i "%%j" "%%k\%%i"

CALL :Msg Finished
CALL :ArchiveLogFiles
EXIT


:LIST_ROBOCOPY
	SET COPY_PROFILE=%1
	SET COPY_FROM=%2
	SET COPY_TO=%3
	ECHO Profile: %COPY_PROFILE%
	ECHO From: %COPY_FROM%
	ECHO To: %COPY_TO%
	ECHO ROBOCOPY %COPY_FROM% %COPY_TO%
	ROBOCOPY %COPY_FROM% %COPY_TO% %TARGET_FILES% %ROBOCOPY_COPY_OPTIONS% /log:copy-list@%COPY_PROFILE%.txt /l /fp
	IF %ERRORLEVEL% EQU 1 (
		ECHO OK
	)
	START NOTEPAD copy-list@%COPY_PROFILE%.txt
	EXIT /B

:EXEC_ROBOCOPY
	SET COPY_PROFILE=%1
	SET COPY_FROM=%2
	SET COPY_TO=%3
	ECHO ROBOCOPY %COPY_FROM% %COPY_TO%
	ROBOCOPY %COPY_FROM% %COPY_TO% %ROBOCOPY_COPY_OPTIONS% /log:ROBOCOPY_%COPY_PROFILE%@%yyyy%%mm%%dd%%hh%%mn%%ss%.log /v /fp /np /tee
	START NOTEPAD ROBOCOPY_%COPY_PROFILE%@%yyyy%%mm%%dd%%hh%%mn%%ss%.log
	REM EXPLORER %COPY_TO%
	EXIT /B

:Msg
	SET MSG=%1
	SET /P END=%MSG%
	EXIT /B

:ArchiveLogFiles
	7z a -tzip -sdel log_%yyyy%%mm%%dd%%hh%%mn%%ss%_%USERDOMAIN%.zip copy-list*.txt *%yyyy%%mm%%dd%%hh%%mn%%ss%*
	EXIT /B
