// lib/features/Reports/Models/transaction_model.dart
import 'package:hive/hive.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class Transaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String customerId;

  @HiveField(2)
  final List<TransactionItem> items;

  @HiveField(3)
  final double totalAmount;

  @HiveField(4)
  final double taxAmount;

  @HiveField(5)
  final double discountAmount;

  @HiveField(6)
  final DateTime timestamp;

  @HiveField(7)
  final String? paymentMethod;

  @HiveField(8)
  final TransactionStatus? status;

  Transaction({
    required this.id,
    required this.customerId,
    required this.items,
    required this.totalAmount,
    required this.taxAmount,
    required this.discountAmount,
    required this.timestamp,
    this.paymentMethod, // Changed from required to optional
    this.status, // Changed from required to optional
  });

  Transaction copyWith({
    String? id,
    String? customerId,
    List<TransactionItem>? items,
    double? totalAmount,
    double? taxAmount,
    double? discountAmount,
    DateTime? timestamp,
    String? paymentMethod,
    TransactionStatus? status,
  }) {
    return Transaction(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      timestamp: timestamp ?? this.timestamp,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      'timestamp': timestamp.toIso8601String(),
      'paymentMethod': paymentMethod,
      'status': status?.name,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      customerId: json['customerId'],
      items:
          (json['items'] as List)
              .map((item) => TransactionItem.fromJson(item))
              .toList(),
      totalAmount: json['totalAmount'].toDouble(),
      taxAmount: json['taxAmount'].toDouble(),
      discountAmount: json['discountAmount'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      paymentMethod: json['paymentMethod'],
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransactionStatus.completed,
      ),
    );
  }
}

@HiveType(typeId: 4)
class TransactionItem extends HiveObject {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final double unitPrice;

  @HiveField(4)
  final double totalPrice;

  TransactionItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  TransactionItem copyWith({
    String? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
  }) {
    return TransactionItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
    };
  }

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      productId: json['productId'],
      productName: json['productName'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'].toDouble(),
      totalPrice: json['totalPrice'].toDouble(),
    );
  }
}

@HiveType(typeId: 5)
enum TransactionStatus {
  @HiveField(0)
  completed,
  @HiveField(1)
  pending,
  @HiveField(2)
  cancelled,
  @HiveField(3)
  refunded,
}
