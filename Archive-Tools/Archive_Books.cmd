@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd

REM ---------- Archive_Books.cmd(SettingsOptions) ----------
REM SET BOOKS_ZIP_DIR=%DOWNLOADS_DIR%\Books-zip


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
IF NOT DEFINED BOOKS_ZIP_DIR SET BOOKS_ZIP_DIR=%DOCUMENTS_DIR%\Books-zip
IF NOT EXIST %BOOKS_ZIP_DIR% MD %BOOKS_ZIP_DIR%

FOR %%i in (%*) DO (
	ECHO %%i
	IF NOT EXIST "%BOOKS_ZIP_DIR%\%%~nxi.zip" (
		7z a -tzip -sdel "%BOOKS_ZIP_DIR%\%%~nxi.zip" ""%%i\*"" -xr!*.db -xr!*.dat -xr!*.url -xr!.DS_Store -mx=0 -mtc=off
		7z l "%BOOKS_ZIP_DIR%\%%~nxi.zip">"%%~nxi.zip.txt"
	)
	books_rename.py "%BOOKS_ZIP_DIR%\%%~nxi.zip"
	RMDIR %%i
)
EXIT

