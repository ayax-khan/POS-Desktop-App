// lib/features/invoice/model/invoice_model.dart
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Invoice extends HiveObject {
  @HiveField(0)
  String? invoiceNumber;

  @HiveField(1)
  String? customerName;

  @HiveField(2)
  String? customerId;

  @HiveField(3)
  DateTime? date;

  @HiveField(4)
  List<InvoiceItem>? items;

  @HiveField(5)
  double? subtotal;

  @HiveField(6)
  double? tax;

  @HiveField(7)
  double? discount;

  @HiveField(8)
  double? totalAmount;

  @HiveField(9)
  String? status;

  @HiveField(10)
  String? paymentMethod;

  @HiveField(11)
  String? notes;

  Invoice({
    this.invoiceNumber,
    this.customerName,
    this.customerId,
    this.date,
    this.items,
    this.subtotal,
    this.tax,
    this.discount,
    this.totalAmount,
    this.status,
    this.paymentMethod,
    this.notes,
  });
}

@HiveType(typeId: 1)
class InvoiceItem extends HiveObject {
  @HiveField(0)
  String? productId;

  @HiveField(1)
  String? productName;

  @HiveField(2)
  int? quantity;

  @HiveField(3)
  double? price;

  @HiveField(4)
  double? total;

  @HiveField(5)
  String? category;

  InvoiceItem({
    this.productId,
    this.productName,
    this.quantity,
    this.price,
    this.total,
    this.category,
  });
}
