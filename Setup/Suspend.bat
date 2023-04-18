REM powercfg /a
REM powercfg -h off
TIMEOUT /T 5
rundll32.exe PowrProf.dll,SetSuspendState
EXIT
