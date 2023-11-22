@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Extract.cmd(SettingsOptions) ----------
REM SET ARCHIVE_DIR=C:\Archives
REM SET STORE_DIR=C:\Store
REM SET DOWNLOADS_PASSWORD=
REM IF NOT DEFINED DRIVE_LETTER (SET DRIVE_LETTER=%CD:~0,1%)
REM SET EXTRACT_TARGET_DIR=%DRIVE_LETTER%:\ARCHIVE2023\Downloads
REM SET EXTRACT_TARGET_DIR=%USERPROFILE%\Desktop\*
REM SET EXTRACT_EXT=*
REM SET IGNORE_FILE=CloudDL-Store@*
REM SET IGNORE_FILE_2=.ts
REM SET MOVE_STORE_FLG=1


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED MOVE_STORE_FLG (SET MOVE_STORE_FLG=0)
IF NOT DEFINED DOWNLOADS_PASSWORD (SET /P DOWNLOADS_PASSWORD="SET DOWNLOADS_PASSWORD(%ARCHIVE_PASSWORD%)=")
IF NOT DEFINED DOWNLOADS_PASSWORD (SET DOWNLOADS_PASSWORD=%ARCHIVE_PASSWORD%)

IF NOT "%1"=="" (
	FOR %%i in (%*) DO (CALL :Extract7z %%i)
	EXIT
)

DIR /B %ARCHIVE_DIR%
SET /P EXTRACT_YYYY="Enter Extract YYYY* or YYYYMM. (Default:%yyyy%%mm%) -> "
IF "%EXTRACT_YYYY%"=="" SET EXTRACT_YYYY=%yyyy%%mm%
CALL :MAKE_LIST_FILE
CALL :EXTRACT_YYYYMM
TIMEOUT /T 2
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:MAKE_LIST_FILE
	FOR /D %%i IN ("%ARCHIVE_DIR%\%EXTRACT_YYYY%") DO (
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\DL_*.7z") DO (
			7z l -p%DOWNLOADS_PASSWORD% %%j
		)
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\DL_*.7z.001") DO (
			7z l -p%DOWNLOADS_PASSWORD% %%j
		)
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\VD_*.7z.001") DO (
			7z l -p%DOWNLOADS_PASSWORD% %%j
		)

	)
	EXIT /B

:EXTRACT_YYYYMM
	IF NOT DEFINED EXTRACT_EXT SET /P EXTRACT_EXT="SET EXTRACT_EXT (Default:*) -> "
	IF "%EXTRACT_EXT%"=="" SET EXTRACT_EXT=*
	IF NOT DEFINED EXTRACT_TARGET_DIR SET /P EXTRACT_TARGET_DIR="SET EXTRACT_TARGET_DIR (Default:%DESKTOP_DIR%) -> "
	IF "%EXTRACT_TARGET_DIR%"=="" SET EXTRACT_TARGET_DIR=%DESKTOP_DIR%
	IF DEFINED IGNORE_FILE SET IGNORE_OPT=-xr!%IGNORE_FILE%
	IF DEFINED IGNORE_FILE_2 SET IGNORE_OPT=%IGNORE_OPT% -xr!%IGNORE_FILE_2%
	IF %MOVE_STORE_FLG%==1 MD %STORE_DIR%\%EXTRACT_YYYY%
	
	FOR /D %%i IN ("%ARCHIVE_DIR%\%EXTRACT_YYYY%") DO (
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\DL_*.7z") DO (
			IF NOT EXIST %EXTRACT_TARGET_DIR%\%%~ni\%%~nj.txt (
				7z x -p%DOWNLOADS_PASSWORD% %%j -o%EXTRACT_TARGET_DIR%\%%~ni -aot %EXTRACT_EXT% -r %IGNORE_OPT%
				7z l -p%DOWNLOADS_PASSWORD% %%j>%EXTRACT_TARGET_DIR%\%%~ni\%%~nj.txt
			)
		)
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\DL_*.7z.001") DO (
			IF NOT EXIST %EXTRACT_TARGET_DIR%\%%~ni\%%~nj.txt (
				7z x -p%DOWNLOADS_PASSWORD% %%j -o%EXTRACT_TARGET_DIR%\%%~ni -aot %EXTRACT_EXT% -r %IGNORE_OPT%
				7z l -p%DOWNLOADS_PASSWORD% %%j>%EXTRACT_TARGET_DIR%\%%~ni\%%~nj.txt
			)
		)
		FOR %%j IN ("%ARCHIVE_DIR%\%%~ni\VD_*.7z.001") DO (
			IF NOT EXIST %EXTRACT_TARGET_DIR%\%%~nj.txt (
				7z x -p%DOWNLOADS_PASSWORD% %%j -o%EXTRACT_TARGET_DIR%\%%~ni -aot %EXTRACT_EXT% -r %IGNORE_OPT%
				7z l -p%DOWNLOADS_PASSWORD% %%j>%EXTRACT_TARGET_DIR%\%%~nj.txt
			)
		)
		IF %MOVE_STORE_FLG%==1 (
			MOVE %ARCHIVE_DIR%\%EXTRACT_YYYY%\*.7z %STORE_DIR%\%EXTRACT_YYYY%\
			MOVE %ARCHIVE_DIR%\%EXTRACT_YYYY%\*.7z.??? %STORE_DIR%\%EXTRACT_YYYY%\
			RMDIR %ARCHIVE_DIR%\%EXTRACT_YYYY%
		)
	)
	EXIT /B
	
:Extract7z
	SET EXTRACT_FILE=%1
	SET EXTRACT_EXT=*
	REM IF NOT DEFINED EXTRACT_TARGET_DIR SET EXTRACT_TARGET_DIR=%USERPROFILE%\Desktop\*
	IF NOT DEFINED EXTRACT_TARGET_DIR SET EXTRACT_TARGET_DIR=%DOWNLOADS_DIR%
	7z x -p%DOWNLOADS_PASSWORD% %EXTRACT_FILE% -o%EXTRACT_TARGET_DIR% %EXTRACT_EXT% -r %IGNORE_OPT%
	7z l -p%DOWNLOADS_PASSWORD% %EXTRACT_FILE%>%EXTRACT_TARGET_DIR%\%~n1.txt
	EXIT /B

