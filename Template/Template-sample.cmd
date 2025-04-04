@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Template.cmd(SettingsOptions.cmd) ----------
SETLOCAL ENABLEDELAYEDEXPANSION
SET DRIVE_LETTER_FILE=%CD:~0,2%
SET DRIVE_LETTER_CMD=%~d0

REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
CD
REM target file dir
IF NOT DEFINED DRIVE_LETTER_FILE (SET DRIVE_LETTER_FILE=%CD:~0,2%)
REM self cmd dir
IF NOT DEFINED DRIVE_LETTER_CMD (SET DRIVE_LETTER_CMD=%~d0)
ECHO DRIVE_LETTER_FILE=%DRIVE_LETTER_FILE%
ECHO DRIVE_LETTER_CMD=%DRIVE_LETTER_CMD%

SET VAR=before
	IF "%VAR%" == "before" (
	SET VAR=after
	IF "!VAR!" == "after" @echo IF you see this, it worked
)

REM CALL :INPUT_SETTINGS TEST "SET TEST=0 : " 0
IF NOT DEFINED VARIABLE (SET /P VARIABLE="SET VARIABLE(DEFAULT)=")
IF NOT DEFINED VARIABLE (SET VARIABLE=DEFAULT)

IF NOT DEFINED DOWNLOADS_PASSWORD (SET /P DOWNLOADS_PASSWORD="SET DOWNLOADS_PASSWORD(%ARCHIVE_PASSWORD%)=")
IF NOT DEFINED DOWNLOADS_PASSWORD (SET DOWNLOADS_PASSWORD=%ARCHIVE_PASSWORD%)

ECHO %~dp0
ECHO %~n0
ECHO %0
ECHO %~dp0
CALL :isEmptyDir  %DESKTOP_DIR%
IF %ERRORLEVEL% EQU 1 (
	ECHO Files not Exist. %DESKTOP_DIR%
)

CALL :CheckDirectory %DESKTOP_DIR%
IF %ERRORLEVEL% EQU 1 (
	ECHO Directory not Exist. %DESKTOP_DIR%
	EXIT
)

IF ""%1""=="""" (
	ECHO no arg
) ELSE (
	ECHO %0
	ECHO DIR: %~dp0
	ECHO .
	FOR %%i IN (%*) DO (
		ECHO %%i
		ECHO NAME: %%~ni
		ECHO DIR: %%~dpi
		ECHO .
	)
)

PAUSE
TIMEOUT /T 5
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:CheckDirectory
	IF EXIST %1 (
		ECHO Directory %1 is Exist.
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT /B 1
	)
	EXIT /B 0
	
:ChangeDirectory
	IF EXIST %1 (
		CD /D %1
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0
	
:Msg
	SET MSG=%1
	SET /P END=%MSG%
	EXIT /B

:ArchiveEXE
	SET OUT=%1
	SET IN=%2
	7z a -sfx7z.sfx %OUT% %IN%
	EXIT /B %ERRORLEVEL%

:Archive7z
	SET OUT=%1
	SET IN=%2
	IF NOT "%ARCHIVE_PASSWORD%"=="" SET ARCHIVE_OPT_PW=-p%ARCHIVE_PASSWORD% -mhe
	7z a -t7z %ARCHIVE_OPT_PW% %OUT% %IN%
	EXIT /B %ERRORLEVEL%

:TreeDir
	SET TREE_DIR=%1
	TREE /F %TREE_DIR% >%USERPROFILE%\Desktop\tree.txt
	EXIT /B %ERRORLEVEL%

:makeYYYYMM
	for /l %%i in (1,1,12) do (
	  if %%i LSS 10 (
		md %yyyy%0%%i
	  ) else (
		md %yyyy%%%i
	  )
	)
	EXIT /B

:makeGpg
	SET USER_ID=%1
	SET OUT_FILE=%2
	SET IN_FILE=%3
	gpg -e -r %USER_ID% -a -o %USERPROFILE%\Desktop\%OUT_FILE% %IN_FILE%
	EXIT /B

:isEmptyDir
	DIR %1 /A:A-S /S /B
	IF %ERRORLEVEL% EQU 0 (
		ECHO Files Exist.
		EXIT /B 0
	)
	EXIT /B 1

:INPUT_YorN
	IF NOT DEFINED YorN SET /P YorN="YorN? 1/0 -> "
	IF "%YorN%"=="" SET YorN=0
	EXIT /B
	
:INPUT_SETTINGS
	IF EXIST input.cmd DEL input.cmd
	SET INPUT_ENV=%1
	SET INPUT_COMMENT=%2
	SET DEFAULT_VAL=%3
	echo IF NOT DEFINED %INPUT_ENV% (SET /P %INPUT_ENV%=%INPUT_COMMENT%)>>input.cmd
	echo IF NOT DEFINED %INPUT_ENV% (SET %INPUT_ENV%=%DEFAULT_VAL%)>>input.cmd
	IF EXIST input.cmd (
		CALL input.cmd
		TYPE input.cmd >>%DESKTOP_DIR%\input.cmd.txt
		DEL input.cmd
	)
	SET %INPUT_ENV%
	EXIT /B

:MAKE_PAGE_URL
	DEL a.txt
	FOR /L %%I IN (1,1,100) DO (
		ECHO https://www/?c=1^&p=%%I >>a.txt
	)
	TYPE a.txt
	EXIT /B

:SetDriveLetter
	IF NOT DEFINED DRIVE_LETTER (
		SET /P DRIVE_LETTER="SET DRIVE_LETTER(D)="
	)
	IF NOT DEFINED DRIVE_LETTER (SET DRIVE_LETTER=D)
	CD %DRIVE_LETTER%:
	IF %ERRORLEVEL% EQU 1 EXIT
	EXIT /B

:SEARCH_DIR
	FOR /D %%i IN ("*") DO (ECHO %%i)
	EXIT /B

:IS_FILE_EMPTY
FOR %%F IN (%1) DO (
	IF %%~zF EQU 0 (
		REM File size is zero
		EXIT /B 0
	)
)
EXIT /B 1

