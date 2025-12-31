@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
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
	7z a -tzip %SDEL_OPT% %OUTPUT_DIR_NAME%\%OUTPUT_FILENAME%.zip  %ARCHIVE_PREFIX%*.%ARCHIVE_EXT% -r -xr!Archive-Extension.cmd -xr!%OUTPUT_FILENAME%.zip -xr!%OUTPUT_FILENAME%.zip.txt -mx=0
	7z l %OUTPUT_DIR_NAME%\%OUTPUT_FILENAME%.zip >%OUTPUT_DIR_NAME%\%OUTPUT_FILENAME%.zip.txt
	TYPE %OUTPUT_DIR_NAME%\%OUTPUT_FILENAME%.zip.txt
	EXIT /B

:EXECUTE_ARCHIVE_EXT_SETTINGS_FROM_FILE
	SET EXT_LIST_FILE=%1
	CD %TARGET_DIR%
	SET OUTPUT_DIR=%OUTPUT_DIR_NAME%
	FOR /F "skip=1 tokens=1,2,3 delims=;" %%C IN (%EXT_LIST_FILE%) DO (
		ECHO %%C %%D %%E
		IF %%C==1 (
			IF NOT EXIST %OUTPUT_DIR% MD %OUTPUT_DIR%
			7z a -tzip %SDEL_OPT% %OUTPUT_DIR%\%%D %%E -r -xr!Archive-Extension.cmd -x!%OUTPUT_DIR_NAME% -xr!%%D -xr!%%D.txt -xr!.ts -mx=0
			7z l %OUTPUT_DIR%\%%D >%OUTPUT_DIR%\%%D.txt
			TYPE %OUTPUT_DIR%\%%D.txt
		)
	)
	EXIT /B

