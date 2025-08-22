// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 3;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as String,
      customerId: fields[1] as String,
      items: (fields[2] as List).cast<TransactionItem>(),
      totalAmount: fields[3] as double,
      taxAmount: fields[4] as double,
      discountAmount: fields[5] as double,
      timestamp: fields[6] as DateTime,
      paymentMethod: fields[7] as String?,
      status: fields[8] as TransactionStatus?,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerId)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.taxAmount)
      ..writeByte(5)
      ..write(obj.discountAmount)
      ..writeByte(6)
      ..write(obj.timestamp)
      ..writeByte(7)
      ..write(obj.paymentMethod)
      ..writeByte(8)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionItemAdapter extends TypeAdapter<TransactionItem> {
  @override
  final int typeId = 4;

  @override
  TransactionItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionItem(
      productId: fields[0] as String,
      productName: fields[1] as String,
      quantity: fields[2] as int,
      unitPrice: fields[3] as double,
      totalPrice: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TransactionItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.unitPrice)
      ..writeByte(4)
      ..write(obj.totalPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionStatusAdapter extends TypeAdapter<TransactionStatus> {
  @override
  final int typeId = 5;

  @override
  TransactionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionStatus.completed;
      case 1:
        return TransactionStatus.pending;
      case 2:
        return TransactionStatus.cancelled;
      case 3:
        return TransactionStatus.refunded;
      default:
        return TransactionStatus.completed;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionStatus obj) {
    switch (obj) {
      case TransactionStatus.completed:
        writer.writeByte(0);
        break;
      case TransactionStatus.pending:
        writer.writeByte(1);
        break;
      case TransactionStatus.cancelled:
        writer.writeByte(2);
        break;
      case TransactionStatus.refunded:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
