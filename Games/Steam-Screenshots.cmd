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
REM Factorio
REM ----------------------------------------------------------------------
SET /P B="Steam��Screanshots��ۑ����܂���? 1/0 -> "
IF ""=="%B%" SET B=0
CALL :CheckDirectory %STEAM_DIR%\userdata
FOR /F "tokens=1,2* delims=, " %%i in (steam_screenshots.txt) do CALL :ArchiveScreenshots %%i %STEAM_DIR%\%%j
IF %B% EQU 1 CALL :7zScreenshots "%DOWNLOADS_DIR%\Steam-Screenshsots-%yyyy%%mm%%dd%@%USERDOMAIN%.zip"
EXPLORER %DOWNLOADS_DIR%
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM �f�B���N�g���[�`�F�b�N
REM ----------------------------------------------------------------------
:CheckDirectory
	IF EXIST %1 (
	ECHO �t�H���_%1������
	) ELSE (
		SET /P ERR=�t�H���_%1�����݂��܂���
		EXIT
	)
	EXIT /B 0

REM ----------------------------------------------------------------------
REM Archive7z [Output EXE FILE NAME] [INPUT FILE]
REM ----------------------------------------------------------------------
:Archive7z
	SET OUT=%1%
	SET IN=%2%
	echo /P A="%OUT% %IN%"
	7z a -tzip -sdel %OUT% %IN%
	EXIT /B

REM ----------------------------------------------------------------------
REM :ArchiveScreenshots [GameName] [Scrennshots_DIR]
REM ----------------------------------------------------------------------
:ArchiveScreenshots
	SET GAME_NAME=%1%
	SET SS_DIR=%2%
	IF EXIST %SS_DIR% (
		CALL :Archive7z "%DOWNLOADS_DIR%\%GAME_NAME%-Screenshsots-%yyyy%%mm%%dd%@%USERDOMAIN%.zip" %SS_DIR% -xr!thumbnails
	)
	EXIT /B

REM ----------------------------------------------------------------------
REM :7zScreenshots [OUTPUT]
REM ----------------------------------------------------------------------
:7zScreenshots
	SET OUT=%1%
	CALL :CheckDirectory %STEAM_DIR%\userdata
	CD %STEAM_DIR%
	7z a -tzip %OUT% -ir!*\screenshots\*.jpg
	EXIT /B

