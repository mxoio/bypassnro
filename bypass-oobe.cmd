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

:: Create login info file for the desktop
echo Creating login information file...
(
echo ================================================
echo Windows 11 OOBE Bypass - Login Information
echo ================================================
echo.
echo Your local account has been created!
echo.
echo Username: %username%
echo Password: ^(blank - no password set^)
echo.
echo To set a password:
echo 1. Press Windows + I to open Settings
echo 2. Go to Accounts ^> Sign-in options
echo 3. Click Password ^> Add
echo.
echo Bloatware removal is running in the background.
echo Check these logs to see what was removed:
echo - C:\Windows\Setup\Scripts\RemovePackages.log
echo - C:\Windows\Setup\Scripts\Specialize.log
echo.
echo ================================================
) > "C:\Users\Public\Desktop\LOGIN-INFO.txt"

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
echo ================================================
echo IMPORTANT - LOGIN INFORMATION:
echo ================================================
echo Username: %username%
echo Password: (blank - just press Enter)
echo.
echo If auto-login fails and you see a login screen:
echo 1. Type username: %username%
echo 2. Leave password blank (press Enter)
echo 3. You will login and see desktop
echo ================================================
echo.
echo The system will now:
echo 1. Apply unattend.xml using Sysprep
echo 2. Reboot to complete OOBE
echo 3. Create your local account
echo 4. Auto-login once to finish setup
echo 5. Remove bloatware in the background
echo.
echo Press any key to continue...
pause >nul

:: Apply unattend.xml using Sysprep (THIS IS THE KEY!)
echo.
echo Applying configuration with Sysprep...
%WINDIR%\System32\Sysprep\Sysprep.exe /oobe /unattend:C:\Windows\Panther\unattend.xml /reboot

:: If Sysprep fails, show error
if errorlevel 1 (
    echo.
    echo ERROR: Sysprep failed to apply unattend.xml
    echo Error code: %errorlevel%
    echo.
    echo Troubleshooting:
    echo 1. Make sure you're running this during OOBE setup
    echo 2. Check if C:\Windows\Panther\unattend.xml exists
    echo 3. Try running: type C:\Windows\Panther\unattend.xml
    echo.
    pause
    exit /b 1
)
