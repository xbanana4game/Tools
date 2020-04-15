@ECHO OFF
REM ----------------------------------------------------------------------
REM 設定ファイル読み込み
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd

REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
SET LOGNAME=ExtractBeatmap@%USERDOMAIN%.log
SET LOGNAME_DETAIL=ExtractBeatmapD@%USERDOMAIN%.log
FOR %%i in (%*) DO (
	7z e %%i -o%OSU_SONGS_DIR%
	ECHO %yyyy%/%mm%/%dd%:%%~nxi >>%OSU_DIR%\Logs\%LOGNAME%
	7z l %%i >>%OSU_DIR%\Logs\%LOGNAME_DETAIL%
)
NOTEPAD %OSU_DIR%\Logs\%LOGNAME%
EXIT

