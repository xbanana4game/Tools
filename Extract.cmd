@ECHO OFF
REM ----------------------------------------------------------------------
REM �ݒ�t�@�C���ǂݍ���
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF "%1"=="" (
	SET /P YYYYMM="YYYYMM���w�肵�Ă������� default:%yyyy%%mm%->"
)
IF "%YYYYMM%"=="" SET YYYYMM=%yyyy%%mm%

IF "%1"=="" (
	FOR %%i IN ("%ARCHIVE_DIR%\%YYYYMM%\*.7z") DO 7z l -p%ARCHIVE_PASSWORD% %%i
) ELSE (
	FOR %%i in (%*) DO 7z l -p%ARCHIVE_PASSWORD% %%i
)
SET /P EXTRACT_EXT="�W�J����Ώۂ��w�肵�Ă�������(Default:*) -> "
IF "%EXTRACT_EXT%"=="" SET EXTRACT_EXT=*

IF "%1"=="" (
	FOR %%i IN ("%ARCHIVE_DIR%\%YYYYMM%\*.7z") DO CALL :Extract7z %%i %EXTRACT_EXT%
) ELSE (
	FOR %%i in (%*) DO (CALL :Extract7z %%i %EXTRACT_EXT%)
)
EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM �W�J CALL :Extract7z [TARGET] [EXT]
REM ----------------------------------------------------------------------
:Extract7z
	SET EXTRACT_FILE=%1
	SET EXTRACT_EXT=%2
	SET OUTPUT_DIR=%USERPROFILE%\Desktop
	7z x -p%ARCHIVE_PASSWORD% %EXTRACT_FILE% -o%OUTPUT_DIR%\* %EXTRACT_EXT% -r
	EXIT /B


