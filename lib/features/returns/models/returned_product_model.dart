import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'returned_product_model.g.dart';

@HiveType(typeId: 15)
class ReturnedProduct extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String productId;

  @HiveField(2)
  String productName;

  @HiveField(3)
  String? productSku;

  @HiveField(4)
  int quantityReturned;

  @HiveField(5)
  double unitPrice;

  @HiveField(6)
  double totalAmount;

  @HiveField(7)
  String reason;

  @HiveField(8)
  DateTime returnDate;

  @HiveField(9)
  String? customerName;

  @HiveField(10)
  String? orderId;

  @HiveField(11)
  ReturnStatus status;

  ReturnedProduct({
    required this.id,
    required this.productId,
    required this.productName,
    this.productSku,
    required this.quantityReturned,
    required this.unitPrice,
    required this.totalAmount,
    required this.reason,
    required this.returnDate,
    this.customerName,
    this.orderId,
    this.status = ReturnStatus.pending,
  });

  // Calculate total return amount
  double get calculatedTotal => unitPrice * quantityReturned;

  // Convert to map for export/import
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productSku': productSku,
      'quantityReturned': quantityReturned,
      'unitPrice': unitPrice,
      'totalAmount': totalAmount,
      'reason': reason,
      'returnDate': returnDate.toIso8601String(),
      'customerName': customerName,
      'orderId': orderId,
      'status': status.toString(),
    };
  }

  // Create from map
  factory ReturnedProduct.fromMap(Map<String, dynamic> map) {
    return ReturnedProduct(
      id: map['id'],
      productId: map['productId'],
      productName: map['productName'],
      productSku: map['productSku'],
      quantityReturned: map['quantityReturned'],
      unitPrice: map['unitPrice'],
      totalAmount: map['totalAmount'],
      reason: map['reason'],
      returnDate: DateTime.parse(map['returnDate']),
      customerName: map['customerName'],
      orderId: map['orderId'],
      status: ReturnStatus.values.firstWhere(
        (e) => e.toString() == map['status'],
        orElse: () => ReturnStatus.pending,
      ),
    );
  }
}

@HiveType(typeId: 7)
enum ReturnStatus {
  @HiveField(0)
  pending,

  @HiveField(1)
  approved,

  @HiveField(2)
  rejected,

  @HiveField(3)
  processed,
}

// Extension for better display
extension ReturnStatusExtension on ReturnStatus {
  String get displayName {
    switch (this) {
      case ReturnStatus.pending:
        return 'Pending';
      case ReturnStatus.approved:
        return 'Approved';
      case ReturnStatus.rejected:
        return 'Rejected';
      case ReturnStatus.processed:
        return 'Processed';
    }
  }

  Color get color {
    switch (this) {
      case ReturnStatus.pending:
        return Colors.orange;
      case ReturnStatus.approved:
        return Colors.green;
      case ReturnStatus.rejected:
        return Colors.red;
      case ReturnStatus.processed:
        return Colors.blue;
    }
  }
}
