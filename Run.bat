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

ECHO 알약 통합에이전트 제거를 위해 안전모드로 다시 시작해야합니다.
ECHO 다시 시작 시, 실행되고 있는 모든 프로그램이 강제로 종료됩니다.
ECHO 다시 시작 후, 바탕 화면의 {저를 실행해주세요!}를 실행해주세요.
ECHO 안전모드로 변경 후 다시 시작하시겠습니까?
CHOICE

CLS
IF %errorlevel% equ 1 (
	BCDEDIT /set {current} safeboot minimal > nul
	COPY bat\ALYacIntegrationAgent_Remove.bat %UserProfile%\desktop\"저를 실행해주세요!".bat > nul
	SHUTDOWN /r /t 3 /c "안전모드로 다시 시작합니다." /f
) ELSE IF %errorlevel% equ 2 (
	ECHO 작업을 종료합니다.
	TIMEOUT /t 3 > nul
	EXIT
)
