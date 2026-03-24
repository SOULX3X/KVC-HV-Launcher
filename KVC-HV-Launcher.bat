@echo off
echo ================================================
echo       KVC DSE Bypass Launcher By SOULX3X
echo ================================================

if /i not "%~1"=="__MINIMIZED__" (
    start "" /min cmd /c ""%~f0" __MINIMIZED__"
    exit /b
)

fltmc >nul 2>&1
if errorlevel 1 (
    echo.
    echo This script requires administrator privileges.
    echo.
    echo A UAC prompt will appear. Please click "Yes".
    echo.
    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -Verb RunAs -WindowStyle Hidden" >nul 2>&1
    exit /b
)

cd /d "%~dp0"

:: ============================
:: CHECK CORE ISOLATION STATUS
:: ============================
echo Checking Core Isolation (Memory Integrity)...

set "CI="

for /f "tokens=3" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled 2^>nul ^| find /i "Enabled"') do set CI=%%A
set CI=%CI: =%

echo Detected CI value: "%CI%"

if "%CI%"=="" (
    echo Core Isolation key not found. Assuming it is disabled.
    goto CHECK_MSI
)

if /i "%CI%"=="1" goto CORE_ON
if /i "%CI%"=="0x1" goto CORE_ON

goto CHECK_MSI

:CORE_ON
color 0C
echo.
echo ================================================
echo   ERROR: Core Isolation (Memory Integrity) is ON
echo ===============================================
echo.
echo Please DISABLE Core Isolation (Memory Integrity)
echo from Windows Security - Device Security.
echo.
echo After disabling it, RESTART your PC
echo and run this script again.
echo.
pause
color 07
goto END


:: ============================================
:: CHECK IF MSI AFTERBURNER IS RUNNING
:: ============================================
:CHECK_MSI
echo Checking MSI Afterburner status...

set "MSI_RUNNING=0"
set "MSI_PATH="

tasklist /FI "IMAGENAME eq MSIAfterburner.exe" | find /I "MSIAfterburner.exe" >nul
if %errorlevel%==0 (
    echo MSI Afterburner is running. Closing it...
    set "MSI_RUNNING=1"

    for /f "tokens=2 delims==" %%A in (
     'wmic process where "name='MSIAfterburner.exe'" get ExecutablePath /value 2^>nul'
    ) do set "MSI_PATH=%%A"

    taskkill /IM MSIAfterburner.exe /F >nul 2>&1
) else (
    echo MSI Afterburner is not running.
)

echo.
goto CONTINUE_SCRIPT


:CONTINUE_SCRIPT
echo Core Isolation is disabled. Continuing...
echo.

timeout /t 1 /nobreak > nul

echo [1/3] Disabling DSE...
kvc.exe dse off --safe

timeout /t 0 /nobreak >nul

echo Searching for loader executable...

set "loader="

if exist "steamclient_loader_x64.exe" set "loader=steamclient_loader_x64.exe"
if not defined loader if exist "HypervisorLauncher.exe" set "loader=HypervisorLauncher.exe"
if not defined loader if exist "launcher.exe" set "loader=launcher.exe"
if not defined loader if exist "hypervisor-launcher.exe" set "loader=hypervisor-launcher.exe"
if not defined loader if exist "HV-StartGame.exe" set "loader=HV-StartGame.exe"

if not defined loader (
    echo ERROR: No loader executable found!
    pause
    goto END
)

echo Found: %loader%
start "" "%loader%"

timeout /t 1 /nobreak >nul

echo [3/3] Enabling DSE...
kvc.exe dse on --safe

:: ============================================
:: RESTART MSI AFTERBURNER IF IT WAS RUNNING
:: ============================================
if "%MSI_RUNNING%"=="1" (
    echo Restarting MSI Afterburner...
    if defined MSI_PATH start "" "%MSI_PATH%"
) else (
    echo MSI Afterburner was not running before. Skipping restart.
)

:END
exit