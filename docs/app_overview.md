# LVL (Encryp App) – Technical Overview

## 1. Purpose & Overview

- **Goal**  
  LVL is a local, offline-focused utility for:
  - Encrypting arbitrary text with a user-defined numeric passcode.
  - Decrypting previously encrypted text.
  - Saving encrypted credentials locally (title + encrypted password).
  - Tracking usage statistics (operations count, data volume).
  - Managing a local "friends" list for a demo chat feature (no real backend).
  - Personalizing the experience with username and profile picture.

- **Platform & Tech Stack**  
  - Framework: **Flutter** (Material design, dark theme, Material 3).
  - Storage: **SharedPreferences** (via `shared_preferences` package).
  - Media / Files: **image_picker**, **path_provider**, `dart:io`.
  - Encryption: Custom algorithm in pure Dart (`EncryptionService`).

---

## 2. High-Level Flow

1. **Splash & Onboarding**
   - App starts at `SplashScreen` (`home: SplashScreen()` in `EncrypApp`).
   - Animated typewriter logo `> LVL`.
   - Checks if a username is stored:
     - If yes: shows a typewritten welcome message and then navigates to `PasscodeScreen`.
     - If no: shows a `> Hello ` typewriter line and an input field to capture username; saves to `StorageService` then proceeds.

2. **Passcode & Home**
   - `PasscodeScreen` collects a numeric master passcode.
   - On success, user is navigated to `HomePage(passcode: ...)`.

3. **Main Navigation (HomePage)**
   - `HomePage` is a `Scaffold` with:
     - `AppBar` with title `> LVL` and a settings button.
     - `PageView` controlled by `PageController` for 5 tabs:
       - `EncryptTab`
       - `DecryptTab`
       - `HomeScreen`
       - `SavedCredentialsTab`
       - `FriendsScreen`
     - `BottomNavigationBar` to switch between tabs.

---

## 3. Core Features & Screens

### 3.1 EncryptTab

- **Inputs**
  - Free text to encrypt (`_inputController`).
  - Optional title for saving encrypted text as a credential (`_titleController`).

- **Encryption Flow**
  - `EncryptionService.encrypt(inputText, passcode)`:
    - Custom shift cipher using digits of the passcode.
    - Base64 encoding.
    - ROT13 on the Base64 string.
  - Updates usage stats:
    - `StorageService.incrementEncryptCount()`
    - `StorageService.addEncryptedBytes(inputText.length)`
  - Displays encrypted result in a styled container.
  - Copy to clipboard using `Clipboard.setData`.

- **Saving Credentials**
  - Validates that title and encrypted text are non-empty.
  - Loads existing credentials: `StorageService.loadCredentials()`.
  - Appends a map: `{ 'title': title, 'username': '', 'password': encrypted }`.
  - Saves with `StorageService.saveCredentials`.
  - Clears fields and shows a `> SAVED` snackbar.

---

### 3.2 DecryptTab

- **Input**
  - Encrypted string pasted by the user (`_inputController`).

- **Decryption Flow**
  - `EncryptionService.decrypt(encryptedText, passcode)`:
    - Reverse ROT13.
    - Base64 decode.
    - Reverse custom shift cipher using the same passcode digits.
  - Updates stats:
    - `StorageService.incrementDecryptCount()`
    - `StorageService.addDecryptedBytes(decrypted.length)`
  - Displays decrypted result with option to copy to clipboard.

---

### 3.3 SavedCredentialsTab

- **Data**
  - Loads list of credentials from `StorageService.loadCredentials()`:
    - Stored as serialized strings, converted back to `List<Map<String, String>>`.

- **UI Behavior**
  - Shows a loading spinner while fetching.
  - If empty:
    - Shows logo / lock icon and messages like `> NO SAVED CREDENTIALS`.
  - If not empty:
    - Renders a `ListView` of `Card` / `ListTile` items:
      - Leading initial (first letter of the title).
      - Title: `> TITLE`.
      - Subtitle: encrypted password (one line, ellipsis).
      - Actions:
        - **Copy encrypted** password.
        - **View decrypted** password:
          - Uses `EncryptionService.decrypt(encryptedPassword, passcode)`.
          - Shows an `AlertDialog` with decrypted text and `> COPY` button.
        - **Delete credential**:
          - Removes from local list and `StorageService.saveCredentials`.
          - Snackbar `> CREDENTIAL DELETED`.

---

### 3.4 HomeScreen (Dashboard)

- **Data Sources**
  - `_stats` from `StorageService.getStatistics()`:
    - `encryptCount`, `decryptCount`, `encryptedBytes`, `decryptedBytes`.
  - User profile from `StorageService.getUsername()` and `getProfilePicture()`.

- **UI**
  - **Welcome Card**
    - Profile picture:
      - If path saved, uses `FileImage`.
      - Else fallback to logo image or user’s initial.
    - Text: `> Welcome back,` and username.
  - **Statistics**
    - Cards for:
      - Number of encryption operations.
      - Number of decryption operations.
    - Data volume card:
      - “Encrypted” and “Decrypted” with human-readable byte formatting (`_formatBytes`).
    - Total operations card:
      - Encrypt + decrypt counts.

- **Refresh**
  - Wrapped in `RefreshIndicator` to re-fetch current stats, username, and profile picture.

---

### 3.5 FriendsScreen

- **Friends Data**
  - List of friend usernames stored via `StorageService.saveFriends` / `loadFriends`.
  - Local only; dialog explains it’s a demo (real chat would require backend).

- **Features**
  - Add friend:
    - Dialog with username input.
    - Saves via `StorageService.addFriend`.
  - Remove friend:
    - Calls `StorageService.removeFriend`.
  - Open chat:
    - Navigates to `ChatScreen(friendUsername: friend)` for demo conversation.
  - Empty state:
    - Shows `> NO FRIENDS YET` and button `> ADD FRIEND`.

---

### 3.6 SettingsScreen

- **User Profile**
  - Shows username (from `StorageService.getUsername`).
  - Profile picture:
    - Tap to open gallery (`image_picker`).
    - Selected image is copied into app documents directory (`path_provider` + `File.copy`).
    - File path stored via `StorageService.saveProfilePicture`.

- **Security**
  - `> CHANGE PASSCODE` action:
    - Opens dialog with fields:
      - Current passcode.
      - New passcode.
      - Confirm new passcode.
    - Uses `PasscodeService` to validate and update stored passcode.

- **About**
  - Card with app info:
    - Version: `LVL v1.0.0`.
    - Description: `Secure password encryption using custom algorithms`.

- **Animations**
  - Multiple `FadeTransition` sections for smooth appearance of profile, security, and about cards.

---

## 4. Encryption & Storage Details

### 4.1 EncryptionService

- **Algorithm Steps (Encrypt)**
  - Input: `plainText`, numeric `passcode` (string of digits).
  - If either is empty ⇒ returns empty string.
  - `_applyCustomShift(plainText, passcode, reverse: false)`:
    - Converts passcode to `List<int>` of digits.
    - For each character:
      - If `A–Z` or `a–z`, shifts by corresponding passcode digit.
      - Wrap-around within alphabet (mod 26).
      - Non-letters stay unchanged.
    - Passcode pattern repeats across the whole text.
  - Base64 encode shifted text.
  - Apply ROT13 to the Base64 string.
  - Return final encrypted string.

- **Decryption**
  - Reverse ROT13, Base64 decode, then `_applyCustomShift(..., reverse: true)`.

- **Error Handling**
  - If Base64 decode fails or anything throws:
    - Returns `"Error: Invalid encrypted text or wrong passcode"`.

### 4.2 StorageService

- **Credential Management**
  - Keys:
    - `_credentialsKey`, `_usernameKey`, `_profilePictureKey`,
    - `_friendsKey`, `_encryptCountKey`, `_decryptCountKey`,
    - `_encryptedBytesKey`, `_decryptedBytesKey`.
  - Credentials stored as string list:
    - Each: `"title|||username|||password"`.
  - Helpers:
    - `saveCredentials`, `loadCredentials`, `clearCredentials`.

- **User Profile**
  - `saveUsername`, `getUsername`, `hasUsername`.
  - `saveProfilePicture`, `getProfilePicture`.

- **Friends**
  - `saveFriends`, `loadFriends`, `addFriend`, `removeFriend`.

- **Statistics**
  - `incrementEncryptCount`, `incrementDecryptCount`.
  - `addEncryptedBytes`, `addDecryptedBytes`.
  - `getStatistics` returns a map with all four metrics.

---

## 5. UI & Theme

- **Theme**
  - Global `ColorScheme.dark` with:
    - Surface/background: black.
    - Accent: `kAccentColor (0xFF00D9FF)`.
    - Text: `kSoftWhite (0xFFE0E0E0)`.
  - Monospace font across app (`fontFamily: 'monospace'`).
  - AppBar, cards, text fields, buttons all styled to match a terminal / hacker aesthetic.

- **Navigation**
  - `MaterialApp` without debug banner.
  - Manual navigation via `Navigator.push` / `pushReplacement` for screens like `SettingsScreen`, `PasscodeScreen`, `ChatScreen`.

---

## 6. How to Use (User Perspective)

- **First launch**
  - See animated logo.
  - Enter your name.
  - Set a master passcode (via `PasscodeScreen`).
- **Encrypt**
  - Go to ENCRYPT tab.
  - Type text, tap `> ENCRYPT`.
  - Optionally give a title and tap `> SAVE` to store credentials.
- **Decrypt**
  - Go to DECRYPT tab.
  - Paste encrypted string, tap `> DECRYPT`.
- **Saved**
  - See list of saved credentials, copy or view/decrypt them.
- **Home**
  - View your profile and encryption/decryption statistics.
- **Friends**
  - Add local friend usernames and open chat demo.
- **Settings**
  - Change profile picture.
  - Change master passcode.
  - View app version & about info.
