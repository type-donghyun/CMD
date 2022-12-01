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

ECHO Office 365 설치
ECHO 포함된 제품은 Excel, Word, Powerpoint입니다.
ECHO 설치에는 인터넷 연결이 필요하며 시간이 다소 소요될 수 있습니다.
ECHO 아무 버튼이나 누르면 설치가 시작됩니다.
PAUSE > nul

CD data > nul
ECHO 설치 파일 다운로드 중...
setup.exe /download configuration.xml
CLS
ECHO 설치 중...
setup.exe /configure configuration.xml
