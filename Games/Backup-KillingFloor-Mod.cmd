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
SET KILLINGFLOOR_DIR=%STEAM_LIBRARY_2%\KillingFloor
CALL :CheckDirectory %KILLINGFLOOR_DIR%\KF-SERVER
IF %ERRORLEVEL% EQU 1 (EXIT)
REM EXPLORER %KILLINGFLOOR_DIR%\KF-SERVER

SET /P ARCHIVE_ZMT="Archive KF-ZMT_SERVER? 1/0 -> "
IF "%ARCHIVE_ZMT%"=="" SET ARCHIVE_ZMT=0

SET /P ARCHIVE_ZMT_MAPS="Archive KF-ZMT_SERVER_MAPS? 1/0 -> "
IF "%ARCHIVE_ZMT_MAPS%"=="" SET ARCHIVE_ZMT_MAPS=0

IF %ARCHIVE_ZMT% EQU 1 (CALL :ArchiveKF KF-ZMT_SERVER)
IF %ARCHIVE_ZMT_MAPS% EQU 1 (CALL :ArchiveKF KF-ZMT_SERVER_MAPS)

PAUSE
EXPLORER %DOWNLOADS_DIR%
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:CheckDirectory
	IF EXIST %1 (
	ECHO Directory %1 is Exist.
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0

:ArchiveKF
	SET TARGET=%1%
	CALL :TREE_KF_SERVER %TARGET%
	CALL :CheckDirectory "%KILLINGFLOOR_DIR%\KF-SERVER\%TARGET%"
	7z a -t7z "%DOWNLOADS_DIR%\%TARGET%.7z" "%KILLINGFLOOR_DIR%\KF-SERVER\%TARGET%" -mx=9
	EXIT /B %ERRORLEVEL%

:TREE_KF_SERVER
	SET SERVER_NAME=%1
	CALL :CheckDirectory %KILLINGFLOOR_DIR%\KF-SERVER\%SERVER_NAME%
	CD /D %KILLINGFLOOR_DIR%\KF-SERVER
	TREE /F %SERVER_NAME% >%SERVER_NAME%\%SERVER_NAME%.txt
	NOTEPAD %SERVER_NAME%\%SERVER_NAME%.txt
	EXIT /B

