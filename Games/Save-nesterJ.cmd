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

CALL :CheckDirectory %NESTERJ_DIR%
IF %ERRORLEVEL% EQU 1 (
	ECHO Directory not Exist. %DESKTOP_DIR%
	EXIT
)
CD %NESTERJ_DIR%
7z a %DOWNLOADS_DIR%\nesterJ-saves@%yyyy%%mm%%dd%.7z -spf2 state\* save\*
CALL  :RENAME_ADD_DATE_NESTER  shot
7z a -tzip -sdel %DOWNLOADS_DIR%\nesterJ-screenshots@%yyyy%%mm%%dd%.zip -spf2 shot\*
PAUSE
EXPLORER %DOWNLOADS_DIR%
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
	CALL a.cmd
	DEL a.cmd
	EXIT /B 0

:CheckDirectory
	IF EXIST %1 (
		ECHO Directory %1 is Exist.
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT /B 1
	)
	EXIT /B 0
	
