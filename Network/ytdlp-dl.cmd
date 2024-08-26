@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- ytdlp-dl.cmd(SettingsOptions.cmd) ----------
REM SET SHUTDOWN_FLG=0
REM SET YTDLP_PROFILE=default
REM SET DLURL_LIST=%VIDEOS_DIR%\yt-dlp_%yyyy%%mm%%dd%-%hh%%mn%%ss%.txt
REM SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp
REM SET YTDLP_CONFIG_FILE_DEFAULT=%VIDEOS_DIR%\%~n0.conf
REM SET YTDLP_DL_LIST_FILE=%DESKTOP_DIR%\dl.txt
REM SET DLURL_HISTORY_DIR=%VIDEOS_DIR%
REM SET MODE=INPUT
REM SET MODE=FILE
REM SET SKIP_FLG=1


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED YTDLP_CONFIG_FILE_DEFAULT SET YTDLP_CONFIG_FILE_DEFAULT=%VIDEOS_DIR%\yt-dlp.conf
IF NOT DEFINED YTDLP_CONFIG_FILE SET YTDLP_CONFIG_FILE=%DESKTOP_DIR%\yt-dlp_%yyyy%%mm%%dd%-%hh%%mn%%ss%.conf
IF NOT DEFINED YTDLP_DL_LIST_FILE SET YTDLP_DL_LIST_FILE=%DESKTOP_DIR%\dl.txt
IF NOT DEFINED DLURL_LIST SET DLURL_LIST=%DESKTOP_DIR%\yt-dlp_%yyyy%%mm%%dd%-%hh%%mn%%ss%.txt
IF NOT DEFINED SHUTDOWN_FLG (SET SHUTDOWN_FLG=0)
IF 1 EQU %SHUTDOWN_FLG% SET /P SHUTDOWN_FLG2="Shutdown? 1:YES 0:NO -> "
IF NOT DEFINED YTDLP_PROFILE (SET YTDLP_PROFILE=default)
IF NOT DEFINED VIDEO_OUTPUT_DIR SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp
IF NOT DEFINED DLURL_HISTORY_DIR SET DLURL_HISTORY_DIR=%CONFIG_DIR%\yt-dlp
CHOICE /C 01 /T 1 /D 1 /M "SKIP MODE "
IF %ERRORLEVEL% EQU 1 (
	ECHO SKIP MODE OFF
	SET SKIP_FLG=0
) ELSE IF %ERRORLEVEL% EQU 2 (
	ECHO SKIP MODE ON
	SET SKIP_FLG=1
)
IF NOT DEFINED SKIP_FLG (SET /P SKIP_FLG="SET SKIP_FLG(1)=")
IF NOT DEFINED SKIP_FLG (SET SKIP_FLG=1)
CHOICE /C 123 /T 5 /D 1 /M "1:INPUT 2:FILE 3:csv.txt "
IF %ERRORLEVEL% EQU 1 (
	SET MODE=INPUT
) ELSE IF %ERRORLEVEL% EQU 2 (
	SET MODE=FILE
) ELSE IF %ERRORLEVEL% EQU 3 (
	SET MODE=FILE
	SET /P YTDLP_DL_LIST_FILE="input csv.txt: "
	SET DLURL_LIST=%DESKTOP_DIR%\yt-dlp_%yyyy%%mm%%dd%-%hh%%mn%%ss%.csv.txt
)
ECHO %MODE%


:COPY_CONF
IF NOT "%1"=="" (
	SET YTDLP_PROFILE_FILE=%~1
	COPY %~1 %YTDLP_CONFIG_FILE_DEFAULT%
	REM NOTEPAD %YTDLP_CONFIG_FILE_DEFAULT%
) ELSE (
	SET YTDLP_PROFILE_FILE=yt-dlp.%YTDLP_PROFILE%.dlp
)
IF NOT EXIST %YTDLP_CONFIG_FILE_DEFAULT% (COPY %YTDLP_PROFILE_FILE% %YTDLP_CONFIG_FILE_DEFAULT%)
TYPE %YTDLP_CONFIG_FILE_DEFAULT%
COPY %YTDLP_CONFIG_FILE_DEFAULT% %YTDLP_CONFIG_FILE%
SET YTDLP_CONF_OPT=--config-location %YTDLP_CONFIG_FILE%


:SET_RESOLUTION
FINDSTR /C:"RESOLUTION" %YTDLP_CONFIG_FILE_DEFAULT%
IF ERRORLEVEL 1 (
	REM PASS
) ELSE (
	ECHO SELECT RESOLUTION
	ECHO youtube: 144 240 360 480 720 1080
	ECHO twitch : 160 360 480 720 720 1080
	SET /P RESOLUTION="-> "
)
IF DEFINED RESOLUTION (
	SET YTDLP_RESOLUTION_OPT=-S "res:%RESOLUTION%"
	ECHO #-S "res:%RESOLUTION%">>%YTDLP_CONFIG_FILE%
)
GOTO :DL_START_%MODE%


:DL_START_INPUT
SET DOWNLOAD_URL=
SET /P DOWNLOAD_URL="URL: "
%TOOLS_DIR%\Network\strip_url.py %DOWNLOAD_URL%
FOR /F "tokens=1,2 delims=," %%i IN (url.txt) DO (SET DOWNLOAD_URL=%%i)
ECHO URL:%DOWNLOAD_URL%
DEL url.txt
IF %SKIP_FLG%==1 (
	FINDSTR /C:"%DOWNLOAD_URL%" %DLURL_HISTORY_DIR%\*.log
	IF ERRORLEVEL 1 (
		ECHO Start DL %DOWNLOAD_URL%
	) ElSE (
		ECHO Skip: %DOWNLOAD_URL%
		GOTO :DL_START_INPUT
	)
)
yt-dlp.exe %YTDLP_CONF_OPT% %YTDLP_RESOLUTION_OPT% %DOWNLOAD_URL%
GOTO :DL_START_INPUT


:DL_START_FILE
IF EXIST %YTDLP_DL_LIST_FILE% COPY %YTDLP_DL_LIST_FILE% %DLURL_LIST%
IF NOT EXIST %DLURL_LIST% TYPE nul >%DLURL_LIST%
NOTEPAD %DLURL_LIST%
%TOOLS_DIR%\Network\strip_url.py %DLURL_LIST%
MOVE url.txt %DLURL_LIST%
IF %SKIP_FLG%==1 (
	type nul>%DLURL_LIST%.tmp
	FOR /F "tokens=1,2 delims=," %%i IN (%DLURL_LIST%) DO (
		FINDSTR /C:"%%i" %DLURL_HISTORY_DIR%\*.log
		IF ERRORLEVEL 1 (
			ECHO Start DL: %%i
			ECHO %%i>>%DLURL_LIST%.tmp
		) ELSE (
			ECHO Skip DL: %%i
		)
	)
	IF EXIST %DLURL_LIST%.tmp MOVE %DLURL_LIST%.tmp %DLURL_LIST%
)

CD %VIDEOS_DIR%
yt-dlp.exe %YTDLP_CONF_OPT% %YTDLP_RESOLUTION_OPT% -a %DLURL_LIST%

DEL %DLURL_LIST%
GOTO :DL_END


:DL_END
DEL %YTDLP_CONFIG_FILE%
IF 1 EQU %SHUTDOWN_FLG2% (SHUTDOWN /S /T 3)
EXIT
