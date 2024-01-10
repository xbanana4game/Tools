@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM --------------- Rename-captures.cmd(SettingsOptions.cmd) --------------
REM SET CAPTURES_DIR=%VIDEOS_DIR%\Captures
REM ----------------------------------------------------------------------


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SET CAPTURES_LIST_FILE=%TOOLS_DIR%\Games\captures.txt
IF NOT DEFINED CAPTURES_DIR (SET CAPTURES_DIR=%VIDEOS_DIR%\Captures)

MD %VIDEOS_DIR%\Captures
EXPLORER "%CAPTURES_DIR%"

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

MD "%CAPTURES_DIR%\%GAME_DIR%"
FOR %%i IN ("%CAPTURES_DIR%\*.mp4") DO (
	ECHO RENAME "%%i" "%GAME_NAME% - %%~nxi"
	RENAME "%%i" "%GAME_NAME% - %%~nxi"
	MOVE "%CAPTURES_DIR%\%GAME_NAME% - %%~nxi" "%CAPTURES_DIR%\%GAME_DIR%\"
)
FOR %%i IN ("%CAPTURES_DIR%\*.png") DO (
	MD "%PICTURES_DIR%\Captures\%GAME_DIR%\screenshots"
	ECHO RENAME "%%i" "%GAME_NAME% - %%~nxi"
	RENAME "%%i" "%GAME_NAME% - %%~nxi"
	MOVE "%CAPTURES_DIR%\%GAME_NAME% - %%~nxi" "%PICTURES_DIR%\Captures\%GAME_DIR%\screenshots\"
)

SET MP4_FILES_DIR=%CAPTURES_DIR%
SET IMG_OUTPUT_DIR=%PICTURES_DIR%\mp4img
SET FFMPGE_OPT_SS=1
SET END_FLG=1
CALL mp4img.cmd
Mp3tag.exe /fp:"%CAPTURES_DIR%"

TIMEOUT /T 2
EXIT

