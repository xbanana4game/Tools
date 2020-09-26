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
IF NOT DEFINED NESTERJ_DIR SET NESTERJ_DIR=%USERPROFILE%\Documents\nj051b_ja
IF NOT DEFINED NESTERJ_SCREENSHOTS_DIR SET NESTERJ_SCREENSHOTS_DIR=%NESTERJ_DIR%\shot

CALL :ChangeDirectory %NESTERJ_DIR%
7z a %DOCUMENTS_DIR%\nesterJ-saves@%yyyy%%mm%.7z -spf2 state\* save\*
7z l %DOCUMENTS_DIR%\nesterJ-saves@%yyyy%%mm%.7z

CALL  :RENAME_ADD_DATE_NESTER  %NESTERJ_SCREENSHOTS_DIR%
7z a -tzip -sdel %DOCUMENTS_DIR%\nesterJ-screenshots@%yyyy%%mm%.zip %NESTERJ_SCREENSHOTS_DIR%\*
7z l %DOCUMENTS_DIR%\nesterJ-screenshots@%yyyy%%mm%.zip

PAUSE
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:RENAME_ADD_DATE_NESTER
	SET TARGET_DIR_NAME=%1%
	FOR %%i in (%TARGET_DIR_NAME%\*) DO (
		echo SET F_DATE=%%~ti>>a.cmd
		echo SET F_YYYYMMDD_HHMM=%%F_DATE:~0,4%%%%F_DATE:~5,2%%%%F_DATE:~8,2%%-%%F_DATE:~11,2%%%%F_DATE:~14,2%%>>a.cmd
		echo RENAME "%%~fi" "%%F_YYYYMMDD_HHMM%%_-_%%~ni%%~xi" >>a.cmd
		echo ECHO RENAME "%%~fi" "%%F_YYYYMMDD_HHMM%%_-_%%~ni%%~xi" >>a.cmd
	)
	IF EXIST a.cmd (
		CALL a.cmd
		DEL a.cmd
	)
	EXIT /B 0

:ChangeDirectory
	IF EXIST %1 (
		CD /D %1
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0
