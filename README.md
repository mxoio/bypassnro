# Windows 11 Local Account Bypass

An interactive solution to bypass Microsoft's account requirement during Windows 11 installation, with customizable debloating profiles.

## 🚀 Quick Start

During Windows 11 installation (OOBE screen):

1. Press `Shift + F10` to open Command Prompt
2. Run these commands:
```batch
curl -L mxoio.github.io/bypassnro/bypass.cmd -o skip.cmd
skip.cmd
```
3. Follow the interactive prompts to configure your installation

## 📋 Features

- ✅ **Interactive Setup** - Prompts for username, password, and display name
- ✅ **No Auto-Login** - Disabled by default for security
- ✅ **Multiple Profiles** - Choose from 4 different debloat levels
- ✅ **Privacy-Focused** - Removes telemetry and bloatware
- ✅ **Easy Updates** - Hosted on GitHub Pages for reliability

## 🎯 Installation Profiles

### 1. Minimal
- Removes only essential bloatware
- Keeps most Windows features intact
- Disables: Cortana, Copilot, Teams auto-install, News
- **Best for**: Users who want a light touch

### 2. Standard (Recommended)
- Balanced bloatware removal
- Removes common unnecessary apps
- Keeps essential Windows functionality
- Configures taskbar and search settings
- **Best for**: Most users

### 3. Gaming
- Keeps all gaming features (Xbox, Game Bar, Game DVR)
- Removes productivity apps (Office, Outlook, Teams)
- Optimized for gaming performance
- **Best for**: Gaming PCs

### 4. Full Debloat
- Maximum bloatware removal
- Removes Xbox apps, OneDrive, optional features
- Most aggressive privacy settings
- Enables long paths support
- **Best for**: Advanced users, developers, privacy enthusiasts

## 🛠️ What Gets Configured

All profiles include:
- ✅ Local account creation (bypasses Microsoft account)
- ✅ Disabled Copilot
- ✅ Disabled Teams auto-install
- ✅ Disabled password expiration
- ✅ Privacy-enhanced settings

## 📖 Manual Installation

If you prefer to download and review the files first:

1. Download `bypass.cmd` from this repository
2. Review the unattend XML files to see what will be modified
3. During Windows setup, press `Shift + F10`
4. Copy the `bypass.cmd` file to the system (via USB or network)
5. Run it: `bypass.cmd`

## 🔒 Security Notes

- All scripts are open source and can be reviewed before use
- Passwords are stored in plaintext in the unattend.xml temporarily (deleted after setup)
- No data is collected or sent anywhere
- Auto-login is **disabled** by default

## 🌐 Using Your Own Host

To host this yourself:

1. Fork this repository
2. Enable GitHub Pages in Settings → Pages
3. Set source to "Deploy from a branch" → main → /root
4. Update the URL in `bypass.cmd` to point to your GitHub Pages URL:
```batch
curl -L -o C:\Windows\Panther\unattend.xml https://yourusername.github.io/bypassnro/unattend-!PROFILE_NAME!.xml
```

## 🤝 Credits

Based on the original concept by [ChrisTitusTech](https://github.com/ChrisTitusTech/bypassnro)

Enhanced with:
- Interactive user input
- Multiple debloat profiles
- No auto-login (security improvement)
- Modular design

## ⚠️ Disclaimer

This tool modifies Windows installation behavior. Use at your own risk. Always backup important data before installing Windows.

## 📝 License

MIT License - Feel free to modify and distribute

## 🐛 Issues

Found a bug or have a suggestion? [Open an issue](https://github.com/mxoio/bypassnro/issues)

---

**Note**: This is designed for Windows 11 and has been tested on version 24H2 and newer builds where Microsoft has removed the traditional bypass methods.
