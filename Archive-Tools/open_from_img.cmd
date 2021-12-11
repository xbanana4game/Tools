@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED MP4_FILES_DIR (SET /P MP4_FILES_DIR="SET MP4_FILES_DIR(%DOWNLOADS_DIR%)=")
IF NOT DEFINED MP4_FILES_DIR (SET MP4_FILES_DIR=%DOWNLOADS_DIR%)

IF ""%1""=="""" (
	ECHO no arg
) ELSE (
	CALL :ChangeDirectory %MP4_FILES_DIR%
	FORFILES /s /m %~n1 /c "cmd /c @path"
)

EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
:ChangeDirectory
	IF EXIST %1 (
		CD /D %1
	) ELSE (
		SET /P ERR=Directory %1 is not Exist.
		EXIT
	)
	EXIT /B 0
	
