# LVL - Secure Cybersecurity Vault

## 🔒 Security Features Overview

LVL is a military-grade encrypted vault designed for cybersecurity professionals, penetration testers, and security researchers who need absolute privacy and offline-first security.

## ✨ Core Features

### 1. **Master Password + Biometric Authentication**
- ✅ Master password required to access vault
- ✅ Face ID support (iOS)
- ✅ Fingerprint authentication (Android/iOS)
- ✅ Biometric auth as secondary authentication layer
- ✅ Password strength validation

### 2. **AES-256-GCM Encryption**
- ✅ Military-grade encryption using AES-256-GCM mode
- ✅ SHA-256 key derivation from master password
- ✅ Unique initialization vector (IV) for each encryption operation
- ✅ All data encrypted before storage
- ✅ Content stays encrypted in database (only titles/tags searchable)

### 3. **Comprehensive Data Storage**
Store multiple types of sensitive data:
- ✅ **Notes**: Markdown notes with syntax highlighting
- ✅ **Passwords/Credentials**: Username, password, URL, notes
- ✅ **Tokens/API Keys**: Service tokens with expiration tracking
- ✅ **Keys**: Encryption keys, SSH keys, etc.
- ✅ **Scripts**: Code snippets with language support (bash, python, sql, js, etc.)
- ✅ **Files**: Encrypted file storage up to 10 MB per file

### 4. **Hive Database with Encrypted Boxes**
- ✅ Local-only Hive database
- ✅ Fully encrypted boxes using AES-256
- ✅ No cloud sync - everything stays on device
- ✅ Fast query performance
- ✅ Automatic data persistence

### 5. **Markdown Editor with Syntax Highlighting**
- ✅ Full markdown support
- ✅ Syntax highlighting for 15+ languages:
  - Bash, Python, SQL, JavaScript, TypeScript
  - Java, C, C++, C#, Go, Rust
  - PHP, Ruby, PowerShell, YAML, JSON
- ✅ Real-time preview
- ✅ Monospace font for terminal aesthetic

### 6. **15+ Built-in Templates**

#### Training & Labs
1. **OSCP Lab Notes** - Structured lab documentation
2. **HackTheBox Machine** - HTB writeup template
3. **TryHackMe Room** - THM room documentation

#### Web Application Testing
4. **Burp Suite Session** - Web app testing notes
5. **SQL Injection Test** - SQLi payloads and tests
6. **XSS Payloads** - Cross-site scripting vectors
7. **API Security Testing** - API penetration testing

#### Network & Wireless
8. **Nmap Scan Results** - Network reconnaissance
9. **Wireless Network Audit** - WiFi security testing

#### Exploitation
10. **Metasploit Session** - MSF framework notes
11. **Reverse Shell Cheatsheet** - Shell payload collection

#### Privilege Escalation
12. **Linux Privilege Escalation** - Linux privesc checklist
13. **Windows Privilege Escalation** - Windows privesc guide

#### Reconnaissance & Reporting
14. **Web Application Reconnaissance** - Web recon workflow
15. **Incident Response Log** - IR documentation
16. **Penetration Test Report** - Professional pentest report

### 7. **Tags, Folders & Fast Search**
- ✅ Organize items with custom tags
- ✅ Create folder hierarchies
- ✅ Fast search by title and tags (content stays encrypted)
- ✅ Filter by type (notes, passwords, scripts, etc.)
- ✅ Favorite items for quick access
- ✅ Sort by date, name, or type

### 8. **Export/Import Encrypted Vault**
- ✅ Export entire vault as single `.scvault` file
- ✅ Vault file is encrypted with master password
- ✅ Compressed using gzip for smaller file size
- ✅ Import vault from `.scvault` file
- ✅ Validates file integrity before import
- ✅ Transfer vaults between devices

### 9. **QR Code Data Transfer**
- ✅ Transfer data between devices via QR codes
- ✅ Large data automatically split into multiple QR codes
- ✅ Encrypted transfer with temporary password
- ✅ Scan and transfer in seconds
- ✅ Perfect for air-gapped environments
- ✅ No internet required

### 10. **Auto-Lock Timer**
- ✅ Configurable auto-lock (1-5 minutes)
- ✅ Locks vault after inactivity
- ✅ Countdown timer visible to user
- ✅ Resets on user activity
- ✅ Can be disabled (not recommended)
- ✅ Immediate lock on app backgrounding

### 11. **Self-Destruct Security**
- ✅ Counts failed login attempts
- ✅ Shows remaining attempts (10 total)
- ✅ **Automatically wipes ALL data after 10 wrong attempts**
- ✅ No recovery possible - data is gone forever
- ✅ Protects against brute force attacks
- ✅ Resets counter on successful login

### 12. **Panic Button**
- ✅ **Hold volume-down button for 5 seconds**
- ✅ Instantly wipes all vault data
- ✅ Emergency data destruction
- ✅ Works even when app is locked
- ✅ No confirmation needed (instant wipe)
- ✅ Perfect for emergency situations

### 13. **Screenshot Protection**
- ✅ **Android**: FLAG_SECURE prevents screenshots
- ✅ **iOS**: Screenshot detection (can't block, but can detect)
- ✅ Screen recording blocked on Android
- ✅ Enabled by default
- ✅ Prevents shoulder surfing via screenshots
- ✅ Protects sensitive data in screenshots

### 14. **Zero Internet, Zero Analytics, Zero Cloud**
- ✅ **NO INTERNET PERMISSION** in manifest
- ✅ Cannot connect to internet (enforced by OS)
- ✅ No analytics or tracking
- ✅ No telemetry
- ✅ No crash reporting
- ✅ No cloud sync
- ✅ 100% local-only storage
- ✅ Complete privacy and security

### 15. **Custom Cybersecurity Themes**
10 professional themes inspired by security tools:

1. **Kali Purple** - Inspired by Kali Linux Purple
2. **Parrot OS** - Parrot Security OS aesthetic
3. **Black Hat** - Pure black terminal theme
4. **Matrix** - The Matrix green theme
5. **Cyberpunk** - Neon cyberpunk colors
6. **Red Team** - Offensive security red theme
7. **Blue Team** - Defensive security blue theme
8. **Dracula** - Popular Dracula theme
9. **Nord** - Arctic nord theme
10. **Hacker Green** - Classic terminal green

All themes feature:
- Monospace fonts for terminal aesthetic
- Command-line style UI elements
- High contrast for readability
- Professional cybersecurity look

## 🛡️ Security Architecture

### Encryption Flow
```
User Input → Master Password → SHA-256 → 256-bit Key
                                              ↓
Plain Data → AES-256-GCM Encryption → Random IV + Encrypted Data
                                              ↓
                                    Base64 Encode → Store in Hive
```

### Data Storage
- All vault items stored in encrypted Hive boxes
- Master password hash stored separately
- Settings stored in non-encrypted box (no sensitive data)
- Failed attempts counter persists across app restarts

### Authentication Flow
1. User enters master password
2. Password hashed with SHA-256
3. Hash compared with stored hash
4. If match: Vault decrypted and opened
5. If no match: Failed attempts incremented
6. After 10 failed attempts: Self-destruct triggered

## 📊 File Size Limits
- **Individual files**: Up to 10 MB
- **Total vault size**: Limited only by device storage
- **QR transfer**: Automatic chunking for large transfers
- **.scvault export**: Compressed with gzip (typically 50% reduction)

## 🔐 Password Requirements
- Minimum 6 characters (recommended 12+)
- Numeric passcode supported
- Alphanumeric passwords supported
- No password recovery (by design)
- Lost password = Lost data (no backdoors)

## ⚠️ Important Security Notes

### Data Loss Scenarios
Your data will be **permanently deleted** in these cases:
1. 10 failed password attempts
2. Panic button activation (volume-down 5 seconds)
3. Manual vault wipe in settings

### No Recovery
- There is NO password recovery
- There are NO backdoors
- Data cannot be recovered if lost
- Make regular exports to `.scvault` files
- Store exports in secure locations

### Threat Model
This app protects against:
- ✅ Device theft
- ✅ Unauthorized access
- ✅ Shoulder surfing (screenshot protection)
- ✅ Brute force attacks (10 attempt limit)
- ✅ Emergency seizure (panic button)
- ✅ Network sniffing (no internet)
- ✅ Cloud breaches (no cloud storage)

This app does NOT protect against:
- ❌ Advanced malware with root/jailbreak access
- ❌ Physical device tampering by experts
- ❌ Side-channel attacks
- ❌ Quantum computing (future threat)

## 🚀 Best Practices

### For Maximum Security:
1. Use a strong master password (12+ characters)
2. Enable biometric authentication
3. Set auto-lock to 1-2 minutes
4. Enable screenshot protection
5. Regular exports to `.scvault` files
6. Store exports in separate secure location
7. Practice using panic button
8. Use tags and folders for organization
9. Leverage templates for consistent documentation
10. Never share master password

### For Pentesting Workflow:
1. Create dedicated folders for each engagement
2. Use tags: #oscp, #htb, #webapp, #network, etc.
3. Start from templates for faster documentation
4. Store screenshots as encrypted files
5. Save commands as scripts for reuse
6. Export vault after each engagement
7. Use QR transfer for air-gapped labs

## 📱 Platform Support
- ✅ Android 5.0+ (API 21+)
- ✅ iOS 12.0+
- ✅ No internet required
- ✅ Works completely offline
- ✅ No Google Play Services required

## 🔧 Technical Stack
- **Framework**: Flutter 3.9+
- **Database**: Hive (encrypted boxes)
- **Encryption**: encrypt package (AES-256-GCM)
- **Biometrics**: local_auth
- **QR Codes**: qr_flutter, mobile_scanner
- **Markdown**: flutter_markdown, flutter_highlight
- **Compression**: archive (gzip)
- **Zero internet dependencies**

## 📄 License
Private project - All rights reserved

## ⚠️ Disclaimer
This is a security tool. Users are responsible for:
- Remembering their master password
- Making regular backups
- Understanding the self-destruct features
- Using the panic button responsibly
- Complying with local laws and regulations

The developers are not responsible for lost data due to forgotten passwords, failed attempts triggering self-destruct, or panic button activation.

---

**Remember: With great security comes great responsibility. This app has NO backdoors and NO recovery options by design. Lost password = Lost data.**
