@echo off

rem VBScript�t�@�C���̃p�X
set vbsFile=C:\Users\tomas\Desktop\msgbox.vbs

rem ����VBScript�t�@�C�������݂�����폜
if exist "%vbsFile%" (
	del /f "%vbsFile%"
)

REM VBScript�t�@�C���쐬
echo Dim result >> %vbsFile%
echo result = msgbox("���������s���܂����H" ,vbOKCancel + vbInformation, "���b�Z�[�W") >> "%vbsFile%"
echo WScript.Quit(result) >> "%vbsFile%"

rem VBScript�t�@�C�����s
"%vbsFile%"

rem ���b�Z�[�W�{�b�N�X�ŃN���b�N���ꂽ�{�^�����m�F
if %errorlevel% == 1 (
    echo ���������s���܂����B
) else if %errorlevel% == 2 (
    echo �������L�����Z�����܂����B
)

rem VBScript�t�@�C���폜
del /f "%vbsFile%"

echo.
pause
exit

