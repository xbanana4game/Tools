@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
SETLOCAL ENABLEDELAYEDEXPANSION
SET DRIVE_LETTER_FILE=%CD:~0,2%
SET DRIVE_LETTER_CMD=%~d0
REM ---------- ytdlp-dl.cmd(SettingsOptions.cmd) ----------
REM SET SHUTDOWN_FLG=0
REM SET YTDLP_PROFILE=default
REM SET YTDLP_CONF_DIR=%CONFIG_DIR%\yt-dlp
REM SET DLURL_LIST_DIR=%YTDLP_CONF_DIR%
REM SET DLURL_LIST_NAME=_%yyyy%-%mm%-%dd%_T%hh%%mn%%ss%_%~n1
REM SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp
REM SET YTDLP_DL_LIST_FILE=%~n1.txt
REM SET YTDLP_DL_LIST_FILE_EXP=%~n1.*.log
REM SET YTDLP_DL_LIST_FILE_EXP=%DESKTOP_DIR%\*.csv.txt
REM SET DLURL_HISTORY_DIR=%CONFIG_DIR%\yt-dlp-history
REM SET DLURL_HISTORY_FILES=%DLURL_HISTORY_DIR%\*.log
REM SET MODE=INPUT
REM SET MODE=FILE
REM SET SKIP_FLG=1
REM SET YT_DLP_LOG_DIR=%DOWNLOADS_DIR%\yt-dlp-log



REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED END_FILE_EXT SET END_FILE_EXT=end
IF NOT DEFINED VIDEO_OUTPUT_DIR SET VIDEO_OUTPUT_DIR=%USERPROFILE%\Videos\yt-dlp
IF NOT EXIST %VIDEO_OUTPUT_DIR% MD %VIDEO_OUTPUT_DIR%
IF NOT DEFINED YTDLP_DL_LIST_FILE_EXP SET YTDLP_DL_LIST_FILE_EXP=%~n1.*.%END_FILE_EXT%
IF NOT DEFINED YTDLP_DL_LIST_FILE SET YTDLP_DL_LIST_FILE=%~n1.txt
IF NOT DEFINED YTDLP_CONF_DIR SET YTDLP_CONF_DIR=%CONFIG_DIR%\yt-dlp
IF NOT DEFINED DLURL_LIST_DIR SET DLURL_LIST_DIR=%YTDLP_CONF_DIR%
IF NOT DEFINED DLURL_LIST_NAME SET DLURL_LIST_NAME=_%yyyy%-%mm%-%dd%_T%hh%%mn%%ss%_%~n1
IF NOT DEFINED DLURL_LIST SET DLURL_LIST=%DLURL_LIST_DIR%\%DLURL_LIST_NAME%
IF NOT DEFINED YTDLP_CONFIG_FILE SET YTDLP_CONFIG_FILE=%DLURL_LIST%.dlp
IF NOT DEFINED SHUTDOWN_FLG (SET SHUTDOWN_FLG=0)
IF 1 EQU %SHUTDOWN_FLG% SET /P SHUTDOWN_FLG2="Shutdown? 1:YES 0:NO -> "
IF NOT DEFINED YTDLP_PROFILE (SET YTDLP_PROFILE=default)
IF NOT DEFINED DLURL_HISTORY_DIR SET DLURL_HISTORY_DIR=%CONFIG_DIR%\yt-dlp-history
IF NOT DEFINED DLURL_HISTORY_FILES SET DLURL_HISTORY_FILES=%DLURL_HISTORY_DIR%\*.log
IF NOT DEFINED YT_DLP_LOG_DIR SET YT_DLP_LOG_DIR=%DOWNLOADS_DIR%\yt-dlp-log
IF NOT DEFINED BATCH_MODE SET BATCH_MODE=0

IF NOT EXIST %YTDLP_CONF_DIR% MD %YTDLP_CONF_DIR%
IF NOT EXIST %DLURL_HISTORY_DIR% MD %DLURL_HISTORY_DIR%
SET YT_DLP_ERR_FILE=%VIDEOS_DIR%\%DLURL_LIST_NAME%_%yyyy%%mm%%dd%%hh%%mn%%ss%.err

IF "%BATCH_MODE%"=="ON" GOTO :DL_START_BATCH


:COPY_CONF
IF NOT "%1"=="" (
	SET YTDLP_PROFILE_FILE=%~1
	SET YTDLP_PROFILE=%~n1
	COPY %~1 %YTDLP_CONFIG_FILE%
) ELSE (
	FOR %%i IN (%CONFIG_DIR%\yt-dlp\*.dlp) DO (
		ECHO %%~ni
	)
	SET /P YTDLP_PROFILE="->"
	SET YTDLP_PROFILE_FILE=%CONFIG_DIR%\yt-dlp\!YTDLP_PROFILE!.dlp
	COPY !YTDLP_PROFILE_FILE! %YTDLP_CONFIG_FILE%
)
IF NOT EXIST %YTDLP_CONFIG_FILE% (EXIT)
TYPE %YTDLP_CONFIG_FILE%
SET YTDLP_CONF_OPT=--config-location %YTDLP_CONFIG_FILE%


:SET_SKIP_MODE
FINDSTR /C:"#SKIP_MODE_OFF" %YTDLP_CONFIG_FILE%
IF ERRORLEVEL 1 (
	REM PASS
) ELSE (
	SET SKIP_FLG=0
	GOTO :SET_SKIP_MODE_END
)

FINDSTR /C:"#SKIP_MODE_ON_PREFIX" %YTDLP_CONFIG_FILE%
IF ERRORLEVEL 1 (
	REM PASS
) ELSE (
	SET SKIP_FLG=1
	SET DLURL_HISTORY_FILES=%DLURL_HISTORY_DIR%\%~n1*.log
	SET SKIP_QUALITY=%~n1
	ECHO !DLURL_HISTORY_FILES!
	GOTO :SET_SKIP_MODE_END
)
FINDSTR /C:"#SKIP_MODE_ON" %YTDLP_CONFIG_FILE%
IF ERRORLEVEL 1 (
	REM PASS
) ELSE (
	SET SKIP_FLG=1
	GOTO :SET_SKIP_MODE_END
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
:SET_SKIP_MODE_END


:SET_RESOLUTION
FINDSTR /C:"RESOLUTION" %YTDLP_CONFIG_FILE%
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
FINDSTR /C:"INPUT_MODE" %YTDLP_CONFIG_FILE%
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
CHOICE /C 12345 /M "1:INPUT 2:FILE 3:BATCH 4:PLAYLIST 5:FORMAT"
IF %ERRORLEVEL% EQU 1 (
	SET MODE=INPUT
) ELSE IF %ERRORLEVEL% EQU 2 (
	SET MODE=FILE
	ECHO DEFAULT: %YTDLP_DL_LIST_FILE%
	IF NOT EXIST %YTDLP_DL_LIST_FILE% SET /P YTDLP_DL_LIST_FILE="input txt: "
) ELSE IF %ERRORLEVEL% EQU 3 (
	SET MODE=FILE
	SET BATCH_ONLY=1
	MOVE %YTDLP_CONFIG_FILE% %DLURL_LIST%_batch.dlp
	SET YTDLP_CONFIG_FILE=%DLURL_LIST%_batch.dlp
	SET DLURL_LIST_NAME=%DLURL_LIST_NAME%_batch
	SET DLURL_LIST=%DLURL_LIST%_batch
	ECHO DEFAULT: %YTDLP_DL_LIST_FILE%
	IF NOT EXIST %YTDLP_DL_LIST_FILE% SET /P YTDLP_DL_LIST_FILE="input txt: "
) ELSE IF %ERRORLEVEL% EQU 4 (
	SET MODE=PLAYLIST
) ELSE IF %ERRORLEVEL% EQU 5 (
	SET MODE=FORMAT
	GOTO :CHECK_FORMAT
)
SET YTDLP_CONF_OPT=--config-location %YTDLP_CONFIG_FILE%
ECHO %MODE%

SET _YTDLP_DL_LIST_FILE=%YTDLP_DL_LIST_FILE:"=%
SET FILE_EXT=%_YTDLP_DL_LIST_FILE:~-7,-4%
SET FILE_EXT_LAST=%_YTDLP_DL_LIST_FILE:~-3%
SET DLURL_LIST_OUTPUT=%DLURL_LIST%.txt
IF "%FILE_EXT%"=="csv" (
	SET DLURL_LIST=%DLURL_LIST%.csv.txt
) ELSE (
	SET DLURL_LIST=%DLURL_LIST%.txt
)

GOTO :DL_START_%MODE%
EXIT /B



REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:DL_START_INPUT
SET DOWNLOAD_URL=
SET /P DOWNLOAD_URL="URL: "
strip_url.py %DOWNLOAD_URL%
REM IF ERRORLEVEL 1 (
	REM DEL url.txt
	REM DEL %YTDLP_CONFIG_FILE%
	REM PAUSE
	REM EXIT
REM ) ElSE (
	REM FOR /F "tokens=1,2 delims=," %%i IN (url.txt) DO (SET DOWNLOAD_URL=%%i)
	REM ECHO URL:%DOWNLOAD_URL%
	REM DEL url.txt
REM )
REM IF %SKIP_FLG%==1 (
	REM FINDSTR /C:"%DOWNLOAD_URL%" %DLURL_HISTORY_FILES%
	REM IF ERRORLEVEL 1 (
		REM ECHO Start:%DOWNLOAD_URL%
	REM ) ElSE (
		REM ECHO Skip:%DOWNLOAD_URL%
		REM DEL %YTDLP_CONFIG_FILE%
		REM PAUSE
		REM GOTO :DL_END
	REM )
REM )
CD /D %VIDEOS_DIR%
yt-dlp.exe %YTDLP_CONF_OPT% %YTDLP_RESOLUTION_OPT% "%DOWNLOAD_URL%"
IF %ERRORLEVEL% EQU 0 (
	TIMEOUT /T 3
) ELSE (
	PAUSE
)
DEL %YTDLP_CONFIG_FILE%
GOTO :DL_END
EXIT /B


:DL_START_PLAYLIST
SET /P DOWNLOAD_URL="URL: "
SET /P PLAYLIST_START="PLAYLIST START NUMBER: "
SET YTDLP_OPT=--yes-playlist
IF DEFINED PLAYLIST_START SET YTDLP_OPT=%YTDLP_OPT% --playlist-start %PLAYLIST_START%
CD /D %VIDEOS_DIR%
yt-dlp.exe %YTDLP_CONF_OPT% %YTDLP_RESOLUTION_OPT% %YTDLP_OPT% "%DOWNLOAD_URL%" 2>%YT_DLP_ERR_FILE%
DEL %YTDLP_CONFIG_FILE%
GOTO :DL_END
EXIT /B


:DL_START_FILE
IF EXIST %YTDLP_DL_LIST_FILE% COPY %YTDLP_DL_LIST_FILE% %DLURL_LIST%
IF NOT EXIST %DLURL_LIST% TYPE nul >%DLURL_LIST%
SET BATCH_LOCK_FILE=%DESKTOP_DIR%\%DLURL_LIST_NAME%.lock
NOTEPAD %DLURL_LIST%

IF "%FILE_EXT_LAST%"=="%END_FILE_EXT%" (
	DEL %YTDLP_DL_LIST_FILE%
	DEL %YTDLP_PROFILE_FILE%
)

IF %SKIP_FLG%==0 ECHO #SKIP_MODE_OFF>>%YTDLP_CONFIG_FILE%
IF %SKIP_FLG%==1 (
	strip_url.py %DLURL_LIST%
	IF ERRORLEVEL 1 (
		DEL url.txt
		PAUSE
		EXIT
	) ElSE (
		MOVE url.txt %DLURL_LIST_OUTPUT%
	)
	type nul>%DLURL_LIST_OUTPUT%.tmp
	FOR /F "tokens=1,2 delims=," %%i IN (%DLURL_LIST_OUTPUT%) DO (
		FINDSTR /C:"%%j" %DLURL_HISTORY_FILES% %YTDLP_CONF_DIR%\*.%END_FILE_EXT% >nul 2>&1
		IF ERRORLEVEL 1 (
			ECHO Start:%%i
			REM ECHO #Start DL: %%i>>%YTDLP_CONFIG_FILE%
			ECHO %%i>>%DLURL_LIST_OUTPUT%.tmp
		) ELSE (
			ECHO Skip:%%i
			ECHO #Skip:%%i>>%YTDLP_CONFIG_FILE%
		)
	)
	IF EXIST %DLURL_LIST_OUTPUT%.tmp MOVE %DLURL_LIST_OUTPUT%.tmp %DLURL_LIST_OUTPUT%
)
CD /D %VIDEOS_DIR%
MOVE %DLURL_LIST_OUTPUT% %DLURL_LIST_OUTPUT%.%END_FILE_EXT%

CALL :MAKE_BATCH_FILE
IF DEFINED BATCH_ONLY (
	REM EXPLORER %YTDLP_CONF_DIR%
	EXIT /B
)

REM RUN
CALL :IS_FILE_EMPTY %DLURL_LIST_OUTPUT%.%END_FILE_EXT%
IF %ERRORLEVEL% EQU 0 (
	GOTO :DL_END
)
ECHO;>%BATCH_LOCK_FILE%
yt-dlp.exe %YTDLP_CONF_OPT% %YTDLP_RESOLUTION_OPT% -a %DLURL_LIST_OUTPUT%.%END_FILE_EXT% 2>%YT_DLP_ERR_FILE%
IF %ERRORLEVEL% EQU 0 (
	GOTO :DL_END
) ELSE (
	DEL %BATCH_LOCK_FILE%
)
FINDSTR /C:"ERROR" %YT_DLP_ERR_FILE%
IF ERRORLEVEL 1 (
	REM NO ERROR
) ELSE (
	REM ERROR
	FINDSTR /C:"ERROR" %BATCH_ERR_FILE%>%DESKTOP_DIR%\%YTDLP_CONFIG_FILE_NAME%.err
	REM MOVE %BATCH_ERR_FILE% %DESKTOP_DIR%\
)
EXIT /B


:MAKE_BATCH_FILE
SET BATCH_FILE=%YTDLP_CONF_DIR%\yt-dlp-batch_%yyyy%%mm%%dd%.cmd
IF NOT EXIST %BATCH_FILE% (
	ECHO SET BATCH_MODE=ON>>%BATCH_FILE%
	REM ECHO SET MODE=BATCH>>%BATCH_FILE%
	ECHO CALL %USERPROFILE%\.Tools\Settings.cmd>>%BATCH_FILE%
	ECHO SET BATCH_LIST_DIR=%YTDLP_CONF_DIR%>>%BATCH_FILE%
	ECHO SET YTDLP_BATCH_OPT=>>%BATCH_FILE%
	ECHO;>>%BATCH_FILE%
)
ECHO :%DLURL_LIST_NAME%_START>>%BATCH_FILE%
ECHO (SET SKIP_FLG=%SKIP_FLG%)>>%BATCH_FILE%
ECHO SET DLURL_HISTORY_FILES=%DLURL_HISTORY_FILES%>>%BATCH_FILE%
IF DEFINED SKIP_QUALITY (
	ECHO SET SKIP_QUALITY=%SKIP_QUALITY%>>%BATCH_FILE%
)
IF DEFINED RESOLUTION (
	ECHO SET YTDLP_OPT=-S "res:%RESOLUTION%">>%BATCH_FILE%
) ELSE (
	ECHO SET YTDLP_OPT=>>%BATCH_FILE%
)

REM ECHO CALL ytdlp-dl.cmd %YTDLP_CONFIG_FILE% %DLURL_LIST_OUTPUT%.%END_FILE_EXT%>>%BATCH_FILE%
ECHO CALL ytdlp-dl.cmd %%BATCH_LIST_DIR%%\%DLURL_LIST_NAME%.dlp %%BATCH_LIST_DIR%%\%DLURL_LIST_NAME%.txt.%END_FILE_EXT%>>%BATCH_FILE%
ECHO REM yt-dlp.exe --config-location %%BATCH_LIST_DIR%%\%DLURL_LIST_NAME%.dlp %%YTDLP_BATCH_OPT%% %%YTDLP_OPT%% -a %%BATCH_LIST_DIR%%\%DLURL_LIST_NAME%.txt.%END_FILE_EXT%>>%BATCH_FILE%
ECHO :%DLURL_LIST_NAME%_END>>%BATCH_FILE%
ECHO;>>%BATCH_FILE%
EXIT /B


:DL_START_BATCH
SET YTDLP_CONFIG_FILE_NAME=%~n1
SET YTDLP_CONFIG_FILE=%~1
SET DLURL_LIST_DIR=%~p1
SET DLURL_LIST=%~2
SET DLURL_LIST_OUTPUT=%~2
SET DLURL_LIST_NAME=%YTDLP_CONFIG_FILE_NAME%
SET BATCH_ERR_FILE=%VIDEOS_DIR%\%YTDLP_CONFIG_FILE_NAME%_%yyyy%%mm%%dd%%hh%%mn%%ss%.err
SET BATCH_LOCK_FILE=%DESKTOP_DIR%\%YTDLP_CONFIG_FILE_NAME%.lock
SET YTDLP_CONF_OPT=--config-location %YTDLP_CONFIG_FILE%
ECHO BATCH_MODE: %YTDLP_CONFIG_FILE_NAME%
IF NOT EXIST %YTDLP_CONFIG_FILE% EXIT /B
IF NOT EXIST %DLURL_LIST% EXIT /B
IF EXIST %BATCH_LOCK_FILE% EXIT /B
IF EXIST %DESKTOP_DIR%\%YTDLP_CONFIG_FILE_NAME%*.err EXIT /B
ECHO;>%BATCH_LOCK_FILE%
IF %SKIP_FLG%==1 (
	strip_url.py %DLURL_LIST%
	IF ERRORLEVEL 1 (
		DEL url.txt
		PAUSE
		EXIT
	) ElSE (
		MOVE url.txt %DLURL_LIST_OUTPUT%
	)
	type nul>%DLURL_LIST%.tmp
	FOR /F "tokens=1,2 delims=," %%i IN (%DLURL_LIST%) DO (
		FINDSTR /C:"%%j" %DLURL_HISTORY_FILES% >nul 2>&1
		IF ERRORLEVEL 1 (
			ECHO Start:%%i
			REM ECHO #Start DL: %%i>>%YTDLP_CONFIG_FILE%
			ECHO %%i>>%DLURL_LIST%.tmp
		) ELSE (
			ECHO Skip:%%i
			ECHO #Skip:%%i>>%YTDLP_CONFIG_FILE%
		)
	)
	IF EXIST %DLURL_LIST%.tmp MOVE %DLURL_LIST%.tmp %DLURL_LIST%
)

CALL :IS_FILE_EMPTY %DLURL_LIST%
IF %ERRORLEVEL% EQU 0 (
	GOTO :DL_END
)
yt-dlp.exe %YTDLP_CONF_OPT% %YTDLP_BATCH_OPT% %YTDLP_OPT% -a %DLURL_LIST% 2>%BATCH_ERR_FILE%
IF %ERRORLEVEL% EQU 0 (
	IF NOT EXIST %YT_DLP_LOG_DIR% MD %YT_DLP_LOG_DIR%
	MOVE %BATCH_ERR_FILE% %YT_DLP_LOG_DIR%\
	GOTO :DL_END
) ELSE (
	DEL %BATCH_LOCK_FILE%
)
FINDSTR /C:"ERROR" %BATCH_ERR_FILE%
IF ERRORLEVEL 1 (
	REM NO ERROR
) ELSE (
	REM ERROR
	FINDSTR /C:"ERROR" %BATCH_ERR_FILE%>%DESKTOP_DIR%\%YTDLP_CONFIG_FILE_NAME%.err
	REM MOVE %BATCH_ERR_FILE% %DESKTOP_DIR%\
)
EXIT /B


:CHECK_FORMAT
REM SET YTDLP_OPT=-v -F --list-subs
SET YTDLP_OPT=-v -F
SET DOWNLOAD_URL=
SET /P DOWNLOAD_URL="URL: "
IF NOT DEFINED DOWNLOAD_URL GOTO :CHECK_FORMAT_END
REM SET /P FORMAT_OPTION="FORMAT_OPTION: "
yt-dlp.exe %YTDLP_CONF_OPT% %YTDLP_OPT% %FORMAT_OPTION% %DOWNLOAD_URL%
GOTO :CHECK_FORMAT
:CHECK_FORMAT_END
DEL %YTDLP_CONFIG_FILE%
EXIT /B


:DL_END
IF NOT EXIST %YT_DLP_LOG_DIR% MD %YT_DLP_LOG_DIR%
IF DEFINED BATCH_LOCK_FILE DEL %BATCH_LOCK_FILE%
ECHO MOVE LOG DIR: %DLURL_LIST_DIR%\%DLURL_LIST_NAME%*
FOR %%F IN (%DLURL_LIST_DIR%\%DLURL_LIST_NAME%*) DO (
	IF EXIST %%F MOVE %%F %YT_DLP_LOG_DIR%\
)
IF 1 EQU %SHUTDOWN_FLG2% (SHUTDOWN /S /T 3)
EXIT /B


:IS_FILE_EMPTY
FOR %%F IN (%1) DO (
	IF %%~zF EQU 0 (
		REM File size is zero
		EXIT /B 0
	)
)
EXIT /B 1


