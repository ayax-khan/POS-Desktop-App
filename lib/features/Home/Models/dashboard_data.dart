// lib/features/Home/models/dashboard_data.dart
import 'package:hive/hive.dart';

part 'dashboard_data.g.dart';

@HiveType(typeId: 10)
class DashboardData extends HiveObject {
  @HiveField(0)
  double totalSales;

  @HiveField(1)
  int totalOrders;

  @HiveField(2)
  int totalCustomers;

  @HiveField(3)
  int lowStockItems;

  @HiveField(4)
  double salesGrowth;

  @HiveField(5)
  double ordersGrowth;

  @HiveField(6)
  double customersGrowth;

  @HiveField(7)
  List<SalesData> dailySales;

  @HiveField(8)
  List<SalesData> weeklySales;

  @HiveField(9)
  List<SalesData> monthlySales;

  @HiveField(10)
  List<TopProduct> topProducts;

  @HiveField(11)
  List<RecentTransaction> recentTransactions;

  @HiveField(12)
  DateTime lastUpdated;

  DashboardData({
    required this.totalSales,
    required this.totalOrders,
    required this.totalCustomers,
    required this.lowStockItems,
    required this.salesGrowth,
    required this.ordersGrowth,
    required this.customersGrowth,
    required this.dailySales,
    required this.weeklySales,
    required this.monthlySales,
    required this.topProducts,
    required this.recentTransactions,
    required this.lastUpdated,
  });

  factory DashboardData.empty() => DashboardData(
    totalSales: 0,
    totalOrders: 0,
    totalCustomers: 0,
    lowStockItems: 0,
    salesGrowth: 0,
    ordersGrowth: 0,
    customersGrowth: 0,
    dailySales: [],
    weeklySales: [],
    monthlySales: [],
    topProducts: [],
    recentTransactions: [],
    lastUpdated: DateTime.now(),
  );
}

@HiveType(typeId: 11)
class SalesData extends HiveObject {
  @HiveField(0)
  String period;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  SalesData({required this.period, required this.amount, required this.date});
}

@HiveType(typeId: 12)
class TopProduct extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  double revenue;

  @HiveField(3)
  String category;

  TopProduct({
    required this.name,
    required this.quantity,
    required this.revenue,
    required this.category,
  });
}

@HiveType(typeId: 13)
class RecentTransaction extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String customerName;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String status;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String paymentMethod;

  RecentTransaction({
    required this.id,
    required this.customerName,
    required this.amount,
    this.status = 'Completed',
    required this.date,
    this.paymentMethod = 'Cash',
  });
}
