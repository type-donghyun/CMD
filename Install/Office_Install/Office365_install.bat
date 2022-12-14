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

TITLE Office 365 설치
ECHO Office 365 설치
ECHO.
%echoblack% 포함된 제품
%echogreen% Excel
%echolightblue% Word
%echolightred% Powerpoint
ECHO.
ECHO 설치에는 인터넷 연결이 필요하며 시간이 다소 소요될 수 있습니다.
CHOICE /c 12 /n /t 3 /d 2 /m "설치를 진행하시겠습니까? [1] Yes, [2] No"

IF %errorlevel% equ 1 (
	CLS
	CD data > nul
	ECHO 설치 파일 다운로드 중...
	setup.exe /download configuration.xml

	CLS
	ECHO 설치 진행 중...
	setup.exe /configure configuration.xml
)
