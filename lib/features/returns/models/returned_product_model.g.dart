// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'returned_product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReturnedProductAdapter extends TypeAdapter<ReturnedProduct> {
  @override
  final int typeId = 15;

  @override
  ReturnedProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReturnedProduct(
      id: fields[0] as String,
      productId: fields[1] as String,
      productName: fields[2] as String,
      productSku: fields[3] as String?,
      quantityReturned: fields[4] as int,
      unitPrice: fields[5] as double,
      totalAmount: fields[6] as double,
      reason: fields[7] as String,
      returnDate: fields[8] as DateTime,
      customerName: fields[9] as String?,
      orderId: fields[10] as String?,
      status: fields[11] as ReturnStatus,
    );
  }

  @override
  void write(BinaryWriter writer, ReturnedProduct obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productName)
      ..writeByte(3)
      ..write(obj.productSku)
      ..writeByte(4)
      ..write(obj.quantityReturned)
      ..writeByte(5)
      ..write(obj.unitPrice)
      ..writeByte(6)
      ..write(obj.totalAmount)
      ..writeByte(7)
      ..write(obj.reason)
      ..writeByte(8)
      ..write(obj.returnDate)
      ..writeByte(9)
      ..write(obj.customerName)
      ..writeByte(10)
      ..write(obj.orderId)
      ..writeByte(11)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReturnedProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReturnStatusAdapter extends TypeAdapter<ReturnStatus> {
  @override
  final int typeId = 7;

  @override
  ReturnStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReturnStatus.pending;
      case 1:
        return ReturnStatus.approved;
      case 2:
        return ReturnStatus.rejected;
      case 3:
        return ReturnStatus.processed;
      default:
        return ReturnStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, ReturnStatus obj) {
    switch (obj) {
      case ReturnStatus.pending:
        writer.writeByte(0);
        break;
      case ReturnStatus.approved:
        writer.writeByte(1);
        break;
      case ReturnStatus.rejected:
        writer.writeByte(2);
        break;
      case ReturnStatus.processed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReturnStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
