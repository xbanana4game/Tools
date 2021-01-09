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
PATH=%PATH%;%USERPROFILE%\AppData\Local\MEGAcmd

START %USERPROFILE%\AppData\Local\MEGAcmd\MEGAcmdShell.exe

CD %DOWNLOADS_DIR%
SET GET_LINK_LIST=Mega-links-%yyyy%%mm%%dd%_%hh%%mn%.txt
NOTEPAD %GET_LINK_LIST%
FOR /F %%i IN (%GET_LINK_LIST%) DO (
	mega-get "%%i"
)

PAUSE

