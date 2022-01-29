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
CD %DESKTOP_DIR%
MD Paladins
CD Paladins

md Damage
cd Damage
md Bomb_King
md Cassie
md Dredge
md Drogoz
md Imani
md Kinessa
md Lian
md Sha_Lin
md Strix
md Tiberius
md Tyra
md Viktor
md Vivian
md Willo
md Octavia
cd ..

md Flank
cd Flank
md Androxus
md Buck
md Evie
md Lex
md Maeve
md Moji
md Skye
md Talus
md Vora
md Zhin
md Vatu
cd ..

md Frontline
cd Frontline
md Ash
md Atlas
md Barik
md Inara
md Khan
md Makoa
md Ruckus
md Terminus
md Torvald
md Fernando
md Yagorath
cd ..

md Support
cd Support
md Corvus
md Furia
md Grohk
md Grover
md Io
md Jenos
md Pip
md Seris
md Ying
md Mal'Damba
cd ..