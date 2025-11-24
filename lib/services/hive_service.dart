import 'dart:convert';
import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import '../models/vault_item.dart';
import 'aes_encryption_service.dart';

/// Service for managing Hive encrypted database
class HiveService {
  static const String _vaultBoxName = 'secure_vault';
  static const String _settingsBoxName = 'app_settings';
  static const String _passwordTestKey = 'password_test';
  static const String _failedAttemptsKey = 'failed_attempts';
  static const String _masterPasswordHashKey = 'master_password_hash';
  static const String _autoLockTimeKey = 'auto_lock_time';
  static const String _themeModeKey = 'theme_mode';

  static Box<VaultItem>? _vaultBox;
  static Box? _settingsBox;

  /// Initializes Hive and registers adapters
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register type adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(VaultItemAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(VaultItemTypeAdapter());
    }
  }

  /// Opens encrypted vault box with master password
  static Future<bool> openVault(String masterPassword) async {
    try {
      // Verify password if this is not first time
      if (await hasMasterPassword()) {
        if (!await verifyMasterPassword(masterPassword)) {
          await incrementFailedAttempts();
          return false;
        }
        await resetFailedAttempts();
      } else {
        // First time setup - save password hash
        await setMasterPassword(masterPassword);
      }

      // Generate encryption key from password
      final encryptionKey = _generateEncryptionKey(masterPassword);

      // Open encrypted vault box
      _vaultBox = await Hive.openBox<VaultItem>(
        _vaultBoxName,
        encryptionCipher: HiveAesCipher(encryptionKey),
      );

      // Open settings box (not encrypted)
      _settingsBox = await Hive.openBox(_settingsBoxName);

      return true;
    } catch (e) {
      print('Error opening vault: $e');
      return false;
    }
  }

  /// Generates 256-bit encryption key from master password
  static List<int> _generateEncryptionKey(String masterPassword) {
    final bytes = utf8.encode(masterPassword);
    final hash = sha256.convert(bytes);
    return hash.bytes;
  }

  /// Closes all boxes
  static Future<void> closeVault() async {
    await _vaultBox?.close();
    _vaultBox = null;
  }

  /// Checks if vault is unlocked
  static bool isVaultOpen() {
    return _vaultBox != null && _vaultBox!.isOpen;
  }

  /// Saves master password hash for verification
  static Future<void> setMasterPassword(String masterPassword) async {
    final settingsBox = await Hive.openBox(_settingsBoxName);
    final hash = sha256.convert(utf8.encode(masterPassword)).toString();
    await settingsBox.put(_masterPasswordHashKey, hash);
  }

  /// Verifies if master password is correct
  static Future<bool> verifyMasterPassword(String masterPassword) async {
    final settingsBox = await Hive.openBox(_settingsBoxName);
    final storedHash = settingsBox.get(_masterPasswordHashKey);
    if (storedHash == null) return false;
    
    final inputHash = sha256.convert(utf8.encode(masterPassword)).toString();
    return storedHash == inputHash;
  }

  /// Checks if master password exists
  static Future<bool> hasMasterPassword() async {
    final settingsBox = await Hive.openBox(_settingsBoxName);
    return settingsBox.containsKey(_masterPasswordHashKey);
  }

  /// Gets failed login attempts count
  static Future<int> getFailedAttempts() async {
    final settingsBox = await Hive.openBox(_settingsBoxName);
    return settingsBox.get(_failedAttemptsKey, defaultValue: 0);
  }

  /// Increments failed attempts counter
  static Future<void> incrementFailedAttempts() async {
    final settingsBox = await Hive.openBox(_settingsBoxName);
    final current = await getFailedAttempts();
    await settingsBox.put(_failedAttemptsKey, current + 1);
  }

  /// Resets failed attempts counter
  static Future<void> resetFailedAttempts() async {
    final settingsBox = await Hive.openBox(_settingsBoxName);
    await settingsBox.put(_failedAttemptsKey, 0);
  }

  /// Self-destructs all data (called after 10 wrong attempts)
  static Future<void> selfDestruct() async {
    try {
      // Close boxes first
      await closeVault();
      
      // Delete all Hive boxes
      await Hive.deleteBoxFromDisk(_vaultBoxName);
      await Hive.deleteBoxFromDisk(_settingsBoxName);
      
      // Delete all Hive data
      await Hive.deleteFromDisk();
      
      print('All data has been wiped');
    } catch (e) {
      print('Error during self-destruct: $e');
    }
  }

  // ============ VAULT ITEM OPERATIONS ============

  /// Adds a new vault item
  static Future<void> addItem(VaultItem item) async {
    if (!isVaultOpen()) throw Exception('Vault is not open');
    await _vaultBox!.put(item.id, item);
  }

  /// Updates an existing vault item
  static Future<void> updateItem(VaultItem item) async {
    if (!isVaultOpen()) throw Exception('Vault is not open');
    item.modifiedAt = DateTime.now();
    await _vaultBox!.put(item.id, item);
  }

  /// Deletes a vault item
  static Future<void> deleteItem(String id) async {
    if (!isVaultOpen()) throw Exception('Vault is not open');
    await _vaultBox!.delete(id);
  }

  /// Gets a vault item by ID
  static VaultItem? getItem(String id) {
    if (!isVaultOpen()) throw Exception('Vault is not open');
    return _vaultBox!.get(id);
  }

  /// Gets all vault items
  static List<VaultItem> getAllItems() {
    if (!isVaultOpen()) throw Exception('Vault is not open');
    return _vaultBox!.values.toList();
  }

  /// Gets items by type
  static List<VaultItem> getItemsByType(VaultItemType type) {
    if (!isVaultOpen()) throw Exception('Vault is not open');
    return _vaultBox!.values.where((item) => item.type == type).toList();
  }

  /// Gets items by folder
  static List<VaultItem> getItemsByFolder(String folder) {
    if (!isVaultOpen()) throw Exception('Vault is not open');
    return _vaultBox!.values.where((item) => item.folder == folder).toList();
  }

  /// Gets items by tag
  static List<VaultItem> getItemsByTag(String tag) {
    if (!isVaultOpen()) throw Exception('Vault is not open');
    return _vaultBox!.values.where((item) => item.tags.contains(tag)).toList();
  }

  /// Searches items by title or tags (content stays encrypted)
  static List<VaultItem> searchItems(String query) {
    if (!isVaultOpen()) throw Exception('Vault is not open');
    final lowerQuery = query.toLowerCase();
    
    return _vaultBox!.values.where((item) {
      return item.title.toLowerCase().contains(lowerQuery) ||
             item.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  /// Gets all unique folders
  static List<String> getAllFolders() {
    if (!isVaultOpen()) throw Exception('Vault is not open');
    final folders = _vaultBox!.values
        .where((item) => item.folder.isNotEmpty)
        .map((item) => item.folder)
        .toSet()
        .toList();
    folders.sort();
    return folders;
  }

  /// Gets all unique tags
  static List<String> getAllTags() {
    if (!isVaultOpen()) throw Exception('Vault is not open');
    final tags = <String>{};
    for (var item in _vaultBox!.values) {
      tags.addAll(item.tags);
    }
    final tagList = tags.toList();
    tagList.sort();
    return tagList;
  }

  /// Gets favorite items
  static List<VaultItem> getFavoriteItems() {
    if (!isVaultOpen()) throw Exception('Vault is not open');
    return _vaultBox!.values.where((item) => item.isFavorite).toList();
  }

  // ============ SETTINGS ============

  /// Sets auto-lock time in minutes
  static Future<void> setAutoLockTime(int minutes) async {
    final settingsBox = await Hive.openBox(_settingsBoxName);
    await settingsBox.put(_autoLockTimeKey, minutes);
  }

  /// Gets auto-lock time in minutes (default 5)
  static Future<int> getAutoLockTime() async {
    final settingsBox = await Hive.openBox(_settingsBoxName);
    return settingsBox.get(_autoLockTimeKey, defaultValue: 5);
  }

  /// Sets theme mode
  static Future<void> setThemeMode(String themeMode) async {
    final settingsBox = await Hive.openBox(_settingsBoxName);
    await settingsBox.put(_themeModeKey, themeMode);
  }

  /// Gets theme mode (default 'kali_purple')
  static Future<String> getThemeMode() async {
    final settingsBox = await Hive.openBox(_settingsBoxName);
    return settingsBox.get(_themeModeKey, defaultValue: 'kali_purple');
  }

  /// Gets total vault size in bytes
  static int getVaultSize() {
    if (!isVaultOpen()) return 0;
    
    int totalSize = 0;
    for (var item in _vaultBox!.values) {
      totalSize += item.encryptedContent.length;
    }
    return totalSize;
  }

  /// Gets item count
  static int getItemCount() {
    if (!isVaultOpen()) return 0;
    return _vaultBox!.length;
  }
}
