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
ECHO Windows 10 Pro 정품 활성화 중...
ECHO 정품 인증은 6개월 후, 만료됩니다.

SLMGR /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
SLMGR /skms kms.digiboy.ir
SLMGR /ato
SLMGR /xpr
SLMGR /dlv