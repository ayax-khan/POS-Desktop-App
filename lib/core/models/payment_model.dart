// lib/core/models/payment_model.dart
import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class PaymentModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String saleId;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String method; // 'cash', 'bank', 'card'

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime? updatedAt;

  @HiveField(6)
  final String? transactionId;

  @HiveField(7)
  final String? notes;

  PaymentModel({
    required this.id,
    required this.saleId,
    required this.amount,
    required this.method,
    required this.createdAt,
    this.updatedAt,
    this.transactionId,
    this.notes,
  });

  PaymentModel copyWith({
    String? id,
    String? saleId,
    double? amount,
    String? method,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? transactionId,
    String? notes,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      transactionId: transactionId ?? this.transactionId,
      notes: notes ?? this.notes,
    );
  }
}
