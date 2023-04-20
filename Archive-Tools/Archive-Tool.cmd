@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM --------------- Archive-Tool.cmd(SettingsOptions) --------------------
REM SET OUTPUT_DIR=%DESKTOP_DIR%
REM SET ARCHIVE_ROOT_DIR_NAME=%ARCHIVE_PROFILE%
REM SET FILE_TYPE=7z
REM SET ARCHIVE_OPT_X=5
REM SET ARCHIVE_PASSWORD=
REM SET STORE_PASSWORD=%ARCHIVE_PASSWORD%
REM SET REMOVE_EMPTY_DIR_FLG=1
REM SET BACKUPS_DIR=C:\Backups\7z
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
SET REMOVE_EMPTY_DIR_FLG=1
IF EXIST %ARCHIVE_PATH%\ArchiveOptions.cmd (
	TYPE %ARCHIVE_PATH%\ArchiveOptions.cmd
	NOTEPAD %ARCHIVE_PATH%\ArchiveOptions.cmd
	CALL %ARCHIVE_PATH%\ArchiveOptions.cmd
)

IF NOT DEFINED BACKUPS_DIR (SET /P BACKUPS_DIR="SET BACKUPS_DIR(C:\Backups\7z)=")
IF NOT DEFINED BACKUPS_DIR (SET BACKUPS_DIR=C:\Backups\7z)


REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF NOT EXIST %ARCHIVE_ROOT_DIR_NAME% (
	CALL :MAKE_ARCHIVE_DIRECTORY
	EXIT
)

ECHO ARCHIVE_PATH: %ARCHIVE_PATH%
ECHO PROFILE: %ARCHIVE_PROFILE%
ECHO   1:Make Directory
ECHO   2:Remove empty Directory and Make Listfile
ECHO   3:Archive(exclude __Store)
ECHO   4:Update (%BACKUPS_DIR%\%ARCHIVE_PROFILE%@????????.%FILE_TYPE%)
ECHO   5:Store Old Directory (_store, _old)
SET /P A="-> "
IF 1 EQU %A% (CALL :MAKE_ARCHIVE_DIRECTORY)
IF 2 EQU %A% (
	IF %REMOVE_EMPTY_DIR_FLG%==1 CALL :REMOVE_EMPTY_DIR
	CALL :MAKE_LIST_FILE
)
IF 3 EQU %A% (
	IF %REMOVE_EMPTY_DIR_FLG%==1 CALL :REMOVE_EMPTY_DIR
	CALL :MAKE_LIST_FILE
	CALL :MAKE_7Z_FILE
)
IF 4 EQU %A% (
	CALL :FIND_BACKUPS
	IF DEFINED BASE_ARCHIVE_FILE (
		CALL :UPDATE_7Z_FILE
	)
)
IF 5 EQU %A% (CALL :STORE_OLD_DIR)

PAUSE
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
	REM DIR /A:D /B > directory.txt
	CALL :ChangeDirectory %ARCHIVE_ROOT_DIR_NAME%
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
	EXIT /B
	
:STORE_OLD_DIR
	CALL :ChangeDirectory %ARCHIVE_ROOT_DIR_NAME%
	SET STORE_FILE=Store\%ARCHIVE_PROFILE%-Store@%yyyy%%mm%%dd%
	IF DEFINED STORE_PASSWORD SET ARCHIVE_OPT_PW=-p%STORE_PASSWORD% -mhe
	7z a -t7z %ARCHIVE_OPT_PW% -sdel %STORE_FILE%.7z -ir!_old\ -ir!_store\ -mx=0
	7z l %ARCHIVE_OPT_PW% %STORE_FILE%.7z >%STORE_FILE%.txt
	TYPE %STORE_FILE%.txt
	EXIT /B

:MAKE_LIST_FILE
	TREE /F /A %ARCHIVE_ROOT_DIR_NAME% > %ARCHIVE_PROFILE%.txt
	COPY %ARCHIVE_PROFILE%.txt %ARCHIVE_PROFILE%@%yyyy%%mm%%dd%.txt
	7z a -tzip  %ARCHIVE_ROOT_DIR_NAME%\Settings@%ARCHIVE_PROFILE%.zip  %ARCHIVE_PATH%\ArchiveOptions.cmd  %ARCHIVE_PROFILE_FILE% %ARCHIVE_PROFILE%@%yyyy%%mm%%dd%.txt
	DEL %ARCHIVE_PROFILE%@%yyyy%%mm%%dd%.txt
	EXIT /B

:MAKE_7Z_FILE
	IF NOT DEFINED OUTPUT_DIR (
		SET /P OUTPUT_DIR="SET OUTPUT_DIR=E:,C:\Archives,default:%BACKUPS_DIR%="
	)
	REM SET /P ARCHIVE_PASSWORD="SET ARCHIVE_PASSWORD="
	IF "%OUTPUT_DIR%"=="" SET OUTPUT_DIR=%BACKUPS_DIR%
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t%FILE_TYPE% %ARCHIVE_OPT_PW% %OUTPUT_DIR%\%ARCHIVE_PROFILE%@%yyyy%%mm%%dd%.%FILE_TYPE% %ARCHIVE_ROOT_DIR_NAME% -mx=%ARCHIVE_OPT_X% -xr!__Store
	EXIT /B
	
:FIND_BACKUPS
	CALL :CheckDirectory %BACKUPS_DIR%
	FOR %%i IN ("%BACKUPS_DIR%\%ARCHIVE_PROFILE%@????????.%FILE_TYPE%") DO (
		ECHO SET BASE_ARCHIVE_FILE=%%~ni>>a.cmd
		ECHO SET BASE_ARCHIVE_PATH=%%~fi>>a.cmd
	)
	IF EXIST a.cmd (
		NOTEPAD a.cmd
		CALL a.cmd
		DEL a.cmd
	) ELSE (
		ECHO "Backups File not Exist."
		PAUSE
	)
	EXIT /B

:UPDATE_7Z_FILE
	SET UPDATE_SWITCH_OPT=p0q3x2z0
	IF "%OUTPUT_DIR%"=="" SET OUTPUT_DIR=%BACKUPS_DIR%
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	IF NOT DEFINED BASE_ARCHIVE_FILE SET /P BASE_ARCHIVE_FILE="Base Archive File: "
	SET UPDATE_7Z_FILE=%OUTPUT_DIR%\%BASE_ARCHIVE_FILE%_-_Update-%yyyy%%mm%%dd%.7z
	7z u %ARCHIVE_OPT_PW% %BASE_ARCHIVE_PATH% -u- -u%UPDATE_SWITCH_OPT%!%UPDATE_7Z_FILE% %ARCHIVE_ROOT_DIR_NAME% -xr!__Store
	7z l %ARCHIVE_OPT_PW% %UPDATE_7Z_FILE% >%UPDATE_7Z_FILE%.txt
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


	