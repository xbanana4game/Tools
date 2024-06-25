@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SET CSV_FILE=%1
SET CSV_SJIS_FILE=%DESKTOP_DIR%\csv-sjis.txt
ECHO %CSV_FILE%
nkf32.exe -s %CSV_FILE%>%CSV_SJIS_FILE%
FOR /F "tokens=1,6 delims=," %%i IN (%CSV_SJIS_FILE%) DO (
	REM ECHO %%i %%j
	IF %%i==1 (
		ECHO %%j
		ECHO %%j>>%DESKTOP_DIR%\dl.txt
	)
)
DEL %CSV_SJIS_FILE%
pause
