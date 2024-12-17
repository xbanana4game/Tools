@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Archive-Osu!-Screenshot.cmd(SettingsOptions) ----------
REM SET OSU_DIR=
REM SET SCREENSHOT_DIR=%OSU_DIR%\Screenshots
REM SET SCREENSHOTS_ARCHIVE_NAME=Osu!-screenshots-%yyyy%%mm%%dd%_%hh%%mn%


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF NOT DEFINED SCREENSHOT_DIR SET SCREENSHOT_DIR=%OSU_DIR%\Screenshots
IF NOT DEFINED SCREENSHOTS_ARCHIVE_NAME SET SCREENSHOTS_ARCHIVE_NAME=Osu!-screenshots-%yyyy%%mm%%dd%_%hh%%mn%
IF NOT DEFINED SCREENSHOT_EXT SET SCREENSHOT_EXT=jpg

CALL :CheckDirectory %SCREENSHOT_DIR%
IF %ERRORLEVEL% EQU 1 (
	ECHO Directory not Exist. %SCREENSHOT_DIR%
	EXIT
)
CALL  :RENAME_ADD_DATE_OSU %SCREENSHOT_DIR%
IF EXIST %SCREENSHOT_DIR%\*.%SCREENSHOT_EXT% (
	7z a -tzip -sdel %DOWNLOADS_DIR%\%SCREENSHOTS_ARCHIVE_NAME%.zip %SCREENSHOT_DIR%\* -mx=0
)

EXIT /B 0


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:RENAME_ADD_DATE_OSU
	SET CMD_FILE=%USERPROFILE%\.Tools\%yyyy%%mm%%dd%%hh%%mn%%ss%.cmd
	SET TARGET_DIR_NAME=%1
	IF NOT DEFINED SCREENSHOT_EXT SET SCREENSHOT_EXT=jpg

	FOR %%i in (%TARGET_DIR_NAME%\*.%SCREENSHOT_EXT%) DO (
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
	
