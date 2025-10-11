@echo off
setlocal enabledelayedexpansion
color 0A
cls

echo ===============================================
echo   Windows 11 Local Account Setup
echo   Bypass Microsoft Account Requirement
echo ===============================================
echo.

REM Get username
:get_username
set "USERNAME_INPUT="
set /p USERNAME_INPUT="Enter desired username: "
if "!USERNAME_INPUT!"=="" (
    echo Username cannot be empty!
    goto get_username
)

REM Get password
:get_password
set "PASSWORD_INPUT="
set /p PASSWORD_INPUT="Enter password (leave empty for no password): "

REM Get display name
set "DISPLAYNAME_INPUT="
set /p DISPLAYNAME_INPUT="Enter display name (leave empty to use username): "
if "!DISPLAYNAME_INPUT!"=="" set "DISPLAYNAME_INPUT=!USERNAME_INPUT!"

echo.
echo ===============================================
echo   Select Installation Profile
echo ===============================================
echo   1. Minimal    - Keep most features, remove only essential bloat
echo   2. Standard   - Balanced removal of bloatware
echo   3. Gaming     - Keep gaming features, remove productivity apps
echo   4. Full       - Maximum debloat, remove everything possible
echo ===============================================
echo.

:get_profile
set "PROFILE="
set /p PROFILE="Select profile (1-4): "

if "!PROFILE!"=="1" set "PROFILE_NAME=minimal"
if "!PROFILE!"=="2" set "PROFILE_NAME=standard"
if "!PROFILE!"=="3" set "PROFILE_NAME=gaming"
if "!PROFILE!"=="4" set "PROFILE_NAME=full"

if "!PROFILE_NAME!"=="" (
    echo Invalid selection!
    goto get_profile
)

echo.
echo ===============================================
echo   Configuration Summary
echo ===============================================
echo   Username:     !USERNAME_INPUT!
echo   Display Name: !DISPLAYNAME_INPUT!
echo   Password:     !PASSWORD_INPUT!
echo   Profile:      !PROFILE_NAME!
echo ===============================================
echo.
set /p CONFIRM="Continue? (Y/N): "
if /i not "!CONFIRM!"=="Y" goto get_username

echo.
echo Downloading configuration file...

REM Download the selected unattend.xml template
curl -L -o C:\Windows\Panther\unattend.xml https://bypassnro.mxioi.uk/unattend-!PROFILE_NAME!.xml

if errorlevel 1 (
    echo Failed to download configuration file!
    echo Please check your internet connection.
    pause
    exit /b 1
)

echo Creating custom configuration...

REM Create a PowerShell script to modify the unattend.xml with user input
echo $xml = [xml](Get-Content "C:\Windows\Panther\unattend.xml") > C:\Windows\Panther\customize.ps1
echo $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable) >> C:\Windows\Panther\customize.ps1
echo $ns.AddNamespace("u", "urn:schemas-microsoft-com:unattend") >> C:\Windows\Panther\customize.ps1
echo $ns.AddNamespace("wcm", "http://schemas.microsoft.com/WMIConfig/2002/State") >> C:\Windows\Panther\customize.ps1
echo $accounts = $xml.SelectNodes("//u:LocalAccount", $ns) >> C:\Windows\Panther\customize.ps1
echo foreach($account in $accounts) { >> C:\Windows\Panther\customize.ps1
echo     if($account.Name -eq "Admin" -or $account.Name -eq "PLACEHOLDER_USERNAME") { >> C:\Windows\Panther\customize.ps1
echo         $account.Name = "!USERNAME_INPUT!" >> C:\Windows\Panther\customize.ps1
echo         $account.DisplayName = "!DISPLAYNAME_INPUT!" >> C:\Windows\Panther\customize.ps1
echo         $account.Password.Value = "!PASSWORD_INPUT!" >> C:\Windows\Panther\customize.ps1
echo     } >> C:\Windows\Panther\customize.ps1
echo } >> C:\Windows\Panther\customize.ps1
echo $autologon = $xml.SelectSingleNode("//u:AutoLogon", $ns) >> C:\Windows\Panther\customize.ps1
echo if($autologon) { >> C:\Windows\Panther\customize.ps1
echo     $autologon.Username = "!USERNAME_INPUT!" >> C:\Windows\Panther\customize.ps1
echo     $autologon.Password.Value = "!PASSWORD_INPUT!" >> C:\Windows\Panther\customize.ps1
echo } >> C:\Windows\Panther\customize.ps1
echo $xml.Save("C:\Windows\Panther\unattend.xml") >> C:\Windows\Panther\customize.ps1

REM Run the customization script
powershell.exe -ExecutionPolicy Bypass -File C:\Windows\Panther\customize.ps1

if errorlevel 1 (
    echo Failed to customize configuration!
    pause
    exit /b 1
)

REM Clean up
del C:\Windows\Panther\customize.ps1

echo.
echo Configuration complete!
echo System will now reboot and continue setup...
echo.
timeout /t 3

REM Run sysprep with the customized unattend.xml
%WINDIR%\System32\Sysprep\Sysprep.exe /oobe /unattend:C:\Windows\Panther\unattend.xml /reboot
