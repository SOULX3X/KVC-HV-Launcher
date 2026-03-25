@echo off
echo ================================================
echo       KVC DSE Bypass Launcher By SOULX3X
echo ================================================

fltmc >nul 2>&1
if errorlevel 1 (
    echo.
    echo This script requires administrator privileges.
    echo.
    echo A UAC prompt will appear. Please click "Yes".
    echo.

    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -ArgumentList '__MINIMIZED__' -Verb RunAs -WindowStyle Minimized"
    exit /b
)

if /i not "%~1"=="__MINIMIZED__" (
    start "" /min "%~f0" __MINIMIZED__
    exit /b
)

cd /d "%~dp0"

REM ============================================================
REM Ensure kvc.exe exists (download if missing)
REM ============================================================

if exist "kvc.exe" goto KVC_READY

echo kvc.exe not found, installing...

set "URL=https://github.com/wesmar/kvc/releases/download/v1.0.1/kvc.7z"
set "INSTALL_DIR=KVC Installing"
set "ARCHIVE=%INSTALL_DIR%\kvc.7z"

mkdir "%INSTALL_DIR%" >nul 2>&1

set RETRIES=0

:DOWNLOAD_RETRY

powershell -NoProfile -Command "Invoke-WebRequest '%URL%' -OutFile '%ARCHIVE%'" >nul 2>&1

if exist "%ARCHIVE%" goto EXTRACT_KVC

set /a RETRIES+=1

if %RETRIES% GEQ 3 (
    echo ERROR: failed to download kvc after 3 attempts.
    pause
    goto END
)

echo Download failed. Retrying...
timeout /t 2 /nobreak >nul
goto DOWNLOAD_RETRY


:EXTRACT_KVC

echo Extracting archive...

if not exist "7zr.exe" (
    powershell -NoProfile -Command "Invoke-WebRequest 'https://www.7-zip.org/a/7zr.exe' -OutFile '7zr.exe'" >nul 2>&1
)
if exist "7zr.exe" 7zr.exe x "%ARCHIVE%" -o"%INSTALL_DIR%" -p"github.com" -y >nul 2>&1

set WAIT_COUNT=0

:WAIT_FOR_KVC

if exist "%INSTALL_DIR%\kvc.exe" goto MOVE_KVC

set /a WAIT_COUNT+=1

if %WAIT_COUNT% GEQ 30 (
    echo ERROR: extraction failed.
    rd /s /q "%INSTALL_DIR%" >nul 2>&1
    if exist "7zr.exe" del /f /q "7zr.exe" >nul 2>&1
    pause
    goto END
)

timeout /t 1 /nobreak >nul
goto WAIT_FOR_KVC


:MOVE_KVC

move "%INSTALL_DIR%\kvc.exe" "kvc.exe" >nul

rd /s /q "%INSTALL_DIR%" >nul 2>&1
if exist "7zr.exe" del /f /q "7zr.exe" >nul 2>&1

echo kvc.exe ready.

:KVC_READY

REM ============================================================


:: ============================
:: CHECK CORE ISOLATION STATUS
:: ============================

echo Checking Core Isolation (Memory Integrity)...

set "CI="

for /f "tokens=3" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled 2^>nul ^| find /i "Enabled"') do set CI=%%A
set CI=%CI: =%

echo Detected CI value: "%CI%"

if "%CI%"=="" goto CHECK_MSI
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
:: CHECK MSI AFTERBURNER
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
        ) do for /f "delims=" %%B in ("%%A") do set "MSI_PATH=%%B"

    taskkill /IM MSIAfterburner.exe /F >nul 2>&1
) else (
    echo MSI Afterburner is not running.
)

echo Core Isolation is disabled. Continuing...
echo.

timeout /t 0 /nobreak >nul

echo [1/3] Disabling DSE...
kvc.exe dse off --safe
if errorlevel 1 (
    echo ERROR: Failed to disable DSE.
    pause
    goto RESTORE_MSI
)


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
    goto RESTORE_MSI
)

echo Found: %loader%
start "" "%loader%"

timeout /t 0 /nobreak >nul

echo [3/3] Enabling DSE...
kvc.exe dse on --safe

:RESTORE_MSI
if "%MSI_RUNNING%"=="1" (
    echo Restarting MSI Afterburner...
    if defined MSI_PATH start "" "%MSI_PATH%"
)

timeout /t 0 /nobreak >nul & if exist "%~dp0kvc.exe" del /f /q "%~dp0kvc.exe" >nul 2>&1

:END
exit