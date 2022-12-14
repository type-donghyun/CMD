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

CHCP 65001

REG ADD "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d 1 /f > nul
GPUPDATE /force
%echogreen% Windows 업데이트에 드라이버를 포함하지 않음 옵션을 사용으로 변경했습니다.
TIMEOUT /t 3 > nul
