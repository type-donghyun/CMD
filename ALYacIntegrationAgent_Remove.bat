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
ECHO 제거를 진행하시겠습니까?
CHOICE

IF %errorlevel% == 1 (
	CLS
) ELSE IF %errorlevel% == 2 (
	COLOR 04
	goto :Endlevel
)

SET directory1 = %ProgramFiles%\ESTsoft\ALYac
SET directory2 = %ProgramFiles%\ESTsoft\ALYacIntegrationAgent
SET directory3 = %ProgramFiles%\ESTsoft\ASM
SET directory4 = %ProgramData%\ESTsoft\ALYac
SET directory5 = %ProgramData%\ESTsoft\ALYacIntegrationAgent
SET directory6 = %ProgramData%\ESTsoft\ASM
SET directory7 = %ProgramData%\Microsoft\Windows\"Start menu"\Programs\이스트소프트

ECHO 디렉토리 제거 시작
ECHO.
FOR /l %%i in (1,1,7) do (
	IF EXIST directory%%i (
		RD /s /q directory%%i
		ECHO %%i번째 디렉토리를 제거
	) ELSE (
		ECHO %%i번째 디렉토리를 발견하지 못 함
	)
)
ECHO.
ECHO 디렉토리 제거 완료

TIMEOUT /t 1 > nul
CLS

SET file1 = %ProgramData%\Microsoft\Windows\"Start menu"\알약.lnk

ECHO 파일 제거 시작
ECHO.
FOR /l %%i in (1,1,1) do (
	IF EXIST file%%i (
		DEL /s /q file%%i 2> nul
		ECHO %%i번째 디렉토리를 제거
	) ELSE (
		ECHO %%i번째 디렉토리를 발견하지 못 함
	)
)
ECHO.
ECHO 파일 제거 완료

TIMEOUT /t 1 > nul
CLS

SET registry1 = HKLM\SOFTWARE\ESTsoft\ALYac
SET registry2 = HKLM\SOFTWARE\ESTsoft\ALYacIntegrationAgent
SET registry3 = HKLM\SOFTWARE\ESTsoft\ASM

ECHO 레지스트리 제거 시작
ECHO.
SET /a count = 0

:regdel
SET /a count += 1
REG QUERY registry%count% /f 2> nul
IF %errorlevel% == 0 (
	REG DELETE registry%count% /f 2> nul
	ECHO %count%번째 레지스트리를 제거
) ELSE IF %errorlevel% == 1 (
	ECHO %count%번째 레지스트리를 발견하지 못 함
)

IF %count% lss 3 (
	GOTO :regdel
)
ECHO.
ECHO 레지스트리 제거 완료

TIMEOUT /t 1 > nul
CLS

:Endlevel
CLS
ECHO 작업을 종료합니다.
BCDEDIT /deletevalue {current} safeboot > nul
TIMEOUT /t 3 > nul
SHUTDOWN /r /t 2 /c "안전모드 해제 후, 다시 시작합니다." /f
