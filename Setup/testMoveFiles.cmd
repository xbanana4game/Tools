REM ======================================================================
REM
REM                                Settings
REM
REM ======================================================================
IF NOT EXIST %USERPROFILE%\.Tools\Settings.cmd (EXIT)
CALL %USERPROFILE%\.Tools\Settings.cmd

SET ARCHIVE_FLG=1


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
CALL MoveFiles.cmd

PAUSE
EXIT
