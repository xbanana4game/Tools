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

ECHO Mp3tag Filter: title PRESENT
REM CALL :EXEC_MP3TAG_DIRS %DESKTOP_DIR%
CALL :EXEC_MP3TAG_DIRS %VIDEO_OUTPUT_DIR%
CALL :EXEC_MP3TAG_DIR %JD2_DL%\Videos
CHOICE /C YN /T 10 /D N /M "Continue?"
IF %ERRORLEVEL% EQU 2 EXIT
CALL :EXEC_MP3TAG_DIR %DOWNLOADS_DIR%\youtube.com
CALL :EXEC_MP3TAG_DIRS %DOWNLOADS_DIR%\xxx
CALL :EXEC_MP3TAG_DIRS %DOWNLOADED_VIDEOS_DIR%\xxx
REM PAUSE
REM CALL :EXEC_MP3TAG_DIR \\%NASDOMAIN%\Multimedia\Videos

EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:IS_EXIST_MP4
	FOR /R %1 %%i IN (*.mp4 *.webm *.m4a) DO EXIT /B 0
	EXIT /B 1
	
	
:EXEC_MP3TAG_MP4
	CALL :IS_EXIST_MP4 %1
	IF %ERRORLEVEL% EQU 0 (
		ECHO %1
		Mp3tag.exe /fp:"%1"
	) ELSE (
		ECHO video file is not exist. %1
		EXIT /B 1
	)
	EXIT /B 0
	
	
:EXEC_MP3TAG_DIR
	IF NOT EXIST %1 (
		ECHO Directory %1 is not exist.
		EXIT /B 1
	)
	CALL :EXEC_MP3TAG_MP4 %1
	EXIT /B 0
	

:EXEC_MP3TAG_DIRS
	IF NOT EXIST %1 (
		ECHO Directory %1 is not exist.
		EXIT /B 1
	)
	FOR /D %%i IN ("%1\*") DO (
		CALL :EXEC_MP3TAG_MP4 %%i
	)
	EXIT /B 0


