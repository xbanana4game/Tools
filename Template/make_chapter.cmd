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
ECHO VLC Screenshot settings
ECHO $d.jpg-_-$T_-

CD %PICTURES_DIR%
DIR /B *.jpg >chapter.txt

ECHO RUN vlcjpg-chapter.ppa
%SAKURA% chapter.txt
EXIT

