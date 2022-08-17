@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Add-Disc-Directory.cmd(SettingsOptions) ----------
SET DISK_PROFILE=%~n0
SET MOVE_MODE=1

REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED DISK_PROFILE (SET /P DISK_PROFILE="SET DISK_PROFILE=")

SET NUMBER=0
:NEXT_NUMBER
SET /A NUMBER=%NUMBER%+1
IF %NUMBER% LSS 10 (SET F_NUMBER=0%NUMBER%) ELSE (SET F_NUMBER=%NUMBER%)
IF EXIST %DISK_PROFILE%-Disc-%F_NUMBER% GOTO :NEXT_NUMBER
MD %DISK_PROFILE%-Disc-%F_NUMBER%

REM FOR %%i IN (%*) DO (
REM 	IF %MOVE_MODE%==1 (
REM 		MOVE "%%i" "%DISK_PROFILE%-Disc-%F_NUMBER%\%%~nxi"
REM 	) ELSE (
REM 		MKLINK /H "%DISK_PROFILE%-Disc-%F_NUMBER%\%%~nxi" "%%i"
REM 	)
REM )
CALL :MAKE_DISK
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
REM 25,000,000,000 Byte　=　24,414,062 KB　=　23,841 MB　=　23.28 GB
REM BD Free Space: 25025314816 bytes = 24438784 kbyte
REM 1GB = 1073741824 byte = 1048576 kbyte
REM 23GB = 24117248 kbyte
:MAKE_DISK
	SET CMD_FILE=%USERPROFILE%\.Tools\%yyyy%%mm%%dd%%hh%%mn%%ss%.cmd
	ECHO SET /A NUMBER=%NUMBER% >>%CMD_FILE%
	ECHO SET TOTAL_SIZE=0 >>%CMD_FILE%
	ECHO REM ----------------------------------------------------------------------------------------------------------- >>%CMD_FILE%
	FOR %%i in (*.7z.???) DO (
		ECHO %%~nxi
		ECHO REM %%~nxi >>%CMD_FILE%
		ECHO SET FILE_SIZE=%%~zi/1024 >>%CMD_FILE%
		ECHO SET /A TOTAL_SIZE=%%TOTAL_SIZE%%+%%FILE_SIZE%% >>%CMD_FILE%
		ECHO IF %%TOTAL_SIZE%% GEQ 24414062 SET /A NUMBER=%%NUMBER%%+1 >>%CMD_FILE%
		ECHO IF %%TOTAL_SIZE%% GEQ 24414062 SET TOTAL_SIZE=%%FILE_SIZE%% >>%CMD_FILE%
		ECHO IF %%NUMBER%% LSS 10 SET F_NUMBER=0%%NUMBER%%>>%CMD_FILE%
		ECHO IF %%NUMBER%% GEQ 10 SET F_NUMBER=%%NUMBER%%>>%CMD_FILE%
		ECHO IF NOT EXIST %DISK_PROFILE%-Disc-%%F_NUMBER%% MD %DISK_PROFILE%-Disc-%%F_NUMBER%% >>%CMD_FILE%
		REM ECHO ELSE MD %DISK_PROFILE%-Disc-%F_NUMBER% >>%CMD_FILE%
		REM ECHO MOVE %%~nxi %DISK_PROFILE%-Disc-%%F_NUMBER%% >>%CMD_FILE%
		IF %MOVE_MODE%==1 (
			ECHO MOVE "%%i" "%DISK_PROFILE%-Disc-%%F_NUMBER%%\%%~nxi" >>%CMD_FILE%
		) ELSE (
			ECHO MKLINK /H "%DISK_PROFILE%-Disc-%%F_NUMBER%%\%%~nxi" "%%i" >>%CMD_FILE%
		)
		ECHO REM ----------------------------------------------------------------------------------------------------------- >>%CMD_FILE%
	)
	IF EXIST %CMD_FILE% (
		NOTEPAD %CMD_FILE%
		CALL %CMD_FILE%
		REM DEL %CMD_FILE%
	)
	EXIT /B 0
	
	