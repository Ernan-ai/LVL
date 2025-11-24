# LVL - Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Get Pre-Built App (Easiest)

**If you have GitHub access:**
1. Go to GitHub repo → **Actions** tab
2. Download latest successful build:
   - `LVL_Encryp.apk` for Android
   - `LVL_Encryp.ipa` for iOS (use with Sideloadly)
3. Install and skip to Step 3!

### Step 2: Or Build Locally

**If building from source:**
```bash
cd d:\Encryp\encryp_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

**Or use GitHub Actions** (recommended):
```bash
git push origin main
# Then download artifacts from GitHub Actions tab
```

### Step 3: First Time Setup
1. Enter your username (one-time setup)
2. Create a master password (REMEMBER THIS!)
3. (Optional) Enable biometric authentication

### Step 4: Start Using LVL

#### Create Your First Note
1. Tap the bottom navigation to go to vault
2. Tap "+" floating action button
3. Select "Note"
4. Choose a template or start from scratch
5. Save with tags and folder

#### Store a Password
1. Tap "+" → "Password"
2. Enter username and password
3. Add URL and notes (optional)
4. Save to vault (encrypted automatically)

#### Try a Template
1. Create new note
2. Select "Templates"
3. Choose from 15+ pentesting templates:
   - OSCP Lab Notes
   - HackTheBox Machine
   - Burp Suite Session
   - Nmap Scan Results
   - And more...
4. Template loads with structured format

## 📝 Common Tasks

### Organize with Tags & Folders
```
Tags: #oscp #htb #webapp #privesc #recon
Folders: CTF/HackTheBox, Work/Pentests, Training/OSCP
```

### Search Quickly
- Search bar searches titles and tags
- Filter by type (notes, passwords, scripts)
- Sort by date, name, or favorites

### Export Your Vault
1. Settings → Export Vault
2. Enter master password
3. Save `.scvault` file securely
4. File is encrypted and compressed

### Transfer via QR Code
1. Select items to transfer
2. Tap "Share via QR"
3. Scan QR codes on receiving device
4. Data transfers securely (encrypted)

### Change Theme
1. Settings → Theme
2. Choose from 10 cybersecurity themes:
   - Kali Purple (default)
   - Parrot OS
   - Black Hat
   - Matrix
   - Cyberpunk
   - Red Team / Blue Team
   - And more...

### Configure Security
1. **Auto-Lock**: Settings → Security → Auto-Lock Timer (1-5 min)
2. **Biometric**: Settings → Enable Face ID/Fingerprint
3. **Screenshot Protection**: Enabled by default

## ⚠️ Important Reminders

### Remember Your Master Password!
- **NO PASSWORD RECOVERY**
- Lost password = Lost data
- No backdoors by design
- Make regular exports

### Self-Destruct Features
- **10 wrong password attempts** → All data wiped
- **Panic button** (volume-down 5s) → Instant wipe
- No confirmation, no recovery

### Remaining Attempts
The app shows remaining attempts on login screen:
```
Wrong password! 7 attempts remaining.
⚠️ All data will be wiped after 10 failed attempts!
```

## 🎯 Pro Tips

### For Pentesting
1. **Create engagement folders**: `Work/ClientName-2024`
2. **Use consistent tags**: `#webapp #network #privesc #loot`
3. **Start from templates**: Faster documentation
4. **Store screenshots as files**: Encrypted automatically
5. **Export after each day**: Regular backups

### For OSCP/Certifications
1. **One folder per machine**: `OSCP/Lab/10.10.10.5`
2. **Use OSCP template**: Pre-structured format
3. **Tag by category**: `#linux #windows #easy #medium #hard`
4. **Save exploits as scripts**: Reusable code
5. **Track flags separately**: Easy to find later

### For Bug Bounty
1. **Folder per program**: `BugBounty/ProgramName`
2. **Burp template**: Structured findings
3. **Tag by severity**: `#critical #high #medium #low`
4. **Store POC scripts**: Quick reproduction
5. **Export before submission**: Backup evidence

### For Security Research
1. **Tag by CVE**: `#CVE-2024-1234`
2. **Store payloads as scripts**: Language-tagged
3. **Use markdown for writeups**: Professional format
4. **Files for binary analysis**: Up to 10MB
5. **QR transfer to airgapped VMs**: No network needed

## 🔐 Security Best Practices

### Daily Usage
- ✅ Lock when leaving desk (auto-lock handles this)
- ✅ Don't share master password
- ✅ Enable biometric for convenience
- ✅ Screenshot protection prevents shoulder surfing
- ✅ Use strong master password (12+ chars)

### Weekly Maintenance
- ✅ Export vault to `.scvault` file
- ✅ Store export in separate secure location
- ✅ Review and tag unorganized items
- ✅ Clean up old/unused items
- ✅ Verify auto-lock is working

### Before Important Work
- ✅ Test panic button (not with real data!)
- ✅ Verify exports are working
- ✅ Check remaining storage space
- ✅ Update vault organization
- ✅ Practice emergency procedures

## 🆘 Troubleshooting

### "I forgot my password!"
**There is no recovery.** Your data is lost. This is by design for security.

Prevention:
- Write password in physical notebook (kept secure)
- Use password you'll remember
- Regular exports to `.scvault` files

### "App won't unlock with Face ID/Fingerprint"
Biometric is secondary auth. You still need master password:
1. Enter master password first
2. Then biometric will work for future unlocks
3. Or disable biometric and use password only

### "Vault seems slow"
- Large vaults (1000+ items) may be slower
- Export and archive old data
- Keep active vault under 500 items for best performance
- Search filters help find items faster

### "QR transfer not working"
- Ensure both devices have camera permission
- Good lighting helps QR scanning
- For large transfers, expect multiple QR codes
- Position camera 6-12 inches from screen

### "Screenshot says 'blocked'"
This is correct! Screenshot protection is working.
- Android: Screenshots are blocked
- iOS: Screenshots are detected (can't be blocked)

### "Panic button activated accidentally!"
**All data is now wiped.** This cannot be undone.

Prevention:
- Be careful with volume buttons
- 5 second hold is intentional delay
- Keep regular exports
- Restore from `.scvault` backup

## 📱 Keyboard Shortcuts

### When Unlocked
- `Ctrl/Cmd + F`: Search
- `Ctrl/Cmd + N`: New item
- `Ctrl/Cmd + E`: Export vault
- `Ctrl/Cmd + L`: Lock vault
- `Ctrl/Cmd + T`: Change theme

### In Editor
- `Ctrl/Cmd + B`: Bold (markdown)
- `Ctrl/Cmd + I`: Italic (markdown)
- `Ctrl/Cmd + K`: Code block (markdown)
- `Ctrl/Cmd + S`: Save
- `Esc`: Cancel

## 🎓 Learning Resources

### Templates to Study
1. Start with **OSCP Lab Notes** - Learn structure
2. Try **Burp Suite Session** - Web testing format
3. Explore **Nmap Scan Results** - Recon workflow
4. Use **Reverse Shell Cheatsheet** - Quick reference

### Markdown Basics
```markdown
# Heading 1
## Heading 2
**Bold text**
*Italic text*
`code`
```bash
command here
```
- Bullet point
1. Numbered list
```

### Tag Strategy
```
Categories: #webapp #network #mobile #wireless
Severity: #critical #high #medium #low
Status: #todo #inprogress #complete
Tools: #burp #nmap #metasploit #wireshark
Platforms: #linux #windows #macos #android
```

## 🎉 You're Ready!

You now know:
- ✅ How to create and organize items
- ✅ Security features and best practices
- ✅ How to export and transfer data
- ✅ Templates for pentesting workflows
- ✅ Troubleshooting common issues

**Start securing your sensitive data with LVL!**

---

## ⚡ Quick Reference Card

```
╔════════════════════════════════════════════════════════════╗
║                    LVL QUICK REFERENCE                      ║
╠════════════════════════════════════════════════════════════╣
║ SECURITY                                                    ║
║  • Auto-Lock: 1-5 minutes (configurable)                   ║
║  • Failed Attempts: 10 max (then wipe)                     ║
║  • Panic Button: Volume-down 5 seconds                     ║
║  • Screenshot: Blocked (Android)                           ║
║                                                             ║
║ DATA TYPES                                                  ║
║  • Notes (Markdown + syntax highlighting)                  ║
║  • Passwords (username/password/URL)                       ║
║  • Tokens (API keys with expiry)                           ║
║  • Scripts (bash/python/sql/js/etc)                        ║
║  • Files (up to 10MB, encrypted)                           ║
║                                                             ║
║ ORGANIZATION                                                ║
║  • Tags: #hashtag format                                   ║
║  • Folders: Hierarchical structure                         ║
║  • Search: Title + tags (content stays encrypted)          ║
║  • Favorites: Quick access                                 ║
║                                                             ║
║ BACKUP & TRANSFER                                           ║
║  • Export: .scvault file (encrypted)                       ║
║  • Import: Restore from .scvault                           ║
║  • QR Transfer: Device-to-device (no internet)             ║
║                                                             ║
║ REMEMBER                                                    ║
║  • NO password recovery                                    ║
║  • NO cloud sync                                           ║
║  • NO internet permission                                  ║
║  • Make REGULAR backups                                    ║
╚════════════════════════════════════════════════════════════╝
```

Need more details? See:
- `SECURITY_FEATURES.md` - Complete feature list
- `BUILD_GUIDE.md` - Build and deployment
- `README.md` - Project overview
