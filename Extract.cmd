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

REM ----------------------------------------------------------------------
REM ���X�g�쐬
REM ----------------------------------------------------------------------
IF "%1"=="" (
	FOR %%i IN ("%ARCHIVE_DIR%\%YYYYMM%\*.7z") DO (
		7z l -p%ARCHIVE_PASSWORD% %%i
	)
) ELSE (
	SET LIST_TXT=
	FOR %%i IN (%*) DO (
		DEL %%~dpi\%%~ni_%USERDOMAIN%.txt
		7z l -p%ARCHIVE_PASSWORD% %%i >>%%~dpi\%%~ni_%USERDOMAIN%.txt
		NOTEPAD %%~dpi\%%~ni_%USERDOMAIN%.txt
		TYPE %%~dpi\%%~ni_%USERDOMAIN%.txt
	)
)

REM ----------------------------------------------------------------------
REM �W�J
REM ----------------------------------------------------------------------
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


