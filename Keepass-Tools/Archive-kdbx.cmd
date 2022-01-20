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
SET CMD_FILE=%USERPROFILE%\.Tools\a.cmd
CD %USERPROFILE%\.Tools\%CMD_FILE%
IF "%1"=="" (
	IF NOT DEFINED KDBX_TARGET_DIR SET /P KDBX_TARGET_DIR="KDBX_TARGET_DIR (default. %DESKTOP_DIR%) -> "
	IF "%KDBX_TARGET_DIR%"=="" SET KDBX_TARGET_DIR=%DESKTOP_DIR%
)
IF "%1"=="" (
	FOR %%i IN (%KDBX_TARGET_DIR%\*.kdbx) DO (
		ECHO REM ======================================================================>>%CMD_FILE%
		ECHO REM %%i>>%CMD_FILE%
		ECHO REM ======================================================================>>%CMD_FILE%
		echo SET F_DATE=%%~ti>>%CMD_FILE%
		echo SET F_YYYYMMDD=%%F_DATE:~0,4%%%%F_DATE:~5,2%%%%F_DATE:~8,2%%>>%CMD_FILE%
		echo 7z a "%DOWNLOADS_DIR%\kp-%%~ni@%%F_YYYYMMDD%%.zip" "%%i">>%CMD_FILE%
	)
) ELSE (
	ECHO REM ======================================================================>>%CMD_FILE%
	ECHO REM %%i>>%CMD_FILE%
	ECHO REM ======================================================================>>%CMD_FILE%
	echo SET F_DATE=%~t1>>%CMD_FILE%
	echo SET F_YYYYMMDD=%%F_DATE:~0,4%%%%F_DATE:~5,2%%%%F_DATE:~8,2%%>>%CMD_FILE%
	echo 7z a "%DOWNLOADS_DIR%\kp-%~n1@%%F_YYYYMMDD%%.zip" "%1">>%CMD_FILE%
	echo 7z l "%DOWNLOADS_DIR%\kp-%~n1@%%F_YYYYMMDD%%.zip">>%CMD_FILE%
)

IF EXIST %CMD_FILE% (
	CALL %CMD_FILE%
	DEL %CMD_FILE%
)

PAUSE
EXIT

