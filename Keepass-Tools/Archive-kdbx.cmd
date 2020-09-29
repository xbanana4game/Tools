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
IF "%1"=="" (
	IF NOT DEFINED KDBX_TARGET_DIR SET /P KDBX_TARGET_DIR="KDBX_TARGET_DIR (default. %DESKTOP_DIR%) -> "
	IF "%KDBX_TARGET_DIR%"=="" SET KDBX_TARGET_DIR=%DESKTOP_DIR%
)
IF "%1"=="" (
	FOR %%i IN (%KDBX_TARGET_DIR%\*.kdbx) DO (
		ECHO REM ======================================================================>>a.cmd
		ECHO REM %%i>>a.cmd
		ECHO REM ======================================================================>>a.cmd
		echo SET F_DATE=%%~ti>>a.cmd
		echo SET F_YYYYMMDD=%%F_DATE:~0,4%%%%F_DATE:~5,2%%%%F_DATE:~8,2%%>>a.cmd
		echo 7z a "%DOWNLOADS_DIR%\keepass-%%~ni@%%F_YYYYMMDD%%.7z" "%%i">>a.cmd
	)
) ELSE (
	ECHO REM ======================================================================>>a.cmd
	ECHO REM %%i>>a.cmd
	ECHO REM ======================================================================>>a.cmd
	echo SET F_DATE=%~t1>>a.cmd
	echo SET F_YYYYMMDD=%%F_DATE:~0,4%%%%F_DATE:~5,2%%%%F_DATE:~8,2%%>>a.cmd
	echo 7z a "%DOWNLOADS_DIR%\keepass-%~n1@%%F_YYYYMMDD%%.7z" "%1">>a.cmd
)

IF EXIST a.cmd (
	CALL a.cmd
	TYPE a.cmd
	DEL a.cmd
)

PAUSE
EXIT

