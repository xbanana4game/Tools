@ECHO OFF
REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd
REM ---------- Template.cmd(SettingsOptions.cmd) ----------
IF NOT DEFINED DRIVE_LETTER (SET DRIVE_LETTER=%CD:~0,1%)
SET VHDX_DIR=%DRIVE_LETTER%:\vhdx
REM SET VHDX_DIR=%DRIVE_LETTER%:\vhdx-games

REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
REM START taskschd.msc /s
REM schtasks /query /TN "Auto Mount" /V
FOR %%i in (%VHDX_DIR%\*.vhdx) DO (
	ECHO SELECT VDISK FILE="%%~fni"
	ECHO ATTACH VDISK
	ECHO;
	REM ECHO DETACH VDISK
)
ECHO EXIT

NOTEPAD %VHDX_DIR%\vhdmount.txt

PAUSE
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================

