// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DashboardDataAdapter extends TypeAdapter<DashboardData> {
  @override
  final int typeId = 10;

  @override
  DashboardData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardData(
      totalSales: fields[0] as double,
      totalOrders: fields[1] as int,
      totalCustomers: fields[2] as int,
      lowStockItems: fields[3] as int,
      salesGrowth: fields[4] as double,
      ordersGrowth: fields[5] as double,
      customersGrowth: fields[6] as double,
      dailySales: (fields[7] as List).cast<SalesData>(),
      weeklySales: (fields[8] as List).cast<SalesData>(),
      monthlySales: (fields[9] as List).cast<SalesData>(),
      topProducts: (fields[10] as List).cast<TopProduct>(),
      recentTransactions: (fields[11] as List).cast<RecentTransaction>(),
      lastUpdated: fields[12] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, DashboardData obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.totalSales)
      ..writeByte(1)
      ..write(obj.totalOrders)
      ..writeByte(2)
      ..write(obj.totalCustomers)
      ..writeByte(3)
      ..write(obj.lowStockItems)
      ..writeByte(4)
      ..write(obj.salesGrowth)
      ..writeByte(5)
      ..write(obj.ordersGrowth)
      ..writeByte(6)
      ..write(obj.customersGrowth)
      ..writeByte(7)
      ..write(obj.dailySales)
      ..writeByte(8)
      ..write(obj.weeklySales)
      ..writeByte(9)
      ..write(obj.monthlySales)
      ..writeByte(10)
      ..write(obj.topProducts)
      ..writeByte(11)
      ..write(obj.recentTransactions)
      ..writeByte(12)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SalesDataAdapter extends TypeAdapter<SalesData> {
  @override
  final int typeId = 11;

  @override
  SalesData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesData(
      period: fields[0] as String,
      amount: fields[1] as double,
      date: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SalesData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.period)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TopProductAdapter extends TypeAdapter<TopProduct> {
  @override
  final int typeId = 12;

  @override
  TopProduct read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopProduct(
      name: fields[0] as String,
      quantity: fields[1] as int,
      revenue: fields[2] as double,
      category: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TopProduct obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.revenue)
      ..writeByte(3)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecentTransactionAdapter extends TypeAdapter<RecentTransaction> {
  @override
  final int typeId = 13;

  @override
  RecentTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentTransaction(
      id: fields[0] as String,
      customerName: fields[1] as String,
      amount: fields[2] as double,
      status: fields[3] as String,
      date: fields[4] as DateTime,
      paymentMethod: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecentTransaction obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.customerName)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.paymentMethod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
