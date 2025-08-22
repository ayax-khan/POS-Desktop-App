import 'package:pos/core/models/products.dart';
import 'package:pos/core/services/hive_service.dart';

class SearchService {
  static List<Product> searchProducts(String query) {
    final products = HiveService.getProducts();
    if (query.isEmpty) return products;
    return products.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.category.toLowerCase().contains(query.toLowerCase()) ||
          (product.sku?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
          (product.brand?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }
}
