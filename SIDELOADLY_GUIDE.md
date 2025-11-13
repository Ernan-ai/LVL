# Install LVL Encryp on iPhone (No Jailbreak, Free Apple ID)

## What You Need
- iPhone running iOS 12.0 or later
- Windows/Mac computer
- Lightning/USB-C cable
- Free Apple ID
- **Sideloadly** (free software)

## Step 1: Download Sideloadly
1. Go to: https://sideloadly.io
2. Download for Windows or Mac
3. Install and open Sideloadly

## Step 2: Get the IPA File

### Option A: Download from GitHub Actions
1. Go to: https://github.com/Ernan-ai/LVL/actions
2. Click on the latest successful build
3. Download "LVL-Encryp-iOS" artifact
4. Extract the ZIP to get `LVL_Encryp.ipa`

### Option B: Build yourself on Mac
```bash
cd encryp_app
flutter build ios --release --no-codesign
mkdir Payload
cp -r build/ios/iphoneos/Runner.app Payload/
zip -r LVL_Encryp.ipa Payload
```

## Step 3: Install with Sideloadly

### First Time Setup:
1. Connect your iPhone via USB cable
2. Trust computer on iPhone when prompted
3. Open Sideloadly

### Installation:
1. **Drag** `LVL_Encryp.ipa` into Sideloadly window
2. **Device**: Your iPhone should be automatically detected
3. **Apple Account**: Enter your Apple ID email
   - Use a free Apple ID (no paid developer account needed)
   - You can create one at: https://appleid.apple.com
4. **Password**: Enter your Apple ID password
   - Sideloadly stores it locally, never sent online
5. Click **"Start"** button
6. Wait for the signing and installation process (1-2 minutes)

### On Your iPhone:
1. Go to **Settings** → **General** → **VPN & Device Management**
2. Find your Apple ID under "Developer App"
3. Tap it and tap **"Trust [Your Apple ID]"**
4. Go to home screen
5. **Launch LVL Encryp!** 🎉

## Important Notes ⚠️

### App Expires After 7 Days
- Free Apple IDs: Apps expire after 7 days
- You need to re-sign/re-install every week
- Your data is not deleted, just can't launch the app
- Solution: Use Sideloadly's "Refresh" feature

### Alternative: Paid Apple Developer ($99/year)
- Apps last 1 year before re-signing
- Can distribute to more devices
- Can use TestFlight

## Troubleshooting 🔧

### "Unable to verify app"
- Go to Settings → General → VPN & Device Management
- Trust your Apple ID

### "App keeps crashing"
- Make sure you trusted the developer profile
- Restart your iPhone
- Re-install the app

### "This Apple ID has reached the maximum number of free apps"
- Free Apple IDs limited to 3 apps per device
- Delete old sideloaded apps or use another Apple ID
- Or use a different device

### "Provisioning profile not found"
- Revoke all certificates in Sideloadly settings
- Try again with a fresh install

### Two-Factor Authentication (2FA)
- Use app-specific password instead of your regular password
- Generate at: https://appleid.apple.com → Security → App-Specific Passwords

## Auto-Refresh (Windows Only)

Sideloadly can auto-refresh apps before they expire:
1. Keep Sideloadly running in background
2. Enable "Auto-refresh" in settings
3. Connect iPhone to PC overnight once a week
4. Sideloadly will automatically re-sign

## Alternatives to Sideloadly

### AltStore
- Similar to Sideloadly
- Free and open source
- Download: https://altstore.io

### iOS App Signer (Mac only)
- Manual signing tool
- More control over process
- Download: https://dantheman827.github.io/ios-app-signer/

### Xcode (Mac only)
- Apple's official tool
- Most reliable but requires Mac
- Free with Apple ID

## Need Help?

- Sideloadly Discord: https://discord.gg/sideloadly
- GitHub Issues: https://github.com/Ernan-ai/LVL/issues
- r/sideloaded on Reddit

---

**Enjoy your encrypted passwords on iPhone! 🔐📱**
