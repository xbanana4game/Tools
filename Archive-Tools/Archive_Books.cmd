@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd

REM ---------- Archive_Books.cmd(SettingsOptions) ----------
REM SET OUTPUT_BOOKS_DIR=%DOWNLOADS_DIR%\Books-zip


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED OUTPUT_BOOKS_DIR SET OUTPUT_BOOKS_DIR=%DOCUMENTS_DIR%\Books-zip

IF NOT EXIST %OUTPUT_BOOKS_DIR% MD %OUTPUT_BOOKS_DIR%

FOR %%i in (%*) DO (
	ECHO %%i
	IF NOT EXIST "%OUTPUT_BOOKS_DIR%\%%~nxi.zip" (
		7z a -tzip -sdel "%OUTPUT_BOOKS_DIR%\%%~nxi.zip" ""%%i\*"" -xr!*.db -xr!*.dat -xr!*.url -xr!.DS_Store -mx=0 -mtc=off
		7z l "%OUTPUT_BOOKS_DIR%\%%~nxi.zip">"%%~nxi.zip.txt"
	)
	RMDIR %%i
)
EXIT

