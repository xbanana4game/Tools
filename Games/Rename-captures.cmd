@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd

SET CAPTURES_LIST_FILE=%TOOLS_DIR%\Games\captures.txt
IF NOT DEFINED CAPTURES_DIR (SET /P CAPTURES_DIR="SET CAPTURES_DIR(%VIDEOS_DIR%\Captures) : ")
IF ""=="%CAPTURES_DIR%" (
	SET CAPTURES_DIR=%VIDEOS_DIR%\Captures
)
MD %VIDEOS_DIR%\Captures
EXPLORER "%CAPTURES_DIR%"
CALL :CheckDirectory "%CAPTURES_DIR%"
IF %ERRORLEVEL% EQU 1 (
	PAUSE
	EXIT
)
ECHO ======================================================================
FOR /F "skip=1 tokens=1,2,3 delims=:" %%C IN (%CAPTURES_LIST_FILE%) DO (
	ECHO %%C : %%D
)
ECHO ======================================================================
IF NOT DEFINED CAPTURE_NO (SET /P CAPTURE_NO="SET CAPTURE_NO : ")
IF NOT DEFINED CAPTURE_NO (SET CAPTURE_NO=0)
FOR /F "skip=1 tokens=1,2,3 delims=:" %%C IN (%CAPTURES_LIST_FILE%) DO (
	IF %%C==%CAPTURE_NO% (
		SET GAME_NAME=%%D
		SET GAME_DIR=%%E
	)
)
IF NOT DEFINED GAME_NAME (SET /P GAME_NAME="SET GAME_NAME : ")
IF NOT DEFINED GAME_NAME (SET GAME_NAME=Unknown)
IF NOT DEFINED GAME_DIR (SET /P GAME_DIR="SET GAME_DIR : ")
IF NOT DEFINED GAME_DIR (SET GAME_DIR=Unknown)


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
MD "%CAPTURES_DIR%\%GAME_DIR%"
REM CALL :RENAME_ADD_DATE "%CAPTURES_DIR%"
FOR %%i IN ("%CAPTURES_DIR%\*.mp4") DO (
	ECHO RENAME "%%i" "%GAME_NAME% - %%~nxi"
	RENAME "%%i" "%GAME_NAME% - %%~nxi"
	MOVE "%CAPTURES_DIR%\%GAME_NAME% - %%~nxi" "%CAPTURES_DIR%\%GAME_DIR%\"
)

SET MP4_FILES_DIR=%CAPTURES_DIR%
SET IMG_OUTPUT_DIR=%PICTURES_DIR%\mp4img
SET FFMPGE_OPT_SS=1
SET END_FLG=1
CALL mp4img.cmd

PAUSE
EXPLORER "%CAPTURES_DIR%"
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
		ECHO Directory %1 is not Exist.
		EXIT /B 1
	)
	EXIT /B 0
	
:RENAME_ADD_DATE
	SET TARGET_DIR_NAME=%1%
	FOR %%i in (%TARGET_DIR_NAME%\*.mp4) DO (
		ECHO SET /A NUMBER=%%NUMBER%%+1 >>a.cmd
		ECHO SET F_DATE=%%~ti>>a.cmd
		ECHO SET F_YYYYMMDD_HHMM=%%F_DATE:~0,4%%-%%F_DATE:~5,2%%-%%F_DATE:~8,2%% %%F_DATE:~11,2%%-%%F_DATE:~14,2%%>>a.cmd
		
		REM %GAME_NAME%%%F_YYYYMMDD_HHMM%%%%~xi
		ECHO ECHO RENAME "%%~fi" "%GAME_NAME%%%F_YYYYMMDD_HHMM%%%%~xi" >>a.cmd
		ECHO RENAME "%%~fi" "%GAME_NAME%%%F_YYYYMMDD_HHMM%%%%~xi" >>a.cmd
	)
	IF EXIST a.cmd (
		CALL a.cmd
		DEL a.cmd
	)
	EXIT /B 0
	
