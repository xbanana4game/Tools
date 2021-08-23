@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd


REM ======================================================================
REM
REM                                Main
REM
REM ======================================================================
REM ----------------------------------------------------------------------
REM 
REM ----------------------------------------------------------------------
SET /P TREE_DIR="Target Directory(A:, C:\disk1)-> "
SET /P TREE_PROFILE="PROFILE-> "
TREE /F "%TREE_DIR%\" >"%USERPROFILE%\Desktop\%TREE_PROFILE%.txt"
"%USERPROFILE%\Desktop\%TREE_PROFILE%.txt"



