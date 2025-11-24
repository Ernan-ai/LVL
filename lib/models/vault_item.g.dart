// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VaultItemAdapter extends TypeAdapter<VaultItem> {
  @override
  final int typeId = 0;

  @override
  VaultItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VaultItem(
      id: fields[0] as String,
      title: fields[1] as String,
      encryptedContent: fields[2] as String,
      type: fields[3] as VaultItemType,
      tags: (fields[4] as List).cast<String>(),
      folder: fields[5] as String,
      createdAt: fields[6] as DateTime?,
      modifiedAt: fields[7] as DateTime?,
      isFavorite: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, VaultItem obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.encryptedContent)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.folder)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.modifiedAt)
      ..writeByte(8)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VaultItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VaultItemTypeAdapter extends TypeAdapter<VaultItemType> {
  @override
  final int typeId = 1;

  @override
  VaultItemType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VaultItemType.note;
      case 1:
        return VaultItemType.password;
      case 2:
        return VaultItemType.token;
      case 3:
        return VaultItemType.script;
      case 4:
        return VaultItemType.file;
      default:
        return VaultItemType.note;
    }
  }

  @override
  void write(BinaryWriter writer, VaultItemType obj) {
    switch (obj) {
      case VaultItemType.note:
        writer.writeByte(0);
        break;
      case VaultItemType.password:
        writer.writeByte(1);
        break;
      case VaultItemType.token:
        writer.writeByte(2);
        break;
      case VaultItemType.script:
        writer.writeByte(3);
        break;
      case VaultItemType.file:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VaultItemTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class VaultItemTypeAdapterAdapter extends TypeAdapter<VaultItemTypeAdapter> {
  @override
  final int typeId = 1;

  @override
  VaultItemTypeAdapter read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return VaultItemTypeAdapter.note;
      case 1:
        return VaultItemTypeAdapter.password;
      case 2:
        return VaultItemTypeAdapter.token;
      case 3:
        return VaultItemTypeAdapter.key;
      case 4:
        return VaultItemTypeAdapter.script;
      case 5:
        return VaultItemTypeAdapter.file;
      default:
        return VaultItemTypeAdapter.note;
    }
  }

  @override
  void write(BinaryWriter writer, VaultItemTypeAdapter obj) {
    switch (obj) {
      case VaultItemTypeAdapter.note:
        writer.writeByte(0);
        break;
      case VaultItemTypeAdapter.password:
        writer.writeByte(1);
        break;
      case VaultItemTypeAdapter.token:
        writer.writeByte(2);
        break;
      case VaultItemTypeAdapter.key:
        writer.writeByte(3);
        break;
      case VaultItemTypeAdapter.script:
        writer.writeByte(4);
        break;
      case VaultItemTypeAdapter.file:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VaultItemTypeAdapterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
