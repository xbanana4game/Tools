@ECHO OFF
REM ----------------------------------------------------------------------
REM �ݒ�t�@�C���ǂݍ���
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd

IF NOT "%1"=="" (
	FOR %%i in (%*) DO (CALL :Archive_Directory %%~ni.7z %%i)
	EXPLORER %USERPROFILE%\Desktop
	EXIT
)
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF 1 EQU %SHUTDOWN_FLG% SET /P SHUTDOWN_FLG2="�A�[�J�C�u�쐬��V���b�g�_�E�����܂���? 1:YES 0:NO -> "
IF ""=="%SHUTDOWN_FLG2%" SET SHUTDOWN_FLG2=0
IF 1 EQU %ARCHIVE_UPLOAD_FLG% SET /P ARCHIVE_UPLOAD_FLG2="�A�b�v���[�h�t�H���_���A�[�J�C�u���܂����H 1:YES 0:NO -> "
IF ""=="%ARCHIVE_UPLOAD_FLG2%" SET ARCHIVE_UPLOAD_FLG2=0

REM ----------------------------------------------------------------------
REM �A�b�v���[�h
REM ----------------------------------------------------------------------
IF 1 EQU %ARCHIVE_UPLOAD_FLG2% (CALL :Archive_Upload)

REM ----------------------------------------------------------------------
REM �_�E�����[�h
REM ----------------------------------------------------------------------
CALL :Archive_Downloads

REM ----------------------------------------------------------------------
REM ���X�g�쐬
REM ----------------------------------------------------------------------
REM SET LIST_TXT=%ARCHIVE_DIR%\%yyyy%%mm%_%USERDOMAIN%.txt
REM IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD%
REM 7z l %ARCHIVE_OPT_PW% %DL_DIR%\*.7z >%LIST_TXT%
REM DEL %ARCHIVE_DIR%\%yyyy%%mm%_%USERDOMAIN%.txt.gpg
REM CALL :makeGpg %GPG_USER_ID% %ARCHIVE_DIR%\%yyyy%%mm%_%USERDOMAIN%.txt.gpg %ARCHIVE_DIR%\%yyyy%%mm%_%USERDOMAIN%.txt

REM ----------------------------------------------------------------------
REM �V���b�g�_�E������
REM ----------------------------------------------------------------------
IF 1 EQU %SHUTDOWN_FLG2% (SHUTDOWN /S /T 30)
EXPLORER %ARCHIVE_DIR%

EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM �_�E�����[�h
REM ----------------------------------------------------------------------
:Archive_Downloads
	SET DOWNLOAD_FILENAME=DL_%yyyy%%mm%%dd%_%USERDOMAIN%
	SET DL_DIR=%ARCHIVE_DIR%\%yyyy%%mm%
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t7z  -sdel %ARCHIVE_OPT_PW% %DL_DIR%\%DOWNLOAD_FILENAME%.7z %USERPROFILE%\Downloads\* -xr!desktop.ini -xr!�A�b�v���[�h -mx=%ARCHIVE_OPT_X%
	EXIT /B

REM ----------------------------------------------------------------------
REM �A�b�v���[�h�����֐�
REM ----------------------------------------------------------------------
:Archive_Upload
	SET UL_DIR=%ARCHIVE_DIR%\%yyyy%%mm%
	MD %UL_DIR%
	SET UPLOAD_FILENAME=UL_%yyyy%%mm%_%USERDOMAIN%
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t7z  -sdel %ARCHIVE_OPT_PW% %UL_DIR%\%UPLOAD_FILENAME%.7z %UPLOADS_DIR%\* -mx=%ARCHIVE_OPT_X%
	MD %UPLOADS_DIR%
	EXIT /B

:Archive_Directory
	SET OUT_NAME=%1
	SET IN=%2
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t7z  %ARCHIVE_OPT_PW% %USERPROFILE%\Desktop\%OUT_NAME% %IN% -mx=%ARCHIVE_OPT_X%
	EXIT /B

:makeGpg
	SET USER_ID=%1
	SET OUT_FILE=%2
	SET IN_FILE=%3
	gpg -e -r %USER_ID% -a -o %OUT_FILE% %IN_FILE%
	EXIT /B



