# Windows 11 OOBE Bypass - Testing Guide

## Quick Testing Instructions

### What This Does
- Bypasses Microsoft account requirement during Windows 11 setup
- Creates custom username/password of your choice
- Auto-launches GUI on first login to select bloatware removal level
- No extra steps needed - everything happens automatically

---

## Method 1: Online Testing (Requires Internet)

### During Windows 11 OOBE:

1. **Start Windows 11 installation** in your VM

2. **When you see the Microsoft account screen**, press:
   ```
   Shift + F10
   ```
   This opens Command Prompt

3. **Run these commands:**
   ```batch
   curl -L -o bypass.cmd https://raw.githubusercontent.com/mxoio/bypassnro/main/bypass-oobe.cmd
   bypass.cmd
   ```

4. **Follow the prompts:**
   - Enter desired username (or press Enter for "Admin")
   - Enter desired password (or press Enter for no password)
   - Script will download files and apply configuration
   - System will reboot

5. **After reboot:**
   - Windows will complete setup automatically
   - Auto-login happens with your account
   - **Bloatware GUI appears automatically** - NO NEED TO RUN ANYTHING!
   - Select your profile (Minimal/Gaming/Standard/Full)
   - Click "Apply"
   - Done!

---

## Method 2: Offline Testing (USB/ISO)

### Preparation (Do this on your host machine):

1. **Download all required files:**
   ```batch
   curl -L -o bypass-oobe.cmd https://raw.githubusercontent.com/mxoio/bypassnro/main/bypass-oobe.cmd
   curl -L -o unattend_template.xml https://raw.githubusercontent.com/mxoio/bypassnro/main/unattend_template.xml
   curl -L -o BloatwareGUI.ps1 https://raw.githubusercontent.com/mxoio/bypassnro/main/BloatwareGUI.ps1
   ```

2. **Put these 3 files on:**
   - USB drive, OR
   - Mount as second virtual drive in VM, OR
   - Add to Windows ISO

### During Windows 11 OOBE in VM:

1. **At Microsoft account screen**, press:
   ```
   Shift + F10
   ```

2. **Navigate to your files** (adjust drive letter as needed):
   ```batch
   D:
   cd \
   ```

3. **Copy files to Windows:**
   ```batch
   mkdir C:\Windows\Setup\Scripts
   copy BloatwareGUI.ps1 C:\Windows\Setup\Scripts\
   copy unattend_template.xml C:\Windows\Panther\
   ```

4. **Run the script:**
   ```batch
   bypass-oobe.cmd
   ```

5. **Follow prompts** (same as online method above)

---

## What To Test

### ✅ Basic Functionality:
- [ ] Script runs without errors
- [ ] Username/password prompt works
- [ ] System reboots after running script
- [ ] Microsoft account screen is bypassed
- [ ] Custom username is created
- [ ] Auto-login works on first boot
- [ ] GUI appears automatically after login

### ✅ GUI Testing:
- [ ] GUI window appears on first login
- [ ] All 4 radio buttons are visible
- [ ] Descriptions are readable
- [ ] "Apply" button works
- [ ] Progress messages appear during removal
- [ ] GUI closes when complete

### ✅ Profile Testing:
Test each profile to verify correct apps are removed:

- [ ] **Minimal** - No apps removed, completes instantly
- [ ] **Gaming** - Removes bloat but Xbox remains
- [ ] **Standard** - Removes bloat AND Xbox
- [ ] **Full** - Maximum removal + privacy tweaks

### ✅ Logging:
- [ ] Log file created at `C:\Windows\Setup\Scripts\BloatwareRemoval.log`
- [ ] Log shows selected profile
- [ ] Log shows removed apps
- [ ] Log shows failed removals (if any)

---

## Expected Results

### Minimal Profile:
- **Apps Removed:** None
- **Time:** ~2 seconds
- **Log:** "Minimal profile - no bloatware removal"

### Gaming Profile:
- **Apps Removed:** OneDrive, Teams, Office Hub, Bing apps, Cortana, etc.
- **Apps Kept:** Xbox, Game Bar, Xbox services
- **Time:** 2-5 minutes
- **Log:** Shows ~20 apps removed

### Standard Profile:
- **Apps Removed:** Everything from Gaming + Xbox apps
- **Apps Kept:** Essential Windows features
- **Time:** 3-7 minutes
- **Log:** Shows ~27 apps removed

### Full Profile:
- **Apps Removed:** Everything from Standard + Maps, Sound Recorder, Paint, etc.
- **Registry Changes:** Telemetry disabled, activity history disabled
- **Time:** 5-10 minutes
- **Log:** Shows ~30+ apps removed + privacy tweaks

---

## Verification Commands

After bloatware removal, verify what was removed:

### Check if OneDrive is gone:
```powershell
Get-AppxPackage -Name Microsoft.OneDrive
```
Should return nothing if removed.

### Check if Xbox is present (Gaming profile should keep it):
```powershell
Get-AppxPackage -Name Microsoft.GamingApp
```
Should show Xbox if Gaming profile was used.

### Check privacy settings (Full profile):
```powershell
Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry"
```
Should show `0` if Full profile was used.

### List all remaining AppX packages:
```powershell
Get-AppxPackage | Select-Object Name | Sort-Object Name
```

---

## Troubleshooting

### Issue: Microsoft account screen still appears
- **Cause:** Script wasn't run during OOBE, or internet connection failed
- **Fix:** Restart VM, try again earlier in OOBE process

### Issue: GUI doesn't appear on first login
- **Cause:** FirstLogonCommands didn't execute
- **Check:** Does `C:\Windows\Setup\Scripts\BloatwareGUI.ps1` exist?
- **Fix:** Manually run: `powershell -ExecutionPolicy Bypass -File C:\Windows\Setup\Scripts\BloatwareGUI.ps1`

### Issue: Apps aren't removed
- **Cause:** Apps are provisioned differently, or protected
- **Check:** Log file at `C:\Windows\Setup\Scripts\BloatwareRemoval.log`
- **Note:** Some apps can't be removed, this is normal

### Issue: Can't login
- **Cause:** Wrong username/password
- **Fix:** Use the username you entered, or "Admin" if you pressed Enter
- **Password:** Leave blank if you pressed Enter, otherwise use what you entered

---

## Files Location Reference

### During OOBE:
- `C:\Windows\Panther\unattend_template.xml` - Template (downloaded)
- `C:\Windows\Panther\unattend.xml` - Generated config with your credentials
- `C:\Windows\Setup\Scripts\BloatwareGUI.ps1` - GUI script (downloaded)

### After Installation:
- `C:\Windows\Setup\Scripts\BloatwareRemoval.log` - Removal log
- `C:\Windows\Panther\setupact.log` - Windows setup log (for advanced debugging)

---

## VM Setup Recommendations

### Hyper-V / VMware / VirtualBox:
- **RAM:** 4GB minimum (8GB recommended)
- **Disk:** 60GB minimum
- **Network:** Enabled (for online method)
- **ISO:** Windows 11 23H2 or 24H2

### Snapshot Strategy:
1. **Snapshot 1:** Fresh Windows 11 ISO mounted, before OOBE
2. **Snapshot 2:** After running script, before reboot
3. **Snapshot 3:** After first login, before selecting profile
4. **Snapshot 4:** After bloatware removal completes

This lets you quickly test different profiles without reinstalling.

---

## Quick Test Checklist

```
VM Setup:
[ ] Windows 11 VM created
[ ] Network enabled (for online method) OR files prepared (for offline)
[ ] Snapshot taken before OOBE

During OOBE:
[ ] Pressed Shift + F10 successfully
[ ] Downloaded/ran bypass-oobe.cmd
[ ] Entered custom username: ___________
[ ] Entered custom password: ___________
[ ] System rebooted

After Reboot:
[ ] Microsoft account screen bypassed
[ ] Auto-login worked
[ ] GUI appeared automatically
[ ] Selected profile: ___________
[ ] Apps removed successfully
[ ] Log file created

Verification:
[ ] Checked removed apps
[ ] Checked log file
[ ] Confirmed expected apps are gone
[ ] Confirmed expected apps remain (Gaming = Xbox stays)
```

---

## Expected Timeline

- **Script execution:** 30-60 seconds
- **First reboot:** 2-5 minutes
- **Windows setup completion:** 3-5 minutes
- **GUI appearance:** Immediately after login
- **Bloatware removal:**
  - Minimal: 2 seconds
  - Gaming: 2-5 minutes
  - Standard: 3-7 minutes
  - Full: 5-10 minutes

**Total time from OOBE to finished:** ~15-25 minutes

---

## Contact / Issues

If something doesn't work:

1. Check log file: `C:\Windows\Setup\Scripts\BloatwareRemoval.log`
2. Check unattend was applied: `C:\Windows\Panther\unattend.xml` should exist
3. Check Windows setup logs: `C:\Windows\Panther\setupact.log`
4. Report issue with logs at: https://github.com/mxoio/bypassnro/issues

---

## GitHub Repository

All files available at: https://github.com/mxoio/bypassnro

- bypass-oobe.cmd
- unattend_template.xml
- BloatwareGUI.ps1
- README.md
- TESTING-GUIDE.md (this file)

---

**Good luck with testing!** 🚀
