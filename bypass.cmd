@echo off
echo ===============================================
echo   Windows 11 Local Account Bypass
echo   Run this during OOBE (Windows Setup)
echo ===============================================
echo.
echo Select your profile:
echo   1. Minimal
echo   2. Standard (Recommended)
echo   3. Gaming
echo   4. Full Debloat
echo.
set /p profile="Enter choice (1-4): "

if "%profile%"=="1" set "xml=minimal"
if "%profile%"=="2" set "xml=standard"
if "%profile%"=="3" set "xml=gaming"
if "%profile%"=="4" set "xml=full"

if "%xml%"=="" (
    echo Invalid choice! Defaulting to Standard...
    set "xml=standard"
)

echo.
echo Downloading %xml% configuration...
curl -L -o C:\Windows\Panther\unattend.xml https://bypassnro.mxioi.uk/unattend-%xml%.xml

if errorlevel 1 (
    echo Download failed! Check your internet connection.
    pause
    exit /b 1
)

echo.
echo Configuration downloaded successfully.
echo.
echo This will create a local account named "Admin" with NO password.
echo After first boot, you can rename it and add a password in Settings.
echo.
echo System will reboot and continue setup automatically...
timeout /t 3

%WINDIR%\System32\Sysprep\Sysprep.exe /oobe /unattend:C:\Windows\Panther\unattend.xml /reboot
