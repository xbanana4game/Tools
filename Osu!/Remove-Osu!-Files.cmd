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
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
CALL :ChangeDirectory %OSU_SONGS_DIR%
CALL :F_OSU_ARCHIVE_FILES
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------		
:F_OSU_ARCHIVE_FILES
	CALL :F_FORFILES_INIT %OSU_DIR%\Logs\ArchiveOsu!Files@%yyyy%%mm%%dd%%hh%%mn%.list
	CALL :F_FORDIR_ARCHIVE
	FOR %%i IN (osb) DO CALL :F_FORFILES_EXT_ARCHIVE %%i
	FOR %%i IN (avi wmv flv mp4 mpge mpg wav) DO CALL :F_FORFILES_EXT_ARCHIVE %%i
	CALL :F_FORFILES_EXT_SIZE_ARCHIVE ogg 500000
	CALL :F_FORFILES_ARCHIVE_EXECUTE
	EXIT /B
	

REM ----------------------------------------------------------------------
REM  ARCHIVE
REM ----------------------------------------------------------------------
:F_FORFILES_INIT
	CALL :ChangeDirectory %OSU_SONGS_DIR%
	SET FORFILES_CMD_FILE=%1
	EXIT /B
	
:F_FORFILES_EXT_ARCHIVE
	SET TARGET_EXT=%1
	IF NOT DEFINED FORFILES_CMD_FILE EXIT /B
	FORFILES /s /m *.%TARGET_EXT% /c "cmd /c ECHO @path >>%FORFILES_CMD_FILE%"
	EXIT /B
	
:F_FORFILES_EXT_SIZE_ARCHIVE
	SET TARGET_EXT=%1
	SET TARGET_SIZE=%2
	IF NOT DEFINED FORFILES_CMD_FILE EXIT /B
	FORFILES /s /m *.%TARGET_EXT% /c "cmd /c IF @fsize LSS %TARGET_SIZE% ECHO @path >>%FORFILES_CMD_FILE%"
	EXIT /B

:F_FORDIR_ARCHIVE
	IF NOT DEFINED FORFILES_CMD_FILE EXIT /B
	FOR /D %%i IN ("%OSU_SONGS_DIR%\*") DO (
	  CD /D "%%i"
	  FOR /D %%j IN ("*") DO (
		ECHO "%%i\%%j" >>%FORFILES_CMD_FILE%
	  )
	)
	CALL :ChangeDirectory %OSU_SONGS_DIR%
	EXIT /B

:F_FORFILES_ARCHIVE_EXECUTE
	IF NOT DEFINED FORFILES_CMD_FILE EXIT /B
	IF NOT EXIST "%FORFILES_CMD_FILE%" EXIT /B
	TYPE %~dp0\skin.txt >>%FORFILES_CMD_FILE%
	NOTEPAD %FORFILES_CMD_FILE%
	7z a -t7z -sdel %OSU_SONGS_DIR%\..\SongsFiles@%yyyy%%mm%%dd%%hh%%mn%.7z -spf2 @%FORFILES_CMD_FILE%
	MOVE %FORFILES_CMD_FILE% %FORFILES_CMD_FILE%.log
	7z l %OSU_SONGS_DIR%\..\SongsFiles@%yyyy%%mm%%dd%%hh%%mn%.7z >>%FORFILES_CMD_FILE%.log
	EXPLORER %OSU_SONGS_DIR%\..
	EXIT /B
	
	
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
:ChangeDirectory
	IF EXIST %1 (
		CD /D %1
	) ELSE (
		ECHO Directory %1 is not Exist.
		PAUSE
		EXIT
	)
	EXIT /B 0

