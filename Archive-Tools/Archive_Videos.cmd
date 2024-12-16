@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Archive_Videos.cmd(SettingsOptions) ----------
REM SET OUTPUT_DIRECTORY=.
REM SET OUTPUT_FILE_EXT=zip.avi
REM SET SDEL_OPT=-sdel



REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
REM SET OUTPUT_DIRECTORY=%USERPROFILE%\Videos
IF NOT DEFINED OUTPUT_DIRECTORY SET OUTPUT_DIRECTORY=.
IF NOT DEFINED OUTPUT_FILE_EXT SET OUTPUT_FILE_EXT=zip.avi
IF NOT DEFINED SDEL_OPT SET SDEL_OPT=-sdel
REM IF NOT EXIST MD %OUTPUT_DIRECTORY%

FOR %%i in (%*) DO (
	ECHO %%i
	IF NOT EXIST "%OUTPUT_DIRECTORY%\%%~nxi.%OUTPUT_FILE_EXT%" (
		REM 7z a -tzip %SDEL_OPT% "%OUTPUT_DIRECTORY%\%%~nxi.%OUTPUT_FILE_EXT%" ""%%i\*"" -xr!.@__thumb -xr!*.db -xr!*.ts -xr!.DS_Store -mx=0 -mtc=off
		7z a -tzip %SDEL_OPT% "%OUTPUT_DIRECTORY%\%%~nxi.zip" ""%%i"" -xr!.@__thumb -xr!*.db -xr!*.ts -xr!.DS_Store -mx=0 -mtc=off
		REM 7z l "%OUTPUT_DIRECTORY%\%%~nxi.%OUTPUT_FILE_EXT%">"%%~nxi.%OUTPUT_FILE_EXT%.txt"
	)
	MKLINK /H "%OUTPUT_DIRECTORY%\%%~nxi.%OUTPUT_FILE_EXT%" "%OUTPUT_DIRECTORY%\%%~nxi.zip"
	RMDIR %%i
)

EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================

