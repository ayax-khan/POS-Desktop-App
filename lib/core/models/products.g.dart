// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      purchasePrice: fields[3] as double,
      sellingPrice: fields[4] as double,
      stockQuantity: fields[5] as int,
      unit: fields[6] as String,
      brand: fields[7] as String?,
      sku: fields[8] as String?,
      barcode: fields[9] as String?,
      expiryDate: fields[10] as DateTime?,
      imagePath: fields[11] as String?,
      description: fields[12] as String?,
      tax: fields[13] as double?,
      supplierInfo: fields[14] as String?,
      discount: fields[15] as double?,
      reorderLevel: fields[16] as int?,
      favorite: fields[17] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.purchasePrice)
      ..writeByte(4)
      ..write(obj.sellingPrice)
      ..writeByte(5)
      ..write(obj.stockQuantity)
      ..writeByte(6)
      ..write(obj.unit)
      ..writeByte(7)
      ..write(obj.brand)
      ..writeByte(8)
      ..write(obj.sku)
      ..writeByte(9)
      ..write(obj.barcode)
      ..writeByte(10)
      ..write(obj.expiryDate)
      ..writeByte(11)
      ..write(obj.imagePath)
      ..writeByte(12)
      ..write(obj.description)
      ..writeByte(13)
      ..write(obj.tax)
      ..writeByte(14)
      ..write(obj.supplierInfo)
      ..writeByte(15)
      ..write(obj.discount)
      ..writeByte(16)
      ..write(obj.reorderLevel)
      ..writeByte(17)
      ..write(obj.favorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
