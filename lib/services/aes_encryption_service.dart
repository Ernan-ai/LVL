import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt_pkg;
import 'package:crypto/crypto.dart';

/// Service for encrypting and decrypting data using AES-256-GCM
/// This provides military-grade encryption for all stored data
class AESEncryptionService {
  /// Generates a 256-bit key from master password using SHA-256
  static encrypt_pkg.Key _deriveKey(String masterPassword) {
    final bytes = utf8.encode(masterPassword);
    final hash = sha256.convert(bytes);
    return encrypt_pkg.Key(Uint8List.fromList(hash.bytes));
  }

  /// Encrypts plaintext using AES-256-GCM
  /// Returns base64-encoded encrypted data with IV prepended
  static String encrypt(String plaintext, String masterPassword) {
    if (plaintext.isEmpty || masterPassword.isEmpty) {
      throw ArgumentError('Plaintext and password cannot be empty');
    }

    try {
      final key = _deriveKey(masterPassword);
      final iv = encrypt_pkg.IV.fromSecureRandom(16); // 128-bit IV for GCM
      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key, mode: encrypt_pkg.AESMode.gcm));

      final encrypted = encrypter.encrypt(plaintext, iv: iv);
      
      // Combine IV + encrypted data for storage
      final combined = Uint8List.fromList([
        ...iv.bytes,
        ...encrypted.bytes,
      ]);

      return base64.encode(combined);
    } catch (e) {
      throw Exception('Encryption failed: $e');
    }
  }

  /// Decrypts ciphertext using AES-256-GCM
  /// Expects base64-encoded data with IV prepended
  static String decrypt(String ciphertext, String masterPassword) {
    if (ciphertext.isEmpty || masterPassword.isEmpty) {
      throw ArgumentError('Ciphertext and password cannot be empty');
    }

    try {
      final key = _deriveKey(masterPassword);
      final combined = base64.decode(ciphertext);

      if (combined.length < 16) {
        throw ArgumentError('Invalid ciphertext: too short');
      }

      // Extract IV and encrypted data
      final iv = encrypt_pkg.IV(Uint8List.fromList(combined.sublist(0, 16)));
      final encryptedData = Uint8List.fromList(combined.sublist(16));

      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key, mode: encrypt_pkg.AESMode.gcm));
      final encrypted = encrypt_pkg.Encrypted(encryptedData);

      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e) {
      throw Exception('Decryption failed: Wrong password or corrupted data');
    }
  }

  /// Encrypts binary data (for files)
  static Uint8List encryptBytes(Uint8List data, String masterPassword) {
    if (data.isEmpty || masterPassword.isEmpty) {
      throw ArgumentError('Data and password cannot be empty');
    }

    try {
      final key = _deriveKey(masterPassword);
      final iv = encrypt_pkg.IV.fromSecureRandom(16);
      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key, mode: encrypt_pkg.AESMode.gcm));

      final encrypted = encrypter.encryptBytes(data, iv: iv);
      
      // Combine IV + encrypted data
      return Uint8List.fromList([
        ...iv.bytes,
        ...encrypted.bytes,
      ]);
    } catch (e) {
      throw Exception('Binary encryption failed: $e');
    }
  }

  /// Decrypts binary data (for files)
  static Uint8List decryptBytes(Uint8List data, String masterPassword) {
    if (data.isEmpty || masterPassword.isEmpty) {
      throw ArgumentError('Data and password cannot be empty');
    }

    try {
      final key = _deriveKey(masterPassword);
      
      if (data.length < 16) {
        throw ArgumentError('Invalid encrypted data: too short');
      }

      // Extract IV and encrypted data
      final iv = encrypt_pkg.IV(Uint8List.fromList(data.sublist(0, 16)));
      final encryptedData = Uint8List.fromList(data.sublist(16));

      final encrypter = encrypt_pkg.Encrypter(encrypt_pkg.AES(key, mode: encrypt_pkg.AESMode.gcm));
      final encrypted = encrypt_pkg.Encrypted(encryptedData);

      return encrypter.decryptBytes(encrypted, iv: iv);
    } catch (e) {
      throw Exception('Binary decryption failed: Wrong password or corrupted data');
    }
  }

  /// Verifies if the master password is correct by attempting to decrypt a test value
  static bool verifyPassword(String encryptedTestValue, String masterPassword) {
    try {
      decrypt(encryptedTestValue, masterPassword);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Creates an encrypted test value for password verification
  static String createTestValue(String masterPassword) {
    const testString = 'PASSWORD_VERIFICATION_TEST';
    return encrypt(testString, masterPassword);
  }
}
