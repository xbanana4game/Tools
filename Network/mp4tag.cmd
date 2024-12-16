@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- mp4tag.cmd(SettingsOptions.cmd) ----------
REM SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED VIDEO_OUTPUT_DIR SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp

CALL :EXEC_MP3TAG_DIRS %DESKTOP_DIR%
CALL :EXEC_MP3TAG_DIRS %VIDEO_OUTPUT_DIR%
CALL :EXEC_MP3TAG_DIR %JD2_DL%\Videos
PAUSE
CALL :EXEC_MP3TAG_DIR %DOWNLOADS_DIR%\youtube.com
CALL :EXEC_MP3TAG_DIR %DOWNLOADS_DIR%\xxx

EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:EXEC_MP3TAG_MP4
	IF EXIST %1\*.mp4 (
		ECHO %1
		Mp3tag.exe /fp:"%1"
	) ELSE (
		ECHO Directory %1 is not Exist.
		EXIT /B 1
	)
	EXIT /B 0
	
	
:EXEC_MP3TAG_DIR
	IF EXIST %1 (
		ECHO %1
		Mp3tag.exe /fp:"%1"
	) ELSE (
		ECHO Directory %1 is not Exist.
		EXIT /B 1
	)
	EXIT /B 0
	

:EXEC_MP3TAG_DIRS
	FOR /D %%i IN ("%1\*") DO (
		CALL :EXEC_MP3TAG_MP4 %%i
	)
	EXIT /B 0


