@echo off
setlocal enabledelayedexpansion

echo ===============================================
echo   Windows 11 Local Account Bypass
echo   Based on Chris Titus Tech's method
echo ===============================================
echo.
echo This script will:
echo - Download Chris Titus Tech's unattend.xml
echo - Place it where Windows will find it
echo - Restart OOBE to apply the configuration
echo.
echo The unattend.xml will:
echo - Create a local "Admin" account (no password)
echo - Bypass Microsoft account requirement
echo - Remove bloatware automatically
echo.
pause

:: Get script directory
set "SCRIPT_DIR=%~dp0"

echo.
echo Step 1: Preparing unattend.xml...
echo.

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

:: Verify the file exists
if not exist "C:\Windows\Panther\unattend.xml" (
    echo.
    echo ERROR: unattend.xml was not created!
    pause
    exit /b 1
)

echo.
echo Step 2: Unattend.xml placed successfully!
echo.

echo ================================================
echo IMPORTANT - AFTER REBOOT:
echo ================================================
echo.
echo The system will reboot and Windows will:
echo 1. Apply the unattend.xml automatically
echo 2. Create account: Admin
echo 3. Password: (blank/empty)
echo 4. Auto-login once to finish setup
echo.
echo IF YOU SEE A LOGIN SCREEN:
echo - Username: Admin
echo - Password: Leave blank, just press Enter
echo.
echo ================================================
echo.
echo Press any key to restart OOBE and apply configuration...
pause >nul

:: Restart OOBE process to pick up the unattend.xml
echo.
echo Restarting OOBE...
echo.

:: Method 1: Use the OOBE BypassNRO command
cd %WINDIR%\System32\oobe
start /wait BypassNRO.cmd

:: If BypassNRO doesn't exist, just reboot
if errorlevel 1 (
    echo BypassNRO not found, rebooting normally...
    shutdown /r /t 3 /c "Restarting to apply unattend.xml"
)
