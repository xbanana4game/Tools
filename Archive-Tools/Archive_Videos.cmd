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
REM SET OUTPUT_DIRECTORY=%USERPROFILE%\Videos
SET OUTPUT_DIRECTORY=.
SET OUTPUT_FILE_EXT=zip
REM IF NOT EXIST MD %OUTPUT_DIRECTORY%
FOR %%i in (%*) DO (
	ECHO %%i
	IF NOT EXIST "%OUTPUT_DIRECTORY%\%%~nxi.%OUTPUT_FILE_EXT%" (
		7z a -tzip -sdel "%OUTPUT_DIRECTORY%\%%~nxi.%OUTPUT_FILE_EXT%" ""%%i\*"" -xr!.@__thumb -xr!*.db -xr!*.ts -xr!.DS_Store -mx=0 -mtc=off
		REM 7z l "%OUTPUT_DIRECTORY%\%%~nxi.%OUTPUT_FILE_EXT%">"%%~nxi.%OUTPUT_FILE_EXT%.txt"
	)
)
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================

