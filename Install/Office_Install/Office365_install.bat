@ECHO OFF
::================================================================================관리자 권한 요청
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
::====================================================================================================

::================================================================================ECHO 색상 설정
SET _elev=
IF /i "%~1"=="-el" SET _elev=1
FOR /f "tokens=6 delims=[]. " %%G in ('ver') do set winbuild=%%G
SET "_null=1>nul 2>nul"
SET "_psc=powershell"
SET "EchoRed=%_psc% write-host -back Black -fore Red"
SET "EchoGreen=%_psc% write-host -back Black -fore Green"
SET "ErrLine=echo: & %EchoRed% ==== ERROR ==== &echo:"
::====================================================================================================

CHCP 65001 > nul

ECHO Office 365 설치
%echogreen% 포함된 제품은 Excel, Word, Powerpoint입니다.
ECHO 설치에는 인터넷 연결이 필요하며 시간이 다소 소요될 수 있습니다.
ECHO 10초 후, 설치가 시작됩니다.
TIMEOUT /t 10 > nul

CLS
CD data > nul
ECHO 설치 파일 다운로드 중...
setup.exe /download configuration.xml
CLS
ECHO 설치 진행 중...
setup.exe /configure configuration.xml
