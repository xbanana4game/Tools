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
REM SET YTDLP_CONFIG_FILE=%VIDEOS_DIR%\yt-dlp.conf
REM SET YTDLP_CONFIG_FILE=%CONFIG_DIR%\%~n0.conf
REM SET DLURL_HISTORY_DIR=%VIDEOS_DIR%


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF DEFINED YTDLP_CONFIG_FILE (SET YTDLP_CONF_OPT=--config-location %YTDLP_CONFIG_FILE%)

IF NOT DEFINED YTDLP_CONFIG_FILE SET YTDLP_CONFIG_FILE=%VIDEOS_DIR%\yt-dlp.conf
IF NOT DEFINED DLURL_LIST SET DLURL_LIST=%VIDEOS_DIR%\yt-dlp_%yyyy%%mm%%dd%-%hh%%mn%%ss%.txt
IF NOT DEFINED SHUTDOWN_FLG (SET SHUTDOWN_FLG=0)
IF 1 EQU %SHUTDOWN_FLG% SET /P SHUTDOWN_FLG2="Shutdown? 1:YES 0:NO -> "
IF NOT DEFINED YTDLP_PROFILE (SET YTDLP_PROFILE=default)
IF NOT DEFINED VIDEO_OUTPUT_DIR SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp
IF NOT DEFINED DLURL_HISTORY_DIR SET DLURL_HISTORY_DIR=%VIDEOS_DIR%

:COPY_CONF
IF NOT "%1"=="" (
	SET YTDLP_PROFILE_FILE=%~1
	COPY %~1 %YTDLP_CONFIG_FILE%
	NOTEPAD %YTDLP_CONFIG_FILE%
) ELSE (
	SET YTDLP_PROFILE_FILE=yt-dlp.%YTDLP_PROFILE%.dlp
)
IF NOT EXIST %YTDLP_CONFIG_FILE% (COPY %YTDLP_PROFILE_FILE% %YTDLP_CONFIG_FILE%)
TYPE %YTDLP_CONFIG_FILE%

:DL_START
ECHO;>>%DLURL_LIST%
NOTEPAD %DLURL_LIST%
FOR /F %%i IN (%DLURL_LIST%) DO (
	FINDSTR /C:"%%i" %DLURL_HISTORY_DIR\*.log
	IF ERRORLEVEL 1 (
		ECHO Start DL: %%i
		ECHO %%i>>%DLURL_LIST%.tmp
	) ELSE (
		ECHO Skip DL: %%i>>"%DLURL_HISTORY_DIR%\history.log"
	)
)
IF EXIST %DLURL_LIST%.tmp MOVE %DLURL_LIST%.tmp %DLURL_LIST%

CD %VIDEOS_DIR%
yt-dlp.exe %YTDLP_CONF_OPT% -a %DLURL_LIST%

TYPE %DLURL_LIST% >>"%DLURL_HISTORY_DIR%\history.log"
ECHO;>>"%DLURL_HISTORY_DIR%\history.log"
DEL %DLURL_LIST%

:DL_END
EXPLORER %VIDEO_OUTPUT_DIR%
REM Mp3tag.exe /fp:"%VIDEOS_DIR%\yt-dlp"
IF 1 EQU %SHUTDOWN_FLG2% (SHUTDOWN /S /T 3)

EXIT
