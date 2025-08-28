// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessInfoModelAdapter extends TypeAdapter<BusinessInfoModel> {
  @override
  final int typeId = 14;

  @override
  BusinessInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessInfoModel(
      shopName: fields[0] as String,
      logoPath: fields[1] as String?,
      address: fields[2] as String,
      phoneNumber: fields[3] as String,
      country: fields[4] as String,
      lastUpdated: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessInfoModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.shopName)
      ..writeByte(1)
      ..write(obj.logoPath)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.country)
      ..writeByte(5)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
