@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
SET DRIVE_LETTER_FILE=%CD:~0,2%
SET DRIVE_LETTER_CMD=%~d0
REM ---------- Extract.cmd(SettingsOptions) ----------
REM SET ARCHIVE_DIR=C:\Archives
REM SET STORE_DIR=C:\Store
REM SET DOWNLOADS_PASSWORD=
REM SET EXTRACT_TARGET_DIR=%DRIVE_LETTER%:\ARCHIVE2023\Downloads
REM SET EXTRACT_TARGET_DIR=%USERPROFILE%\Desktop
REM SET EXTRACT_TARGET_DIR=%USERPROFILE%\Desktop\*
REM SET EXTRACT_EXT=*
REM SET IGNORE_FILE=CloudDL-Store@*
REM SET IGNORE_FILE_2=.ts
REM SET MOVE_STORE_FLG=0
REM SET ARCHIVE_STORE_DIR=%STORE_DIR%\DL_%yyyy%%mm%


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED MOVE_STORE_FLG (SET MOVE_STORE_FLG=0)
IF NOT DEFINED DOWNLOADS_PASSWORD (SET /P DOWNLOADS_PASSWORD="SET DOWNLOADS_PASSWORD(%ARCHIVE_PASSWORD%)=")
IF NOT DEFINED DOWNLOADS_PASSWORD (SET DOWNLOADS_PASSWORD=%ARCHIVE_PASSWORD%)
REM IF NOT DEFINED ARCHIVE_STORE_DIR SET ARCHIVE_STORE_DIR=%STORE_DIR%\DL_%yyyy%%mm%
					
IF NOT "%1"=="" (
	FOR %%i in (%*) DO (CALL :Extract7z %%i)
	EXIT
)

CHOICE /C AS /T 3 /D A /M "A:ARCHIVE S:STORE"
IF %ERRORLEVEL% EQU 1 (
	ECHO %ARCHIVE_DIR%
) ElSE IF %ERRORLEVEL% EQU 2 (
	ECHO %STORE_DIR%
	SET ARCHIVE_DIR=%STORE_DIR%
	SET MOVE_STORE_FLG=0
)

ECHO ================== LIST ==================
DIR /B %ARCHIVE_DIR%
SET /P EXTRACT_YYYY="Enter Extract YYYY* or YYYYMM. (Default:DL_%yyyy%%mm%) -> "
IF "%EXTRACT_YYYY%"=="" SET EXTRACT_YYYY=DL_%yyyy%%mm%
IF NOT DEFINED ARCHIVE_STORE_DIR SET ARCHIVE_STORE_DIR=%STORE_DIR%\%EXTRACT_YYYY%
IF DEFINED ARCHIVE_STORE_DIR MD %ARCHIVE_STORE_DIR% 2>nul
CALL :MAKE_LIST_FILE
CALL :EXTRACT_YYYYMM
TIMEOUT /T 2
REM PAUSE
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
	IF %MOVE_STORE_FLG%==1 MD %ARCHIVE_STORE_DIR%
	
	REM auto rename existing file (for example, name.txt will be renamed to name_1.txt).
	FOR /D %%i IN ("%ARCHIVE_DIR%\%EXTRACT_YYYY%") DO (
		ECHO %%i
		CALL :EXTRACT_EXP "%ARCHIVE_DIR%\%%~ni\DL_*.7z"
		CALL :EXTRACT_EXP "%ARCHIVE_DIR%\%%~ni\DL_*.7z.001"
		CALL :EXTRACT_EXP "%ARCHIVE_DIR%\%%~ni\VD_*.7z.001"
	)
	EXIT /B
	
:EXTRACT_EXP
	SET TARGET_DIR_EXP=%~1
	ECHO CALL :EXTRACT_EXP %TARGET_DIR_EXP%
	FOR %%j IN ("%TARGET_DIR_EXP%") DO (
			ECHO 7z x -p%DOWNLOADS_PASSWORD% %%j -o%EXTRACT_TARGET_DIR%\%%~ni -aot "%EXTRACT_EXT%" -r %IGNORE_OPT%
			7z x -p%DOWNLOADS_PASSWORD% %%j -o%EXTRACT_TARGET_DIR%\%%~ni -aot "%EXTRACT_EXT%" -r %IGNORE_OPT%
			IF ERRORLEVEL 1 (
				ECHO 7z.exe failed.
				PAUSE
				EXIT
			)
			7z l -p%DOWNLOADS_PASSWORD% %%j>%EXTRACT_TARGET_DIR%\%%~ni\%%~nj.txt
			IF %MOVE_STORE_FLG%==1 (
				ECHO MOVE "%%j" %ARCHIVE_STORE_DIR%\
				MOVE "%%j" %ARCHIVE_STORE_DIR%\
				ECHO MOVE "%%~dpnj.???" %ARCHIVE_STORE_DIR%\
				MOVE "%%~dpnj.???" %ARCHIVE_STORE_DIR%\
				RMDIR %ARCHIVE_DIR%\%EXTRACT_YYYY% 2>nul
			)
	)
	EXIT /B
:Extract7z
	SET EXTRACT_FILE=%1
	SET EXTRACT_EXT=*
	REM IF NOT DEFINED EXTRACT_TARGET_DIR SET EXTRACT_TARGET_DIR=%USERPROFILE%\Desktop\*
	IF NOT DEFINED EXTRACT_TARGET_DIR SET EXTRACT_TARGET_DIR=%DOWNLOADS_DIR%
	REM Overwrite All existing files without prompt.
	ECHO 7z x -p%DOWNLOADS_PASSWORD% %EXTRACT_FILE% -o%EXTRACT_TARGET_DIR% -aoa %EXTRACT_EXT% -r %IGNORE_OPT%
	7z x -p%DOWNLOADS_PASSWORD% %EXTRACT_FILE% -o%EXTRACT_TARGET_DIR% -aoa %EXTRACT_EXT% -r %IGNORE_OPT%
	IF ERRORLEVEL 1 (
		ECHO 7z.exe failed.
		PAUSE
		EXIT /B 1
	)
	7z l -p%DOWNLOADS_PASSWORD% %EXTRACT_FILE%>%EXTRACT_TARGET_DIR%\%~n1.txt
	EXIT /B

