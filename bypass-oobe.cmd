@echo off
echo ===============================================
echo   Windows 11 Local Account Bypass
echo   Using Chris Titus Tech's Method (FIXED)
echo ===============================================
echo.
echo This will:
echo - Set registry key to bypass network requirement
echo - Download and apply unattend.xml
echo - Create local "Admin" account (no password)
echo - Skip Microsoft account screen completely
echo - Remove bloatware automatically
echo.
pause

echo.
echo Step 1: Setting registry bypass...
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v BypassNRO /t REG_DWORD /d 1 /f
if errorlevel 1 (
    echo WARNING: Could not set registry key (may need admin rights)
) else (
    echo Registry bypass set successfully!
)

echo.
echo Step 2: Downloading unattend.xml...
curl -L -o C:\Windows\Panther\unattend.xml https://raw.githubusercontent.com/mxoio/bypassnro/main/unattend.xml

if errorlevel 1 (
    echo.
    echo ERROR: Failed to download unattend.xml
    echo Check your internet connection
    pause
    exit /b 1
)

echo.
echo Download successful!
echo.
echo ================================================
echo AFTER REBOOT - LOGIN INFORMATION:
echo ================================================
echo Username: Admin
echo Password: (blank - just press Enter)
echo.
echo The system will auto-login once, then require
echo the password on subsequent logins.
echo.
echo NOTE: The Microsoft account screen will be
echo       completely bypassed this time!
echo ================================================
echo.
echo Press any key to apply configuration and reboot...
pause >nul

echo.
echo Applying unattend.xml and rebooting...
%WINDIR%\System32\Sysprep\Sysprep.exe /oobe /unattend:C:\Windows\Panther\unattend.xml /reboot
