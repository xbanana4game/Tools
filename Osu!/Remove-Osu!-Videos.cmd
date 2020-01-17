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
REM 
REM ----------------------------------------------------------------------
CALL :ChangeDirectory %OSU_SONGS_DIR%
SET /P DELETE_SB_FILES="ストーリーボードを削除しますか? 1/0 -> "
IF ""=="%DELETE_SB_FILES%" SET DELETE_SB_FILES=0
SET /P DELETE_VIDEOS_FILES="動画を削除しますか? 1/0 -> "
IF ""=="%DELETE_VIDEOS_FILES%" SET DELETE_VIDEOS_FILES=0
SET /P DELETE_SOUNDS_FILES="効果音を削除しますか? 1/0 -> "
IF ""=="%DELETE_SOUNDS_FILES%" SET DELETE_SOUNDS_FILES=0
SET /P DELETE_PICTURES_FILES="画像を削除しますか? 1/0 -> "
IF ""=="%DELETE_PICTURES_FILES%" SET DELETE_PICTURES_FILES=0
SET /P ARCHIVE_SONGS_FILES="動画をアーカイブしますか? 1/0 -> "
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
:F_OSU_DELETE_SB
	CALL :ChangeDirectory %OSU_SONGS_DIR%
	SET CMD_EXE_FILE=%OSU_DIR%\Logs\RemoveOsu!SB@%yyyy%%mm%%dd%%hh%%mn%.cmd
	FOR /D %%i IN ("%OSU_SONGS_DIR%\*") DO (
	  CD /D "%%i"
	  FOR /D %%j IN ("*") DO (
		ECHO RMDIR /S /Q "%%i\%%j" >>%CMD_EXE_FILE%
	  )
	)
	CALL :F_FORFILES_INIT %CMD_EXE_FILE%
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
	SET /P DELETE_JPEG_FILES="JPEGファイルを削除しますか? 1/0 -> "
	IF ""=="%DELETE_JPEG_FILES%" SET DELETE_JPEG_FILES=0
	SET /P DELETE_PNG_FILES="PNGファイルを削除しますか? 1/0 -> "
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
	CALL :ChangeDirectory %OSU_SONGS_DIR%
	7z a -t7z -sdel %OSU_DIR%\SongsVideos@%yyyy%%mm%%dd%.7z -ir!%OSU_DIR%\Songs\*.mp4 -ir!%OSU_DIR%\Songs\*.avi
	EXIT /B
	
:F_FORFILES_INIT
	CALL :ChangeDirectory %OSU_SONGS_DIR%
	SET FORFILES_CMD_FILE=%1
	EXIT /B
	
REM CALL :F_FORFILES_EXT_DELETE [TARGET_EXT]
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

REM CALL :ChangeDirectory [Directory]
:ChangeDirectory
	IF EXIST %1 (
	  CD /D %1
	) ELSE (
	  SET /P ERR=フォルダ%1が存在しません
	  EXIT
	)
	EXIT /B 0

