import 'package:hive/hive.dart';
import 'package:pos/core/models/products.dart';
import 'package:pos/core/services/hive_service.dart';
import 'package:pos/features/Home/Models/dashboard_data.dart';
import 'package:pos/features/invoice/model/order.dart';
import 'package:pos/features/Customer/Models/customer_model.dart';

class DashboardService {
  static final DashboardService _instance = DashboardService._internal();
  factory DashboardService() => _instance;
  DashboardService._internal();

  late Box<DashboardData> _dashboardBox;
  late Box<Order> _invoiceBox;
  late Box<Customer> _customerBox;
  late Box<Product> _productBox;
  late Box _transactionBox;

  /// ✅ Pehle constructor me call ho raha tha, ab explicit initialize use hoga
  Future<void> initialize() async {
    _dashboardBox = await HiveService.openDashboardBox();
    _invoiceBox = await Hive.openBox<Order>('ordersBox');
    _customerBox = await Hive.openBox<Customer>('customerBox');
    _productBox = await Hive.openBox<Product>('posBox');
    _transactionBox = await Hive.openBox('transactionsBox');
  }

  Future<void> loadDashboardData() async {
    final now = DateTime.now();
    final totalSales = _calculateTotalSales();
    final totalOrders = _invoiceBox.length;
    final totalCustomers = _customerBox.length;
    final lowStockItems = _calculateLowStockItems();
    final salesGrowth = _calculateSalesGrowth();
    final ordersGrowth = _calculateOrdersGrowth();
    final customersGrowth = _calculateCustomersGrowth();
    final dailySales = _getDailySales();
    final weeklySales = _getWeeklySales();
    final monthlySales = _getMonthlySales();
    final topProducts = _getTopProducts();
    final recentTransactions = _getRecentTransactions();

    final dashboardData = DashboardData(
      totalSales: totalSales,
      totalOrders: totalOrders,
      totalCustomers: totalCustomers,
      lowStockItems: lowStockItems,
      salesGrowth: salesGrowth,
      ordersGrowth: ordersGrowth,
      customersGrowth: customersGrowth,
      dailySales: dailySales,
      weeklySales: weeklySales,
      monthlySales: monthlySales,
      topProducts: topProducts,
      recentTransactions: recentTransactions,
      lastUpdated: now,
    );

    await _dashboardBox.put('current', dashboardData);
  }

  double _calculateTotalSales() {
    double total = 0;
    for (var invoice in _invoiceBox.values) {
      total += invoice.total;
    }
    return total;
  }

  int _calculateLowStockItems() {
    int count = 0;
    for (var product in _productBox.values) {
      if (product.stockQuantity < 10) {
        count++;
      }
    }
    return count;
  }

  double _calculateSalesGrowth() {
    final now = DateTime.now();
    final thisMonth = _getSalesForMonth(now);
    final lastMonth = _getSalesForMonth(DateTime(now.year, now.month - 1));
    if (lastMonth == 0) return 0;
    return ((thisMonth - lastMonth) / lastMonth) * 100;
  }

  double _calculateOrdersGrowth() {
    return 12.5; // Placeholder
  }

  double _calculateCustomersGrowth() {
    return 8.3; // Placeholder
  }

  double _getSalesForMonth(DateTime month) {
    double total = 0;
    for (var invoice in _invoiceBox.values) {
      if (invoice.date.month == month.month &&
          invoice.date.year == month.year) {
        total += invoice.total;
      }
    }
    return total;
  }

  List<SalesData> _getDailySales() {
    final sales = <SalesData>[];
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final amount = _getSalesForDay(date);
      sales.add(
        SalesData(period: _formatDay(date), amount: amount, date: date),
      );
    }
    return sales;
  }

  List<SalesData> _getWeeklySales() {
    final sales = <SalesData>[];
    final now = DateTime.now();
    for (int i = 3; i >= 0; i--) {
      final weekStart = now.subtract(Duration(days: i * 7 + now.weekday - 1));
      final amount = _getSalesForWeek(weekStart);
      sales.add(
        SalesData(period: 'Week ${4 - i}', amount: amount, date: weekStart),
      );
    }
    return sales;
  }

  List<SalesData> _getMonthlySales() {
    final sales = <SalesData>[];
    final now = DateTime.now();
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i);
      final amount = _getSalesForMonth(month);
      sales.add(
        SalesData(period: _formatMonth(month), amount: amount, date: month),
      );
    }
    return sales;
  }

  double _getSalesForDay(DateTime day) {
    double total = 0;
    for (var invoice in _invoiceBox.values) {
      if (invoice.date.day == day.day &&
          invoice.date.month == day.month &&
          invoice.date.year == day.year) {
        total += invoice.total;
      }
    }
    return total;
  }

  double _getSalesForWeek(DateTime weekStart) {
    double total = 0;
    final weekEnd = weekStart.add(const Duration(days: 7));
    for (var invoice in _invoiceBox.values) {
      if (invoice.date.isAfter(weekStart) && invoice.date.isBefore(weekEnd)) {
        total += invoice.total;
      }
    }
    return total;
  }

  String _formatDay(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _formatMonth(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date.month - 1];
  }

  List<TopProduct> _getTopProducts() {
    final productSales = <String, Map<String, dynamic>>{};
    for (var invoice in _invoiceBox.values) {
      for (var item in invoice.products) {
        final product = item['product'] as Product;
        final productName = product.name;
        if (!productSales.containsKey(productName)) {
          productSales[productName] = {
            'quantity': 0,
            'revenue': 0.0,
            'category': product.category,
          };
        }
        productSales[productName]!['quantity'] += item['quantity'] as int;
        productSales[productName]!['revenue'] +=
            (item['quantity'] as int) * product.sellingPrice;
      }
    }

    final sorted =
        productSales.entries.toList()
          ..sort((a, b) => b.value['revenue'].compareTo(a.value['revenue']));
    return sorted
        .take(5)
        .map(
          (e) => TopProduct(
            name: e.key,
            quantity: e.value['quantity'],
            revenue: e.value['revenue'],
            category: e.value['category'],
          ),
        )
        .toList();
  }

  List<RecentTransaction> _getRecentTransactions() {
    final transactions =
        _transactionBox.values
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList()
          ..sort(
            (a, b) =>
                DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])),
          );
    return transactions
        .take(10)
        .map(
          (t) => RecentTransaction(
            id: t['orderId'] as String,
            customerName: t['customerName'] as String,
            amount: (t['total'] as num).toDouble(),
            status: 'Completed', // Default (transactionsBox me status nahi hai)
            date: DateTime.parse(t['date'] as String),
            paymentMethod: 'Unknown', // Agar paymentMethod store nahi hai
          ),
        )
        .toList();
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }
}
