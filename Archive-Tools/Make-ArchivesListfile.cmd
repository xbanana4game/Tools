@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM Make list file
REM ----------------------------------------------------------------------
FOR /D %%j IN ("%ARCHIVE_DIR%\*") DO (
	IF NOT EXIST %ARCHIVE_DIR%\%%~nj_%USERDOMAIN%.txt (
		ECHO %%j
		FOR %%i IN ("%%j\*.7z") DO (
			ECHO %%i
			7z l -p%ARCHIVE_PASSWORD% %%i >>%ARCHIVE_DIR%\%%~nj_%USERDOMAIN%.txt
		)
	)
)

PAUSE
EXPLORER %ARCHIVE_DIR%

