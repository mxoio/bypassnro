# Windows 11 OOBE Bypass

A single-file solution to bypass Microsoft's account requirement during Windows 11 installation, with customizable debloating profiles.

## 🚀 Quick Start

During Windows 11 installation (OOBE screen):

1. Press `Shift + F10` to open Command Prompt
2. **Option A** - Download (requires internet):
   ```batch
   curl -L -o bypass.cmd https://raw.githubusercontent.com/mxoio/bypassnro/main/bypass-oobe.cmd
   bypass.cmd
   ```
3. **Option B** - From USB (works offline):
   - Copy `bypass-oobe.cmd` to USB drive
   - Run it from USB
4. Follow the interactive prompts to configure your installation

## 📋 Features

- ✅ **Single File** - Everything in one script, no separate XML files needed
- ✅ **Interactive Setup** - Prompts for username and password
- ✅ **Works Offline** - No internet connection required
- ✅ **Custom Accounts** - Create your own username and password
- ✅ **Multiple Profiles** - Choose from 4 different debloat levels
- ✅ **Privacy-Focused** - Removes telemetry and bloatware
- ✅ **Easy to Use** - Simple command-line interface

## 🎯 Installation Profiles

### 1. Minimal (Bypass Only)
- **Bypasses Microsoft account requirement ONLY**
- Creates local account with your chosen username
- Keeps ALL Windows features intact
- No bloatware removal
- Ideal for: Users who just want to skip Microsoft account sign-in

### 2. Gaming (Bypass + Gaming Optimized)
- Bypasses Microsoft account requirement
- **Keeps gaming features** (Xbox, Game Bar, Game DVR)
- Removes non-gaming bloatware (Office, Teams, Spotify, etc.)
- Disables telemetry and tracking
- Ideal for: Gaming PCs and users who want Xbox features

### 3. Standard (Balanced Debloat)
- Bypasses Microsoft account requirement
- Removes common bloatware (including Xbox apps)
- Removes unnecessary Microsoft apps
- Enhanced privacy settings
- Shows file extensions and hidden files
- Ideal for: Most users who want a cleaner system

### 4. Full Debloat (Maximum Privacy)
- Bypasses Microsoft account requirement
- **Removes almost all bloatware** (keeps only Store, Calculator, Photos, Terminal, Paint)
- Disables OneDrive, Cortana, Windows Defender
- Maximum privacy and telemetry blocking
- Enables long path support
- Disables Copilot, Widgets, Chat
- Ideal for: Advanced users, developers, privacy enthusiasts

## 🛠️ What Gets Configured

### All Profiles Include:
- ✅ Local account creation (bypasses Microsoft account)
- ✅ Custom username and password
- ✅ No security questions required
- ✅ Skips OOBE privacy screens
- ✅ Registry bypass for network requirement

## 📖 Installation Instructions

### Method 1: Download During Setup (Requires Internet)

1. During Windows 11 installation, when you reach the Microsoft account screen:
   - Press `Shift + F10` to open Command Prompt
2. Run these commands:
   ```batch
   curl -L -o bypass.cmd https://raw.githubusercontent.com/mxoio/bypassnro/main/bypass-oobe.cmd
   bypass.cmd
   ```
3. Follow the on-screen prompts:
   - Choose your debloat profile (1-4)
   - Enter your desired username
   - Enter your password (or leave blank)
4. The system will reboot and complete setup with your local account

### Method 2: From USB (Works Offline)

1. Download `bypass-oobe.cmd` to a USB drive before installation
2. During Windows 11 installation, when you reach the Microsoft account screen:
   - Press `Shift + F10` to open Command Prompt
   - Type: `D:` (or whatever drive letter your USB is)
   - Type: `bypass-oobe.cmd` (or whatever you named it)
3. Follow the on-screen prompts
4. The system will reboot and complete setup

## 🔒 Security Notes

- All scripts are open source and can be reviewed before use
- Passwords are temporarily stored in `C:\Windows\Panther\unattend.xml` during setup
- The unattend.xml file can be deleted after setup completes
- No data is collected or sent anywhere
- All changes are applied locally during installation

## ⚙️ How It Works

1. **BypassNRO Registry Key**: Sets `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE\BypassNRO` to skip network requirement
2. **Dynamic XML Generation**: Creates unattend.xml on-the-fly based on your selections
3. **Local Account Creation**: Creates a local administrator account with your credentials
4. **FirstLogonCommands**: Runs PowerShell and registry commands on first boot to remove bloatware and configure privacy settings

## 🔧 Files in This Repository

- **bypass-oobe.cmd** - The all-in-one script (recommended)
- **bypass.cmd** - Original script that uses separate XML files
- **unattend-*.xml** - Separate XML files for each profile (optional, for manual customization)
- **FIXES.md** - Details of what was fixed in this version
- **TESTING-GUIDE.md** - Comprehensive testing instructions

## 🆚 Which File Should I Use?

- **Use `bypass-oobe.cmd`** if you want a single file that's easy to manage (recommended)
- **Use `bypass.cmd` + XML files** if you want to customize the XML files yourself

## 🐛 Troubleshooting

### "Script Can't Find unattend.xml"
- Make sure you're running the script during OOBE with Shift+F10
- Check that `C:\Windows\Panther` directory exists
- Try running Command Prompt as Administrator

### "System Still Asks for Microsoft Account"
- The BypassNRO command may not have executed
- Try the manual method:
  ```batch
  reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v BypassNRO /t REG_DWORD /d 1 /f
  shutdown /r /t 5
  ```

### "User Account Not Created"
- Check that the unattend.xml file was created in `C:\Windows\Panther\`
- Verify your username doesn't contain special characters
- Try using the Minimal profile first to isolate issues

## 🤝 Credits

Based on the original concept by [ChrisTitusTech](https://github.com/ChrisTitusTech/bypassnro)

Enhanced with:
- Single-file operation (no separate XML files needed)
- Dynamic XML generation
- Multiple debloat profiles
- Custom username/password support
- Gaming-optimized profile

## ⚠️ Disclaimer

This tool modifies Windows installation behavior. Use at your own risk. Always backup important data before installing Windows.

**Important**: Full Debloat profile disables Windows Defender - only use if you plan to install alternative security software.

## 📝 License

MIT License - Feel free to modify and distribute

## 🐛 Issues

Found a bug or have a suggestion? [Open an issue](https://github.com/mxoio/bypassnro/issues)

---

**Note**: This is designed for Windows 11 and has been tested on version 24H2 and newer builds where Microsoft has removed the traditional bypass methods.
