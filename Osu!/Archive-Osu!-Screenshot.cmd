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
CALL :CheckDirectory %OSU_DIR%\Screenshots
IF %ERRORLEVEL% EQU 1 (
	ECHO Directory not Exist. %DESKTOP_DIR%
	EXIT
)
CALL  :RENAME_ADD_DATE_OSU  %OSU_DIR%\Screenshots

REM SET /P SCREENSHOT_YYYYMM="YYYYMM default:%yyyy%%mm%->"
REM IF "%SCREENSHOT_YYYYMM%"=="" SET SCREENSHOT_YYYYMM=%yyyy%%mm%
REM SET SCREENSHOTS_ARCHIVE_NAME=Osu!-Screenshots-%SCREENSHOT_YYYYMM%
REM 7z a -tzip -sdel %DOCUMENTS_DIR%\%SCREENSHOTS_ARCHIVE_NAME%.zip %OSU_DIR%\Screenshots\%SCREENSHOT_YYYYMM%*  -mx=0
REM EXPLORER %DOCUMENTS_DIR%

SET SCREENSHOTS_ARCHIVE_NAME=Osu!-Screenshots-%yyyy%%mm%%dd%_%hh%%mn%
7z a -tzip -sdel %DOWNLOADS_DIR%\%SCREENSHOTS_ARCHIVE_NAME%.zip %OSU_DIR%\Screenshots\%yyyy%*  -mx=0

EXIT /B 0


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:RENAME_ADD_DATE_OSU
	SET CMD_FILE=%USERPROFILE%\.Tools\%yyyy%%mm%%dd%%hh%%mn%%ss%.cmd
	SET TARGET_DIR_NAME=%1%
	FOR %%i in (%TARGET_DIR_NAME%\screenshot*.jpg) DO (
		ECHO %%~nxi
		ECHO SET F_DATE=%%~ti>>%CMD_FILE%
		ECHO SET F_YYYYMMDD_HHMM=%%F_DATE:~0,4%%%%F_DATE:~5,2%%%%F_DATE:~8,2%%-%%F_DATE:~11,2%%%%F_DATE:~14,2%%>>%CMD_FILE%
		
		ECHO SET FILE_COUNT=0 >>%CMD_FILE%
		ECHO :"RENAME_%%~ni" >>%CMD_FILE%
		ECHO SET /A FILE_COUNT=%%FILE_COUNT%%+1 >>%CMD_FILE%
		
		REM %%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi
		ECHO IF EXIST "%%~dpi%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" GOTO :"RENAME_%%~ni" >>%CMD_FILE%
		ECHO ECHO RENAME "%%~fi" "%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" >>%CMD_FILE%
		ECHO RENAME "%%~fi" "%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" >>%CMD_FILE%
	)
	
	FOR %%i in (%TARGET_DIR_NAME%\*.png) DO (
		ECHO %%~nxi
		ECHO SET F_DATE=%%~ti>>%CMD_FILE%
		ECHO SET F_YYYYMMDD_HHMM=%%F_DATE:~0,4%%%%F_DATE:~5,2%%%%F_DATE:~8,2%%-%%F_DATE:~11,2%%%%F_DATE:~14,2%%>>%CMD_FILE%
		
		ECHO SET FILE_COUNT=0 >>%CMD_FILE%
		ECHO :"RENAME_%%~ni" >>%CMD_FILE%
		ECHO SET /A FILE_COUNT=%%FILE_COUNT%%+1 >>%CMD_FILE%
		
		REM %%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi
		ECHO IF EXIST "%%~dpi%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" GOTO :"RENAME_%%~ni" >>%CMD_FILE%
		ECHO ECHO RENAME "%%~fi" "%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" >>%CMD_FILE%
		ECHO RENAME "%%~fi" "%%F_YYYYMMDD_HHMM%%-%%FILE_COUNT%%%%~xi" >>%CMD_FILE%
	)
		
	IF EXIST %CMD_FILE% (
		CALL %CMD_FILE%
		DEL %CMD_FILE%
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
	
