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
IF "%~x1" == ".7zext" (
	CALL :EXECUTE_ARCHIVE_EXT_SETTINGS_FROM_FILE %~1
) ELSE (
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

	7z a -t7z -sdel %OUTPUT_FILENAME%.7z  %ARCHIVE_PREFIX%*.%ARCHIVE_EXT% -r -xr!Archive-Extension.cmd
	7z l %OUTPUT_FILENAME%.7z >%OUTPUT_FILENAME%.txt
	TYPE %OUTPUT_FILENAME%.txt
	EXIT /B

:EXECUTE_ARCHIVE_EXT_SETTINGS_FROM_FILE
	SET EXT_LIST_FILE=%1
	FOR /F "skip=1 tokens=1,2 delims= " %%C IN (%EXT_LIST_FILE%) DO (
		ECHO 7z a -t7z -sdel %%C  %%D -r -xr!Archive-Extension.cmd -xr!%%C -xr!%%C.txt
		7z a -t7z -sdel %%C  %%D -r -xr!Archive-Extension.cmd -xr!%%C -xr!%%C.txt
		7z l %%C >%%C.txt
		TYPE %%C.txt
	)
	EXIT /B

