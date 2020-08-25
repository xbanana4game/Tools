@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd


REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
SET LOGNAME=%OSU_SONGS_DIR%\ExtractBeatmap.log
SET LOGNAME_DETAIL=%OSU_SONGS_DIR%\ExtractBeatmapD.log
FOR %%i in (%*) DO (
	7z e %%i -o%OSU_SONGS_DIR% -aoa
	ECHO %yyyy%/%mm%/%dd%:%%~nxi >>%LOGNAME%
	7z l %%i >>%LOGNAME_DETAIL%
)
NOTEPAD %LOGNAME%
EXIT

