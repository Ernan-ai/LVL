# LVL - Secure Cybersecurity Vault

**Military-grade encrypted vault for cybersecurity professionals, penetration testers, and security researchers.**

## What is LVL?

LVL is a **zero-internet, zero-cloud, zero-analytics** encrypted vault app designed specifically for cybersecurity professionals who need:

- Military-grade encryption (AES-256-GCM)
- Complete offline operation (no internet permission)
- Organized storage for notes, passwords, scripts, and files
- 15+ pentesting templates (OSCP, HTB, Burp, Nmap, etc.)
- Self-destruct security (10 wrong attempts)
- Panic button (volume-down 5 seconds)
- Screenshot protection (Android)
- QR code transfer (air-gapped environments)

## Key Features

### Security First
- AES-256-GCM encryption - Military-grade, industry-standard
- Master password + biometric - Face ID / Fingerprint support
- Encrypted Hive database - All data encrypted at rest
- Auto-lock timer - 1-5 minutes configurable
- Screenshot protection - FLAG_SECURE on Android
- Self-destruct - Wipes data after 10 wrong attempts
- Panic button - Hold volume-down 5 seconds to instantly wipe
- Zero internet - No internet permission in manifest
- No analytics - Zero tracking, zero telemetry

### Comprehensive Storage
- Notes - Markdown with syntax highlighting
- Passwords - Credentials with URLs and notes
- Tokens/Keys - API keys, SSH keys, auth tokens
- Scripts - Code snippets (bash, python, sql, js, etc.)
- Files - Encrypted files up to 10MB each

### 15+ Built-in Templates
Perfect for pentesting and security work:
- OSCP Lab Notes, HackTheBox Machine, TryHackMe Room
- Burp Suite Session, Nmap Scan Results, Metasploit Session
- SQL Injection Tests, XSS Payloads, Reverse Shell Cheatsheet
- Linux/Windows Privilege Escalation, Web App Reconnaissance
- API Security Testing, Wireless Network Audit
- Incident Response Log, Penetration Test Report

### Organization & Search
- Tags - Organize with hashtags (#webapp #oscp #htb)
- Folders - Hierarchical folder structure
- Fast search - Search titles and tags (content stays encrypted)
- Favorites - Quick access to important items
- Filters - By type, folder, tag, date

### Export & Transfer
- Export vault - Single encrypted .scvault file
- Import vault - Restore from .scvault backup
- QR code transfer - Device-to-device (no internet needed)
- Compressed - Gzip compression for smaller files

### 10 Cybersecurity Themes
Professional themes: Kali Purple, Parrot OS, Black Hat, Matrix, Cyberpunk, Red Team, Blue Team, Dracula, Nord, Hacker Green

## Quick Start

### Installation
```bash
cd d:\Encryp\encryp_app
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### First Launch
1. Enter username (one-time setup)
2. Create master password - REMEMBER THIS!
3. Enable biometric auth (optional)
4. Start creating encrypted items

## Documentation

- QUICKSTART.md - Get started in 5 minutes
- SECURITY_FEATURES.md - Complete security overview
- BUILD_GUIDE.md - Build and deployment guide
- SIDELOADLY_GUIDE.md - iOS sideloading instructions

## Security Architecture

```
User Input -> Master Password -> SHA-256 -> 256-bit Key
                                              |
Plain Data -> AES-256-GCM Encryption -> Random IV + Encrypted Data
                                              |
                                    Base64 Encode -> Store in Hive
```

## Important Security Notes

### NO PASSWORD RECOVERY
- Lost password = Lost data
- This is by design for maximum security
- No backdoors, no recovery options
- Make regular exports to .scvault files

### Self-Destruct Scenarios
Your data will be permanently wiped if:
1. 10 failed password attempts
2. Panic button activated (volume-down 5 seconds)
3. Manual vault wipe in settings

## Technical Stack

- Framework: Flutter 3.9.2+
- Language: Dart
- Database: Hive (encrypted boxes)
- Encryption: AES-256-GCM via encrypt package
- Biometrics: local_auth
- QR Codes: qr_flutter, mobile_scanner
- Markdown: flutter_markdown, flutter_highlight
- Platform: Android 5.0+, iOS 12.0+

## Privacy Commitment

ZERO INTERNET PERMISSION
- Cannot connect to internet (enforced by OS)
- No analytics, tracking, telemetry, crash reporting, cloud sync, or ads
- 100% local storage - Your data never leaves your device

## License

Private project - All rights reserved

## Disclaimer

Users are responsible for remembering passwords, making backups, and understanding self-destruct features.

**NO PASSWORD RECOVERY. NO BACKDOORS. NO COMPROMISES.**
