@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM --------------- Add-Disc-Directory.cmd(SettingsOptions) --------------
REM SET BASE_DIR=S:\Store\VD_20XX
REM SET BASE_DIR=.\test-Base
REM SET DISK_OUTPUT_DIR=%DOWNLOADS_DIR%
REM SET DISK_PROFILE=test
REM SET MOVE_MODE=0
REM SET TARGET_EXT=*.7z.???
REM SET MAX_VOLUME_SIZE_KB=24414062
REM MOVE_MODE [1:MOVE 0:MKLINK 2:MKLINK X.7z.001]
REM IF NOT EXIST %DISK_OUTPUT_DIR% MD %DISK_OUTPUT_DIR%
REM CALL :CheckDirectory %DISK_OUTPUT_DIR%
REM ----------------------------------------------------------------------


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED DISK_PROFILE (SET /P DISK_PROFILE="SET DISK_PROFILE(%~n0)=")
IF NOT DEFINED DISK_PROFILE SET DISK_PROFILE=%~n0
IF NOT DEFINED DISK_OUTPUT_DIR (SET /P DISK_OUTPUT_DIR="SET DISK_OUTPUT_DIR(%~dp0)=")
IF NOT DEFINED DISK_OUTPUT_DIR (SET DISK_OUTPUT_DIR=%~dp0)
IF NOT DEFINED MOVE_MODE (SET MOVE_MODE=0)
IF NOT DEFINED TARGET_EXT (SET TARGET_EXT=*.7z.???)
IF NOT DEFINED MAX_VOLUME_SIZE_KB(SET MAX_VOLUME_SIZE_KB=24414062)

IF DEFINED BASE_DIR CD /D %BASE_DIR%
SET NUMBER=0
:NEXT_NUMBER
SET /A NUMBER=%NUMBER%+1
IF %NUMBER% LSS 10 (SET F_NUMBER=0%NUMBER%) ELSE (SET F_NUMBER=%NUMBER%)
IF EXIST "%DISK_OUTPUT_DIR%\%DISK_PROFILE%-Disc-%F_NUMBER%" GOTO :NEXT_NUMBER
MD "%DISK_OUTPUT_DIR%\%DISK_PROFILE%-Disc-%F_NUMBER%"

REM FOR %%i IN (%*) DO (
REM 	IF %MOVE_MODE%==1 (
REM 		MOVE "%%i" "%DISK_OUTPUT_DIR%\%DISK_PROFILE%-Disc-%F_NUMBER%\%%~nxi"
REM 	) ELSE (
REM 		MKLINK /H "%DISK_OUTPUT_DIR%\%DISK_PROFILE%-Disc-%F_NUMBER%\%%~nxi" "%%i"
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
REM 数値は 32 ビットで表記される数値 -2147483648 ～ 2147483647
:MAKE_DISK
	SET CMD_FILE=%USERPROFILE%\.Tools\%yyyy%%mm%%dd%%hh%%mn%%ss%.cmd
	ECHO SET /A NUMBER=%NUMBER% >>%CMD_FILE%
	ECHO SET TOTAL_SIZE=0 >>%CMD_FILE%
	ECHO REM ----------------------------------------------------------------------------------------------------------- >>%CMD_FILE%
	FOR /R %%i in (%TARGET_EXT%) DO (
		ECHO %%~nxi
		ECHO REM %%~nxi >>%CMD_FILE%
		ECHO SET FILE_SIZE_BYTE=%%~zi>>%CMD_FILE%
		REM 2GByte以下のファイル
		REM ECHO SET FILE_SIZE=%%~zi/1024 >>%CMD_FILE%
		REM 2GByteを超えるファイルがある場合
		ECHO SET FILE_SIZE=%%FILE_SIZE_BYTE:~0,-3%%>>%CMD_FILE%
		ECHO SET /A TOTAL_SIZE=%%TOTAL_SIZE%%+%%FILE_SIZE%% >>%CMD_FILE%
		ECHO IF %%TOTAL_SIZE%% GEQ %MAX_VOLUME_SIZE_KB% SET /A NUMBER=%%NUMBER%%+1 >>%CMD_FILE%
		ECHO IF %%TOTAL_SIZE%% GEQ %MAX_VOLUME_SIZE_KB% SET TOTAL_SIZE=%%FILE_SIZE%% >>%CMD_FILE%
		ECHO IF %%NUMBER%% LSS 10 SET F_NUMBER=0%%NUMBER%%>>%CMD_FILE%
		ECHO IF %%NUMBER%% GEQ 10 SET F_NUMBER=%%NUMBER%%>>%CMD_FILE%
		ECHO IF NOT EXIST "%DISK_OUTPUT_DIR%\%DISK_PROFILE%-Disc-%%F_NUMBER%%" MD "%DISK_OUTPUT_DIR%\%DISK_PROFILE%-Disc-%%F_NUMBER%%" >>%CMD_FILE%
		REM ECHO ELSE MD "%DISK_OUTPUT_DIR%\%DISK_PROFILE%-Disc-%F_NUMBER%" >>%CMD_FILE%
		REM ECHO MOVE "%%~nxi" "%DISK_OUTPUT_DIR%\%DISK_PROFILE%-Disc-%%F_NUMBER%%" >>%CMD_FILE%

		ECHO SET FILENAME=%%~nxi >>%CMD_FILE%
		ECHO SET FILENAME=%%FILENAME:~0,1%%.7z%%~xi >>%CMD_FILE%
		IF %MOVE_MODE%==2 (ECHO MKLINK /H "%DISK_OUTPUT_DIR%\%DISK_PROFILE%-Disc-%%F_NUMBER%%\%%FILENAME%%" "%%i" >>%CMD_FILE%)
		IF %MOVE_MODE%==1 (
			ECHO MOVE "%%i" "%DISK_OUTPUT_DIR%\%DISK_PROFILE%-Disc-%%F_NUMBER%%\%%~nxi" >>%CMD_FILE%
		) ELSE (
			ECHO MKLINK /H "%DISK_OUTPUT_DIR%\%DISK_PROFILE%-Disc-%%F_NUMBER%%\%%~nxi" "%%i" >>%CMD_FILE%
		)
		ECHO REM ----------------------------------------------------------------------------------------------------------- >>%CMD_FILE%
	)
	IF EXIST %CMD_FILE% (
		IF DEFINED DEBUG NOTEPAD %CMD_FILE%
		CALL %CMD_FILE%
		DEL %CMD_FILE%
	)
	EXIT /B 0
	

	
