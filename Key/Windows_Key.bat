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

FOR /f "tokens=4-6" %%a in ('systeminfo') do (
	IF "%%a" equ "Windows" (
		SET OSname=%%a
		SET version=%%b
		SET edition=%%c
	)
)

CHCP 65001 > nul

IF "%OSname%" equ "Windows" (
	GOTO :dowork
) ELSE (
	%echored% 운영체제가 Windows가 아닙니다.
	GOTO :workend
)

IF "%version%" equ "10" (
	GOTO :dowork
) ELSE IF "%version%" equ "11" (
	GOTO :dowork
) ELSE (
	%echored% Windows 버전이 10/11이 아닙니다.
	GOTO :workend
)

:dowork
IF "%edition%" equ "Pro" (
	%echoyellow% Windows %version% %edition%가 감지되었습니다.
	SLMGR /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
) ELSE IF "%edition%" equ "Home" (
	%echoyellow% Windows %version% %edition%이 감지되었습니다.
	SLMGR /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
) ELSE (
	%echored% 활성화할 수 없는 Windows 버전입니다: %edition%
	GOTO :workend
)

SLMGR /skms kms.digiboy.ir
SLMGR /ato

CLS
%echogreen% Windows 정품이 활성화되었습니다.
CHOICE /c 12 /n /t 3 /d 2 /m "라이센스 정보와 만료 날짜를 확인하시겠습니까? [1] Yes, [2] No"

CLS
IF %errorlevel% equ 1 (
	SLMGR /xpr
	SLMGR /dlv
)

:workend
ECHO 작업을 종료합니다.
TIMEOUT /t 3 > nul
EXIT /b
