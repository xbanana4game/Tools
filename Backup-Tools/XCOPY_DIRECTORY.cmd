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
SET /P XCOPY_DIR_NAME="XCOPY_DIR_NAME default:youtube.com->"
IF "%XCOPY_DIR_NAME%"=="" SET XCOPY_DIR_NAME=youtube.com
SET /P XCOPY_DIR_FROM="XCOPY_DIR_FROM default:M:%XCOPY_DIR_NAME%->"
IF "%XCOPY_DIR_FROM%"=="" SET XCOPY_DIR_FROM=M:%XCOPY_DIR_NAME%

MD %XCOPY_DIR_NAME%
CD %XCOPY_DIR_NAME%

XCOPY %XCOPY_DIR_FROM% . /T

PAUSE