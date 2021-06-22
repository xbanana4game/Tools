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
FOR %%i in (%*) DO (
	ECHO %%i
	7z a -tzip -sdel "%%~nxi.zip" ""%%i\*"" -mx=0 -mtc=off
	7z l "%%~nxi.zip">"%%~nxi.zip.txt"
)
EXIT

