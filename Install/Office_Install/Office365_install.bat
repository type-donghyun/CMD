@ECHO OFF
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
IF %errorlevel% neq 0 (
	GOTO UACPrompt
) ELSE (
	GOTO gotAdmin
)
:UACPrompt
	ECHO SET UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
	SET params = %*:"=""
	ECHO UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
	"%temp%\getadmin.vbs"
	REM DEL "%temp%\getadmin.vbs"
	EXIT /b
:gotAdmin
PUSHD "%CD%"
	CD /d "%~dp0"

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
