@echo off
setlocal enabledelayedexpansion

echo ===============================================
echo   Windows 11 Local Account Setup
echo   Custom Username/Password + Bloatware Removal
echo ===============================================
echo.
echo This script will:
echo  1. Ask for your desired username and password
echo  2. Create the account during Windows setup
echo  3. Auto-login once after setup
echo  4. Show a GUI to select bloatware removal level
echo.
pause

:: Get username
echo.
set "USERNAME="
set /p "USERNAME=Enter desired username (or press Enter for 'Admin'): "
if "%USERNAME%"=="" set "USERNAME=Admin"

echo.
echo Username will be: %USERNAME%

:: Get password
echo.
echo Enter desired password (or press Enter for no password):
set "PASSWORD="
set /p "PASSWORD=Password: "

if "%PASSWORD%"=="" (
    echo No password will be set (can login with just Enter)
    set "PASSWORD_VALUE="
) else (
    echo Password will be set
    set "PASSWORD_VALUE=%PASSWORD%"
)

echo.
echo Creating configuration...

:: Set registry bypass
echo Setting registry bypass...
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v BypassNRO /t REG_DWORD /d 1 /f >nul 2>&1

:: Download the GUI script and XML template
echo Downloading configuration files...

curl -L -o C:\Windows\Setup\Scripts\BloatwareGUI.ps1 https://raw.githubusercontent.com/mxoio/bypassnro/main/BloatwareGUI.ps1 2>nul
curl -L -o C:\Windows\Panther\unattend_template.xml https://raw.githubusercontent.com/mxoio/bypassnro/main/unattend_template.xml 2>nul

if not exist C:\Windows\Panther\unattend_template.xml (
    echo ERROR: Could not download configuration files
    echo Make sure you have internet connection
    pause
    exit /b 1
)

:: Replace USERNAME and PASSWORD in the template
powershell.exe -NoProfile -Command "(Get-Content 'C:\Windows\Panther\unattend_template.xml') -replace 'USERNAME_PLACEHOLDER', '%USERNAME%' -replace 'PASSWORD_PLACEHOLDER', '%PASSWORD_VALUE%' | Set-Content 'C:\Windows\Panther\unattend.xml'"

echo.
echo Configuration created successfully!
echo.
echo ================================================
echo WHAT HAPPENS NEXT:
echo ================================================
echo 1. System will reboot and complete Windows setup
echo 2. Account "%USERNAME%" will be created
echo 3. Auto-login will happen once
echo 4. A GUI will appear asking for bloatware level:
echo    - Minimal: Bypass only, keep everything
echo    - Gaming: Remove bloat, KEEP Xbox/Game Bar
echo    - Standard: Balanced removal including Xbox
echo    - Full: Maximum removal + privacy tweaks
echo 5. Selected bloatware will be removed automatically
echo 6. System will be ready to use!
echo ================================================
echo.
echo Press any key to apply configuration and reboot...
pause >nul

echo.
echo Applying configuration and rebooting...
%WINDIR%\System32\Sysprep\Sysprep.exe /oobe /unattend:C:\Windows\Panther\unattend.xml /reboot
