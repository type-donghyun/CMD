@ECHO OFF
CHCP 65001 > nul
FOR /f "tokens=4-6" %%a in ('systeminfo') do (
	IF %%a equ Windows (
		SET hello=%%a %%b %%c
	)
)

ECHO 설치된 윈도우는 %hello%입니다
SET hello=%%hello

IF %%hello equ "Windows 10 Pro" (
	echo 프로
) ELSE IF %%hello equ "Windows 10 Home" (
	echo 홈
) ELSE (
	ECHO 불가능한 Windows 버전: hello%
)
TIMEOUT /t 10 > nul
