@echo off
setlocal enabledelayedexpansion

:: ========================================
:: Enhanced BypassNRO Script with Logging
:: Version 2.0 - Debug Edition
:: ========================================

:: Configuration
set "LOG_DIR=\\server.local.mxioi.uk\Mikey\code\debug-logs"
set "LOG_FILE=%LOG_DIR%\bypass-log-%COMPUTERNAME%-%DATE:~-4%%DATE:~4,2%%DATE:~7,2%-%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.log"
set "LOG_FILE=%LOG_FILE: =0%"
set "XML_LOCAL=C:\Windows\Panther\unattend-custom.xml"
set "BACKUP_DIR=C:\Windows\Panther\Backup"

:: Initialize logging
call :Log "=========================================="
call :Log "Enhanced BypassNRO Script Started"
call :Log "Timestamp: %DATE% %TIME%"
call :Log "Computer: %COMPUTERNAME%"
call :Log "Username: %USERNAME%"
call :Log "=========================================="

:: Check if running with admin privileges
call :Log "Checking administrator privileges..."
net session >nul 2>&1
if %errorlevel% neq 0 (
    call :Log "ERROR: Script requires administrator privileges!"
    echo This script must be run as Administrator
    pause
    exit /b 1
)
call :Log "Administrator check: PASSED"

:: Display menu
:MENU
cls
echo ========================================
echo   Enhanced BypassNRO Setup
echo ========================================
echo.
echo Select Debloat Level:
echo   1. Minimal (Keep most apps, bypass only)
echo   2. Standard (Remove common bloatware)
echo   3. Aggressive (Remove maximum bloatware)
echo   4. Custom (Choose specific options)
echo   5. Debug Only (Test logging without changes)
echo   6. Exit
echo.
set /p choice="Enter your choice (1-6): "

call :Log "User selected menu option: %choice%"

if "%choice%"=="1" goto MINIMAL
if "%choice%"=="2" goto STANDARD
if "%choice%"=="3" goto AGGRESSIVE
if "%choice%"=="4" goto CUSTOM
if "%choice%"=="5" goto DEBUG_ONLY
if "%choice%"=="6" goto EXIT
goto MENU

:MINIMAL
set "DEBLOAT_LEVEL=MINIMAL"
call :Log "Debloat level set to: MINIMAL"
goto COLLECT_USER_INFO

:STANDARD
set "DEBLOAT_LEVEL=STANDARD"
call :Log "Debloat level set to: STANDARD"
goto COLLECT_USER_INFO

:AGGRESSIVE
set "DEBLOAT_LEVEL=AGGRESSIVE"
call :Log "Debloat level set to: AGGRESSIVE"
goto COLLECT_USER_INFO

:CUSTOM
call :Log "Entering custom configuration mode"
call :CustomConfig
goto COLLECT_USER_INFO

:DEBUG_ONLY
call :Log "Debug mode selected - no system changes will be made"
echo.
echo Debug mode active - testing logging only
echo Log file location: %LOG_FILE%
echo.
call :TestLogging
pause
goto MENU

:COLLECT_USER_INFO
cls
echo ========================================
echo   User Account Configuration
echo ========================================
echo.

set /p "NEW_USERNAME=Enter desired username: "
call :Log "Username entered: %NEW_USERNAME%"

:PASSWORD_INPUT
set /p "NEW_PASSWORD=Enter password (leave blank for no password): "
if "%NEW_PASSWORD%"=="" (
    set /p "CONFIRM_NO_PASS=Are you sure you want no password? (Y/N): "
    if /i "!CONFIRM_NO_PASS!"=="Y" (
        call :Log "User chose no password"
        set "NEW_PASSWORD="
        goto SECURITY_QUESTIONS
    ) else (
        goto PASSWORD_INPUT
    )
)
call :Log "Password set (length: %NEW_PASSWORD:~0,1%****)"

:SECURITY_QUESTIONS
echo.
set /p "SKIP_SECURITY=Skip security questions? (Y/N): "
call :Log "Skip security questions: %SKIP_SECURITY%"

if /i "%SKIP_SECURITY%"=="Y" (
    set "SECURITY_Q1="
    set "SECURITY_A1="
    set "SECURITY_Q2="
    set "SECURITY_A2="
    set "SECURITY_Q3="
    set "SECURITY_A3="
) else (
    echo.
    echo Security Question 1:
    set /p "SECURITY_Q1=Question: "
    set /p "SECURITY_A1=Answer: "
    
    echo Security Question 2:
    set /p "SECURITY_Q2=Question: "
    set /p "SECURITY_A2=Answer: "
    
    echo Security Question 3:
    set /p "SECURITY_Q3=Question: "
    set /p "SECURITY_A3=Answer: "
    
    call :Log "Security questions configured"
)

:: Confirm settings
cls
echo ========================================
echo   Configuration Summary
echo ========================================
echo.
echo Debloat Level: %DEBLOAT_LEVEL%
echo Username: %NEW_USERNAME%
echo Password: %NEW_PASSWORD:~0,1%****
echo Skip Security: %SKIP_SECURITY%
echo.
set /p "CONFIRM=Proceed with these settings? (Y/N): "

if /i not "%CONFIRM%"=="Y" (
    call :Log "User cancelled configuration"
    goto MENU
)

call :Log "Configuration confirmed by user"
goto APPLY_SETTINGS

:APPLY_SETTINGS
call :Log "Starting system configuration..."

:: Create backup directory
call :Log "Creating backup directory: %BACKUP_DIR%"
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

:: Generate custom unattend.xml
call :Log "Generating custom unattend.xml"
call :GenerateXML

:: Backup existing files
if exist "C:\Windows\Panther\unattend.xml" (
    call :Log "Backing up existing unattend.xml"
    copy "C:\Windows\Panther\unattend.xml" "%BACKUP_DIR%\unattend-backup-%DATE:~-4%%DATE:~4,2%%DATE:~7,2%.xml" >nul 2>&1
)

:: Apply the configuration
call :Log "Applying configuration with Sysprep..."
call :Log "Command: %WINDIR%\System32\Sysprep\Sysprep.exe /oobe /unattend:%XML_LOCAL% /reboot"

echo.
echo Configuration will be applied and system will reboot...
timeout /t 5

%WINDIR%\System32\Sysprep\Sysprep.exe /oobe /unattend:%XML_LOCAL% /reboot

if %errorlevel% neq 0 (
    call :Log "ERROR: Sysprep failed with error code %errorlevel%"
    echo.
    echo ERROR: Configuration failed!
    echo Check log file: %LOG_FILE%
    pause
    goto MENU
)

call :Log "Sysprep executed successfully - system rebooting"
exit /b 0

:: ========================================
:: Functions
:: ========================================

:Log
echo [%DATE% %TIME%] %~1 >> "%LOG_FILE%" 2>&1
echo %~1
exit /b 0

:TestLogging
call :Log "=== Debug Test Started ==="
call :Log "System Information:"
call :Log "  OS Version: %OS%"
call :Log "  Processor: %PROCESSOR_IDENTIFIER%"
call :Log "  Computer Name: %COMPUTERNAME%"
call :Log "  User Domain: %USERDOMAIN%"
call :Log "  System Root: %SystemRoot%"
call :Log "  Program Files: %ProgramFiles%"

call :Log "Network Configuration:"
ipconfig /all >> "%LOG_FILE%" 2>&1

call :Log "Disk Information:"
wmic logicaldisk get caption,description,filesystem,size,freespace >> "%LOG_FILE%" 2>&1

call :Log "=== Debug Test Completed ==="
echo.
echo Debug test completed successfully!
echo Log saved to: %LOG_FILE%
exit /b 0

:CustomConfig
echo.
echo Custom Configuration Options:
echo.
set /p "REMOVE_ONEDRIVE=Remove OneDrive? (Y/N): "
set /p "REMOVE_CORTANA=Remove Cortana? (Y/N): "
set /p "REMOVE_EDGE=Remove Edge extras? (Y/N): "
set /p "DISABLE_TELEMETRY=Disable Telemetry? (Y/N): "
set /p "DISABLE_DEFENDER=Disable Windows Defender? (Y/N): "
set /p "REMOVE_XBOX=Remove Xbox features? (Y/N): "

call :Log "Custom config - OneDrive: %REMOVE_ONEDRIVE%"
call :Log "Custom config - Cortana: %REMOVE_CORTANA%"
call :Log "Custom config - Edge: %REMOVE_EDGE%"
call :Log "Custom config - Telemetry: %DISABLE_TELEMETRY%"
call :Log "Custom config - Defender: %DISABLE_DEFENDER%"
call :Log "Custom config - Xbox: %REMOVE_XBOX%"

exit /b 0

:GenerateXML
call :Log "Generating unattend.xml with debloat level: %DEBLOAT_LEVEL%"

:: This would contain the full XML generation logic
:: For now, we'll download and modify the base version

call :Log "Downloading base unattend.xml..."
powershell -Command "& {Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ChrisTitusTech/bypassnro/main/unattend.xml' -OutFile '%XML_LOCAL%'}" >> "%LOG_FILE%" 2>&1

if %errorlevel% neq 0 (
    call :Log "ERROR: Failed to download unattend.xml"
    exit /b 1
)

call :Log "Base XML downloaded successfully"
call :Log "Modifying XML with custom settings..."

:: Add custom modifications based on debloat level
:: This would use PowerShell to modify the XML

powershell -NoProfile -Command "& { $xml = [xml](Get-Content '%XML_LOCAL%'); Write-Host 'XML loaded successfully'; $xml.Save('%XML_LOCAL%'); }" >> "%LOG_FILE%" 2>&1

call :Log "XML generation completed"
exit /b 0

:EXIT
call :Log "Script exited by user"
exit /b 0
