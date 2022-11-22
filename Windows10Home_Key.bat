@ECHO OFF
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    rem del "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
pushd "%CD%"
    CD /D "%~dp0"

CHCP 65001 > nul
ECHO Windows 10 Home 정품 활성화 중...
ECHO 정품 인증은 6개월 후, 만료됩니다.

SLMGR /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
SLMGR /skms kms.digiboy.ir
SLMGR /ato
SLMGR /xpr
SLMGR /dlv