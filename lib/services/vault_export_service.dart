import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/vault_item.dart';
import 'aes_encryption_service.dart';
import 'hive_service.dart';

/// Service for exporting and importing entire vault as encrypted .scvault file
class VaultExportService {
  /// Exports entire vault to encrypted .scvault file
  /// Returns file path on success, null on failure
  static Future<String?> exportVault(String masterPassword) async {
    try {
      // Get all vault items
      final items = HiveService.getAllItems();
      
      // Convert to JSON
      final vaultData = {
        'version': '1.0',
        'exportedAt': DateTime.now().toIso8601String(),
        'itemCount': items.length,
        'items': items.map((item) => {
          'id': item.id,
          'title': item.title,
          'encryptedContent': item.encryptedContent,
          'type': item.type.toString(),
          'tags': item.tags,
          'folder': item.folder,
          'createdAt': item.createdAt.toIso8601String(),
          'modifiedAt': item.modifiedAt.toIso8601String(),
          'isFavorite': item.isFavorite,
        }).toList(),
      };

      // Convert to JSON string
      final jsonString = json.encode(vaultData);
      
      // Compress using gzip
      final jsonBytes = utf8.encode(jsonString);
      final compressed = GZipEncoder().encode(jsonBytes);
      
      if (compressed == null) {
        throw Exception('Compression failed');
      }

      // Encrypt the compressed data
      final encrypted = AESEncryptionService.encryptBytes(
        Uint8List.fromList(compressed),
        masterPassword,
      );

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'vault_export_$timestamp.scvault';
      final filePath = '${directory.path}/$fileName';
      
      final file = File(filePath);
      await file.writeAsBytes(encrypted);

      return filePath;
    } catch (e) {
      print('Export error: $e');
      return null;
    }
  }

  /// Imports vault from encrypted .scvault file
  /// Returns number of items imported, -1 on failure
  static Future<int> importVault(String filePath, String masterPassword) async {
    try {
      // Read encrypted file
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('File not found');
      }

      final encrypted = await file.readAsBytes();

      // Decrypt
      final compressed = AESEncryptionService.decryptBytes(
        encrypted,
        masterPassword,
      );

      // Decompress
      final jsonBytes = GZipDecoder().decodeBytes(compressed);
      final jsonString = utf8.decode(jsonBytes);

      // Parse JSON
      final vaultData = json.decode(jsonString) as Map<String, dynamic>;

      // Validate version
      if (vaultData['version'] != '1.0') {
        throw Exception('Unsupported vault version');
      }

      // Import items
      final items = vaultData['items'] as List<dynamic>;
      int importedCount = 0;

      for (var itemData in items) {
        final item = VaultItem(
          id: itemData['id'] as String,
          title: itemData['title'] as String,
          encryptedContent: itemData['encryptedContent'] as String,
          type: _parseVaultItemType(itemData['type'] as String),
          tags: List<String>.from(itemData['tags'] as List),
          folder: itemData['folder'] as String,
          createdAt: DateTime.parse(itemData['createdAt'] as String),
          modifiedAt: DateTime.parse(itemData['modifiedAt'] as String),
          isFavorite: itemData['isFavorite'] as bool,
        );

        await HiveService.addItem(item);
        importedCount++;
      }

      return importedCount;
    } catch (e) {
      print('Import error: $e');
      return -1;
    }
  }

  /// Validates .scvault file without importing
  static Future<Map<String, dynamic>?> validateVaultFile(
    String filePath,
    String masterPassword,
  ) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return null;
      }

      final encrypted = await file.readAsBytes();
      final compressed = AESEncryptionService.decryptBytes(
        encrypted,
        masterPassword,
      );
      final jsonBytes = GZipDecoder().decodeBytes(compressed);
      final jsonString = utf8.decode(jsonBytes);
      final vaultData = json.decode(jsonString) as Map<String, dynamic>;

      return {
        'version': vaultData['version'],
        'exportedAt': vaultData['exportedAt'],
        'itemCount': vaultData['itemCount'],
      };
    } catch (e) {
      print('Validation error: $e');
      return null;
    }
  }

  /// Helper to parse VaultItemType from string
  static VaultItemType _parseVaultItemType(String typeString) {
    switch (typeString) {
      case 'VaultItemType.note':
        return VaultItemType.note;
      case 'VaultItemType.password':
        return VaultItemType.password;
      case 'VaultItemType.token':
        return VaultItemType.token;
      case 'VaultItemType.key':
        return VaultItemType.key;
      case 'VaultItemType.script':
        return VaultItemType.script;
      case 'VaultItemType.file':
        return VaultItemType.file;
      default:
        return VaultItemType.note;
    }
  }

  /// Gets export file size estimate in bytes
  static Future<int> getExportSizeEstimate() async {
    try {
      final items = HiveService.getAllItems();
      int totalSize = 0;
      
      for (var item in items) {
        totalSize += item.encryptedContent.length;
        totalSize += item.title.length;
        totalSize += item.tags.join(',').length;
        totalSize += 100; // Metadata overhead
      }

      // Account for compression (estimate 50% reduction)
      return (totalSize * 0.5).toInt();
    } catch (e) {
      return 0;
    }
  }
}
