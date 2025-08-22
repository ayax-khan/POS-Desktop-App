// lib/features/Products/Models/product_model.dart
import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class Product extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? category;

  @HiveField(4)
  double? price;

  @HiveField(5)
  double? cost;

  @HiveField(6)
  int? stock;

  @HiveField(7)
  String? sku;

  @HiveField(8)
  String? barcode;

  @HiveField(9)
  String? unit;

  @HiveField(10)
  int? reorderLevel;

  @HiveField(11)
  String? supplier;

  @HiveField(12)
  DateTime? createdAt;

  @HiveField(13)
  DateTime? updatedAt;

  @HiveField(14)
  bool? isActive;

  @HiveField(15)
  String? imageUrl;

  Product({
    this.id,
    this.name,
    this.description,
    this.category,
    this.price,
    this.cost,
    this.stock,
    this.sku,
    this.barcode,
    this.unit,
    this.reorderLevel,
    this.supplier,
    this.createdAt,
    this.updatedAt,
    this.isActive,
    this.imageUrl,
  });
}
