import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pos/core/models/products.dart';
import 'package:pos/core/services/hive_service.dart';
import 'package:pos/features/returns/models/returned_product_model.dart';
import 'package:ulid/ulid.dart';

class ReturnsService {
  static const String _returnsBoxName = 'returned_products';

  // Initialize Hive and register adapters
  static Future<void> init() async {
    try {
      if (!Hive.isAdapterRegistered(6)) {
        Hive.registerAdapter(ReturnedProductAdapter());
      }
      if (!Hive.isAdapterRegistered(7)) {
        Hive.registerAdapter(ReturnStatusAdapter());
      }
      await Hive.openBox<ReturnedProduct>(_returnsBoxName);
    } catch (e) {
      debugPrint('Error initializing ReturnsService: $e');
    }
  }

  // Process product return
  static Future<bool> processReturn({
    required String productId,
    required int quantityToReturn,
    required String reason,
    String? customerName,
    String? orderId,
  }) async {
    try {
      // Get product details
      final product = HiveService.getProductById(productId);
      if (product == null) {
        throw Exception('Product not found');
      }

      // Check if enough stock to return (in case of restocking)
      if (quantityToReturn <= 0) {
        throw Exception('Invalid return quantity');
      }

      // Create return record
      final returnedProduct = ReturnedProduct(
        id: Ulid().toString(),
        productId: productId,
        productName: product.name,
        productSku: product.sku,
        quantityReturned: quantityToReturn,
        unitPrice: product.sellingPrice,
        totalAmount: product.sellingPrice * quantityToReturn,
        reason: reason,
        returnDate: DateTime.now(),
        customerName: customerName,
        orderId: orderId,
        status: ReturnStatus.approved, // Auto-approve for now
      );

      // Save return record
      final box = await Hive.openBox<ReturnedProduct>(_returnsBoxName);
      await box.put(returnedProduct.id, returnedProduct);

      // Update product stock (add returned quantity back to stock)
      await _updateProductStock(productId, quantityToReturn);

      debugPrint('Return processed successfully: ${returnedProduct.id}');
      return true;
    } catch (e) {
      debugPrint('Error processing return: $e');
      return false;
    }
  }

  // Update product stock after return
  static Future<void> _updateProductStock(
    String productId,
    int returnedQuantity,
  ) async {
    try {
      final product = HiveService.getProductById(productId);
      if (product != null) {
        // Add returned quantity back to stock
        final updatedProduct = product.copyWith(
          stockQuantity: product.stockQuantity + returnedQuantity,
          updatedAt: DateTime.now(),
        );

        await HiveService.updateProduct(updatedProduct);
        debugPrint(
          'Product stock updated: ${product.name} (+$returnedQuantity)',
        );
      }
    } catch (e) {
      debugPrint('Error updating product stock: $e');
    }
  }

  // Get all returned products
  static Future<List<ReturnedProduct>> getAllReturns() async {
    try {
      final box = await Hive.openBox<ReturnedProduct>(_returnsBoxName);
      return box.values.toList()
        ..sort((a, b) => b.returnDate.compareTo(a.returnDate));
    } catch (e) {
      debugPrint('Error getting all returns: $e');
      return [];
    }
  }

  // Get returns by date range
  static Future<List<ReturnedProduct>> getReturnsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final allReturns = await getAllReturns();
      return allReturns.where((returnItem) {
        final returnDate = returnItem.returnDate;
        return returnDate.isAfter(
              startDate.subtract(const Duration(days: 1)),
            ) &&
            returnDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    } catch (e) {
      debugPrint('Error getting returns by date range: $e');
      return [];
    }
  }

  // Get returns for today
  static Future<List<ReturnedProduct>> getTodayReturns() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return getReturnsByDateRange(startOfDay, endOfDay);
  }

  // Get returns for last week
  static Future<List<ReturnedProduct>> getLastWeekReturns() async {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));
    return getReturnsByDateRange(lastWeek, now);
  }

  // Get returns for last month
  static Future<List<ReturnedProduct>> getLastMonthReturns() async {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, now.day);
    return getReturnsByDateRange(lastMonth, now);
  }

  // Search products for return (by SKU or name)
  static List<Product> searchProductsForReturn(String query) {
    if (query.isEmpty) return [];

    final products = HiveService.getProducts();
    return products.where((product) {
      final nameMatch = product.name.toLowerCase().contains(
        query.toLowerCase(),
      );
      final skuMatch =
          product.sku?.toLowerCase().contains(query.toLowerCase()) ?? false;
      return nameMatch || skuMatch;
    }).toList();
  }

  // Get return statistics
  static Future<Map<String, dynamic>> getReturnStatistics() async {
    try {
      final allReturns = await getAllReturns();
      final todayReturns = await getTodayReturns();

      final totalReturns = allReturns.length;
      final todayReturnsCount = todayReturns.length;
      final totalReturnValue = allReturns.fold<double>(
        0.0,
        (sum, item) => sum + item.totalAmount,
      );
      final todayReturnValue = todayReturns.fold<double>(
        0.0,
        (sum, item) => sum + item.totalAmount,
      );

      return {
        'totalReturns': totalReturns,
        'todayReturns': todayReturnsCount,
        'totalReturnValue': totalReturnValue,
        'todayReturnValue': todayReturnValue,
        'averageReturnValue':
            totalReturns > 0 ? totalReturnValue / totalReturns : 0.0,
      };
    } catch (e) {
      debugPrint('Error getting return statistics: $e');
      return {
        'totalReturns': 0,
        'todayReturns': 0,
        'totalReturnValue': 0.0,
        'todayReturnValue': 0.0,
        'averageReturnValue': 0.0,
      };
    }
  }

  // Update return status
  static Future<bool> updateReturnStatus(
    String returnId,
    ReturnStatus newStatus,
  ) async {
    try {
      final box = await Hive.openBox<ReturnedProduct>(_returnsBoxName);
      final returnItem = box.get(returnId);

      if (returnItem != null) {
        returnItem.status = newStatus;
        await box.put(returnId, returnItem);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating return status: $e');
      return false;
    }
  }

  // Delete return record
  static Future<bool> deleteReturn(String returnId) async {
    try {
      final box = await Hive.openBox<ReturnedProduct>(_returnsBoxName);
      await box.delete(returnId);
      return true;
    } catch (e) {
      debugPrint('Error deleting return: $e');
      return false;
    }
  }

  // Get most returned products
  static Future<List<Map<String, dynamic>>> getMostReturnedProducts({
    int limit = 5,
  }) async {
    try {
      final allReturns = await getAllReturns();
      final Map<String, Map<String, dynamic>> productReturns = {};

      for (final returnItem in allReturns) {
        final productId = returnItem.productId;
        if (productReturns.containsKey(productId)) {
          productReturns[productId]!['count'] += returnItem.quantityReturned;
          productReturns[productId]!['totalValue'] += returnItem.totalAmount;
        } else {
          productReturns[productId] = {
            'productName': returnItem.productName,
            'productSku': returnItem.productSku,
            'count': returnItem.quantityReturned,
            'totalValue': returnItem.totalAmount,
          };
        }
      }

      final sortedProducts =
          productReturns.entries.toList()
            ..sort((a, b) => b.value['count'].compareTo(a.value['count']));

      return sortedProducts
          .take(limit)
          .map((entry) => {'productId': entry.key, ...entry.value})
          .toList();
    } catch (e) {
      debugPrint('Error getting most returned products: $e');
      return [];
    }
  }
}
