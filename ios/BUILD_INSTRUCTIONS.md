# iOS Build Instructions

## Prerequisites
- macOS computer
- Xcode installed (from App Store)
- CocoaPods installed (`sudo gem install cocoapods`)

## Steps to Build on Mac

### 1. Transfer Project
Copy the entire `encryp_app` folder to your Mac.

### 2. Install Dependencies
```bash
cd encryp_app
flutter pub get
cd ios
pod install
```

### 3. Open in Xcode
```bash
open Runner.xcworkspace
```
**Important:** Open `Runner.xcworkspace`, NOT `Runner.xcodeproj`

### 4. Configure Signing
In Xcode:
- Select the "Runner" project in the left sidebar
- Go to "Signing & Capabilities" tab
- Select your Team (requires Apple Developer account)
- Xcode will automatically manage signing

### 5. Build for Device
Option A - Using Flutter:
```bash
cd ..  # Back to encryp_app folder
flutter build ipa
```
The IPA file will be at: `build/ios/ipa/encryp_app.ipa`

Option B - Using Xcode:
- Select your device or "Any iOS Device" at the top
- Menu: Product → Archive
- Once archived, click "Distribute App"
- Choose distribution method (App Store, Ad Hoc, etc.)

## For App Store Release

1. Create app in App Store Connect (https://appstoreconnect.apple.com)
2. Set bundle identifier in Xcode to match (e.g., com.yourname.encryp)
3. Archive and upload through Xcode
4. Submit for review

## For Testing (No App Store)

### TestFlight:
- Archive in Xcode
- Upload to App Store Connect
- Invite testers via email

### Ad Hoc Distribution:
- Register device UDIDs in Apple Developer portal
- Create Ad Hoc provisioning profile
- Build with that profile
- Share IPA file via email/link

## Quick Test Build
For quick testing on a connected iPhone:
```bash
flutter run
```

## Troubleshooting

**"No valid identities found":**
- Add Apple ID in Xcode → Preferences → Accounts
- Select team in Signing settings

**"CocoaPods not installed":**
```bash
sudo gem install cocoapods
```

**Build fails:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

## Notes
- First build may take 5-10 minutes
- Keep your Mac on the same Flutter version (3.35.7)
- App requires iOS 12.0 or later
