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

SET /P DELETE_SB_FILES="Remove StoryBoard? 1/0 -> "
IF ""=="%DELETE_SB_FILES%" SET DELETE_SB_FILES=0
SET /P DELETE_VIDEOS_FILES="Remove Videos? 1/0 -> "
IF ""=="%DELETE_VIDEOS_FILES%" SET DELETE_VIDEOS_FILES=0
SET /P DELETE_SOUNDS_FILES="Remove Sounds? 1/0 -> "
IF ""=="%DELETE_SOUNDS_FILES%" SET DELETE_SOUNDS_FILES=0
SET /P DELETE_PICTURES_FILES="Remove Images? 1/0 -> "
IF ""=="%DELETE_PICTURES_FILES%" SET DELETE_PICTURES_FILES=0
SET /P ARCHIVE_SONGS_FILES="Archive Files? 1/0 -> "
IF ""=="%ARCHIVE_SONGS_FILES%" SET ARCHIVE_SONGS_FILES=0

IF 1 EQU %DELETE_SB_FILES% (CALL :F_OSU_DELETE_SB)
IF 1 EQU %DELETE_VIDEOS_FILES% (CALL :F_OSU_DELETE_VIDEOS)
IF 1 EQU %DELETE_SOUNDS_FILES% (CALL :F_OSU_DELETE_SOUNDS)
IF 1 EQU %DELETE_PICTURES_FILES% (CALL :F_OSU_DELETE_PICTURES)
IF 1 EQU %ARCHIVE_SONGS_FILES% (CALL :F_OSU_ARCHIVE_FILES)
EXPLORER %OSU_DIR%\Logs
EXIT



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
:F_OSU_DELETE_SB
	CALL :F_FORFILES_INIT %OSU_DIR%\Logs\RemoveOsu!SB@%yyyy%%mm%%dd%%hh%%mn%.cmd
	CALL :F_FORDIR_DELETE
	FOR %%i IN (osb) DO CALL :F_FORFILES_EXT_DELETE %%i
	CALL :F_FORFILES_EXECUTE
	EXIT /B
	
:F_OSU_DELETE_SOUNDS
	CALL :F_FORFILES_INIT %OSU_DIR%\Logs\RemoveOsu!Sounds@%yyyy%%mm%%dd%%hh%%mn%.cmd
	FOR %%i IN (wav ogg) DO CALL :F_FORFILES_EXT_DELETE %%i
	CALL :F_FORFILES_EXECUTE
	EXIT /B

:F_OSU_DELETE_VIDEOS
	CALL :F_FORFILES_INIT %OSU_DIR%\Logs\RemoveOsu!Videos@%yyyy%%mm%%dd%%hh%%mn%.cmd
	FOR %%i IN (avi wmv flv mp4 mpge mpg) DO CALL :F_FORFILES_EXT_DELETE %%i
	CALL :F_FORFILES_EXECUTE
	EXIT /B
	
:F_OSU_DELETE_PICTURES
	CALL :F_FORFILES_INIT %OSU_DIR%\Logs\RemoveOsu!Pictures@%yyyy%%mm%%dd%%hh%%mn%.cmd
	SET /P DELETE_JPEG_FILES="Remove JPEG? 1/0 -> "
	IF ""=="%DELETE_JPEG_FILES%" SET DELETE_JPEG_FILES=0
	SET /P DELETE_PNG_FILES="Remove PNG? 1/0 -> "
	IF ""=="%DELETE_PNG_FILES%" SET DELETE_PNG_FILES=0
	IF 1 EQU %DELETE_PNG_FILES% (
	  FOR %%i IN (png) DO CALL :F_FORFILES_EXT_DELETE %%i
	)
	IF 1 EQU %DELETE_JPEG_FILES% (
	  FOR %%i IN (jpg jpeg) DO CALL :F_FORFILES_EXT_DELETE %%i
	)
	CALL :F_FORFILES_EXECUTE
	EXIT /B
	
:F_OSU_ARCHIVE_FILES
	CALL :F_FORFILES_INIT %OSU_DIR%\Logs\ArchiveOsu!Files@%yyyy%%mm%%dd%%hh%%mn%.list
	CALL :F_FORDIR_ARCHIVE
	FOR %%i IN (osb) DO CALL :F_FORFILES_EXT_ARCHIVE %%i
	FOR %%i IN (avi wmv flv mp4 mpge mpg wav ogg) DO CALL :F_FORFILES_EXT_ARCHIVE %%i
	CALL :F_FORFILES_ARCHIVE_EXECUTE
	EXIT /B
	
	
REM ----------------------------------------------------------------------
REM  DELETE
REM ----------------------------------------------------------------------
:F_FORFILES_INIT
	CALL :ChangeDirectory %OSU_SONGS_DIR%
	SET FORFILES_CMD_FILE=%1
	EXIT /B
	
:F_FORDIR_DELETE
	IF NOT DEFINED FORFILES_CMD_FILE EXIT /B
	FOR /D %%i IN ("%OSU_SONGS_DIR%\*") DO (
	  CD /D "%%i"
	  FOR /D %%j IN ("*") DO (
		ECHO RMDIR /S /Q "%%i\%%j" >>%FORFILES_CMD_FILE%
	  )
	)
	CALL :ChangeDirectory %OSU_SONGS_DIR%
	EXIT /B
	
	
:F_FORFILES_EXT_DELETE
	SET TARGET_EXT=%1
	IF NOT DEFINED FORFILES_CMD_FILE EXIT /B
	FORFILES /s /m *.%TARGET_EXT% /c "cmd /c ECHO DEL @path >>%FORFILES_CMD_FILE%"
	EXIT /B

:F_FORFILES_EXECUTE
	IF NOT DEFINED FORFILES_CMD_FILE EXIT /B
	IF NOT EXIST "%FORFILES_CMD_FILE%" EXIT /B
	NOTEPAD %FORFILES_CMD_FILE%
	CALL %FORFILES_CMD_FILE%
	MOVE %FORFILES_CMD_FILE% %FORFILES_CMD_FILE%.log
	EXIT /B
	


REM ----------------------------------------------------------------------
REM  ARCHIVE
REM ----------------------------------------------------------------------
:F_FORFILES_EXT_ARCHIVE
	SET TARGET_EXT=%1
	IF NOT DEFINED FORFILES_CMD_FILE EXIT /B
	FORFILES /s /m *.%TARGET_EXT% /c "cmd /c ECHO @path >>%FORFILES_CMD_FILE%"
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
	7z a -t7z -sdel %OSU_SONGS_DIR%\SongsFiles@%yyyy%%mm%%dd%%hh%%mn%.7z -spf2 @%FORFILES_CMD_FILE%
	MOVE %FORFILES_CMD_FILE% %FORFILES_CMD_FILE%.log
	7z l %OSU_SONGS_DIR%\SongsFiles@%yyyy%%mm%%dd%%hh%%mn%.7z >>%FORFILES_CMD_FILE%.log
	EXPLORER %OSU_SONGS_DIR%
	EXIT /B
	
	
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
:ChangeDirectory
	IF EXIST %1 (
		CD /D %1
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0

