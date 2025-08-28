// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 4;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    // Defensive parsing: handle older/incorrectly-typed stored values.
    final dynamic _profileRaw = fields[4];
    String? profilePicturePath;
    if (_profileRaw == null) {
      profilePicturePath = null;
    } else if (_profileRaw is String) {
      profilePicturePath = _profileRaw;
    } else {
      // Fallback: convert to string
      profilePicturePath = _profileRaw.toString();
    }

    final dynamic _regRaw = fields[5];
    DateTime registrationDate;
    if (_regRaw is DateTime) {
      registrationDate = _regRaw;
    } else if (_regRaw is int) {
      registrationDate = DateTime.fromMillisecondsSinceEpoch(_regRaw);
    } else if (_regRaw is String) {
      // Try ISO parse, then try int parse
      registrationDate =
          DateTime.tryParse(_regRaw) ??
          DateTime.fromMillisecondsSinceEpoch(int.tryParse(_regRaw) ?? 0);
      // If parsing failed, fallback to now
      if (registrationDate.millisecondsSinceEpoch == 0) {
        registrationDate = DateTime.now();
      }
    } else {
      registrationDate = DateTime.now();
    }

    return UserModel(
      name: fields[0] as String,
      email: fields[1] as String,
      shopAddress: fields[2] as String,
      phoneNumber: fields[3] as String,
      profilePicturePath: profilePicturePath,
      registrationDate: registrationDate,
      isRegistered: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.shopAddress)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.profilePicturePath)
      ..writeByte(5)
      ..write(obj.registrationDate)
      ..writeByte(6)
      ..write(obj.isRegistered);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
