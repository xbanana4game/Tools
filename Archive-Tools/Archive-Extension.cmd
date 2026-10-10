@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
SET DRIVE_LETTER_FILE=%CD:~0,2%
SET DRIVE_LETTER_CMD=%~d0
REM x=[0 | 1 | 3 | 5 | 7 | 9 ] 
REM SET Z_OPT_X=0



REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED Z_OPT_X SET Z_OPT_X=0

CHOICE /C 01 /M "SDEL_FLG :"
IF %ERRORLEVEL% EQU 1 (
	REM SDEL_FLG :0
	SET SDEL_OPT=
) ELSE IF %ERRORLEVEL% EQU 2 (
	REM SDEL_FLG :1
	SET SDEL_OPT=-sdel
)

IF "%~x1" == ".7zext" (
	SET OUTPUT_DIR_NAME=%~n1-files
	SET TARGET_DIR=%~n1
	CALL :EXECUTE_ARCHIVE_EXT_SETTINGS_FROM_FILE %~1
) ELSE (
	SET OUTPUT_DIR_NAME=files
	CALL :EXECUTE_ARCHIVE_EXT
)
PAUSE
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:INPUT_SETTINGS
	IF NOT DEFINED ARCHIVE_PREFIX (SET /P ARCHIVE_PREFIX="Enter PREFIX: ")
	IF NOT DEFINED ARCHIVE_PREFIX (SET ARCHIVE_PREFIX=)
	IF NOT DEFINED ARCHIVE_EXT (SET /P ARCHIVE_EXT="Enter EXT: ")
	IF NOT DEFINED ARCHIVE_EXT (SET ARCHIVE_EXT=xxx)
	EXIT /B

:EXECUTE_ARCHIVE_EXT
	CALL :INPUT_SETTINGS

	SET OUTPUT_FILENAME=%ARCHIVE_PREFIX%_%ARCHIVE_EXT%-files
	IF "%ARCHIVE_PREFIX%"=="" SET OUTPUT_FILENAME=%ARCHIVE_EXT%-files

	IF NOT EXIST %OUTPUT_DIR_NAME% MD %OUTPUT_DIR_NAME%
	ECHO 7z a -tzip %SDEL_OPT% %OUTPUT_DIR_NAME%\%OUTPUT_FILENAME%.zip  %ARCHIVE_PREFIX%*.%ARCHIVE_EXT% -r -xr!Archive-Extension.cmd -xr!%OUTPUT_FILENAME%.zip -xr!%OUTPUT_FILENAME%.zip.txt -mx=%Z_OPT_X%
	7z a -tzip %SDEL_OPT% %OUTPUT_DIR_NAME%\%OUTPUT_FILENAME%.zip  %ARCHIVE_PREFIX%*.%ARCHIVE_EXT% -r -xr!Archive-Extension.cmd -xr!%OUTPUT_FILENAME%.zip -xr!%OUTPUT_FILENAME%.zip.txt -mx=%Z_OPT_X%
	7z l %OUTPUT_DIR_NAME%\%OUTPUT_FILENAME%.zip >%OUTPUT_DIR_NAME%\%OUTPUT_FILENAME%.zip.txt
	TYPE %OUTPUT_DIR_NAME%\%OUTPUT_FILENAME%.zip.txt
	EXIT /B

:EXECUTE_ARCHIVE_EXT_SETTINGS_FROM_FILE
	SET EXT_LIST_FILE=%1
	IF NOT EXIST "%TARGET_DIR%" (
		ECHO %TARGET_DIR% not exist.
		PAUSE
		EXIT
	)
	CD %TARGET_DIR%
	SET OUTPUT_DIR=%OUTPUT_DIR_NAME%
	FOR /F "skip=1 tokens=1,2,3 delims=;" %%C IN (%EXT_LIST_FILE%) DO (
		ECHO %%C %%D %%E
		IF %%C==1 (
			IF NOT EXIST %OUTPUT_DIR% MD %OUTPUT_DIR%
			ECHO 7z a -tzip %SDEL_OPT% %OUTPUT_DIR%\%%D %%E -r -xr!Archive-Extension.cmd -x!%OUTPUT_DIR_NAME% -xr!%%D -xr!%%D.txt -xr!.ts -mx=%Z_OPT_X%
			7z a -tzip %SDEL_OPT% %OUTPUT_DIR%\%%D %%E -r -xr!Archive-Extension.cmd -x!%OUTPUT_DIR_NAME% -xr!%%D -xr!%%D.txt -xr!.ts -mx=%Z_OPT_X%
			7z l %OUTPUT_DIR%\%%D >%OUTPUT_DIR%\%%D.txt
			TYPE %OUTPUT_DIR%\%%D.txt
			ECHO;
		)
	)
	EXIT /B

