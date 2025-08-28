import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:pos/core/models/products.dart';
import 'package:pos/features/invoice/model/order.dart';
import 'package:flutter/foundation.dart';
import 'package:pos/features/Customer/Models/customer_model.dart';
import 'package:pos/features/auth/models/user_model.dart';
import 'package:pos/features/auth/models/license_model.dart';
import 'package:pos/features/auth/models/business_info_model.dart';
// ...existing code...
import 'package:pos/features/Home/Models/dashboard_data.dart'; // Add this import

class HiveService {
  static const String locationBoxName = 'locationBox';
  static const String productBoxName = 'posBox';
  static const String orderBoxName = 'ordersBox';
  static const String transactionBoxName = 'transactionsBox';
  static const String draftOrderBoxName = 'draftOrdersBox';
  static const String locationKey = 'currentLocation';
  static const String customerBoxName = 'customerBox';
  static const String userBoxName = 'userBox';
  static const String licenseBoxName = 'licenseBox';
  static const String dashboardBoxName = 'dashboard'; // Add this

  static Box<Product>? _productsBox;
  static Box<Order>? _ordersBox;
  static Box? _locationBox;
  static Box? _transactionsBox;
  static Box<Order>? _draftOrderBox;

  // Add these static methods
  static Future<dynamic> openDashboardBox() async {
    if (Hive.isBoxOpen('dashboard')) {
      return Hive.box<DashboardData>('dashboard');
    }
    return await Hive.openBox<DashboardData>('dashboard');
  }

  static Future<dynamic> openOrdersBox() async {
    if (!Hive.isBoxOpen('ordersBox')) {
      return await Hive.openBox<Order>('ordersBox');
    }
    return Hive.box<Order>('ordersBox');
  }

  static Future<dynamic> openCustomerBox() async {
    if (!Hive.isBoxOpen('customerBox')) {
      return await Hive.openBox<Customer>('customerBox');
    }
    return Hive.box<Customer>('customerBox');
  }

  static Future<dynamic> openProductBox() async {
    if (!Hive.isBoxOpen('posBox')) {
      return await Hive.openBox<Product>('posBox');
    }
    return Hive.box<Product>('posBox');
  }

  // Modify the init method to open these boxes
  static Future<void> init() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);

    // Register all Hive adapters
    Hive.registerAdapter(ProductAdapter()); // typeId: 0
    Hive.registerAdapter(CustomerAdapter()); // typeId: 1
    Hive.registerAdapter(OrderAdapter()); // typeId: 2
    Hive.registerAdapter(UserModelAdapter()); // typeId: 3
    Hive.registerAdapter(LicenseModelAdapter()); // typeId: 4
    Hive.registerAdapter(
      BusinessInfoModelAdapter(),
    ); // register business info adapter

    // Dashboard data adapters
    Hive.registerAdapter(DashboardDataAdapter());
    Hive.registerAdapter(SalesDataAdapter());
    Hive.registerAdapter(TopProductAdapter());
    Hive.registerAdapter(RecentTransactionAdapter());

    // Open all boxes
    _productsBox = await openProductBox();
    _ordersBox = await openOrdersBox();
    _locationBox = await Hive.openBox(locationBoxName);
    _transactionsBox = await Hive.openBox(transactionBoxName);
    _draftOrderBox = await Hive.openBox<Order>(draftOrderBoxName);

    // Open the dashboard and customer boxes
    await openDashboardBox();
    await openCustomerBox();
  }

  // Existing methods (unchanged)
  static Future<void> saveLocation(String location) async {
    if (_locationBox == null) return;
    await _locationBox!.put(locationKey, location);
  }

  static String? getLocation() {
    if (_locationBox == null) return null;
    return _locationBox!.get(locationKey) as String?;
  }

  static Future<void> addProduct(Product product) async {
    if (_productsBox == null) return;
    await _productsBox!.put(product.id, product);
  }

  static List<Product> getProducts() {
    if (_productsBox == null) return [];
    return _productsBox!.values.cast<Product>().toList();
  }

  static Future<void> updateProduct(Product product) async {
    if (_productsBox == null) return;
    await _productsBox!.put(product.id, product);
  }

  static Future<void> deleteProduct(String id) async {
    if (_productsBox == null) return;
    await _productsBox!.delete(id);
  }

  static Future<void> toggleFavorite(String id) async {
    if (_productsBox == null) return;
    final product = _productsBox!.get(id);
    if (product != null) {
      await _productsBox!.put(
        id,
        product.copyWith(favorite: !product.favorite),
      );
    }
  }

  static Future<void> saveOrder(Order order) async {
    if (_ordersBox == null || _productsBox == null) return;
    await _ordersBox!.put(order.id, order);
    for (var item in order.products) {
      final product = item['product'] as Product;
      final newStock = product.stockQuantity - (item['quantity'] as int);
      if (newStock >= 0) {
        await _productsBox!.put(
          product.id,
          product.copyWith(stockQuantity: newStock),
        );
      } else {
        throw Exception('Insufficient stock for product: ${product.name}');
      }
    }
    _logTransaction(order);
  }

  static List<Order> getOrders() {
    if (_ordersBox == null) return [];
    return _ordersBox!.values.cast<Order>().toList();
  }

  static Future<void> deleteOrder(String orderId) async {
    debugPrint('HiveService: Attempting to delete order with ID: $orderId');
    if (_ordersBox == null) {
      debugPrint('HiveService: _ordersBox is null, cannot delete order.');
      return;
    }
    await _ordersBox!.delete(orderId);
    debugPrint('HiveService: Order $orderId deleted.');
    if (_transactionsBox != null) {
      final transactionsMap = _transactionsBox!.toMap();
      final keysToDelete =
          transactionsMap.entries
              .where((entry) => entry.value['orderId'] == orderId)
              .map((entry) => entry.key)
              .toList();
      for (var key in keysToDelete) {
        await _transactionsBox!.delete(key);
        debugPrint('HiveService: Deleted transaction with key: $key');
      }
    }
  }

  static Future<void> saveDraftOrder(Order order) async {
    if (_draftOrderBox == null) return;
    await _draftOrderBox!.put('currentDraftOrder', order);
  }

  static Order? getDraftOrder() {
    if (_draftOrderBox == null) return null;
    return _draftOrderBox!.get('currentDraftOrder');
  }

  static Future<void> clearDraftOrder() async {
    if (_draftOrderBox == null) return;
    await _draftOrderBox!.delete('currentDraftOrder');
  }

  static void _logTransaction(Order order) {
    if (_transactionsBox == null) return;
    final transaction = {
      'orderId': order.id,
      'customerName': order.customerName,
      'total': order.total,
      'date': order.date.toIso8601String(),
    };
    _transactionsBox!.add(transaction);
  }

  static List<Map<String, dynamic>> getTransactions() {
    if (_transactionsBox == null) return [];
    return _transactionsBox!.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }
}
