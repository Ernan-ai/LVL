# LVL - Build & Installation Guide

## 🛠️ Prerequisites

### Required Software
1. **Flutter SDK** (3.9.2 or higher)
   ```bash
   flutter --version
   ```

2. **Dart SDK** (comes with Flutter)

3. **Android Studio** (for Android builds)
   - Android SDK
   - Android NDK
   - Gradle

4. **Xcode** (for iOS builds - macOS only)
   - Command Line Tools
   - CocoaPods

### System Requirements
- **For Android Development**: Windows, macOS, or Linux
- **For iOS Development**: macOS only
- **RAM**: 8GB minimum, 16GB recommended
- **Storage**: 10GB free space minimum

## 📦 Installation Steps

### 1. Clone/Extract Project
```bash
cd d:\Encryp\encryp_app
```

### 2. Install Flutter Dependencies
```bash
flutter pub get
```

This will install all required packages including:
- Hive & hive_flutter (encrypted database)
- encrypt (AES-256-GCM encryption)
- local_auth (biometric authentication)
- qr_flutter & mobile_scanner (QR code features)
- flutter_markdown & flutter_highlight (markdown editor)
- And more...

### 3. Generate Hive Type Adapters
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates the `vault_item.g.dart` file for Hive database.

### 4. Verify Installation
```bash
flutter doctor -v
```

Make sure all checks pass (or at least Android/iOS toolchain).

## 🏗️ Building the App

### ⭐ Recommended: GitHub Actions (Automated)

**The easiest way to build is using the GitHub Actions workflow!**

#### Step 1: Push to GitHub
```bash
git add .
git commit -m "Ready to build"
git push origin main
```

#### Step 2: Workflow Runs Automatically
The workflow (`.github/workflows/build-ios.yml`) automatically:
- ✅ Builds Android APK
- ✅ Builds iOS IPA (no codesign, ready for Sideloadly)
- ✅ Uploads artifacts for 30 days
- ✅ Uses Flutter 3.35.7 stable

#### Step 3: Download Built Files
1. Go to your GitHub repo → **Actions** tab
2. Click on the latest workflow run
3. Download artifacts:
   - `LVL_Encryp.apk (Android)` - Ready to install
   - `LVL_Encryp.ipa (Ready for Sideloadly)` - For iOS sideloading
   - `Runner.app (iOS Build)` - Raw iOS app

#### Manual Trigger
You can also manually trigger builds:
1. Go to GitHub repo → **Actions** tab
2. Select "Build iOS & Android" workflow
3. Click "Run workflow" → "Run workflow"

### Alternative: Manual Local Build

If you prefer to build locally:

#### For Android

**Release Build (APK)**
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

**Install on Connected Device**
```bash
flutter install
# Or manually:
adb install build/app/outputs/flutter-apk/app-release.apk
```

#### For iOS

**Release Build (no codesign)**
```bash
flutter build ios --release --no-codesign
```

**Create IPA manually**
```bash
mkdir Payload
cp -r build/ios/iphoneos/Runner.app Payload/
zip -r LVL_Encryp.ipa Payload
rm -rf Payload
```

The IPA is now ready for Sideloadly!

**Note**: For App Store distribution, you need Xcode + Apple Developer account ($99/year).

## 🔐 Android App Signing

For release builds on Android, you need to sign the APK.

### Generate Keystore (First Time Only)
```bash
keytool -genkey -v -keystore encryp-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias encryp
```

**Store this keystore safely! You'll need it for all future updates.**

### Configure Signing

1. Create `android/key.properties`:
```properties
storePassword=your_keystore_password
keyPassword=your_key_password
keyAlias=encryp
storeFile=../encryp-release-key.jks
```

2. Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

Now `flutter build apk --release` will create a signed APK.

## 🚀 Running the App

### Run on Emulator/Simulator
```bash
# Android
flutter run

# iOS
flutter run
```

### Run on Physical Device
1. Enable USB Debugging (Android) or Trust Computer (iOS)
2. Connect device via USB
3. Run:
```bash
flutter run --release
```

### Hot Reload During Development
When app is running:
- Press `r` to hot reload
- Press `R` to hot restart
- Press `q` to quit

## 📱 Sideloading (iOS)

For iOS without App Store:

### Using Sideloadly
See `SIDELOADLY_GUIDE.md` for detailed instructions.

### Using AltStore
1. Install AltStore on iOS device
2. Build IPA in Xcode
3. Install via AltStore

### Using Xcode (Free)
1. Connect iPhone
2. Open `ios/Runner.xcworkspace`
3. Select your device
4. Change bundle identifier to something unique
5. Select your Apple ID team
6. Click Run (▶️)

Free accounts have 7-day expiry; you'll need to re-install weekly.

## 🐛 Troubleshooting

### Common Issues

#### "Hive type adapters not found"
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### "CocoaPods not installed" (iOS)
```bash
sudo gem install cocoapods
cd ios
pod install
```

#### "Gradle build failed" (Android)
1. Update Android SDK in Android Studio
2. Clean build:
```bash
flutter clean
flutter pub get
flutter build apk
```

#### "Certificate not trusted" (iOS)
Settings → General → VPN & Device Management → Trust Developer

#### "App won't install on device"
- Check device has enough storage
- Uninstall previous version first
- Enable "Install from Unknown Sources" (Android)
- Trust developer certificate (iOS)

### Flutter Doctor Issues
```bash
flutter doctor -v
```

Fix any issues reported (usually SDK paths or licenses).

### Cache Issues
```bash
flutter clean
flutter pub get
rm -rf ios/Pods ios/Podfile.lock
cd ios && pod install && cd ..
```

## 📊 Build Sizes

Typical build sizes:
- **Android APK**: 15-25 MB
- **Android App Bundle**: 12-20 MB
- **iOS IPA**: 20-35 MB

Release builds are smaller than debug builds.

## 🔧 Development Mode

### Enable Debug Features
Edit `lib/main.dart`:
```dart
const bool debugMode = true; // Set to false for release
```

Debug mode shows:
- Detailed error messages
- Encryption/decryption logs
- Performance metrics
- Test data generators

**Always set to `false` for production builds!**

### Run Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

## 🌐 Localization (Future)

Currently English only. To add languages:
1. Add `flutter_localizations` dependency
2. Create `l10n/` folder with ARB files
3. Generate translations
4. Update MaterialApp with localization delegates

## 📦 Dependencies Update

Keep dependencies updated:
```bash
flutter pub outdated
flutter pub upgrade
```

**Test thoroughly after updating!**

## ⚡ Performance Optimization

### Release Build Optimizations
Already configured:
- Code shrinking (Android)
- Obfuscation
- Tree shaking
- AOT compilation

### Additional Optimizations
```bash
# Android: split APKs by ABI (smaller downloads)
flutter build apk --split-per-abi

# iOS: bitcode enabled (default)
```

## 📱 Device Testing Checklist

Before release, test on:
- [ ] Android 5.0 (minimum supported)
- [ ] Android 10+ (modern devices)
- [ ] iOS 12.0 (minimum supported)
- [ ] iOS 16+ (modern devices)
- [ ] Different screen sizes
- [ ] Different screen densities
- [ ] Low-end devices (performance)
- [ ] High-end devices (features)

## 🔒 Security Checklist Before Release

- [ ] Screenshot protection working (Android)
- [ ] Biometric auth working (both platforms)
- [ ] Auto-lock timer functional
- [ ] Self-destruct on 10 attempts working
- [ ] Panic button working (volume-down 5s)
- [ ] No internet permission in manifest
- [ ] All data encrypted at rest
- [ ] Master password verification correct
- [ ] Export/import .scvault working
- [ ] QR transfer working
- [ ] All themes rendering correctly

## 📋 Release Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Update version codes in native files
- [ ] Run all tests
- [ ] Test on physical devices
- [ ] Create release notes
- [ ] Build signed release
- [ ] Test signed build on devices
- [ ] Create backups of signing keys
- [ ] Tag release in git
- [ ] Create GitHub release (if applicable)

## 💾 Backup Important Files

Always backup:
- `encryp-release-key.jks` (Android signing key)
- `key.properties` (Android signing config)
- Apple Developer certificates (iOS)
- Provisioning profiles (iOS)

**Losing signing keys means you can't update your app!**

## 🆘 Getting Help

### Resources
- Flutter Docs: https://flutter.dev/docs
- Hive Docs: https://docs.hivedb.dev
- Stack Overflow: Tag `flutter`

### Common Commands Reference
```bash
# Check Flutter version
flutter --version

# List connected devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Build release APK
flutter build apk --release

# Install on device
flutter install

# Clean build
flutter clean

# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format .
```

## 🎉 Successful Build!

Once built successfully:
1. Test all features thoroughly
2. Test on multiple devices
3. Verify security features work
4. Create backups
5. Distribute to users

---

**Happy Building! 🚀**
