@ECHO OFF
REM ----------------------------------------------------------------------
REM �ݒ�t�@�C���ǂݍ���
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF NOT "%1"=="" (
	SET ARC_PROFILE_FILE=%1
	SET ARC_DRIVE=%~d1
	SET ARC_PROFILE=%~n1
	SET ARC_EXT=%~x1
)ELSE (
	for %%i IN (*.dir ) do (
	SET ARC_PROFILE_FILE=%%~fi
	SET ARC_DRIVE=%%~di
	SET ARC_PROFILE=%%~ni
	SET ARC_EXT=%%~xi
	)
)
IF "%ARC_PROFILE%"=="" EXIT
CD /D %ARC_DRIVE%

SET USE_JP=0
if %USE_JP%==1 (
  set USE_TOKEN=2
) else (
  set USE_TOKEN=1
)


REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
IF NOT "%ARC_EXT%"==".dir" EXIT
ECHO �f�B���N�g���[(%ARC_PROFILE%)
ECHO   1:�f�B���N�g���쐬
ECHO   2:��f�B���N�g���폜
ECHO   3:�A�[�J�C�u
SET /P A="-> "
IF 1 EQU %A% (CALL :mk_download)
IF 2 EQU %A% (CALL :tree_txt_download)
IF 3 EQU %A% (CALL :archive_download)
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM CALL :CheckDirectory [�f�B���N�g���[]
REM ----------------------------------------------------------------------
:CheckDirectory
	IF EXIST %1% (
	  ECHO "�t�H���_%1%������"
	) ELSE (
	  SET /P ERR="�t�H���_%1%�����݂��܂���"
	  EXIT
	)
	EXIT /B 0

REM ----------------------------------------------------------------------
REM CALL :mk_download
REM ----------------------------------------------------------------------
:mk_download
	MD %ARC_PROFILE%
	CD %ARC_PROFILE%
	FOR /F "tokens=%USE_TOKEN%,3 delims= " %%C IN (%ARC_PROFILE_FILE%) DO (
	IF %%D==1 MD %%C
	)
	EXIT /B


REM ----------------------------------------------------------------------
REM CALL :tree_txt_download
REM ----------------------------------------------------------------------
:tree_txt_download
	REM ----------------------------------------------------------------------
	REM directory.list�ɋL�q����Ă���f�B���N�g���Ƃ��̃T�u�f�B���N�g�����폜����i��f�B���N�g���̂݁j
	REM ----------------------------------------------------------------------
	REM DIR /A:D/B > directory.list
	CALL :CheckDirectory %ARC_PROFILE%
	cd %ARC_PROFILE%
	FOR /F "tokens=%USE_TOKEN% delims= " %%C IN (%ARC_PROFILE_FILE%) DO (
	  FOR /F "delims=" %%D IN ('DIR %%C /A:D/B/S ^| SORT /R') DO ( 
		RMDIR "%%D" 
	  )
	  RMDIR %%C
	)
	cd ..

	REM ----------------------------------------------------------------------
	REM �t�@�C���ꗗ���쐬
	REM ----------------------------------------------------------------------
	COPY %ARC_PROFILE_FILE% %ARC_PROFILE%
	TREE /F %ARC_PROFILE% > %ARC_PROFILE%\%ARC_PROFILE%.txt
	NOTEPAD %ARC_PROFILE%\%ARC_PROFILE%.txt
	EXIT /B


REM ----------------------------------------------------------------------
REM CALL :archive_download
REM ----------------------------------------------------------------------
:archive_download
	SET /P OUTPUT_DIR="�o�͐�(ex.E:): "
	SET /P PASSWORD="Password: "
	IF "%PASSWORD%"=="" (
		7z a -t7z %OUTPUT_DIR%\%ARC_PROFILE%@%yyyy%%mm%%dd%.7z %ARC_PROFILE% -mx=5
	) ELSE (
		7z a -t7z -p%PASSWORD% -mhe %OUTPUT_DIR%\%ARC_PROFILE%@%yyyy%%mm%%dd%.7z %ARC_PROFILE% -mx=5
	)
	
	EXIT /B

