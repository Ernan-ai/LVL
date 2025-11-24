import 'package:hive/hive.dart';

part 'vault_item.g.dart';

/// Type of vault item
@HiveType(typeId: 1)
enum VaultItemType {
  @HiveField(0)
  note,
  @HiveField(1)
  password,
  @HiveField(2)
  token,
  @HiveField(3)
  script,
  @HiveField(4)
  file,
}

/// Base class for all vault items
@HiveType(typeId: 0)
class VaultItem extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String encryptedContent; // Encrypted JSON string of item-specific data

  @HiveField(3)
  late VaultItemType type;

  @HiveField(4)
  late List<String> tags;

  @HiveField(5)
  late String folder;

  @HiveField(6)
  late DateTime createdAt;

  @HiveField(7)
  late DateTime modifiedAt;

  @HiveField(8)
  late bool isFavorite;

  VaultItem({
    required this.id,
    required this.title,
    required this.encryptedContent,
    required this.type,
    this.tags = const [],
    this.folder = '',
    DateTime? createdAt,
    DateTime? modifiedAt,
    this.isFavorite = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        modifiedAt = modifiedAt ?? DateTime.now();
}

/// Note data structure (stored as JSON, then encrypted)
class NoteData {
  final String content; // Markdown content
  final String? template; // Template name if created from template

  NoteData({
    required this.content,
    this.template,
  });

  Map<String, dynamic> toJson() => {
        'content': content,
        'template': template,
      };

  factory NoteData.fromJson(Map<String, dynamic> json) => NoteData(
        content: json['content'] as String,
        template: json['template'] as String?,
      );
}

/// Password/credential data structure
class PasswordData {
  final String username;
  final String password;
  final String? url;
  final String? notes;

  PasswordData({
    required this.username,
    required this.password,
    this.url,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'url': url,
        'notes': notes,
      };

  factory PasswordData.fromJson(Map<String, dynamic> json) => PasswordData(
        username: json['username'] as String,
        password: json['password'] as String,
        url: json['url'] as String?,
        notes: json['notes'] as String?,
      );
}

/// Token/API key data structure
class TokenData {
  final String token;
  final String? service;
  final String? notes;
  final DateTime? expiresAt;

  TokenData({
    required this.token,
    this.service,
    this.notes,
    this.expiresAt,
  });

  Map<String, dynamic> toJson() => {
        'token': token,
        'service': service,
        'notes': notes,
        'expiresAt': expiresAt?.toIso8601String(),
      };

  factory TokenData.fromJson(Map<String, dynamic> json) => TokenData(
        token: json['token'] as String,
        service: json['service'] as String?,
        notes: json['notes'] as String?,
        expiresAt: json['expiresAt'] != null
            ? DateTime.parse(json['expiresAt'] as String)
            : null,
      );
}

/// Script data structure
class ScriptData {
  final String code;
  final String language; // bash, python, sql, js, etc.
  final String? notes;

  ScriptData({
    required this.code,
    required this.language,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'language': language,
        'notes': notes,
      };

  factory ScriptData.fromJson(Map<String, dynamic> json) => ScriptData(
        code: json['code'] as String,
        language: json['language'] as String,
        notes: json['notes'] as String?,
      );
}

/// File data structure
class FileData {
  final String fileName;
  final String mimeType;
  final int sizeBytes;
  final String encryptedData; // Base64 encoded encrypted file data
  final String? notes;

  FileData({
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
    required this.encryptedData,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'mimeType': mimeType,
        'sizeBytes': sizeBytes,
        'encryptedData': encryptedData,
        'notes': notes,
      };

  factory FileData.fromJson(Map<String, dynamic> json) => FileData(
        fileName: json['fileName'] as String,
        mimeType: json['mimeType'] as String,
        sizeBytes: json['sizeBytes'] as int,
        encryptedData: json['encryptedData'] as String,
        notes: json['notes'] as String?,
      );
}

/// Hive type adapters
@HiveType(typeId: 1)
enum VaultItemTypeAdapter {
  @HiveField(0)
  note,
  @HiveField(1)
  password,
  @HiveField(2)
  token,
  @HiveField(3)
  key,
  @HiveField(4)
  script,
  @HiveField(5)
  file,
}
