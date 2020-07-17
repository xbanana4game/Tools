@ECHO OFF
REM ----------------------------------------------------------------------
REM 設定ファイル読み込み
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
CALL :CheckDirectory %KILLINGFLOOR_DIR%\KF-SERVER
IF %ERRORLEVEL% EQU 1 (EXIT)
SET /P ARCHIVE_ZMT="Archive KF-ZMT_SERVER? 1/0 -> "
SET /P ARCHIVE_ZMT_MAPS="Archive KF-ZMT_SERVER_MAPS? 1/0 -> "

SET /P TREE_KF_FLG="Execute TREE? 1/0 -> "
IF 1 EQU %TREE_KF_FLG% (
  EXPLORER %KILLINGFLOOR_DIR%\KF-SERVER
  CALL :TREE_KF_SERVER
)

IF %ARCHIVE_ZMT% EQU 1 CALL :ArchiveKF KF-ZMT_SERVER
IF %ARCHIVE_ZMT_MAPS% EQU 1 CALL :ArchiveKF KF-ZMT_SERVER_MAPS

EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM CALL :CheckDirectory [ディレクトリー]
REM ----------------------------------------------------------------------
:CheckDirectory
	IF EXIST %1 (
	ECHO Directory %1 is Exist.
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0

REM ----------------------------------------------------------------------
REM CALL :ArchiveKF [TARGET]
REM ----------------------------------------------------------------------
:ArchiveKF
	SET TARGET=%1%
	CALL :CheckDirectory "%KILLINGFLOOR_DIR%\KF-SERVER\%TARGET%"
	7z a -t7z "%DOWNLOADS_DIR%\%TARGET%.7z" "%KILLINGFLOOR_DIR%\KF-SERVER\%TARGET%" -mx=9
	EXIT /B %ERRORLEVEL%

REM ----------------------------------------------------------------------
REM CALL :TREE_KF_SERVER
REM ----------------------------------------------------------------------
:TREE_KF_SERVER
	CALL :CheckDirectory %KILLINGFLOOR_DIR%\KF-SERVER
	CD /D %KILLINGFLOOR_DIR%\KF-SERVER

	SET SERVER_NAME=KF-ZMT_SERVER
	TREE /F %SERVER_NAME% >%SERVER_NAME%\%SERVER_NAME%.txt
	NOTEPAD %SERVER_NAME%\%SERVER_NAME%.txt

	SET SERVER_NAME=KF-ZMT_SERVER_MAPS
	TREE /F %SERVER_NAME% >%SERVER_NAME%\%SERVER_NAME%.txt
	NOTEPAD %SERVER_NAME%\%SERVER_NAME%.txt
	EXIT /B

