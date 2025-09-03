import 'package:hive/hive.dart';

part 'products.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String category;

  @HiveField(3)
  double purchasePrice;

  @HiveField(4)
  double sellingPrice;

  @HiveField(5)
  int stockQuantity;

  @HiveField(6)
  String unit;

  @HiveField(7)
  String? brand;

  @HiveField(8)
  String? sku;

  @HiveField(9)
  String? barcode;

  @HiveField(10)
  DateTime? expiryDate;

  @HiveField(11)
  String? imagePath;

  @HiveField(12)
  String? description;

  @HiveField(13)
  double? tax;

  @HiveField(14)
  String? supplierInfo;

  @HiveField(15)
  double? discount;

  @HiveField(16)
  int? reorderLevel;

  @HiveField(17)
  bool favorite;

  @HiveField(18) // 🔹 New field
  DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stockQuantity,
    required this.unit,
    this.brand,
    this.sku,
    this.barcode,
    this.expiryDate,
    this.imagePath,
    this.description,
    this.tax,
    this.supplierInfo,
    this.discount,
    this.reorderLevel,
    this.favorite = false,
    this.updatedAt, // 🔹 Add to constructor
  });

  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? purchasePrice,
    double? sellingPrice,
    int? stockQuantity,
    String? unit,
    String? brand,
    String? sku,
    String? barcode,
    DateTime? expiryDate,
    String? imagePath,
    String? description,
    double? tax,
    String? supplierInfo,
    double? discount,
    int? reorderLevel,
    bool? favorite,
    DateTime? updatedAt, // 🔹 Add here
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      unit: unit ?? this.unit,
      brand: brand ?? this.brand,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      expiryDate: expiryDate ?? this.expiryDate,
      imagePath: imagePath ?? this.imagePath,
      description: description ?? this.description,
      tax: tax ?? this.tax,
      supplierInfo: supplierInfo ?? this.supplierInfo,
      discount: discount ?? this.discount,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      favorite: favorite ?? this.favorite,
      updatedAt: updatedAt ?? this.updatedAt, // 🔹 Assign here
    );
  }
}
