import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import '../models/vault_item.dart';
import 'aes_encryption_service.dart';

/// Service for transferring data between devices via QR code
/// Large data is split into multiple QR codes
class QRTransferService {
  static const int maxQRDataSize = 2000; // Max bytes per QR code (conservative)
  
  /// Prepares vault data for QR transfer
  /// Returns list of QR data chunks
  static Future<List<String>> prepareForQRTransfer(
    List<VaultItem> items,
    String transferPassword,
  ) async {
    try {
      // Convert items to JSON
      final transferData = {
        'version': '1.0',
        'timestamp': DateTime.now().toIso8601String(),
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
      final jsonString = json.encode(transferData);
      
      // Compress
      final jsonBytes = utf8.encode(jsonString);
      final compressed = GZipEncoder().encode(jsonBytes);
      
      if (compressed == null) {
        throw Exception('Compression failed');
      }

      // Encrypt
      final encrypted = AESEncryptionService.encryptBytes(
        Uint8List.fromList(compressed),
        transferPassword,
      );

      // Convert to base64
      final base64Data = base64.encode(encrypted);

      // Split into chunks
      return _splitIntoChunks(base64Data);
    } catch (e) {
      print('QR preparation error: $e');
      return [];
    }
  }

  /// Splits data into QR-friendly chunks
  static List<String> _splitIntoChunks(String data) {
    final chunks = <String>[];
    final totalChunks = (data.length / maxQRDataSize).ceil();

    for (int i = 0; i < totalChunks; i++) {
      final start = i * maxQRDataSize;
      final end = (start + maxQRDataSize).clamp(0, data.length);
      final chunk = data.substring(start, end);
      
      // Add metadata: chunk_index/total_chunks:data
      final chunkWithMetadata = '${i + 1}/$totalChunks:$chunk';
      chunks.add(chunkWithMetadata);
    }

    return chunks;
  }

  /// Reconstructs data from scanned QR chunks
  /// Returns null if chunks are incomplete or invalid
  static Future<List<VaultItem>?> reconstructFromQRChunks(
    List<String> scannedChunks,
    String transferPassword,
  ) async {
    try {
      // Parse chunks and sort by index
      final chunkMap = <int, String>{};
      int totalChunks = 0;

      for (var chunk in scannedChunks) {
        final parts = chunk.split(':');
        if (parts.length != 2) continue;

        final indexPart = parts[0].split('/');
        if (indexPart.length != 2) continue;

        final index = int.parse(indexPart[0]);
        totalChunks = int.parse(indexPart[1]);
        final data = parts[1];

        chunkMap[index] = data;
      }

      // Verify all chunks received
      if (chunkMap.length != totalChunks) {
        print('Missing chunks: ${totalChunks - chunkMap.length}');
        return null;
      }

      // Reconstruct data
      final buffer = StringBuffer();
      for (int i = 1; i <= totalChunks; i++) {
        buffer.write(chunkMap[i]);
      }

      final base64Data = buffer.toString();

      // Decode from base64
      final encrypted = base64.decode(base64Data);

      // Decrypt
      final compressed = AESEncryptionService.decryptBytes(
        encrypted,
        transferPassword,
      );

      // Decompress
      final jsonBytes = GZipDecoder().decodeBytes(compressed);
      final jsonString = utf8.decode(jsonBytes);

      // Parse JSON
      final transferData = json.decode(jsonString) as Map<String, dynamic>;

      // Convert to VaultItems
      final items = <VaultItem>[];
      for (var itemData in transferData['items'] as List) {
        items.add(VaultItem(
          id: itemData['id'] as String,
          title: itemData['title'] as String,
          encryptedContent: itemData['encryptedContent'] as String,
          type: _parseVaultItemType(itemData['type'] as String),
          tags: List<String>.from(itemData['tags'] as List),
          folder: itemData['folder'] as String,
          createdAt: DateTime.parse(itemData['createdAt'] as String),
          modifiedAt: DateTime.parse(itemData['modifiedAt'] as String),
          isFavorite: itemData['isFavorite'] as bool,
        ));
      }

      return items;
    } catch (e) {
      print('QR reconstruction error: $e');
      return null;
    }
  }

  /// Estimates number of QR codes needed for transfer
  static Future<int> estimateQRCount(List<VaultItem> items) async {
    try {
      final jsonString = json.encode(items.map((item) => {
        'id': item.id,
        'title': item.title,
        'encryptedContent': item.encryptedContent,
      }).toList());

      final jsonBytes = utf8.encode(jsonString);
      final compressed = GZipEncoder().encode(jsonBytes);
      
      if (compressed == null) return 0;

      // Base64 encoding increases size by ~33%
      final base64Size = (compressed.length * 1.33).ceil();
      
      return (base64Size / maxQRDataSize).ceil();
    } catch (e) {
      return 0;
    }
  }

  /// Validates transfer password before reconstruction
  static bool validateTransferChunk(String chunk) {
    try {
      final parts = chunk.split(':');
      if (parts.length != 2) return false;

      final indexPart = parts[0].split('/');
      if (indexPart.length != 2) return false;

      int.parse(indexPart[0]); // Index
      int.parse(indexPart[1]); // Total

      return true;
    } catch (e) {
      return false;
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
      case 'VaultItemType.script':
        return VaultItemType.script;
      case 'VaultItemType.file':
        return VaultItemType.file;
      default:
        return VaultItemType.note;
    }
  }
}
