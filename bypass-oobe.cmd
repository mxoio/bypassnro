@echo off
setlocal enabledelayedexpansion

echo ===============================================
echo   Windows 11 Local Account Bypass
echo   Run this during OOBE (Windows Setup)
echo ===============================================
echo.
echo Select your profile:
echo.
echo   1. Minimal (Bypass only - keeps all Microsoft features)
echo      - Creates local account
echo      - Bypasses Microsoft account requirement
echo      - Keeps all default Windows features
echo.
echo   2. Gaming (Bypass + keep gaming features)
echo      - Removes bloatware apps
echo      - Keeps Xbox, Game Bar, Game DVR
echo      - Optimized for gaming
echo.
echo   3. Standard (Bypass + balanced debloat)
echo      - Removes common bloatware
echo      - Keeps essential functionality
echo      - Recommended for most users
echo.
echo   4. Full Debloat (Maximum bloat removal)
echo      - Removes OneDrive, Cortana, Xbox
echo      - Maximum privacy settings
echo      - For advanced users
echo.
set /p profile="Enter choice (1-4): "

if "%profile%"=="1" goto MINIMAL
if "%profile%"=="2" goto GAMING
if "%profile%"=="3" goto STANDARD
if "%profile%"=="4" goto FULL

echo Invalid choice! Defaulting to Minimal...
goto MINIMAL

:MINIMAL
set "PROFILE_NAME=Minimal"
set "REMOVE_APPS="
set "EXTRA_COMMANDS="
goto GET_USER_INFO

:GAMING
set "PROFILE_NAME=Gaming"
set "REMOVE_APPS=Microsoft.BingNews|Microsoft.BingWeather|Microsoft.GetHelp|Microsoft.Getstarted|Microsoft.Microsoft3DViewer|Microsoft.MicrosoftOfficeHub|Microsoft.MicrosoftSolitaireCollection|Microsoft.People|Microsoft.SkypeApp|Microsoft.WindowsMaps|Microsoft.YourPhone|Microsoft.ZuneMusic|Microsoft.ZuneVideo|MicrosoftTeams|Microsoft.Todos|Microsoft.PowerAutomateDesktop|SpotifyAB.SpotifyMusic|Microsoft.WindowsFeedbackHub"
set "EXTRA_COMMANDS=yes"
goto GET_USER_INFO

:STANDARD
set "PROFILE_NAME=Standard"
set "REMOVE_APPS=Microsoft.BingNews|Microsoft.BingWeather|Microsoft.GetHelp|Microsoft.Getstarted|Microsoft.Microsoft3DViewer|Microsoft.MicrosoftOfficeHub|Microsoft.MicrosoftSolitaireCollection|Microsoft.People|Microsoft.SkypeApp|Microsoft.WindowsMaps|Microsoft.YourPhone|Microsoft.ZuneMusic|Microsoft.ZuneVideo|MicrosoftTeams|Microsoft.Todos|Microsoft.PowerAutomateDesktop|SpotifyAB.SpotifyMusic|Microsoft.WindowsFeedbackHub|Microsoft.XboxApp|Microsoft.Xbox.TCUI|Microsoft.XboxGameOverlay|Microsoft.XboxGamingOverlay|Microsoft.XboxIdentityProvider|Microsoft.XboxSpeechToTextOverlay"
set "EXTRA_COMMANDS=yes"
goto GET_USER_INFO

:FULL
set "PROFILE_NAME=Full Debloat"
set "REMOVE_APPS=ALL"
set "EXTRA_COMMANDS=yes"
goto GET_USER_INFO

:GET_USER_INFO
echo.
echo Selected profile: %PROFILE_NAME%
echo.
echo Enter account details:
set /p username="Enter username (default: User): "
if "%username%"=="" set "username=User"

set /p password="Enter password (press Enter for no password): "

echo.
echo Creating configuration for user: %username%
echo.

:: Generate the unattend.xml file
call :GenerateXML

echo.
echo Configuration ready!
echo.
echo Account: %username%
if "%password%"=="" (
    echo Password: None ^(you can add one after setup^)
) else (
    echo Password: ****
)
echo.
echo System will now bypass OOBE and reboot...
echo.
timeout /t 5

:: Apply unattend and continue OOBE
OOBE\BypassNRO

:: Alternative method if BypassNRO doesn't work
if errorlevel 1 (
    echo Using alternative bypass method...
    reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE /v BypassNRO /t REG_DWORD /d 1 /f
    shutdown /r /t 5 /c "Rebooting to apply Windows setup bypass"
)
exit /b 0

:: ========================================
:: Generate XML Function
:: ========================================
:GenerateXML
echo Generating unattend.xml...

:: Escape password for XML if it contains special characters
set "ESCAPED_PASSWORD=%password%"
set "ESCAPED_PASSWORD=%ESCAPED_PASSWORD:&=&amp;%"
set "ESCAPED_PASSWORD=%ESCAPED_PASSWORD:<=&lt;%"
set "ESCAPED_PASSWORD=%ESCAPED_PASSWORD:>=&gt;%"
set "ESCAPED_PASSWORD=%ESCAPED_PASSWORD:'=&apos;%"
set "ESCAPED_PASSWORD=%ESCAPED_PASSWORD:"=&quot;%"

:: Start building XML
(
echo ^<?xml version="1.0" encoding="utf-8"?^>
echo ^<unattend xmlns="urn:schemas-microsoft-com:unattend"^>
echo     ^<settings pass="oobeSystem"^>
echo         ^<component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"^>
echo             ^<UserAccounts^>
echo                 ^<LocalAccounts^>
echo                     ^<LocalAccount wcm:action="add"^>
echo                         ^<Name^>%username%^</Name^>
echo                         ^<Group^>Administrators^</Group^>
echo                         ^<Password^>
echo                             ^<Value^>%ESCAPED_PASSWORD%^</Value^>
echo                             ^<PlainText^>true^</PlainText^>
echo                         ^</Password^>
echo                     ^</LocalAccount^>
echo                 ^</LocalAccounts^>
echo             ^</UserAccounts^>
echo             ^<OOBE^>
echo                 ^<HideEULAPage^>true^</HideEULAPage^>
echo                 ^<HideOEMRegistrationScreen^>true^</HideOEMRegistrationScreen^>
echo                 ^<HideOnlineAccountScreens^>true^</HideOnlineAccountScreens^>
echo                 ^<HideWirelessSetupInOOBE^>false^</HideWirelessSetupInOOBE^>
echo                 ^<ProtectYourPC^>3^</ProtectYourPC^>
echo                 ^<SkipUserOOBE^>true^</SkipUserOOBE^>
echo                 ^<SkipMachineOOBE^>true^</SkipMachineOOBE^>
echo             ^</OOBE^>
echo             ^<FirstLogonCommands^>
echo                 ^<SynchronousCommand wcm:action="add"^>
echo                     ^<Order^>1^</Order^>
echo                     ^<CommandLine^>cmd /c reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v PrivacyConsentStatus /t REG_DWORD /d 0 /f^</CommandLine^>
echo                 ^</SynchronousCommand^>
echo                 ^<SynchronousCommand wcm:action="add"^>
echo                     ^<Order^>2^</Order^>
echo                     ^<CommandLine^>cmd /c reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OOBE" /v DisablePrivacyExperience /t REG_DWORD /d 1 /f^</CommandLine^>
echo                 ^</SynchronousCommand^>
) > C:\Windows\Panther\unattend.xml

if "%REMOVE_APPS%" NEQ "" call :AddAppRemoval
if "%EXTRA_COMMANDS%"=="yes" call :AddExtraCommands

:: Close XML tags
(
echo             ^</FirstLogonCommands^>
echo         ^</component^>
echo         ^<component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"^>
echo             ^<InputLocale^>en-US^</InputLocale^>
echo             ^<SystemLocale^>en-US^</SystemLocale^>
echo             ^<UILanguage^>en-US^</UILanguage^>
echo             ^<UserLocale^>en-US^</UserLocale^>
echo         ^</component^>
echo     ^</settings^>
echo     ^<settings pass="specialize"^>
echo         ^<component name="Microsoft-Windows-Deployment" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS"^>
echo             ^<RunSynchronous^>
echo                 ^<RunSynchronousCommand wcm:action="add"^>
echo                     ^<Order^>1^</Order^>
echo                     ^<Path^>reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v BypassNRO /t REG_DWORD /d 1 /f^</Path^>
echo                 ^</RunSynchronousCommand^>
echo             ^</RunSynchronous^>
echo         ^</component^>
echo     ^</settings^>
echo ^</unattend^>
) >> C:\Windows\Panther\unattend.xml

echo XML generation complete.
exit /b 0

:AddAppRemoval
if "%REMOVE_APPS%"=="ALL" (
    echo                 ^<SynchronousCommand wcm:action="add"^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<Order^>3^</Order^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<CommandLine^>powershell -NoProfile -Command "Get-AppxPackage -AllUsers | Where-Object {$_.Name -notmatch 'Microsoft.WindowsStore^|Microsoft.WindowsCalculator^|Microsoft.Windows.Photos^|Microsoft.ScreenSketch^|Microsoft.Paint^|Microsoft.WindowsNotepad^|Microsoft.WindowsTerminal^|Microsoft.DesktopAppInstaller'} | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"^</CommandLine^> >> C:\Windows\Panther\unattend.xml
    echo                 ^</SynchronousCommand^> >> C:\Windows\Panther\unattend.xml
) else (
    echo                 ^<SynchronousCommand wcm:action="add"^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<Order^>3^</Order^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<CommandLine^>powershell -NoProfile -Command "Get-AppxPackage -AllUsers | Where-Object {$_.Name -match '%REMOVE_APPS%'} | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"^</CommandLine^> >> C:\Windows\Panther\unattend.xml
    echo                 ^</SynchronousCommand^> >> C:\Windows\Panther\unattend.xml
)
exit /b 0

:AddExtraCommands
set ORDER=4

if "%PROFILE_NAME%"=="Full Debloat" (
    echo                 ^<SynchronousCommand wcm:action="add"^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<Order^>%ORDER%^</Order^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<CommandLine^>cmd /c reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f^</CommandLine^> >> C:\Windows\Panther\unattend.xml
    echo                 ^</SynchronousCommand^> >> C:\Windows\Panther\unattend.xml
    set /a ORDER+=1
)

echo                 ^<SynchronousCommand wcm:action="add"^> >> C:\Windows\Panther\unattend.xml
echo                     ^<Order^>%ORDER%^</Order^> >> C:\Windows\Panther\unattend.xml
echo                     ^<CommandLine^>cmd /c reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f^</CommandLine^> >> C:\Windows\Panther\unattend.xml
echo                 ^</SynchronousCommand^> >> C:\Windows\Panther\unattend.xml
set /a ORDER+=1

echo                 ^<SynchronousCommand wcm:action="add"^> >> C:\Windows\Panther\unattend.xml
echo                     ^<Order^>%ORDER%^</Order^> >> C:\Windows\Panther\unattend.xml
echo                     ^<CommandLine^>cmd /c reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f^</CommandLine^> >> C:\Windows\Panther\unattend.xml
echo                 ^</SynchronousCommand^> >> C:\Windows\Panther\unattend.xml
set /a ORDER+=1

echo                 ^<SynchronousCommand wcm:action="add"^> >> C:\Windows\Panther\unattend.xml
echo                     ^<Order^>%ORDER%^</Order^> >> C:\Windows\Panther\unattend.xml
echo                     ^<CommandLine^>cmd /c reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f^</CommandLine^> >> C:\Windows\Panther\unattend.xml
echo                 ^</SynchronousCommand^> >> C:\Windows\Panther\unattend.xml
set /a ORDER+=1

echo                 ^<SynchronousCommand wcm:action="add"^> >> C:\Windows\Panther\unattend.xml
echo                     ^<Order^>%ORDER%^</Order^> >> C:\Windows\Panther\unattend.xml
echo                     ^<CommandLine^>cmd /c reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t REG_DWORD /d 1 /f^</CommandLine^> >> C:\Windows\Panther\unattend.xml
echo                 ^</SynchronousCommand^> >> C:\Windows\Panther\unattend.xml
set /a ORDER+=1

if "%PROFILE_NAME%"=="Standard" (
    echo                 ^<SynchronousCommand wcm:action="add"^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<Order^>%ORDER%^</Order^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<CommandLine^>cmd /c reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f^</CommandLine^> >> C:\Windows\Panther\unattend.xml
    echo                 ^</SynchronousCommand^> >> C:\Windows\Panther\unattend.xml
    set /a ORDER+=1

    echo                 ^<SynchronousCommand wcm:action="add"^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<Order^>%ORDER%^</Order^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<CommandLine^>cmd /c reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f^</CommandLine^> >> C:\Windows\Panther\unattend.xml
    echo                 ^</SynchronousCommand^> >> C:\Windows\Panther\unattend.xml
    set /a ORDER+=1
)

if "%PROFILE_NAME%"=="Full Debloat" (
    echo                 ^<SynchronousCommand wcm:action="add"^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<Order^>%ORDER%^</Order^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<CommandLine^>cmd /c reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f^</CommandLine^> >> C:\Windows\Panther\unattend.xml
    echo                 ^</SynchronousCommand^> >> C:\Windows\Panther\unattend.xml
    set /a ORDER+=1

    echo                 ^<SynchronousCommand wcm:action="add"^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<Order^>%ORDER%^</Order^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<CommandLine^>cmd /c reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f^</CommandLine^> >> C:\Windows\Panther\unattend.xml
    echo                 ^</SynchronousCommand^> >> C:\Windows\Panther\unattend.xml
    set /a ORDER+=1

    echo                 ^<SynchronousCommand wcm:action="add"^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<Order^>%ORDER%^</Order^> >> C:\Windows\Panther\unattend.xml
    echo                     ^<CommandLine^>cmd /c reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f^</CommandLine^> >> C:\Windows\Panther\unattend.xml
    echo                 ^</SynchronousCommand^> >> C:\Windows\Panther\unattend.xml
)

exit /b 0
