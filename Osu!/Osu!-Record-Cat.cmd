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
IF NOT DEFINED TARGET_YYYY (SET /P TARGET_YYYY="SET TARGET_YYYY : ")
IF NOT DEFINED TARGET_YYYY (SET TARGET_YYYY=%yyyy%)

SET OUTPUT=Osu!-Record-%TARGET_YYYY%.txt
IF EXIST %OUTPUT% DEL %OUTPUT%
FOR %%i IN (Osu!-Record-%TARGET_YYYY%*.txt) DO (
	ECHO %%i
	ECHO ======================================================================>>%OUTPUT%
	ECHO %%~ni>>%OUTPUT%
	ECHO ======================================================================>>%OUTPUT%
	TYPE %%i>>%OUTPUT%
)

PAUSE
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================
