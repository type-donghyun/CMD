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

ECHO 알약 통합에이전트 제거를 위한 작업입니다.
ECHO Uninstall 권한이 없어 프로그램 파일과 레지스트리를 직접 제거합니다.
ECHO 제거를 진행하시겠습니까?
CHOICE

IF %errorlevel% equ 1 (
	CLS
) ELSE IF %errorlevel% equ 2 (
	COLOR 04
	GOTO End
)

COLOR 04
ECHO ====================================================
ECHO 백그라운드에서 동작 중인 알약 프로세스를 강제로 종료
ECHO ====================================================
TASKKILL /im "AYCUpdSrv.ayc" /t /f 2> nul
TIMEOUT /t 3 > nul

CLS
COLOR 06
ECHO ==================
ECHO 디렉토리 제거 시작
ECHO ==================
TIMEOUT /t 3 > nul

CLS
RD /s /q "%Program Files%\ESTsoft"
RD /s /q "%ProgramData%\ESTsoft"
RD /s /q "%ProgramData%\Microsoft\Windows\Start Menu\Programs\이스트소프트"
PAUSE

CLS
COLOR 0A
ECHO ==================
ECHO 디렉토리 제거 완료
ECHO ==================
TIMEOUT /t 3 > nul

CLS
COLOR 06
ECHO ==============
ECHO 파일 제거 시작
ECHO ==============
TIMEOUT /t 3 > nul

CLS
DEL /s /q "%ProgramData%\Microsoft\Windows\Start menu\알약.lnk"
DEL /s /q "%UserProfile%\Desktop\알약.lnk"
PAUSE

CLS
COLOR 0A
ECHO ==============
ECHO 파일 제거 완료
ECHO ==============
TIMEOUT /t 3 > nul

CLS
COLOR 06
ECHO ====================
ECHO 레지스트리 제거 시작
ECHO ====================
TIMEOUT /t 3 > nul

CLS
REG DELETE "HKCR\*\shellex\ContextMenuHandlers\ALYac" /f
REG DELETE "HKCR\CLSID\{22C7B543-DCDE-48F6-A226-524D67C4428D}" /f
REG DELETE "HKCR\TypeLib\{6A479902-8E46-4413-A8C4-F270468C95FB}" /f
REM 	값 데이터			REG DELETE HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UFH\SHC" /v "C:\ProgramData\Microsoft\Windows\Start Menu\알약.lnk" /f
REM 	값 데이터			REG DELETE HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UFH\SHC" /v "C:\Program Files\ESTsoft\ALYac\AYCLaunch.exe" /f
REG DELETE "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store" /v "C:\Program Files\ESTsoft\ALYac\AYCLaunch.exe" /f
REG DELETE "HKLM\SOFTWARE\ESTsoft\ALYac" /f
REG DELETE "HKLM\SOFTWARE\ESTsoft\ALYacIntegrationAgent" /f
REG DELETE "HKLM\SOFTWARE\ESTsoft\ASM" /f
REG DELETE "HKLM\SOFTWARE\ESTsoft" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Security Center\Provider\Av\{5B7204C1-D426-0E58-80E9-8987FC08E2AC}" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Security Center\Provider\Fw\{634985E4-9E49-0F00-ABB6-20B202DBA5D7}" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Security Center\Provider\Fw\{85094255-782A-66B3-E410-0F5785E13919}" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Security Center\Provider\Av\{BD32C370-3245-67EB-CF4F-A6627B327E62}" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "ALYac" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "ALYacIntegrationAgent" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ALYac_is1" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ALYacIntegrationAgent" /f
REG DELETE "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ALYacIntegrationAgent_is1" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\ALYac_IASrv" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\ALYac_RTSrv" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\ALYac_UpdSrv" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\ALYac_WSSrv" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\EscWfp" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\EstRtwIFDrv" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{016FA45E-EC0A-412F-ACF0-09821EA7BE44}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{03B78843-63BC-4C77-A96B-4604E28ED289}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{117686BF-123F-42F5-AA4F-20ABA3F4FBB2}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{1A106844-60E3-447E-B1E0-35A6E1C3F213}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{20C048B2-736B-49DE-AE01-8DED803B10DA}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{3A61DAF3-8598-4669-A61C-05CA8E6E7011}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{3FFEBE2C-C9F0-48F0-A900-48517BF9BFB6}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{53084479-460F-4139-8185-1BF02B42647E}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{5593FFFA-9E1A-44B3-9E58-9A8708B8C8F8}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{55D1A199-E4C7-41AF-8CE3-C03502CDEF03}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{74216C38-D905-48C9-9844-1EA9E0E9B12C}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{7583D591-7F5A-4898-8A6D-B318AA9370F2}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{77F1961C-501F-4527-8728-5C3C89587C7D}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{7CF7C13B-C540-4247-8441-E082060847C6}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{7DA4ED27-8D36-4C76-A270-758E94B582B8}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{8527E817-187C-4437-B4E7-AB97B785B74C}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{8EF51641-69DA-4A85-801A-423E5661DDF6}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{95DD7CAB-89BB-4486-9B31-ADA064AE4F45}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{9A97A68B-5E71-4CEB-89BF-90022E6670DB}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{A811AF3C-A5B7-4BD2-B870-E05722ADA3B0}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{ACB7374D-6CAB-49DD-B72A-832DAF0D9BD1}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{B1AC5B5C-2ED5-4B27-B5F8-9E15F0AFA20A}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{BAC97EB4-CDB1-4A6B-B510-48A49BA607A5}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{C9FE8503-1BBC-4ACE-B6F1-F75C8790DF72}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{CBF1D6BD-1235-4FF7-9830-1F2222D10DC4}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{D53CB706-0DF6-4A54-A301-B22720157AE7}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{E0BEB4B1-01DB-4B28-825B-773A16676525}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{ED35D22F-A741-4444-A248-E9E999F4A7CA}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{F14F24B5-2465-4979-B7A1-E6E0641B1620}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" /v "{FCAAF1D2-9D12-475E-AD86-A3586CF43D60}" /f
REG DELETE "HKLM\SYSTEM\ControlSet001\Services\trufos" /f
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Minimal\ALYac_UpdSrv" /f
REG DELETE "HKLM\SYSTEM\CurrentControlSet\Control\SafeBoot\Network\ALYac_UpdSrv" /f

CLS
COLOR 0A
ECHO ====================
ECHO 레지스트리 제거 완료
ECHO ====================
TIMEOUT /t 3 > nul

:End
CLS
BCDEDIT /deletevalue {current} safeboot > nul
SHUTDOWN /r /t 5 /c "안전모드 해제 후, 다시 시작합니다." /f
DEL /s /q "%UserProfile%\desktop\저를 실행해주세요!.bat" 2> nul
