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

REG ADD HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate /v ExcludeWUDriversInQualityUpdate /t REG_DWORD /d 1 /f > nul
GPUPDATE /force
CHCP 65001 > nul
ECHO Windows 업데이트에 드라이버를 포함하지 않음 옵션을 사용으로 변경했습니다.
TIMEOUT /t 3 > nul

