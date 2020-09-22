@ECHO OFF
REM ----------------------------------------------------------------------
REM 設定ファイル読み込み
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
SET /P B="Save Steam Screanshots? 1/0 -> "
IF ""=="%B%" SET B=0
CALL :CheckDirectory %STEAM_DIR%\userdata
FOR /F "tokens=1,2* delims=," %%i in (steam_screenshots.txt) do CALL :ArchiveScreenshots %%i %STEAM_DIR%\%%j
IF %B% EQU 1 CALL :7zScreenshots "%DOWNLOADS_DIR%\Steam-Screenshots-%yyyy%%mm%%dd%@%USERDOMAIN%.zip"
EXPLORER %DOWNLOADS_DIR%
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM ディレクトリーチェック
REM ----------------------------------------------------------------------
:CheckDirectory
	IF EXIST %1 (
		ECHO Directory %1 is Exist.
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
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
	7z a -tzip -sdel %OUT% %IN% -xr!thumbnails
	EXIT /B

REM ----------------------------------------------------------------------
REM :ArchiveScreenshots [GameName] [Scrennshots_DIR]
REM ----------------------------------------------------------------------
:ArchiveScreenshots
	SET GAME_NAME=%1%
	SET SS_DIR=%2%
	IF EXIST %SS_DIR% (
		CALL :Archive7z "%DOWNLOADS_DIR%\%GAME_NAME%-Screenshots-%yyyy%%mm%%dd%@%USERDOMAIN%.zip" %SS_DIR%
	)
	EXIT /B

REM ----------------------------------------------------------------------
REM :7zScreenshots [OUTPUT]
REM ----------------------------------------------------------------------
:7zScreenshots
	SET OUT=%1%
	CALL :CheckDirectory %STEAM_DIR%\userdata
	CD %STEAM_DIR%
	7z a -tzip %OUT% -ir!*\screenshots\*.jpg  -xr!thumbnails
	EXIT /B

