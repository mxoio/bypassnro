@echo off
setlocal enabledelayedexpansion

echo ===============================================
echo   Windows 11 Local Account Bypass
echo   Based on Chris Titus Tech's method
echo ===============================================
echo.
echo This will:
echo - Create a local Admin account (no password)
echo - Bypass Microsoft account requirement
echo - Auto-login once to complete setup
echo - Remove most bloatware
echo.
echo Press any key to continue or Ctrl+C to cancel...
pause >nul

echo.
echo Enter your desired username (or press Enter for "Admin"):
set /p username=Username:
if "%username%"=="" set "username=Admin"

echo.
echo Creating unattend.xml for user: %username%
echo.

:: Get script directory
set "SCRIPT_DIR=%~dp0"

:: Check for local unattend.xml first
if exist "%SCRIPT_DIR%unattend.xml" (
    echo Using local unattend.xml...
    copy /Y "%SCRIPT_DIR%unattend.xml" "C:\Windows\Panther\unattend.xml" >nul 2>&1
    if errorlevel 1 (
        echo ERROR: Failed to copy local unattend.xml
        pause
        exit /b 1
    )
    echo Local file copied successfully!
) else (
    echo Local unattend.xml not found, downloading from GitHub...
    curl -L -o C:\Windows\Panther\unattend.xml https://raw.githubusercontent.com/ChrisTitusTech/bypassnro/main/unattend.xml

    if errorlevel 1 (
        echo ERROR: Failed to download unattend.xml
        echo.
        echo Make sure you have internet connection, or place unattend.xml
        echo in the same folder as this script
        pause
        exit /b 1
    )
    echo Downloaded successfully!
)
echo.

:: Modify the username if not using default "Admin"
if not "%username%"=="Admin" (
    echo Customizing username to: %username%
    powershell -NoProfile -Command "$xml = [xml](Get-Content 'C:\Windows\Panther\unattend.xml'); $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable); $ns.AddNamespace('u', 'urn:schemas-microsoft-com:unattend'); $admin = $xml.SelectSingleNode('//u:LocalAccount[u:Name=''Admin'']', $ns); if ($admin) { $name = $admin.SelectSingleNode('u:Name', $ns); if ($name) { $name.InnerText = '%username%' } }; $autologon = $xml.SelectSingleNode('//u:AutoLogon/u:Username', $ns); if ($autologon) { $autologon.InnerText = '%username%' }; $xml.Save('C:\Windows\Panther\unattend.xml')"

    if errorlevel 1 (
        echo Warning: Could not customize username, using default "Admin"
    ) else (
        echo Username customized successfully!
    )
)

echo.
echo Configuration ready!
echo.
echo Username: %username%
echo Password: None (you can set one after first login)
echo.
echo The system will now reboot and:
echo 1. Skip Microsoft account requirement
echo 2. Create your local account
echo 3. Auto-login once to complete Windows setup
echo 4. Remove bloatware in the background
echo.
echo Press any key to reboot...
pause >nul

:: Reboot to apply unattend.xml
shutdown /r /t 3 /c "Rebooting to apply Windows OOBE bypass"
