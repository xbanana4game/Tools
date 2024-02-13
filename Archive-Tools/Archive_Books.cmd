@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM SET OUTPUT_BOOKS_DIR=%DOCUMENTS_DIR%\Books


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED OUTPUT_BOOKS_DIR SET OUTPUT_BOOKS_DIR=%DOCUMENTS_DIR%\Books
IF NOT EXIST MD %OUTPUT_BOOKS_DIR%
FOR %%i in (%*) DO (
	ECHO %%i
	REM CALL  :RENAME_ADD_DATE  %%i
	IF NOT EXIST "%OUTPUT_BOOKS_DIR%\%%~nxi.zip" (
		7z a -tzip -sdel "%OUTPUT_BOOKS_DIR%\%%~nxi.zip" ""%%i\*"" -xr!*.db -xr!*.dat -xr!*.url -xr!.DS_Store -mx=0 -mtc=off
		REM 7z a -tzip -sdel "%%~nxi.zip" ""%%i"" -mx=0 -mtc=off
		7z l "%OUTPUT_BOOKS_DIR%\%%~nxi.zip">"%%~nxi.zip.txt"
		7z l "%OUTPUT_BOOKS_DIR%\%%~nxi.zip">>"%DOWNLOADS_DIR%\books-%yyyy%%mm%%dd%.log"
	)
	RMDIR "%%i"
)
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:RENAME_ADD_DATE
	SET CMD_FILE=%USERPROFILE%\.Tools\%yyyy%%mm%%dd%%hh%%mn%%ss%.cmd
	SET TARGET_DIR_NAME=%1%
	ECHO SET NUMBER=0 >>%CMD_FILE%
	FOR %%i in (%TARGET_DIR_NAME%\*.*) DO (
		ECHO %%~nxi
		ECHO SET /A NUMBER=%%NUMBER%%+1 >>%CMD_FILE%
		ECHO IF %%NUMBER%% LSS 10000 SET F_NUMBER=%%NUMBER%% >>%CMD_FILE%
		ECHO IF %%NUMBER%% LSS 1000 SET F_NUMBER=0%%NUMBER%% >>%CMD_FILE%
		ECHO IF %%NUMBER%% LSS 100 SET F_NUMBER=00%%NUMBER%% >>%CMD_FILE%
		ECHO IF %%NUMBER%% LSS 10 SET F_NUMBER=000%%NUMBER%% >>%CMD_FILE%
		ECHO SET F_DATE=%%~ti>>%CMD_FILE%
		ECHO SET F_YYYYMMDD_HHMM=%%F_DATE:~0,4%%%%F_DATE:~5,2%%%%F_DATE:~8,2%%-%%F_DATE:~11,2%%%%F_DATE:~14,2%%>>%CMD_FILE%
		
		ECHO ECHO RENAME "%%~fi" "%%F_NUMBER%%%%~xi" >>%CMD_FILE%
		ECHO RENAME "%%~fi" "%%F_NUMBER%%%%~xi" >>%CMD_FILE%
	)
	IF EXIST %CMD_FILE% (
		CALL %CMD_FILE%
		DEL %CMD_FILE%
	)
	EXIT /B 0
