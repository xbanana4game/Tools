@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Add-Disc-Directory.cmd ----------
SET DISK_PROFILE=%~n0

REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED DISK_PROFILE (SET /P DISK_PROFILE="SET DISK_PROFILE=")

SET NUMBER=0
:NEXT_NUMBER
SET /A NUMBER=%NUMBER%+1
IF %NUMBER% LSS 10 SET F_NUMBER=0%NUMBER%
ELSE SET F_NUMBER=%NUMBER%
IF EXIST %DISK_PROFILE%-Disc-%F_NUMBER% GOTO :NEXT_NUMBER
MD %DISK_PROFILE%-Disc-%F_NUMBER%

FOR %%i IN (%*) DO (
	MKLINK /H "%DISK_PROFILE%-Disc-%F_NUMBER%\%%~nxi" "%%i"
	REM MOVE "%%i" "%DISK_PROFILE%-Disc-%F_NUMBER%\%%~nxi"
)

