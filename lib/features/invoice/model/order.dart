import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 3)
class Order {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String customerName;

  @HiveField(2)
  final List<Map<String, dynamic>> products; // {product: Product, quantity: int}

  @HiveField(3)
  final double total;

  @HiveField(4)
  final DateTime date;

  @HiveField(5)
  final int? templateId; // Added to store selected template ID

  @HiveField(6)
  final String status; // NEW: Add status ('completed', 'refunded', etc.)

  Order({
    required this.id,
    required this.customerName,
    required this.products,
    required this.total,
    required this.date,
    this.templateId, // Make it optional
    this.status = 'completed', // Default to 'completed'
  });
}