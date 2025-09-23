import 'dart:io';
import 'dart:math';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pos/features/Customer/Models/customer_model.dart';
import 'package:pos/core/models/products.dart';
import 'package:pos/features/Reports/Models/revenue_data.dart';
import 'package:pos/features/invoice/model/order.dart'; // Import Order
import 'package:ulid/ulid.dart';

class ReportsService {
  static const String _orderBoxName =
      'ordersBox'; // Adjusted to match HiveService
  static const String _customerBoxName = 'customers';
  static const String _productBoxName =
      'posBox'; // From HiveService, it's 'posBox' for products

  // Initialize Hive and register adapters
  static Future<void> init() async {
    try {
      // Assuming adapters are registered in main or HiveService.init()
      // No need to register here if done elsewhere

      // Open boxes if not already opened
      if (!Hive.isBoxOpen(_orderBoxName)) {
        await Hive.openBox<Order>(_orderBoxName);
      }
      if (!Hive.isBoxOpen(_customerBoxName)) {
        await Hive.openBox<Customer>(_customerBoxName);
      }
      if (!Hive.isBoxOpen(_productBoxName)) {
        await Hive.openBox<Product>(_productBoxName);
      }

      // Add sample data for demo
      await _addSampleDataIfNeeded();
    } catch (e) {
      debugPrint('Error initializing ReportsService: $e');
      rethrow;
    }
  }

  static Future<RevenueData> getRevenueData({
    required String period,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final now = DateTime.now();
      DateTime calcStart;
      DateTime calcEnd;

      // Calculate date range based on period
      final dateRange = _calculateDateRange(period, startDate, endDate, now);
      calcStart = dateRange['start']!;
      calcEnd = dateRange['end']!;

      // Get orders and other data
      final orders = await _getOrders(calcStart, calcEnd);
      final customers = await _getCustomers();
      final products = await _getProducts();

      // Calculate current period metrics
      final totalRevenue = _calculateTotalRevenue(orders);
      final totalProducts = orders.fold<int>(0, (sum, o) {
        if (o.status == 'completed') {
          return sum +
              o.products.fold<int>(
                0,
                (s, item) => s + (item['quantity'] as int),
              );
        }
        return sum;
      });
      final totalCustomers = _getUniqueCustomers(orders).length;
      final returnRate = _calculateReturnRate(orders);

      // Calculate previous period for comparison
      final periodDays =
          calcEnd.difference(calcStart).inDays + 1; // Adjust for inclusive days
      final previousStart = calcStart.subtract(Duration(days: periodDays));
      final previousEnd = calcEnd.subtract(Duration(days: periodDays));
      final previousOrders = await _getOrders(previousStart, previousEnd);

      // Previous period metrics
      final previousRevenue = _calculateTotalRevenue(previousOrders);
      final previousProducts = previousOrders.fold<int>(0, (sum, o) {
        if (o.status == 'completed') {
          return sum +
              o.products.fold<int>(
                0,
                (s, item) => s + (item['quantity'] as int),
              );
        }
        return sum;
      });
      final previousCustomers = _getUniqueCustomers(previousOrders).length;
      final previousReturnRate = _calculateReturnRate(previousOrders);

      // Week over week comparison
      final weekPreviousStart = calcStart.subtract(const Duration(days: 7));
      final weekPreviousEnd = calcEnd.subtract(const Duration(days: 7));
      final weekPreviousOrders = await _getOrders(
        weekPreviousStart,
        weekPreviousEnd,
      );

      final weekPreviousRevenue = _calculateTotalRevenue(weekPreviousOrders);
      final weekPreviousProducts = weekPreviousOrders.fold<int>(0, (sum, o) {
        if (o.status == 'completed') {
          return sum +
              o.products.fold<int>(
                0,
                (s, item) => s + (item['quantity'] as int),
              );
        }
        return sum;
      });
      final weekPreviousCustomers =
          _getUniqueCustomers(weekPreviousOrders).length;
      final weekPreviousReturnRate = _calculateReturnRate(weekPreviousOrders);

      // Percentage changes
      final revenuePreviousChange = _calculatePercentageChange(
        totalRevenue,
        previousRevenue,
      );
      final revenueWowChange = _calculatePercentageChange(
        totalRevenue,
        weekPreviousRevenue,
      );
      final productsPreviousChange = _calculatePercentageChange(
        totalProducts.toDouble(),
        previousProducts.toDouble(),
      );
      final productsWowChange = _calculatePercentageChange(
        totalProducts.toDouble(),
        weekPreviousProducts.toDouble(),
      );
      final customersPreviousChange = _calculatePercentageChange(
        totalCustomers.toDouble(),
        previousCustomers.toDouble(),
      );
      final customersWowChange = _calculatePercentageChange(
        totalCustomers.toDouble(),
        weekPreviousCustomers.toDouble(),
      );
      final returnsPreviousChange = _calculatePercentageChange(
        returnRate,
        previousReturnRate,
      );
      final returnsWowChange = _calculatePercentageChange(
        returnRate,
        weekPreviousReturnRate,
      );

      // Generate period-specific chart data
      final isSingleDay = _isSingleDayPeriod(period);
      final chartData = _generateChartData(
        orders,
        isSingleDay,
        period,
        calcStart,
        calcEnd,
      );
      final visitorsData = _generateVisitorsData(
        orders,
        isSingleDay,
        period,
        calcStart,
        calcEnd,
      );
      final productsData = _generateProductsData(
        orders,
        isSingleDay,
        period,
        calcStart,
        calcEnd,
      );

      // Get top customers and products
      final topCustomers = _getTopCustomers(orders, customers);
      final topProducts = _getTopProducts(orders, products);

      // Get period-specific hourly/time-based revenue
      final hourlyRevenue = _getTimeBasedRevenue(
        orders,
        period,
        calcStart,
        calcEnd,
      );

      // Calculate insights
      final bestSalesDay = _getBestSalesDay(orders, period);
      final peakSaleData = _getPeakSaleHour(orders);
      final lowStockCount = _getLowStockCount(products);

      return RevenueData(
        totalRevenue: totalRevenue,
        totalProducts: totalProducts,
        totalCustomers: totalCustomers,
        returnRate: returnRate,
        revenuePreviousDayChange: revenuePreviousChange,
        revenueWeekOverWeekChange: revenueWowChange,
        productsPreviousDayChange: productsPreviousChange,
        productsWeekOverWeekChange: productsWowChange,
        customersPreviousDayChange: customersPreviousChange,
        customersWeekOverWeekChange: customersWowChange,
        returnsPreviousDayChange: returnsPreviousChange,
        returnsWeekOverWeekChange: returnsWowChange,
        chartData: chartData,
        visitorsData: visitorsData,
        productsData: productsData,
        topCustomers: topCustomers,
        topProducts: topProducts,
        hourlyRevenue: hourlyRevenue,
        bestSalesDay: bestSalesDay,
        peakSaleHour: peakSaleData['hour']!,
        peakSaleAmount: double.tryParse(peakSaleData['amount']!) ?? 0.0,
        lowStockCount: lowStockCount,
      );
    } catch (e) {
      debugPrint('Error getting revenue data: $e');
      return _getDefaultRevenueData();
    }
  }

  static Map<String, DateTime> _calculateDateRange(
    String period,
    DateTime? startDate,
    DateTime? endDate,
    DateTime now,
  ) {
    DateTime calcStart;
    DateTime calcEnd;

    if (period == 'Custom') {
      if (startDate == null || endDate == null) {
        throw Exception('Start and end dates required for custom period');
      }
      calcStart = DateTime(startDate.year, startDate.month, startDate.day);
      calcEnd = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    } else {
      switch (period) {
        case 'Today':
          calcStart = DateTime(now.year, now.month, now.day);
          calcEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
          break;
        case 'Yesterday':
          final yesterday = now.subtract(const Duration(days: 1));
          calcStart = DateTime(yesterday.year, yesterday.month, yesterday.day);
          calcEnd = DateTime(
            yesterday.year,
            yesterday.month,
            yesterday.day,
            23,
            59,
            59,
          );
          break;
        case 'Last Week':
          final weekStart = now.subtract(Duration(days: now.weekday - 1 + 7));
          calcStart = DateTime(weekStart.year, weekStart.month, weekStart.day);
          calcEnd = calcStart.add(
            const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
          );
          break;
        case 'Last Month':
          final lastMonth = DateTime(now.year, now.month - 1, 1);
          calcStart = lastMonth;
          calcEnd = DateTime(now.year, now.month, 0, 23, 59, 59);
          break;
        default:
          calcStart = now.subtract(const Duration(days: 30));
          calcEnd = now;
      }
    }

    return {'start': calcStart, 'end': calcEnd};
  }

  static bool _isSingleDayPeriod(String period) {
    return period == 'Today' || period == 'Yesterday';
  }

  static List<ChartDataPoint> _generateChartData(
    List<Order> orders,
    bool isSingleDay,
    String period,
    DateTime start,
    DateTime end,
  ) {
    if (orders.isEmpty) return [];

    if (isSingleDay) {
      // Hourly data for today/yesterday
      final Map<int, double> hourRevenue = {};
      for (var o in orders) {
        if (o.status == 'completed') {
          final hour = o.date.hour;
          hourRevenue.update(hour, (v) => v + o.total, ifAbsent: () => o.total);
        }
      }
      return hourRevenue.entries
          .map(
            (e) =>
                ChartDataPoint(date: DateTime(0, 0, 0, e.key), value: e.value),
          )
          .toList()
        ..sort((a, b) => a.date.hour.compareTo(b.date.hour));
    } else {
      // Daily data for week/month/custom
      final Map<DateTime, double> dayRevenue = {};
      for (var o in orders) {
        if (o.status == 'completed') {
          final day = DateTime(o.date.year, o.date.month, o.date.day);
          dayRevenue.update(day, (v) => v + o.total, ifAbsent: () => o.total);
        }
      }

      // Fill in missing days with zero values
      final result = <ChartDataPoint>[];
      final current = DateTime(start.year, start.month, start.day);
      final endDay = DateTime(end.year, end.month, end.day);

      for (
        var day = current;
        !day.isAfter(endDay);
        day = day.add(const Duration(days: 1))
      ) {
        final revenue = dayRevenue[day] ?? 0.0;
        result.add(ChartDataPoint(date: day, value: revenue));
      }

      return result;
    }
  }

  static List<ChartDataPoint> _generateVisitorsData(
    List<Order> orders,
    bool isSingleDay,
    String period,
    DateTime start,
    DateTime end,
  ) {
    if (orders.isEmpty) return [];

    if (isSingleDay) {
      final Map<int, Set<String>> hourVisitors = {};
      for (var o in orders) {
        final hour = o.date.hour;
        hourVisitors.update(
          hour,
          (s) => s..add(o.customerName),
          ifAbsent: () => {o.customerName},
        );
      }
      return hourVisitors.entries
          .map(
            (e) => ChartDataPoint(
              date: DateTime(0, 0, 0, e.key),
              value: e.value.length.toDouble(),
            ),
          )
          .toList()
        ..sort((a, b) => a.date.hour.compareTo(b.date.hour));
    } else {
      final Map<DateTime, Set<String>> dayVisitors = {};
      for (var o in orders) {
        final day = DateTime(o.date.year, o.date.month, o.date.day);
        dayVisitors.update(
          day,
          (s) => s..add(o.customerName),
          ifAbsent: () => {o.customerName},
        );
      }

      // Fill in missing days
      final result = <ChartDataPoint>[];
      final current = DateTime(start.year, start.month, start.day);
      final endDay = DateTime(end.year, end.month, end.day);

      for (
        var day = current;
        !day.isAfter(endDay);
        day = day.add(const Duration(days: 1))
      ) {
        final visitors = dayVisitors[day]?.length ?? 0;
        result.add(ChartDataPoint(date: day, value: visitors.toDouble()));
      }

      return result;
    }
  }

  static List<ChartDataPoint> _generateProductsData(
    List<Order> orders,
    bool isSingleDay,
    String period,
    DateTime start,
    DateTime end,
  ) {
    if (orders.isEmpty) return [];

    if (isSingleDay) {
      // Hourly data for today/yesterday
      final Map<int, double> hourProducts = {};
      for (var o in orders) {
        if (o.status == 'completed') {
          final hour = o.date.hour;
          final qty = o.products.fold(
            0,
            (sum, item) => sum + (item['quantity'] as int),
          );
          hourProducts.update(
            hour,
            (v) => v + qty.toDouble(),
            ifAbsent: () => qty.toDouble(),
          );
        }
      }
      return hourProducts.entries
          .map(
            (e) =>
                ChartDataPoint(date: DateTime(0, 0, 0, e.key), value: e.value),
          )
          .toList()
        ..sort((a, b) => a.date.hour.compareTo(b.date.hour));
    } else {
      // Daily data for week/month/custom
      final Map<DateTime, double> dayProducts = {};
      for (var o in orders) {
        if (o.status == 'completed') {
          final day = DateTime(o.date.year, o.date.month, o.date.day);
          final qty = o.products.fold(
            0,
            (sum, item) => sum + (item['quantity'] as int),
          );
          dayProducts.update(
            day,
            (v) => v + qty.toDouble(),
            ifAbsent: () => qty.toDouble(),
          );
        }
      }

      // Fill in missing days with zero values
      final result = <ChartDataPoint>[];
      final current = DateTime(start.year, start.month, start.day);
      final endDay = DateTime(end.year, end.month, end.day);

      for (
        var day = current;
        !day.isAfter(endDay);
        day = day.add(const Duration(days: 1))
      ) {
        final productsQty = dayProducts[day] ?? 0.0;
        result.add(ChartDataPoint(date: day, value: productsQty));
      }

      return result;
    }
  }

  static List<HourlyRevenue> _getTimeBasedRevenue(
    List<Order> orders,
    String period,
    DateTime start,
    DateTime end,
  ) {
    if (period == 'Today' || period == 'Yesterday') {
      return _getHourlyRevenue(orders, true);
    } else if (period == 'Last Month') {
      return _getWeeklyRevenue(orders, start, end);
    } else {
      return _getDailyRevenue(orders, start, end);
    }
  }

  static List<HourlyRevenue> _getHourlyRevenue(
    List<Order> orders,
    bool isSingleDay,
  ) {
    final Map<int, double> hourMap = {};
    for (var o in orders) {
      if (o.status == 'completed') {
        final h = o.date.hour;
        hourMap.update(h, (v) => v + o.total, ifAbsent: () => o.total);
      }
    }

    final List<HourlyRevenue> hourly = [];
    if (isSingleDay) {
      final currentHour = DateTime.now().hour;
      final startHour = max(0, currentHour - 6);
      for (int i = startHour; i <= min(23, currentHour + 1); i++) {
        final amt = hourMap[i] ?? 0.0;
        final hourStr = '${i.toString().padLeft(2, '0')}:00';
        hourly.add(HourlyRevenue(hour: hourStr, amount: amt));
      }
    }
    return hourly;
  }

  static List<HourlyRevenue> _getDailyRevenue(
    List<Order> orders,
    DateTime start,
    DateTime end,
  ) {
    final Map<DateTime, double> dayMap = {};
    for (var o in orders) {
      if (o.status == 'completed') {
        final day = DateTime(o.date.year, o.date.month, o.date.day);
        dayMap.update(day, (v) => v + o.total, ifAbsent: () => o.total);
      }
    }

    final List<HourlyRevenue> daily = [];
    final current = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);

    for (
      var day = current;
      !day.isAfter(endDay);
      day = day.add(const Duration(days: 1))
    ) {
      final amt = dayMap[day] ?? 0.0;
      final dayStr = '${day.day}/${day.month}';
      daily.add(HourlyRevenue(hour: dayStr, amount: amt));
    }

    return daily.take(10).toList(); // Limit to last 10 days
  }

  static List<HourlyRevenue> _getWeeklyRevenue(
    List<Order> orders,
    DateTime start,
    DateTime end,
  ) {
    final Map<int, double> weekMap = {};
    for (var o in orders) {
      if (o.status == 'completed') {
        final weekNumber = ((o.date.difference(start).inDays) / 7).floor();
        weekMap.update(weekNumber, (v) => v + o.total, ifAbsent: () => o.total);
      }
    }

    final List<HourlyRevenue> weekly = [];
    final totalWeeks = ((end.difference(start).inDays) / 7).ceil();

    for (int i = 0; i < min(4, totalWeeks); i++) {
      final amt = weekMap[i] ?? 0.0;
      final weekStr = 'Week ${i + 1}';
      weekly.add(HourlyRevenue(hour: weekStr, amount: amt));
    }

    return weekly;
  }

  // Helper methods (keeping existing ones)
  static Future<List<Order>> _getOrders(DateTime start, DateTime end) async {
    try {
      final box = Hive.box<Order>(_orderBoxName);
      return box.values
          .where((o) => !o.date.isBefore(start) && !o.date.isAfter(end))
          .toList();
    } catch (e) {
      debugPrint('Error getting orders: $e');
      return [];
    }
  }

  static Future<List<Customer>> _getCustomers() async {
    try {
      final box = Hive.box<Customer>(_customerBoxName);
      return box.values.toList();
    } catch (e) {
      debugPrint('Error getting customers: $e');
      return [];
    }
  }

  static Future<List<Product>> _getProducts() async {
    try {
      final box = Hive.box<Product>(_productBoxName);
      return box.values.toList();
    } catch (e) {
      debugPrint('Error getting products: $e');
      return [];
    }
  }

  static double _calculateTotalRevenue(List<Order> orders) {
    return orders.fold(0.0, (sum, o) {
      if (o.status == 'completed') {
        return sum + o.total;
      }
      return sum;
    });
  }

  static Set<String> _getUniqueCustomers(List<Order> orders) {
    return orders.map((o) => o.customerName).toSet();
  }

  static double _calculateReturnRate(List<Order> orders) {
    if (orders.isEmpty) return 0.0;
    final refundedAmount = orders.fold(0.0, (sum, o) {
      if (o.status == 'refunded') {
        return sum + o.total;
      }
      return sum;
    });
    final totalRevenue = _calculateTotalRevenue(orders);
    return totalRevenue > 0 ? (refundedAmount / totalRevenue) * 100 : 0.0;
  }

  static double _calculatePercentageChange(double current, double previous) {
    if (previous == 0) return current > 0 ? 100.0 : 0.0;
    return ((current - previous) / previous) * 100;
  }

  static List<TopCustomer> _getTopCustomers(
    List<Order> orders,
    List<Customer> customers,
  ) {
    final Map<String, double> customerAmounts = {};
    for (var o in orders) {
      if (o.status == 'completed') {
        customerAmounts.update(
          o.customerName,
          (v) => v + o.total,
          ifAbsent: () => o.total,
        );
      }
    }

    final sorted =
        customerAmounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final top5 = sorted.take(5);
    // Since customer IDs are not in Order, use name directly; if needed, match name to customer box
    return top5.map((e) => TopCustomer(name: e.key, amount: e.value)).toList();
  }

  static List<TopProduct> _getTopProducts(
    List<Order> orders,
    List<Product> products,
  ) {
    final Map<String, Map<String, dynamic>> productStats = {};
    for (var o in orders) {
      if (o.status == 'completed') {
        for (var item in o.products) {
          final product = item['product'] as Product;
          final quantity = item['quantity'] as int;
          final id = product.id;
          final entry = productStats[id] ?? {'units': 0, 'amount': 0.0};
          entry['units'] += quantity;
          entry['amount'] += product.sellingPrice * quantity;
          productStats[id] = entry;
        }
      }
    }

    final sorted =
        productStats.entries.toList()
          ..sort((a, b) => b.value['amount'].compareTo(a.value['amount']));
    final top5 = sorted.take(5);
    final productMap = {
      for (var p in products) p.id: {'name': p.name, 'sku': p.sku},
    };

    return top5.map((e) {
      final info =
          productMap[e.key] ?? {'name': 'Product ${e.key}', 'sku': null};
      return TopProduct(
        name: info['name'] ?? 'Unknown Product',
        units: e.value['units'],
        amount: e.value['amount'],
        sku: info['sku'],
      );
    }).toList();
  }

  static String _getBestSalesDay(List<Order> orders, String period) {
    if (orders.isEmpty) return 'N/A';

    final Map<DateTime, double> dayMap = {};
    for (var o in orders) {
      if (o.status == 'completed') {
        final day = DateTime(o.date.year, o.date.month, o.date.day);
        dayMap.update(day, (v) => v + o.total, ifAbsent: () => o.total);
      }
    }

    if (dayMap.isEmpty) return 'N/A';
    final maxDay = dayMap.entries.reduce((a, b) => a.value > b.value ? a : b);

    final weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final monthAbbr = [
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
    return '${weekdayNames[maxDay.key.weekday - 1]}, ${monthAbbr[maxDay.key.month - 1]} ${maxDay.key.day}';
  }

  static Map<String, String> _getPeakSaleHour(List<Order> orders) {
    final Map<int, double> hourMap = {};
    for (var o in orders) {
      if (o.status == 'completed') {
        final h = o.date.hour;
        hourMap.update(h, (v) => v + o.total, ifAbsent: () => o.total);
      }
    }

    if (hourMap.isEmpty) return {'hour': 'N/A', 'amount': '0'};
    final maxEntry = hourMap.entries.reduce(
      (a, b) => a.value > b.value ? a : b,
    );
    final hourStr = '${maxEntry.key.toString().padLeft(2, '0')}:00';
    return {'hour': hourStr, 'amount': maxEntry.value.toStringAsFixed(2)};
  }

  static int _getLowStockCount(List<Product> products) {
    const threshold = 10;
    return products.where((p) => p.stockQuantity < threshold).length;
  }

  static RevenueData _getDefaultRevenueData() {
    return RevenueData(
      totalRevenue: 0.0,
      totalProducts: 0,
      totalCustomers: 0,
      returnRate: 0.0,
      revenuePreviousDayChange: 0.0,
      revenueWeekOverWeekChange: 0.0,
      productsPreviousDayChange: 0.0,
      productsWeekOverWeekChange: 0.0,
      customersPreviousDayChange: 0.0,
      customersWeekOverWeekChange: 0.0,
      returnsPreviousDayChange: 0.0,
      returnsWeekOverWeekChange: 0.0,
      chartData: [],
      visitorsData: [],
      topCustomers: [],
      topProducts: [],
      productsData: [],
      hourlyRevenue: [],
      bestSalesDay: 'N/A',
      peakSaleHour: 'N/A',
      peakSaleAmount: 0.0,
      lowStockCount: 0,
    );
  }

  static Future<String> exportRevenueReport(
    RevenueData data,
    String period,
  ) async {
    try {
      List<List<dynamic>> csvData = [];

      // Report Header
      csvData.add(['Revenue Report - $period']);
      csvData.add(['Generated on: ${DateTime.now().toString()}']);
      csvData.add([]);

      // Key Metrics
      csvData.add(['Key Metrics']);
      csvData.add([
        'Metric',
        'Value',
        'Previous Period Change (%)',
        'Week over Week Change (%)',
      ]);
      csvData.add([
        'Revenue (PKR)',
        data.totalRevenue.toStringAsFixed(2),
        data.revenuePreviousDayChange.toStringAsFixed(1),
        data.revenueWeekOverWeekChange.toStringAsFixed(1),
      ]);
      csvData.add([
        'Products Sold',
        data.totalProducts,
        data.productsPreviousDayChange.toStringAsFixed(1),
        data.productsWeekOverWeekChange.toStringAsFixed(1),
      ]);
      csvData.add([
        'Customers',
        data.totalCustomers,
        data.customersPreviousDayChange.toStringAsFixed(1),
        data.customersWeekOverWeekChange.toStringAsFixed(1),
      ]);
      csvData.add([
        'Return Rate (%)',
        data.returnRate.toStringAsFixed(2),
        data.returnsPreviousDayChange.toStringAsFixed(1),
        data.returnsWeekOverWeekChange.toStringAsFixed(1),
      ]);
      csvData.add([]);

      // Top Customers
      csvData.add(['Top Customers']);
      csvData.add(['Rank', 'Name', 'Total Amount (PKR)']);
      for (int i = 0; i < data.topCustomers.length; i++) {
        final customer = data.topCustomers[i];
        csvData.add([i + 1, customer.name, customer.amount.toStringAsFixed(2)]);
      }
      csvData.add([]);

      // Top Products
      csvData.add(['Top Products']);
      csvData.add(['Rank', 'Name', 'SKU', 'Units Sold', 'Revenue (PKR)']);
      for (int i = 0; i < data.topProducts.length; i++) {
        final product = data.topProducts[i];
        csvData.add([
          i + 1,
          product.name,
          product.sku ?? 'N/A',
          product.units,
          product.amount.toStringAsFixed(2),
        ]);
      }
      csvData.add([]);

      // Time-based Revenue
      final timeLabel =
          period == 'Last Month'
              ? 'Weekly Revenue'
              : (period == 'Today' || period == 'Yesterday')
              ? 'Hourly Revenue'
              : 'Daily Revenue';
      csvData.add([timeLabel]);
      csvData.add(['Period', 'Revenue (PKR)']);
      for (var hourly in data.hourlyRevenue) {
        csvData.add([hourly.hour, hourly.amount.toStringAsFixed(2)]);
      }
      csvData.add([]);

      // Sales Insights
      csvData.add(['Sales Insights']);
      csvData.add(['Best Sales Day', data.bestSalesDay]);
      csvData.add(['Peak Sales Hour', data.peakSaleHour]);
      csvData.add([
        'Peak Hour Revenue (PKR)',
        data.peakSaleAmount.toStringAsFixed(2),
      ]);
      csvData.add(['Low Stock Items Count', data.lowStockCount]);

      // Convert to CSV
      String csv = const ListToCsvConverter().convert(csvData);

      // Save file
      Directory directory = await getApplicationDocumentsDirectory();
      String fileName =
          'revenue_report_${period.toLowerCase().replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.csv';
      String filePath = '${directory.path}/$fileName';

      File file = File(filePath);
      await file.writeAsString(csv);

      return filePath;
    } catch (e) {
      debugPrint('Error exporting revenue report: $e');
      throw Exception('Failed to export report: $e');
    }
  }

  // Sample data generation
  static Future<void> _addSampleDataIfNeeded() async {
    try {
      final orderBox = Hive.box<Order>(_orderBoxName);
      final customerBox = Hive.box<Customer>(_customerBoxName);
      final productBox = Hive.box<Product>(_productBoxName);

      // Add sample customers if empty
      if (customerBox.isEmpty) {
        await _addSampleCustomers();
      }

      // Add sample products if empty
      if (productBox.isEmpty) {
        await _addSampleProducts();
      }

      // Add sample orders if empty
      if (orderBox.isEmpty) {
        await addSampleOrders();
      }
    } catch (e) {
      debugPrint('Error adding sample data: $e');
    }
  }

  static Future<void> _addSampleCustomers() async {
    final box = Hive.box<Customer>(_customerBoxName);
    final customerNames = [
      'Ahmed Ali',
      'Fatima Khan',
      'Muhammad Hassan',
      'Ayesha Ahmed',
      'Omar Malik',
      'Sana Sheikh',
      'Ali Raza',
      'Zara Hussain',
      'Tariq Mahmood',
      'Hina Butt',
      'Kashif Iqbal',
      'Mariam Qureshi',
      'Usman Dar',
      'Rabia Nawaz',
      'Bilal Shah',
      'Sidra Aslam',
      'Fahad Khan',
      'Nadia Mirza',
      'Hamza Cheema',
      'Sadia Malik',
    ];

    for (int i = 0; i < customerNames.length; i++) {
      final customer = Customer(
        id: 'customer_$i',
        name: customerNames[i],
        email:
            '${customerNames[i].toLowerCase().replaceAll(' ', '.')}@email.com',
        phone: '+92300${1000000 + i}',
        group: 'general',
        createdAt: DateTime.now().subtract(
          Duration(days: Random().nextInt(365)),
        ),
      );
      await box.put(customer.id, customer);
    }
  }

  static Future<void> _addSampleProducts() async {
    final box = Hive.box<Product>(_productBoxName);
    final productNames = [
      'Laptop Dell XPS',
      'iPhone 14 Pro',
      'Samsung Galaxy S23',
      'MacBook Air M2',
      'iPad Pro',
      'Sony Headphones',
      'Nike Running Shoes',
      'Adidas T-Shirt',
      'Canon Camera',
      'HP Printer',
      'Office Chair',
      'Gaming Keyboard',
      'Wireless Mouse',
      'Monitor 24"',
      'USB Cable',
      'Power Bank',
      'Bluetooth Speaker',
      'Smart Watch',
      'Tablet Android',
      'Laptop Bag',
    ];

    for (int i = 0; i < productNames.length; i++) {
      final product = Product(
        id: 'product_$i',
        name: productNames[i],
        sku: 'SKU${1000 + i}',
        sellingPrice: (Random().nextDouble() * 50000) + 1000, // 1000-51000 PKR
        purchasePrice:
            ((Random().nextDouble() * 0.5) + 0.5) *
            ((Random().nextDouble() * 50000) + 1000), // <-- added
        stockQuantity: Random().nextInt(100) + 5, // 5-105 units
        unit: ['pcs', 'box', 'pair', 'kg'][Random().nextInt(4)], // <-- added
        category:
            ['Electronics', 'Clothing', 'Accessories', 'Office'][Random()
                .nextInt(4)],
        description: 'High quality ${productNames[i]}',
        expiryDate: DateTime.now().subtract(
          Duration(days: Random().nextInt(180)),
        ),
      );
      await box.put(product.id, product);
    }
  }

  static Future<void> addSampleOrders() async {
    final box = Hive.box<Order>(_orderBoxName);
    if (box.isNotEmpty) return;

    final random = Random();
    final now = DateTime.now();

    // Generate more realistic transaction patterns
    for (int i = 0; i < 60; i++) {
      // 60 days of data
      final date = now.subtract(Duration(days: i));

      // Weekend vs weekday logic
      final isWeekend =
          date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
      final baseTransactionCount =
          isWeekend ? 3 : 8; // Fewer transactions on weekends
      final transactionCount = random.nextInt(baseTransactionCount) + 2;

      for (int j = 0; j < transactionCount; j++) {
        // Business hours logic
        final hour =
            isWeekend
                ? random.nextInt(8) + 10
                : // 10 AM - 6 PM on weekends
                random.nextInt(10) + 8; // 8 AM - 6 PM on weekdays

        final transactionTime = DateTime(
          date.year,
          date.month,
          date.day,
          hour,
          random.nextInt(60),
        );

        final items = <Map<String, dynamic>>[];
        final itemCount = random.nextInt(3) + 1; // 1-3 items per transaction
        double totalAmount = 0;

        for (int k = 0; k < itemCount; k++) {
          final productIndex = random.nextInt(20);
          final quantity = random.nextInt(3) + 1; // 1-3 quantity
          final unitPrice =
              (random.nextDouble() * 20000) + 500; // 500-20500 PKR
          final totalPrice = quantity * unitPrice;
          totalAmount += totalPrice;

          final product = Product(
            id: 'product_$productIndex',
            name: 'Product $productIndex',
            sku: 'SKU$productIndex',
            sellingPrice: unitPrice,
            purchasePrice: unitPrice * 0.8,
            stockQuantity: 100,
            unit: 'pcs',
            category: 'Electronics',
            description: '',
            expiryDate: DateTime.now(),
          );

          items.add({'product': product, 'quantity': quantity});
        }

        final order = Order(
          id: Ulid().toString(),
          customerName: 'Customer ${random.nextInt(20)}',
          products: items,
          total: totalAmount,
          date: transactionTime,
          templateId: random.nextInt(4),
          status: random.nextInt(100) < 95 ? 'completed' : 'refunded',
        );

        await box.put(order.id, order);
      }
    }
  }

  // Transaction management methods
  static Future<void> addOrder(Order order) async {
    try {
      final box = Hive.box<Order>(_orderBoxName);
      await box.put(order.id, order);
    } catch (e) {
      debugPrint('Error adding order: $e');
      throw Exception('Failed to add order: $e');
    }
  }

  static Future<List<Order>> getAllOrders() async {
    try {
      final box = Hive.box<Order>(_orderBoxName);
      return box.values.toList();
    } catch (e) {
      debugPrint('Error getting all orders: $e');
      return [];
    }
  }

  static Future<void> deleteOrder(String id) async {
    try {
      final box = Hive.box<Order>(_orderBoxName);
      await box.delete(id);
    } catch (e) {
      debugPrint('Error deleting order: $e');
      throw Exception('Failed to delete order: $e');
    }
  }

  static Future<void> updateOrderStatus(String id, String status) async {
    try {
      final box = Hive.box<Order>(_orderBoxName);
      final order = box.get(id);
      if (order != null) {
        final updatedOrder = Order(
          id: order.id,
          customerName: order.customerName,
          products: order.products,
          total: order.total,
          date: order.date,
          templateId: order.templateId,
          status: status,
        );
        await box.put(id, updatedOrder);
      }
    } catch (e) {
      debugPrint('Error updating order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }
}
