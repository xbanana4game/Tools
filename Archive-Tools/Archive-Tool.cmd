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
IF NOT "%1"=="" (
	SET ARCHIVE_PROFILE_FILE=%~1
	SET ARCHIVE_DRIVE=%~d1
	SET ARCHIVE_PATH=%~dp1
	SET ARCHIVE_PROFILE=%~n1
	SET ARCHIVE_EXT=%~x1
)ELSE (
	for %%i IN (*.archive ) do (
		SET ARCHIVE_PROFILE_FILE=%%~fi
		SET ARCHIVE_DRIVE=%%~di
		SET ARCHIVE_PATH=%%~dpi
		SET ARCHIVE_PROFILE=%%~ni
		SET ARCHIVE_EXT=%%~xi
	)
)
IF "%ARCHIVE_PROFILE%"=="" EXIT
REM DIR /AD /B /S >sample.archive.txt
IF NOT "%ARCHIVE_EXT%"==".archive" EXIT
CALL :ChangeDirectory "%ARCHIVE_PATH%"


REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
SET FILE_TYPE=7z
SET ARCHIVE_OPT_X=5
SET ARCHIVE_ROOT_DIR_NAME=%ARCHIVE_PROFILE%
ECHO SettingsOptions@%ARCHIVE_PROFILE%.cmd
IF EXIST %ARCHIVE_PATH%\SettingsOptions@%ARCHIVE_PROFILE%.cmd (
	TYPE %ARCHIVE_PATH%\SettingsOptions@%ARCHIVE_PROFILE%.cmd
	CALL %ARCHIVE_PATH%\SettingsOptions@%ARCHIVE_PROFILE%.cmd
)


REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
ECHO PROFILE: %ARCHIVE_PROFILE%
ECHO   1:Make Directory
ECHO   2:Remove empty Directory and Make Listfile
ECHO   3:Archive
SET /P A="-> "
IF 1 EQU %A% (CALL :MAKE_ARCHIVE_DIRECTORY)
IF 2 EQU %A% (
	CALL :REMOVE_EMPTY_DIR
	CALL :MAKE_LIST_FILE
)
IF 3 EQU %A% (
	CALL :REMOVE_EMPTY_DIR
	CALL :MAKE_LIST_FILE
	CALL :MAKE_7Z_FILE
)

CALL :Msg Finished
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:MAKE_ARCHIVE_DIRECTORY
	MD %ARCHIVE_ROOT_DIR_NAME%
	CD %ARCHIVE_ROOT_DIR_NAME%
	FOR /F "tokens=1,2 delims= " %%C IN (%ARCHIVE_PROFILE_FILE%) DO (
		IF %%D==1 MD %%C
	)
	EXIT /B

:REMOVE_EMPTY_DIR
	REM DIR /A:D /B > directory.list
	CALL :CheckDirectory %ARCHIVE_ROOT_DIR_NAME%
	CD %ARCHIVE_ROOT_DIR_NAME%
	FOR /F "tokens=1,2 delims= " %%C IN (%ARCHIVE_PROFILE_FILE%) DO (
		IF EXIST "%%C" (
			FOR /F "delims=" %%I IN ('DIR %%C /A:D/B/S ^| SORT /R') DO ( 
				ECHO RMDIR "%%I" 
				RMDIR "%%I" 
			)
			ECHO RMDIR "%%C" 
			RMDIR %%C
		)
	)
	cd ..

:MAKE_LIST_FILE
	TREE /F %ARCHIVE_ROOT_DIR_NAME% > %ARCHIVE_PROFILE%.txt
	COPY %ARCHIVE_PROFILE%.txt %ARCHIVE_PROFILE%@%yyyy%%mm%%dd%.txt
	7z a -tzip  %ARCHIVE_ROOT_DIR_NAME%\Settings@%ARCHIVE_PROFILE%.zip  %ARCHIVE_PATH%\SettingsOptions@%ARCHIVE_PROFILE%.cmd  %ARCHIVE_PROFILE_FILE% %ARCHIVE_PROFILE%@%yyyy%%mm%%dd%.txt
	DEL %ARCHIVE_PROFILE%@%yyyy%%mm%%dd%.txt
	EXIT /B

:MAKE_7Z_FILE
	IF NOT DEFINED OUTPUT_DIR (
		SET /P OUTPUT_DIR="Enter Output (E:, C:\Archives): "
	)
	REM SET /P ARCHIVE_PASSWORD="Password: "
	IF "%OUTPUT_DIR%"=="" SET OUTPUT_DIR=%DESKTOP_DIR%
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t%FILE_TYPE% %ARCHIVE_OPT_PW%  %OUTPUT_DIR%\%ARCHIVE_PROFILE%@%yyyy%%mm%%dd%.%FILE_TYPE% %ARCHIVE_ROOT_DIR_NAME% -mx=%ARCHIVE_OPT_X%
	EXIT /B
	
:ChangeDirectory
	IF EXIST %1 (
		CD /D %1
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0

:CheckDirectory
	IF EXIST %1 (
		ECHO Directory %1 is Exist.
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0

:Msg
	SET MSG=%1
	SET /P END=%MSG%
	EXIT /B

	