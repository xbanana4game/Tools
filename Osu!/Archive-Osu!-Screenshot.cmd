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
CALL :CheckDirectory %OSU_DIR%\Screenshots
IF %ERRORLEVEL% EQU 1 (
	ECHO Directory not Exist. %DESKTOP_DIR%
	EXIT
)
CALL  :RENAME_ADD_DATE_OSU  %OSU_DIR%\Screenshots

SET /P SCREENSHOT_YYYYMM="YYYYMM default:%yyyy%%mm%->"
IF "%SCREENSHOT_YYYYMM%"=="" SET SCREENSHOT_YYYYMM=%yyyy%%mm%

SET SCREENSHOTS_ARCHIVE_NAME=Osu!-Screenshots-%SCREENSHOT_YYYYMM%
7z a -tzip -sdel %DOCUMENTS_DIR%\%SCREENSHOTS_ARCHIVE_NAME%.zip %OSU_DIR%\Screenshots\%SCREENSHOT_YYYYMM%*

EXPLORER %DOCUMENTS_DIR%
EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:RENAME_ADD_DATE_OSU
	SET TARGET_DIR_NAME=%1%
	FOR %%i in (%TARGET_DIR_NAME%\screenshot*.jpg) DO (
		echo SET F_DATE=%%~ti>>a.cmd
		echo SET F_YYYYMMDD_HHMM=%%F_DATE:~0,4%%%%F_DATE:~5,2%%%%F_DATE:~8,2%%-%%F_DATE:~11,2%%%%F_DATE:~14,2%%>>a.cmd
		
		echo SET FILE_COUNT=0 >>a.cmd
		echo :"RENAME_%%~ni" >>a.cmd
		echo SET /A FILE_COUNT=%%FILE_COUNT%%+1 >>a.cmd
		
		REM %%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi
		echo IF EXIST "%%~dpi%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" GOTO :"RENAME_%%~ni" >>a.cmd
		echo ECHO RENAME "%%~fi" "%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" >>a.cmd
		echo RENAME "%%~fi" "%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" >>a.cmd
	)
	IF EXIST a.cmd (
		CALL a.cmd
		DEL a.cmd
	)
	EXIT /B 0

	
:CheckDirectory
	IF EXIST %1 (
		ECHO Directory %1 is Exist.
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT /B 1
	)
	EXIT /B 0
	
