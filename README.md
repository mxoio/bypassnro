# Windows 11 OOBE Bypass with Custom Setup

Bypass Microsoft account requirement during Windows 11 installation with **custom username/password** and **interactive bloatware removal**.

## Features

- ✅ **Custom Username & Password** - Choose your own credentials during OOBE
- ✅ **Interactive Bloatware Selection** - GUI automatically appears on first login
- ✅ **4 Removal Profiles** - Minimal, Gaming, Standard, Full
- ✅ **Auto-Login Once** - Completes Windows setup automatically
- ✅ **Privacy Tweaks** - Disable telemetry and tracking (Full profile)
- ✅ **Detailed Logging** - Track what was removed

## Quick Start

During Windows 11 installation (OOBE screen):

1. Press `Shift + F10` to open Command Prompt
2. Run:
   ```batch
   curl -L -o bypass.cmd https://raw.githubusercontent.com/mxoio/bypassnro/main/bypass-oobe.cmd
   bypass.cmd
   ```
3. Enter your desired username and password (or press Enter for defaults)
4. System reboots and completes Windows setup
5. **Bloatware selection GUI appears automatically** on first login
6. Choose your profile and click Apply

## Bloatware Profiles

### 1. Minimal - Bypass Only
- **Removes:** Nothing
- **Keeps:** Everything intact
- **Best for:** Users who want only the Microsoft account bypass

### 2. Gaming - Remove Bloat, KEEP Xbox
- **Removes:** OneDrive, Teams, Office Hub, Bing apps, Cortana, unnecessary apps
- **Keeps:** Xbox, Game Bar, all gaming features
- **Best for:** Gamers who need Xbox functionality

### 3. Standard - Balanced (Recommended)
- **Removes:** Everything from Gaming profile PLUS Xbox apps
- **Keeps:** Essential Windows features
- **Best for:** Most users who don't need Xbox

### 4. Full - Maximum Removal + Privacy
- **Removes:** All optional apps, mixed reality, legacy apps
- **Privacy Tweaks:** Disables telemetry, activity history, advertising ID
- **Best for:** Advanced users who want minimal Windows

## What Each Profile Removes

### Gaming Profile
- OneDrive
- Microsoft Teams
- Office Hub, OneNote
- Skype
- Bing News, Weather, Finance, Sports
- Zune Music & Video
- Cortana
- Feedback Hub, Get Help
- Your Phone, People
- Power Automate, Clipchamp
- And more...

### Standard Profile
Gaming profile apps PLUS:
- Xbox App
- Xbox Gaming Overlay
- Xbox Game Bar
- All Xbox services

### Full Profile
Standard profile apps PLUS:
- Windows Maps
- Sound Recorder
- Mixed Reality Portal
- Paint, Paint 3D
- 3D Builder
- Windows Alarms, Camera
- Screen Sketch

**Privacy Tweaks:**
- Telemetry disabled
- Activity history disabled
- Advertising ID disabled

## What Always Stays

These essential apps are never removed:
- Microsoft Store
- Windows Terminal
- Settings
- Calculator
- Notepad
- File Explorer
- Edge (can be removed manually later if desired)

## How It Works

1. **During OOBE:**
   - You run `bypass-oobe.cmd`
   - Enter username/password
   - Script sets registry bypass key
   - Downloads bloatware GUI script
   - Generates custom unattend.xml with your credentials
   - Applies configuration and reboots

2. **First Login:**
   - Windows auto-logs in with your account
   - Bloatware selection GUI appears automatically
   - You select your desired profile
   - Bloatware is removed based on selection
   - Log file is created at `C:\Windows\Setup\Scripts\BloatwareRemoval.log`

3. **Done!**
   - Your custom account is ready
   - Bloatware is removed
   - Windows is ready to use

## Files

- **bypass-oobe.cmd** - Main script to run during OOBE
- **unattend_template.xml** - XML template with placeholders for username/password
- **BloatwareGUI.ps1** - PowerShell GUI for bloatware selection (auto-runs on first login)

## Advanced Usage

### Offline Installation (USB Drive)

1. Download all 3 files to a USB drive:
   - bypass-oobe.cmd
   - unattend_template.xml
   - BloatwareGUI.ps1

2. During Windows setup, press `Shift + F10`

3. Navigate to USB drive:
   ```batch
   D:
   cd \
   ```

4. Copy files to Windows:
   ```batch
   mkdir C:\Windows\Setup\Scripts
   copy BloatwareGUI.ps1 C:\Windows\Setup\Scripts\
   copy unattend_template.xml C:\Windows\Panther\
   ```

5. Run the script:
   ```batch
   bypass-oobe.cmd
   ```

### Custom Modifications

You can edit `BloatwareGUI.ps1` to customize:
- Which apps to remove
- Add more profiles
- Change privacy settings
- Modify the GUI appearance

Edit the `$appsToRemove` array for each profile to add/remove apps.

## Logs

After setup, check logs at:
- `C:\Windows\Setup\Scripts\BloatwareRemoval.log` - Full removal log with timestamps

The log shows:
- Which profile was selected
- Each app that was removed
- Any apps that failed to remove
- Privacy tweaks applied (Full profile)

## Troubleshooting

### Still Asks for Microsoft Account
- Make sure you're running the script during OOBE (not after Windows is installed)
- Try pressing `Shift + F10` earlier in the setup process
- Verify internet connection for downloading files

### GUI Doesn't Appear
- Check if `C:\Windows\Setup\Scripts\BloatwareGUI.ps1` exists
- Manually run: `powershell -ExecutionPolicy Bypass -File C:\Windows\Setup\Scripts\BloatwareGUI.ps1`
- Check unattend.xml was applied: `C:\Windows\Panther\unattend.xml`

### Apps Not Removed
- Some apps are protected and can't be removed
- Windows Update may reinstall some apps later
- Check `BloatwareRemoval.log` for details
- Some apps require multiple reboots to fully remove

### Can't Login
- Default username is "Admin" with no password
- If you set a custom username/password, use those
- Press Enter at password prompt if you didn't set a password

## Credits

- Based on [Chris Titus Tech's bypassnro](https://github.com/ChrisTitusTech/bypassnro)
- Uses [schneegans.de unattend generator](https://schneegans.de/windows/unattend-generator/) principles

## License

MIT License - Free to use, modify, and distribute

## Disclaimer

This modifies Windows installation. Use at your own risk. Backup important data before installing Windows.

Some apps may be reinstalled by Windows Update. You can block this by:
1. Group Policy: `gpedit.msc` → Computer Configuration → Administrative Templates → Windows Components → Store → Turn off Automatic Download and Install of updates
2. Or disable Store auto-updates in Settings

---

**Tested on:** Windows 11 23H2, 24H2
**Requirements:** Internet connection during OOBE (for online method)
