# Windows 11 OOBE Bypass

Simple script to bypass Microsoft account requirement during Windows 11 installation using [Chris Titus Tech's proven method](https://github.com/ChrisTitusTech/bypassnro).

## Quick Start

During Windows 11 installation (OOBE screen):

1. Press `Shift + F10` to open Command Prompt
2. Run the script:
   ```batch
   curl -L -o bypass.cmd https://raw.githubusercontent.com/mxoio/bypassnro/main/bypass-oobe.cmd
   bypass.cmd
   ```
3. Enter your desired username (or press Enter for "Admin")
4. System will reboot and complete setup with local account

## What It Does

- ✅ Creates local administrator account (no password required)
- ✅ Bypasses Microsoft account requirement
- ✅ Auto-login once to complete Windows setup
- ✅ Removes bloatware (OneDrive, Teams, Xbox apps, Bing apps, etc.)
- ✅ Configures privacy settings
- ✅ Disables telemetry

## Files

- **bypass-oobe.cmd** - Main script to run during OOBE
- **unattend.xml** - Chris Titus Tech's proven unattend configuration

## How to Use

### Method 1: Download During OOBE (Requires Internet)

At the Microsoft account screen during Windows setup:
1. Press `Shift + F10`
2. Run:
   ```batch
   curl -L -o bypass.cmd https://raw.githubusercontent.com/mxoio/bypassnro/main/bypass-oobe.cmd
   bypass.cmd
   ```

### Method 2: USB Drive (Offline)

1. Download both files to a USB drive:
   - bypass-oobe.cmd
   - unattend.xml
2. During Windows setup, press `Shift + F10`
3. Navigate to USB drive (usually D: or E:)
4. Run: `bypass-oobe.cmd`

## What Gets Removed

Chris's configuration removes:
- OneDrive
- Teams
- Cortana
- Xbox apps
- Office Hub
- Mail & Calendar
- Bing apps (News, Weather)
- Clipchamp, Paint 3D, Mixed Reality
- Feedback Hub, Tips, Get Help
- And many more...

## What Gets Kept

Essential apps are preserved:
- Microsoft Store
- Windows Terminal
- Notepad
- Calculator
- Settings

## Technical Details

This script uses Chris Titus Tech's `unattend.xml` which:

1. **windowsPE pass** - Accepts EULA automatically
2. **specialize pass** - Extracts embedded PowerShell scripts and runs configuration
3. **oobeSystem pass** - Creates local accounts with AutoLogon
4. **FirstLogon** - Runs cleanup scripts and disables auto-login

The unattend.xml contains embedded PowerShell scripts that:
- Remove provisioned app packages
- Disable Windows capabilities (features)
- Configure privacy settings
- Set taskbar preferences
- Remove bloatware

## Logs

After setup completes, check these logs to verify:
- `C:\Windows\Setup\Scripts\Specialize.log` - Main configuration log
- `C:\Windows\Setup\Scripts\RemovePackages.log` - App removal log
- `C:\Windows\Setup\Scripts\FirstLogon.log` - First boot configuration

## Customization

The script allows you to customize the username. If you want to customize what gets removed:

1. Edit `unattend.xml`
2. Modify the app lists in the `RemovePackages.ps1` section
3. Save and use your customized version

## Troubleshooting

### Still Asks for Microsoft Account

- Verify `C:\Windows\Panther\unattend.xml` exists and has content
- Check `C:\Windows\Panther\setupact.log` for errors
- Try downloading the script again

### No Apps Removed

- Check `C:\Windows\Setup\Scripts\RemovePackages.log`
- Scripts run on first login, give it a few minutes
- Some apps may only be available after Windows Update

### Can't Login

- Default account is "Admin" with no password
- If you customized the username, use that instead
- Press Enter at password prompt (no password set)

## Credits

- **Chris Titus Tech** - Original unattend.xml and bypass method
- Based on [schneegans.de unattend generator](https://schneegans.de/windows/unattend-generator/)

## License

MIT License - Free to use, modify, and distribute

## Disclaimer

This modifies Windows installation. Use at your own risk. Backup important data before installing Windows.

---

**Tested on**: Windows 11 23H2, 24H2
