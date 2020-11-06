@ECHO OFF
REM ----------------------------------------------------------------------
REM Read Settings
REM ----------------------------------------------------------------------
IF NOT EXIST %USERPROFILE%\Settings.cmd (EXIT)
CALL %USERPROFILE%\Settings.cmd


REM ======================================================================
REM
REM                                INSTALL
REM
REM ======================================================================
CALL :INSTALL_ARCHIVE_TOOLS
CALL :Msg Finished
EXIT


REM ======================================================================
REM
REM                                Function
REM
REM ======================================================================	
:INSTALL_ARCHIVE_TOOLS
	SET /P INSTALL_DRIVE="DRIVE(A:, C:\disk1)-> "
	SET /P INSTALL_PROFILE="PROFILE-> "
	ECHO "Make %INSTALL_DRIVE%\%INSTALL_PROFILE%.archive"
	
	IF NOT EXIST "%INSTALL_DRIVE%\%INSTALL_PROFILE%.archive" (COPY profile.archive %INSTALL_DRIVE%\%INSTALL_PROFILE%.archive)
	NOTEPAD %INSTALL_DRIVE%\%INSTALL_PROFILE%.archive

	IF NOT EXIST "%INSTALL_DRIVE%\ArchiveOptions.cmd" (COPY ArchiveOptions.cmd %INSTALL_DRIVE%\ArchiveOptions.cmd)
	NOTEPAD %INSTALL_DRIVE%\ArchiveOptions.cmd
	
	REM COPY Archive-Tool.cmd %INSTALL_DRIVE%\Archive-Tool.cmd
	
	EXIT /B
	
:Msg
	SET MSG=%1
	SET /P END=%MSG%
	EXIT /B

