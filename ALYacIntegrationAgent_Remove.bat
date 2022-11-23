@ECHO OFF
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
IF '%errorlevel%' NEQ '0' (
	goto UACPrompt
) ELSE (goto gotAdmin)
:UACPrompt
	ECHO SET UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
	SET params = %*:"=""
	ECHO UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"
	"%temp%\getadmin.vbs"
	REM del "%temp%\getadmin.vbs"
	EXIT /b
:gotAdmin
pushd "%CD%"
	CD /d "%~dp0"

CHCP 65001 > nul

ECHO 알약 통합에이전트 제거를 위한 작업입니다.
ECHO Uninstall 권한이 없어 프로그램 파일과 레지스트리를 직접 제거합니다.
:ReQ
ECHO 제거를 진행합니다.
CHOICE

IF %errorlevel% == 1 (
	ECHO > nul
) ELSE IF %errorlevel% == 2 (
	ECHO 작업을 취소합니다.
	goto :Endlevel
) ELSE (
	goto :ReQ
)

CLS

SET directory1=C:\"Program Files"\ESTsoft\ALYac
SET directory2=C:\"Program Files"\ESTsoft\ALYacIntegrationAgent
SET directory3=C:\"Program Files"\ESTsoft\ASM
SET directory4=C:\ProgramData\ESTsoft\ALYac
SET directory5=C:\ProgramData\ESTsoft\ALYacIntegrationAgent
SET directory6=C:\ProgramData\ESTsoft\ASM

ECHO 디렉토리 제거 시작
FOR /l %%i in (1,1,6) do (
	IF EXIST directory%%i (
		RMDIR /s /q directory%%i
		ECHO %%i번째 디렉토리를 제거
	) ELSE (
		ECHO %%i번째 디렉토리를 발견하지 못 함
	)
)
ECHO 디렉토리 제거 완료

TIMEOUT /t 1 > nul
CLS

SET registry1=HKEY_LOCAL_MACHINE\SOFTWARE\ESTsoft\ALYac
SET registry2=HKEY_LOCAL_MACHINE\SOFTWARE\ESTsoft\ALYacIntegrationAgent
SET registry3=HKEY_LOCAL_MACHINE\SOFTWARE\ESTsoft\ASM

ECHO 레지스트리 제거 시작
FOR /l %%i in (1,1,3) do (
	REG DELETE registry%%i /ve /va /f 2> %%i
	IF %errorlevel%==1 (
		ECHO %%i번째 레지스트리를 발견하지 못 함
	) ELSE (
		ECHO %%i번째 레지스트리를 제거
	)
)
ECHO 레지스트리 제거 완료

:Endlevel
BCDEDIT /deletevalue {current} safeboot
TIMEOUT /t 3 > nul
SHUTDOWN /r /t 2 /c "안전모드 해제 후, 다시 시작합니다." /f
