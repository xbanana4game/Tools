@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM --------------- Remove-Empty-Dir.cmd(SettingsOptions) --------------------
REM SET ROOT_DIR=%DESKTOP_DIR%
REM ----------------------------------------------------------------------


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF NOT "%1"=="" (
	SET ROOT_DIR=%1
)
IF NOT DEFINED ROOT_DIR SET /P ROOT_DIR="ROOT_DIR:"
IF NOT EXIST %ROOT_DIR% EXIT
echo START REMOVE EMPTY DIR %ROOT_DIR%
CALL :REMOVE_EMPTY_DIR %ROOT_DIR%
pause
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:ChangeDirectory
	IF EXIST %1 (
		CD /D %1
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0
	
:REMOVE_EMPTY_DIR
	SET TARGET_DIR=%1
	CALL :ChangeDirectory %TARGET_DIR%
	FOR /F "delims=" %%I IN ('DIR /A:D/B/S ^| SORT /R') DO ( 
		ECHO RMDIR "%%I" 
		RMDIR "%%I" 
	)
	EXIT /B
	
