Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create log directory
$logPath = "C:\Windows\Setup\Scripts\BloatwareRemoval.log"
New-Item -Path "C:\Windows\Setup\Scripts" -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null

# Log function
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
    "[$timestamp] $Message" | Out-File -Append -FilePath $logPath
    Write-Host $Message
}

Write-Log "=== Windows 11 Bloatware Removal GUI Started ==="

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Windows 11 Bloatware Removal'
$form.Size = New-Object System.Drawing.Size(650,550)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::White

# Title label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Location = New-Object System.Drawing.Point(20,15)
$titleLabel.Size = New-Object System.Drawing.Size(600,35)
$titleLabel.Text = 'Welcome! Select Bloatware Removal Level'
$titleLabel.Font = New-Object System.Drawing.Font('Segoe UI',16,[System.Drawing.FontStyle]::Bold)
$form.Controls.Add($titleLabel)

# Description label
$descLabel = New-Object System.Windows.Forms.Label
$descLabel.Location = New-Object System.Drawing.Point(20,55)
$descLabel.Size = New-Object System.Drawing.Size(600,25)
$descLabel.Text = 'Choose what to remove from your Windows installation:'
$descLabel.Font = New-Object System.Drawing.Font('Segoe UI',10)
$form.Controls.Add($descLabel)

# Radio buttons group
$yPos = 90
$radioGroup = @()

# Minimal
$radioMinimal = New-Object System.Windows.Forms.RadioButton
$radioMinimal.Location = New-Object System.Drawing.Point(30,$yPos)
$radioMinimal.Size = New-Object System.Drawing.Size(580,25)
$radioMinimal.Text = 'Minimal - Bypass Only (Keep Everything)'
$radioMinimal.Font = New-Object System.Drawing.Font('Segoe UI',11,[System.Drawing.FontStyle]::Bold)
$form.Controls.Add($radioMinimal)
$radioGroup += $radioMinimal

$labelMinimal = New-Object System.Windows.Forms.Label
$labelMinimal.Location = New-Object System.Drawing.Point(50,($yPos+28))
$labelMinimal.Size = New-Object System.Drawing.Size(560,30)
$labelMinimal.Text = 'No bloatware removal. Keeps all Windows apps and features intact.'
$labelMinimal.Font = New-Object System.Drawing.Font('Segoe UI',9)
$labelMinimal.ForeColor = [System.Drawing.Color]::DarkGray
$form.Controls.Add($labelMinimal)

# Gaming
$yPos += 70
$radioGaming = New-Object System.Windows.Forms.RadioButton
$radioGaming.Location = New-Object System.Drawing.Point(30,$yPos)
$radioGaming.Size = New-Object System.Drawing.Size(580,25)
$radioGaming.Text = 'Gaming - Remove Bloat, KEEP Xbox/Game Bar'
$radioGaming.Font = New-Object System.Drawing.Font('Segoe UI',11,[System.Drawing.FontStyle]::Bold)
$radioGaming.Checked = $true
$form.Controls.Add($radioGaming)
$radioGroup += $radioGaming

$labelGaming = New-Object System.Windows.Forms.Label
$labelGaming.Location = New-Object System.Drawing.Point(50,($yPos+28))
$labelGaming.Size = New-Object System.Drawing.Size(560,40)
$labelGaming.Text = "Removes: OneDrive, Teams, Office Hub, Bing apps, Cortana.`nKEEPS: Xbox, Game Bar, all gaming features. Recommended for gamers."
$labelGaming.Font = New-Object System.Drawing.Font('Segoe UI',9)
$labelGaming.ForeColor = [System.Drawing.Color]::DarkGray
$form.Controls.Add($labelGaming)

# Standard
$yPos += 80
$radioStandard = New-Object System.Windows.Forms.RadioButton
$radioStandard.Location = New-Object System.Drawing.Point(30,$yPos)
$radioStandard.Size = New-Object System.Drawing.Size(580,25)
$radioStandard.Text = 'Standard - Balanced Removal (Recommended)'
$radioStandard.Font = New-Object System.Drawing.Font('Segoe UI',11,[System.Drawing.FontStyle]::Bold)
$form.Controls.Add($radioStandard)
$radioGroup += $radioStandard

$labelStandard = New-Object System.Windows.Forms.Label
$labelStandard.Location = New-Object System.Drawing.Point(50,($yPos+28))
$labelStandard.Size = New-Object System.Drawing.Size(560,40)
$labelStandard.Text = "Removes: Everything from Gaming profile PLUS Xbox apps.`nGood balance of performance and features. Recommended for most users."
$labelStandard.Font = New-Object System.Drawing.Font('Segoe UI',9)
$labelStandard.ForeColor = [System.Drawing.Color]::DarkGray
$form.Controls.Add($labelStandard)

# Full
$yPos += 80
$radioFull = New-Object System.Windows.Forms.RadioButton
$radioFull.Location = New-Object System.Drawing.Point(30,$yPos)
$radioFull.Size = New-Object System.Drawing.Size(580,25)
$radioFull.Text = 'Full - Maximum Removal + Privacy Tweaks'
$radioFull.Font = New-Object System.Drawing.Font('Segoe UI',11,[System.Drawing.FontStyle]::Bold)
$form.Controls.Add($radioFull)
$radioGroup += $radioFull

$labelFull = New-Object System.Windows.Forms.Label
$labelFull.Location = New-Object System.Drawing.Point(50,($yPos+28))
$labelFull.Size = New-Object System.Drawing.Size(560,50)
$labelFull.Text = "Maximum debloat. Removes all optional apps, disables telemetry,`napplies privacy tweaks. For advanced users who want minimal Windows."
$labelFull.Font = New-Object System.Drawing.Font('Segoe UI',9)
$labelFull.ForeColor = [System.Drawing.Color]::DarkGray
$form.Controls.Add($labelFull)

# Progress label
$progressLabel = New-Object System.Windows.Forms.Label
$progressLabel.Location = New-Object System.Drawing.Point(20,450)
$progressLabel.Size = New-Object System.Drawing.Size(480,30)
$progressLabel.Text = ''
$progressLabel.Font = New-Object System.Drawing.Font('Segoe UI',9,[System.Drawing.FontStyle]::Italic)
$progressLabel.Visible = $false
$form.Controls.Add($progressLabel)

# Apply button
$buttonApply = New-Object System.Windows.Forms.Button
$buttonApply.Location = New-Object System.Drawing.Point(480,460)
$buttonApply.Size = New-Object System.Drawing.Size(130,35)
$buttonApply.Text = 'Apply'
$buttonApply.Font = New-Object System.Drawing.Font('Segoe UI',11,[System.Drawing.FontStyle]::Bold)
$buttonApply.BackColor = [System.Drawing.Color]::FromArgb(0,120,212)
$buttonApply.ForeColor = [System.Drawing.Color]::White
$buttonApply.FlatStyle = 'Flat'
$buttonApply.Add_Click({
    $selectedProfile = 'minimal'
    if ($radioGaming.Checked) { $selectedProfile = 'gaming' }
    if ($radioStandard.Checked) { $selectedProfile = 'standard' }
    if ($radioFull.Checked) { $selectedProfile = 'full' }

    Write-Log "User selected profile: $selectedProfile"

    $buttonApply.Enabled = $false
    $progressLabel.Visible = $true
    $progressLabel.Text = "Applying $selectedProfile profile..."
    $form.Refresh()

    # Disable all radio buttons
    foreach ($radio in $radioGroup) { $radio.Enabled = $false }

    # Minimal - do nothing
    if ($selectedProfile -eq 'minimal') {
        Write-Log 'Minimal profile - no bloatware removal'
        $progressLabel.Text = 'Complete! No changes made.'
        Start-Sleep -Seconds 2
        $form.Close()
        return
    }

    # Define apps to remove per profile
    $appsToRemove = @(
        'Microsoft.OneDrive',
        'Microsoft.Teams',
        'Microsoft.Office.OneNote',
        'Microsoft.SkypeApp',
        'Microsoft.BingNews',
        'Microsoft.BingWeather',
        'Microsoft.BingFinance',
        'Microsoft.BingSports',
        'Microsoft.ZuneMusic',
        'Microsoft.ZuneVideo',
        'Microsoft.MicrosoftOfficeHub',
        'Microsoft.Getstarted',
        'Microsoft.WindowsFeedbackHub',
        'Microsoft.GetHelp',
        'Microsoft.People',
        'Microsoft.YourPhone',
        'MicrosoftTeams',
        'Microsoft.Todos',
        'Microsoft.PowerAutomateDesktop',
        'Clipchamp.Clipchamp',
        'Microsoft.549981C3F5F10'  # Cortana
    )

    # Standard and Full - add Xbox removal
    if ($selectedProfile -eq 'standard' -or $selectedProfile -eq 'full') {
        $appsToRemove += @(
            'Microsoft.XboxApp',
            'Microsoft.XboxGamingOverlay',
            'Microsoft.XboxGameOverlay',
            'Microsoft.XboxSpeechToTextOverlay',
            'Microsoft.Xbox.TCUI',
            'Microsoft.XboxIdentityProvider',
            'Microsoft.GamingApp'
        )
    }

    # Full - add even more apps
    if ($selectedProfile -eq 'full') {
        $appsToRemove += @(
            'Microsoft.WindowsMaps',
            'Microsoft.WindowsSoundRecorder',
            'Microsoft.MixedReality.Portal',
            'Microsoft.Paint',
            'Microsoft.MSPaint',
            'Microsoft.WindowsAlarms',
            'Microsoft.WindowsCamera',
            'Microsoft.ScreenSketch',
            'Microsoft.Print3D',
            'Microsoft.3DBuilder'
        )
    }

    Write-Log "Removing $($appsToRemove.Count) app packages..."
    $progressLabel.Text = "Removing bloatware... (this may take a few minutes)"
    $form.Refresh()

    $removed = 0
    $failed = 0
    foreach ($app in $appsToRemove) {
        try {
            $found = $false

            # Remove for current user
            $package = Get-AppxPackage -Name $app -ErrorAction SilentlyContinue
            if ($package) {
                $package | Remove-AppxPackage -ErrorAction Stop
                $found = $true
            }

            # Remove for all users
            $allUsersPackage = Get-AppxPackage -Name $app -AllUsers -ErrorAction SilentlyContinue
            if ($allUsersPackage) {
                $allUsersPackage | Remove-AppxPackage -AllUsers -ErrorAction Stop
                $found = $true
            }

            # Remove provisioned package
            $provisionedPackage = Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Where-Object DisplayName -like $app
            if ($provisionedPackage) {
                $provisionedPackage | Remove-AppxProvisionedPackage -Online -ErrorAction Stop
                $found = $true
            }

            if ($found) {
                Write-Log "Removed: $app"
                $removed++
            } else {
                Write-Log "Not found: $app"
            }
        } catch {
            Write-Log "Failed to remove: $app - $($_.Exception.Message)"
            $failed++
        }
    }

    Write-Log "Removed $removed apps, $failed failed"

    # Full profile - additional tweaks
    if ($selectedProfile -eq 'full') {
        Write-Log 'Applying privacy tweaks...'
        $progressLabel.Text = 'Applying privacy settings...'
        $form.Refresh()

        try {
            # Disable telemetry
            if (-not (Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection')) {
                New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Force | Out-Null
            }
            Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection' -Name 'AllowTelemetry' -Value 0 -Force
            Write-Log 'Disabled telemetry'

            # Disable activity history
            if (-not (Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System')) {
                New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Force | Out-Null
            }
            Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System' -Name 'EnableActivityFeed' -Value 0 -Force
            Write-Log 'Disabled activity history'

            # Disable advertising ID
            if (-not (Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo')) {
                New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo' -Force | Out-Null
            }
            Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo' -Name 'DisabledByGroupPolicy' -Value 1 -Force
            Write-Log 'Disabled advertising ID'

            Write-Log 'Privacy tweaks applied'
        } catch {
            Write-Log "Privacy tweaks error: $($_.Exception.Message)"
        }
    }

    Write-Log '=== Bloatware removal complete! ==='
    $progressLabel.Text = "Complete! Removed $removed apps. Log: $logPath"

    Start-Sleep -Seconds 4
    $form.Close()
})
$form.Controls.Add($buttonApply)

# Show form
Write-Log 'Showing bloatware selection GUI...'
[void]$form.ShowDialog()

Write-Log 'GUI closed. Script finished.'
