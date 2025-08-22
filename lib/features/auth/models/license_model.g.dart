// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LicenseModelAdapter extends TypeAdapter<LicenseModel> {
  @override
  final int typeId = 5;

  @override
  LicenseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LicenseModel(
      licenseCode: fields[0] as String,
      activationDate: fields[1] as DateTime,
      durationInDays: fields[2] as int,
      isActive: fields[3] as bool,
      lastLoginTime: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LicenseModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.licenseCode)
      ..writeByte(1)
      ..write(obj.activationDate)
      ..writeByte(2)
      ..write(obj.durationInDays)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.lastLoginTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LicenseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
