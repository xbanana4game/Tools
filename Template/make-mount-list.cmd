@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Template.cmd(SettingsOptions.cmd) ----------


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
FOR %%i in (Steam-vhdx\*.vhdx) DO (
	ECHO REM SELECT VDISK FILE="%%~fni"
	ECHO REM ATTACH VDISK
	REM ECHO DETACH VDISK
)

FOR %%i in (Games-vhdx\*.vhdx) DO (
	ECHO REM SELECT VDISK FILE="%%~fni"
	ECHO REM ATTACH VDISK
)

ECHO EXIT

PAUSE
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================

