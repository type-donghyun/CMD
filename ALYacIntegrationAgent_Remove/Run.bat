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
	DEL "%temp%\getadmin.vbs"
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
SET "EchoBlack=%_psc% write-host -back DarkGray -fore Black"
SET "EchoBlue=%_psc% write-host -back Black -fore DarkBlue"
SET "EchoGreen=%_psc% write-host -back Black -fore Darkgreen"
SET "EchoCyan=%_psc% write-host -back Black -fore DarkCyan"
SET "EchoRed=%_psc% write-host -back Black -fore DarkRed"
SET "EchoPurple=%_psc% write-host -back Black -fore DarkMagenta"
SET "EchoYellow=%_psc% write-host -back Black -fore DarkYellow"
SET "EchoWhite=%_psc% write-host -back Black -fore Gray"
SET "EchoGray=%_psc% write-host -back Black -fore DarkGray"
SET "EchoLightBlue=%_psc% write-host -back Black -fore Blue"
SET "EchoLightGreen=%_psc% write-host -back Black -fore Green"
SET "EchoLightCyan=%_psc% write-host -back Black -fore Cyan"
SET "EchoLightRed=%_psc% write-host -back Black -fore Red"
SET "EchoLightPurple=%_psc% write-host -back Black -fore Magenta"
SET "EchoLightYellow=%_psc% write-host -back Black -fore Yellow"
SET "EchoBrightWhite=%_psc% write-host -back Black -fore White"
SET "ErrLine=echo: & %EchoRed% ==== ERROR ==== &echo:"
::====================================================================================================

CHCP 65001 > nul

ECHO 알약 통합에이전트 제거를 위해 안전모드로 다시 시작해야합니다.
ECHO 다시 시작 시, 실행되고 있는 모든 프로그램이 강제로 종료됩니다.
%echowarning% 다시 시작 후, 바탕 화면의 [저를 실행해주세요!]를 실행해주세요.
CHOICE /c 12 /n /t 3 /d 2 /m "안전모드로 변경 후 다시 시작하시겠습니까? [1] Yes, [2] No"

CLS
IF %errorlevel% equ 1 (
	BCDEDIT /set {current} safeboot minimal > nul
	COPY "bat\ALYacIntegrationAgent_Remove.bat" "%UserProfile%\desktop\저를 실행해주세요!.bat" > nul
	SHUTDOWN /r /t 3 /c "안전모드로 다시 시작합니다." /f
) ELSE IF %errorlevel% equ 2 (
	ECHO 작업을 종료합니다.
	TIMEOUT /t 3 > nul
)
