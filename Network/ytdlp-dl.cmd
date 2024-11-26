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
REM SET DLURL_LIST=%VIDEOS_DIR%\yt-dlp_%yyyy%%mm%%dd%-%hh%%mn%%ss%
REM SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp
REM SET YTDLP_CONFIG_FILE_DEFAULT=%VIDEOS_DIR%\%~n0.conf
REM SET YTDLP_DL_LIST_FILE=%~n1.txt
REM SET YTDLP_DL_LIST_FILE_EXP=%~n1.*.log
REM SET DLURL_HISTORY_DIR=%CONFIG_DIR%\yt-dlp
REM SET MODE=INPUT
REM SET MODE=FILE
REM SET SKIP_FLG=1
REM SET YT_DLP_LOG_DIR=%DOWNLOADS_DIR%\yt-dlp-log


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED VIDEO_OUTPUT_DIR SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp
IF NOT EXIST %VIDEO_OUTPUT_DIR% MD %VIDEO_OUTPUT_DIR%
IF NOT DEFINED YTDLP_CONFIG_FILE_DEFAULT SET YTDLP_CONFIG_FILE_DEFAULT=%VIDEOS_DIR%\%~n0.conf
REM IF NOT DEFINED YTDLP_CONFIG_FILE_DEFAULT SET YTDLP_CONFIG_FILE_DEFAULT=%VIDEOS_DIR%\yt-dlp.conf
IF NOT DEFINED YTDLP_DL_LIST_FILE_EXP SET YTDLP_DL_LIST_FILE_EXP=%~n1.*.log
IF NOT DEFINED YTDLP_DL_LIST_FILE SET YTDLP_DL_LIST_FILE=%~n1.txt
IF NOT DEFINED YTDLP_CONF_DIR SET YTDLP_CONF_DIR=%CONFIG_DIR%\tmp
IF NOT DEFINED DLURL_LIST SET DLURL_LIST=%YTDLP_CONF_DIR%\yt-dlp_%yyyy%%mm%%dd%-%hh%%mn%%ss%
IF NOT DEFINED YTDLP_CONFIG_FILE SET YTDLP_CONFIG_FILE=%DLURL_LIST%.dlp
IF NOT DEFINED SHUTDOWN_FLG (SET SHUTDOWN_FLG=0)
IF 1 EQU %SHUTDOWN_FLG% SET /P SHUTDOWN_FLG2="Shutdown? 1:YES 0:NO -> "
IF NOT DEFINED YTDLP_PROFILE (SET YTDLP_PROFILE=default)
IF NOT DEFINED DLURL_HISTORY_DIR SET DLURL_HISTORY_DIR=%CONFIG_DIR%\yt-dlp
IF NOT DEFINED YT_DLP_LOG_DIR SET YT_DLP_LOG_DIR=%DOWNLOADS_DIR%\yt-dlp-log
IF NOT DEFINED BATCH_MODE SET BATCH_MODE=0

IF NOT EXIST %YTDLP_CONF_DIR% MD %YTDLP_CONF_DIR%
SET DLURL_HISTORY_FILES=%DLURL_HISTORY_DIR%\*.log

IF "%BATCH_MODE%"=="ON" GOTO :DL_START_BATCH


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


:SET_SKIP_MODE
FINDSTR /C:"#SKIP_MODE_OFF" %YTDLP_CONFIG_FILE_DEFAULT%
IF ERRORLEVEL 1 (
	REM PASS
) ELSE (
	SET SKIP_FLG=0
	GOTO :SET_RESOLUTION
)
CHOICE /C 01 /T 1 /D 1 /M "SKIP MODE "
IF %ERRORLEVEL% EQU 1 (
	ECHO SKIP MODE OFF
	SET SKIP_FLG=0
) ELSE IF %ERRORLEVEL% EQU 2 (
	ECHO SKIP MODE ON
	SET SKIP_FLG=1
)
IF NOT DEFINED SKIP_FLG (SET SKIP_FLG=1)


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


:SET_MODE
FINDSTR /C:"INPUT_MODE" %YTDLP_CONFIG_FILE_DEFAULT%
IF ERRORLEVEL 1 (
	REM PASS
) ELSE (
	SET MODE=INPUT
	GOTO :DL_START_INPUT
)


:SET_INPUT_MODE
FOR %%i in (%YTDLP_DL_LIST_FILE_EXP%) DO (
	SET YTDLP_DL_LIST_FILE=%%i
)
CHOICE /C 123 /M "1:INPUT 2:FILE 3:BATCH"
IF %ERRORLEVEL% EQU 1 (
	SET MODE=INPUT
) ELSE IF %ERRORLEVEL% EQU 2 (
	SET MODE=FILE
	IF NOT EXIST %YTDLP_DL_LIST_FILE% SET /P YTDLP_DL_LIST_FILE="input txt: "
) ELSE IF %ERRORLEVEL% EQU 3 (
	SET MODE=FILE
	SET BATCH_ONLY=1
	MOVE %YTDLP_CONFIG_FILE% %DLURL_LIST%_batch.dlp
	SET YTDLP_CONFIG_FILE=%DLURL_LIST%_batch.dlp
	SET DLURL_LIST=%DLURL_LIST%_batch
	IF NOT EXIST %YTDLP_DL_LIST_FILE% SET /P YTDLP_DL_LIST_FILE="input txt: "
)
SET YTDLP_CONF_OPT=--config-location %YTDLP_CONFIG_FILE%
ECHO %MODE%

SET _YTDLP_DL_LIST_FILE=%YTDLP_DL_LIST_FILE:"=%
SET FILE_EXT=%_YTDLP_DL_LIST_FILE:~-7,-4%
SET FILE_EXT_LAST=%_YTDLP_DL_LIST_FILE:~-3%
IF "%FILE_EXT%"=="csv" (
	SET DLURL_LIST=%DLURL_LIST%.csv.txt
) ELSE (
	SET DLURL_LIST=%DLURL_LIST%.txt
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
	FINDSTR /C:"%DOWNLOAD_URL%" %DLURL_HISTORY_FILES%
	IF ERRORLEVEL 1 (
		ECHO Start DL %DOWNLOAD_URL%
	) ElSE (
		ECHO Skip: %DOWNLOAD_URL%
REM		GOTO :DL_START_INPUT
	)
)
CD /D %VIDEOS_DIR%
yt-dlp.exe %YTDLP_CONF_OPT% %YTDLP_RESOLUTION_OPT% %DOWNLOAD_URL%
GOTO :DL_END


:DL_START_FILE
IF EXIST %YTDLP_DL_LIST_FILE% COPY %YTDLP_DL_LIST_FILE% %DLURL_LIST%
IF NOT EXIST %DLURL_LIST% TYPE nul >%DLURL_LIST%
NOTEPAD %DLURL_LIST%

IF "%FILE_EXT_LAST%"=="log" (
	DEL %YTDLP_DL_LIST_FILE%
	DEL %YTDLP_PROFILE_FILE%
)

IF EXIST %YTDLP_CONF_DIR%\*.log SET DLURL_HISTORY_FILES=%DLURL_HISTORY_FILES% %YTDLP_CONF_DIR%\*.log
IF %SKIP_FLG%==0 ECHO #SKIP_MODE_OFF>>%YTDLP_CONFIG_FILE%
IF %SKIP_FLG%==1 (
	%TOOLS_DIR%\Network\strip_url.py %DLURL_LIST%
	MOVE url.txt %DLURL_LIST%
	type nul>%DLURL_LIST%.tmp
	FOR /F "tokens=1,2 delims=," %%i IN (%DLURL_LIST%) DO (
		FINDSTR /C:"%%j" %DLURL_HISTORY_FILES%
		IF ERRORLEVEL 1 (
			ECHO Start DL: %%i
			REM ECHO #Start DL: %%i>>%YTDLP_CONFIG_FILE%
			ECHO %%i>>%DLURL_LIST%.tmp
		) ELSE (
			ECHO Skip DL: %%i
			ECHO #Skip: %%i>>%YTDLP_CONFIG_FILE%
		)
	)
	IF EXIST %DLURL_LIST%.tmp MOVE %DLURL_LIST%.tmp %DLURL_LIST%
)
CD /D %VIDEOS_DIR%
MOVE %DLURL_LIST% %DLURL_LIST%.log

REM MAKE_BATCH_FILE
SET BATCH_FILE=%YTDLP_CONF_DIR%\yt-dlp-batch_%yyyy%%mm%%dd%.cmd
IF NOT EXIST %BATCH_FILE% (
	ECHO SET BATCH_MODE=ON>>%BATCH_FILE%
	REM ECHO SET MODE=BATCH>>%BATCH_FILE%
	ECHO CALL %USERPROFILE%\.Tools\Settings.cmd>>%BATCH_FILE%
	ECHO; >>%BATCH_FILE%
)
ECHO (SET SKIP_FLG=%SKIP_FLG%)>>%BATCH_FILE%
IF DEFINED RESOLUTION (
	ECHO SET YTDLP_RESOLUTION_OPT=-S "res:%RESOLUTION%">>%BATCH_FILE%
) ELSE (
	ECHO SET YTDLP_RESOLUTION_OPT=>>%BATCH_FILE%
)
ECHO CALL %TOOLS_DIR%\Network\ytdlp-dl.cmd %YTDLP_CONFIG_FILE% %DLURL_LIST%.log>>%BATCH_FILE%
ECHO REM yt-dlp.exe %YTDLP_CONF_OPT% %YTDLP_RESOLUTION_OPT% -a %DLURL_LIST%.log >>%BATCH_FILE%
ECHO; >>%BATCH_FILE%
IF DEFINED BATCH_ONLY (
	EXPLORER %YTDLP_CONF_DIR%
	EXIT /B
)
REM RUN
yt-dlp.exe %YTDLP_CONF_OPT% %YTDLP_RESOLUTION_OPT% -a %DLURL_LIST%.log
IF %ERRORLEVEL% EQU 0 (
	GOTO :DL_END
)
EXIT /B


:DL_START_BATCH
SET BATCH_LOG_FILE=%~n1.log
SET YTDLP_CONFIG_FILE=%~1
SET DLURL_LIST=%~2
ECHO BATCH_MODE %YTDLP_CONFIG_FILE% %DLURL_LIST%
IF NOT EXIST %YTDLP_CONFIG_FILE% EXIT /B
IF NOT EXIST %DLURL_LIST% EXIT /B
SET YTDLP_CONF_OPT=--config-location %YTDLP_CONFIG_FILE%
IF DEFINED RESOLUTION (
	SET YTDLP_RESOLUTION_OPT=-S "res:%RESOLUTION%"
)

IF %SKIP_FLG%==1 (
	%TOOLS_DIR%\Network\strip_url.py %DLURL_LIST%
	MOVE url.txt %DLURL_LIST%
	type nul>%DLURL_LIST%.tmp
	FOR /F "tokens=1,2 delims=," %%i IN (%DLURL_LIST%) DO (
		FINDSTR /C:"%%j" %DLURL_HISTORY_FILES%
		IF ERRORLEVEL 1 (
			ECHO Start DL: %%i
			REM ECHO #Start DL: %%i>>%YTDLP_CONFIG_FILE%
			ECHO %%i>>%DLURL_LIST%.tmp
		) ELSE (
			ECHO Skip DL: %%i
			ECHO #Skip: %%i>>%YTDLP_CONFIG_FILE%
		)
	)
	IF EXIST %DLURL_LIST%.tmp MOVE %DLURL_LIST%.tmp %DLURL_LIST%
)
yt-dlp.exe %YTDLP_CONF_OPT% %YTDLP_RESOLUTION_OPT% -a %DLURL_LIST% 2>%BATCH_LOG_FILE%
IF %ERRORLEVEL% EQU 0 (
	DEL %BATCH_LOG_FILE%
	GOTO :DL_END
)
EXIT /B


:CHECK_FORMAT
SET YTDLP_OPT=-v -F --list-subs
SET /P DOWNLOAD_URL="URL: "
REM SET /P FORMAT_OPTION="FORMAT_OPTION: "
yt-dlp.exe %YTDLP_OPT% %FORMAT_OPTION% %DOWNLOAD_URL%
GOTO :CHECK_FORMAT


:DL_END
IF NOT EXIST %YT_DLP_LOG_DIR% MD %YT_DLP_LOG_DIR%
IF EXIST %DLURL_LIST%.log MOVE %DLURL_LIST%.log %YT_DLP_LOG_DIR%\
IF EXIST %DLURL_LIST% MOVE %DLURL_LIST% %YT_DLP_LOG_DIR%\
IF EXIST %YTDLP_CONFIG_FILE% MOVE %YTDLP_CONFIG_FILE% %YT_DLP_LOG_DIR%\
IF 1 EQU %SHUTDOWN_FLG2% (SHUTDOWN /S /T 3)
EXIT /B

