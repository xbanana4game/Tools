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
IF NOT DEFINED SDEL_FLG (SET /P SDEL_FLG="Enter SDEL_FLG 1/0(default:0): ")
IF "%SDEL_FLG%"=="1" (SET SDEL_OPT=-sdel)

IF "%~x1" == ".7zext" (
	SET OUTPUT_DIR_NAME=%~n1-files
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

	MD %OUTPUT_DIR_NAME%
	7z a -tzip %SDEL_OPT% %OUTPUT_DIR_NAME%\%OUTPUT_FILENAME%.zip  %ARCHIVE_PREFIX%*.%ARCHIVE_EXT% -r -xr!Archive-Extension.cmd -xr!%OUTPUT_FILENAME%.zip -xr!%OUTPUT_FILENAME%.zip.txt -mx=0
	7z l %OUTPUT_DIR_NAME%\%OUTPUT_FILENAME%.zip >%OUTPUT_DIR_NAME%\%OUTPUT_FILENAME%.zip.txt
	TYPE %OUTPUT_DIR_NAME%\%OUTPUT_FILENAME%.zip.txt
	EXIT /B

:EXECUTE_ARCHIVE_EXT_SETTINGS_FROM_FILE
	SET EXT_LIST_FILE=%1
	FOR /F "skip=1 tokens=1,2 delims=;" %%C IN (%EXT_LIST_FILE%) DO (
		MD %OUTPUT_DIR_NAME%
		7z a -tzip %SDEL_OPT% %OUTPUT_DIR_NAME%\%%C  %%D -r -xr!Archive-Extension.cmd -xr!%%C -xr!%%C.txt -mx=0
		7z l %OUTPUT_DIR_NAME%\%%C >%OUTPUT_DIR_NAME%\%%C.txt
		TYPE %OUTPUT_DIR_NAME%\%%C.txt
	)
	EXIT /B

