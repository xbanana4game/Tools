@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
DIR /B %ARCHIVE_DIR%
IF "%1"=="" (
	SET /P YYYYMM="Select YYYYMM. default:%yyyy%%mm%->"
)
IF "%YYYYMM%"=="" SET YYYYMM=%yyyy%%mm%

REM ----------------------------------------------------------------------
REM Make list file
REM ----------------------------------------------------------------------
IF "%1"=="" (
	FOR %%i IN ("%ARCHIVE_DIR%\%YYYYMM%\*.7z") DO (
		7z l -p%ARCHIVE_PASSWORD% %%i
	)
) ELSE (
	FOR %%i IN (%*) DO (
		7z l -p%ARCHIVE_PASSWORD% %%i
	)
)

REM ----------------------------------------------------------------------
REM Extract 
REM ----------------------------------------------------------------------
SET /P EXTRACT_EXT="Enter Extract Target. (Default:*) -> "
IF "%EXTRACT_EXT%"=="" SET EXTRACT_EXT=*

IF "%1"=="" (
	FOR %%i IN ("%ARCHIVE_DIR%\%YYYYMM%\*.7z") DO CALL :Extract7zALL %%i %EXTRACT_EXT%
) ELSE (
	FOR %%i in (%*) DO (CALL :Extract7z %%i %EXTRACT_EXT%)
)
EXPLORER %EXTRACT_TARGET_DIR%

EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM CALL :Extract7z [TARGET] [EXT]
REM ----------------------------------------------------------------------
:Extract7z
	SET EXTRACT_FILE=%1
	SET EXTRACT_EXT=%2
	7z x -p%ARCHIVE_PASSWORD% %EXTRACT_FILE% -o%EXTRACT_TARGET_DIR%\* %EXTRACT_EXT% -r
	EXIT /B


:Extract7zALL
	SET EXTRACT_FILE=%1
	SET EXTRACT_EXT=%2
	7z x -p%ARCHIVE_PASSWORD% %EXTRACT_FILE% -o%EXTRACT_TARGET_DIR%\%YYYYMM% -aot %EXTRACT_EXT% -r
	EXIT /B

