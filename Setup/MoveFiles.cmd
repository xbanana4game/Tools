@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM if  called this batch from Archive.cmd ARCHIVE_FLG is 1. 
IF NOT DEFINED ARCHIVE_FLG (SET ARCHIVE_FLG=0)
REM ---------- MoveFiles.cmd(SettingsOptions) ----------
REM SET VIDEOS_STORE_DIR=%STORE_DIR%
REM SET XCOPY_XXX=1
REM SET MOVE_VIDEOS=1
REM SET COPY_VIDEOS=1
REM SET SAVE_STEAM_SS=1
REM SET SAVE_OSU_SS=1
REM SET XCOPY_DIRECTORY=E:\%USERDOMAIN%
REM SET XCOPY_DIRECTORY=\\NAS\Multimedia\Videos
REM SET XCOPY_DIRECTORY_VIDEOS=\\NAS\Multimedia\VD_%yyyy%%mm%%dd%
REM SET XCOPY_DIRECTORY_XXX=\\NAS\Multimedia\Videos

IF EXIST %USERPROFILE%\.Tools\MoveFiles-user.cmd (CALL %USERPROFILE%\.Tools\MoveFiles-user.cmd)
IF NOT DEFINED VIDEOS_STORE_DIR SET VIDEOS_STORE_DIR=%STORE_DIR%


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
SET ROBOCOPY_LOG=%DESKTOP_DIR%\robocopy-%yyyy%%mm%%dd%%hh%%mn%%ss%.log
ECHO Move Beatmap_Pack
CALL :MOVE_TARGET_FILES  %DOWNLOADS_DIR%\Games\Osu!\Beatmap_Pack %DOWNLOADS_DIR%\*Beatmap*.7z
CALL :MOVE_TARGET_FILES  %DOWNLOADS_DIR%\Games\Osu!\Beatmap_Pack %DOWNLOADS_DIR%\*Beatmap*.zip

IF "%XCOPY_XXX%"=="1" CALL :F_XCOPY_XXX
IF DEFINED MOVE_VIDEOS CALL :MOVE_VIDEOS
IF DEFINED SAVE_STEAM_SS CALL :SAVE_STEAM_SS
IF DEFINED SAVE_OSU_SS CALL :SAVE_OSU_SS
EXIT /B


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:MOVE_TARGET_FILES
	SET TARGET_DIR=%1
	SET TARGET_FILE=%2
	IF NOT EXIST %TARGET_FILE% EXIT /B
	MD %TARGET_DIR%
	MOVE %TARGET_FILE% %TARGET_DIR%\
	EXIT /B

:MOVE_VIDEOS
	ECHO MOVE VIDEOS %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%
	IF 1 EQU %ARCHIVE_FLG% (
		MD %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%
		IF EXIST %DOWNLOADS_DIR%\Captures MOVE %DOWNLOADS_DIR%\Captures %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\
		IF EXIST %DOWNLOADS_DIR%\youtube.com MOVE %DOWNLOADS_DIR%\youtube.com %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\
		FOR /D %%i IN ("%DOWNLOADS_DIR%\youtube.com*") DO (
			ECHO %%i
			MOVE %%i %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\
		)
		RMDIR %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%
		ECHO VD_%yyyy%%mm%%dd%
		IF EXIST %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd% EXPLORER %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%
		ECHO 1. Sort Album and make %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\mp3tag.m3u8
		CALL :RENAME_PLAYLIST_FILES
		PAUSE
		CALL :RENAME_PLAYLIST_FILES
		IF DEFINED COPY_VIDEOS CALL :COPY_VIDEOS
		EXIT /B
	)
	EXIT /B
	
:RENAME_PLAYLIST_FILES
		IF EXIST %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\mp3tag.m3u (
			nkf32.exe -w %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\mp3tag.m3u >%VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\VD_%yyyy%%mm%%dd%.m3u8
			DEL %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\mp3tag.m3u 
		)
		IF EXIST %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\youtube.com\mp3tag.m3u (
			nkf32.exe -w %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\youtube.com\mp3tag.m3u >%VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\youtube.com\VD_%yyyy%%mm%%dd%.m3u8
			DEL %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\youtube.com\mp3tag.m3u
		)
		IF EXIST %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\youtube.com\mp3tag.m3u8 (
			RENAME %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\mp3tag.m3u8 VD_%yyyy%%mm%%dd%.m3u8
		)
		IF EXIST %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\youtube.com\mp3tag.m3u8 (
			RENAME %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%\youtube.com\mp3tag.m3u8 VD_%yyyy%%mm%%dd%.m3u8
		)
		EXIT /B

:COPY_VIDEOS
	IF NOT DEFINED XCOPY_DIRECTORY_VIDEOS EXIT /B
	IF NOT EXIST %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd% EXIT /B
	IF 1 EQU %ARCHIVE_FLG% (
		CHOICE /C YN /T 3 /D Y /M "COPY VIDEOS %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd%?"
		IF %ERRORLEVEL% EQU 2 (EXIT /B)
		REM XCOPY %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd% %XCOPY_DIRECTORY%\VD_%yyyy%%mm%%dd%\ /Y /H /S /E /F /K
		ROBOCOPY %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd% %XCOPY_DIRECTORY_VIDEOS% /e /r:3 /w:10 /log+:%ROBOCOPY_LOG% /v /fp /tee
		REM ROBOCOPY %VIDEOS_STORE_DIR%\VD_%yyyy%%mm%%dd% %XCOPY_DIRECTORY%\VD_%yyyy%%mm%%dd%\ /z /e /r:3 /w:10 /log+:%ROBOCOPY_LOG% /v /fp /np /tee
	IF %ERRORLEVEL% EQU 8 (
		NOTEPAD %ROBOCOPY_LOG%
	) ELSE (
		EXPLORER %XCOPY_DIRECTORY_VIDEOS%
	)
		DEL %ROBOCOPY_LOG%
	)
	EXIT /B
	
:SAVE_STEAM_SS
	ECHO ARCHIVE STEAM SS
	IF 0 EQU %ARCHIVE_FLG% (
		EXIT /B
	)
	IF NOT DEFINED SAVE_STEAM_SS_EXECUTE (SET /P SAVE_STEAM_SS_EXECUTE="SET SAVE_STEAM_SS_EXECUTE(0)=")
	IF NOT DEFINED SAVE_STEAM_SS_EXECUTE (SET SAVE_STEAM_SS_EXECUTE=0)
	IF 1 EQU %SAVE_STEAM_SS_EXECUTE% (
		CALL Steam-Screenshots.cmd
		PAUSE
	)
	EXIT /B

:SAVE_OSU_SS
	ECHO SAVE OSU SS
	IF 0 EQU %ARCHIVE_FLG% (
		EXIT /B
	)
	IF NOT DEFINED SAVE_OSU_SS_EXECUTE (SET /P SAVE_OSU_SS_EXECUTE="SET SAVE_OSU_SS_EXECUTE(0)=")
	IF NOT DEFINED SAVE_OSU_SS_EXECUTE (SET SAVE_OSU_SS_EXECUTE=0)
	IF 1 EQU %SAVE_OSU_SS_EXECUTE% (
		CALL %TOOLS_DIR%\Osu!\Archive-Osu!-Screenshot.cmd
		PAUSE
	)
	EXIT /B

:F_XCOPY_XXX
	IF NOT DEFINED XCOPY_DIRECTORY_XXX SET XCOPY_DIRECTORY_XXX=%XCOPY_DIRECTORY%\xxx
	IF NOT EXIST %DOWNLOADS_DIR%\xxx EXIT /B
	SET TARGET_XXX_FILE=*5star* *4star* *3star*
	IF 1 EQU %ARCHIVE_FLG% (
		ROBOCOPY %DOWNLOADS_DIR%\xxx %XCOPY_DIRECTORY_XXX% %TARGET_XXX_FILE% /e /r:3 /w:10 /log+:%ROBOCOPY_LOG% /v /fp /tee
		REM ROBOCOPY %DOWNLOADS_DIR%\xxx %XCOPY_DIRECTORY_XXX%\xxx_%yyyy%%mm%%dd% *4star* /z /e /r:3 /w:10 /log+:%ROBOCOPY_LOG% /v /fp /np /tee
		IF %ERRORLEVEL% EQU 8 (
			NOTEPAD %ROBOCOPY_LOG%
		) ELSE (
			EXPLORER %XCOPY_DIRECTORY_XXX%
		)
		DEL %ROBOCOPY_LOG%
	)
	EXIT /B

